*-----------------------------------------------------------
* Title      : PRAFIN22
* Written by : Iván Gómez y Luis Jover 
* Date       : 30/05/2022
* Description: Emulador de la JARVIS
*-----------------------------------------------------------
    ORG $1000
EMEM:   DC.W $2800,$2A03,$50E0,$0B60,$5114,$0C70,$1430,$0E40,$7140,$3001,$32FF,$90D0
        DC.W $8020,$C000,$0002,$0003,$0001,$0003,$0002,$0004,$0000,$0000,$0000
EIR:    DC.W 0 ;eregistro de instruccion
EPC:    DC.W 0 ;econtador de programa
EB0:    DC.W 0 ;eregistro B0
EB1:    DC.W 0 ;eregistro B1
ER2:    DC.W 0 ;eregistro R2
ER3:    DC.W 0 ;eregistro R3
ER4:    DC.W 0 ;eregistro R4
ER5:    DC.W 0 ;eregistro R5
ET6:    DC.W 0 ;eregistro T6
ET7:    DC.W 0 ;eregistro T7
ESR:    DC.W 0 ;eregistro de estado (00000000 00000ZCN)

START:
    CLR.W EPC

FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC,
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	
	    ; ESCRIBID VUESTRO CODIGO AQUI    
	    
	MOVE.W EPC, A6
    ADD.W A6, A6   ;multiplicamos *2
	MOVE.W EMEM(A6), EIR
	ADDQ.W #1, EPC	    
	    
        
    ;--- FFETCH: FIN FETCH
    
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

    	; ESCRIBID VUESTRO CODIGO AQUI
    	    
    SUBQ.L #2, A7
    MOVE.W EIR, -(A7)
    JSR DECOD
    
    
    MOVE.W (A7)+, EIR  ;sacamos EIR
    MOVE.W (A7)+, D1 ;hacemos pop del resultado de la pila dejandola vacia
    	
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ETRA
    JMP EADD
    JMP ESUB
    JMP ENAN
    JMP ESTC
    JMP EINC
    JMP ELOA
    JMP ELOAX
    JMP ESTO
    JMP ESTOX
    JMP EBRI
    JMP EBRZ
    JMP EBRN
    JMP ESTP
    
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
	
	; ESCRIBID EN CADA ETIQUETA LA FASE DE EJECUCION DE CADA INSTRUCCION
	
ETRA:
    MOVE.W EIR, D5
    JSR CogerA
    MOVE.W A5, A0 ;A0 contiene la dirección efectiva del registro aaa
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1 ;A1 contiene la dirección efectiva del registro bbb
    
    MOVE.W (A0), (A1)
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0005, D7
    MOVE.W D7, ESR
        
    BRA ProxInst
    
EADD:
    MOVE.W EIR, D5
    JSR CogerA
    MOVE.W A5, A0 ;A0 contiene la dirección efectiva del registro aaa
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1 ;A1 contiene la dirección efectiva del registro bbb
    
    CLR.L D4        ;inicializamos a 0
    ADD.W (A0), D4
    ADD.W (A1), D4  ;acumulamos la suma en D4
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0007, D7
    MOVE.W D7, ESR
    
    MOVE.W D4, (A1)
     
    BRA ProxInst
    
ESUB:
    MOVE.W EIR, D5
    JSR CogerA
    MOVE.W A5, A0 ;A0 contiene la dirección efectiva del registro aaa
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1 ;A1 contiene la dirección efectiva del registro bbb
    
    NOT.W (A1)
    ADDQ.W #1, (A1)
    
    CLR.L D4        ;inicializamos a 0
    ADD.W (A0), D4
    ADD.W (A1), D4  ;acumulamos la suma en D4
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0007, D7
    MOVE.W D7, ESR
    
    
    MOVE.W D4, (A1)
    
    BRA ProxInst
    
ENAN:
    MOVE.W EIR, D5
    JSR CogerA
    MOVE.W A5, A0 ;A0 contiene la dirección efectiva del registro aaa
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1 ;A1 contiene la dirección efectiva del registro bbb
    

    MOVE.W (A0), D3 
    MOVE.W (A1), D4
    
    AND.W D3, D4 ;hacemos la NAND
    NEG.W D4 
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0005, D7
    MOVE.W D7, ESR
    
    MOVE.W D4, (A1)
    
    BRA ProxInst 
 
