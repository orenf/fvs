      SUBROUTINE CHREAD (CBUFF,IPNT,LNCBUF,CVARBL,IBEGIN)
      IMPLICIT NONE
C----------
C  **CHREAD  DATE OF LAST REVISION:  07/31/08
C----------
C
C     READ A CHARACTER FROM THE DIRECT ACCESS BUFFER CBUFF.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     NL CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--FEB 1987
C
C     SEE CHWRIT FOR LIST OF ARGUMENTS. METHODS ARE THE SAME AS
C     USED IN BFREAD/BFWRIT.
C
C
      INTEGER IBEGIN,IPNT,LNCBUF
      CHARACTER CBUFF(LNCBUF)
      CHARACTER CVARBL
      IF (IBEGIN.EQ.1) IPNT=LNCBUF
      IF (IPNT.LT.LNCBUF) GOTO 500
      CALL CHDSTH (CBUFF,IPNT)
      IPNT=0
  500 CONTINUE
      IPNT=IPNT+1
      CVARBL=CBUFF(IPNT)
      RETURN
      END
