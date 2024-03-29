      SUBROUTINE SPLAEX (CIDS,NCIDS,ISRT,IRC)
      IMPLICIT NONE
C----------
C  **SPLAEX--PPBASE  DATE OF LAST REVISION:  07/31/08
C----------
C     EXTRACTS, OR MAKES READY, THE LOCATION AND AREA DATA SO THAT
C     SUBROUTINE SPLAAR AND SPLALO CAN EFFECTIENTLY ACCESS IT.
C
C     CIDS  = A LIST OF IDS FOR WHICH AREALOCS DATA WILL BE EXTRACTED.
C             CALLS TO SPNBBD WILL BE MADE USING SUBSCRIPS OF CIDS.
C     NCIDS = THE LENGTH OF CIDS AND ISRT.
C     ISRT  = AN INTEGER SORT OVER CIDS IN ASCENDING ORDER.
C     IRC   = SEE SPEXTR.
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
      INCLUDE 'PPSPLA.F77'
C
C
COMMONS
C
      CHARACTER*26 CIDS(NCIDS)
      INTEGER ISRT(NCIDS),NCIDS,IRC
C
C     EXTRACT THE AREA/LOCATIONS DATA.
C
      CALL SPEXTR (CIDS,NCIDS,ISRT,LAORD,MXSTND,NLAS,CLAID,IRC)
      RETURN
      END
