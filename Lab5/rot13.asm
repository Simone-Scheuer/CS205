extern printf
global main
extern printf
extern scanf

%define SIZE 1023
%define NULL 0
%define NL 10
%define EXIT_SUCCESS 0

section .bss
user_input: resb SIZE
rotated_array: resb SIZE

section .data
rot_amount: dd 0

section .rodata

;; CHAR SET INFO
char_set: db " !" , '"' ,"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
char_count: equ ($ - char_set)

;; READ FORMAT STATEMENTS
get_rot_amt: db "Enter the amount to rotate: ", NULL
get_user_input: db "Enter the message to encrypt: ", NULL
output: db "Your encrypted message: ", NULL

rotten_rot_1: db "The rotate value must be between -94 and 94 (inclusive)", NL, NULL
rotten_rot_2: db "Your rotate is rotten. Exiting...", NL, NULL

;; SCANF STATEMENTS
scanf_magic: db NL, "%[^",NL,"]s", NULL
fmt_int: db "%d", 0 

section .text

main:

    push ebp
    mov ebp, esp

read_data:

.user_input:
    push get_user_input
    call printf
    add esp, 4

    push user_input
    push scanf_magic
    call scanf
    add esp, 8

.rot_amount:
    push get_rot_amt
    call printf
    add esp, 4

    push rot_amount
    push fmt_int
    call scanf
    add esp, 8

    cmp dword [rot_amount], -94
    jl .rotten
    cmp dword [rot_amount], 94
    jg .rotten

    jmp .continue

    .rotten:
    push rotten_rot_1
    call printf
    add esp, 4
    push rotten_rot_2
    call printf
    add esp, 4
    jmp exit

.continue:


.begin_rotation:
    mov eax, user_input ;; USER ARRAY TRACKER REGISTER
    mov edi, 0 ;; USER ARRAY INDEX REGISTER

    mov ebx, rotated_array ;; CHAR ARRAY TRACKER REGISTER
    mov esi, 0 ;; CHAR ARRAY INDEX REGISTER
    
    rotate:
    cmp dword [eax + edi], 0
    je .finished

    mov ecx, [eax + edi] 
    add ecx, [rot_amount]
    mov [ebx + esi], ecx
    inc edi
    inc esi
    jmp rotate


    .finished:
    push output
    call printf
    add esp, 4

    push rotated_array
    call printf
    add esp, 4

exit:

    mov esp, ebp
    pop ebp

    mov eax, 0
    ret

