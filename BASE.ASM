; Name: Asaf Niv
IDEAL
MODEL small
STACK 100h
DATASEG
enterGrades db 13,"Enter grades:$"
avgStr db "AVG$"
enterCommand db "Enter a command:$"
biggestGrade db "Biggest grade: $"
smallestGrade db "Smallest grade: $"
grades db 9 dup(99)

gradesLH db 9 dup(99) ; grades sorted from low to high
gradesLHCount db 0

; Default value is 99 so we know what NOT to print
catA db 9 dup(99)
catACount db 0

catB db 9 dup(99)
catBCount db 0

catC db 9 dup(99)
catCCount db 0

evenGrades db 9 dup(99)
evenGradesCount db 0
oddGrades db 9 dup(99)
oddGradesCount db 0

avg db 0

CODESEG
start:
    mov ax,@data
    mov ds,ax
   ;-----------
    lea dx, [enterGrades]
    push dx
    call printString
    mov bx,0
    mov cl,0 ; we're adding every grade to cl
    call readGrades
    mov bx,0
    call sortGradesLH
    call sortGrades
    mov bx,0
    call printSortedGrades
    call printNewline
    call recvCommand
   ;-----------
   jmp exit
proc sortGradesLH
    push ax
    push cx
    push bx
    mov bx,0
    @@iterate:
        call findLowestGrade
        push bx
        mov bl,[gradesLHCount]
        mov [gradesLH+bx],al
        inc [gradesLHCount]
        pop bx
        push bx
        mov bx,cx
        mov [grades+bx],99
        pop bx
        cmp bx,9
        jz @@end
        inc bx
        jmp @@iterate
    @@end:
        pop bx
        pop cx
        pop ax
        ret
endp
proc recvCommand
    lea dx, [enterCommand]
    push dx
    call printString
    call printNewline
    mov ah,01h
    int 21h
    call printNewline
    cmp al,'A'
    ; show category A grades, and so on...
    jz @@showCatA
    cmp al,'a'
    jz @@showCatA

    cmp al,'B'
    jz @@showCatB
    cmp al,'b'
    jz @@showCatB

    cmp al,'C'
    jz @@showCatC
    cmp al,'c'
    jz @@showCatC

    cmp al,'P'
    ; show even grades
    jz @@printEven
    cmp al,'p'
    jz @@printEven

    cmp al,'E'
    ; show odd grades
    jz @@printOdd
    cmp al,'e'
    jz @@printOdd
    
    cmp al, 'V'
    ; show avg
    jz @@printAvg
    cmp al, 'v'
    jz @@printAvg
    
    cmp al, 'X'
    ; show avg
    jz @@printHighLow
    cmp al, 'x'
    jz @@printHighLow

    cmp al, '#'
    ; bye
    jz @@end

    jmp recvCommand
    
    @@showCatA:
        call printA
        call printNewline
        jmp recvCommand
    @@showCatB:
        call printB
        call printNewline
        jmp recvCommand
    @@showCatC:
        call printC
        call printNewline
        jmp recvCommand
    @@printEven:
        call printEvenGrades
        call printNewline
        jmp recvCommand
    @@printOdd:
        call printOddGrades
        call printNewline
        jmp recvCommand
    @@printAvg:
        mov dl,[avg]
        push dx
        call printNum
        call printNewline
        jmp recvCommand
    @@printHighLow:
        call printHighestGrade
        call printNewline
        call printSmallestGrade
        call printNewline
        jmp recvCommand
    @@end:
    ret
endp
proc findLowestGrade ; finds the lowest grade, return value in al, number index in cx
    push bx
    push dx
    mov bx,0
    mov ax,0
    mov al,99 ; an initial value that is impossible for the user to enter
    @@iterate:
        cmp [grades+bx],al
        jg @@greaterOrEqual
        jz @@greaterOrEqual
        jmp @@smaller
    @@greaterOrEqual:
        inc bx
        cmp bx,9
        jz @@end
        jmp @@iterate
    @@smaller:
        mov cx,bx
        mov al,[grades+bx]
        jmp @@greaterOrEqual ; avoid duplicate code
    @@end:
        pop dx
        pop bx
        ret
endp
proc printHighestGrade
    push bx
    lea dx,[biggestGrade]
    push dx
    call printString
    mov dl,[gradesLH+8]
    push dx
    call printNum
    pop dx
    ret
