      SUBROUTINE ESTAB (KDT)
      IMPLICIT NONE
C----------
C   **ESTAB--STRP  DATE OF LAST REVISION:  12/17/12
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
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
      INCLUDE 'STDSTK.F77'
C
C
COMMONS
C
C     REGENERATION ESTABLISHMENT MODEL   --   VERSION 2.0
C     USDA FOREST SERVICE, INTERMOUNTAIN RESEARCH STATION
C     1221 S. MAIN, MOSCOW, IDAHO  83843   (208) 882-3557
C     ******* THIS SUBROUTINE FOR USE IN VARIANTS *******
C
      EXTERNAL ESRANN
      LOGICAL LPPE,DEBUG
      INTEGER*4 IDCMP1,ITMP,ITEMP,ITOOMP
      CHARACTER CPREP(4)*4,CTOPO(5)*4,CBLANK*2,CLAST(MAXSP)*2
      REAL PRMS(6),SUMUP(MAXSP)
      INTEGER MYTYPE(30),MYHABG(16)
      REAL TOTTPA(MAXSP),TOTPCT(MAXSP),BESTPA(MAXSP),AVEHT(MAXSP)
      INTEGER MYACTS(4)
      REAL BESPCT(MAXSP),PASTPA(MAXSP),PASPCT(MAXSP),FIRST(2,MAXSP)
      INTEGER NNPREP(4),ICODE(99)
      REAL HEIGHT(99),ESPROB(99)
      INTEGER IASEP(99),IPLANT(MAXSP),NEWTPP
      REAL HTIMLT(99),AGEPL(99)
      INTEGER L,K,IBRKUP,JJ,MXRR,ITP,ISHADE,IPNSPE,IDO,ITPP,IEVTYR
      REAL CW,CRDUM,BRKUP,RAN,XXH,XH,HHT,TMTIME,DILATE,SHADE,TREEHT
      REAL DELAY,TRAGE,PTREE,EMSQR,BAAOLD,RADIAN
      REAL BACHLO,ESAVE,GENTIM,TBAAA,SUM1,SUM2,FTEMP2,FTEMP,SUM,DRAW
      REAL PNONE,DUPNPT,DUP,TTOTTP,TCROP1,TCROP2,FLONPT,FLOKDT,ZHARV
      INTEGER KDT,NOFSPE,ITRNIN,I,N,IDUP,NTODO,ITODO,NN,J,ISER,II
      INTEGER MYDO,IZERO,NP,IACTK,IPYEAR,NCOUNT,ISTART,IEND,ITYPEP
      INTEGER IPOLD,NTIMES,IREP
C
      DATA CBLANK/'  '/,CPREP/'NONE','MECH','BURN','ROAD'/,CTOPO/
     &  'BOTM','LOWR',' MID','UPPR','RIDG'/,MYTYPE/9*1,2*5,2*2,3*3,4,
     &  12*5,1/,IDCMP1/10000000/,MYHABG/4*1,4*2,3,4,6*5/,
     &  MYACTS/430,431,491,493/,NOFSPE/MAXSP/
C
C     INITIALIZE ARRAYS AND VARIABLES
C
      CALL DBCHK (DEBUG,'ESTAB',5,ICYC)
      IF(DEBUG) WRITE(JOSTND,7000) KDT,IDSDAT,NTALLY
 7000 FORMAT(/' IN ESTAB; BEGIN DEBUG.  KDT=',I5,' IDSDAT=',I5,
     >        ' NTALLY=',I2)
      ITRNIN=ITRN+1
      ZHARV=FLOAT(IDSDAT)
      FLOKDT=FLOAT(KDT)
      TIME=FLOKDT - ZHARV +1.0
      FLONPT=FLOAT(NPTIDS)
      ELEVSQ=ELEV*ELEV
      ITMP=ICYC
      ITMP=ITMP*10000
      MODE=0
      IF(KDT+1-IY(1).GT.20) THEN
        INADV=1
        LOAD=0
      ENDIF
      DO 40 I= 1,99
      AGEPL(I)= 0.0
   40 CONTINUE
      DO 41 I=1,2
      DO 41 N=1,NOFSPE
      FIRST(I,N)=0.1
   41 CONTINUE
      TCROP1=0.0
      TCROP2=0.0
      TTOTTP=0.0
      DO 181 I=1,NOFSPE
      TOTTPA(I)=0.0
      AVEHT(I)=0.0
      SUMPX(I)=0.0
      SUMPI(I)=0.0
      BESTPA(I)=0.0
      PASTPA(I)=0.0
      IPLANT(I)=0
  181 CONTINUE
C
C     PLOT REPLICATION
C
      DUP=0.0
      DO 138 I=1,MINREP
      DUP=DUP+1.0
      N=NPTIDS*I
      IF(NPTIDS*(I+1).GT.MAXPLT) GO TO 139
      IF(N.GE.MINREP) GO TO 139
  138 CONTINUE
  139 CONTINUE
      IDUP=DUP+0.5
      DUPNPT=FLONPT*DUP
