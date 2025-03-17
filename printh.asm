global printh

;//////// This is a working replica of stdlib printf with reduced functionality (less specifiers)
;////////

printh: 

    pop rax
    mov [lostIP], rax
    xor rax, rax

    push r9
    push r8
    push rcx
    push rdx
    push rsi
    push rdi

    pop rsi

    xor rcx, rcx ; QUESTIONABLE

MainReadingLoop:

    cmp byte [rsi], TerminatorASCII
    je MainReadingLoopEnd

    cmp byte [rsi], PercentASCII
    je IsSpecifier

    mov rax, [rsi]
    push rbx 
    mov rbx, rax
    ;mov [MessageBuffer + rcx], rax
    ;inc rcx
    call PrintToBuffer
    pop rbx

    inc rsi

    jmp MainReadingLoop

IsSpecifier:
    inc rsi 

    cmp byte [rsi], PercentASCII
    je PercentS

    xor rax, rax
    mov al, byte [rsi]
    sub al, aSCII
    shl al, 3
    jmp [JumpTable + rax]

PercentS:
    push rbx 
    xor rbx, rbx
    mov bl, PercentASCII
    ;mov byte [MessageBuffer + rcx], PercentASCII
    ;inc rcx
    call PrintToBuffer
    pop rbx
    inc rsi
    jmp MainReadingLoop


speA:

speB:
    pop rax
    xor rdx, rdx
    mov rdx, 0x20

InsigSkip:

    mov rbx, rax
    shr rbx, 0x1F
    and rbx, FirstBitMask
    

    cmp rbx, 0x01
    je InsigSkipEnd

    cmp rdx, 0x00
    je AllZerosInBinary

    shl rax, 1

    dec rdx

    jmp InsigSkip

InsigSkipEnd:
    add bl, zeroASCII
    ;mov byte[MessageBuffer + rcx], bl 
    call PrintToBuffer
    shl rax, 1 
    dec rdx 
    ;inc rcx
    jmp PrintBin

PrintBin:

    cmp rdx, 0x00
    je PrintBinEnd

    mov rbx, rax
    shr rbx, 0x1F
    and rbx, FirstBitMask

    add rbx, zeroASCII

    ;mov byte [MessageBuffer + rcx], bl
    ;inc rcx
    call PrintToBuffer

    shl rax, 1

    dec rdx

    jmp PrintBin

AllZerosInBinary:
    xor rbx, rbx 
    add bl, zeroASCII
    ;mov byte [MessageBuffer + rcx], bl 
    ;inc rcx 
    call PrintToBuffer
    inc rsi
    jmp MainReadingLoop

PrintBinEnd:
    inc rsi
    jmp MainReadingLoop

speC:   
    xor rbx, rbx
    pop rbx
    call PrintToBuffer
    ;mov byte [MessageBuffer + rcx], al
    ;inc rcx
    inc rsi
    jmp MainReadingLoop

speD:
    pop rax     ; arg is in rax
    xor r8, r8
    xor rbx, rbx 
    mov ebx, 0xA

    test rax, Sign32bitMask
    jnz SignedIntPrint

RemainderLoopDec:
    xor rdx, rdx 

    div ebx
    add edx, zeroASCII 
    push rdx

    inc r8

    cmp eax, 0x00 
    jne RemainderLoopDec

PrintDec:
    cmp r8, 0x00
    je PrintDecEnd
    pop rdx
    push rbx 
    xor rbx, rbx
    mov bl, dl 

    ;mov byte [MessageBuffer + rcx], dl 
    ;inc rcx 

    call PrintToBuffer
    
    pop rbx

    dec r8

    jmp PrintDec

SignedIntPrint:
    push rbx 
    xor rbx, rbx 
    mov bl, minusASCII
    call PrintToBuffer
    ;mov byte [MessageBuffer + rcx], minusASCII
    ;inc rcx
    pop rbx
    neg rax
    jmp RemainderLoopDec

PrintDecEnd:
    inc rsi
    jmp MainReadingLoop










speE:
speF:
speG:
speH:
speI:
speJ:
speK:
speL:
speM:
speN:
    mov rax, [byteCounter]
    push rax 
    jmp speD

speO: 
    pop rax 

    push rbx 
    xor rbx, rbx
    mov bl, zeroASCII
    call PrintToBuffer
    pop rbx

    xor rbx, rbx
    mov rbx, rax 
    shr rbx, 0x1E
    cmp bl, 0x00
    je FirstZeroOctal

    jmp FirstSignificantOctal

    FirstZeroOctal:
    mov rdx, 0xA
    shl rax, 0x02
    jmp SkipInsigOct

    FirstSignificantOctal:
    mov rbx, rax
    shr rbx, 0x1F
    add bl, zeroASCII
    call PrintToBuffer

    mov rdx, 0xA

    shl rax, 0x02
    jmp PrintOctal

