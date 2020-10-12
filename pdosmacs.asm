print macro text
LOCAL WRITECONSOLE ;etiquetas
WRITECONSOLE:
	push ax
    push dx
    xor dx, dx
	MOV ah, 09h
	lea dx, text ;MOV dx, offset text
	int 21h	
	xor dx, dx
	xor ax, ax
    pop dx
	pop ax
endm

readchar macro
LOCAL READCONSOLE
READCONSOLE:
	MOV ah, 01h
	int 21h
endm

readtext macro array
	LOCAL Continue, End
	push si
	push ax
	xor si, si
	Continue:
		readchar
		CMP al, 0dh
		je End
		MOV array[si], al
		inc si
		jmp Continue

	End:
		MOV al, '$'
		MOV array[si], al

	pop ax
	pop si
endm

cleanarray macro array, size
	LOCAL Continue, End
	push si
	MOV cx, size
	Continue:
		xor si, si
		MOV si, cx
		sub si, 1
		MOV array[si], '$'
		loop Continue
	End:
	pop si
endm

cleanarraypath macro array, size
	LOCAL Continue, End
	push si
	MOV cx, size
	Continue:
		xor si, si
		MOV si, cx
		sub si, 1
		MOV array[si], 0
		loop Continue
	End:
	xor cx, cx
	pop si
endm

createfile macro buffer,handle
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	mov handle,ax
	jc OpenError
endm

openfile macro path, handler
	LOCAL Inicio
	xor ax, ax
	Inicio:
		mov ah, 3dh
		mov al, 10b
		lea dx, path
		int 21h
		mov handler, ax
		jc OpenError
endm

readfile macro numbytes,buffer,handle
	mov ah,3fh
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ReadError
endm

writefile macro nbytes, buffer, handler
	LOCAL Inicio
	xor ax, ax
	Inicio:
		mov ah, 40h
		mov bx, handler
		mov cx, nbytes
		lea dx, buffer
		int 21h
		jc WriteError
endm

closefile macro handler
	LOCAL Inicio
	xor ax, ax
	Inicio:
		mov ah, 3eh
		mov bx, handler
		int 21h
		jc CloseError
endm

numtostring macro buffer, numeroo
	LOCAL Divide, Divide2, EndCr,Negative, End
	push si
	push di
	push ax
	push dx
	xor si, si
	xor di, di
	xor cx, cx
	mov si, 000ah
	xor dx, dx
	mov ax, numeroo
	test ax, 1000000000000000
	jnz Negative
	jmp Divide2

	Negative:
		neg ax
		mov buffer[di], 45
		inc di
		jmp Divide2

	Divide:
		xor dx, dx

	Divide2:
		div si
		inc cx
		push dx
		cmp ax, 0000h
		je EndCr
		jmp Divide
	EndCr:
		pop dx
		add dx, 30h
		mov buffer[di], dx
		inc di
		;xor dx, dx
		loop EndCr
		mov dx, 24h
		mov buffer[di], dx
		inc di
		jmp End

	End:
		pop dx
		pop ax
		pop di
		pop si
endm

stringtonum macro buffer, argument
	LOCAL Inicio, Fin
	push ax
	push cx
	xor ax, ax
	xor cx, cx
	xor bx, bx
	mov bx, 10
	;xor si, si
	Inicio:
		mov cl, buffer[si]
		cmp cl, 48
		jl Fin
		cmp cl, 57
		jg Fin
		inc si
		sub cl, 48
		mul bx
		add ax, cx
		jmp Inicio
	Fin:
		mov argument, ax
		xor ax, ax
		pop cx
		pop ax
endm

sumax macro
	LOCAL Inicio, End
	Inicio:
		cmp ax, 0
			je End
		inc ax
		jmp End
	End:

endm