C
C     CHANGE FOREST CODES
C
      DO 4 I=1,20
      IF (KODFOR.NE.IFORCD(I)) GO TO 4
      IFO=IFORST(I)
      GO TO 5
    4 CONTINUE
      IFO=4
    5 CONTINUE
C
C     IF NOT THE FIRST TALLY, CANCEL MECH & BURNPREP'S IN THIS CYCLE.
C
      IF(NTALLY.GT.1) THEN
        CALL OPFIND (2,MYACTS(3),NTODO)
        IF(NTODO.GT.0) THEN
          DO 6 ITODO=1,NTODO
          CALL OPDEL1 (ITODO)
    6     CONTINUE
        ENDIF
      ENDIF
C
C     IF NOT THE FIRST TALLY, THEN SKIP SITE PREPS.
C
      IF(NTALLY.NE.1) GO TO 276
      CALL ESETPR (METH,ZMECH,ZBURN,PNONE,PMECH,PBURN,IALN,
     &  IDSDAT,KDT,LOAD)
      IF(ZMECH.LT.ZHARV) ZMECH=ZHARV
      IF(ZBURN.LT.ZHARV) ZBURN=ZHARV
      IF(DEBUG) WRITE(JOSTND,7011) METH,IDSDAT,KDT,ZMECH,ZBURN,
     &  PNONE,PMECH,PBURN,(IALN(I),I=1,3)
 7011 FORMAT(' AFTER ESETPR: METH=',I2,' IDSDAT=',I5,' KDT=',I5,
     &  ' ZMECH=',F7.1,' ZBURN=',F7.1,/,5X,'PNONE=',F7.4,' PMECH=',
     &  F7.4,' PBURN=',F7.4,3X,'IALN(I)=',3I5)
   44 CONTINUE
      KDTOLD=ZHARV-0.5
      DO 45 I=1,5
      SUMPRE(I)=0.0
   45 CONTINUE
      DO 46 I=1,16
      IHABT(I)=0
   46 CONTINUE
  276 CONTINUE
      IF(NTALLY.EQ.1) THEN
        CALL ESRANN (DRAW)
        ITEMP=DRAW*100000.0 +0.5
        ESDRAW=FLOAT(ITEMP)
      ENDIF
      CALL ESRNSD (.TRUE.,ESDRAW)
      IF(DEBUG) WRITE(JOSTND,7014) ESDRAW
 7014 FORMAT(' RANDOM NUMBER SEED=',F9.2)
C
C     LOAD REGENERATION VECTORS FROM CURRENT INVENTORY.
C
      SUM=0.0
      IF(ITRN.EQ.0) GO TO 198
      DO 177 I=1,ITRN
      FTEMP=DBH(I)
      IF(FTEMP.GE.REGNBK) GO TO 177
      NN=ISP(I)
      IF(NN.LT.1.OR.NN.GT.NOFSPE) GO TO 177
      FTEMP2=PROB(I)
      PASTPA(NN)=PASTPA(NN)+FTEMP2
      TCROP2=TCROP2 +FTEMP2
      SUM=SUM+FTEMP2
      N=ITRE(I)
  177 CONTINUE
  198 CONTINUE
C
C     WORK WITH SITE PREPARATION OPTIONS. EXIT = STMT 242
C
      DO 183 I=1,IDUP*NPTIDS
      CALL ESRANN (DRAW)
      WK6(I)=DRAW
  183 CONTINUE
      IF(NTALLY.NE.1) GO TO 242
      IF(LOAD.NE.1) GO TO 249
C
C     IF LOAD=1, REP PLOT PREPS; IF NEEDED COMPRESS ARRAY IPPREP.
C
      NN=0
      DO 243 I=1,NPTIDS
      NN=NN+1
      N=IPTIDS(I)
      IPPREP(NN)=IPPREP(N)
  243 CONTINUE
      IF(IDUP.LT.2) GO TO 49
      DO 251 I=1,IDUP
      DO 247 N=1,NPTIDS
      J=I*NPTIDS +N
      IPPREP(J)=IPPREP(N)
  247 CONTINUE
  251 CONTINUE
      GO TO 49
  249 CONTINUE
      IF(IALN(2).EQ.0.AND.IALN(3).EQ.0) GO TO 246
      SUM=PMECH+PBURN
      IF(SUM.LE.1.0) GO TO 248
      PMECH=PMECH/SUM
      PBURN=PBURN/SUM
  248 CONTINUE
      PNONE=1.0-PMECH-PBURN
      GO TO 252
  246 CONTINUE
C
C     USER HAS NOT SUPPLIED ANY SITE PREPARATION KEYWORDS.
C
      ISER=1
      CALL ESPREP (ISER,PNONE,PMECH,PBURN)
  252 CONTINUE
