; Name: Asaf Niv
IDEAL
MODEL small
STACK 100h
DATASEG
enterGrades db 13,"Enter grades:$"
grades db 9 dup(99)
; Default values so we know what NOT to print
catA db 9 dup(99)
catB db 9 dup(99)
catC db 9 dup(99)
CODESEG
start:
    mov ax,@data
    mov ds,ax
   ;-----------
    lea dx, [enterGrades]
    mov ah, 09h
    int 21h
    mov bx,0
    call readGrades
    mov bx,0
    call sortGrades
    mov bx,0
    call printSortedGrades
   ;-----------
   jmp exit
proc printSortedGrades
    mov dl, 'C'
    mov ah, 02h
    int 21h
    call printSpace

    mov bx,0
    @@printC:
    mov dl,[catC+bx]
    call printDlNum
    inc bx
    cmp bx,9
    jnz @@printC

    mov dl, 'B'
    mov ah, 02h
    int 21h
    call printSpace

    mov bx,0
    @@printB:
    mov dl,[catB+bx]
    call printDlNum
    inc bx
    cmp bx,9
    jnz @@printB

    mov dl, 'A'
    mov ah, 02h
    int 21h
    call printSpace

    mov bx,0
    @@printA:
    mov dl,[catA+bx]
    call printDlNum
    inc bx
    cmp bx,9
    jnz @@printA
    
    ret
endp
; prints a number from dl if it's not 99
proc printDlNum
    cmp dl,99 ; check if it's 99
    jz @@end
    add dl,48 ; make that number a character
    mov ah, 02h
    int 21h
    call printSpace
    @@end:
    ret
endp
proc readGrades ; reads 9 numbers (aka grades in this context) from user input
    mov ah,01h
    int 21h
    mov [grades+bx],al
    sub [grades+bx],48
    inc bx
    cmp bx,9
    jnz readGrades
    call printNewline
    ret
endp
proc printNewline ; makes a new line
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    ret
endp
proc printSpace ;  prints a space to seperate between stuff
    mov dl, ' '
    mov ah, 02h
    int 21h
    ret
endp
proc sortGrades ; sorts grades to categories A,B,C accordingly
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
