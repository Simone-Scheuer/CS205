extern printf
global main

%define array1_size 25
%define array1_bytes 2
%define NULL 0
%define NL 10
%define EXIT_SUCCESS 0

section .bss

section .data
    array1: resw array1_size
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
    mov eax, 7

    assign:
    mov [ebx+edi * 2], eax 

    add edi, 1
    add eax, 7

    cmp edi, array1_size
    jl assign

    mov edi, 0
    mov ebx, array1

    print: 
    mov eax, 0
    mov ax, [ebx+edi * 2]
    push eax
    push edi

    push dword fmt1
    call printf
    add esp, 12
    add edi, 1
    cmp edi, array1_size
    jl print


    mov esp, ebp
    pop ebp

    mov eax, 0
    ret
