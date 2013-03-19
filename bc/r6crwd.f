      SUBROUTINE R6CRWD(ISPC,D,H,CRWDTH)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C  **R6CRWD--SEI   DATE OF LAST REVISION:  02/24/12
C----------
C  THIS ROUTINE COMPUTES CROWN WIDTH FOR INDIVIDUAL TREES.
C  CALLED FROM CCFCAL IN ALL REGION 6 VARIANTS, AND FOR THE
C  NI, KT, AND IE VARIANTS.
C
C  EQUATIONS FOR TREES LARGER THAN 4.5 FEET TALL WERE FIT BY
C  DENNIS DONNELLY (FOREST MANAGEMENT SERVICE CENTER, FORT COLLINS,
C  COLORADO) FROM INVENTORY DATA PROVIDED SPECIFICALLY FOR THIS
C  PURPOSE BY TOMMY GREGG IN REGION 6.  EQUATIONS ARE OF THE FORM:
C  CW = A * (DBH)**B     CW IN FEET, DBH IN INCHES
C
C  EQUATIONS FOR TREES LESS THAN 4.5 FEET TALL ARE OF THE FORM
C  CW = CONSTANT * HEIGHT, WHERE THE CONSTANT IS THE SLOPE OF A
C  STRAIGHT LINE THROUGH THE POINTS (H=0, CW=0) AND
C  (H=4.5, CW=VALUE OF DONNELLY EQUATION AT BUD WIDTH)
C
C----------
C  DEFINITION OF VARIABLES:
C
C     CROWN WIDTH COEFFICIENTS FOR TREES WITH HEIGHT > 4.5 FEET
C      CRWDTH = BG1() * D**BG2()
C      BG1 -- CONSTANT TERM OR INTERCEPT, SUBSCRIPTED BY SPECIES.
C      BG1 -- EXPONENT, SUBSCRIPTED BY SPECIES.
C
C     CROWN WIDTH COEFFICIENTS FOR TREE WITH HEIGHT <= 4.5 FEET
C      CRWDTH = SM * H
C      SM  -- SLOPE, SUBSCRIPTED BY SPECIES
C
C     CRWDTH = CROWN WIDTH FOR A TREE (FEET)
C     D      = DIAMETER AT BREAST HEIGHT (INCHES)
C     H      = TOTAL TREE HEIGHT (FEET)
C     ISPC   = NUMERIC SPECIES CODE
C
C  ORDER OF COEFFICIENTS IN THIS SUBROUTINE:
C
C   1 = DOUGLAS FIR                     PSEUDOTSUGA MENZIESII
C   2 = PACIFIC SILVER FIR              ABIES AMABILIS
C   3 = WHITE FIR                       ABIES CONCOLOR
C   4 = GRAND FIR                       ABIES GRANDIS
C   5 = SUBALPINE FIR                   ABIES LASIOCARPA
C   6 = RED FIR                         ABIES MAGNIFICA
C   7 = NOBLE FIR                       ABIES PROCERA
C
C   8 = INCENSE CEDAR                   CALOCEFRUS DECURRENS
C   9 = PORT ORFORD CEDAR               CHAMAECYPARIS LAWSONIA
C  10 = ALASKA CEDAR                    CHAMAECYPARIS NOOTKATENSIS
C  11 = WESTERN RED CEDAR               THUJA PLICATA
C
C  12 = SUBALPINE LARCH                 LARIX LYALLII
C  13 = WESTERN LARCH                   LARIX OCCIDENTALIS
C
C  14 = WESTERN HEMLOCK                 TSUGA HETEROPHYLLA
C  15 = MOUNTAIN HEMLOCK                TSUGA MERTENSIANA
C
C  16 = PACIFIC YEW                     TAXUS BREVIFOLIA
C
C  17 = WHITEBARK PINE                  PINUS ALBICAULIS
C  18 = KNOBCONE PINE                   PINUS ATTENUATA
C  19 = LODGEPOLE PINE                  PINUS CONTORTA
C  20 = JEFFREY PINE                    PINUS JEFFREYI
C  21 = SUGAR PINE                      PINUS LAMBERTIANA
C  22 = WESTERN WHITE PINE              PINUS MONTICOLA
C  23 = PONDEROSA PINE                  PINUS PONDEROSA
C
C  24 = ENGELMANN SPRUCE                PICEA ENGELMANNII
C  25 = SITKA SPRUCE                    PICEA SITCHENSIS
C
C  26 = BIG LEAF MAPLE                  ACER MACROPHYLLUM
C  27 = RED ALDER                       ALNUS RUBRA
C  28 = PAPER BIRCH                     BETULA PAPYRIFERA
C  29 = QUAKING ASPEN                   POPULUS TREMULOIDES
C  30 = OREGON WHITE OAK                QUERCUS GARRYANA
C----------
      CHARACTER VVER*7
      INTEGER   ISPC, INDX
      INTEGER   MAPSO(33),MAPEC(32),MAPBM(11),MAPNC(11),MAPWC(39),
     &          MAPNI(11),MAPCA(49),MAPIE(23),MAPAK(13)
      INTEGER   MAPBC(15)
      REAL      D, H, CRWDTH
      REAL      BG1(30),BG2(30),SM(30)
