;------------------MACROS-----------------------
include pdosmacs.asm

.model small
.stack 100h 
.data
;------------------- SEGMENTO DE DATOS ------------------------------
;---header
    titl db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',0ah,0dh,'FACULTAD DE INGENIERIA CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',0ah,0dh,'NOMBRE: MIGUEL ESTEBAN ALVARADO MONOROY',0ah,0dh,'CARNET: 201800587',0ah,0dh,'SECCION: A',0ah,0dh,'$'
    opts db 0ah,0dh,'Options:',0ah,0dh,'1.Load File',0ah,0dh,'2.Console',0ah,0dh,'3.Exit',0ah,0dh,'_________________________________________________',0ah,0dh,'$'
    optshow db 0ah,0dh,'Show:',0ah,0dh,'1.ID',0ah,0dh,'2.Avarage',0ah,0dh,'3.Mode',0ah,0dh,'4.Median',0ah,0dh,'5.Major',0ah,0dh,'6.Minor',0ah,0dh,'7.Report',0ah,0dh,'8.Exit',0ah,0dh,'_________________________________________________',0ah,0dh,'$'
    msgop db 0ah,0dh,'Enter Operation:',0ah,0dh,'$'
    msgavd db 0ah,0dh,'Avarage:',0ah,0dh,'$'
    msgmode db 0ah,0dh,'Mode:',0ah,0dh,'$'
    msgmed db 0ah,0dh,'Median:',0ah,0dh,'$'
    msgmaj db 0ah,0dh,'Major:',0ah,0dh,'$'
    msgmin db 0ah,0dh,'Minor:',0ah,0dh,'$'
;---end header
;---read json
    msgruta db 0ah,0dh,'Enter path:',0ah,0dh,'$'
    msgendread db 0ah,0dh,'File has been read!',0ah,0dh,'$'
    namebuffer db 300 dup(0),0
    readfilebuffer db 30000 dup(0),0
    simbols dw 5000 dup(0),0
    simbolsnum dw 500 dup(0),0
    nargument dw 600 dup(0),0
    nuneg db 0b
    firstarg dw 0000h
    secondarg dw 0000h
    temporalarg dw 0000h
    msgresults dw 0000h, '$'
    operation dw 0000h
    temporalid dw 15 dup (0), 0
    parsednum dw 6 dup(0),0
    obtnum db 6 dup(0),0
    numero dw 2 dup(0), 0
    grate dw 0h
    contaux dw 0000h
    contaux2 dw 0000h
    modaux dw 0000h
    modaux2 dw 0000h
;--- end read json
;---results
    avgg db 6 dup(0),0
    modee db 6 dup(0),0
    med dw 0000h
    medd db 6 dup(0),0
    majoo db 6 dup(0),0
    minuu db 6 dup(0),0
    opertemp db 15 dup (0), 0
    resptemp db 6 dup(0),0
;---EndResults
;---FILE---
    erroropenf db 0ah,0dh, 'Open Error','$'
    errorclosef db 0ah,0dh, 'Close Error','$'
    errorreadf db 0ah,0dh, 'Read Error','$'
    errorwrite db 0ah,0dh, 'Write Error','$'
    saltoll db 0ah,0dh
    handlefile dw ?