C
C     SECTION TO CHOOSE SITE PREPS.  SAMPLE WITHOUT REPLACEMENT.
C
      SUM=PNONE+PMECH+PBURN
      SUMUP(1)=PNONE/SUM
      SUMUP(2)=PMECH/SUM
      SUMUP(3)=PBURN/SUM
      IF(DEBUG) WRITE(JOSTND,7051) (SUMUP(I),I=1,3)
 7051 FORMAT(' PNONE=',F8.4,'  PMECH=',F8.4,'  PBURN=',F8.4)
      N=0
      DO 10 II=1,IDUP
      DO 9 NN=1,NPTIDS
      N=N+1
      DRAW=WK6(N)
      DRAW=DRAW* (((DUPNPT+1.0)-FLOAT(N))/DUPNPT)
      SUM=0.0
      DO 2 I=1,2
      SUM=SUM+SUMUP(I)
      IF(DRAW.GT.SUM) GO TO 2
      GO TO 8
    2 CONTINUE
      I=3
      IF(SUMUP(3).LT.0.0) I=1
    8 CONTINUE
      IPPREP(N)=I
      SUMUP(I)=SUMUP(I)-(1.0/DUPNPT)
      IF(SUMUP(I).LT.0.0) SUMUP(I)=0.0
    9 CONTINUE
   10 CONTINUE
   49 CONTINUE
  242 CONTINUE
C
C     GET THE PLANT & NATURAL KEYWORDS READY TO ACCESS
C
      CALL OPFIND (2,MYACTS,NTODO)
      IF(DEBUG) WRITE (JOSTND,'('' # OF PLANT & NATURAL='',I4)') NTODO
      IF(NTODO.GT.0) MODE=1
C----------
C  IF NUMBER TO ESTABLISH IS NEAR ZERO, THEN MARK KEYWORD FOR DELETION.
C  IF THIS WAS THE ONLY ACTIVITY FOUND, SET MODE FLAG TO 0.
C  GED 10-23-97
C----------
      MYDO=NTODO
      DO 244 IZERO=1,NTODO
      CALL OPGET (IZERO,6,IPYEAR,IACTK,NP,PRMS)
      IF(PRMS(2).LE.0.001 .OR. PRMS(3).LE. 0.001) THEN
        CALL OPDEL1(IZERO)
        MYDO=MYDO-1
      ENDIF
  244 CONTINUE
      IF(MYDO .EQ. 0) MODE=0
C 
C     ACCUMULATE SUMS FOR CALCULATION OF SHADE ADJUSTMENTS
C
      SUM1=0.
      SUM2=0.
      DO 245 NN=1,NPTIDS
      NNID=IPTIDS(NN)
      TBAAA=BAAA(NNID)
      IF(TBAAA .LT. 1.)TBAAA=1.
      SUM1=SUM1+TBAAA
  245 CONTINUE
      DO 2451 NN=1,NPTIDS
      NNID=IPTIDS(NN)
      TBAAA=BAAA(NNID)
      IF(TBAAA .LT. 1.)TBAAA=1.
      SUM2=SUM2+SUM1/TBAAA
      IF(DEBUG)
     &WRITE(JOSTND,*)' NNID,BAAA,TBAAA,SUM1,SUM2= ',
     &NNID,BAAA(NNID),TBAAA,SUM1,SUM2
 2451 CONTINUE
      IF(DEBUG)WRITE(JOSTND,*)' SUM1,SUM2= ',SUM1,SUM2
C
C     BEGIN PROCESSING OF PLOTS                             HERE WE GO
C
      NCOUNT=0
      GENTIM=FINT-5.0
      IF(GENTIM.LT.0.0) GENTIM=0.0
      DO 203  NN=1,NPTIDS
      DO 38 I=1,4
      NNPREP(I)=0
   38 CONTINUE
      ISTART=NN*IDUP -IDUP+1
      IEND=NN*IDUP
      DO 39 I=ISTART,IEND
      N=IPPREP(I)
      IF(N.LT.1.OR.N.GT.4) N=1
      NNPREP(N)=NNPREP(N)+1
   39 CONTINUE
C
C     PROCESS REPLICATED PLOTS BY EACH OF THE 4 SITE PREPS
C
      DO 202 ITYPEP=1,4
      IPOLD=0
      IF(NNPREP(ITYPEP).LT.1) GO TO 202
      NTIMES=NNPREP(ITYPEP)
      DO 201 IREP=1,NTIMES
      NCOUNT=NCOUNT+1
      IPREP=ITYPEP
      IF(IPREP.EQ.IPOLD) GO TO 137
      IPOLD=IPREP
      NNID=IPTIDS(NN)
      RADIAN=PASP(NNID)
      SLO=PSLO(NNID)
      IPHY=IPHYS(NNID)
      XCOSAS=COS(RADIAN)
      XSINAS=SIN(RADIAN)
      XCOS=XCOSAS*SLO
      XSIN=XSINAS*SLO
      BAA=BAAA(NNID)
      IF(BAA.LT.1.0) BAA=1.0
      IF(BAA.GT.400.0) BAA=400.0
      BAASQ=BAA*BAA
      BAALN=ALOG(BAA)
      BAAOLD=BAAINV(NNID)
      IF(BAAOLD.LT.1.0) BAAOLD=1.0
      IF(BAAOLD.GT.400.0) BAAOLD=400.0
      IHAB=IPHAB(NNID)
      ISER=MYHABG(IHAB)
      IF(DEBUG) THEN
        WRITE(JOSTND,6033) NNID,NOFSPE,IPREP,NTALLY,ISER,IFO,
     &  SLO,BAA,ELEV,ASPECT
 6033   FORMAT(/,1X,72('='),/,' PLOT=',I4,'  NOFSPE=',I4,'  IPREP=',I3,
     &  '  NTALLY=',I3,'  ISER=',I3,/,' IFO=',I3,
     &  '  SLO=',F5.2,'  BAA=',F7.2,'  ELEV=',F6.1,'  ASPECT=',F7.3)
        WRITE(JOSTND,*) ' OCURHT = ',(OCURHT(IHAB,I),I=1,NOFSPE)
        WRITE(JOSTND,*) ' OCURNF = ',(OCURNF(IFO,I),I=1,NOFSPE)
        WRITE(JOSTND,*) ' XESMLT = ',(XESMLT(I),I=1,NOFSPE)
      ENDIF
      IF(STOADJ.LT.0.0001) GO TO 137
C
C     PROBABILITY OF STOCKING CODE USED TO BE HERE.
C
  137 CONTINUE
C
C     RESET TIME TO YEARS SINCE DISTURBANCE OR SITE PREP.
C
      IF (IPREP.EQ.2) THEN
         IEVTYR=IFIX(ZMECH)
         TIME=FLOKDT +1.0 -ZMECH
      ELSEIF (IPREP.EQ.3) THEN
         IEVTYR=IFIX(ZBURN)
         TIME=FLOKDT +1.0 -ZBURN
      ELSE
         IEVTYR=IDSDAT
         TIME=FLOKDT +1.0 -ZHARV
      ENDIF
      IF(DEBUG) WRITE (JOSTND,7010) TIME,IEVTYR
 7010 FORMAT(' TIME=',F7.1,'; IEVTYR=',I5)
      CALL ESTIME (IEVTYR,KDT)
      IF(DEBUG) WRITE (JOSTND,7020) BWB4,BWAF,REGT,SQREGT,SQBWAF
 7020 FORMAT(' BWB4=',F7.3,' BWAF=',F7.3,' REGT=',F7.3,' SQREGT=',
     &  F7.3,' SQBWAF=',F7.3)
      CALL ESRANN (DRAW)
      EMSQR=1.0
      IF(DRAW.LT.0.5) EMSQR= -1.0
      CALL ESRANN (DRAW)
      EMSQR=EMSQR*DRAW
      IF(DEBUG) WRITE (JOSTND,7015) EMSQR
 7015 FORMAT(' EMSQR=',F10.3)
C
C     CHOOSE THE NUMBER OF TREES ON A STOCKED PLOT.
C
C     DETERMINE NUMBER OF SPECIES ON THE PLOT.
C
C     CHOOSE THE SPECIES TO OCCUPY THE PLOT
C
C     ASSIGN HEIGHTS TO TALLEST TREE BY SPECIES & ADVANCE/SUBS.
C
C     STATEMENT 163 IS USED WHEN STOADJ .LE. 0.0
C
  163 CONTINUE
      ITPP=0
      NEWTPP=0
C
C     CREATE TREES FROM 'PLANT' AND 'NATURAL' KEYWORDS.  EXIT=STMT 321
C
      CALL ESRANN (DRAW)
      ITEMP=DRAW*100000.0+0.5
      ESAVE=FLOAT(ITEMP)
      IF(MODE.NE.1) GO TO 321
      ITODO=0
      CALL OPFIND (2,MYACTS,NTODO)
      IF(DEBUG) WRITE (JOSTND,'('' # PLANT & NATURAL 322='',I4)') NTODO
      ITOOMP=0
      DO 322 IDO=1,NTODO
      CALL OPGET (IDO,6,IPYEAR,IACTK,NP,PRMS)
      IF(IACTK .LE. 0) GO TO 322
      ITODO=ITODO+1
      IF (ITPP+ITODO.GT.99) THEN
         ITOOMP=ITOOMP+1
         CALL OPDEL1(IDO)
         ITODO=ITODO-1
         GO TO 322
      ENDIF
      IPNSPE=IFIX(PRMS(1))
      PTREE=(PRMS(2)*(PRMS(3)/100.0)) /DUPNPT
      TRAGE=PRMS(4)
      IF(TRAGE.LT.0.5) TRAGE=2.0
      IF(TRAGE.GT.10.0) TRAGE=10.0
      AGEPL(ITODO)=TRAGE
      IF(DEBUG)WRITE(JOSTND,*)' ITODO, AGEPL= ',ITODO, AGEPL(ITODO)
      DELAY=FLOAT(IPYEAR) -(KDT+1-FINT)
      TREEHT=PRMS(5)
      ISHADE=IFIX(PRMS(6))
      SHADE=0.0
      IF(ISHADE.EQ.1) SHADE=1.0
      IF(ISHADE.EQ.2) SHADE=-1.0
      FTEMP=BAA
