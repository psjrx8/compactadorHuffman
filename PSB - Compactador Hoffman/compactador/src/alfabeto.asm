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
funcBubbleAlfabeto:
push ebp
mov ebp, esp

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

pop ebp
ret
