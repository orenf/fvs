      SUBROUTINE REVISE (VAR,REV)
      IMPLICIT NONE
C----------
C  **REVISE--BASE  DATE OF LAST REVISION:  02/17/09
C  (DON'T CHANGE THIS DATE UNLESS THE SUBROUTINE LOGIC CHANGES.)
C----------
C
C  THIS ROUTINE PROVIDES THE LATEST REVISION DATE FOR EACH VARIANT
C  WHICH GETS PRINTED IN THE MAIN HEADER ON THE OUTPUT.
C  CALLED FROM GROHED, FILOPN, SUMHED, SUMOUT, ECVOLS, PRTRLS,
C  AND DGDRIV.
C----------
      CHARACTER VAR*7,REV*10
C----------
C ONTARIO - WAS LAKE STATES
C----------
      IF(VAR(:2).EQ.'ON') THEN
        REV = '10/01/12'
        GO TO 100
      ENDIF
  100 CONTINUE
      RETURN
      END