C      IF(FTEMP.LT.1.5) FTEMP=0.0
      IF(FTEMP.LT.1.0) FTEMP=1.0
      IF(DEBUG) WRITE(JOSTND,7048) PTREE,SHADE,FTEMP,DUPNPT,BA
 7048 FORMAT(' PTREE=',F6.1,'  SHADE=',F4.1,'  FTEMP=',F6.1,
     &  '  DUPNPT=',F4.1,'  BA=',F6.1)
C
C THE ORIGINAL SHADE CODE ADJUSTMENT SHOWN HERE WAS NOT HAVING MUCH EFFECT.
C REPLACED BY A STRAIGHT RATIO OF BA ON THE PLOT BY DIXON 5/22/08
C NOTE CHANGED SETTING OF FTEMP, AND ACCUMULATIONS OF SUMS, ABOVE
C
C      IF(BA.GT.10.0) PTREE=PTREE +2.0*(PTREE*SHADE*(((FTEMP/DUPNPT)/BA)
C     &  -(1.0/DUPNPT) ) )
      IF(ISHADE.EQ.1)THEN
        PTREE=PTREE*NPTIDS*FTEMP/SUM1
      ELSEIF(ISHADE.EQ.2)THEN
        PTREE=PTREE*NPTIDS*(SUM1/FTEMP)/SUM2
      ENDIF
      IF(DEBUG)WRITE(JOSTND,*)' NNID,FTEMP,SUM1,SUM2,PTREE= ',
     &NNID,FTEMP,SUM1,SUM2,PTREE
C
      DILATE=FIRST(2,IPNSPE)
      TMTIME=TIME
      TIME=FINT
      CALL ESSUBH (IPNSPE,HHT,EMSQR,DILATE,DELAY,ELEV,ISER,GENTIM,
     &  TRAGE)
      TIME=TMTIME
      IF(TREEHT.GE.0.1) THEN
        HHT=TREEHT
        XH=ALOG(HHT)
  161   CONTINUE
        XXH=EXP(BACHLO(XH,0.5,ESRANN))
        IF(XXH.LT.(0.5*HHT) .OR. XXH.GT.(2.0*HHT)) GO TO 161
        HHT=XXH
        HHT=HHT+HTADJ(IPNSPE)
        IF(HHT.LT.0.05) HHT=0.05
      ELSE
  162   RAN=BACHLO(0.5,0.25,ESRANN)
        IF(RAN.LT.0.0 .OR. RAN.GT.1.5) GO TO 162
        HHT=HHT+RAN
        HHT=HHT+HTADJ(IPNSPE)
        IF(HHT.LT.XMIN(IPNSPE) ) HHT=XMIN(IPNSPE)
      ENDIF
      FIRST(2,IPNSPE)=SQRT(DILATE)
      IF(HHT.GT.HHTMAX(IPNSPE)) HHT=HHTMAX(IPNSPE)
      IF(DEBUG) WRITE(JOSTND,7050) IPNSPE,HHT,PTREE,ITODO,ITPP,IACTK,
     &TIME,DELAY,TRAGE
 7050 FORMAT(' IPNSPE=',I3,'  HHT=',F6.2,'  PTREE=',F7.2,'  ITODO=',I4,
     &'  ITPP=',I4,'  IACTK=',I4,' TIME= ',F6.3, 'DELAY= ',F6.2,
     &' TRAGE= ',F6.2)
      ICODE(ITPP+ITODO)=IPNSPE
      IASEP(ITPP+ITODO)=4
      IF(IACTK.EQ.430) IASEP(ITPP+ITODO)=3
      HEIGHT(ITPP+ITODO)=HHT
      ESPROB(ITPP+ITODO)=PTREE
C----------
C     FOR PLANTED TREES, DELAY IS THE NUMBER OF YEARS BETWEEN THE START
C     OF THE PROJECTION CYCLE AND THE PLANTING OCCURRANCE (0 to FINT-1)
C     RESET GENTIM ACCORDINGLY. GED  03-27-09
C
      IF(FINT-DELAY .LT. 5)THEN
        GENTIM = 0.
      ELSE
        GENTIM = FINT-DELAY-5.0
      ENDIF
C----------
      FTEMP=TRAGE
      IF(FTEMP.GT.GENTIM) FTEMP=GENTIM
      HTIMLT(ITPP+ITODO)=FTEMP/(GENTIM+0.0001)
      AGEPL(ITPP+ITODO)=FINT-DELAY+AGEPL(ITODO)
