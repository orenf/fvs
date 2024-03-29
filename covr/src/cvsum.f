      SUBROUTINE CVSUM (LTHIN)
      IMPLICIT NONE
C----------
C  **CVSUM  DATE OF LAST REVISION:  07/11/08
C----------
C  COMPUTES CROWN PROJECTION AREA, NUMBER OF TREES, AND SUMS OF
C  SQUARED DIAMETERS BY HEIGHT CLASS FOR SUBROUTINE **CVCLAS**.
C
C  COMPUTES PERCENT CANOPY CLOSURE, CROWN VOLUME, CROWN PROFILE AREA,
C  CROWN FOLIAGE BIOMASS BY HEIGHT CLASS, AND SUM OF DIAMETERS
C  FOR THE CANOPY OPTION.
C
C  COMPUTES SHRUB COVER BY HEIGHT FOR THE SHRUBS OPTION.
C  COMPUTES SHRUB-SMALL CONIFER COMPETITION VALUES BY HEIGHT.
C----------
C  DEFINITIONS OF VARIABLES NEEDED BY **CVCLAS**
C
C  HTMAX - HEIGHT OF TALLEST TREE IN STAND
C  HTMIN - HEIGHT OF SHORTEST TREE IN STAND
C  TALLSH - AVERAGE HEIGHT OF TALL SHRUBS, WEIGHTED BY PBCV(I)
C  CRXHT(16) - CROWN PROJECTION AREA OF TREES WHOSE TOTAL HEIGHTS FALL
C              IN HEIGHT CLASS
C  SD2XHT(16) - SUM OF SQUARED DIAMETERS OF TREES WHOSE HEIGHTS FALL IN
C               HEIGHT CLASS
C----------
C  DEFINITIONS OF VARIABLES NEEDED BY THE CANOPY OPTION.
C
C  PCXHT(MAXCY1,2,16) - PERCENT CANOPY CLOSURE CONTRIBUTED BY TREES
C                   WHOSE TOTAL HEIGHTS FALL IN HEIGHT CLASS
C  TPCTCV(MAXCY1,2) - TOTAL PERCENT CANOPY CLOSURE
C  TXHT(MAXCY1,2,16) - NUMBER OF TREES WHOSE HEIGHTS FALL IN HT CLASS
C  TRETOT(MAXCY1,2) - TOTAL NUMBER OF TREES
C  PROXHT(MAXCY1,2,16) - CROWN PROFILE AREA WITHIN HEIGHT CLASS
C  TPROAR(MAXCY1,2) - TOTAL CROWN PROFILE AREA
C  VOLXHT(MAXCY1,2,16) - CROWN VOLUME WITHIN HEIGHT CLASS
C  TCVOL(MAXCY1,2) - TOTAL CROWN VOLUME
C  CFBXHT(MAXCY1,2,16) - CROWN FOLIAGE BIOMASS WITHIN HEIGHT CLASS
C  TOTBMS(MAXCY1,2) - TOTAL CROWN FOLIAGE BIOMASS
C  SDIAM(MAXCY1,2) - SUM OF STEM DIAMETERS
C  STDHT(MAXCY1,2) - TOP HEIGHT (AVERAGE HEIGHT OF LARGEST 40
C                TREES PER ACRE BY DBH).
C  ICVAGE(MAXCY1,2)  - OVERSTORY AGE
C
C  ISHAP, ISHAPE(MAXTRE) - TREE CROWN SHAPE
C  LCNOP - LOGICAL FLAG FOR CANOPY OPTION
C  TRECW(MAXTRE) - TREE CROWN WIDTH
C  TRFBMS(MAXTRE) - TREE FOLIAGE BIOMASS
C  CAREA  - TOTAL CROWN PROFILE AREA, COMPUTED ANALYTICALLY
C  CVOLUM - TOTAL CROWN VOLUME, COMPUTED ANALYTICALLY
C  PROP - PROPORTION OF FRUSTRUM TO TOTAL VOLUME
C  HC   - HEIGHT OF CROWN  (CROWN LENGTH)
C  BASE - HEIGHT AT CROWN BASE (BOTTOM IF SHAPE CONE, PARABOLOID, OR
C         NEILOID; MID-CROWN IF SHAPE = SPHERE OR ELLIPSOID)
C  RAD  - CROWN RADIUS AT BASE
C
C  CROWN DIMENSIONS WITHIN HEIGHT CLASS;
C
C  BOT     - HEIGHT AT CROWN BOTTOM
C  TREVOL  - TREE CROWN VOLUME, COMPUTED AS SUM OF FRUST
C  TREAR   - TREE CROWN PROFILE AREA, COMPUTED AS SUM OF PAREA
C  ITOP    - INDEX TO HEIGHT CLASS CONTAINING CROWN TOP
C  IBOT    - INDEX TO HEIGHT CLASS CONTAINING CROWN BOTTOM
C  H1 - DISTANCE FROM BASE TO LOWER PLANE OF FRUSTRUM
C  H2 - THICKNESS OF FRUSTRUM
C  R1 - RADIUS OF LOWER PLANE OF FRUSTRUM
C  R2 - RADIUS OF UPPER PLANE OF FRUSTRUM
C  Y1 - LOWER LIMIT OF INTEGRATION
C  Y2 - UPPER LIMIT OF INTEGRATION
C  CNOP(1)  - HEIGHT AT LOWER LIMIT OF CROWN CLASS
C  CNOP(2)  - HEIGHT AT UPPER LIMIT OF CROWN CLASS
C  UPLIM    - HEIGHT AT UPPER PLANE OF CROWN FRUSTRUM
C  LOWLIM   - HEIGHT AT LOWER PLANE OF CROWN FRUSTRUM
C  FRUST    - VOLUME OF FRUSTRUM
C  PAREA    - PROFILE AREA OF FRUSTRUM
C----------
C  VARIABLES NEEDED BY THE SHRUBS OPTION.
C
C-- ASHT(MAXCY1,2) -- WEIGHTED AVERAGE HEIGHT OF ALL SPECIES,
C                     USING PBCV(I)
C-- CLOW(MAXCY1,2),CMED(MAXCY1,2),CTALL(MAXCY1,2) -- SUM OF SPECIES
C             COVER FOR LOW, MEDIUM, AND TALL HEIGHT CLASSES
C-- SCV(MAXCY1,2,12), SHT(MAXCY1,2,12), SPB(MAXCY1,2,12),
C   ISSP(MAXCY1,2,12) --
C             COVER, HEIGHT, PROB, AND SPECIES CODE OF 1ST 3 SPECIES,
C             PLUS 'OTHR', WITH GREATEST PREDICTED COVER (PBCV(I))
C             WITHIN LOW, MEDIUM, AND TALL HEIGHT CLASSES
C-- NUM(3), INC(3), PASS(12), OTHCOV, OTHHT, OTHPB, INDX(12), IGSP(3) -
C             USED TO SORT SHRUBS INTO 3 HEIGHT CLASSES BY GREATEST
C             PREDICTED COVER (PBCV(I))
C-- LSHOW, ISHOW(6), NSHOW -- LOGICAL FLAG, SUBSCRIPTS, AND NUMBER
C             OF USER-SELECTED SPECIES FOR DISPLAY
C-- CIND(MAXCY1,2,6), HIND(MAXCY1,2,6), PIND(MAXCY1,2,6),
C   INDSP(MAXCY1,2,6) --
C             COVER, HEIGHT, PROB, AND SPECIES CODE OF UP TO 6
C             USER-SELECTED SPECIES FOR DISPLAY
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
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CVCOM.F77'
C
C
COMMONS
C
      REAL LOWLIM
      LOGICAL LTHIN,DEBUG
      INTEGER INDX(12)
      REAL CNOP(2)
      REAL SHTRHT(11)
      INTEGER NUM(3),INC(3),IGSP(3)
      REAL PASS(12)
      INTEGER J1,IICR,ISHAP,IBOT,K,ITOP
      REAL PROP,PAREA,FRUST,CONST,Z1,Z2,B1,CAREA,CVOLUM,Y2,Y1,R2,R1,H1
      REAL H2,UPLIM,TREAR,TREVOL,RAD,BASE,BOT,HC
      INTEGER ITHN,IP1,I,ISPI,IH,J,JP1,IG
      REAL HEIGHT,SUMPB,TSHT,TSUMPB,HM1,OTHCOV,OTHHT,OTHPB
      
      DATA NUM /7,12,12/
      DATA INC /0,7,19/
      DATA IGSP /0,4,8/
