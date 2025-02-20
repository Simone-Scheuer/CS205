extern printf                                                                                                                                                                                                
global main
%define NULL 0
%define NL 10
%define EXIT_SUCCESS 0


section .bss

section .data
a: dd 5
b: dd 10
c: dd 0
d: dd 0


section .rodata
fmt1: db "example: %2d a = %2d b = %2d c = %2d", NL, NULL
fmt2: db "example: %2d b = %2d eax = %2d c = %2d", NL, NULL
fmt3: db "example: %2d a = %2d b = %2d d = %2d c = %2d", NL, NULL

section .text

main:

push ebp
mov ebp, esp

example1:
mov eax, [a]
mov ebx, [b]
cmp eax, ebx
jne .false1
mov dword [c], 1
jmp .done1

.false1:
mov dword [c], 0

.done1:
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
je .true2
mov dword [c], 0
jmp .done2

.true2:
mov dword [c], 1

.done2:
push dword [c]
push dword [b]
push dword [a]
push dword 2
push dword fmt2
call printf
add esp, 20

example3:
mov eax, [ b ]
cmp eax, [ b ]
je .true3
mov dword [ c ], 0
jmp .done3
.true3:
mov dword [ c ], 1
.done3:
push dword [ c ]
push eax
push dword [ b ]
push dword 3 
push dword fmt2
call printf
add esp, 20

example4:
mov eax, [ a ]
mov ebx, [ b ]
cmp eax, ebx
jge .false4
mov ebx, [ d ]
cmp eax, ebx
jle .false4
mov dword [ c ], 1
jmp .done4
.false4:
mov dword [ c ], 0
.done4:
push dword [c]
push dword [d]
push dword [b]
push dword [a]
push dword 4
push dword fmt3
call printf
add esp, 24

mov esp, ebp
pop ebp
mov eax, 0
ret