C
  322 CONTINUE
      IF (ITOOMP.GT.0) THEN
         CALL RCDSET(1,.TRUE.)
         WRITE (JOSTND,323) ITOOMP
  323    FORMAT (/' ******** WARNING:',I4,' PLANT OR NATURAL REQUESTS',
     >            ' WERE CANCELED BECAUSE THERE WERE TOO MANY.')
      ENDIF
      ITP=ITPP+ITODO
  321 CONTINUE
      CALL ESRNSD (.TRUE.,ESAVE)
      IF(DEBUG) WRITE(JOSTND,7014) ESAVE
      IF(STOADJ.LT.0.0001) GO TO 229
C
C     PICKING BEST TREES USED TO BE DONE HERE.
C
C     NOTE: STMT 229 IS USED WHEN STOADJ .LE. 0.0
C
  229 CONTINUE
C
C     PRINT OUT PLOT STATISTICS IF DEBUG IS ON.
C
      IF(DEBUG) THEN
        ITEMP=(RADIAN*57.2958) +0.5
        WRITE(JOSTND,6002) NN,IHAB,ITEMP,SLO,IPREP,
     &  ITPP,NEWTPP,NCOUNT
 6002   FORMAT(/,' PLOT  H.TYPE  ASP  SLO  PREP',2X,'P(STOCK)  TREES ',
     &  'PER PLOT    NCOUNT',/,1X,4('-'),2X,6('-'),2X,2(3('-'),2X),
     &  4('-'),2X,8('-'),2X,16('-'),2X,6('-'),/,T2,I3,T9,I3,T15,I4,T20,
     &  F4.2,T28,I1,T41,I3,' TOTAL,',I3,' NEW',T61,I3,//,T5,
     &  'TREE RECORDS:',T20,'TREE#  SPECIES  HEIGHT  BEST?  ASEP#  ',
     &  'ESPROB  HTIMLT',/,T20,'-----  -------  ------  ----- ',
     &  ' -----  ------  ------')
        IF(MODE.EQ.1) WRITE(JOSTND,6006) (I,ICODE(I),HEIGHT(I),
     &  IASEP(I),ESPROB(I),HTIMLT(I),  I=ITPP+1,ITP)
 6006   FORMAT(T21,I3,T30,I2,T37,F4.1,T50,I4,2X,F8.4,2X,F6.3)
      ENDIF
C
C     MAKE SURE THAT THERE IS ROOM IN THE TREE LIST FOR REGENERATION.
C     THE CALL TO RDESCP INSURES THAT THE SPACE REQUIRED IS BELOW THAT
C     NEEDED BY THE ROOT DISEASE MODEL.  RDESCP RETURNS THE MAXIMUM
C     NUMBER OF TREES THAT ROOT DISEASE CAN HANDLE.  IF RROT IS NOT
C     BEING RUN, MXRR IS RETURNED AS MAXTRE.
C
      CALL RDESCP (MAXTRE, MXRR)

      IF(ITRN.GE.MXRR-99) THEN
        CALL ESGENT (ITRNIN)
        ITEMP=MXRR/2
        CALL ESCPRS (ITEMP,DEBUG)
        ITRNIN=ITRN+1
C
C       OPFIND IS CALLED TO RESET THE PARAMETERS FOR THE
C       PLANT & NATURAL KEYWORDS.
C
        CALL OPFIND (2,MYACTS,NTODO)
      ENDIF
C
C     PASS TREES FROM 'PLANT' AND 'NATURAL' KEYWORDS.  EXIT = STMT 227
C
      IF(MODE.NE.1) GO TO 227
      J=ITP - ITPP
      DO 35 JJ=1,J
      I= ICODE(ITPP+JJ)
      FTEMP=ESPROB(ITPP+JJ)
      IF(FTEMP.LT.0.00011.AND.JJ.LT.J) THEN
        ESPROB(ITPP+JJ+1)=ESPROB(ITPP+JJ+1)+FTEMP
        ESPROB(ITPP+JJ)=0.0
        GO TO 35
      ENDIF
      IBRKUP=FTEMP/10.0 +1.0
      BRKUP=FLOAT(IBRKUP)
      TOTTPA(I)=TOTTPA(I)+FTEMP
      PASTPA(I)=PASTPA(I)+FTEMP
      BESTPA(I)=BESTPA(I)+FTEMP
      TCROP1=TCROP1+FTEMP
      TCROP2=TCROP2+FTEMP
      TTOTTP=TTOTTP+FTEMP
      DO 24 II=1,IBRKUP
      ITRN=ITRN+1
      HHT=HEIGHT(ITPP+JJ)
      IMC(ITRN)=1
      ISP(ITRN)=I
      CFV(ITRN)=0.
      ITRUNC(ITRN)=0
      NORMHT(ITRN)=0
      ITRE(ITRN)=NNID
      FTEMP2=FTEMP/BRKUP
      PROB(ITRN)=FTEMP2
      DBH(ITRN)=0.1
      HT(ITRN)=HHT
      ABIRTH(ITRN)=AGEPL(JJ)
      DEFECT(ITRN)=0.
      ISPECL(ITRN)=0
