;Cria os nós e o vetor de nós folha da arvore
funcCriarVetorNosFolha:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax
    mov dword [numNos], 0                   ;Inicializa contador de nós

    mov ecx, 128                      ;Tamanho do loop
    mov ebx, 0
    criarVetorNosFolha:
        mov eax, [frequencia + ebx]
        cmp eax, 0                    ;Verifica incidencia do caractere no texto
        je  sairCriarVetorNosFolha

        ;Nó com 16 bytes
        ;4 bytes [*Esquerda] + 4 bytes [*Direita] + 4 bytes [Frequencia] + 4 byte [Char]
        call create_node

        mov edx, [alfabeto + ebx]         ;Caractere  4 bytes
        mov [eax], edx

        mov edx, dword [frequencia + ebx] ;Frequencia 4 bytes
        mov [eax - 4], edx

        mov edx, 0
        mov [eax -8], edx                ;Ponteiro direito  [menor frequencia]
        mov [eax -12], edx               ;Ponteiro esquerdo [maior frequencia]

        ; call print_int
        ; call print_nl

        call funcIncluirVetorNo

        sairCriarVetorNosFolha:
        add ebx, 4
        loop criarVetorNosFolha
  pop eax
  pop ebx
  pop ecx
  pop edx
pop ebp
ret

funcIncluirVetorNo:
push ebp
mov ebp, esp
  push edx

    push eax
      mov edx, 4
      mov eax, [numNos]   ;eax = numero de nós
      imul edx            ;eax = eax * 4 (doubleword)
      mov edx, eax        ;edx = eax (indice do array de nós)
    pop eax

    push ebx
    push eax
      mov ebx, eax          ;ebx = eax (endereço do nó)
      mov [nos + edx], ebx  ;Preenche array de nós (com endereços)
    pop eax
    pop ebx

    add dword [numNos], 1    ;Incrementa contador de nós

  pop edx
pop ebp
ret


;funcImprimirNos()
;Imprime todos os nós do vetor
funcImprimirNos:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax

  call print_nl

  ;Imprime número de nós
  mov eax, [numNos]
  call print_int
  call print_nl

  mov ecx, [numNos]           ;Tamanho do loop (número de nós)
  mov ebx, 0
  imprimeNo:
    push ecx
    push ebx

      mov eax, [nos + ebx]
      ;mov eax, [ebx]          ;eax aponta para o nó

      call funcImprimirNo

    pop ebx
    pop ecx

    add ebx, 4
    loop imprimeNo

  pop eax
  pop ebx
  pop ecx
  pop edx
pop ebp
ret

;Imprime o nó posicionado em eax
;funcImprimirNo()
funcImprimirNo:
push ebp
mov ebp, esp
  push edx
  push ebx
  push eax

    call print_nl

    ;Imprime letra
    mov edx, [eax]            ;edx aponta para o nó
    push edx
      call funcImprimirLetra
    pop edx

    ;Imprime frequencia
    push eax
      mov edx, [eax - 4]
      mov eax, edx
        call print_int
        call funcImprimirSeparador
    pop eax

    ;Imprime nó direito (menor frequencia)
    push eax
      mov edx, [eax - 8]
      mov eax, edx
        call print_int
        call funcImprimirSeparador
    pop eax

    ;Imrpime nó esquerdo [maior frequencia]
    push eax
      mov edx, [eax - 12]
      mov eax, edx
        call print_int
        call funcImprimirSeparador
    pop eax

    call print_nl

  pop eax
  pop ebx
  pop edx
pop ebp
ret

funcCriarNoComposto:
push ebp
mov ebp, esp
  push ecx
  push edx
  push ebx

    mov ebx, 0
    mov dword [pesoNo], 0

    mov edx, [nos + ebx]  ;Caractere  4 bytes
    mov [noDireito], edx
    mov eax, [edx - 4]
    add [pesoNo], eax

    add ebx, 4
    mov edx, [nos + ebx]  ;Caractere  4 bytes
    mov [noEsquerdo], edx
    mov eax, [edx - 4]
    add [pesoNo], eax

    call create_node

    mov edx, 129           ;Caractere  4 bytes
    mov [eax], edx

    mov edx, [pesoNo]     ;Frequencia 4 bytes
    mov [eax - 4], edx

    mov edx, [noDireito]
    mov [eax -8], edx     ;Ponteiro direito  [menor frequencia]
    mov edx, [noEsquerdo]
    mov [eax -12], edx    ;Ponteiro esquerdo [maior frequencia]

    ; call funcImprimirNo

    call funcDesempilhaNos

  pop ebx
  pop edx
  pop ecx
