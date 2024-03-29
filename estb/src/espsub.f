      SUBROUTINE ESPSUB
      IMPLICIT NONE
C----------
C  **ESPSUB--ESTB   DATE OF LAST REVISION:   07/25/08
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'ESHAP2.F77'
C
C
COMMONS
C
C     PREDICT THE PROBABILITY OF SUBSEQUENT SPECIES.
C     PLANTING COEFFICIENTS NOT INCLUDED IN THIS SUBROUTINE.
C     P(SUBSEQUENT WHITE PINE)  7/12/89
C
      REAL PN
C
      PN= -2.4158523 +DHAB(IHAB,1) -.0190109*XCOS -1.3862606*XSIN
     &    -1.8366897*SLO +DPRE(IPREP,1) -.0096275*BAA
     &    -0.0480603*ELEV +.5816639*SQRT(TIME)
      IF(IFO.EQ.7.OR.IFO.EQ.10.OR.IFO.EQ.16) PN=PN-1.5468744
      IF(OVER(1,NNID).GT.9.95) PN=PN +1.1525173
      PSUB(1)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,1)  *XESMLT(1)
     &     *OCURNF(IFO,1)
C
C     P(SUBSEQUENT WESTERN LARCH).
C
      PN= -6.6374979 +DHAB(IHAB,2) +1.4214396*XCOS +0.7795442*XSIN
     &  -.4926099*SLO +DPRE(IPREP,2) -0.0097349*BAA +0.1260484*ELEV
     &    -0.0016995*ELEVSQ 
      IF(OVER(2,NNID).GT.9.95) PN=PN +1.1026379
      IF(IFO.EQ.9.OR.IFO.EQ.10.OR.IFO.EQ.14.OR.IFO.EQ.16)
     &  PN=PN+1.8727359
      PSUB(2)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,2)  *XESMLT(2)
     &     *OCURNF(IFO,2)
C
C     P(SUBSEQUENT DOUGLAS-FIR).  7/12/89
C
      PN=-2.6235752 +DHAB(IHAB,3) +DPRE(IPREP,3) +0.5771993*XCOS
     &  -.0248810*XSIN +0.2794252*SLO -.0058675*BAA -0.0229114*ELEV
     &   +0.6120327*SQREGT      +0.5549276*SQBWAF
      IF(OVER(3,NNID).GT.9.95) PN=PN+0.2350508
      IF(IFO.EQ.19.OR.IFO.EQ.20) PN=PN-0.6635007
      IF(IFO.EQ.7.OR.IFO.EQ.9.OR.IFO.EQ.10.OR.IFO.EQ.11.OR.IFO.
     &   EQ.12.OR.IFO.EQ.3) PN=PN+0.6195183
      PSUB(3)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,3)  *XESMLT(3)
     &     *OCURNF(IFO,3)
C
C     P(SUBSEQUENT GRAND FIR) 3/13/87
C
      PN= -4.2174864 +0.7765163*XCOS +0.8718039*XSIN -0.4550694*SLO
     &  -.0045320*BAA +0.1369318*ELEV -.0017545*ELEVSQ +DHAB(IHAB,4)
     &  +.555869*SQREGT -.249851*BWB4 +.412380*SQBWAF +DPRE(IPREP,4)
      IF(OVER(4,NNID).GT.9.95) PN=PN+0.2759684
      IF(IFO.EQ.3.OR.IFO.EQ.10) PN=PN-1.8014250
      IF(IFO.EQ.14.OR.IFO.EQ.16.OR.IFO.EQ.19.OR.IFO.EQ.20)
     &    PN=PN -1.1073681
      PSUB(4)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,4)  *XESMLT(4)
     &     *OCURNF(IFO,4)
C
C     P(SUBSEQUENT WESTERN HEMLOCK). 07/11/89
C
      PN= -12.3053122 +2.5642173*XCOS -0.4392772*XSIN -1.4051726*SLO
     &    +DPRE(IPREP,5)
     &    +0.4534289*ELEV -0.0058291*ELEVSQ +0.7455533*SQRT(TIME)
      IF(OVER(5,NNID).GT.9.95) PN=PN+0.7780439
      PSUB(5)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,5)  *XESMLT(5)
     &     *OCURNF(IFO,5)