ESTC:

    MOVE.W EIR, D5
    JSR CogerK
    MOVE.W D5, D3  ;guardamos K en D3
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1  ;contiene la dirección efectiva del registro bbb
    
    MOVE.W D3, (A1)
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0005, D7
    MOVE.W D7, ESR
    
    BRA ProxInst
    
EINC:

    MOVE.W EIR, D5
    JSR CogerK
    MOVE.W D5, D3  ;guardamos K en D3
    
    MOVE.W EIR, D5
    JSR CogerB
    MOVE.W A5, A1 ;A1 contiene la dirección efectiva del registro bbb
    
    CLR.L D4
    ADD.W D3, D4
    ADD.W (A1), D4 ;acumulamos la suma
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0007, D7
    MOVE.W D7, ESR
    
    MOVE.W D4, (A1)
    
    BRA ProxInst
    
ELOA:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, A0  ;A0 contiene la direción de memória emulada
    
    ADD.W A0, A0 ;multiplicamos x2 la memoria emulada
    
    MOVE.W EMEM(A0), ET6 
    
    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0005, D7
    MOVE.W D7, ESR
    
    BRA ProxInst
    
ELOAX:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, D2  ;D2 contiene la direción de memória emulada
    
    MOVE.W EIR, D5  ;cargamos IJ
    JSR CogerIJ
        
    AND.W #$0002, D5
    BNE Ies1ELOAX
        
    ;si no salta, I es 0
    MOVE.L #0, A5
    ADD.W (EB0), A5
    ADD.W  D2, A5 ;sumamos contenido de EB0 + m 
    ADD.W A5, A5 ;multiplicamos x2 la memoria emulada
        
VolverLOAX:   
  
    ;miramos si j es 1
    MOVE.W EIR, D5  ;cargamos IJ
    JSR CogerIJ
    AND.W #$0001, D5
    BNE Jes1ELOAX
    
        
    ;si no salta J es 0
    MOVE.W EMEM(A5), ET6
    BRA SalirLOAX
        
        
Ies1ELOAX:
    MOVE.L #0, A5
    ADD.W (EB1), A5
    ADD.W  D2, A5 ;sumamos contenido de EB1 + m
    ADD.W A5, A5 ;multiplicamos x2 la memoria emulada
    BRA VolverLOAX
     
    
Jes1ELOAX:
    MOVE.W EMEM(A5), ET7
    
SalirLOAX:

    ;actualizar eflags
    MOVE.W SR, D5
    JSR CargarFlags ;devuelve los EFLAGS en D7
    AND.W #$0005, D7
    MOVE.W D7, ESR
    
    BRA ProxInst
    
ESTO:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, A0  ;A0 contiene la direción de memória emulada
    
    ADD.W A0, A0 ;multiplicamos x2 la memoria emulada
    
    
    MOVE.W ET6, EMEM(A0)
    BRA ProxInst
    
ESTOX:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, D2  ;D2 contiene la direción de memória emulada
    
    MOVE.W EIR, D5    
    JSR CogerIJ
    MOVE.W D5, D3  ;cargamos IJ
        
    AND.W #$0002, D3
    BNE Ies1ESTOX
        
    ;si no salta, I es 0
    MOVE.L #0, A5
    ADD.W (EB0), A5
    ADD.W  D2, A5 ;sumamos contenido de EB0 + m
    
    ADD.W A5, A5 ;multiplicamos x2 la memoria emulada
        
VolverESTOX:   
  
    ;miramos si j es 1
    MOVE.W EIR, D5    
    JSR CogerIJ
    AND.W #$0001, D5
    BNE Jes1ESTOX
    
        
    ;si no salta J es 0
    MOVE.W (ET6), EMEM(A5)
    BRA SalirESTOX
         
Ies1ESTOX:
    MOVE.L #0, A5
    ADD.W (EB1), A5
    ADD.W  D2, A5 ;sumamos contenido de EB1 + m
    ADD.W A5, A5 ;multiplicamos x2 la memoria emulada
    
    BRA VolverESTOX
     
    
