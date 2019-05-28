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
   letra  resd 1

segment .text

%include "src/read_write_file.asm"

        global  asm_main
asm_main:

    mov ecx, 128
    mov ebx, 0

preencherAlfabeto:
    mov [alfabeto + ebx], ebx
    ;mov eax, [alfabeto + ebx]
    add ebx, 4
    loop preencherAlfabeto

    push ecx
    push ebx
      call funcExibirAlfabeto
    pop ebx
    pop ecx

    push filename
    push buffer
    push buflen
    call read_file
    add esp, 12

    mov esi, buffer
    cld
    print:
    lodsb ;al=[esi] e esi+=1
        cmp al, 0
        je exit
        movzx eax, al
        call print_char
        imul eax, 4
        add dword [frequencia + eax], 1
    jmp print
    exit:

    call print_nl

    push ecx
    push ebx
      call funcExibirFrequencia
    pop ebx
    pop ecx


    mov ecx, 127
    mov ebx, 0
ordernarVetor: ;Bubble sort
    push ecx
    push ebx
    subOrdenarVetor:
      mov eax, [frequencia + ebx]
      add ebx, 4
      mov edx, [frequencia + ebx]
      cmp eax, edx
      jge  continuar

      push ecx
      push ebx
        call funcBubble
      pop ebx
      pop ecx
      continuar:
      loop subOrdenarVetor
    pop ebx
    pop ecx
    loop ordernarVetor

    push ecx
    push ebx
      call funcExibirFrequencia
    pop ebx
    pop ecx

    push ecx
    push ebx
      call funcExibirAlfabeto
    pop ebx
    pop ecx

    jmp sair

funcExibirFrequencia:
    push ebp
    mov ebp, esp
      call print_nl
      mov ecx, 128
      mov ebx, 0
      exibirFrequencia:
          mov eax, [frequencia + ebx]
          add ebx, 4
          call print_int
          mov eax, ' '
          call print_char
          loop exibirFrequencia
      call print_nl
      call print_nl
    pop ebp
    ret

funcExibirAlfabeto:
    push ebp
    mov ebp, esp
      call print_nl
      mov ecx, 128
      mov ebx, 0
      exibirAlfabeto:
          mov eax, [alfabeto + ebx]
          add ebx, 4
          call print_int
          mov eax, ' '
          call print_char
          loop exibirAlfabeto
      call print_nl
      call print_nl
    pop ebp
    ret

funcBubble:
    push ebp
    mov ebp, esp

      sub ebx, 4
      mov [frequencia + ebx], edx

      add ebx, 4
      mov [frequencia + ebx], eax

      mov eax, [alfabeto + ebx]
      mov [maior], eax

      sub ebx, 4
      mov eax, [alfabeto + ebx]
      mov [menor], eax

      mov eax, [maior]
      mov [alfabeto + ebx], eax

      add ebx, 4
      mov eax, [menor]
      mov [alfabeto + ebx], eax

    pop ebp
    ret

sair:

    leave
    ret