expresion macro
	LOCAL Inicio, Direccion, ValidAdd, ValidSub, ValidMul, ValidDiv, ValidId, Opsuma, Opresta, Opmult, Opdiv, Opnum, Isneg, Fixdiv, Opidini, Opid, Rid, Ereadid, Saveargoneid, Firstnegat, Secondnegat, Operar, Sumar, Resta, Multip, Divis, Dividir, Asigntosecond, Endone, EndE, Saveargone, Saveargtwo
	Inicio:
		inc si
		cmp readfilebuffer[si], '"'
            je Direccion
		cmp readfilebuffer[si], 0
            je EndE
		jmp Inicio
	Direccion:
	 	inc si
        cmp readfilebuffer[si], 'a'
        	je ValidAdd
        cmp readfilebuffer[si], '+'
    		je Opsuma
        cmp readfilebuffer[si], 's'
        	je ValidSub
        cmp readfilebuffer[si], '-'
            je Opresta
        cmp readfilebuffer[si], 'm'
            je ValidMul
        cmp readfilebuffer[si], '*'
            je Opmult
        cmp readfilebuffer[si], 'd'
            je ValidDiv
        cmp readfilebuffer[si], '/'
            je Opdiv
		cmp readfilebuffer[si], 'i'
            je ValidId
		cmp readfilebuffer[si], '#'
            je Opnum
		
		dec si
        jmp EndE
	
	ValidAdd:
        inc si
        cmp readfilebuffer[si], 'd'
            jne EndE
        inc si
        cmp readfilebuffer[si], 'd'
            je Opsuma
        jmp EndE
    ValidSub:
        inc si
        cmp readfilebuffer[si], 'u'
            jne EndE
        inc si
        cmp readfilebuffer[si], 'b'
            je Opresta
        jmp EndE
    ValidMul:
        inc si
        cmp readfilebuffer[si], 'u'
            jne EndE
        inc si
        cmp readfilebuffer[si], 'l'
            je Opmult
        jmp EndE
    ValidDiv:
        inc si
        cmp readfilebuffer[si], 'i'
        	jne EndE
        inc si
        cmp readfilebuffer[si], 'v'
            je Opdiv
        jmp EndE
	ValidId:
		inc si
		cmp readfilebuffer[si], 'd'
			je Opidini
		dec si
		jmp EndE
    Opsuma:
		
		sumax

		inc si
		mov operation, '+'
		push di
		xor di, di
		mov di, ax
		xor dx, dx
		mov dx, operation
		mov nargument[di], dx

		inc ax
		mov di, ax
		xor dx, dx
		mov dx, firstarg
		mov nargument[di], dx
		mov firstarg, 0000h

		inc ax
		mov di, ax
		xor dx, dx
		mov dx, secondarg
		mov nargument[di], dx
		mov secondarg, 0000h

		pop di

		;guardo que es suma
        jmp Endone
    Opresta:

		sumax

		inc si
		mov operation, '-'
		push di
		xor di, di
		mov di, ax
		xor dx, dx
		mov dx, operation
		mov nargument[di], dx

		inc ax
		mov di, ax
		xor dx, dx
		mov dx, firstarg
		mov nargument[di], dx
		mov firstarg, 0000h

		inc ax
		mov di, ax
		xor dx, dx
		mov dx, secondarg
		mov nargument[di], dx
		mov secondarg, 0000h

		;push si
            ;xor si, si
			;xor dx, dx
            ;mov dx, nargument[di]
			;add dx, 48
            ;mov msgresults[si], dx
            ;print msgresults
			;xor si, si
		;pop si

		pop di

		;guardo que es resta
        jmp Endone

    Opmult:
		
		sumax

		inc si
		mov operation, '*'
		push di
		xor di, di
		mov di, ax
		xor dx,dx
		mov dx, operation
		mov nargument[di], dx
		inc ax
		mov di, ax
		xor dx, dx
		mov dx, firstarg
		mov nargument[di], dx
		mov firstarg, 0000h
		inc ax
		mov di, ax
		xor dx, dx
		mov dx, secondarg
		mov nargument[di], dx
		mov secondarg, 0000h
		pop di

		;guardo que es mult
        jmp Endone
    Opdiv:
		sumax

		inc si
		mov operation, '/'
		push di
		xor di, di
		mov di, ax
		xor dx,dx
		mov dx, operation
		mov nargument[di], dx
		inc ax
		mov di, ax
		xor dx, dx
		mov dx, firstarg
		mov nargument[di], dx
		mov firstarg, 0000h
		inc ax
		mov di, ax
		xor dx, dx
		mov dx, secondarg
		mov nargument[di], dx
		mov secondarg, 0000h
		pop di

		;guardo que es div
        jmp Endone
		
	Opnum:

		inc si

		cmp readfilebuffer[si], '-'
		je Isneg
		cmp readfilebuffer[si], 48
		jl Opnum
		cmp readfilebuffer[si], 57
		jg Opnum
		
		;guardar numero
		cmp firstarg, 0000h
			je Saveargone
		jmp Saveargtwo

	Isneg:
		mov nuneg, 1b
		jmp Opnum
		
	Saveargone:

		stringtonum readfilebuffer, firstarg

		cmp nuneg, 1b
		je Firstnegat

		jmp Endone

	Firstnegat:
		neg firstarg
		mov nuneg, 0b
		jmp Endone

	Saveargtwo:

		stringtonum readfilebuffer, secondarg
		
		cmp nuneg, 1b
		je Secondnegat

		jmp Operar

	Secondnegat:
		neg secondarg
		mov nuneg, 0b
		jmp Operar

	Operar:

		mov temporalarg, 0000h
		;operar
		cmp operation, '+'
    		je Sumar
		cmp operation, '-'
			je Resta
		cmp operation, '*'
			je Multip
		;cmp readfilebuffer[si], '/'
		;	je Divis
		jmp Divis

	Sumar:
		;print prov 
		xor dx, dx
		mov dx, firstarg
		mov temporalarg, dx
		xor dx, dx
		mov dx, secondarg
		add temporalarg, dx
		jmp EndOperar
	Resta:
		;print prov 
		xor dx, dx
		mov dx, firstarg
		mov temporalarg, dx
		xor dx, dx
		mov dx, secondarg
		sub temporalarg, dx
		jmp EndOperar
	Multip:
		push si
		push ax
		xor dx, dx
		xor ax, ax
		mov ax, firstarg
		mov si, secondarg
		imul si
		mov temporalarg, ax
		xor si, si
		xor ax, ax
		pop ax
		pop si
		jmp EndOperar
	Divis:

		cmp firstarg, 0
		jl Fixdiv
		jmp Dividir
	Fixdiv:
		neg firstarg
		mov nuneg, 1b
		jmp Dividir
	Dividir:
		push si
		push ax
		xor dx, dx
		xor ax, ax
		mov ax, firstarg
		mov si, secondarg
		idiv si
		mov temporalarg, ax
		xor si, si
		xor ax, ax
		pop ax
		pop si
		cmp nuneg, 1b
		jne EndOperar
		neg temporalarg
		mov nuneg, 0b
		jmp EndOperar

	EndOperar:

		;cmp ax, 0002h
		;	je EndE

		push di

		mov firstarg, 0000h
		mov secondarg, 0000h
		
		dec ax
		xor di, di
		mov di, ax

		cmp nargument[di], 0000h
			jne Asigntosecond
		
		inc ax
		xor dx, dx
		mov dx, temporalarg
		mov firstarg, dx

		;sacar de mi pila de operaciones	
		xor di, di
		mov di, ax
		mov nargument[di], 0000h

		dec ax
		xor di, di
		mov di, ax
		mov nargument[di], 0000h

		dec ax
		xor di, di
		mov di, ax

		mov nargument[di], 0000h

		dec ax

		;asignar argumento a la operación padre
		dec ax
		dec ax
		xor di, di
		mov di, ax
		xor dx, dx
		mov dx, nargument[di]
		xor dh, dh
		mov operation, dx
		add ax, 2d

		;add temporalarg, 48

		;just printing
		;xor di, di
		;xor dx, dx
		;mov dx, temporalarg
		;mov msgresults[di], dx
		;print msgresults

		pop di
		jmp Endone

	Asigntosecond:
		
		xor dx, dx
		mov dx, temporalarg
		mov secondarg, dx

		xor dx, dx
		xor di, di
		mov di, ax
		mov dx, nargument[di]
		mov firstarg, dx

		inc ax

		;sacar de mi pila de operaciones	
		xor di, di
		mov di, ax
		mov nargument[di], 0000h

		dec ax
		xor di, di
		mov di, ax
		mov nargument[di], 0000h

		dec ax
		xor di, di
		mov di, ax
		mov nargument[di], 0000h
		
		dec ax
		;asignar argumento a la operación padre
		dec ax
		dec ax

		xor di, di
		mov di, ax
		xor dx, dx
		mov dx, nargument[di]
		xor dh, dh
		mov operation, dx

		add ax, 2d
		
		;add temporalarg, 48

		;just printing
		;xor di, di
		;xor dx, dx
		;mov dx, temporalarg
		;mov msgresults[di], dx
		;print msgresults

		pop di
		jmp Operar

    Opidini:
		inc si
		push di
		cleanarraypath temporalid, SIZEOF temporalid
		xor di, di
		xor dx, dx
		jmp Opid
	Opid:
		;advance to "
		inc si
		cmp readfilebuffer[si], '"'
		jne Opid
		jmp Rid
	Rid:
		;save id
		inc si
		cmp readfilebuffer[si], '"'
		je Ereadid
		xor dx, dx
		mov dl, readfilebuffer[si]
		mov temporalid[di], dx
		inc di
        jmp Rid
	Ereadid:

		inc si

		mov temporalid[di], ','
		;inc di
		;mov temporalid[di], '$'
		;print temporalid
		pop di

		;guardar numero
		cmp firstarg, 0000h
			je Saveargoneid

		getvalueid secondarg, simbols
	
		jmp Operar
		
	Saveargoneid:
		getvalueid firstarg, simbols
		jmp Endone

	Endone:
		jmp Inicio
	EndE:
endm

getvalueid macro argument, buffer
	LOCAL Inicioo, Inicioi, Found, Notfound, Foundini, Found, Foundneg, Endfound, Endidd
	
	Inicioo:

		push si
		push di
		push bx
		xor si, si
		xor di, di
		cleanarraypath obtnum, SIZEOF obtnum
		jmp Inicioi
	Inicioi:
		xor bx, bx
		mov bx, buffer[si]
		xor bh, bh
		cmp bx, 0
		je Endidd
		xor dx, dx
		mov dx, temporalid[di]
		xor dh, dh

		cmp bx, dx
		jne Notfound
		cmp bx, ','
		je Foundini

		;inc si
		inc si
		;inc di
		inc di
		jmp Inicioi
	
	Foundini:
		push di
		xor di, di
		jmp Found
	Found:
		inc si
		xor dx, dx
		mov dx, buffer[si]
		xor dh,dh
		cmp dx, '-'
		je Foundneg
		cmp dx, '.'
		je Endfound
		mov obtnum[di], dl
		inc di
		jmp Found
	Foundneg:
		mov nuneg, 1b
		jmp Found
	Endfound:
		inc di
		mov obtnum[di], '$'
		pop di

		xor si, si
		stringtonum obtnum, argument
		
		cmp nuneg, 1b
		jne Endidd

		mov nuneg, 0b
		neg argument

		jmp Endidd

	Notfound:
		inc si
		xor dx, dx
		mov dx, buffer[si]
		xor dh,dh
		cmp dx, 0
		je Endidd
		cmp dx, '.'
		jne Notfound
		xor di, di
		;inc si
		inc si
		jmp Inicioi
	Endidd:
		;print prov
		xor si, si
		xor di, di
		pop bx
		pop di
		pop si