Jes1ESTOX:
    MOVE.W (ET7), EMEM(A5)
    
     
SalirESTOX:
    BRA ProxInst
    
EBRI:

    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, A0  ;A0 contiene la direción de memória emulada    

    MOVE.W A0, EPC

    BRA ProxInst
EBRZ:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, A0  ;A0 contiene la direción de memória emulada
    
    AND.W #$0004, ESR
    BNE Zes1
    
    ;si no salta, n es 1
    BRA Zes0
    
Zes1:
    MOVE.W A0, EPC
    
Zes0:
    BRA ProxInst
EBRN:
    MOVE.W EIR, D5
    JSR CogerM
    MOVE.W D5, A0  ;A0 contiene la direción de memória emulada
    
    AND.W #$0001, ESR
    BNE Nes1
    
    ;si no salta, n es 1
    BRA Nes0
    
Nes1:
    MOVE.W A0, EPC
    
Nes0:
    BRA ProxInst
ESTP:
    BRA Finalizar  ; terminamos el programa  

ProxInst:
     
    BRA FETCH ;el resultado esta guardado en code, volvemos a iterar

    ;--- FEXEC: FIN EJECUCION

    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	    ; ESCRIBID VUESTRO CODIGO AQUI
	    
	    CogerA: ;desplaza 4 a la derecha y copia el valor aaa
    LSR.L #4,D5
    AND.W #$0007, D5
    
    JSR DecodRegistro
    
    RTS
    
CogerB: ;desplaza 4 a la derecha y copia el valor bbb
    LSR.L #8,D5
    AND.W #$0007, D5
    
    JSR DecodRegistro
    
    RTS
    
CogerM:
    LSR.L #4, D5
    AND.W #$00FF, D5
    
    RTS
    
CogerIJ:
    
    LSR.L #2, D5
    AND.W #0003, D5
    
    RTS
    
CogerK:
    
    AND.B #$FF, D5
    EXT.W D5        ;extendemos el signo
    
    RTS
    
    
DecodRegistro:
    ;si primer bit uno
    MOVE.W D5, D0
    AND.W #$0004, D0
    BNE PriBitUno
    
    ;si no salta es 0, miramos si el segundo bit es 1
    MOVE.W D5, D0
    AND.W #$0002, D0
    BNE SegBitUno
    
    ;si no salta, miramos si el tercer bit es 1
    MOVE.W D5, D0
    AND.W #$0001, D0
    BNE TerBitUno
     
    ;si no salta, es B0
    LEA.L EB0, A5
    BRA Leave
    
PriBitUno:
    MOVE.W D5, D0
    AND.W #$0002, D0
    BNE T6oT7
    
    ;Si no salta, 
    MOVE.W D5, D0
    AND.W #$0001, D0
    BNE R5

    ;si no salta, es R4
    LEA.L ER4, A5 
    BRA Leave
    
R5:
    LEA.L ER5, A5
    BRA Leave
    
T6oT7:
    MOVE.W D5, D0
    AND.W #$0001, D0
    BNE T7
    
    ;Si no salta, es T6
    LEA.L ET6, A5
    BRA Leave
    
T7:
    LEA.L ET7, A5
    BRA Leave    
    
SegBitUno:
    MOVE.W D5, D0
    AND.W #$0001, D0
    BNE R3
    
    ;si no salta
    LEA.L ER2, A5
    BRA Leave
    
R3:
    LEA.L ER3, A5
    BRA Leave
    
TerBitUno:
    LEA.L EB1, A5 ;guardamos dirección efectiva
    BRA Leave
    

Leave:  
  
    RTS
    
CargarFlags:
    CLR D7

    MOVE.W D5, D6 ;guardamos una copia de los flags
    AND.W #$0004, D6 ;D2 contiene los flags del 68k
    BNE EZes1
    
    BRA EZnoEs1 ;si no es 1, saltamos

EZes1:
    BSET #2, D7
    
EZnoEs1:

    MOVE.W D5, D6 
    AND.W #$0001, D6 
    BNE ECes1
    BRA ECnoEs1
    
