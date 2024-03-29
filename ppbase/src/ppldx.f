      SUBROUTINE PPLDX (X,INSTR,IRC)
      IMPLICIT NONE
C----------
C  **PPLDX  DATE OF LAST REVISION:  08:35:00 07/31/08
C----------
C
C     CALLED FROM ALGEVL
C
C     LOADS X VALUES OWNED BY PPE AS OPPOSED TO THE PROGNOSIS MODEL.
C
C     N.L.CROOKSTON - APR 87 - FORESTRY SCIENCES LAB - MOSCOW, ID
C
C     X     = THE VALUE REQUESTED.
C     INSTR = THE CODE THAT SAYS WHICH VALUE IS REQUESTED.
C     IRC   = RETURN CODE, 0=OK, 1=VARIABLE IS CURRENTLY UNDEFINED,
C             2=INSTRUCTION CODE COULD NOT BE DECIPHERED.
C
COMMONS
C
C
      INCLUDE 'PPEXCM.F77'
C
C
COMMONS
C
C
      INTEGER IRC,INSTR,I
      REAL X
C
C     DECODE INSTRUCTION AND EXECUTE.
C
      IF (INSTR.GT.7000) THEN
         IF (INSTR.LT.7200) THEN
            I=INSTR-7000
            IF (I.LE.NPTST1) THEN
               IF (LPTST1(I)) THEN
                  X=PTSTV1(I)
                  IRC=0
                  RETURN
               ELSE
                  IRC=1
                  RETURN
               ENDIF
            ELSE
               IRC=2
               RETURN
            ENDIF
         ELSEIF (INSTR.LT.8000) THEN
            I=INSTR-7200
            IF (I.LT.NPTST2) THEN
               IF (LPTST2(I)) THEN
                  X=PTSTV2(I)
                  IRC=0
                  RETURN
               ELSE
                  IRC=1
                  RETURN
               ENDIF
            ELSE
               IRC=2
               RETURN
            ENDIF
         ELSE
            I=INSTR-8000
            IF (I.LT.NPTST3) THEN
               X=PTSTV3(I)
               IRC=0
               RETURN
            ELSE
               IRC=2
               RETURN
            ENDIF
         ENDIF
      ELSE
         IRC=2
         RETURN
      ENDIF
      END