C
      PTOCFV(ITRN)=0.
      PMRCFV(ITRN)=0.
      PMRBFV(ITRN)=0.
      NCFDEF(ITRN)=0
      NBFDEF(ITRN)=0
      PDBH(ITRN)=0.
      PHT(ITRN)=0.
      ZRAND(ITRN)=-999.
C
      CALL RDESTB (ITRN,PROB(ITRN))
C
      ICR(ITRN)=0
      DG(ITRN)=0.0
      HTG(ITRN)=0.0
      PCT(ITRN)=0.0
      OLDPCT(ITRN)=0.0
      OLDRN(ITRN)=0.0
      WK1(ITRN)=0.0
      WK2(ITRN)=0.0
      WK4(ITRN)=HTIMLT(ITPP+JJ)
      BFV(ITRN)=0.0
      IESTAT(ITRN)=0
      PTBALT(ITRN)=PTBAA(NNID)
      IDTREE(ITRN)=IDCMP1+ITMP+ITRN
      CALL MISPUTZ(ITRN,0)
C
C     CALL BLISTER RUST TO PROCESS PLANTED TREES.
C
      CALL BRESTB (TIME,5,I)
C
   24 CONTINUE
   35 CONTINUE
  227 CONTINUE
C
C     SUMMARIZE STATISTICS FOR THE PLOT
C
      SUMPRE(IPREP)=SUMPRE(IPREP) +1.0
      SUMPRE(5)=SUMPRE(5)+1.0
      IHABT(IHAB)=IHABT(IHAB) +1
C
C     END OF PLOT CYCLE. RETURN AND CONTINUE PROJECTION.
C
  201 CONTINUE
  202 CONTINUE
  203 CONTINUE
C
C     ALL PLOTS ARE PROCESSED.
C
      IF(DEBUG) WRITE (JOSTND,6030) ITRNIN,ITRN
 6030 FORMAT(36(' ='),/,' ITRNIN=',I6,'  ITRN=',I6)
      IF(NTODO.GT.0) THEN
        DO 225 ITODO=1,NTODO
        CALL OPGET (ITODO,6,IPYEAR,IACTK,NP,PRMS)
        IF(IACTK .LE. 0) GO TO 225
        ITEMP=IFIX(PRMS(1))
        IPLANT(ITEMP)=1
        CALL OPDONE (ITODO,IPYEAR)
  225   CONTINUE
      ENDIF
C
C     IF NEW TREES HAVE BEEN ADDED TO THE TREELIST
C     'GROW' TREES TO THE END OF THE CYCLE
C
      IF(ITRN.GE.ITRNIN)CALL ESGENT (ITRNIN)
      IF(DEBUG)WRITE(JOSTND,*)' AFTER CALL TO ESGENT-ITRN,ITRNIN= ',
     &ITRN,ITRNIN 
      DO 230 I= ITRNIN,ITRN
C----------
C  CALCULATE A CROWN WIDTH FOR SEEDLINGS/SPROUTS
C----------
      CRDUM=1.
      CALL CWCALC(ISP(I),PROB(I),DBH(I),HT(I),CRDUM,
     &            ICR(I),CW,0,JOSTND)
      CRWDTH(I)=CW
      ABIRTH(I)= ABIRTH(I)+GENTIM
  230 CONTINUE