;---End FILE---
;---Report---

    namerep db 'report.jso','$'

    inirep db 0ah,0dh,'{',0ah,0dh,09h,'"report":{',0ah,0dh,09h,09h,'"alumno":{',0ah,0dh,09h,09h,09h,'"nombre":"Miguel Alvarado",',0ah,0dh,09h,09h,09h,'"carnet":201800587,',0ah,0dh,09h,09h,09h,'"seccion":"A",',0ah,0dh,09h,09h,09h,'"curso":"ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1"',0ah,0dh,09h,09h,'},'
    
    daterep db 0ah,0dh,09h,09h,'"date":{'
    diarep db 0ah,0dh,09h,09h,09h,'"day":'
    mesrep db 0ah,0dh,09h,09h,09h,'"month":'
    anorep db 0ah,0dh,09h,09h,09h,'"year":' 

    hourrep db 0ah,0dh,09h,09h,'"Hour":{'
    hrep db 0ah,0dh,09h,09h,09h,'"hour":'
    minrep db 0ah,0dh,09h,09h,09h,'"min":'
    segrep db 0ah,0dh,09h,09h,09h,'"sec":'

    resurep db 0ah,0dh,09h,09h,'"results":{'
    avgrep db 0ah,0dh,09h,09h,09h,'"avarage":'
    medrep db 0ah,0dh,09h,09h,09h,'"median":'
    moderep db 0ah,0dh,09h,09h,09h,'"mode":'
    minerep db 0ah,0dh,09h,09h,09h,'"min":'
    majerep db 0ah,0dh,09h,09h,09h,'"maj":'
    commarep db ','
    findatarep db 0ah,0dh,09h,09h,'},'

    operep db 0ah,0dh,09h,09h,'"operations":['
    inioprep db 0ah,0dh,09h,09h,09h,'{'
    operaep db 0ah,0dh,09h,09h,09h,09h
    comilla db '"'
    dpuntos db ':'
    nextoprep db 0ah,0dh,09h,09h,09h,'},'
    finoprep db 0ah,0dh,09h,09h,09h,'}'
    finopesrep db 0ah,0dh,09h,09h,']'
    finopesrep1 db 0ah,0dh,09h,'}'
    finopesrep2 db 0ah,0dh,'}'
;---EndReport---
;---Datetime
    dia db 0,0,0
	mes db 0,0,0
	mesp db 0,0,0
	anio db 0,0,0,0,0
	hora db 0,0,0
	minuto db 0,0,0
	second db 0,0,0
;---EndDatetime
;---proves
    prov db 0ah,0dh,'Entra','$'