C
      DATA SHTRHT/0.5,1.0,2.0,3.0,4.0,5.0,7.5,10.0,15.0,20.0,400./
C----------
C  CHECK FOR DEBUG.
C----------
      CALL DBCHK(DEBUG,'CVSUM',5,ICYC)
C----------
C LTHIN = .TRUE. IF THINNING HAS OCCURRED.
C----------
      ITHN = 1
      IP1 = ICYC + 1
      IF (LTHIN) ITHN = 2
      IF (LTHIN) IP1 = ICYC
      IF (DEBUG) WRITE (JOSTND,9000) ICYC
 9000 FORMAT (/' **CALLING CVSUM, CYCLE = ',I2)
C======================================================================
C  ** COMPUTE SHRUB SUMMARY VALUES **
C======================================================================
C  SKIP THIS SECTION IF SHRUB CALCULATIONS NOT AVAILABLE.
C----------
      IF (.NOT. LBROW) GO TO 150
      IF (SAGE .GT. 40.) GO TO 150
C----------
C  COMPUTE VARIOUS SHRUB BY HEIGHT VALUES.
C----------
      HEIGHT = 0.0
      SUMPB = 0.0
      TSHT = 0.0
      TSUMPB = 0.0
      DO 10 I = 1,11
      SCOV(IP1,ITHN,I) = 0.0
      TRSH(IP1,ITHN,I) = 0.0
   10 CONTINUE
