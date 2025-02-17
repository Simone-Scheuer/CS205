extern printf
extern scanf

global main

section .bss
    result: resd 1
    num1: resd 1
    num2: resd 1
    symb: resd 1

section .data
    fmt_show_expression: db "Basic Addition and Subtraction Calculator.", 10, 0
    fmt_show_add: db "Your Expression %d = %d + %d", 10, 0
    fmt_show_sub: db "Your Expression %d = %d - %d", 10, 0
    fmt_get_num1: db "Enter the value for num 1: ", 0
    fmt_get_num2: db "Enter the value for num 2: ", 0
    fmt_get_symb: db "Enter 1 to add, 0 to subtract: ", 0
    fmt_get_val: db "%d", 0

section .text
main:
    push ebp
    mov ebp, esp
    and esp, -16             ; Stack alignment to 16-byte boundary

    ; Print the welcome message
    push fmt_show_expression
    call printf
    add esp, 4               ; Clean up stack after call

    ; Get input for num1
    push fmt_get_num1
    call printf
    add esp, 4
    lea eax, [num1]
    push eax
    push fmt_get_val
    call scanf
    add esp, 8               ; Clean up stack after call

    ; Get input for num2
    push fmt_get_num2
    call printf
    add esp, 4
    lea eax, [num2]
    push eax
    push fmt_get_val
    call scanf
    add esp, 8               ; Clean up stack after call

    ; Get input for symb
    push fmt_get_symb
    call printf
    add esp, 4
    lea eax, [symb]
    push eax
    push fmt_get_val
    call scanf
    add esp, 8               ; Clean up stack after call

    ; Check if symb is 1 (for addition)
    mov eax, [symb]
    cmp eax, 1
    jne not_equal            ; Jump to subtraction if not equal to 1

    ; Addition operation
    mov eax, [num1]
    add eax, [num2]
    mov [result], eax
    push dword [num2]
    push dword [num1]
    push dword [result]
    push fmt_show_add
    call printf
    add esp, 16              ; Clean up stack after call
    jmp done                 ; Skip the subtraction part

not_equal:
    ; Subtraction operation
    mov eax, [num1]
    sub eax, [num2]
    mov [result], eax
    push dword [num2]
    push dword [num1]
    push dword [result]
    push fmt_show_sub
    call printf
    add esp, 16              ; Clean up stack after call

done:
    ; Return and clean up
    mov esp, ebp
    pop ebp
    mov eax, 0
    ret

