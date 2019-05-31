%include "lib/asm_io.inc"

segment .data

  alfabeto   times 128 dd 0
  frequencia times 128 dd 0

  filename db "original.txt", 0
  buflen dd 2048

  debug_msg1 db "===== DEBUG ====", 0
  debug_msg2 db "AQUI",10, 0
  debug_msg3 db "Memory: ", 0

segment .bss

  menor  resd 1
  maior  resd 1

  buffer resb 2048

  tree   resd 1
  nos    resd 129 ;ultimo nó para ordenação
  numNos resb 1

segment .text

%include "src/alfabeto.asm"
%include "src/read_write_file.asm"
%include "src/binary_search_tree.asm"

        global  asm_main
asm_main:

    mov ecx, 128                ;Determina range do loop (127 iterações)
    mov ebx, 0                  ;Define valor inicial do índice do array

preencherAlfabeto:
    mov [alfabeto + ebx], ebx   ;Atribui ao array o valor do índice
    add ebx, 4                  ;Incrementa registrador do índice
    loop preencherAlfabeto

    ;Empilha ecx e ebx para impedir alteração na função
    push ecx
    push ebx
      call funcExibirAlfabeto   ;Função para imprimir alfabeto
    ;Desempilha ebx e ecx respectivamente
    pop ebx
    pop ecx

    call print_nl

    ;Lê arquivo e preenche as variáveis de buffer
    push filename
    push buffer
    push buflen
      call read_file
    add esp, 12

    ;Imprime conteúdo do buffeer e conta frequencia de caracteres
    mov esi, buffer
    cld
    print:
    lodsb                 ;al=[esi] e esi+=1
        cmp al, 0         ;Verifica final do arquivo
        je exit           ;Pula se igual
        movzx eax, al     ;Estende o registrador al para eax
        call print_char   ;Imprime o caractere em eax
        imul eax, 4       ;Multiplica o caractere para encontrar posição no array de frequencia
        add dword [frequencia + eax], 1 ;Incrementa array de frequencia na posição do caractere
    jmp print
    exit:

    ;Empilha ecx e ebx para impedir alteração na função
    push ecx
    push ebx
      call funcExibirFrequencia
    ;Desempilha ebx e ecx respectivamente
    pop ebx
    pop ecx

    ;Ordenação do array de frquencia
    mov ecx, 127
    mov ebx, 0
    ;Dois LOOPS aninhados para ordernar o array de forma decrescente
    ;Ex.: [1],[5],[3],[2],[4]
    ;Loop INTERNO 1: [5],[1],[3],[2],[4]
    ;Loop INTERNO n: [5],[3],[2],[4],[1]
    ;Loop EXTERNO n: [5],[4],[3],[2],[1]
ordernarAlfabeto:                   ;Algorítmo de ordenação BubbleSort
    push ecx                        ;Empilha ecx para evitar alteração no LOOP INTERNO
    push ebx                        ;Empilha ebx para evitar alteração no LOOP INTERNO
    subOrdenarAlfabeto:             ;Início do loop interno
      mov eax, [frequencia + ebx]   ;Armazena "posição atual"
      add ebx, 4                    ;Incrementa índice
      mov edx, [frequencia + ebx]   ;Armazena "posição seguinte"
      cmp eax, edx                  ;Compara "posição atual" e "posição seguinte"
      jle  sairSubOrdenarAlfabeto   ;Se "posição atual" > "posição seguinte" NOP (No operation)
                                    ;else
      push ecx                      ;Empilha ecx para evitar alteração na FUNÇÃO interna
      push ebx                      ;Empilha ebx para evitar alteração na FUNÇÃO interna
        call funcBubbleAlfabeto     ;Função para trocar valores das "posição atual" e "posição seguinte"
      pop ebx                       ;Desempilha ebx para LOOP INTERNO
      pop ecx                       ;Desempilha ecx para LOOP INTERNO
      sairSubOrdenarAlfabeto:
      loop subOrdenarAlfabeto
    pop ebx                         ;Desempilha ebx para LOOP EXTERNO
    pop ecx                         ;Desempilha ecx para LOOP EXTERNO
    loop ordernarAlfabeto

    ;Empilha ecx e ebx para impedir alteração na função
    push ecx
    push ebx
      call funcExibirFrequencia
    ;Desempilha ebx e ecx respectivamente
    pop ebx
    pop ecx

    ;Empilha ecx e ebx para impedir alteração na função
    push ecx
    push ebx
      call funcExibirAlfabeto
    ;Desempilha ebx e ecx respectivamente
    pop ebx
    pop ecx

    call print_nl

    mov byte [numNos], 0

    mov ecx, 128
    mov ebx, 0
criarVetorNos:
    mov eax, [frequencia + ebx]
    cmp eax, 0
    je  sairCriarVetorNos

    call create_node

    mov edx, dword [alfabeto + ebx]
    mov [eax],     edx   ;Caractere  4 bytes
    mov dl, byte [frequencia + ebx]
    mov [eax - 1], dl    ;Frequencia 1 byte

    mov edx, 0
    mov [eax -5], ecx    ;Ponteiro direito  [menor frequencia]
    mov [eax -9], ecx    ;Ponteiro esquerdo [maior frequencia]

    mov edx, [numNos]
    mov [nos + edx], eax
    add byte [numNos], 1

    sairCriarVetorNos:
    add ebx, 4
    loop criarVetorNos

;     mov ecx, [numNos]
;     mov ebx, 0
; ordenarNos:
;     push ecx
;     push ebx
;     subOrdenarNos:
;       mov eax, [nos + ebx]
;       add ebx, 4
;       mov edx, [nos + ebx]
;       cmp eax, edx
;       jle  sairSubOrdenarNos
;
;       push ecx
;       push ebx
;         call funcBubbleNos
;       pop ebx
;       pop ecx
;       sairSubOrdenarNos:
;       loop subOrdenarNos
;     pop ebx
;     pop ecx
;     loop ordenarNos
;
;     jmp sair
;
;     funcBubbleNos:
;     push ebp
;     mov ebp, esp
;
;       sub ebx, 4                    ;Aponta para "posição atual"
;       mov [nos + ebx], edx   ;Atribui VALOR MENOR
;
;       add ebx, 4                    ;Aponta para "posição seguinte"
;       mov [nos + ebx], eax   ;Atribui VALOR MAIOR
;
;       call print_int
;       mov eax, ' '
;       call print_char
;       mov eax, edx
;       call print_int
;
;     pop ebp
;     ret

sair:

    leave
    ret