endp
proc printSmallestGrade
    push bx
    lea dx,[smallestGrade]
    push dx
    call printString
    mov dl,[gradesLH+0]
    push dx
    call printNum
    pop dx
    ret
endp
proc printEvenGrades
    push bx
    push dx
    mov bx,0
    @@print:
        mov dl,[evenGrades+bx]
        push dx
        call printNum
        inc bx
        cmp bx,9
        jnz @@print
    pop dx
    pop bx
    ret
endp
proc printOddGrades
    push bx
    push dx
    mov bx,0
    @@print:
        mov dl,[oddGrades+bx]
        push dx
        call printNum
        inc bx
        cmp bx,9
        jnz @@print
    pop dx
    pop bx
    ret
endp
proc printCCount
    push dx
    mov dl,[catCCount]
    push dx
    call printNum
    pop dx
    ret
endp
proc printBCount
    push dx
    mov dl,[catBCount]
    push dx
    call printNum
    pop dx
    ret
endp
proc printACount
    push dx
    mov dl,[catACount]
    push dx
    call printNum
    pop dx
    ret
endp
proc printC
    push bx
    push dx
    mov bx,0
    cmp [catCCount],0
    jz @@end
    @@printC:
        mov dl,[catC+bx]
        push dx
        call printNum
        inc bx
        cmp bx,9
        jnz @@printC
    @@end:
        pop dx
        pop bx
        ret
endp
proc printB
    push bx
    push dx
    mov bx,0
    cmp [catBCount],0
    jz @@end
    @@printB:
        mov dl,[catB+bx]
        push dx
        call printNum
        inc bx
        cmp bx,9
        jnz @@printB
    @@end:
        pop dx
        pop bx
        ret
endp
proc printA
    push bx
    push dx
    mov bx,0
    cmp [catACount],0
    jz @@end
    @@printA:
        mov dl,[catA+bx]
        push dx
        call printNum
        inc bx
        cmp bx,9
        jnz @@printA
    @@end:
        pop dx
        pop bx
        ret
endp
proc printSortedGrades
    mov dl, 'C'
    call printDlChar
    call printSpace
    call printCCount
    call printC
    
    mov dl, 'B'
    call printDlChar
    call printSpace
    call printBCount
    call printB
    
    mov dl, 'A'
    call printDlChar
    call printSpace
    call printACount
    call printA
    
    mov dl, 'P'
    call printDlChar
    call printSpace
    mov dl,[evenGradesCount]
    push dx
    call printNum

    mov dl, 'E'
    call printDlChar
    call printSpace
    mov dl,[oddGradesCount]
    push dx
    call printNum
    
    lea dx,[avgStr]
    push dx
    call printString
    call printSpace
    
    mov dl,[avg]
    push dx
    call printNum

    ret
endp
; prints a number from dl if it's not 99, and then a space
proc printNum
    push bp
    mov bp, sp
    add sp, 2
    mov dx, [bp+4]
    cmp dl,99 ; check if it's 99
    jz @@end
    add dl,48 ; make that number a character
    mov ah, 02h
    int 21h
    call printSpace
    @@end:
    mov sp, bp
    pop bp
    ret 2
endp
; prints a string from dx
proc printString
    push bp
    mov bp, sp
    add sp, 2
    mov dx, [bp+4]
    mov ah, 09h
    int 21h
    mov sp, bp
    pop bp
    ret 2
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
    push ax
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    pop ax
    ret
endp
proc printSpace ;  prints a space to seperate between stuff
    mov dl, ' '
    call printDlChar
    ret
endp
proc sortGrades ; sorts grades to categories A,B,C accordingly
    mov al,[gradesLH+bx]
    cmp al,8
    jz @@addToA
    jg @@addToA
    cmp al,7
    jz @@addToB
    cmp al,6
    jz @@addToB
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
        push bx
        mov bx,0
        mov bl,[oddGradesCount]
        mov [oddGrades+bx],al
        pop bx
        inc [oddGradesCount]
        jmp @@end
    @@even:
        push bx
        mov bx,0
        mov bl,[evenGradesCount]
        mov [evenGrades+bx],al
        pop bx
        inc [evenGradesCount]
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
