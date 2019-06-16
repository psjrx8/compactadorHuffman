funcFlag:
push ebp
mov ebp, esp
  push eax
    mov eax, msgFlag
    call print_string
    call print_nl
  pop eax
pop ebp
ret

;funcExibirAlfabeto()
funcCriarAlfabeto:
push ebp
mov ebp, esp
  push ecx
  push ebx

  mov ecx, 128                ;Determina range do loop (127 iterações)
  mov ebx, 0                  ;Define valor inicial do índice do array
  preencherAlfabeto:
  mov [alfabeto + ebx], ebx   ;Atribui ao array o valor do índice
  add ebx, 4                  ;Incrementa registrador do índice
  loop preencherAlfabeto

  pop ebx
  pop ecx
pop ebp
ret

;funcExibirAlfabeto()
funcExibirAlfabeto:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax

  call print_nl
  mov ecx, 128
  mov ebx, 0                      ;i = 0
  exibirAlfabeto:
      mov eax, [alfabeto + ebx]   ;eax = alfabeto[i]
      add ebx, 4                 ;i++

      push eax
        call funcImprimirLetra
      pop eax

      loop exibirAlfabeto
  call print_nl

  pop eax
  pop ebx
  pop ecx
pop ebp
ret

;funcImprimirLetra(int letra)
funcImprimirLetra:
push ebp
mov ebp, esp
    push eax
    push ebx
    push eax

    mov eax, [ebp + 8]  ;eax = alfabeto[i]
    mov ebx, 4
    cdq
    div ebx
    call print_char

    push eax
      call funcImprimirSeparador
    pop eax

    pop eax
    pop ebx
    pop eax
pop ebp
ret

;funcExibirFrequencia()
funcExibirFrequencia:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax

  call print_nl
  mov ecx, 128
  mov ebx, 0                        ;i = 0
  exibirFrequencia:
      mov eax, [frequencia + ebx]   ;eax = frequencia[1]
      add ebx, 4                    ;i++
      call print_int                ;Imprime frequencia

      push eax
        call funcImprimirSeparador
      pop eax

      loop exibirFrequencia
  call print_nl

  pop eax
  pop ebx
  pop ecx
pop ebp
ret

;funcOrdenarAlfabeto()
;Tem por objetivo ordernar o vetor Alfabeto com base no valor da frequencia
funcOrdenarAlfabeto:
push ebp
mov ebp, esp
    push edx
    push ecx
    push ebx
    push eax

    ;Ordenação do array de frquencia
    mov ecx, 127
    mov ebx, 0
    ;Dois LOOPS aninhados para ordernar o array de forma crescente
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
          call funcBubbleAlfabeto       ;Função para trocar valores das "posição atual" e "posição seguinte"

          sairSubOrdenarAlfabeto:
          loop subOrdenarAlfabeto
        pop ebx                         ;Desempilha ebx para LOOP EXTERNO
        pop ecx                         ;Desempilha ecx para LOOP EXTERNO
        loop ordernarAlfabeto


  pop eax
  pop ebx
  pop ecx
  pop edx
pop ebp
ret

;funcImprimirSeparador()
funcImprimirSeparador:
push ebp
mov ebp, esp
    push eax
      mov eax, ' '
      call print_char     ;Imprime separador
    pop eax
pop ebp
ret

;Se "posição atual" < "posição seguinte"
;Registrador ebx (índice) apontando para "posição seguinte"
;Registrador eax contém VALOR MAIOR
;Registrador edx contém VALOR MENOR
funcBubbleAlfabeto:
push ebp
mov ebp, esp
  push edx
  push eax

  sub ebx, 4                    ;Aponta para "posição atual"
  mov [frequencia + ebx], edx   ;Atribui VALOR MENOR

  add ebx, 4                    ;Aponta para "posição seguinte"
  mov [frequencia + ebx], eax   ;Atribui VALOR MAIOR

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

  pop eax
  pop edx
pop ebp
ret

;Função para imprimir código binário do registrador
;funcImprimirBinario(*registrador)
funcImprimirBinario:
push ebp
mov ebp, esp
  push ecx
  push eax
    mov ecx, 32
    mov eax, [ebp + 8]
    imprimirBinario:
      shl eax, 1
      jc um
      push eax
        mov eax, 48
        call print_char
      pop eax

      jmp sairImprimirBinario
      um:
      push eax
        mov eax, 49
        call print_char
      pop eax

      sairImprimirBinario:
    loop imprimirBinario

  pop eax
  pop ecx
pop ebp
ret
