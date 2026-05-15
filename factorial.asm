section .data
    buf db 0 

section .text
    global _main

_main:
    ; We put 1 in rax
    mov rax, 1
    ; THIS IS THE VARIABLE TO CHANGE TO CALCULATE THE FACTORIAL
    mov rcx, 5


.loop:
    ; rax = rax * rcx
    imul rax, rcx
    sub rcx, 1 ; We remove 1 to rcx
    cmp rcx, 1 ; We compare rcx to 1
    jne .loop ; if not equal then redo the loop until it does

    mov rbx, 10 ; Divisor
    mov rcx, 0 ; counter 

.extract:
    xor rdx, rdx ; rdx must be equal to 0 
    div rbx ; rax = quotient | rdx = the rest
    add rdx, 48; in ASCII "0" = 48 so we convert in ascii
    push rdx ; fill the number 
    inc rcx ; counter++
    cmp rax, 0 ; rax is the quotient so it loop until no digits left
    jne .extract ; If yes then loop again

.print:
    pop rdx; count a number 
    lea rsi, [rel buf] ; Load Effective Adresse at buf (1octet)
    mov [rsi], dl ; write rsi in buf 
    push rcx ; save rcx
    mov rax, 0x2000004
    mov rdi,1
    mov rdx,1
    syscall
    pop rcx ; restore rcx
    loop .print ; if rcx !=0 like we have more than 1 number left we continue to make newline 



    ;newline
    mov byte [rel buf], 0x0A
    lea rsi, [rel buf]
    mov rax, 0x2000004
    mov rdi, 1
    mov rdx, 1
    syscall

    mov rax,0x2000001
    xor rdi,rdi
    syscall


