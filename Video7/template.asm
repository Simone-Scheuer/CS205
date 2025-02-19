extern printf
global main
    
section .bss
section .data
section .rodata
section .text

main:
    push ebp
    mov ebp, esp

    mov esp, ebp
    pop ebp

    mov eax, 0
    ret

