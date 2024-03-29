CODE SEGMENT CWDCOM
C----------
C  **CWDCOM DATE OF LAST REVISION:  03/09/04
C----------
      LOGICAL LSPCWE(MAXSP)
      REAL    CWDS0(MAXSP),CWDS1(MAXSP),CWDS2(MAXSP),CWDS3(MAXSP),
     &        CWDL0(MAXSP),CWDL1(MAXSP),CWDL2(MAXSP),CWDL3(MAXSP),
     &        CWTDBH(MAXSP)
      COMMON /CWDCOM/ LSPCWE,CWDS0,CWDS1,CWDS2,CWDS3,CWDL0,CWDL1,CWDL2,
     &                CWDL3,CWTDBH
C----------
C  DEFINITIONS OF VARIABLES IN 'CWDCOM' COMMON BLOCK:
C----------
C  LSPCWE -- LOGICAL VARIABLE. 
C             .TRUE. INDICATES THE USER HAS INPUT THEIR OWN EQUATIONS
C                    FOR THIS SPECIES. 
C            .FALSE. INDICATES THE DEFAULT EQUATIONS SHOULD BE USED.
C   CWDS0 -- USER-DEFINED COEFFICIENTS IN THE CROWN WIDTH EQUATION.
C   CWDS1      CW = CWD0 + CWD1 + CWD2*DBH**CWD3
C   CWDS2    FOR TREES WITH DBH LESS THAN THE TRANSITION SIZE.  
C   CWDS3
C   CWDL0 -- USER-DEFINED COEFFICIENTS IN THE CROWN WIDTH EQUATION.
C   CWDL1      CW = CWD0 + CWD1 + CWD2*DBH**CWD3
C   CWDL2    FOR TREES WITH DBH GREATER THAN OR EQUAL TO 
C   CWDL3    THE TRANSITION SIZE.
C  CWTDBH -- CROWN WIDTH TRANSITION DBH FOR SWITCHING BETWEEN THE 
C            SMALL TREE EQUATIONS AND LARGE TREE EQUATIONS
C-----END SEGMENT
