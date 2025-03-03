extern printf
global main

%define array1_size 30
%define NULL 0
%define NL 10
%define EXIT_SUCCESS 0

section .bss

section .data
    array1: times array1_size dd 0 
    index_val dd 0
    fmt1: db "Array Index: %2d Value: %2d", NL, NULL
    fmt2: db "EAX: %2d", NL, NULL
    

section .rodata

section .text

main:
    push ebp
    mov ebp, esp

    mov ebx, array1
    mov edi, 0  
    mov eax, 9

    assign:
    mov [ebx+edi * 4], eax 

    add edi, 1
    add eax, 4

    cmp edi, array1_size
    jle assign

    mov edi, 29
    mov ebx, array1

    print: 
    mov eax, [ebx+edi * 4]

    push dword eax
    push dword edi

    push dword fmt1
    call printf
    add esp, 12

    sub edi, 1
    cmp edi, -1
    jg print


    mov esp, ebp
    pop ebp

    mov eax, 0
    ret