;---end proves
;-------------------segmento de código-------------------------------
.code
    main proc
        MOV dx,@data
		MOV ds,dx 
		print titl

        Initprogram:

            ;TESTING IF NUM TO ARRAY WORKS
            ;cleanarraypath parsednum, SIZEOF parsednum
            ;xor di, di
            ;mov numero[di], 245d
            ;numtostring parsednum, numero[di]
            ;print parsednum
            ;xor di, di

            print opts

            readchar
            CMP al, '1'
			je Readjson
			CMP al, '2'
			je Consoler
			CMP al, '3'
			je Salir

			jmp Initprogram
 ;------------------------------------------------------------Readjson option---------------------------------------------------------------------
        Readjson:
            ;READ JSON
            print msgruta
            cleanarraypath namebuffer, SIZEOF namebuffer
            cleanarraypath readfilebuffer, SIZEOF readfilebuffer
            readtext namebuffer
            openfile namebuffer, handlefile
			readfile SIZEOF readfilebuffer, readfilebuffer, handlefile
			closefile handlefile
            ;END READ JSON

            ;reseting stuff
            xor di, di
            cleanarraypath simbols, SIZEOF simbols ;reseting simbols
            ;end reseting stuff
            xor si, si
            jmp Lexical ; sending to lexic test

        Lexical: ;LEXICAL ANALISYS OF THE JSON FILE
            cmp readfilebuffer[si], '['
            je Lexinit
            cmp readfilebuffer[si], 0
            je Endreadjson
            inc si
            jmp Lexical
        
        Lexinit:
            cmp readfilebuffer[si], 0
            je Endreadjson
            cmp readfilebuffer[si], '"'
            je Lexoption
            inc si
            jmp Lexinit

        Lexoption:
            inc si
            jmp Ident
        
        Ident:
            cmp readfilebuffer[si], '"'
            je Endident
            xor dx, dx
            mov dl, readfilebuffer[si]
            mov simbols[di], dx
            inc di
            inc si
            jmp Ident

        Endident:
            mov simbols[di], ','

            inc si
            xor ax, ax
            mov firstarg, 0000h
            mov secondarg, 0000h
            mov temporalarg, 0000h
            
            expresion
            
            ;mov simbols[di], '.'
            ;inc di

            ;just printing
            print prov
            
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, temporalarg
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di

            inc di
            setvalueid parsednum
            mov simbols[di], '.'
            inc di

            ;mov simbols[di], '$'
            ;print simbols
            ;mov simbols[di], 0

            jmp Lexinit
            ;jmp Endreadjson

        Endreadjson:
            print msgendread
            jmp Initprogram

        OpenError:
			print erroropenf
			jmp Initprogram

		ReadError:
			print errorreadf
			jmp Initprogram

        WriteError:
			print errorwrite
			jmp Initprogram

	    CloseError:
			print errorclosef
			jmp Initprogram
 ;---------------------------------------------------------------Console option----------------------------------------------------------------------
        Consoler:

            cleanarraypath simbolsnum, SIZEOF simbolsnum
            fillsimbolsnum simbols, temporalarg
            mov temporalarg, 0000h
            orderit temporalarg
            mov temporalarg, 0000h

            print optshow

            readchar
            CMP al, '1'
			je Sid
			CMP al, '2'
			je Savg
			CMP al, '3'
			je Smode
            CMP al, '4'
			je Smedian
            CMP al, '5'
			je Smajor
            CMP al, '6'
			je Sminor
            CMP al, '7'
			je Sreport
            CMP al, '8'
			je Sexit

			jmp Consoler

        Sid:
            print msgop
            cleanarraypath temporalid, SIZEOF temporalid
            cleanarraypath namebuffer, SIZEOF namebuffer
            readtext namebuffer
            xor si, si
            xor dx, dx
            jmp Sidparse
        Sidparse:
            cmp namebuffer[si], '$'
            je Sobatainid
            mov dl, namebuffer[si]
            mov temporalid[si], dx
            inc si
            jmp Sidparse
        Sobatainid:
            mov temporalid[si], ','

            getvalueid temporalarg, simbols

            ;just printing
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, temporalarg
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di

            cleanarraypath temporalid, SIZEOF temporalid
            mov temporalarg, 0000h
            jmp Consoler
        Savg:

            getavarage simbols, temporalarg
            ;just printing
            print msgavd
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, temporalarg
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di
            mov temporalarg, 0000h

            jmp Consoler
        Smode:

            getmode simbolsnum

            ;just printing
            print msgmode
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, modaux
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di

            mov temporalarg, 0000h
            jmp Consoler
        Smedian:

            getmedian
            ;just printing
            print msgmed
            cleanarraypath parsednum, SIZEOF parsednum
            xor bx, bx
            mov bx, med
            numtostring parsednum, bx
    
            print parsednum
            jmp Consoler
        Smajor:

            getmajor

            ;just printing
            print msgmaj
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, temporalarg
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di
            mov temporalarg, 0000h
            jmp Consoler
        Sminor:
            getminor
            
            ;just printing
            print msgmaj
            push di
            cleanarraypath parsednum, SIZEOF parsednum
            xor di, di
            mov numero[di], 0000h
            xor dx, dx
            mov dx, temporalarg
            mov numero[di], dx
            numtostring parsednum, numero[di]
    
            print parsednum
            
            xor di, di
            pop di
            mov temporalarg, 0000h
            jmp Consoler
        Sreport:
            cleanarraypath namebuffer, SIZEOF namebuffer
            readtext namebuffer
            createfile namebuffer, handlefile
            openfile namebuffer, handlefile
            getdatetime
            getresults
            savefilereport
			closefile handlefile
            jmp Consoler
        Sexit:
            jmp Initprogram
 ;---------------------------------------------------------------Exit option------------------------------------------------------------------------
		Salir: 
			MOV ah,4ch
			int 21h


    main endp
end