C
      DO 80 ISPI = 1,31
C----------
C  1) ASHT(IP1,ITHN) - WEIGHTED AVERAGE HEIGHT OF SHRUBS
C  USING PBCV(ISPI).
C----------
      SUMPB = SUMPB + PBCV(ISPI)
      HEIGHT = HEIGHT + SH(ISPI)*PBCV(ISPI)
C----------
C  3) TALLSH - AVERAGE SHRUB HEIGHT FOR "TALL SHRUBS" (FROM PATTERSON
C  ET AL., FIELD GUIDE TO FOREST PLANTS OF NORTHERN IDAHO):
C  ACGL,ALSI,AMAL,CESA,CEVE,COST,HODI,PREM,PRVI,SALX,SAMB,SORB.
C----------
      IF (ISPI .LT. 20) GO TO 70
      TSUMPB = TSUMPB + PBCV(ISPI)
      TSHT = TSHT + SH(ISPI)*PBCV(ISPI)
   70 CONTINUE
C----------
C  4) CUMULATIVE SHRUB COVER FOR SHRUB-SMALL CONIFER COMPETITION
C  DISPLAY.
C----------
      HM1 = -1.0
      DO 75 IH = 1,11
      HC = SHTRHT(IH)
      IF ((SH(ISPI).GT.HM1).AND.(SH(ISPI).LE.HC))
     &   SCOV(IP1,ITHN,IH) = SCOV(IP1,ITHN,IH) + PBCV(ISPI)
      HM1 = HC
   75 CONTINUE
   80 CONTINUE
C
C     IF THERE ARE NO SHRUBS OF A GIVEN CLASS, SET THE AVERAGE HEIGHT
C     TO ZERO
C
      IF (SUMPB.LE.1E-4) THEN
         ASHT(IP1,ITHN) = 0.0
      ELSE
         ASHT(IP1,ITHN) = HEIGHT/SUMPB
      ENDIF
      IF (TSUMPB.LE.1E-4) THEN
         TALLSH = 0.0
      ELSE
         TALLSH = TSHT/TSUMPB
      ENDIF
C
      J = 11
      DO 90 IH = 1,10
      J = J - 1
      JP1 = J + 1
      SCOV(IP1,ITHN,J) = SCOV(IP1,ITHN,J) + SCOV(IP1,ITHN,JP1)
   90 CONTINUE
