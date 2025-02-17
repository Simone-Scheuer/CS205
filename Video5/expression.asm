

extern printf ; Declare printf as external func for output
extern scanf ; Declare scanf as external func for input
global main ; Define main as entry point

section .bss ; unitialized data section
    y: resd 1 ; reserve space for y (1 doubleword = 4 bytes)

section .data ; read and write variables
    m: dd 0 ; define m as doubleword (4 bytes) initialized to zero
    x: dd 0 ; define x as doubleword initialized to zero
    b: dd 0

section .rodata ; read only data (constant strings)
    fmt_show_expression: db "You will calculate the expression y = mx +b", 10, 0 
    fmt_show_result: db "Your expression %d = %d * %d + %d", 10, 0
    fmt_get_m: db 9 , "Enter the value for m: ", 0
    fmt_get_x: db 9 , "Enter the value for x: ", 0
    fmt_get_b: db 9 , "Enter the value for b: ", 0
    fmt_get_value: db "%d", 0  ; format specifier for scanf (integer input)


section .text ; code section with executible instructions

main: ; Code Section (contains executibles)

    push ebp  ; save old base pointer (stack frame setup)
    mov ebp, esp ; set base pointer to current stack pointer

    push fmt_show_expression ; push the addy of fmt_show onto the stack
    call printf ; call printf to print presumably the top of the stack
    add esp, 4 ; clean up the stack? one argument 4 bytes

    push fmt_get_m ; push the prompt message for m
    call printf ; print the prompt
    add esp, 4 ; clean the stack

    push m ; push the adderess where scanf will store input
    push fmt_get_value ; push the format specifier (%d)
    call scanf ; call scanf on the top of the stack to populate m
    add esp, 8 ; clean up stack (2 args, 8 bytes)

    push fmt_get_x
    call printf
    add esp, 4

    push x
    push fmt_get_value
    call scanf
    add esp, 8

    push fmt_get_b
    call printf
    add esp, 4

    push b
    push fmt_get_value
    call scanf
    add esp, 8

    mov eax, [ m ] ; load the value stored at addy m to eax
    imul eax, [ x ] ; multiply value stored at addy x to eax
    add eax, [ b ] ; add value stored at addy b to eax
    mov [ y ], eax ; move eax value into y

    push dword [ b ] ; push results in backwards order so 
    push dword [ x ]
    push dword [ m ]
    push dword [ y ]
    push fmt_show_result ; this friggin guy can finsih this
    call printf ; call printf on the top of the stack
    add esp, 20 ; clear all that space

    mov esp, ebp
    pop ebp

    mov eax, 0 ; return 0
    ret ; return from function