C
C     PRINT REGENERATION SUMMARY
C
      IF(IPRINT.EQ.0) GO TO 260
      IF(NTALLY.NE.1) GO TO 233
      DO 204 I=1,4
      SUMPRE(I)=(SUMPRE(I)/SUMPRE(5))*100.0
  204 CONTINUE
      DO 232 I=1,16
      IHABT(I)=IHABT(I)/IDUP
  232 CONTINUE
  233 CONTINUE
      DO 206 N=1,NOFSPE
      AVEHT(N)=SUMPX(N)/(SUMPI(N)+ .00001)
      IF(BESTPA(N).LT.0.5) AVEHT(N)=0.0
      TOTPCT(N)=(TOTTPA(N)/(TTOTTP+.00001))*100.0
      BESPCT(N)=(BESTPA(N)/(TCROP1+.00001))*100.0
      PASPCT(N)=(PASTPA(N)/(TCROP2+.00001))*100.0
  206 CONTINUE
      N=SUMPRE(1) +0.5
      NN=SUMPRE(2) +SUMPRE(4) +0.5
      ITEMP=SUMPRE(3) +0.5
      J = ZHARV+.5
      K = ZMECH+.5
      L = ZBURN+.5
      CALL PPEATV (LPPE)
      IF(NTALLY.EQ.1.OR.LPPE) THEN
        CALL GROHED (JOREGT)
        WRITE(JOREGT,6012) NPLT,MGMID
 6012   FORMAT(/,1X,76('-'),/,T18,'REGENERATION ESTABLISHMENT ',
     &  'MODEL VERSION 2.0',/,T10,'STAND ID: ',A26,5X,
     &  'MANAGEMENT CODE: ',A4,/,T2,76('-') )
        CALL PPLABS(JOREGT)
        WRITE(JOREGT,6013) J,K,L,N,NN,ITEMP
 6013   FORMAT(/,T4,'SITE PREP SUMMARY',
     &  /,T2,19('-'),/,T2,'PREP:NONE MECH BURN',
     &  /,T2,'YEAR:',
     &  3(I4,1X),
     &  /,T3,'PCT:',I4,2I5)
      ENDIF
      ITEMP=KDT+1-J
      WRITE(JOREGT,6021) NTALLY,ITEMP,KDT
 6021 FORMAT(/,' TALLY',I2,' AT',I3,' YEARS.  REGENERATION SUMMARY',
     &  ' IN THE FALL OF',I5,'.')
      N=0
      CLAST(1)=CBLANK
      DO 207 I=1,NOFSPE
      IF(IPLANT(I).LT.1) GO TO 207
      N=N+1
      CLAST(N)=NSP(I,1)
  207 CONTINUE
      IF(N.EQ.0) N=1
      IF(MODE.EQ.1) WRITE(JOREGT,6015) (CLAST(I),I=1,N)
 6015 FORMAT(' TREES FROM PLANT AND NATURAL KEYWORDS: SPECIES= ',
     &  11A4)
      WRITE(JOREGT,6016) REGNBK
 6016 FORMAT(/,T7,'SUMMARY OF ALL',T31,'SUMMARY OF BEST         ',
     &  'TREES <',F4.1,' IN. DBH',/,T7,'TREES REGENERATING',T31,
     &  'TREES REGENERATING      BEING PROJECTED BY',/,T7,
     &  'DURING THIS TALLY.',T31,'DURING THIS TALLY.      THE ',
     &  'PROGNOSIS MODEL',/,T7,19('-'),5X,19('-'),5X,19('-'),/,14X,
     &  'TREES % OF      TREES % OF  AVERAGE     TREES % OF',/,6X,
     &  'SPECIES /ACRE TOTAL     /ACRE TOTAL HEIGHT      /ACRE TOTAL ',
     &  'SPECIES',/,6X,7('-'),1X,5('-'),1X,5('-'),5X,5('-'),1X,5('-'),
     &  1X,7('-'),5X,5('-'),1X,5('-'),1X,7('-') )
      DO 222 I=1,NOFSPE
      IF(TOTTPA(I).LE.0. .AND. BESTPA(I).LE.0. .AND. PASTPA(I).LE.0.)
     &GO TO 222
      WRITE(JOREGT,6014) NSP(I,1),TOTTPA(I),TOTPCT(I),BESTPA(I),
     &  BESPCT(I),AVEHT(I),PASTPA(I),PASPCT(I),NSP(I,1)
 6014 FORMAT(T10,A2,2X,2F6.0,4X,2F6.0,1X,F5.1,6X,2F6.0,3X,A2)
  222 CONTINUE
      WRITE(JOREGT,6026) TTOTTP,TCROP1,TCROP2
 6026 FORMAT(T15,5('-'),T31,5('-'),T55,5('-'),/,T13,F7.0,T29,F7.0,
     &  T53,F7.0,/)
  260 CONTINUE
C
C     PRINT PLOT SUMMARY TABLE IF REQUESTED.
C
      CALL DBCHK (DEBUG,'ESPSUM',6,ICYC)
      IF(DEBUG) THEN
        WRITE(JOREGT,6018) (NSP(I,1),I=1,NOFSPE)
 6018   FORMAT(' IN ESTAB (ESPSUM PLOT SUMMARY): '/
     &  '      SLOPE ASPECT HAB. TOPO SITE       ',
     &  ' <------PLOT OVERSTORY DENSITY (SQ.FT./ACRE)----->',/,
     &  ' PLOT %/100 (DEG.) GRP. POS. PREP  P(S)  TOTAL ',11(A2,2X))
        DO 221 I=1,NPTIDS
        NNID=IPTIDS(I)
        N=(PASP(NNID)*57.2958) +0.5
        NN=IPHYS(NNID)
        ITEMP=IPPREP(I*IDUP)
        WRITE(JOREGT,6020) NNID,PSLO(NNID),N,IPHAB(NNID),CTOPO(NN),
     &  CPREP(ITEMP),BAAA(NNID),(OVER(J,NNID),J=1,NOFSPE)
 6020   FORMAT(2X,I3,F6.2,I6,2X,I3,1X,1X,A4,5X,A4,F6.0,
     &  (/,2X,11F4.0))
  221   CONTINUE
      ENDIF
      KDTOLD=KDT
      MODE=0
      RETURN
      END
