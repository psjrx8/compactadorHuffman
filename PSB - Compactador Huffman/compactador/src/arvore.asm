;Cria os nós e o vetor de nós folha da arvore
funcCriarVetorNosFolha:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax
    mov dword [numNos], 0             ;Inicializa contador de nós

    mov ecx, 128                      ;Tamanho do loop
    mov ebx, 0
    criarVetorNosFolha:
        mov eax, [frequencia + ebx]
        cmp eax, 0                    ;Verifica incidencia do caractere no texto
        je  sairCriarVetorNosFolha

        ;Nó com 16 bytes
        ;4 bytes [*Esquerda] + 4 bytes [*Direita] + 4 bytes [Frequencia] + 4 byte [Char]
        call create_node

        mov edx, [alfabeto + ebx]     ;Caractere  4 bytes
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

;Cria nó composto com os 2 primeiros registros do vetor nos
;funcCriarNoComposto()
funcCriarNoComposto:
push ebp
mov ebp, esp
  push ecx
  push edx
  push ebx

    mov ebx, 0
    mov dword [pesoNo], 0   ; Zera peso do nó

    ; Atribui o primeiro item do vetor ao registrador edx
    mov edx, [nos + ebx]
    mov [noDireito], edx
    mov eax, [edx - 4]
    add [pesoNo], eax       ; Acrescenta frequencia ao peso do nó

    ; Atribui o segundo item do vetor ao registrador edx
    add ebx, 4
    mov edx, [nos + ebx]
    mov [noEsquerdo], edx
    mov eax, [edx - 4]
    add [pesoNo], eax       ; Acrescenta frequencia ao peso do nó

    call create_node        ; Cria nó

    mov edx, 129            ; Atribui caractere 129 ao nó (Não compõe alfabeto)
    mov [eax], edx

    mov edx, [pesoNo]       ; Atribui a frequencia do nó [peso]
    mov [eax - 4], edx

    mov edx, [noDireito]
    mov [eax -8], edx       ;Ponteiro direito  [menor frequencia]
    mov edx, [noEsquerdo]
    mov [eax -12], edx      ;Ponteiro esquerdo [maior frequencia]

    ; call funcImprimirNo

    call funcDesempilhaNos  ; Retira os dois nós do vetor

  pop ebx
  pop edx
  pop ecx
pop ebp
ret

; Função para retirar do vetor os 2 nós que compõe o nó composto
;funcDesempilhaNos()
funcDesempilhaNos:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax
    mov ecx, 2                    ; Número de loops
    desempilhaNos:
      push ecx
        mov ecx, [numNos]         ; Número do loops
        sub ecx, 1
        mov ebx, 4
        subDesempilhaNos:         ; [nos + n] = [nos + n + 1]
          mov eax, [nos + ebx]
          sub ebx, 4
          mov [nos + ebx], eax
          add ebx, 8
        loop subDesempilhaNos
      pop ecx
    loop desempilhaNos
    sub dword [numNos], 2         ; Subtrai os nós do vetor
  pop eax
  pop ebx
  pop ecx
pop ebp
ret

;Ordena os nós no vetor de nós
;funcOrdenarVetorNos()
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
            mov ecx, [eax - 4]        ; Atribui frequencia do primeiro nó a ecx

            ; push eax
            ;   mov eax, [eax - 4]
            ;   call print_int
            ;   call funcImprimirSeparador
            ; pop eax

            add ebx, 4
            mov eax, [nos + ebx]
            mov edx, [eax - 4]        ; Atribui frequencia do segundo nó a edx

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

;Se "posição atual" < "posição seguinte"
;Registrador ebx (índice) apontando para "posição seguinte"
;Registrador eax contém VALOR MAIOR
;Registrador edx contém VALOR MENOR
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

;Função que atribui valor às posições da arvore
;Obs.: Registrador ecx e edx precisa ser igual a 0
;funcCodificaAlfabeto(*Arvore, int codigo)
funcCodificaAlfabeto:
push ebp
mov ebp, esp

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
      je  testaNoEsquerdo

      mov ebx, [ebp + 12]
      shl ebx, 1
      add ebx, 1
      inc edx

      push ebx
      push eax
        call funcCodificaAlfabeto
      add esp, 4
      pop ebx
      shr ebx, 1
      dec edx

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
      je  armazenaCodigo

      mov ebx, [ebp + 12]
      shl ebx, 1
      ; add ebx, 1
      inc edx

      push ebx
      push eax
        call funcCodificaAlfabeto
      add esp, 4
      pop ebx
      shr ebx, 1
      dec edx

    jmp retorno

    armazenaCodigo:
      mov eax, [ebp + 12]
      mov [codigo + ecx], eax

      mov [qtdBitCodigo + ecx], edx

      ; push eax
      ;   mov eax, [codigo + ecx]
      ;   call print_int
      ;   call funcImprimirSeparador
      ; pop eax

      mov eax, [ebp + 8]
      mov eax, [eax]
      mov [correlato + ecx], eax
      ; push eax
      ;   call funcImprimirLetra
      ;   call funcImprimirSeparador
      ; pop eax
      ;
      ; push ebx
      ;   call funcImprimirBinario
      ;   call funcImprimirSeparador
      ; pop ebx
      ;
      ; push eax
      ;   mov eax, [qtdBitCodigo + ecx]
      ;   call print_int
      ;   call print_nl
      ; pop eax

      add ecx, 4
    retorno:
pop ebp
ret

;Função para imprimir os códigos do alfabeto
;funcImprimirCodigos
funcImprimirCodigos:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax

    call print_nl
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
        call funcImprimirSeparador
      pop eax
      sairImprimirCodigo:
      add ebx, 4
    loop imprimirCodigo
  pop eax
  pop ebx
  pop ecx
pop ebp
ret

;Identifica código do caractere
;funcCodificar(*Caractere)
funcCodificar:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
    mov edx, [ebp + 8]
    mov ecx, 128
    mov ebx, 0
    codificar:
      mov eax, [correlato + ebx]
      push edx
      push ebx
        mov ebx, 4
        cdq
        div ebx
        ; push eax
        ;   call print_char
        ;   call funcImprimirSeparador
        ; pop eax
      pop ebx
      pop edx
      cmp eax, edx
      je sairCodificar
      add ebx, 4
    loop codificar
    sairCodificar:
      mov eax, [codigo + ebx]
      ; push eax
      ;   mov eax, ebx
      ;   call print_int
      ;   call print_nl
      ; pop eax

  pop ebx
  pop ecx
  pop edx
pop ebp
ret

; ;Identifica código do caractere
; funcCodificarTextoHuf:
; push ebp
; mov ebp, esp
;   push edx
;   push ecx
;   push ebx
;   push eax
;     mov edx, [ebp + 8]
;     mov eax, edx
;     mov ecx, 128
;     mov ebx, 0
;     compararCaractere:
;       mov eax, [correlato + ebx]
;       cmp eax, edx
;       je sairCompararCaractere
;       add ebx, 4
;     loop compararCaractere
;     jmp out
;     sairCompararCaractere:
;       push ecx
;         mov ecx, 32
;         mov eax, 0
;         mov edx, [codigo + ebx]
;         escreverCodigoHuf:
;           push edx
;             call funcImprimirBinario
;             call print_nl
;           pop edx
;           cmp ecx, [qtdBitCodigo + ebx]
;           jg sairEscreverCodigoHuf
;
;           push eax
;             mov eax, 8
;             cmp eax, [qtdBit]
;           pop eax
;           jne testaBit
;
;           push ecx
;             mov byte [qtdBit], 0
;             mov ecx, [contBuffer]
;             mov [bufferHuf + ecx], al
;             inc dword [contBuffer]
;           pop ecx
;
;           testaBit:
;             shr edx, 1
;             jz zero
;               shr al, 1
;               inc al
;             zero:
;               shr al, 1
;             inc byte [qtdBit]
;
;           sairEscreverCodigoHuf:
;         loop escreverCodigoHuf
;       out:
;       pop ecx
;   pop eax
;   pop ebx
;   pop ecx
;   pop edx
; pop ebp
; ret

funcCodigoCharHuf:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax
    mov eax, [ebp + 8]
    mov ecx, 128
    mov ebx, 0
    compararCaractere:
      cmp eax, [correlato + ebx]
      je achouCaractere
      add ebx, 4
    loop compararCaractere
    jmp sairCompararCaractere
    achouCaractere:
      push ecx
        mov ecx, 32
        mov eax, [codigo + ebx]
        escreverCodigoHuf:
          shl eax, 1
          jc codigoUm
            cmp ecx, [qtdBitCodigo + ebx]
            jg sairEscreverCodigoHuf

            ; push eax
            ;   mov eax, [qtdBitCodigo + ebx]
            ;   call print_int
            ; pop eax

            push ecx
            push eax
              mov ecx, [contBuffer]
              mov al, 48
              mov [bufferHuf + ecx], al
              inc dword [contBuffer]
            pop eax
            pop ecx
            jmp sairEscreverCodigoHuf
          codigoUm:
            cmp ecx, [qtdBitCodigo + ebx]
            jg sairEscreverCodigoHuf

            ; push eax
            ;   mov eax, [qtdBitCodigo + ebx]
            ;   call print_int
            ; pop eax

            push ecx
            push eax
              mov ecx, [contBuffer]
              mov al, 49
              mov [bufferHuf + ecx], al
              inc dword [contBuffer]
            pop eax
            pop ecx
          sairEscreverCodigoHuf:
        loop escreverCodigoHuf
      pop ecx
    sairCompararCaractere:
  pop eax
  pop ebx
  pop ecx
