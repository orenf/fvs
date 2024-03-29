      SUBROUTINE TRIPLE
      IMPLICIT NONE
C----------
C  $Id$
C----------
C  **TRIPLE** PARTITIONS EACH TREE RECORD INTO THREE RECORDS.
C  EACH OF THE TRIPLES HAS BEEN ASSIGNED A DIAMETER GROWTH IN
C  **DGDRIV** (TREES WITH LESS THAN 4.5 INCH DBH ARE ASSIGNED
C  DIAMETER GROWTH IN REGENT).  DBH IS ALSO TRIPPLED IN **DGDRIV**.
C  NOW, OTHER TREE ATTRIBUTES ARE COPIED TO THE TRIPLES.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ESTREE.F77'
C
C
      INCLUDE 'STDSTK.F77'
C
C
C
      INTEGER I,ITFN,IDMR
      REAL WEIGHT
C
C
COMMONS
C----------
      DO 30 I=1,ITRN
C----------
C  THE WEIGHT FOR THE SECOND TRIPLE IS 0.25.
C----------
      WEIGHT=0.25
      ITFN=ITRN+2*I-1
C----------
C  ADJUST THE VISULIZATION FOR RECORD TRIPLING
C----------
      CALL SVTRIP (I,ITFN)
C----------
C  RETURN HERE FOR THIRD TRIPLE.
C----------
   10 CONTINUE
      BFV(ITFN)=BFV(I)
      CFV(ITFN)=CFV(I)
      PTOCFV(ITFN)=PTOCFV(I)
      PMRBFV(ITFN)=PMRBFV(I)
      PMRCFV(ITFN)=PMRCFV(I)
      PDBH(ITFN)=PDBH(I)
      PHT(ITFN)=PHT(I)
      NCFDEF(ITFN)=NCFDEF(I)
      NBFDEF(ITFN)=NBFDEF(I)
      HT(ITFN)=HT(I)
      OLDPCT(ITFN)=OLDPCT(I)
      PCT(ITFN)=PCT(I)
      PROB(ITFN)=PROB(I)*WEIGHT
      WK1(ITFN)=WK1(I)
      WK2(ITFN)=WK2(I)*WEIGHT
      WK3(ITFN)=WK3(I)
      ICR(ITFN)=ICR(I)
      IMC(ITFN)=IMC(I)
      ISP(ITFN)=ISP(I)
      ITRE(ITFN)=ITRE(I)
      ITRUNC(ITFN)=ITRUNC(I)
      NORMHT(ITFN)=NORMHT(I)
      KUTKOD(ITFN)=KUTKOD(I)
      DEFECT(ITFN)=DEFECT(I)
      ISPECL(ITFN)=ISPECL(I)
      IESTAT(ITFN)=IESTAT(I)
      ABIRTH(ITFN)=ABIRTH(I)
      IDTREE(ITFN)=IDTREE(I)
      ZRAND(ITFN)=ZRAND(I)
      CRWDTH(ITFN)=CRWDTH(I)
C----------
C     GET MISTLETOE RATING FROM POSITION I AND PUT IT AT POSITION ITFN.
C
      CALL MISGET(I,IDMR)
      CALL MISPUT(ITFN,IDMR)
C----------
      CALL RDTRIP (ITFN,I,WEIGHT)
      CALL BRTRIP (ITFN,I,WEIGHT)
      CALL BMTRIP (ITFN,I,WEIGHT)
      CALL FMTRIP (ITFN,I,WEIGHT)      
      IF(WEIGHT.LT.0.2) GO TO 20
C----------
C  REASSIGN WEIGHT AND ITFN FOR THIRD TRIPLE.
C----------
      WEIGHT=0.15
      ITFN=ITFN+1
      GO TO 10
C----------
C  ALL ATTRIBUTES FOR EACH TRIPLE HAVE BEEN ASSIGNED.  ADJUST
C  THE PROB AND WK2 (MORTALITY) FOR THE ORIGINAL RECORD.
C----------
   20 CONTINUE
      WK2(I) = WK2(I)*.6
      PROB(I)=PROB(I)*0.60
C----------
C     CALL WESTERN ROOT DISEASE MODEL VER. 3.0 SUBROUTINE TO TRIPLE
C     THE WESTERN ROOT DISEASE TREELIST
C----------
      CALL RDTRIP (ITFN,I,0.6)
C----------
C     CALL BLISTER RUST SUBROUTINE TO TRIPLE BLISTER RUST TREELIST.
C----------
      CALL BRTRIP (ITFN,I,0.6)
C----------
C     CALL BEETLE MODEL TO TRIPLE BEETLE MODEL PARAMETERS
C----------
      CALL BMTRIP (ITFN,I,0.6)
C----------
C     CALL FIRE MODEL TO TRIPLE ITS PARAMETERS
C----------
      CALL FMTRIP (ITFN,I,0.6)      
   30 CONTINUE
C----------
C  UPDATE MULTIPLIER WHICH INFLATES PROB FOR SAMPLE TREE DISPLAY.
C----------
      TRM=TRM*0.6
      RETURN
      END