C----------
C  ORDER SPECIES BY HIGHEST PREDICTED COVER VALUE.  SAVE THE FIRST
C  THREE FOR OUTPUT, AND DUMP EVERYTHING ELSE INTO AN 'OTHER'
C  CATEGORY.  DO FOR THREE HEIGHT CLASSES, 'LOW' SHRUBS, 'MEDIUM'
C  SHRUBS, AND 'TALL' SHRUBS.
C----------
C LOW:SPECIES 1-7    MED:SPECIES 8-19    TALL:SPECIES 20-31
C----------
      DO 120 IG = 1,3
      OTHCOV = 0.0
      OTHHT = 0.0
      OTHPB = 0.0
C
      DO 100 I = 1,NUM(IG)
      K = I + INC(IG)
      PASS(I) = PBCV(K)
      OTHCOV = OTHCOV + PBCV(K)
      OTHHT = OTHHT + SH(K)*PBCV(K)
      OTHPB = OTHPB + PB(K)
  100 CONTINUE
      IF (IG .EQ. 1) CLOW(IP1,ITHN) = OTHCOV
      IF (IG .EQ. 2) CMED(IP1,ITHN) = OTHCOV
      IF (IG .EQ. 3) CTALL(IP1,ITHN) = OTHCOV
C
      CALL RDPSRT (NUM(IG),PASS,INDX,.TRUE.)
C
      DO 110 I=1,3
      K = INDX(I) + INC(IG)
      OTHCOV = OTHCOV - PBCV(K)
      OTHHT = OTHHT - SH(K)*PBCV(K)
      OTHPB = OTHPB - PB(K)
      J = I + IGSP(IG)
      SCV(IP1,ITHN,J) = PBCV(K)
      SPB(IP1,ITHN,J) = 100.*PB(K)
      SHT(IP1,ITHN,J) = SH(K)
      ISSP(IP1,ITHN,J) = K
  110 CONTINUE
      JP1 = J + 1
      SCV(IP1,ITHN,JP1) = OTHCOV
      IF (OTHCOV.LE.1E-4) THEN
         SHT(IP1,ITHN,JP1) = 0.0
      ELSE
         SHT(IP1,ITHN,JP1) = OTHHT/OTHCOV
      ENDIF
      SPB(IP1,ITHN,JP1) = 100.*OTHPB
      ISSP(IP1,ITHN,JP1) = 32
  120 CONTINUE
C----------
C  LOAD USER-SELECTED SPECIES ARRAYS FOR DISPLAY.
C----------
      IF (.NOT. LSHOW) GO TO 140
      DO 130 I=1,NSHOW
      J = ISHOW(I)
      CIND(IP1,ITHN,I) = PBCV(J)
      PIND(IP1,ITHN,I) = 100.*PB(J)
      HIND(IP1,ITHN,I) = SH(J)
      INDSP(IP1,ITHN,I) = J
  130 CONTINUE
  140 CONTINUE
C
  150 CONTINUE
C=======================================================================
C
C  **COMPUTE TREE BY HEIGHT CLASS VALUES USED IN CANOPY OPTION
C  OR IN CVCLAS**
C
C----------
C  INITIALIZE VARIABLES FOR THE CURRENT CYCLE.
C----------
      STDHT(IP1,ITHN) = AVH
      ICVAGE(IP1) = IAGE + IY(IP1) - IY(1)
C
      HTMAX = 0.0
      HTMIN = 999.0
      TPCTCV(IP1,ITHN) = 0.0
      TPROAR(IP1,ITHN) = 0.0
      TCVOL(IP1,ITHN) = 0.0
      TOTBMS(IP1,ITHN) = 0.0
      TRETOT(IP1,ITHN) = 0.0
      SDIAM(IP1,ITHN) = 0.0
      DO 50 J = 1,16
      CRXHT(J) = 0.0
      SD2XHT(J) = 0.0
      TXHT(IP1,ITHN,J) = 0.0
      PCXHT(IP1,ITHN,J) = 0.0
      PROXHT(IP1,ITHN,J) = 0.0
      VOLXHT(IP1,ITHN,J) = 0.0
      CFBXHT(IP1,ITHN,J) = 0.0
   50 CONTINUE
