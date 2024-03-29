      SUBROUTINE ESFLTR
      IMPLICIT NONE
C----------
C  **ESFLTR DATE OF LAST REVISION:  07/25/08
C----------
C
C      CALLED AFTER CRATET TO COLLECT INVENTORY INFORMATION FOR
C      UNDERSTORY/OVERSTORY DENSITIES AND TO FLAG BEST TREES
C
COMMONS
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
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESTREE.F77'
C
C
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'CALDEN.F77'
C
COMMONS
C
      INTEGER IDENWK(MAXTRE),NOTE(30),ICHOIS(30),NULL(MAXSP),
     &          ITALL(MAXSP),IPLOT(MAXTRE)
      REAL TALL(MAXSP)
      INTEGER I,N,KODE,NPS,IDT,IFLAG,IBGIN,NNN,III,NUM,J,IDENT,IS,KT
      INTEGER IHOLD
      REAL PIX,D,ZPROB,CHEK,HEIGHT
      EQUIVALENCE (WK5,IDENWK),(WK6,IPLOT)
      DO 10 I=1,MAXPLT
      BAAINV(I)=0.0
   10 CONTINUE
      TPACRE=0.0
      IF(ITRN.LT.1) GO TO 201
C
C     PIX IS NUMBER OF STOCKABLE PLOTS
C
      PIX=PI-FLOAT(NONSTK)
      DO 30 I=1,ITRN
      IPLOT(I)=ITRE(I)
      D=DBH(I)
      N=ITRE(I)
      ZPROB=PROB(I)
      IF(D.LT.REGNBK) GO TO 20
      BAAINV(N)=BAAINV(N) +0.005454154*D*D*ZPROB*PIX
      GO TO 30
   20 CONTINUE
      TPACRE=TPACRE +ZPROB
   30 CONTINUE
C
C     FLAG INCOMING BEST TREE RECORDS. IGNORE PROB. ASSUMPTIONS:
C     1. SPECIES CODES ARE 1 TO MAXSP.  2. HEIGHTS, DIAMETERS, ETC. ARE
C     SET.  3. BEST TREE RECORDS ARE WITHIN THE FIRST 30 RECORDS OF TREES
C     TALLIED ON A PLOT.  4. IESTAT IS ZEROED OUT (DONE IN INTREE).
C     5. PLOT NUMBERS ARE INTEGERS BETWEEN 1 AND 200.
C
      CALL OPGET2 (428,IDT,IY(1)-20,IY(1)+20,1,1,NPS,WK4,KODE)
      IF(KODE.NE.0) GO TO 201
      IDSDAT=IFIX(WK4(1))
      CALL IAPSRT(ITRN,IPLOT,IDENWK,.TRUE.)
      IFLAG=0
      IBGIN=ITRE(IDENWK(1))
      N=0
      NNN=0
      DO 60 I=1,30
      ICHOIS(I)=0
   60 CONTINUE
      DO 61 I=1,MAXSP
      NULL(I)=0
      ITALL(I)=0
      TALL(I)=0.001
   61 CONTINUE
C
C     BEGIN WORKING WITH THE TREE LIST. FLAG BEST TREES BY PLOT.
C
      DO 200 III=1,ITRN
      NUM=ITRE(IDENWK(III))
      IF(NUM.EQ.IBGIN) GO TO 190
   62 CONTINUE
      IF(N.GT.0) GO TO 63
      IBGIN=ITRE(IDENWK(III))
      GO TO 190
   63 CONTINUE
C
C     STEP 1:  PICK 2 TALLEST RECORDS REGARDLESS OF SPECIES.
C
      DO 65 J=1,2
      IF(NNN.GE.N) GO TO 180
      CHEK=0.001
      DO 64 I=1,N
      IF(ICHOIS(I).EQ.1) GO TO 64
      IDENT=NOTE(I)
      IS=ISP(IDENT)
      HEIGHT=HT(IDENT)
      IF(HEIGHT.LT.CHEK) GO TO 64
      CHEK=HEIGHT
      KT=IS
      IHOLD=I
   64 CONTINUE
      NULL(KT)=1
      ICHOIS(IHOLD)=1
      NNN=NNN+1
   65 CONTINUE
C
C     STEP 2:  PICK TALLEST TREE OF EACH ADDITIONAL SPECIES.
C
      DO 71 J=1,MAXSP
      IF(NULL(J).EQ.1) GO TO 71
      DO 70 I=1,N
      IDENT=NOTE(I)
      IS=ISP(IDENT)
      IF(IS.NE.J) GO TO 70
      IF(ICHOIS(I).EQ.1) GO TO 70
      HEIGHT=HT(IDENT)
      IF(HEIGHT.LT.TALL(J)) GO TO 70
      TALL(J)=HEIGHT
      ITALL(J)=I
   70 CONTINUE
   71 CONTINUE
      DO 80 J=1,MAXSP
      IF(NULL(J).EQ.1) GO TO 80
      KT=ITALL(J)
      IF(KT.EQ.0) GO TO 80
      ICHOIS(KT)=1
      NNN=NNN+1
   80 CONTINUE
      IF(NNN.GE.N) GO TO 180
      IF(NNN.GE.4) GO TO 180
C
C     STEP 3:  PICK 4 TREES BY DESCENDING HEIGHTS, IF POSSIBLE.
C
   90 CONTINUE
      CHEK=0.001
      DO 100 I=1,N
      IF(ICHOIS(I).EQ.1) GO TO 100
      IDENT=NOTE(I)
      HEIGHT=HT(IDENT)
      IF(HEIGHT.LT.CHEK) GO TO 100
      CHEK=HEIGHT
      IHOLD=I
  100 CONTINUE
      ICHOIS(IHOLD)=1
      NNN=NNN+1
      IF(NNN.GE.N) GO TO 180
      IF(NNN.LT.4) GO TO 90
  180 CONTINUE
      DO 181 I=1,N
      IDENT=NOTE(I)
      IESTAT(IDENT)=ICHOIS(I)* (IDSDAT+20)
  181 CONTINUE
C
C     RE-INITIALIZE
C
      IF(IFLAG.EQ.1) GO TO 200
      IBGIN=ITRE(IDENWK(III))
      N=0
      NNN=0
      DO 185 I=1,30
      ICHOIS(I)=0
  185 CONTINUE
      DO 186 I=1,MAXSP
      NULL(I)=0
      ITALL(I)=0
      TALL(I)=0.001
  186 CONTINUE
  190 CONTINUE
      IF(N.GT.29) GO TO 195
      D=DBH(IDENWK(III))
      IF(D.GE.REGNBK) GO TO 200
      N=N+1
      NOTE(N)=IDENWK(III)
  195 CONTINUE
      IF(III.EQ.ITRN) IFLAG=1
      IF(IFLAG.EQ.1) GO TO 62
  200 CONTINUE
  201 CONTINUE
      RETURN
      END
