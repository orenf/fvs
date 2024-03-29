      SUBROUTINE HTDBH (IFOR,ISPC,D,H,MODE)
      IMPLICIT NONE
C----------
C  **HTDBH--LS  DATE OF LAST REVISION:  07/11/08
C----------
C  THIS SUBROUTINE CONTAINS THE DEFAULT HEIGHT-DIAMETER RELATIONSHIPS
C  FROM THE INVENTORY DATA.  IT IS CALLED FROM CRATET TO DUB MISSING
C  HEIGHTS, AND FROM REGENT TO ESTIMATE DIAMETERS (PROVIDED IN BOTH
C  CASES THAT LHTDRG IS SET TO .TRUE.).
C
C  COEFFICIENTS DEVELOPED FOR THE SN VARIANT USING SOUTHERN TREE DATA.
C
C  DEFINITION OF VARIABLES:
C         D = DIAMETER AT BREAST HEIGHT
C         H = TOTAL TREE HEIGHT (STUMP TO TIP)
C         DB= BUDWIDTH(INCHES) AT HEIGHT = 5.51 FT.
C
C  LOCAL ARRAYS
C         SNALL = CURTIS-ARNEY COEFFICIENTS FOR ALL SPECIES.  ALL
C                 SOUTHERN TREE DATA WERE USED IN DEVELOPMENT OF
C                 THESE COEFFS.
C        SNDBAL = BUDWITH, TRANSITION DIAMETER, ESTIMATES FOR ALL
C                 SPECIES
C        IWYKCA = 0 IF USING WKYOFF EQNS; 1 IF USING CURTIS-ARNEY
C
C      MODE = MODE OF OPERATING THIS SUBROUTINE
C             0 IF DIAMETER IS PROVIDED AND HEIGHT IS DESIRED
C             1 IF HEIGHT IS PROVIDED AND DIAMETER IS DESIRED
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
COMMONS
C
      REAL SNALL(3,68), SNDBAL(68)
      INTEGER IWYKCA(68)
      INTEGER MODE,ISPC,IFOR,I,J
      REAL H,D,P2,P3,P4,DB,HAT3
      LOGICAL DEBUG
C
C================================================
C     SPECIES LIST FOR LAKE STATES
C================================================
C     1 = JACK PINE (JP)
C     2 = SCOTCH PINE (SC)
C     3 = RED PINE NATURAL (RN)
C     4 = RED PINE PLANTATION (RP)
C     5 = EASTERN WHITE PINE (WP)
C     6 = WHITE SPRUCE (WS)
C     7 = NORWAY SPRUCE (NS)
C     8 = BALSAM FIR (BF)
C     9 = BLACK SPRUCE (BS)
C    10 = TAMARACK (TA)
C    11 = NORTHERN WHITE-CEDAR (WC)
C    12 = EASTERN HEMLOCK (EH)
C    13 = OTHER SOFTWOOD SPECIES (OS)
C    14 = EASTERN REDCEDAR (RC)
C    15 = BLACK ASH (BA)
C    16 = GREEN ASH (GA)
C    17 = EASTERN COTTONWOOD (EC)
C    18 = SILVER MAPLE (SV)
C    19 = RED MAPLE (RM)
C    20 = BLACK CHERRY (BC)
C    21 = AMERICAN ELM (AE)
C    22 = SLIPPERY ELM (RL)
C    23 = ROCK ELM (RE)
C    24 = YELLOW BIRCH (YB)
C    25 = AMERICAN BASSWOOD (BW)
C    26 = SUGAR MAPLE (SM)
C    27 = BLACK MAPLE (BM)
C    28 = AMERICAN BEECH (AB)
C    29 = WHITE ASH (WA)
C    30 = WHITE OAK (WO)
C    31 = SWAMP WHITE OAK (SW)
C    32 = BUR OAK (BR)
C    33 = CHINKAPIN OAK (CK)
C    34 = NORTHERN RED OAK (RO)
C    35 = BLACK OAK (BO)
C    36 = NORTHERN PIN OAK (NP)
C    37 = BITTERNUT HICKORY (BH)
C    38 = PIGNUT HICKORY (PH)
C    39 = SHAGBARK HICKORY (SH)
C    40 = BIGTOOTH ASPEN (BT)
C    41 = QUAKING ASPEN (QA)
C    42 = BALSAM POPLAR (BP)
C    43 = PAPER BIRCH (PB)
C    44 = COMMERCIAL HARDWOOD SPECIES (CH)
C    45 = BUTTERNUT (BN)
C    46 = BLACK WALNUT (WN)
C    47 = EASTERN HOPHORNBEAM (HH)
C    48 = BLACK LOCUST (BK)
C    49 = NON-COMMERCIAL HARDWOOD SPECIES (NC)
C    50 = BOXELDER (BE)
C    51 = STRIPED MAPLE (ST)
C    52 = MOUNTAIN MAPLE (MM)
C    53 = AMERICAN HORNBEAM (AH)
C    54 = AMERICAN CHESTNUT (AC)
C    55 = HACKBERRY (HK)
C    56 = FLOWERING DOGWOOD (DW)
C    57 = HAWTHORN SPECIES(HT)
C    58 = APPLE SPECIES (AP)
C    59 = BLACKGUM (BG)
C    60 = SYCAMORE (SY)
C    61 = PIN CHERRY (PR)
C    62 = CHOKECHERRY (CC)
C    63 = PLUMS, CHERRIES (PL)
C    64 = WILLOW SPECIES(WI)
C    65 = BLACK WILLOW (BL)
C    66 = DIAMOND WILLOW (DM)
C    67 = SASSAFRAS (SS)
C    68 = AMERICAN MOUNTAIN ASH (MA)
C----------
C
C----------
C     CURTIS-ARNEY COEFFICIENTS
C     ALL SOUTHERN DATA SNALL(I,J) I1=>P2, I2=>P3, I3=>P4, J= SPECIES
C----------
C
      DATA ((SNALL(I,J),I=1,3), J= 1,15)/
