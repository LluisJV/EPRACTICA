DECODIFICACION:
      MOVE.W (A0),D7 *D7 como "registro decofidicador"
      AND.W #$8000,D7 *Mirar si 1st bit es 0
      BNE FirstBitNotZero
      
      *Si no ha saltado, 1st bit es 1
      MOVE.W (A0),D7 
      AND.W #$4000,D7 *Mirar si 2nd bit es 1
      BNE SecondBitNotZero
      
      *Si no ha saltado, 2nd bit es 0
      MOVE.W (A0),D7 
      AND.W #$2000,D7 *Mirar si 3rd bit es 1
      BNE ThirdBitNotZero
      
      *Si no ha saltado, 3rd bit es 0
       MOVE.W (A0),D7 
       AND.W #$1000,D7 *Mirar si 4th bit es 0 = Mirar si es ins. 0
       BEQ InsZero
       
       *Si no ha saltado, 4th bit es 1
       MOVE.W (A0),D7 
       BTST.L #11,D7
       BEQ InsOne *Mirar si es ins. 1
       
       *Si no ha saltado, es ins. 2
       MOVE.W #2,CODE(A1)
       BRA BackToDecod
       
InsZero:
          MOVE.W #0,CODE(A1)
          BRA BackToDecod
          
  InsOne: 
          MOVE.W #1,CODE(A1)
          BRA BackToDecod
          
  FirstBitNotZero: 
      MOVE.W (A0),D7 
      AND.W #$4000,D7 Mirar si es ins. 13
      BNE FinalIns
      MOVE.W (A0),D7 
      AND.W #$2000,D7 *Mirar si es ins. 12
      BNE InsTwelve
      MOVE.W (A0),D7 
      AND.W #$1000,D7 *Mirar si es ins. 11
      BNE InsEleven
      
     *Si no ha saltado, es ins. 10    
      MOVE.W #10,CODE(A1)
      BRA BackToDecod
       
      
  FinaLIns:
          MOVE.W #13,CODE(A1)
          BRA BackToDecod
          
  InsTwelve:
          MOVE.W #12,CODE(A1)
          BRA BackToDecod
     
  InsEleven:
        MOVE.W #11,CODE(A1)
        BRA BackToDecod
        
SecondBitNotZero:
      MOVE.W (A0),D7
      AND.W #$F000,D7
      LSR.L #4,D7
      LSR.L #8,D7
      CMP.W #4,D7 *Mirar si es ins. 6
      BEQ InsSix
      CMP.W #5,D7 *Mirar si es ins. 7
      BEQ InsSeven
      CMP.W #6,D7 *Mirar si es ins. 8
      BEQ InsEight
      
      *Si no ha saltado, es ins. 9
          MOVE.W #9,CODE(A1)
          BRA BackToDecod
      
  InsSix:
          MOVE.W #6,CODE(A1)
          BRA BackToDecod
          
  InsSeven:
          MOVE.W #7,CODE(A1)
          BRA BackToDecod
          
  InsEight:
          MOVE.W #8,CODE(A1)
          BRA BackToDecod
          
          
  ThirdBitNotZero:
      MOVE.W (A0),D7
      AND.W #$1000,D7 *Mirar si es ins. 5
      BNE InsFive
      MOVE.W (A0),D7
      AND.W #$0800,D7 *Mirar si es ins. 4
      BNE InsFour
      
      *Si no ha saltado, es ins. 3
          MOVE.W #3,CODE(A1)
          BRA BackToDecod
          
  InsFive:
          MOVE.W #5,CODE(A1)
          BRA BackToDecod
  InsFour:
          MOVE.W #4,CODE(A1)
          BRA BackToDecod       
  
  BackToDecoD:
          ADDQ.W #2,A1
          ADDQ.W #2,A0
          DBRA D1, DECODIFICACION
          BRA STOP
  
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
  
      ;--- FDECOD: FIN DECOD
      
  STOP:
