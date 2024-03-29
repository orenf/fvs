      BLOCK DATA CUBRDS
      IMPLICIT NONE
C----------
C  **CUBRDS--UT   DATE OF LAST REVISION:  11/30/09
C----------
C  DEFAULT PARAMETERS FOR THE CUBIC AND BOARD FOOT VOLUME EQUATIONS.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C----------
      INTEGER I,J
C----------
C SPECIES ORDER FOR UTAH VARIANT:
C
C  1=WB,  2=LM,  3=DF,  4=WF,  5=BS,  6=AS,  7=LP,  8=ES,  9=AF, 10=PP,
C 11=PI, 12=WJ, 13=GO, 14=PM, 15=RM, 16=UJ, 17=GB, 18=NC, 19=FC, 20=MC,
C 21=BI, 22=BE, 23=OS, 24=OH
C
C VARIANT EXPANSION:
C GO AND OH USE OA (OAK SP.) EQUATIONS FROM UT
C PM USES PI (COMMON PINYON) EQUATIONS FROM UT
C RM AND UJ USE WJ (WESTERN JUNIPER) EQUATIONS FROM UT
C GB USES BC (BRISTLECONE PINE) EQUATIONS FROM CR
C NC, FC, AND BE USE NC (NARROWLEAF COTTONWOOD) EQUATIONS FROM CR
C MC USES MC (CURL-LEAF MTN-MAHOGANY) EQUATIONS FROM SO
C BI USES BM (BIGLEAF MAPLE) EQUATIONS FROM SO
C OS USES OT (OTHER SP.) EQUATIONS FROM UT
C
C----------
C  COEFFICIENTS FOR CUBIC FOOT VOLUME FOR TREES THAT ARE SMALLER THAN
C  THE TRANSITION SIZE
C----------
      DATA ((CFVEQS(I,J),I=1,7),J=1,10) /
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &   -0.343,      0.0,     0.0, 0.00224,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     & 0.030288,      0.0,     0.0,0.002213,     0.0,     0.0,    0.0/
C     
      DATA ((CFVEQS(I,J),I=1,7),J=11,20) /
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0/
C     
      DATA ((CFVEQS(I,J),I=1,7),J=21,MAXSP) /
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0/
C----------
C  COEFFICIENTS FOR CUBIC FOOT VOLUME FOR TREES THAT ARE LARGER THAN
C  THE TRANSITION SIZE
C----------
      DATA ((CFVEQL(I,J),I=1,7),J=1,10) /
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &    1.071,      0.0,     0.0, 0.00217,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &      0.0,      0.0,0.003865,0.001714,     0.0,     0.0,    0.0,
     &-1.557103,      0.0,     0.0,0.002474,     0.0,     0.0,    0.0/
C     
      DATA ((CFVEQL(I,J),I=1,7),J=11,20) /
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0, 0.00219,     0.0,     0.0,    0.0/
C     
      DATA ((CFVEQL(I,J),I=1,7),J=21,MAXSP) /
     &      0.0,      0.0,     0.0, 0.00219,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488,
     &      0.0,      0.0,     0.0,     0.0,0.002782,  1.9041, 1.0488/
C----------
C  FLAG IDENTIFYING THE SIZE TRANSITION VARIABLE; 0=D, 1=D2H
C----------
      DATA ICTRAN/
     & 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
     & 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     & 0, 0, 0, 0/
C----------
C  TRANSITION SIZE.  TREES OF LARGER SIZE (D OR D2H) WILL COEFFICIENTS 
C  FOR LARGER SIZE TREES.
C---------- 
      DATA CTRAN/
     &      0.0,      0.0,     0.0,     0.0,     0.0,
     &     20.0,      0.0,     0.0,     0.0,  6000.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,
     &      0.0,      0.0,     0.0,     0.0/
