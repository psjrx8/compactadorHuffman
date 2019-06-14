%include "lib/asm_io.inc"

segment .data

  alfabeto   times 128 dd 0
  frequencia times 128 dd 0

  codigo     times 128 dd 0
  correlato  times 128 dd 0

  buflen dd 2048

  arquivoOriginal   db "texto.txt", 0
  arquivoCompactado db "texto.huf", 0
  text db "This is the content of my file. The zero after this string indicates the end of file, ok?!", 0
  textlen equ $ - text

  debug_msg1 db "===== DEBUG ====", 0
  debug_msg2 db "AQUI",10, 0
  debug_msg3 db "Memory: ", 0

  msgDireita  db "Nó direita", 0
  msgEsquerda db "Nó esquerda", 0
  msgFlag     db "Aqui!!", 0

segment .bss

  menor  resd 1
  maior  resd 1

  buffer resb 2048

  tree        resd 1

  nos         resd 128 ;ultimo nó para ordenação
  numNos      resd 1
  pesoNo      resd 1
  noDireito   resd 1
  noEsquerdo  resd 1
  raiz        resb 1
  indice      resb 1

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
    push arquivoOriginal
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

    mov ecx, 0
    mov edx, [raiz]
    mov ebx, 0
    push ebx
    push edx
      call funcCodificaAlfabeto
    add esp, 8

    ; call funcImprimirCodigo

    ; push arquivoCompactado
    ; push text
    ; push dword textlen
    ; call write_file
    ; add esp, 12

sair:
    call print_nl

    leave
    ret