SkipInsigOct:
    cmp rdx, 0x00
    je AllZerosInOct

    mov rbx, rax 
    shr rbx, 0x1D

    cmp bl, 0x00
    jne PrintOctal

    shl rax, 0x03
    dec rdx

    jmp SkipInsigOct

PrintOctal:
    cmp rdx, 0x00
    je PrintOctalEnd

    mov rbx, rax 
    shr rbx, 0x1D

    shl rax, 0x03

    and bx, OctBitMask 
    add bx, zeroASCII
    call PrintToBuffer
    dec dx

    jmp PrintOctal

PrintOctalEnd:
    inc rsi 
    jmp MainReadingLoop

AllZerosInOct:
    push rbx
    mov bl, zeroASCII
    call PrintToBuffer 
    pop rbx
    inc rsi
    jmp MainReadingLoop



speP:
speQ:
speR: 


speS:
    pop rax 
SCopy:
    cmp byte [rax], TerminatorASCII
    je SCopyend

    mov bl, byte [rax]
    call PrintToBuffer
    inc rax

    jmp SCopy

SCopyend:
    inc rsi
    jmp MainReadingLoop

speT:
speU:
speV:
speW:

speX:
    pop rax 
    push rbx 
    xor rbx, rbx
    mov bl, zeroASCII
    call PrintToBuffer
    mov bl, xASCII,
    call PrintToBuffer
    pop rbx
    ;mov byte [MessageBuffer + rcx], zeroASCII
    ;inc rcx 
    ;mov byte [MessageBuffer + rcx], xASCII
    ;inc rcx

    mov rdx, 0x08

SkipInsigHex:
    cmp rdx, 0x00
    je AllZerosInHex

    mov rbx, rax 
    shr rbx, 0x1C

    cmp bl, 0x00
    jne PrintHex

    shl rax, 0x04
    dec rdx

    jmp SkipInsigHex

PrintHex:
    cmp rdx, 0x00
    je PrintHexEnd

    mov rbx, rax 
    shr rbx, 0x1C

    ;shl rax, 0x04
    and bx, HexBitMask ; UNDERSTAND ERROR PLEASE
    cmp bl, 0x09
    jg PrintLitHex

    jmp PrintNumHex

PrintHexEnd:
    inc rsi 
    jmp MainReadingLoop

AllZerosInHex:
    push rbx 
    mov bl, zeroASCII
    call PrintToBuffer
    ;mov byte [MessageBuffer + rcx], zeroASCII
    ;linc rcx 
    pop rbx
    inc rsi
    jmp MainReadingLoop

PrintNumHex:    
    add bl, zeroASCII
    ;mov byte [MessageBuffer + rcx], bl 
    ;inc rcx 
    call PrintToBuffer
    dec rdx

    shl rax, 0x04

    jmp PrintHex

PrintLitHex: 
    sub bl, 0xA
    add bl, CapitalAascii
    call PrintToBuffer
    ;mov byte [MessageBuffer + rcx], bl 
    ;inc rcx
    dec rdx 

    shl rax, 0x04

    jmp PrintHex

speY:
speZ:

PrintToBuffer: 
    inc qword [byteCounter]
    push rax 
    mov rax, [byteCounter]
    cmp rax, [BufferLength]
    jg MainReadingLoopEnd 
    pop rax                                 ; срешь в стек
    mov byte [MessageBuffer + rcx], bl 
    inc rcx
    ret

MainReadingLoopEnd:

    mov rax, 0x01
    mov rsi, MessageBuffer
    mov rdi, 0x01
    mov rdx, rcx 
    syscall

    mov rax, [lostIP]
    push rax 
    mov rax, 0x00
    ret

section .data

tenBin          equ 1010b
Last32BitMask   equ 0x80000000
FirstBitMask    equ 1b 
HexBitMask      equ 1111b
OctBitMask      equ 111b
zeroASCII       equ 0x30
onwASCII        equ 0x31
CapitalAascii   equ 0x41
minusASCII      equ 0x2d
aSCII           equ 0x61
cASCII          equ 0x63
xASCII          equ 0x78
zASCII          equ 0x7A
Sign32bitMask   equ 1000000000000000b


TerminatorASCII equ 0x00
PercentASCII    equ 0x25
retCode db 0x00
lostIP dq 0x00
byteCounter dq 0x00
JumpTable dq speA, speB, speC, speD, speE, speF, speG, speH, speI, speJ, speK, speL, speM, speN, speO, speP, speQ, speR, speS, speT, speU, speV, speW, speX, speY, speZ
BufferLength dq 0x0200
MessageBuffer: db 0x0200 dup(0)