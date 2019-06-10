;Cria os nós e o vetor de nós da arvore
funcCriarVetorNos:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax
    mov byte [numNos], 0              ;Inicializa contador de nós

    mov ecx, 128                      ;Tamanho do loop
    mov ebx, 0
    criarVetorNos:
        mov eax, [frequencia + ebx]
        cmp eax, 0                    ;Verifica incidencia do caractere no texto
        je  sairCriarVetorNos

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

        add byte [numNos], 1    ;Incrementa contador de nós

        sairCriarVetorNos:
        add ebx, 4
        loop criarVetorNos
  pop eax
  pop ebx
  pop ecx
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

      mov ebx, [nos + ebx]    ;ebx = [endereço do nó]
      mov eax, [ebx]          ;eax aponta para o nó

      ;Imprime letra
      push eax
        call funcImprimirLetra
      pop eax

      ;Imprime frequencia
      push edx
      push eax
        mov edx, [ebx - 4]
        mov eax, edx
        call print_int
        call funcImprimirSeparador
      pop eax
      pop edx

      ;Imprime no direito [menor frequencia]
      push edx
      push eax
        mov edx, [ebx - 8]
        mov eax, edx
        call print_int
        call funcImprimirSeparador
      pop eax
      pop edx

      ;Imprime no esquerdo [maior frequencia]
      push edx
      push eax
        mov edx, [ebx - 12]
        mov eax, edx
        call print_int
        call funcImprimirSeparador
      pop eax
      pop edx

      call print_nl

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
  push edx
  push ebx

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

  pop ebx
  pop edx
pop ebp
ret