C 1=JACK PINE              USE SN EASTERN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 2=SCOTCH PINE            USE SN POND PINE (11)
     & 142.7468108,     3.97260802,     -0.5870983  ,
C 3=RED PINE NATURAL       USE SN EASTERN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 4=RED PINE PLANTATION    USE SN EASTERN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 5=EASTERN WHITE PINE     USE SN EASTERN WHITE PINE (12)
     & 2108.844224,     5.65948135,     -0.18563136 ,
C 6=WHITE SPRUCE           USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 7=NORWAY SPRUCE          USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 8=BALSAM FIR             USE SN FIR (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 9=BLACK SPRUCE           USE SN SPRUCE (3)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 10=TAMARACK              USE SN FIR (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 11=NORTHERN WHITE-CEDAR  USE SN FIR (1)
     & 2163.946776,     6.26880851,     -0.2161439  ,
C 12=EASTERN HEMLOCK       USE SN HEMLOCK (17)
     & 266.4562239,     3.99313675,     -0.38600287 ,
C 13=OTHER SOFTWOODS       USE SN JUNIPER (SP.) (2)
     & 212.7932729,     3.47154903,     -0.32585230 ,
C 14=EASTERN REDCEDAR      USE SN VIRGINIA PINE (14)
     & 926.1802712,     4.46209203,     -0.20053974 ,
C 15=BLACK ASH             USE SN BLACK ASH (36)
     & 178.9307637,     4.92861465,     -0.63777014 /
C
      DATA ((SNALL(I,J),I=1,3), J= 16,30)/
C 16=GREEN ASH             USE SN GREEN ASH (37)
     & 404.9692122,     3.39019741,     -0.255096   ,
C 17=EASTERN COTTONWOOD    USE SN COTTONWOOD (60)
     & 190.9797059,     3.69278884,     -0.52730469 ,
C 18=SILVER MAPLE          USE SN SILVER MAPLE (21)
     & 80.51179925,     26.98331005,     -2.02202808,
C 19=RED MAPLE             USE SN RED MAPLE (20)
     & 268.5564351,     3.11432843,     -0.29411156 ,
C 20=BLACK CHERRY          USE SN BLACK CHERRY (62)
     & 364.0247807,     3.55987361,     -0.27263121 ,
C 21=AMERICAN ELM          USE SN AMERICAN ELM (86)
     & 418.5941897,     3.17038578,     -0.18964025 ,
C 22=SLIPPERY ELM          USE SN SLIPPERY ELM (87)
     & 1337.547184,     4.48953501,     -0.14749529 ,
C 23=ROCK ELM              USE SN ELM (SP.) (84)
     & 1005.80672,      4.6473994,      -0.20336143 ,
C 24=YELLOW BIRCH          USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 25=AMERICAN BASSWOOD     USE SN BASSWOOD (83)
     & 293.5715132,     3.52261899,     -0.35122247 ,
C 26=SUGAR MAPLE           USE SN SUGAR MAPLE (22)
     & 209.8555358,     2.95281334,     -0.36787496 ,
C 27=BLACK MAPLE           USE SN SUGAR MAPLE (22)
     & 209.8555358,     2.95281334,     -0.36787496 ,
C 28=AMERICAN BEECH        USE SN AMERICAN BEECH (33)
     & 526.1392688,     3.89232121,     -0.22587084 ,
C 29=WHITE ASH             USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 30=WHITE OAK             USE SN WHITE OAK (63)
     & 170.1330787,     3.27815866,     -0.48744214 /
C
      DATA ((SNALL(I,J),I=1,3), J= 31,45)/
C 31=SWAMP WHITE OAK       USE SN CHERRYBARK OAK (66)
     & 182.6306309,     3.12897883,     -0.46391125 ,
C 32=BUR OAK               USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 ,
C 33=CHINKAPIN OAK         USE SN CHINKAPIN OAK (72)
     & 72.7907469,      3.67065539,     -1.09878979 ,
C 34=NORTHERN RED OAK      USE SN NORTHERN RED OAK (75)
     & 700.0636452,     4.10607389,     -0.21392785 ,
C 35=BLACK OAK             USE SN BLACK OAK (78)
     & 224.716279,      3.11648501,     -0.35982064 ,
C 36=NORTHERN PIN OAK      USE SN SCARLET OAK (64)
     & 196.0564703,     3.0067167,      -0.38499624 ,
C 37=BITTERNUT HICKORY     USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 38=PIGNUT HICKORY        USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 39=SHAGBARK HICKORY      USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 40=BIGTOOTH ASPEN        USE SN BIGTOOTH ASPEN (61)
     & 66.6488871,     135.4825559,     -2.88622709 ,
C 41=QUAKING ASPEN         USE SN HICKORY (SP.) (27)
     & 337.6684758,     3.62726466,     -0.32083172 ,
C 42=BALSAM POPLAR         USE SN WHITE ASH (35)
     & 91.35276617,     6.99605268,     -1.22937669 ,
C 43=PAPER BIRCH           USE SN BIRCH (SP.) (24)
     & 170.5253403,     2.68833651,     -0.40080716 ,
C 44=COMMERCIAL HDWDS      USE SN SUGAR MAPLE (22)
     & 209.8555358,     2.95281334,     -0.36787496 ,
C 45=BUTTERNUT             USE SN BUTTERNUT (42)
     & 285.8797853,     3.52138815,     -0.3193688  /
C
      DATA ((SNALL(I,J),I=1,3), J= 46,60)/
C 46=BLACK WALNUT          USE SN BLACK WALNUT (43)
     & 93.71042027,     3.6575094,      -0.88246833 ,
C 47=EASTERN HOPHORNBEAM   USE SN EASTERN HOPHORNBEAM (56)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 48=BLACK LOCUST          USE SN BLACK LOCUST (80)
     & 880.2844971,     4.59642097,     -0.21824277 ,
C 49=NON-COMM HARDWOODS    USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 50=BOXELDER              USE SN BUTTERNUT (42)
     & 285.8797853,     3.52138815,     -0.3193688  ,
C 51=STRIPED MAPLE         USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 52=MOUNTAIN MAPLE        USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 53=AMERICAN HORNBEAM     USE SN EASTERN HOPHORNBEAM (56)
     & 109.7324294,     2.25025802,     -0.41297463 ,
C 54=AMERICAN CHESTNUT     USE SN COTTONWOOD (60)
     & 190.9797059,     3.69278884,     -0.52730469 ,
C 55=HACKBERRY             USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 56=FLOWERING DOGWOOD     USE SN FLOWERING DOGWOOD (31)
     & 863.0501053,     4.38560239,     -0.14812185 ,
C 57=HAWTHRON (SP.)        USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 58=APPLE (SP.)           USE SN APPLE (SP.) (51)
     & 574.0200612,     3.86373895,     -0.16318776 ,
C 59=BLACKGUM              USE SN BLACKGUM (54)
     & 319.9788466,     3.67313408,     -0.30651323 ,
C 60=SYCAMORE              USE SN SYCAMORE (59)
     & 644.3567687,     3.92045786,     -0.21444786 /
C
      DATA ((SNALL(I,J),I=1,3), J= 61,68)/
C 61=PIN CHERRY            USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 62=CHOKECHERRY           USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 63=PLUMS, CHERRIES       USE SN APPLE (SP.) (51)
     & 574.0200612,     3.86373895,     -0.16318776 ,
C 64=WILLOW (SP.)          USE SN WILLOW (81)
     & 408.2772475,     3.81808285,     -0.27210505 ,
C 65=BLACK WILLOW          USE SN WILLOW (81)
     & 408.2772475,     3.81808285,     -0.27210505 ,
C 66=DIAMOND WILLOW        USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 ,
C 67=SASSAFRAS             USE SN SASSAFRAS (82)
     & 755.1038099,     4.39496421,     -0.21778831 ,
C 68=AM. MOUNTAIN ASH      USE SN HACKBERRY (SP.) (29)
     & 484.7529797,     3.93933286,     -0.25998833 /
C----------
C  TRANSITION VALUES (INCHES) IN EXTRAPOLATION TO SHORTER HEIGHTS.
C  THESE CORRESPOND TO THE BUDWIDTH PHYSICAL ATTRIBUTE.  IF THESE
C  ARE MODIFIED, ALSO MODIFY THE DIAM ARRAY IN THE REGCON ENTRY
C  IN **REGENT.
C----------
      DATA (SNDBAL(I), I= 1,68)/
     &   0.1, 0.5, 0.1, 0.1, 0.4, 0.2, 0.2, 0.1, 0.2, 0.1,
     &   0.1, 0.1, 0.3, 0.5, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1,
     &   0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.1, 0.2, 0.2,
     &   0.1, 0.2, 0.1, 0.2, 0.2, 0.2, 0.3, 0.3, 0.3, 0.2,
     &   0.3, 0.2, 0.1, 0.2, 0.3, 0.4, 0.2, 0.1, 0.1, 0.3,
     &   0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.1,
     &   0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1/
C----------
C  FLAGS WHETHER TO USE WYKOFF EQUATIONS (0), OR CURTIS-ARNEY 
C  EQUATIONS (1).
C----------
      DATA IWYKCA/
     & 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0,
     & 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     & 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0,
     & 1, 0, 0, 0, 0, 0, 1, 0/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTDBH',5,ICYC)
      IF(DEBUG)WRITE(JOSTND,2) ICYC
    2 FORMAT(' ENTERING SUBROUTINE HTDBH CYCLE =',I4)
C----------
C  SET EQUATION PARAMETERS ACCORDING TO FOREST AND SPECIES.
C----------
      P2 = SNALL(1,ISPC)
      P3 = SNALL(2,ISPC)
      P4 = SNALL(3,ISPC)
      DB = SNDBAL(ISPC)
C
      IF(MODE .EQ. 0) H=0.
      IF(MODE .EQ. 1) D=0.
C----------
C  PROCESS ACCORDING TO MODE AND WHETHER THE SPECIES IS USING
C  A WYKOFF EQUATION OR CURTIS-ARNEY EQUATION.
C----------
      IF(MODE .EQ. 0) THEN
        IF(IWYKCA(ISPC) .EQ. 0) THEN
          H=EXP(HT1(ISPC) + HT2(ISPC)/(D+1.0))+4.5
        ELSE
          IF(D .GE. 3.) THEN
            H=4.5+P2*EXP(-1.*P3*D**P4)
          ELSE
            H=((4.5+P2*EXP(-1.*P3*(3.**P4))-4.51)*(D-DB)/(3.-DB))+4.51
          ENDIF
        ENDIF
      ELSE
        IF(IWYKCA(ISPC) .EQ. 0) THEN
          D=(HT2(ISPC)/(ALOG(H-4.5)-HT1(ISPC)))-1.0
        ELSE
          HAT3 = 4.5 + P2 * EXP(-1.*P3*3.0**P4)
          IF(H .GE. HAT3) THEN
            IF(DEBUG) WRITE(JOSTND,*)' H= ',H,' HAT3= ',HAT3,' P2= ',P2
            D=EXP(ALOG((ALOG(H-4.5)-ALOG(P2))/(-1.*P3)) * 1./P4)
          ELSE
            D=(((H-4.51)*(3.-DB))/(4.5+P2*EXP(-1.*P3*(3.**P4))-4.51))+DB
          ENDIF
        ENDIF
      ENDIF
C
      IF(MODE.NE.0 .AND. D.LT.DB)D=DB
C
      IF (DEBUG) THEN
        WRITE(JOSTND,*) ' IN HTDBH MODE,ISPC,IWYKCA,H,D= ',
     &                    MODE,ISPC,IWYKCA(ISPC),H,D
        WRITE(JOSTND,*) ' IN HTDBH  P2, P3, P4, DB= ', P2, P3, P4, DB
        WRITE(JOSTND,*) ' IN HTDBH  HT1,HT2 = ',HT1(ISPC),HT2(ISPC)
      ENDIF
      RETURN
      END