endm

setvalueid macro buffer
	LOCAL Inicio, Fin
	push si
	xor si, si
	Inicio:
		cmp buffer[si], '$'
		je Fin
		xor dx, dx
        mov dx, buffer[si]
		xor dh, dh
        mov simbols[di], dx
		inc di
		inc si
		jmp Inicio
	Fin:
		pop si
endm

getavarage macro buffer, argument
	LOCAL Inicio, Continue, Foundini, Found, Foundneg, Endfound, Fin, Fixdiv, Dividir, Sumfound, FinFin
	Inicio:
		xor si, si
		xor di, di
		xor ax, ax
		xor cx, cx
	Continue:
		xor bx, bx
		mov bx, buffer[si]
		xor bh, bh
		cmp bx, 0
		je Fin
		cmp bx, ','
		je Foundini
		inc si
		jmp Continue
	
	Foundini:
		xor di, di
		jmp Found
	Found:
		inc si
		xor dx, dx
		mov dx, buffer[si]
		xor dh,dh
		cmp dx, '-'
		je Foundneg
		cmp dx, '.'
		je Endfound
		mov obtnum[di], dl
		inc di
		jmp Found
	Foundneg:
		mov nuneg, 1b
		jmp Found
	Endfound:
		inc di
		mov obtnum[di], '$'

		push si
		xor si, si
		stringtonum obtnum, argument
		pop si

		cmp nuneg, 1b
		jne Sumfound

		mov nuneg, 0b
		neg argument

		jmp Sumfound

	Sumfound:
		inc cx
		add ax, argument

		mov argument, 0000h
		jmp Continue

	Fin:
		cmp argument, 0
		jl Fixdiv
		jmp Dividir
	Fixdiv:
		neg argument
		mov nuneg, 1b
		jmp Dividir
	Dividir:
		push si
		xor si, si
		xor dx, dx
		mov si, cx

		idiv si
		mov argument, ax
		pop si
		cmp nuneg, 1b
		jne FinFin
		neg argument
		mov nuneg, 0b
		jmp FinFin
	FinFin:

endm

fillsimbolsnum macro buffer, argument
	LOCAL Inicio, Continue, Foundini, Found, Foundneg, Endfound, Fin, Sumfound
	Inicio:
		xor si, si
		xor di, di
		xor ax, ax
		xor cx, cx
	Continue:
		xor bx, bx
		mov bx, buffer[si]
		xor bh, bh
		cmp bx, 0
		je Fin
		cmp bx, ','
		je Foundini
		inc si
		jmp Continue
	
	Foundini:
		push di
		xor di, di
		jmp Found
	Found:
		inc si
		xor dx, dx
		mov dx, buffer[si]
		xor dh,dh
		cmp dx, '-'
		je Foundneg
		cmp dx, '.'
		je Endfound
		mov obtnum[di], dl
		inc di
		jmp Found
	Foundneg:
		mov nuneg, 1b
		jmp Found
	Endfound:
		inc di
		mov obtnum[di], '$'
		pop di

		push si
		xor si, si
		stringtonum obtnum, argument
		pop si

		cmp nuneg, 1b
		jne Sumfound

		mov nuneg, 0b
		neg argument

		jmp Sumfound

	Sumfound:
		xor dx, dx
		mov dx, argument
		mov simbolsnum[di], dx
		inc di
		inc di
		mov argument, 0000h
		jmp Continue

	Fin:
		mov simbolsnum[di], '$'
endm

orderit macro temp
	LOCAL Inicio, Iterar1, Iterar2, Change, Fin1, Fin2, Fin
	Inicio:
		xor si, si
		mov bx, di
		mov grate, bx
		sub grate, 2
		xor di, di
		jmp Iterar1
	Iterar1:
		xor di, di
		jmp Iterar2
	Iterar2:
		xor dx, dx
		mov dx, simbolsnum[di]
		cmp simbolsnum[si], dx
		jl Change
		jmp Fin2
	Change:
		xor dx, dx
		mov dx, simbolsnum[si]
		mov temp, 0000h
		mov temp, dx

		xor dx, dx
		mov dx, simbolsnum[di]
		mov simbolsnum[si], 0000h
		mov simbolsnum[si], dx

		xor dx, dx
		mov dx, temp
		mov simbolsnum[di], 0000h
		mov simbolsnum[di], dx
		jmp Fin2
	Fin2:
		inc di
		inc di
		cmp  di, bx
		jl Iterar2
		jmp Fin1
	Fin1:
		inc si
		inc si
		cmp  si, bx
		jl Iterar1
		jmp Fin
	Fin:
endm