C
      DATA BG1/
     & 4.4215, 3.9723, 3.8166, 4.1870, 3.2348, 3.1146, 3.0614, 4.0920,
     & 5.3864, 3.5341, 6.2318, 2.1039, 2.9571, 5.4864, 2.9372, 4.5859,
     & 2.1606, 2.1451, 2.4132, 3.2367, 3.0610, 3.4447, 2.8541, 3.6802,
     & 4.2857, 7.5183, 7.0806, 5.8980, 4.0910, 2.4922/
      DATA BG2/
     & 0.5329, 0.5177, 0.5229, 0.5341, 0.5179, 0.5780, 0.6276, 0.4912,
     & 0.4213, 0.5374, 0.4259, 0.6758, 0.6081, 0.5144, 0.5878, 0.4841,
     & 0.6897, 0.7132, 0.6403, 0.6247, 0.6201, 0.5185, 0.6400, 0.4940,
     & 0.5940, 0.4461, 0.4771, 0.4841, 0.5907, 0.8544/
      DATA SM/
     &  0.517,  0.473,  0.452,  0.489,  0.385,  0.345,  0.320,  0.412,
     &  0.608,  0.331,  0.698,  0.207,  0.316,  0.533,  0.253,  0.468,
     &  0.255,  0.248,  0.298,  0.406,  0.385,  0.476,  0.407,  0.451,
     &  0.466,  0.815,  0.730,  0.601,  0.351,  0.140/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --SO-- VARIANT
C 1=WP, 2=SP, 3=DF, 4=WF, 5=MH, 6=IC, 7=LP, 8=ES, 9=RF, 10=PP, 11=OT
C  SPECIES ORDER: SO
C  1=WP,  2=SP,  3=DF,  4=WF,  5=MH,  6=IC,  7=LP,  8=ES,  9=SH,  10=PP,
C 11=JU, 12=GF, 13=AF, 14=SF, 15=NF, 16=WB, 17=WL, 18=RC, 19=WH,  20=PY,
C 21=WA, 22=RA, 23=BM, 24=AS, 25=CW, 26=CH, 27=WO, 28=WI, 29=GC,  30=MC,
C 31=MB, 32=OS, 33=OH
C
C SURROGATES: LP FOR OT
C SO USES SAME MAPPPING AS WC FOR ADDED SPECIES
C
      DATA MAPSO/
     & 22, 21,  1,  3, 15,  8, 19, 24,  6, 23,
     & 19,  3,  6,  2,  7, 17, 13, 11, 14, 16,
     & 27, 27, 26, 29, 26, 16, 30, 16, 30,  1,
     &  1,  1,  1/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --EC-- VARIANT
