      FUNCTION TMBCHL (XBAR, STDEV) 
      IMPLICIT NONE
C---------- 
C  **TMBCHL DATE OF LAST REVISION:  14:04:00 11/13/81 
C---------- 
C---------- 
C  THIS FUNCTION RETURNS A RANDOM NUMBER DRAWN FROM THE     
C  NORMAL DISTRIBUTION DESCRIBED BY (XBAR,STDEV).  THIS FUNCTION  
C  UTILIZES THE COMPOSITE REJECTION TECHNIQUE DEVELOPED BY  
C  BATCHELOR AND DESCRIBED IN:
C     
C      TOCHER, K.D.  1963. THE ART OF SIMULATION. D. VAN NOSTRAND 
C                    COMPANY, INC. PRINCETON, NJ. 184 P. (PP 24/27).    
C     
C  DEFINITION OF VARIABLES.   
C     
C    TMBCHL -- GENERATED NORMAL RANDOM VARIABLE.
C    TMRANN -- SUBROUTINE THAT GENERATES UNIFORM RANDOM NUMBERS.  
C    XBAR   -- MEAN OF THE NORMAL DISTRIBUTION FROM WHICH TMBCHL  
C              IS DRAWN.
C    STDEV  -- STANDARD DEVIATION OF THE NORMAL DISTRIBUTION FROM 
C              WHICH TMBCHL IS DRAWN.     
C     
C  DEFINITION OF INTERNAL VARIABLES.
C     
C         X -- COMPUTED ORDINAL OF THE STANDARDIZED NORMAL  
C              DISTRIBUTION FUNCTION.     
C         U -- UNIFORM RANDOM NUMBER DRAWN TO REPRESENT THE INTEGRAL    
C              OF THE STANDARDIZED NORMAL PDF EVALUATED FROM -X TO
C              X.  IF U IS LESS THAN 2/3, X IS APPROXIMATED FROM A
C              UNIFORM DISTRIBUTION.  OTHERWISE, X IS APPROXIMATED
C              FROM A NEGATIVE EXPONENTIAL DISTRIBUTION.    
C         Z -- VALUE COMPUTED ASSUMING X IS EXPONENTIALLY   
C              DISTRIBUTED.   
C         Y -- EXPONENTIALLY DISTRIBUTED RANDOM VARIATE.  IF Y IS 
C              LESS THAN OR EQUAL TO Z, X IS REJECTED AND REDRAWN.
C        R1 -- UNIFORM RANDOM NUMBER DRAWN TO GENERATE Y.   
C        R2 -- UNIFORM RANDOM NUMBER DRAWN TO ASSIGN A SIGN TO X. 
C     

      REAL STDEV,XBAR,TMBCHL,U,R1,R2,X,Y,Z,A,SIGNX     

   10 CONTINUE    
C     
C     DRAW THREE UNIFORM RANDOM NUMBERS;  U, R1, AND R2.    
C     
      CALL TMRANN(U)    
      CALL TMRANN(R1)   
      CALL TMRANN(R2)   

C     
C     DETERMINE METHOD OF APPROXIMATION.  
C     
      IF (U .LE. (2.0 / 3.0)) GOTO 20     

C     
C     CALCULATE X AND Z ASSUMING A NEGATIVE EXPONENTIAL DISTRIBUTION.   
C     
      X = 1.0 - 0.5 * ALOG(3.0 * U - 2.0) 
      Z = 0.5 * (X - 2.0)**2  
      GOTO 30     

C     
C     CALCULATE X AND Z ASSUMING A UNIFORM DISTRIBUTION.    
C     
   20 X = 1.5 * U 
      Z = 0.5 * X * X   

C     
C     DRAW REJECTION PARAMETER FROM AN EXPONENTIAL DISTRIBUTION AND     
C     DETERMINE IF REJECTION IS NECESSARY.
C     
   30 Y = -ALOG(R1)     
      IF (Y .LE. Z) GOTO 10   

C     
C     SELECT THE SIGN OF X    
C     
      A = 0.5 - R2
      SIGNX = A / ABS(A) 
      X = X * SIGNX
C     
C  SCALE STANDARDIZED NORMAL RANDOM VARIATE FOR INPUT MEAN AND    
C  STANDARD DEVIATION AND RETURN IT AS TMBCHL.  
C     
      TMBCHL = X * STDEV + XBAR     

      RETURN
      END   
