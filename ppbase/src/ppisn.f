      SUBROUTINE PPISN (CISN)
      IMPLICIT NONE
C----------
C  **PPISN   DATE OF LAST REVISION:  07/31/08
C----------
C
C     RETURNS THE ISN FOR THE CURRENT STAND.
C     RETURNS THE CURRENT STAND NUMBER.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--OCT 1987
C
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PPEPRM.F77'
C
C
      INCLUDE 'PPCNTL.F77'
C
C
      INCLUDE 'PPCISN.F77'
C
C
COMMONS
C
      INTEGER ISTAND
      CHARACTER CISN*11
C
      IF (ISTND.GT.0) THEN
         CISN=CISNUM(ISTND)
      ELSE
         CISN=CISNS(-ISTND)
      ENDIF
      RETURN
C
      ENTRY PPISND (ISTAND)
      ISTAND=ISTND
      RETURN
      END