C  1=WP,  2=WL,  3=DF,  4=SF,  5=RC,  6=GF,  7=LP,  8=ES,  9=AF, 10=PP,
C 11=WH, 12=MH, 13=PY, 14=WB, 15=NF, 16=WF, 17=LL, 18=YC, 19=WJ, 20=BM,
C 21=VN, 22=RA, 23=PB, 24=GC, 25=DG, 26=AS, 27=CW, 28=WO, 29=PL, 30=WI,
C 31=OS, 32=OH
C
C SURROGATES: LP FOR WJ, BM FOR VN, WO FOR GC, WO FOR DG, BM FOR CW,
C             PY FOR PL, PY FOR WI, RC FOR OS, AS FOR OH
C
      DATA MAPEC/
     & 22, 13,  1,  2, 11,  4, 19, 24,  5, 23,
     & 14, 11, 16, 17,  7,  3, 12, 10, 19, 26,
     & 26, 27, 28, 30, 30, 29, 26, 30, 16, 16,
     & 11, 29/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --BM-- VARIANT
C 1=WP, 2=WL, 3=DF, 4=GF, 5=MH, 6=__, 7=LP, 8=ES, 9=AF, 10=PP, 11=OT
C
C SURROGATES: LP FOR OT
C
      DATA MAPBM/
     & 22, 13,  1,  4, 15, 15, 19, 24,  5, 23, 19/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --IE-- VARIANT
C  1=WP, 2=L , 3=DF, 4=GF, 5=WH, 6=C , 7=LP, 8=S , 9=AF, 10=PP, 11=OT,
C 12=WB, 13=LM, 14=LL, 15=PI, 16=JU, 17=PY, 18=AS, 19=CO, 20=MM,
C 21=PB, 22=OH, 23=0S
C
C SURROGATES: LP FOR LM,PI,JU; BIG LEAF MAPLE FOR CO; PB FOR MM; 
C             AS FOR OH; MH FOR OS
C
      DATA MAPIE/
     & 22, 13,  1,  4, 14, 11, 19, 24,  5, 23, 15,
     & 17, 19, 12, 19, 19, 16, 29, 26, 28, 28, 29, 15/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --NC-- VARIANT
C 1=OC, 2=SP, 3=DF, 4=WF, 5=M , 6=IC, 7=BO, 8=TO, 9=RF, 10=PP, 11=OH
C
C SURROGATES: DF FOR OC, BM FOR M, WO FOR BO, BM FOR TO, BM FOR OH
C
      DATA MAPNC/
     &  1, 21,  1,  3, 26,  8, 30, 26,  6, 23, 26/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --NI-- & --KT-- VARIANTS
C 1=WP, 2=L , 3=DF, 4=GF, 5=WH, 6=C , 7=LP, 8=S , 9=AF, 10=PP, 11=OT
C
C SURROGATES: MH FOR OT
C
      DATA MAPNI/
     & 22, 13,  1,  4, 14, 11, 19, 24,  5, 23, 15/

C----------
C MAPPING FUNCTION FOR SPECIES IN THE --WC-- & --PN-- VARIANTS
C  1=SF,  2=WF,  3=GF,  4=AF,  5=RF,  6=SS,  7=NF,  8=YC,  9=IC, 10=ES,
C 11=LP, 12=JP, 13=SP, 14=WP, 15=PP, 16=DF, 17=RW, 18=RC, 19=WH, 20=MH,
C 21=BM, 22=RA, 23=WA, 24=PB, 25=GC, 26=AS, 27=CW, 28=WO, 29=J , 30=LL,
C 31=WB, 32=KP, 33=PY, 34=DG, 35=HW, 36=BC, 37=WI, 38=__, 39=OT
C
C SURROGATES: DF FOR RW, RA FOR WA, WO FOR GC, BM FOR CO, PY FOR J,
C             WO FOR DG, PY FOR HW, PY FOR BC, PY FOR WI, DF FOR OT
C
      DATA MAPWC/
     &  2,  3,  4,  5,  6, 25,  7, 10,  8, 24,
     & 19, 20, 21, 22, 23,  1,  1, 11, 14, 15,
     & 26, 27, 27, 28, 30, 29, 26, 30, 16, 12,
     & 17, 18, 16, 30, 16, 16, 16, 16,  1/
