*-----------------------------------------------------------
* Title      : PRAFIN22
* Written by : <nombres completos de los autores>
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
CODE:   DC.W $1111,$1111,$1111,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        DC.W $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$1111,$1111,$1111
        
EMEMLENGTH:        DC.W 23

START:
    CLR.W EPC

FETCH:



;------------------------------------------------------------
;Leyenda:

    ;D1 --> se usa para hacer el dbra
    ;A6 --> se usa para acceder a los datos del code


;------------------------------------------------------------
 
	
	MOVE.L #23, D3
	SUBQ.L #1, D3 ;inicializamos D1 para el DBRA
	
DecodInstrus:

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
    	
    	 
    	MOVE.W (A7)+, EIR       ;sacamos EIR
    	MOVE.W (A7)+, CODE(A6)  ;hacemos pop del resultado de la pila dejandola vacia
        
    	DBRA D3, DecodInstrus ;el resultado esta guardado en code, volvemos a iterar
    	    
  
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
EADD:
ESUB:
ENAN:
ESTC:
EINC:
ELOA:
ELOAX:
ESTO:
ESTOX:
EBRI:
EBRZ:
EBRN:
ESTP:
    ;--- FEXEC: FIN EJECUCION
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	    ; ESCRIBID VUESTRO CODIGO AQUI
        
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
    END    START
    
    
    ;D0 - Se usa para hacer la and bit a bit y como auxiliar para guardar el resultado
    ;D1 - Se usa para guardar el dato a codificar (contenido de EIR), para que no se modifique con la and bit a bit