getmode macro array
	LOCAL Inicio, Continue, Changecmp, Changeaux, Itera, Fin
	Inicio:
		xor cx, cx
		xor si, si
		mov contaux, 0000h
    	mov modaux, 0000h
		mov modaux2, 0000h
		xor dx, dx
		mov dx, array[si]
		mov modaux, dx
		xor dx, dx
		mov dx, array[si]
		mov modaux2, dx
		jmp Continue
	Continue:
		cmp array[si], '$'
		je Fin
		xor dx, dx
		mov dx, array[si]
		cmp modaux2, dx
		jne Changecmp
		inc cx
		jmp Itera
	Changecmp:
		cmp contaux, cx
		jl Changeaux
		xor dx, dx
		mov dx, array[si]
		mov modaux2, dx
		xor cx, cx
		inc cx
		jmp Itera
	Changeaux:
		xor dx, dx
		mov dx, modaux2
		mov modaux, dx
		mov contaux, cx
		xor dx, dx
		mov dx, array[si]
		mov modaux2, dx
		xor cx, cx
		inc cx
		jmp Itera
	Itera:
		inc si
		inc si
		jmp Continue
	Fin:
		
endm

getmedian macro
	LOCAL Inicio, Fixmed, Endmed
	Inicio:
		xor si, si
        xor dx, dx
        xor ax, ax
        mov ax, grate
        mov si, 2d

        idiv si

        mov di, ax

        xor dx, dx
        idiv si

        cmp dx, 0
        jne Fixmed

        jmp Endmed
    Fixmed:
        inc di
        jmp Endmed
    Endmed:
        xor bx, bx
        mov bx, simbolsnum[di]
		mov med, bx
endm

getmajor macro
	LOCAL Inicio
	Inicio:
		xor si, si
        mov si, grate
        mov dx, simbolsnum[si]
        mov temporalarg, dx
endm

getminor macro
	LOCAL Inicio
	Inicio:
		xor si, si
        mov dx, simbolsnum[si]
        mov temporalarg, dx
endm



;----------------------------REPORT MACROS-----------------------------


getdate macro
	mov ah,2ah
	int 21h
endm

gethour macro
	mov ah,2ch
	int 21h
endm

numtostring2 macro buffer, numeroo
	LOCAL Divide, Divide2, EndCr,Negative, End
	push si
	push di
	push ax
	push dx
	xor si, si
	xor di, di
	xor cx, cx
	mov si, 000ah
	xor dx, dx
	mov ax, numeroo
	test ax, 1000000000000000
	jnz Negative
	jmp Divide2

	Negative:
		neg ax
		mov buffer[di], 45
		inc di
		jmp Divide2

	Divide:
		xor dx, dx

	Divide2:
		div si
		inc cx
		push dx
		cmp ax, 0000h
		je EndCr
		jmp Divide
	EndCr:
		pop dx
		add dx, 30h
		mov buffer[di], dl
		inc di
		;xor dx, dx
		loop EndCr
		mov dx, 24h
		;mov buffer[di], dl
		inc di
		jmp End

	End:
		pop dx
		pop ax
		pop di
		pop si
endm

getdatetime macro
	LOCAL Inicio
	xor ax,ax
	xor bx,bx
	xor di, di
	xor dx, dx
	Inicio:
		getdate
		mov bx,cx
		;cleanarraypath anio, SIZEOF anio
		numtostring2 anio,bx

		getdate
		xor bx,bx
		mov bl,dh
		;cleanarraypath mes, SIZEOF mes
		numtostring2 mes,bx

		xor si, si
		mov dh, mes[si]
		mov mesp[si], dh
		inc si
		mov dh, mes[si]
		mov mesp[si], dh

		getdate
		xor bx,bx
		mov bl,dl
		;cleanarraypath dia, SIZEOF dia
		numtostring2 dia,bx


		gethour
		xor bx,bx
		mov bl,ch
		;cleanarraypath hora, SIZEOF hora
		numtostring2 hora,bx
		gethour
		xor bx,bx
		mov bl,cl
		;cleanarraypath minuto, SIZEOF minuto
		numtostring2 minuto,bx
		gethour
		xor bx,bx
		mov bl,dh
		;cleanarraypath second, SIZEOF second
		numtostring2 second,bx

endm

getresults macro 
	LOCAL Inicio
	Inicio:
		getavarage simbols, temporalarg
		numtostring2 avgg, temporalarg
		mov temporalarg, 0000h
		getmode simbolsnum
		numtostring2 modee, modaux
		mov modaux, 0000h
		getmedian
		numtostring2 medd, med
		mov med, 0000h
		getmajor
		numtostring2 majoo, temporalarg
		mov temporalarg, 0000h
		getminor
		numtostring2 minuu, temporalarg
		mov temporalarg, 0000h