C----------
C  RETURN IF NOTREES OPTION IN EFFECT.
C----------
      IF (ITRN .GT. 0) GO TO 60
      HTMIN = 0.0
      IF (DEBUG) WRITE (JOSTND,9001) ITRN
 9001 FORMAT (' ITRN =', I5,' : NOTREES : RETURN TO **CVCNOP**')
      RETURN
   60 CONTINUE
C----------------------------------------------------------------------
C  ENTER TREE LOOP.
C----------------------------------------------------------------------
      IF ((LCNOP).AND.(DEBUG)) WRITE (JOSTND,9010)
 9010 FORMAT ('      I  J     FRUST    ',
     &'TREVOL   CVOLUM    PAREA    TREAR    CAREA    BASE   UPLIM',
     &'  LOWLIM      H1      H2      Y1      Y1  TRFBMS')
      DO 300 I = 1,ITRN
C----------
C  COMPUTE SHRUB-SMALL CONIFER COMPETITION VALUES, IF SHRUBS ARE
C  AVAILABLE.
C----------
      IF (.NOT. LBROW) GO TO 161
      HM1 = -1.0
      DO 160 IH = 1,11
      HC = SHTRHT(IH)
      IF ((HT(I).GT.HM1).AND.(HT(I).LE.HC))
     &     TRSH(IP1,ITHN,IH) = TRSH(IP1,ITHN,IH) + PROB(I)
      HM1 = HC
  160 CONTINUE
  161 CONTINUE
C
      IF (HT(I) .GT. HTMAX) HTMAX = HT(I)
      IF (HT(I) .LT. HTMIN) HTMIN = HT(I)
C----------
C  COMPUTE HEIGHT CLASS OF TOP OF TREE.
C  CLASSES ARE 0-10', 10.01-20', ..., 140.01-150', 150'+
C----------
      ITOP = IFIX(HT(I)/10.0001) + 1
      IF (ITOP .GT. 16) ITOP = 16
C----------
C  COMPUTE CROWN PROJECTION, NUMBER OF TREES, AND SUM OF SQUARED
C  DIAMETERS BY HEIGHT CLASS NEEDED BY **CVCLAS**.
C  CONSTANT = PI*CW/2*CW/2 = .785398
C----------
      CRXHT(ITOP) = CRXHT(ITOP) + .785398*TRECW(I)*TRECW(I)*PROB(I)
      TXHT(IP1,ITHN,ITOP) = TXHT(IP1,ITHN,ITOP) + PROB(I)
      SD2XHT(ITOP) = SD2XHT(ITOP) + DBH(I)*DBH(I)*PROB(I)
C-----------
C  SKIP THIS SECTION IF CANOPY OPTION IS NOT SPECIFIED.
C----------
      IF (.NOT. LCNOP) GO TO 300
C----------
C  COMPUTE HEIGHT CLASS OF CROWN BOTTOM.
C----------
      BOT = HT(I) - (HT(I)*ICR(I)/100.)
      IBOT = IFIX (BOT/10.) + 1
C----------
C  COMPUTE DIMENSIONS USED IN HEIGHT CLASS CALCULATIONS.
C----------
      ISHAP = ISHAPE(I)
      IICR = ICR(I)
      HC = FLOAT(IICR)*HT(I)/100.
      BASE = BOT
      IF ((ISHAP.EQ.1) .OR. (ISHAP.EQ.5)) BASE = BOT + HC/2.
      RAD = TRECW(I)/2.
      TREVOL = 0.0
      TREAR = 0.0
C----------
C  SET INITIAL CANOPY HEIGHTS FOR CURRENT TREE.
C----------
      CNOP(1) = 10.*IBOT-20.
      CNOP(2) = CNOP(1) + 10.