ECes1:
    BSET #1, D7
    

ECnoEs1:
    MOVE.W D5, D6 
    AND.W #$0008, D6 
    BNE ENnoEs1
    
    BRA ENnoEs1
    
ENes1:
    BSET #0, D7
    
ENnoEs1:
      
    RTS
        
    ;--- FSUBR: FIN SUBRUTINAS
    

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
	    ; ESCRIBID VUESTRO CODIGO AQUI
	    
    MOVE.L D1, -(A7) ;cargamos los registros que vamos a usar
    MOVE.L D0, -(A7)
	    
    MOVE.W 12(A7), D1 
	
	    
	;codigo decodificacion
	
	MOVE.W D1,D0 ;D0 lo utilizaremos para hacer la AND
    AND.W #$8000,D0 ;miramos si el primer bit es 0
    BNE PrimerBitUno
      
      ;el primer bit es 0
    MOVE.W D1,D0 
    AND.W #$4000,D0
    BNE SegundoBitUno ;saltamos si el bit 2 = 1
      
      ;el segundo bit es 0
    MOVE.W D1,D0 
    AND.W #$2000,D0 *Mirar si 3rd bit es 1
    BNE TercerBitUno
      
      *Si no ha saltado, 3rd bit es 0
    MOVE.W D1,D0 
    AND.W #$1000,D0 *Mirar si 4th bit es 0 = Mirar si es ins. 0
    BNE Id1o2
       
    
    MOVE.W #0, D0 ;si no es ninguna de las anteriores, es 0 
    BRA Salir
       
Id1o2:
    MOVE.W D1, D0
    AND.W #$0800, D0
    BNE Id2
    
    ;si no salta es instrucción 1  
    MOVE.W #1, D0
    BRA Salir
       
Id2: 
    MOVE.W #2,D0
    BRA Salir
          
PrimerBitUno: 
    MOVE.W D1,D0 
    AND.W #$4000,D0 
    BNE Final ;es 13
    
    MOVE.W D1,D0 
    AND.W #$2000,D0 
    BNE Id12 ;es 12
    
    MOVE.W D1,D0 
    AND.W #$1000,D0 
    BNE Id11 ;es 11   
    
    MOVE.W #10,D0
    BRA Salir ;es 10
             
Final:
    MOVE.W #13,D0
    BRA Salir
          
Id12:
    MOVE.W #12,D0
    BRA Salir
     
Id11:
    MOVE.W #11,D0
    BRA Salir
        
SegundoBitUno:
    
    MOVE.W D1,D0 
    AND.W #$2000,D0 
    BNE Id8o9 ;se comprueba si es 8 o 9
    
    ;si no salta es 6 o 7
    MOVE.W D1,D0 
    AND.W #$1000,D0
    BNE Id7
    
    ;si no salta es 6
    MOVE.W #6, D0
    BRA Salir
    
Id7:
    MOVE.W #7, D0
    BRA Salir
    
    
Id8o9:
    MOVE.W D1, D0
    AND.W #$1000,D0 
    BNE Id9 ;se comprueba si es 9
    
    ;si no salta es 8
    MOVE.W #8, D0
    BRA Salir
    
Id9:
    MOVE.W #9, D0
    BRA Salir   
        
          
TercerBitUno:
    MOVE.W D1,D0
    AND.W #$1000,D0 ;es instrucción 5?
    BNE Id5 ; si no salta, es 3 0 4
    
    MOVE.W D1, D0
    AND.W #$0800, D0
    BNE Id4
      
    ; Si no ha saltado, es ins. 3
    MOVE.W #3,D0
    BRA Salir
          
Id5:
    MOVE.W #5,D0
    BRA Salir   
    
Id4:
    MOVE.W #4, D0

    BRA Salir
  
Salir: ;salta cuando ya se sabe que instrucción es 
	
	;fin codigo decodificacion
	    
	;guardamos resultado en la pila
	MOVE.W D0, 14(A7)
        
	;recuperamos registros del usuario    
	MOVE.L (A7)+, D0
	MOVE.L (A7)+, D1
	
	RTS

    ;--- FDECOD: FIN DECOD
    
Finalizar:
    
    END    START