C
C     P(SUBSEQUENT WESTERN REDCEDAR).
C
      PN= -3.6279063 +DHAB(IHAB,6) +1.5773680*XCOS +0.7379712*XSIN
     &  -1.7963310*SLO +DPRE(IPREP,6) -.0039867*BAA -.0259884*ELEV
     &    +0.9247357*SQRT(TIME)
      IF(OVER(6,NNID).GT.9.95) PN=PN +0.9973589
      PSUB(6)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,6)  *XESMLT(6)
     &     *OCURNF(IFO,6)
C
C     P(SUBSEQUENT LODGEPOLE PINE).
C
      PN= -0.9637001+DHAB(IHAB,7)  -3.1974275*SLO -0.6840911*XCOS
     &  -0.1853668*XSIN -0.0317628*BAA +DPRE(IPREP,7)
      IF(OVER(7,NNID).GT.9.95) PN=PN +1.5827047
      IF(IFO.EQ.4.OR.IFO.EQ.5.OR.IFO.EQ.17.OR.IFO.EQ.19)
     &    PN=PN -1.4140185
      IF(IPHY.EQ.1) PN=PN +0.7254971
      PSUB(7)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,7)  *XESMLT(7)
     &     *OCURNF(IFO,7)
C
C     P(SUBSEQUENT ENGELMANN SPRUCE).  7/14/89
C
      PN= -17.6667213 +DHAB(IHAB,8) +1.5222952*XCOS +1.0029485*XSIN
     &  -2.0576222*SLO -.2404502*BAALN +3.173367*ALOG(ELEV)
     &    +DPRE(IPREP,8)    +0.5579416*SQREGT +0.7190073*SQBWAF
      IF(OVER(8,NNID).GT.9.95) PN=PN +1.3091471
      IF(IFO.EQ.3.OR.IFO.EQ.11.OR.IFO.EQ.12) PN=PN -0.5256087
      IF(IFO.EQ.4) PN=PN +1.1098698
      IF(IFO.EQ.9.OR.IFO.EQ.10) PN=PN +0.3115149
      IF(IFO.EQ.14) PN=PN +2.3169837
      IF(IFO.EQ.19) PN=PN -0.3958037
      IF(IFO.EQ.5) PN=PN +.9730915
      IF(IFO.EQ.17) PN=PN +0.9142514
      IF(IFO.EQ.20) PN=PN +0.7438718
      PSUB(8)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,8)  *XESMLT(8)
     &     *OCURNF(IFO,8)
C
C     P(SUBSEQUENT SUBALPINE FIR).
C
      PN= -7.7326031 +DHAB(IHAB,9) +0.8712742*XCOS
     &  +.4329470*XSIN -1.7512965*SLO -.0112333*BAA +.0526394*ELEV
     &    +0.5499482*SQREGT +0.4826650*SQBWAF +DPRE(IPREP,9)
      IF(IFO.EQ.14.OR.IFO.EQ.16) PN=PN +0.8137509
      IF(OVER(9,NNID).GT.9.95) PN=PN +0.5798956
      PSUB(9)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,9)  *XESMLT(9)
     &     *OCURNF(IFO,9)
C
C     P(SUBSEQUENT PONDEROSA PINE). 12/22/86
C
      PN= -3.9285939 -0.7116187*XCOS -0.2141754*XSIN
     &  +DHAB(IHAB,10) +DPRE(IPREP,10) -.6540064*SLO -.3319028*BAALN
     &   -0.0370099*ELEV +0.4603494*SQRT(TIME)
      IF(OVER(10,NNID).GT.9.95) PN=PN +1.0770060
      IF(IFO.EQ.16.OR.IFO.EQ.17) PN=PN +1.8764150
      IF(IFO.EQ.3.OR.IFO.EQ.19.OR.IFO.EQ.20.OR.IFO.EQ.14)
     &  PN=PN+2.4815869
      IF(IPHY.EQ.4.OR.IPHY.EQ.5) PN=PN +0.346372
      PSUB(10)= (1.0/(1.0+EXP(-PN))) * OCURHT(IHAB,10)*XESMLT(10)
     &     *OCURNF(IFO,10)
      PSUB(11)=0.0
      RETURN
      END
