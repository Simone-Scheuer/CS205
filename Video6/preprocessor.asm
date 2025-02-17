extern printf
global main
    
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0
    %define ARRAY_SIZE 100

    %define HELLO_STR "Hello world!"
    %strlen HELLO_LEN HELLO_STR

    %define DEBUG
    %ifdef DEBUG
        %macro CURR_LINE 1
            push %1
            push fmt_curr_line
            call printf
            add esp, 8
        %endmacro
    %else
        %macro CURR_LINE 1
        %endmacro
    %endif 

section .bss
section .data
    array: times ARRAY_SIZE dd 0

section .rodata
    fmt_bad: db "\tHello world!\n", NL, NULL
    fmt_good: db TAB, HELLO_STR, NL, NULL
    fmt_len: db TAB, HELLO_STR, " %d", NL, NULL
    fmt_curr_line: db "DEBUG LINE: %d", NL, NULL
section .text

main:
    push ebp
    mov ebp, esp

    CURR_LINE(__LINE__)
    
    push fmt_bad
    call printf
    add esp, 4

    push fmt_good
    call printf
    add esp, 4

    CURR_LINE(__LINE__)

    push HELLO_LEN
    push fmt_len
    call printf
    add esp, 8

    CURR_LINE(__LINE__)


    mov esp, ebp
    pop ebp

    mov eax, EXIT_SUCCESS
    ret