C----------
C  ENTER HEIGHT CLASS LOOP WITHIN CURRENT TREE.  J1 IS USED TO
C  DECREMENT THE INDEX BY HEIGHT CLASS IF THE SHAPE IS NEILOID
C  (I.E. DO IT UPSIDE-DOWN).
C----------
      J1 = ITOP + 1
      DO 290 J = IBOT,ITOP
      IF (ISHAP .NE. 3) J1 = J
      IF (ISHAP .EQ. 3) J1 = J1 - 1
      DO 230 K=1,2
      CNOP(K) = CNOP(K) + 10.
  230 CONTINUE
      UPLIM = AMIN1(HT(I),CNOP(2))
      IF (J.EQ. ITOP) UPLIM = HT(I)
      LOWLIM = AMAX1(BOT,CNOP(1))
      H1 = LOWLIM - BASE
      H2 = UPLIM - LOWLIM
      R1 = (1.-H1/HC)*RAD
      R2 = (1.-(H1+H2)/HC)*RAD
      Y1 = LOWLIM - BASE
      Y2 = UPLIM - BASE
      IF (Y1 .GE. HC) Y1 = HC
      IF (Y2 .GE. HC) Y2 = HC
      IF (Y1 .LT. -HC) Y1 = -HC
      IF (Y2 .LT. -HC) Y2 = -HC
C----------
C  BRANCH ON SHAPE TO COMPUTE FRUSTRUM VOLUME AND PROFILE AREA.
C----------
      GO TO (241,242,243,244,245),ISHAP
C----------
C  ISHAPE=1   SOLID FORM=SPHERE    PLANE FORM=CIRCLE
C----------
  241 CONTINUE
      CVOLUM = 2.09439*RAD*RAD*HC
      CAREA = 1.57079*RAD*HC
      IF (BASE.GE.LOWLIM) H1 = BASE - UPLIM
      B1 = HC/2.
      IF(Y1.GT.B1) Y1=B1
      IF(Y1.LT.-B1) Y1=-B1
      IF(Y2.GT.B1) Y2=B1
      IF(Y2.LT.-B1) Y2=-B1
      Z1=B1*B1-Y1*Y1
      Z2=B1*B1-Y2*Y2
      IF(Z1.LT.0.0) Z1=0.0
      IF(Z2.LT.0.0) Z2=0.0
      CONST = 1.04720*H2*RAD*RAD/(HC*HC)
      FRUST = CONST*(3*HC*HC - 12*H1*H1 - 12*H1*H2 - 4*H2*H2)
      PAREA = RAD/B1*(Y2*SQRT(Z2)+B1**2*ASIN(Y2/B1))-
     &        RAD/B1*(Y1*SQRT(Z1)+B1**2*ASIN(Y1/B1))
      GO TO 280
C----------
C  ISHAPE=2   SOLID FORM=CONE   PLANE FORM=TRIANGLE
C----------
  242 CONTINUE
      CVOLUM = 1.04719*RAD*RAD*HC
      CAREA = RAD*HC
      CONST = 1.04720*H2
      FRUST = CONST*(R1*R1+R2*R2+R1*R2)
      PAREA = (R1+R2)*H2
      GO TO 280
C----------
C  ISHAPE=3   SOLID FORM=NEILOID   PLANE FORM=NEILOID
C----------
  243 CONTINUE
      CVOLUM = 1.57079*RAD*RAD*HC
      CAREA = .33333*RAD*HC
      FRUST = (3.14159*RAD*RAD*H2) -
     &        (1.57079*H2*RAD**2/HC)*(2*HC-2*H1-H2)
      PAREA = RAD*((Y2+.66667*HC*(1-Y2/HC)**1.5) -
     &             (Y1+.66667*HC*(1-Y1/HC)**1.5))
      GO TO 280
C----------
C  ISHAPE=4   SOLID FORM=PARABOLOID   PLANE FORM=PARABOLA
C----------
  244 CONTINUE
      CVOLUM = 1.57079*RAD*RAD*HC
      CAREA = 1.33333*RAD*HC
      FRUST = (1.57079*H2*RAD**2/HC)*(2*HC-2*H1-H2)
      PAREA = -RAD*1.33333*HC*((1-(Y2/HC))**1.5 - (1-(Y1/HC))**1.5)
      GO TO 280
