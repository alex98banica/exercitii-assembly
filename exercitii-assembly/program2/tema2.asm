extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TODO TASK 1
        push ebp
        mov ebp, esp

        
looop:
        mov dl,byte[eax]
        mov bl,byte[ecx]
        xor bl,dl
        mov byte[ecx],bl
        inc ecx
        inc eax
        cmp byte[ecx],0
        
        jne looop
        
        push ecx
        leave
        ret
                


rolling_xor:
        push ebp
        mov ebp, esp
        
        push ecx
        call strlen
        pop ecx
        add ecx,eax
       dec ecx
        
looop2:
        mov dl,byte[ecx]
        mov bl,byte[ecx-1]              
        xor dl,bl
        mov byte[ecx],dl
        dec eax
        dec ecx
        cmp eax,1  
        jne looop2
        mov ecx,[ebp+8] 
        push ecx
        leave           
        ret

xor_hex_strings:

	push ebp
        mov ebp,esp

        mov ecx,[ebp+8]
        mov eax,[ebp+12]
        
        mov edi, ecx
        xor esi,esi
        xor edx,edx
        xor ebx, ebx
        
        
        
formstr:        
        mov dl,byte[ecx]               ;formez noul string
        cmp dl,0
        je reset
        cmp dl,'a'
        jge label1
        sub dl,'0'
inapoi1:        
        mov bl,byte[ecx+1]
        cmp bl,'a'
        jge label2

        sub bl,'0'
        
inapoi2:        
        add ecx,2
        shl dl,4
        add dl,bl
        mov byte[edi+esi],dl
        inc esi
        jmp formstr
    
reset:                                                ;reinitializez esi si mut stringul schimbat in ecx punand 0 cand se termina
        mov byte[edi+esi],0
        mov ecx,edi
        xor esi,esi
        mov edi, eax
        jmp formcheie            
        
formcheie:                                        ;formez noua cheie   
        mov dl,byte[eax]
        cmp dl,0
        je preg
        cmp dl,'a'
        jge label3
        sub dl,'0'
inapoi3:        
        mov bl,byte[eax+1]
        cmp bl,'a'
        jge label4
        sub bl,'0'
inapoi4:        
        add eax,2
        shl dl,4
        add dl,bl
        mov byte[edi+esi],dl
        inc esi
        jmp formcheie
        
preg:                                                           ;mut cheia schimbata in eax punand 0 la final
        mov byte[edi+esi],0
        mov eax,edi
        xor esi, esi
        jmp xorrr       
        
xorrr:        
        mov dl,byte[eax+esi]                                    ;xor intre strin si cheie
        mov bl,byte[ecx+esi]
        xor bl,dl
        mov byte[ecx+esi],bl
        inc esi
        cmp byte[ecx+esi],0
        jne xorrr
        jmp final        
        
label1:
        sub dl,87 ;(-97+10 FROM HEXA)
        jmp inapoi1
label2:
        sub bl,87 ;(-97+10 FROM HEXA)
        jmp inapoi2
label3:
        sub dl,87 ;(-97+10 FROM HEXA)
        jmp inapoi3
label4:
        sub bl,87 ;(-97+10 FROM HEXA)
        jmp inapoi4        
                
        
final:
    mov [ebp + 8], ecx
    mov [ebp + 12], eax
    leave 
    ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
	ret

decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp, esp
        
        push ecx
        call strlen
        pop ecx
        add eax,ecx
        inc eax
        
        xor edx,edx
       
loop6:
        mov bl,byte[eax+edx]
                       
        cmp byte[ecx],0
        je sf   
        cmp byte[ecx],'a'                   ;daca nu e litera trec pa byte-ul urmator
        jl maideparte
        cmp byte[ecx],'z'
        jg maideparte
        
        sub bl,'a'                          ;formez cate un byte din cheie si il scad la un byte din string
        sub byte[ecx],bl
        cmp byte[ecx],'a'
        jge continue
        jl increment
        
        
continue:        
        inc edx
        inc ecx

        cmp byte[eax + edx],0               ;verific daca a ajuns la finalul cheii
        je resetcheie 
        jne loop6        
        
        
increment:        
        add byte[ecx],26                    ;adun daca e nevoie sa iau alfabetul de la capat
        inc ecx
        inc edx
        
        cmp byte[eax+edx],0
        je resetcheie
        cmp byte[eax+edx],0
        jne loop6
        
      
        
resetcheie:
        xor edx,edx                            
        jmp loop6
        
maideparte:
        inc ecx
        jmp loop6        
        
sf:       
        leave
	ret

main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
        push ecx
        call strlen
        pop ecx
        add eax,ecx
        add eax,1

        push eax        
        push ecx
        call xor_strings
        pop ecx
                      
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:       

        push ecx
        call rolling_xor
        pop ecx

	push ecx
	call puts
	add esp, 4

	jmp task_done

task3:


        push ecx
        call strlen
        pop ecx
        add eax,ecx
        inc eax
        
        push eax
        push ecx
        call xor_hex_strings
        pop ecx
        pop eax

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function

	push ecx                    ;print resulting string
	call puts
	pop ecx

	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:


	push eax 
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
        pop eax
	

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
