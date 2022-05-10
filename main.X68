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

