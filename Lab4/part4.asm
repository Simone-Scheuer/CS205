extern printf
extern scanf
extern srand
extern rand
extern free
extern malloc

global main

%define NULL 0
%define array1_size 30
%define NL 10
%define TAB 9 
%define EXIT_SUCCESS 0

section .bss
    ;array: resd 0

section .data
    array: dd 0x0
    fmt_int: db "%d", 0 
    fmt0: db "array1:", TAB, NULL
    fmt1: db "%d", TAB, NULL
    ask1: db "Enter the number of elements in the array ", NULL, NL
    ask2: db "Enter the seed to use for rand() ", NULL, NL
    ask3: db "Enter the modulo to apply to the random numbers ", NULL, NL
    fmt3: db "array1: "
    fmtdone: db "", NL
    test: db "num els: %d rand_seed %d modulo %d", NL, NULL

    num_els dd 0
    rand_seed dd 0
    modulo dd 0

section .rodata

section .text

main:
    push ebp
    mov ebp, esp

    mov edi, 0  
    mov eax, 0

start:
    push ask1 ;; Enter num of elements 
    call printf
    add esp, 4

    push num_els
    push fmt_int
    call scanf
    add esp, 8
    
    cmp eax, 1
    jne .invalid_array_size
    cmp dword [num_els], 0
    jg .valid_array_size

    .invalid_array_size:
    mov dword [num_els], 7

    .valid_array_size: ;; Proceed to seed size
    push ask2 
    call printf
    add esp, 4

    push rand_seed
    push fmt_int
    call scanf
    add esp, 8

    cmp eax, 1
    jne .invalid_seed_size
    cmp dword [rand_seed], 0
    jg .valid_seed_size

    .invalid_seed_size:
    mov dword [rand_seed], 5

    .valid_seed_size: ;; Proceed to modulo\
    sub esp, 4
    push ask3
    call printf
    add esp, 8

    push modulo
    push fmt_int
    call scanf
    add esp, 8

    cmp eax, 1
    jne .invalid_modulo_size
    cmp dword [modulo], 0
    jg .valid_modulo_size

    .invalid_modulo_size:
    mov dword [modulo], 37

    .valid_modulo_size: ;; Continue onwards


create_array:

    mov eax, [num_els]
    mov ebx, 4
    mul ebx
    
    push eax
    call malloc
    add esp, 4

    mov [array], eax

    mov edi, 0 
    mov eax, 0

assign:

    push dword [ rand_seed ]
    call srand
    add esp, 4  

    mov ebx, [array]


.loop:    
    push edi    

    call rand
    mov edx, 0
    mov ebx, [ array ] 
    div dword [ modulo ]
    mov [ebx + edi * 4], edx 
    
    pop edi
    inc edi 
    cmp edi, [ num_els ] 

    jle .loop
    

print: 
    push dword fmt0
    call printf
    add esp, 4

    mov edi, 0
    mov eax, 0

    mov edx, [num_els]
    sub edx, 1 
    push edx
    

    .loop:
    push edx
    push eax
    push edi

    mov eax, [ebx+edi * 4]

    push dword eax
    push dword fmt1
    call printf
    add esp, 8


    pop edi
    pop eax
    pop edx

    inc edi

    cmp edi, edx
    jle .loop

done:

    mov eax, [array]
    push eax
    call free
    add esp, 4    
    
    mov esp, ebp
    pop ebp

    mov eax, 0
    ret