C----------
C  ISHAPE=5   SOLID FORM=ELLIPSOID   PLANE FORM=ELLIPSE
C----------
  245 CONTINUE
      CVOLUM = 2.09439*RAD*RAD*HC
      CAREA = 1.57079*RAD*HC
      IF (BASE.GE.LOWLIM) H1 = BASE - UPLIM
      B1 = HC/2.
      IF(Y1.GT.B1) Y1=B1
      IF(Y1.LT.-B1) Y1=-B1
      IF(Y2.GT.B1) Y2=B1
      IF(Y2.LT.-B1) Y2=-B1
      Z1=B1*B1-Y1*Y1
      Z2=B1*B1-Y2*Y2
      IF(Z1.LT.0.0) Z1=0.0
      IF(Z2.LT.0.0) Z2=0.0
      CONST = 1.04720*H2*RAD*RAD/(HC*HC)
      FRUST = CONST*(3*HC*HC - 12*H1*H1 - 12*H1*H2 - 4*H2*H2)
      PAREA = RAD/B1*(Y2*SQRT(Z2)+B1**2*ASIN(Y2/B1))-
     &        RAD/B1*(Y1*SQRT(Z1)+B1**2*ASIN(Y1/B1))
  280 CONTINUE
C----------
C  COMPUTE TOTAL VOLUME, PROFILE AREA, AND PROPORTION OF
C  FRUSTRUM TO TOTAL.
C----------
      TREVOL = TREVOL + FRUST
      TREAR = TREAR + PAREA
      PROP = FRUST/CVOLUM
C----------
C  COMPUTE PROFILE AREA, CROWN VOLUME, AND FOLIAGE BIOMASS WITHIN
C  HEIGHT CLASS.
C----------
      PROXHT(IP1,ITHN,J1) = PROXHT(IP1,ITHN,J1) + PAREA*PROB(I)
      VOLXHT(IP1,ITHN,J1) = VOLXHT(IP1,ITHN,J1) + FRUST*PROB(I)
      CFBXHT(IP1,ITHN,J1) = CFBXHT(IP1,ITHN,J1) +
     &                     TRFBMS(I)*PROP*PROB(I)
C
      IF (DEBUG) WRITE (JOSTND,7000) I,J1,FRUST,TREVOL,CVOLUM,
     & PAREA,TREAR,CAREA,BASE,UPLIM,LOWLIM,H1,H2,Y1,Y2,TRFBMS(I)
 7000 FORMAT (I6,I3,F7.2,5F10.2,8F8.2)
C----------
C  END LAYER LOOP
C----------
  290 CONTINUE
C----------
C  COMPUTE SUM OF DIAMETERS
C----------
      SDIAM(IP1,ITHN) = SDIAM(IP1,ITHN) + DBH(I)*PROB(I)/12.
C----------
C  END TREE LOOP
C----------
  300 CONTINUE
C----------
C  COMPUTE TOTALS FOR CANOPY VALUES.
C----------
      DO 350 J = 1,16
      PCXHT(IP1,ITHN,J) = CRXHT(J)/435.6
      TPCTCV(IP1,ITHN) = TPCTCV(IP1,ITHN) + PCXHT(IP1,ITHN,J)
C----------
C  ADJUST HEIGHT CLASS CANOPY COVER FOR CROWN OVERLAP
C----------
      PCXHT(IP1,ITHN,J) = 100.*(1.-EXP(-.01*PCXHT(IP1,ITHN,J)))
      TRETOT(IP1,ITHN) = TRETOT(IP1,ITHN) + TXHT(IP1,ITHN,J)
      TPROAR(IP1,ITHN) = TPROAR(IP1,ITHN) + PROXHT(IP1,ITHN,J)
      TCVOL(IP1,ITHN) = TCVOL(IP1,ITHN) + VOLXHT(IP1,ITHN,J)
      TOTBMS(IP1,ITHN) = TOTBMS(IP1,ITHN) + CFBXHT(IP1,ITHN,J)
  350 CONTINUE
C----------
C  ADJUST TOTAL CANOPY COVER FOR CROWN OVERLAP
C----------
      TPCTCV(IP1,ITHN) = 100.*(1.-EXP(-.01*TPCTCV(IP1,ITHN)))
C----------
C  COMPUTE TREE TOTALS FOR SHRUB-SMALL CONIFER DISPLAY.
C----------
      IF (.NOT. LBROW) GO TO 400
      J = 11
      DO 399 IH = 1,10
      J = J - 1
      JP1 = J + 1
      TRSH(IP1,ITHN,J) = TRSH(IP1,ITHN,J) + TRSH(IP1,ITHN,JP1)
  399 CONTINUE
  400 CONTINUE
C=======================================================================
      RETURN
      END