endm

savefilereport macro
	LOCAL Inicio, Iterar, Continue, Foundini, Continue2, Foundini2, Fin
	Inicio:
		writefile SIZEOF inirep, inirep, handlefile
		writefile SIZEOF daterep, daterep, handlefile
		writefile SIZEOF diarep, diarep, handlefile
		writefile SIZEOF dia, dia, handlefile
		writefile SIZEOF commarep, commarep, handlefile
		writefile SIZEOF mesrep, mesrep, handlefile
		writefile SIZEOF mesp, mesp, handlefile
		writefile SIZEOF commarep, commarep, handlefile
		writefile SIZEOF anorep, anorep, handlefile
		writefile SIZEOF anio, anio, handlefile
		writefile SIZEOF findatarep, findatarep, handlefile



		writefile SIZEOF hourrep, hourrep, handlefile
		writefile SIZEOF hrep, hrep, handlefile
		writefile SIZEOF hora, hora, handlefile
		writefile SIZEOF commarep, commarep, handlefile
		writefile SIZEOF minrep, minrep, handlefile
		writefile SIZEOF minuto, minuto, handlefile
		writefile SIZEOF commarep, commarep, handlefile
		writefile SIZEOF segrep, segrep, handlefile
		writefile SIZEOF second, second, handlefile
		writefile SIZEOF findatarep, findatarep, handlefile



		writefile SIZEOF resurep, resurep, handlefile
		writefile SIZEOF avgrep, avgrep, handlefile

		writefile SIZEOF avgg, avgg, handlefile
		writefile SIZEOF commarep, commarep, handlefile

		writefile SIZEOF moderep, moderep, handlefile
		writefile SIZEOF modee, modee, handlefile
		writefile SIZEOF commarep, commarep, handlefile

		writefile SIZEOF medrep, medrep, handlefile
		writefile SIZEOF medd, medd, handlefile
		writefile SIZEOF commarep, commarep, handlefile

		writefile SIZEOF majerep, majerep, handlefile
		writefile SIZEOF majoo, majoo, handlefile
		writefile SIZEOF commarep, commarep, handlefile

		writefile SIZEOF minerep, minerep, handlefile
		writefile SIZEOF minuu, minuu, handlefile
		
		writefile SIZEOF findatarep, findatarep, handlefile


		writefile SIZEOF operep, operep, handlefile
		xor si, si
		jmp Iterar
	Iterar:
		xor bx, bx
		mov bx, simbols[si]
		xor bh, bh
		cmp bx, 0
		je Fin
		writefile SIZEOF inioprep, inioprep, handlefile
		writefile SIZEOF operaep, operaep, handlefile
		cleanarraypath opertemp, SIZEOF opertemp
		cleanarraypath resptemp, SIZEOF resptemp
		xor di, di
		jmp Continue
	Continue:
		xor bx, bx
		mov bx, simbols[si]
		xor bh, bh
		cmp bl, ','
		je Foundini
		mov opertemp[di], bl
		inc si
		inc di
		jmp Continue
		
	Foundini:
		writefile SIZEOF comilla, comilla, handlefile
		writefile SIZEOF opertemp, opertemp, handlefile
		writefile SIZEOF comilla, comilla, handlefile
		writefile SIZEOF dpuntos, dpuntos, handlefile
		inc si
		xor di, di
		jmp Continue2
	Continue2:
		xor bx, bx
		mov bx, simbols[si]
		xor bh, bh
		cmp bl, '.'
		je Foundini2
		mov resptemp[di], bl
		inc si
		inc di
		jmp Continue2
	Foundini2:
		writefile SIZEOF resptemp, resptemp, handlefile
		writefile SIZEOF nextoprep, nextoprep, handlefile
		inc si
		jmp Iterar
	Fin:
		writefile SIZEOF finopesrep, finopesrep, handlefile
		writefile SIZEOF finopesrep1, finopesrep1, handlefile
		writefile SIZEOF finopesrep2, finopesrep2, handlefile
endm