pop ebp
ret

funcCodigoTextoHuf:
push ebp
mov ebp, esp
  push ecx
  push ebx
  push eax

    mov eax, [ebp + 8]
    mov ecx, 128
    mov ebx, 0
    compararCaractereTexto:
      cmp eax, [correlato + ebx]
      je achouCaractereTexto
      add ebx, 4
    loop compararCaractereTexto
    jmp sairCompararCaractereTexto
    achouCaractereTexto:
      push ecx
        mov ecx, 32
        mov eax, [codigo + ebx]
        escreverTextoHuf:
          shl eax, 1
          jc textoUm
            cmp ecx, [qtdBitCodigo + ebx]
            jg sairEscreverTextoHuf

            push ecx
            push eax
              mov ecx, [contBuffer]
              mov al, [bufferHuf + ecx]
              shl al, 1
              mov [bufferHuf + ecx], al
              inc byte [qtdBit]
            pop eax
            pop ecx
            jmp sairEscreverTextoHuf
          textoUm:
            cmp ecx, [qtdBitCodigo + ebx]
            jg sairEscreverTextoHuf

            push ecx
            push eax
              mov ecx, [contBuffer]
              mov al, [bufferHuf + ecx]
              shl al, 1
              add al, 1
              mov [bufferHuf + ecx], al
              inc byte [qtdBit]
            pop eax
            pop ecx

          sairEscreverTextoHuf:
            push eax
              mov eax, [qtdBit]
              cmp eax, 7
              jne mantemContadorBuffer
              mov byte [qtdBit], 0
              inc dword [contBuffer]
              ; call funcFlag
              mantemContadorBuffer:
            pop eax
        loop escreverTextoHuf
      pop ecx
    sairCompararCaractereTexto:

  pop eax
  pop ebx
  pop ecx
pop ebp
ret

funcEscreverTabelaHuf:
push ebp
mov ebp, esp
  push edx
  push ecx
  push ebx
  push eax
    mov ecx, 128                      ;Tamanho do loop
    mov ebx, 0
    escreverTabela:
      push ecx
        mov eax, [correlato + ebx]
        cmp eax, 0
        je sairSubEscreverTabela

        push ecx
          mov ecx, [contBuffer]
          mov [bufferHuf + ecx], al
          inc ecx
          ; movsx eax, al
          ; call print_char
          ; call funcImprimirSeparador
          push eax
            mov al, 45
            mov [bufferHuf + ecx], al
            inc ecx
          pop eax

          mov [contBuffer], ecx
          push eax
            call funcCodigoCharHuf
          pop eax
          mov ecx, [contBuffer]

          ; push eax
          ;   mov al, 45
          ;   mov [bufferHuf + ecx], al
          ;   inc ecx
          ; pop eax
          ;
          ; mov eax, [qtdBitCodigo + ebx]
          ; call funcIntParaChar
          ; mov [bufferHuf + ecx], al
          ; inc ecx

          push eax
            mov al, 10
            mov [bufferHuf + ecx], al
            inc ecx
          pop eax

          mov [contBuffer], ecx


          ; movsx eax, al
          ; call print_char
          ; call funcImprimirSeparador

        pop ecx

        sairSubEscreverTabela:
        add ebx, 4
      pop ecx
    loop escreverTabela
    inc byte [contBuffer]
  pop eax
  pop ebx
  pop ecx
  pop edx
pop ebp
ret

funcImprimirArquivoHuf:
push ebp
mov ebp, esp
  push eax
    mov esi, bufferHuf
    cld
    printArquivoHuf:
    lodsb                        ;al=[esi] e esi+=1
      cmp al, -1                 ;Verifica final do arquivo
      je sairPrintArquivoHuf  ;Pula se igual
      movzx eax, al             ;Estende o registrador al para eax
      call print_char
      ; call funcImprimirSeparador
    jmp printArquivoHuf
    sairPrintArquivoHuf:
  pop eax
pop ebp
ret


funcCodificarArquivoTexto:
push ebp
mov ebp, esp
  push eax
    mov esi, bufferTxt
    cld
    codificarArquivoTexto:
    lodsb                         ;al=[esi] e esi+=1
      cmp al, 0                 ;Verifica final do arquivo
      je sairCodificarArquivoTexto  ;Pula se igual
      movzx eax, al             ;Estende o registrador al para eax
      push eax
        call funcCodigoTextoHuf
      pop eax
    jmp codificarArquivoTexto
    sairCodificarArquivoTexto:
    inc dword [contBuffer]
  pop eax
pop ebp
ret
