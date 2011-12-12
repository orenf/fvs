      SUBROUTINE HABTYP (KARD2,ARRAY2)
      IMPLICIT NONE
C----------
C  **HABTYP--AN   DATE OF LAST REVISION:  02/21/08
C----------
C
C  DUMMY HABITAT ROUTINE USED IN VARIANTS THAT DON'T USE
C  HABITAT TYPE AS A VARIABLE IN GROWTH FUNCTIONS.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C----------
      INTEGER KODTYP,ITYPE
      REAL ARRAY2
      CHARACTER*10 KARD2
C----------   
      KODTYP=0
      ITYPE=0
      ICL5=999
      KARD2='UNKNOWN   '
      PCOM='UNKNOWN '   
      IF(LSTART)WRITE(JOSTND,21)
   21 FORMAT(/,T13,'HABITAT TYPE IS NOT USED IN THIS VARIANT')
      RETURN
      END