pop ebp
ret

funcDesempilhaNos:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax
    mov ecx, 2
    desempilhaNos:
      push ecx
        mov ecx, [numNos]
        sub ecx, 1
        mov ebx, 4
        subDesempilhaNos:
          mov eax, [nos + ebx]
          sub ebx, 4
          mov [nos + ebx], eax
          add ebx, 8
        loop subDesempilhaNos
      pop ecx
    loop desempilhaNos
    sub dword [numNos], 2
  pop eax
  pop ebx
  pop ecx
pop ebp
ret

funcOrdenarVetorNos:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax

    mov ecx, [numNos]                      ;Tamanho do loop
    sub ecx, 1
    ordenarVetorNos:
      push ecx
        mov ebx, 0
        subOrdenarVetorNos:
          push ecx
            mov eax, [nos + ebx]
            mov ecx, [eax - 4]

            ; push eax
            ;   mov eax, [eax - 4]
            ;   call print_int
            ;   call funcImprimirSeparador
            ; pop eax

            add ebx, 4
            mov eax, [nos + ebx]
            mov edx, [eax - 4]

            ; push eax
            ;   mov eax, [eax - 4]
            ;   call print_int
            ;   call funcImprimirSeparador
            ; pop eax

            cmp ecx, edx
            jle  sairSubOrdenarVetorNos   ;Se "posição atual" > "posição seguinte" NOP (No operation)

            call funcBubbleNos            ;Função para trocar valores das "posição atual" e "posição seguinte"

            sairSubOrdenarVetorNos:
          pop ecx
         loop subOrdenarVetorNos

      pop ecx
    loop ordenarVetorNos
  pop eax
  pop ebx
  pop ecx
  pop edx
pop ebp
ret

funcBubbleNos:
push ebp
mov ebp, esp
  push edx
  push eax

    mov eax, [nos + ebx]

    sub ebx, 4
    mov edx, [nos + ebx]

    mov [nos + ebx], eax

    add ebx, 4
    mov [nos + ebx], edx

  pop eax
  pop edx
pop ebp
ret

funcCodificaAlfabeto:
push ebp
mov ebp, esp
  testaNoEsquerdo:
    mov eax, [ebp + 8]
    mov eax, [eax - 12]
    ; push eax
    ;   call print_int
    ;   call funcImprimirSeparador
    ;   mov eax, msgEsquerda
    ;   call print_string
    ;   call print_nl
    ; pop eax
    cmp eax, 0
    je  testaNoDireito

    mov ebx, [ebp + 12]
    shl ebx, 1
    add ebx, 1
    push ebx
    push eax
      call funcCodificaAlfabeto
    add esp, 8

    testaNoDireito:
      mov eax, [ebp + 8]
      mov eax, [eax - 8]
      ; push eax
      ;   call print_int
      ;   call funcImprimirSeparador
      ;   mov eax, msgDireita
      ;   call print_string
      ;   call print_nl
      ; pop eax
      cmp eax, 0
      je  codifica

      mov ebx, [ebp + 12]
      shl ebx, 1
      push ebx
      push eax
        call funcCodificaAlfabeto
      add esp, 8

    jmp retorno

    codifica:
      mov eax, [ebp + 12]
      mov [codigo + ecx], eax
      ; push eax
      ;   mov eax, [codigo + ecx]
      ;   call print_int
      ;   call funcImprimirSeparador
      ; pop eax

      mov eax, [ebp + 8]    ;*Arvore
      mov eax, [eax]
      mov [correlato + ecx], eax
      ; push eax
      ;   call funcImprimirLetra
      ;   call funcImprimirSeparador
      ; pop eax

      add ecx, 4
    retorno:
pop ebp
ret

funcImprimirCodigo:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax
    mov ecx, 128
    mov ebx, 0
    imprimirCodigo:
      mov eax, [codigo + ebx]
      cmp eax, 0
      je sairImprimirCodigo
      call print_int
      call funcImprimirSeparador
      mov eax, [correlato + ebx]
      push eax
        call funcImprimirLetra
        call print_nl
      pop eax
      sairImprimirCodigo:
      add ebx, 4
    loop imprimirCodigo
  pop eax
  pop ebx
  pop ecx
pop ebp
ret
