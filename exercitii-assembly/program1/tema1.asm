%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
	expr: resb MAX_INPUT_SIZE
section .data
        verif db 0
section .text
global CMAIN
CMAIN:

        push ebp
        mov ebp, esp
        mov ebx,1
        mov eax,1
        mov edx,0
        GET_STRING expr, MAX_INPUT_SIZE
        mov ecx,0

BODY:
        movzx eax,byte[expr+ecx]
        movzx ebx,byte[expr+ecx+1]
        inc ecx
    
        cmp eax,' '
        je adaugastiva
        cmp eax , '+'
        je adunare
        cmp eax , '-'
        je check
        cmp eax , '*'
        je inmultire
        cmp eax , '/'
        je impartire
        cmp eax,0
        je done

        cmp byte[verif],1
        jne nrpoz
        cmp byte[verif],1
        je nrneg
        
nrpoz:
        imul edx,10
        sub eax,48
        add edx,eax
        jmp BODY
        
nrneg:
        imul edx,10
        sub eax,48
        imul eax,-1
        add edx,eax
        jmp BODY 
        
adaugastiva:
        push edx
        mov edx,0
        mov byte[verif],0
        jmp BODY
        

adunare:
        mov edx,0
        mov ebx,0
        pop edx
        pop ebx 
        add edx,ebx
        push edx
        mov ebx,0
        mov edx,0
        inc ecx
        jmp BODY
        
check:
        cmp ebx,' '
        je scadere
        cmp ebx,0
        je scadere
        cmp ebx ,' '
        jne condnrneg
        
condnrneg:
        mov byte[verif],1
        jmp BODY
          
scadere:
        mov edx,0
        mov ebx,0
        pop edx
        pop ebx 
        sub ebx,edx
        push ebx
        mov ebx,0
        mov edx,0
        inc ecx
        jmp BODY
        
inmultire:       
        mov edx,0
        mov ebx,0
        pop edx
        pop ebx 
        imul ebx,edx
        push ebx
        mov ebx,0
        mov edx,0
        inc ecx
        jmp BODY
        
impartire:
        mov eax,0
        mov edx,0
        mov ebx,0
        pop ebx
        pop edx
        mov eax,edx 
        mov edx,0
        cdq
        idiv ebx
        push eax
        mov ebx,0
        mov eax,0
        mov edx,0
        inc ecx
        jmp BODY
        
done:
        pop edx
        PRINT_DEC 4,edx
	xor eax, eax
	pop ebp
	ret
