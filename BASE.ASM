; Name: Asaf Niv
IDEAL
MODEL small
STACK 100h
DATASEG
message db 14,"Enter grades:$"
grades db 9,?
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
   mov al,0
proc readGrades
    mov ah,01h
    int 21h
    mov [grades+bx],al
    sub [grades+bx],48
    inc bx
    cmp bx,3
    jnz readGrades
    ret
endp
exit:
    mov ax, 4c00h
    int 21h
END start