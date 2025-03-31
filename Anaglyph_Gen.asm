extern terminate
extern printStr
extern printStrLn
extern readImageFile
extern writeImageFile

SECTION .data

    scalar1: dd 0.299
    scalar2: dd 0.587
    scalar3: dd 0.114
    errorArguments: db "Numero de Argumentos invalido",10,0
    errorSize: db "O tamanho das imagens nao coincide",10,0
    errorArguments2: db "Deve inserir C ou M como argumento",10,0

SECTION .bss

    left_image: resb 1048576
    right_image: resb 1048576
    anaglyph: resb 1048576
    image_size: resd 1
    image_offset: resd 1
    
SECTION .text

default rel

global _start

_start:

    mov rbx, [rsp] ; numero de argumentos
    cmp rbx, 5
    jne _argError                                     
    
    mov rdi, [rsp+24] ; 1º nome do ficheiro left
    mov rsi, left_image ; tamanho eax?
    call readImageFile
    mov [image_size], rax
    
    mov rdi, [rsp+32]       ; 2º nome do ficheiro right
    mov rsi, right_image
    call readImageFile
    
    cmp [image_size], rax
    jne _sizeError      
    jmp _verifyArgument            
    
_argError:

    mov rdi, errorArguments
    call printStrLn
    jmp _end
    
_sizeError:
    
    mov rdi, errorSize
    call printStrLn
    jmp _end
    
_argError2:

    mov rdi, errorArguments2
    call printStrLn
    jmp _end
    
_verifyArgument:    
     
    mov rbx,[rsp + 16]                   
    mov bl, [rbx]
    cmp bl,'C'
    je _headerCopy                                                      
    cmp bl,'M'
    je _headerCopy
    jmp _argError2
 
_headerCopy:

    xor rbx,rbx
    
    mov eax, [left_image + 10]
    mov [image_offset], eax 
   
    xor rcx, rcx    
    mov edx, [image_offset]
    
_forHeader:

    cmp rcx, rdx
    jl _cicloHeader 
    jmp _argument 

_cicloHeader:
    
    mov al, [left_image + rcx]
    mov [anaglyph + rcx], al
    inc rcx
    jmp _forHeader

_argument:                                        
    mov edx, [image_size]
    mov ecx, [image_offset]
    mov rbx, [rsp + 16]
    mov bl, [rbx]
    cmp bl, 'C'
    je _forColor
    cmp bl, 'M'
    je _forMono                                                    
    jmp _argError2      

_forColor:
    xor rbx, rbx
    cmp rcx, rdx 
    jl _cicloColor 
    jmp _write
    
_cicloColor:
    
    mov al, [right_image + rcx]
    mov [anaglyph + rcx], al
    
    mov al, [right_image + rcx + 1]
    mov [anaglyph + rcx + 1], al
    
    mov al, [left_image + rcx + 2]
    mov [anaglyph + rcx + 2], al
    
    mov [anaglyph + rcx + 3], byte 255
    
    add rcx, 4
        
    jmp _forColor

_forMono:                                     
    
    xor rbx, rbx
    cmp rcx, rdx
    jl _cicloMono
    jmp _write
    
_cicloMono:

    mov bl, [right_image + rcx]
    cvtsi2ss xmm0, rbx ; azul
    mulss xmm0, [scalar3]
    
    mov bl, [right_image + rcx + 1]
    cvtsi2ss xmm1, rbx ; green
    mulss xmm1, [scalar2]
    
    mov bl, [right_image + rcx + 2]
    cvtsi2ss xmm2, rbx; red
    mulss xmm2, [scalar1]
    
    addss xmm0, xmm1
    addss xmm0, xmm2
    
    cvtss2si rax, xmm0
    mov [anaglyph + rcx], al
    mov [anaglyph + rcx + 1], al
    
    mov bl, [left_image + rcx]
    cvtsi2ss xmm0, rbx
    mulss xmm0, [scalar3]
    
    mov bl, [left_image + rcx + 1]
    cvtsi2ss xmm1, rbx
    mulss xmm1, [scalar2]
    
    mov bl, [left_image + rcx + 2]
    cvtsi2ss xmm2, rbx
    mulss xmm2, [scalar1]
    
    addss xmm0, xmm1
    addss xmm0, xmm2
    
    cvtss2si rax, xmm0
    mov [anaglyph + rcx + 2], al
    
    mov [anaglyph + rcx + 3], byte 255
    
    add rcx, 4
    
    jmp _forMono
    
    
_write:

    mov rdi, [rsp+40]
    mov rsi, anaglyph
    mov rdx, [image_size]
    call writeImageFile                 

_end:
    mov rax, 60
    xor rdi, rdi
    syscall