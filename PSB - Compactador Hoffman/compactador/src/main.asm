%include "lib/asm_io.inc"

segment .data

  alfabeto   times 128 dd 0
  frequencia times 128 dd 0

  filename db "original.txt", 0
  buflen dd 2048

  debug_msg1 db "===== DEBUG ====", 0
  debug_msg2 db "AQUI",10, 0
  debug_msg3 db "Memory: ", 0

  codigo     times 128 db 0
  correlato  times 128 db 0

segment .bss

  menor  resd 1
  maior  resd 1

  buffer resb 2048

  tree        resd 1

  nos         resd 128 ;ultimo nó para ordenação
  numNos      resd 1
  pesoNo      resd 1
  noDireito   resb 1
  noEsquerdo  resb 1
  raiz        resb 1

segment .text

%include "src/alfabeto.asm"
%include "src/arvore.asm"
%include "src/read_write_file.asm"
%include "src/binary_search_tree.asm"

        global  asm_main
asm_main:

    call funcCriarAlfabeto   ;Função para imprimir alfabeto
    ;call funcExibirAlfabeto   ;Função para imprimir alfabeto

    ;Lê arquivo e preenche as variáveis de buffer
    push filename
    push buffer
    push buflen
      call read_file
    add esp, 12

    ;call print_nl

    ;Imprime conteúdo do buffeer e conta frequencia de caracteres
    mov esi, buffer
    cld
    printArquivoTexto:
    lodsb                         ;al=[esi] e esi+=1
      cmp al, 0                 ;Verifica final do arquivo
      je sairPrintArquivoTexto  ;Pula se igual
      movzx eax, al             ;Estende o registrador al para eax
      call print_char           ;Imprime o caractere em eax
      imul eax, 4               ;Multiplica o caractere para encontrar posição no array de frequencia
      add dword [frequencia + eax], 1 ;Incrementa array de frequencia na posição do caractere
    jmp printArquivoTexto
    sairPrintArquivoTexto:

    ;call funcExibirFrequencia

    call funcOrdenarAlfabeto
    ;call funcExibirFrequencia
    ;call funcExibirAlfabeto

    mov dword [numNos], 0  ;Inicializa contador de nós

    call funcCriarVetorNosFolha
    ;call funcImprimirNos

    ;call print_nl

    mov edx, [numNos]
    cmp edx, 2
    je montaUltimoNo
    montarArvore:

      call funcCriarNoComposto
      call funcIncluirVetorNo
      call funcOrdenarVetorNos
      ;call funcImprimirNos

      mov edx, [numNos]
      cmp edx, 2
      jg montarArvore

    montaUltimoNo:
      call funcCriarNoComposto
      ;call funcImprimirNo
      mov [raiz], eax

      ; mov eax, [raiz]
      ; call print_int

sair:
    call print_nl

    leave
    ret
