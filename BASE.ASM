; Name: Asaf Niv
IDEAL
MODEL small
STACK 100h
DATASEG
message db 13,"Enter grades:$"
grades db 9 dup(0)
catA db 9 dup(0)
catB db 9 dup(0)
catC db 9 dup(0)
CODESEG
start:
    mov ax,@data
    mov ds,ax
   ;-----------
    lea dx, [message]
    mov ah, 09h
    int 21h
    mov bx,0
    call readGrades
    mov bx,0
    call sortGrades
   ;-----------
   jmp exit
proc readGrades
    mov ah,01h
    int 21h
    mov [grades+bx],al
    sub [grades+bx],48
    inc bx
    cmp bx,9
    jnz readGrades
    ret
endp
proc sortGrades
    mov al,[grades+bx]
    cmp al,8
    je @@addToA
    jg @@addToA
    cmp al,7
    je @@addToB
    cmp al,6
    je @@addToB
    jmp @@addToC

    @@addToA:
    mov [catA+bx],al
    jmp @@sorted
    @@addToB:
    mov [catB+bx],al
    jmp @@sorted
    @@addToC:
    mov [catC+bx],al
    jmp @@sorted

    @@sorted:
    inc bx
    cmp bx,9
    jnz sortGrades
    jz @@end
    @@end:
    ret
endp

exit:
    mov ax, 4c00h
    int 21h
END start