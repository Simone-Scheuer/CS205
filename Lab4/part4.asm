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
    array1: dd 0x0
    array2: dd 0x0
    array3: dd 0x0
    fmt_int: db "%d", 0 
    arr1: db "array1:", TAB, NULL
    arr2: db "array2:", TAB, NULL
    arr3: db "array3:", TAB, NULL

    fmt1: db "%d", TAB, NULL
    ask1: db "Enter the number of elements in the array ", NULL, NL
    ask2: db "Enter the seed to use for rand() ", NULL, NL
    ask3: db "Enter the modulo to apply to the random numbers ", NULL, NL
    fmtdone: db "", NL, NULL

    reverse: db " in reverse ", NULL
    third: db " array1 * array2 %% %d ", NULL

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
    mov dword [num_els], 11

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
    mov dword [rand_seed], 13

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
    mov dword [modulo], 97

    .valid_modulo_size: ;; Continue onwards


create_arrays:

    mov eax, [num_els]
    mov ebx, 4
    mul ebx
    
    push eax
    call malloc
    add esp, 4

    mov [array1], eax

    mov edi, 0 
    mov eax, 0

    mov eax, [num_els]
    mov ebx, 4
    mul ebx
    
    push eax
    call malloc
    add esp, 4

    mov [array2], eax

    mov edi, 0 
    mov eax, 0

    mov eax, [num_els]
    mov ebx, 4
    mul ebx
    
    push eax
    call malloc
    add esp, 4

    mov [array3], eax

    mov edi, 0 
    mov eax, 0

assign1:

    push dword [ rand_seed ]
    call srand
    add esp, 4  

    mov ebx, [array1]


.loop:    
    push edi    

    call rand
    mov edx, 0
    mov ebx, [ array1 ] 
    div dword [ modulo ]
    mov [ebx + edi * 4], edx 
    
    pop edi
    inc edi 
    cmp edi, [ num_els ] 

    jl .loop
    

print1: 
    push dword arr1
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

push fmtdone
call printf
add esp, 4

mov edi, 0
mov edx, 0
mov eax, 0

assign2:

    mov ebx, [array2]

.loop:    
    push edi    

    call rand
    mov edx, 0
    mov ebx, [ array2 ] 
    div dword [ modulo ]
    mov [ebx + edi * 4], edx 
    
    pop edi
    inc edi 
    cmp edi, [ num_els ] 

    jl .loop
    
print2: 
    push dword arr2
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

push fmtdone
call printf
add esp, 4

print2reverse: 
    push dword arr2
    call printf
    add esp, 4

    mov edi, [num_els]
    sub edi, 1
    mov eax, 0

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

    dec edi

    cmp edi, 0
    jge .loop


push reverse
call printf
add esp, 4

push fmtdone
call printf
add esp, 4


assign3:
    mov eax, [array1]
    mov ebx, [array2]
    mov ecx, [array3]
    mov edi, 0

.loop:    
    push edi    
    push eax
    push ebx
    push ecx

    mov eax, [eax + edi * 4]
    mov esi, [ebx+ edi * 4]

    mul esi

    div dword [ modulo ]

    mov [ecx + edi * 4], edx 
    
    pop ecx
    pop ebx
    pop eax
    pop edi

    inc edi 
    cmp edi, [ num_els ] 
    jl .loop
    

print3: 
    push dword arr3
    call printf
    add esp, 4

    mov edi, 0
    mov eax, 0

    mov edx, [num_els]
    sub edx, 1 
    mov ecx, [array3]

    .loop:
    push edx
    push eax
    push edi
    push ecx

    mov eax, [ecx + edi * 4]

    push dword eax
    push dword fmt1
    call printf
    add esp, 8
    
    pop ecx
    pop edi
    pop eax
    pop edx

    inc edi

    cmp edi, edx
    jle .loop
   
    mov eax, [ modulo ]
    push dword eax
    push dword third
    call printf
    add esp, 8


done:
    push dword [array1]
    call free
    add esp, 4

    push dword [array2]
    call free
    add esp, 4

    push dword [array3]
    call free
    add esp, 4
    
    
    
    mov esp, ebp
    pop ebp

    mov eax, 0
    ret
