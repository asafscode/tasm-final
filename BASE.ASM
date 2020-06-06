; Name: Asaf Niv
IDEAL
MODEL small
STACK 100h
DATASEG
enterGrades db 13,"Enter grades:$"
avgStr db "AVG$"
grades db 9 dup(99)

; Default value is 99 so we know what NOT to print
catA db 9 dup(99)
catACount db 0

catB db 9 dup(99)
catBCount db 0

catC db 9 dup(99)
catCCount db 0

evenNums db 0
oddNums db 0

avg db 0

CODESEG
start:
    mov ax,@data
    mov ds,ax
   ;-----------
    lea dx, [enterGrades]
    call printDXString
    mov bx,0
    mov cl,0 ; we're adding every grade to cl
    call readGrades
    mov bx,0
    call sortGrades
    mov bx,0
    call printSortedGrades
   ;-----------
   jmp exit

proc printC
    push bx
    push dx
    mov dl,[catCCount]
    call printDlNum

    mov bx,0
    @@printC:
        mov dl,[catC+bx]
        call printDlNum
        inc bx
        cmp bx,9
        jnz @@printC
    pop dx
    pop bx
    ret
endp
proc printB
    push bx
    push dx
    mov dl,[catBCount]
    call printDlNum

    mov bx,0
    @@printB:
        mov dl,[catB+bx]
        call printDlNum
        inc bx
        cmp bx,9
        jnz @@printB
    pop dx
    pop bx
    ret
endp
proc printA
    push bx
    push dx
    mov dl,[catACount]
    call printDlNum

    mov bx,0
    @@printA:
        mov dl,[catA+bx]
        call printDlNum
        inc bx
        cmp bx,9
        jnz @@printA
    pop dx
    pop bx
    ret
endp
proc printSortedGrades
    mov dl, 'C'
    call printDlChar
    call printSpace
    call printC
    
    mov dl, 'B'
    call printDlChar
    call printSpace
    call printB
    
    mov dl, 'A'
    call printDlChar
    call printSpace
    call printA
    
    mov dl, 'P'
    call printDlChar
    call printSpace
    mov dl,[evenNums]
    call printDlNum

    mov dl, 'E'
    call printDlChar
    call printSpace
    mov dl,[oddNums]
    call printDlNum
    
    lea dx,[avgStr]
    call printDXString
    call printSpace
    
    mov dl,[avg]
    call printDlNum

    ret
endp
; prints a number from dl if it's not 99, and then a space
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
; prints a string from dx
proc printDXString
    mov ah, 09h
    int 21h
    ret
endp
; prints a char from dl
proc printDlChar
    mov ah, 02h
    int 21h
    ret
endp
proc readGrades ; reads 9 numbers (aka grades in this context) from user input
    mov ah,01h
    int 21h
    mov [grades+bx],al
    sub [grades+bx],48
    add cl,[grades+bx] ; adding every grade to cl to calculate avg
    inc bx
    cmp bx,9
    jnz readGrades
    call printNewline
    mov [avg],cl
    call calculateAvg
    ret
endp
; calculates average
proc calculateAvg
    push ax
    push cx
    push dx
    mov ax,0
    mov al,[avg]
    mov dx,0
    mov cx,9
    div cx
    pop cx
    mov [avg],al
    pop dx
    pop cx
    pop ax
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
    call printDlChar
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
        inc [catACount]
        jmp @@sorted
    
    @@addToB:
        mov [catB+bx],al
        inc [catBCount]
        jmp @@sorted

    @@addToC:
        mov [catC+bx],al
        inc [catCCount]
        jmp @@sorted

    @@sorted:
        test al,1
        jnz @@odd
        jz @@even
    @@odd:
        inc [oddNums]
        jmp @@end
    @@even:
        inc [evenNums]
    @@end:
        inc bx
        cmp bx,9
        jnz sortGrades
        ret
endp

exit:
    mov ax, 4c00h
    int 21h
END start