C----------
C  MAPPING FUNCTION FOR THE CA VARIANT
C
C  1=PC  2=IC  3=RC  4=WF  5=RF  6=SF  7=DF  8=WH  9=MH 10=WB
C 11=KP 12=LP 13=CP 14=LM 15=JP 16=SP 17=WP 18=PP 19=MP 20=GP
C 21=JU 22=BS 23=GS 24=PY 25=OS 26=LO 27=CY 28=DO 29=EO 30=WO
C 31=BO 32=VO 33=IO 34=BM 35=BU 36=RA 37=MA 38=GC 39=DG 40=OA
C 41=WA 42=TO 43=SY 44=AS 45=CO 46=WI 47=CN 48=BL 49=OH
C----------
      DATA MAPCA /
     &  9,  8, 11,  3,  6,  6,  1, 14, 15, 17,
     & 18, 19, 23, 23, 20, 21, 22, 23, 23, 23,
     & 16, 24,  1, 16, 23, 30, 30, 30, 30, 30,
     & 30, 30, 30, 26, 30, 27, 29, 30, 30, 29,
     & 26, 29, 29, 29, 26, 16, 29, 26, 30/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --AK-- VARIANT
C  1=WS,  2=RC, 3=SF, 4=MH, 5=WH, 6=YC, 7=LP, 8=SS, 9=AF, 10=RA, 11=CW
C 12=OH, 13=OS
C
C R6CRWD IS ONLY CALLED FOR RED ALDER AND BLACK COTTONWOOD IN AK.
C
      DATA MAPAK/
     & 9*99, 27, 26, 2*99/
C----------
C MAPPING FUNCTION FOR SPECIES IN THE --SEI-- VARIANT
C  1=pw,  2=lw,  3=fd,  4=bg, 5=hw, 6=cw, 7=pl, 8=se, 9=bl, 10=pp,
C 11=ep, 12=at, 13=ac, 14=oc(fd), 15=oh(ep)
C
C ONLY ISPC=11,12,13,15 ARE USED
C SURROGATES: RA(27) FOR AC - COTTONWOOD
C
C
      DATA MAPBC/
     &  22, 13,  1,  4, 14,
     &  11, 19, 24,  5, 23,
     &  28, 29, 27,  1, 28 /

C----------
C IF SPECIES IS ZERO, RETURN
C----------
      IF(ISPC .EQ. 0) THEN
        CRWDTH=0.
        GO TO 100
      ENDIF
C----------
C ASSIGN THE APPROPRIATE EQUATION NUMBER BASED ON THE VARIANT.
C----------
      CALL VARVER(VVER)
      IF (VVER(:2).EQ.'BC') THEN
        INDX=MAPBC(ISPC)
      ELSEIF (VVER(:2).EQ.'SO') THEN
        INDX=MAPSO(ISPC)
      ELSEIF (VVER(:2).EQ.'EC') THEN
        INDX=MAPEC(ISPC)
      ELSEIF (VVER(:2).EQ.'BM') THEN
        INDX=MAPBM(ISPC)
      ELSEIF (VVER(:2).EQ.'IE') THEN
        INDX=MAPIE(ISPC)
      ELSEIF (VVER(:2).EQ.'NC') THEN
        INDX=MAPNC(ISPC)
      ELSEIF (VVER(:2).EQ.'WC' .OR. VVER(:2).EQ.'PN') THEN
        INDX=MAPWC(ISPC)
      ELSEIF (VVER(:2).EQ.'NI' .OR. VVER(:2).EQ.'KT') THEN
        INDX=MAPNI(ISPC)
      ELSEIF (VVER(:2).EQ.'CA') THEN
        INDX=MAPCA(ISPC)
      ELSEIF (VVER(:2).EQ.'AK') THEN
        INDX=MAPAK(ISPC)
       ELSE
        INDX=99
      ENDIF
C----------
C COMPUTE CROWN WIDTH
C----------
      IF(INDX .EQ. 99) THEN
        CRWDTH=0.
        GO TO 100
      ENDIF
C
      IF(H .GT. 4.5) THEN
        CRWDTH = BG1(INDX) * D**BG2(INDX)
      ELSE
        CRWDTH = SM(INDX) * H
      ENDIF
C
  100 CONTINUE
      RETURN
      END
