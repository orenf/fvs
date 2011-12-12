      SUBROUTINE SITSET
      IMPLICIT NONE
C----------
C  **SITSET--NI   DATE OF LAST REVISION:  02/25/09
C----------
C  THIS SUBROUTINE IS USED TO SET SIMULATION CONTROLLING VALUES
C  THAT HAVE NOT BEEN SET USING THE KEYWORDS --- SDIMAX, BAMAX.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C---------
      INTEGER IFIASP, ERRFLAG
      CHARACTER FORST*2,DIST*2,PROD*2,VAR*2,VOLEQ*10,VVER*7
      REAL BAMAXA(30)
      INTEGER I,ISPC,INTFOR,IREGN,J,JJ,K
      DATA BAMAXA/
     &  140.,220.,250.,310.,240.,270.,310.,310.,200.,310.,
     &  290.,330.,380.,440.,500.,500.,390.,390.,440.,180.,
     &  290.,400.,350.,390.,260.,300.,220.,220.,160.,300./
C
      CALL VARVER(VVER)
C----------
C  SET SDIDEF AND BAMAX VALUES WHICH HAVE NOT BEEN SET BY KEYWORD.
C----------
      IF(BAMAX.LE.0) BAMAX=BAMAXA(ITYPE)
      DO 10 I=1,MAXSP
      IF(SDIDEF(I).LE.0.) SDIDEF(I)=BAMAX/(0.5454154*(PMSDIU/100.))
   10 CONTINUE
C
      DO 92 I=1,15
      J=(I-1)*10 + 1
      JJ=J+9
      IF(JJ.GT.MAXSP)JJ=MAXSP
      WRITE(JOSTND,90)(NSP(K,1)(1:2),K=J,JJ)
   90 FORMAT(/' SPECIES ',5X,10(A2,6X))
      WRITE(JOSTND,91)(SDIDEF(K),K=J,JJ )
   91 FORMAT(' SDI MAX ',   10F8.0)
      IF(JJ .EQ. MAXSP)GO TO 93
   92 CONTINUE
   93 CONTINUE
C----------
C  SET METHB & METHC DEFAULTS.  DEFAULTS ARE INITIALIZED TO 999 IN
C  **GRINIT**.  IF THEY HAVE A DIFFERENT VALUE NOW, THEY WERE CHANGED
C  BY KEYWORD IN INITRE. ONLY CHANGE THOSE NOT SET BY KEYWORD.
C
C  COLVILLE  (IFOR=5) IS A REGION 6 FOREST. ALL OTHERS FORESTS IN THIS
C  VARIANT ARE IN REGION 1.
C----------
      DO 50 ISPC=1,MAXSP
      IF(IFOR.EQ.5)THEN
        IF(METHB(ISPC).EQ.999)METHB(ISPC)=6
        IF(METHC(ISPC).EQ.999)METHC(ISPC)=6
      ELSE
        IF(METHB(ISPC).EQ.999)METHB(ISPC)=6
        IF(METHC(ISPC).EQ.999)METHC(ISPC)=6
      ENDIF
   50 CONTINUE
C----------
C  LOAD VOLUME EQUATION ARRAYS FOR ALL SPECIES
C----------
      INTFOR = KODFOR - (KODFOR/100)*100
      WRITE(FORST,'(I2)')INTFOR
      IF(INTFOR.LT.10)FORST(1:1)='0'
      IREGN = KODFOR/100
      DIST='  '
      PROD='  '
      VAR=VVER(:2)
      DO ISPC=1,MAXSP
      READ(FIAJSP(ISPC),'(I4)')IFIASP
      IF(((METHC(ISPC).EQ.6).OR.(METHC(ISPC).EQ.9)).AND.
     &     (VEQNNC(ISPC).EQ.'          '))THEN
        CALL VOLEQDEF(VAR,IREGN,FORST,DIST,IFIASP,PROD,VOLEQ,ERRFLAG)
        VEQNNC(ISPC)=VOLEQ
      ENDIF
      IF(((METHB(ISPC).EQ.6).OR.(METHB(ISPC).EQ.9)).AND.
     &     (VEQNNB(ISPC).EQ.'          '))THEN
        CALL VOLEQDEF(VAR,IREGN,FORST,DIST,IFIASP,PROD,VOLEQ,ERRFLAG)
        VEQNNB(ISPC)=VOLEQ
      ENDIF
      ENDDO
C----------
C  IF FIA CODES WERE IN INPUT DATA, WRITE TRANSLATION TABLE
C---------
      IF(LFIA) THEN
        CALL FIAHEAD(JOSTND)
        WRITE(JOSTND,211) (NSP(I,1)(1:2),FIAJSP(I),I=1,MAXSP)
 211    FORMAT ((T13,8(A3,'=',A6,:,'; '),A,'=',A6))
      ENDIF
C----------
C  WRITE VOLUME EQUATION NUMBER TABLE
C----------
      CALL VOLEQHEAD(JOSTND)
      WRITE(JOSTND,230)(NSP(J,1)(1:2),VEQNNC(J),VEQNNB(J),J=1,MAXSP)
 230  FORMAT(4(3X,A2,4X,A10,1X,A10))
C     
      RETURN
      END
