      SUBROUTINE CMPRT2(IOSUM,HRVSUM,IPT,JPRT,JCOP,LEN,MGMID)
      IMPLICIT NONE
C----------
C  **CMPRT2--PPBASE     DATE OF LAST REVISION:  07/31/08
C----------
C
C     CALLED FROM:
C     CMPRT (ENTRY IN CMADDS) -- COMPUTES AVERAGES FOR WEIGHTED SUMS.
C
C     IOSUM = THE SUMMARY OUTPUT ARRAY FROM THE PROGNOSIS MODEL.
C              1: YEAR
C              2: AGE
C              3: TREES/ACRE
C              4: TOTAL CU FT
C              5: MERCH CU FT
C              6: MERCH BD FT
C              7: REMOVED TREES/ACRE
C              8: REMOVED TOTAL CU FT
C              9: REMOVED MERCH CU FT
C             10: REMOVED MERCH BD FT
C             11: BASAL AREA/ACRE
C             12: CCF
C             13: AVERAGE DOMINATE HEIGHT
C             14: PERIOD LENGTH (YEARS)
C             15: ACCRETION (ANNUAL IN CU FT/ACRE)
C             16: MORTALITY  (ANNUAL IN CU FT/ACRE)
C             17: TOTAL SAMPLE WEIGHT
C
C     HRVSUM= FRACTION OF TOTAL SAMPLE WEIGHT WITH REMOVALS.
C     IPT   = POINTER ARRAY USED TO ACCESS IOSUM IN CRONOLOGICAL
C             ORDER. IF IPT(1)=0, IOSUM IS ASSUMED TO BE IN
C             CRONOLOGICAL ORDER.
C     JPRT  = DATA SET REFERENCE NUMBER FOR 'PRINTED' COPY (WITH
C             HEADINGS AND CARRAGE CONTROL BYTE).  IF JPRT=0, NO
C             DATA WILL BE WRITTEN.
C     JCOP  = DATA SET REFERENCE NUMBER FOR 'NON-PRINTED' COPY (WITH
C             OUT HEADINGS, NO CARRAGE CONTROL BYTE). IF JCOP=0,
C             NO DATA WILL BE WRITTEN.
C     LEN   = NUMBER OF ROWS (ENTRIES) IN IOSUM.
C     MGMID = MANAGEMENT IDENTIFICATION FIELD. ASSUMED ALPHANUMERIC.
C
      INTEGER IPT(LEN),JCOP,JPRT,LEN,J,I,K
      CHARACTER*4 MGMID
      INTEGER IOSUM(17,LEN)
      REAL HRVSUM(LEN)
      LOGICAL LPRT,LDSK
C
C     **************************************************************
C
C     STEP1: SET SWITCHES.
C
      LPRT= JPRT .GT. 0
      LDSK= JCOP  .GT. 0
      IF (.NOT. (LPRT.OR.LDSK)) RETURN
C
C     STEP2: WRITE HEADING; SKIP A FEW LINES, DO NOT START A NEW PAGE.
C
      IF (LPRT) WRITE (JPRT,10)
   10 FORMAT (//T40,'COMPOSITE YIELD STATISTICS'/1X,102('-')/
     >  T17,'VOLUME PER ACRE   REMOVALS/TREATED ACRE',T68,
     >  'AVE   GROWTH'/T17,17('-'),1X,23('-'),'  BA/     DOM ',
     >  11('-'),' TOTAL  FRACTION'/T11,
     >  2('TREES TOTAL MERCH MERCH '),'ACRE     HT  PRD ACC MOR ',
     >  'SAMPLE OF AREA  MGMT'/
     >   ' YEAR AGE ',2('/ACRE CU FT CU FT BD FT '),
     >  'SQFT CCF FT  YRS CUFT/YR WEIGHT TREATED  ID'/
     >  ' ---- --- ',8('----- '),'---- ',5('--- '),'------ ',
     >  '-------- ----')
C
C     STEP3: LOOP THRU ALL ROWS IN IOSUM...WRITE OUTPUT.
C
      DO 50 J=1,LEN
      I=IPT(J)
      IF (I.LE.0) GOTO 50
      IF (LPRT) WRITE (JPRT,20) (IOSUM(K,I),K=1,17),HRVSUM(I),MGMID
      IF (LDSK) WRITE (JCOP,30) (IOSUM(K,I),K=1,17),HRVSUM(I),MGMID
   20 FORMAT (1X,2I4,8I6,I5,5I4,I7,F9.6,1X,A4)
   30 FORMAT    (2I4,8I6,I5,5I4,I7,F9.6,1X,A4)
C
   50 CONTINUE
      RETURN
      END
