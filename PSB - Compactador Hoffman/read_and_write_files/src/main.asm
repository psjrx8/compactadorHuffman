%include "lib/asm_io.inc"

segment .data

  filename db "test.txt", 0
  buflen dd 2048
  alfabeto   times 128 dd 0
  frequencia times 128 dd 0

segment .bss

   buffer resb 2048
   menor  resd 1
   maior  resd 1

segment .text

%include "src/read_write_file.asm"

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
ordernarVetor:                      ;Algorítmo de ordenação BubbleSort
    push ecx                        ;Empilha ecx para evitar alteração no LOOP INTERNO
    push ebx                        ;Empilha ebx para evitar alteração no LOOP INTERNO
    subOrdenarVetor:                ;Início do loop interno
      mov eax, [frequencia + ebx]   ;Armazena "posição atual"
      add ebx, 4                    ;Incrementa índice
      mov edx, [frequencia + ebx]   ;Armazena "posição seguinte"
      cmp eax, edx                  ;Compara "posição atual" e "posição seguinte"
      jge  continuar                ;Se "posição atual" > "posição seguinte" NOP (No operation)
                                    ;else
      push ecx                      ;Empilha ecx para evitar alteração na FUNÇÃO interna
      push ebx                      ;Empilha ebx para evitar alteração na FUNÇÃO interna
        call funcBubble             ;Função para trocar valores das "posição atual" e "posição seguinte"
      pop ebx                       ;Desempilha ebx para LOOP INTERNO
      pop ecx                       ;Desempilha ecx para LOOP INTERNO
      continuar:
      loop subOrdenarVetor
    pop ebx                         ;Desempilha ebx para LOOP EXTERNO
    pop ecx                         ;Desempilha ecx para LOOP EXTERNO
    loop ordernarVetor

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

    jmp sair

    ;Função exibir frequencia
funcExibirFrequencia:
    push ebp
    mov ebp, esp
      call print_nl
      mov ecx, 128
      mov ebx, 0                        ;i = 0
      exibirFrequencia:
          mov eax, [frequencia + ebx]   ;eax = frequencia[1]
          add ebx, 4                    ;i++
          call print_int                ;Imprime frequencia
          mov eax, ' '
          call print_char               ;Imprime separador
          loop exibirFrequencia
      call print_nl
    pop ebp
    ret

funcExibirAlfabeto:
    push ebp
    mov ebp, esp
      call print_nl
      mov ecx, 128
      mov ebx, 0                      ;i = 0
      exibirAlfabeto:
          mov eax, [alfabeto + ebx]   ;eax = alfabeto[i]
          add ebx, 4                  ;i++
          call print_int
          mov eax, ' '
          call print_char             ;Imprime separador
          loop exibirAlfabeto
      call print_nl
    pop ebp
    ret

    ;Se "posição atual" > "posição seguinte"
    ;Registrador ebx (índice) apontando para "posição seguinte"
    ;Registrador eax contém VALOR MAIOR
    ;Registrador edx contém VALOR MENOR
funcBubble:
    push ebp
    mov ebp, esp

      sub ebx, 4                    ;Aponta para "posição atual"
      mov [frequencia + ebx], edx   ;Atribui VALOR MAIOR

      add ebx, 4                    ;Aponta para "posição seguinte"
      mov [frequencia + ebx], eax   ;Atribui VALOR MENOR

      mov eax, [alfabeto + ebx]     ;eax = alfabeto[posição seguinte]
      mov [maior], eax              ;maior = eax

      sub ebx, 4                    ;Aponta para "posição atual"
      mov eax, [alfabeto + ebx]     ;eax = alfabeto[posição atual]
      mov [menor], eax              ;menor = eax

      mov eax, [maior]              ;eax = maior
      mov [alfabeto + ebx], eax     ;alfabeto[posição atual] = maior

      add ebx, 4                    ;Aponta para "posição seguinte"
      mov eax, [menor]              ;eax = menor
      mov [alfabeto + ebx], eax     ;alfabeto[posição seguinte] = menor

    pop ebp
    ret

sair:

    leave
    ret