C----------
C  COEFFICIENTS FOR BOARD FOOT VOLUME FOR TREES THAT ARE SMALLER THAN 
C  THE TRANSITION SIZE
C----------
      DATA ((BFVEQS(I,J),I=1,7),J=1,10) /
     &   -8.085,      0.0,     0.0, 0.01208,     0.0,     0.0,    0.0,
     &   -8.085,      0.0,     0.0, 0.01208,     0.0,     0.0,    0.0,
     &  -25.332,      0.0,     0.0, 0.01003,     0.0,     0.0,    0.0,
     &  -34.127,      0.0,     0.0, 0.01293,     0.0,     0.0,    0.0,
     &  -11.851,      0.0,     0.0, 0.01149,     0.0,     0.0,    0.0,
     &  -18.544,      0.0,     0.0, 0.01197,     0.0,     0.0,    0.0,
     &   -6.600,      0.0,     0.0, 0.01161,     0.0,     0.0,    0.0,
     &  -11.851,      0.0,     0.0, 0.01149,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -50.340,      0.0,     0.0, 0.01201,     0.0,     0.0,    0.0/
C
      DATA ((BFVEQS(I,J),I=1,7),J=11,20) /
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &  -37.314,      0.0,     0.0, 0.01203,     0.0,     0.0,    0.0/
C
      DATA ((BFVEQS(I,J),I=1,7),J=21,MAXSP) /
     &  -37.314,      0.0,     0.0, 0.01203,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &  -11.403,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0/
C----------
C  COEFFICIENTS FOR BOARD FOOT VOLUME FOR TREES THAT ARE LARGER THAN 
C  THE TRANSITION SIZE
C----------
      DATA ((BFVEQL(I,J),I=1,7),J=1,10) /
     &   14.111,      0.0,     0.0, 0.01103,     0.0,     0.0,    0.0,
     &   14.111,      0.0,     0.0, 0.01103,     0.0,     0.0,    0.0,
     &   -9.522,      0.0,     0.0, 0.01011,     0.0,     0.0,    0.0,
     &   10.603,      0.0,     0.0, 0.01218,     0.0,     0.0,    0.0,
     &    1.620,      0.0,     0.0, 0.01158,     0.0,     0.0,    0.0,
     &  -21.309,      0.0,     0.0, 0.01216,     0.0,     0.0,    0.0,
     &   -6.600,      0.0,     0.0, 0.01161,     0.0,     0.0,    0.0,
     &    1.620,      0.0,     0.0, 0.01158,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     & -298.784,      0.0,     0.0, 0.01595,     0.0,     0.0,    0.0/
C
      DATA ((BFVEQL(I,J),I=1,7),J=11,20) /
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &  -50.680,      0.0,     0.0, 0.01306,     0.0,     0.0,    0.0/
C
      DATA ((BFVEQL(I,J),I=1,7),J=21,MAXSP) /
     &  -50.680,      0.0,     0.0, 0.01306,     0.0,     0.0,    0.0,
     &      0.0,      0.0,     0.0,     0.0,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0,
     &  124.425,      0.0,     0.0, 0.00694,     0.0,     0.0,    0.0/
C----------
C  FLAG IDENTIFYING THE SIZE TRANSITION VARIABLE; 0=D, 1=D2H
C----------
      DATA IBTRAN/
     & 1, 1, 0, 1, 0, 1, 0, 0, 1, 1,
     & 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
     & 0, 0, 1, 1/
C----------
C  TRANSITION SIZE.  TREES OF LARGER SIZE (D OR D2H) WILL USE COEFFICIENTS 
C  FOR LARGER SIZE TREES.
C---------- 
      DATA BTRAN/
     &  21100.0,  21100.0,    21.0, 59600.0,    21.0,
     &  14600.0,      0.0,    21.0, 42800.0, 63100.0,
     &  42800.0,  42800.0, 42800.0, 42800.0, 42800.0,
     &  42800.0,      0.0,     0.0,     0.0,    20.5,
     &     20.5,      0.0, 42800.0, 42800.0/
      END
