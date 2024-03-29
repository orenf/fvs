      SUBROUTINE ESTIME (IEVTYR,KDT)
      IMPLICIT NONE
C----------
C  **ESTIME DATE OF LAST REVISION:   07/25/08
C----------
C
C     CALLED FROM ESTAB.
C
C     IEVTYR= A YEAR OF INTEREST.  THE DATA OF DISTURBANCE OR SITE
C             PREP; SOMETIMES THE BEGINNING OF THE CURRENT TALLY.
C     KDT   = THE TALLY YEAR.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
      INCLUDE 'ESWSBW.F77'
C
C
COMMONS
C
C     DEFINE TIME AND WSBW VARIABLES FOR REGENERATION MODEL.
C
      REAL SQRVEC(20)
      INTEGER KDT,IEVTYR,IYR,I
      DATA SQRVEC/1.0, .41421, .31784, .26795, .23607, .21342,
     &  .19626, .18268,.17157, .16228, .15435, .14748, .14145,
     &  .13611, .13133,.12702, .12311, .11954, .11626, .11324/
C
      BWB4=0.0
      BWAF=0.0
      SQBWAF=0.0
      IF (NBWHST.GT.0) THEN
         DO 20 IYR=(IEVTYR-5),(IEVTYR-1)
         DO 10 I=1,NBWHST
         IF (IYR.GE.IBWHST(1,I).AND.IYR.LE.IBWHST(2,I)) THEN
            BWB4=BWB4+1.0
            GOTO 20
         ENDIF
   10    CONTINUE
   20    CONTINUE
         DO 40 IYR=IEVTYR,KDT
         DO 30 I=1,NBWHST
         IF (IYR.GE.IBWHST(1,I).AND.IYR.LE.IBWHST(2,I)) THEN
            BWAF=BWAF+1.0
            SQBWAF=SQBWAF+ SQRVEC(IYR-IEVTYR+1)
            GOTO 40
         ENDIF
   30    CONTINUE
   40    CONTINUE
      ENDIF
      SQREGT=SQRT(TIME)-SQBWAF
      REGT=TIME-BWAF
      RETURN
      END
