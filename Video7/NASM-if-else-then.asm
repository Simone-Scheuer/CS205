extern printf                                                                                                                                                                                                
global main
    %define NULL 10
    %define NL 10
    %define EXIT_SUCCESS 0
    
section .data
    a: dd 5
    b: dd 10
    c: dd 0
    d: dd 0

section .bss

section .rodata
    fmt1: db "example: a = %2d b = %2d c = %2d", NL, NULL

    fmt2: db "example: b = %2d eax = %2d c = %2d", NL, NULL

    fmt3: db "example: a = %2d b = %2d d = %2d c = %2d", NL, NULL

section .text

main:

push ebp
mov, ebp, esp

example1:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx
    jne .false
    mov dword [c], 1
    jmp .done

.false:
    mov dword [c], 0

.done:
    push dword [c]
    push dword [b]
    push dword [a]
    push dword 1
    push dword fmt1
    call printf
    add esp, 20

example2:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx
    jne .true
    mov dword [c], 0
    jmp .done

.true:
    mov dword [c], 1

.done:
    push dword [c]
    push dword [b]
    push dword [a]
    push dword 1
    push dword fmt2
    call printf
    add esp, 20


    


    mov esp, ebp
    pop ebp
    mov eax, 0
    ret

