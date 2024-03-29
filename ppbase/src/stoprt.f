      SUBROUTINE STOPRT
      IMPLICIT NONE
C----------
C  **STOPRT  DATE OF LAST REVISION:  07/31/08
C----------
C
C     STORE PRINT DATA FOR ONE STAND.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--JAN 1982
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PPEPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PPCNTL.F77'
C
C
COMMONS
C
      INTEGER IOAGE,JYR
      LOGICAL LREMOV
C
C     IF NO PRINT DATA IS DESIRED FOR THIS STAND, DON'T WRITE IT.
C
      IF (ITABLE(1).EQ.1 .AND. ITABLE(2).EQ.1) RETURN
C
C     COMPUTE THE PRINT-DATA DATA ELEMENT DESCRIPTION WORD.
C             NOTE: ICL6=1 UPON INITIAL CYCLE, 0 DURING NORMAL
C                   CYCLING, AND -99 FOR FINAL LINE OF OUTPUT.
C
      LREMOV=ONTREM(7).GT.0.
      IPTELS=0
      IF(ICL6.EQ.0) IPTELS=1
      IF(ICL6.LT.0) IPTELS=3
      IF(IPTELS.EQ.1 .AND. LREMOV) IPTELS=2
C
C     GET SPACE ASSIGNMENT FOR THE FIRST PRINT DATA RECORD OF THE GROUP,
C     AND RECORD ITS POSITION IN THE HISTORY FILE.
C
      CALL PRTSPA
      IF (NAVPRT.LE.0) RETURN
      CALL HISTWT
C
C     IF THIS IS THE INITIAL DATA OUTPUT, THEN WRITE INITIAL DATA.
C
      IF(ICL6.LE.0) GOTO 10
      IF (PDEBUG) WRITE(JOPPRT,5) 'INITIAL',NAVPRT
    5 FORMAT (/' IN STOPRT: WRITING ',A,' DATA, RECORD =',I8)
C
C     WRITE LIST IS 48 WORDS
C
      WRITE (IDAPRT,REC=NAVPRT) IPTELS,IAGE,ITITLE,NPLT,MGMID,IOSPCT,
     >       IOSPCV,IOSPMC,IOSPBV,IONSP,LCVOLS,LBVOLS,LMORT
C
C     WRITE LIST IS 84 WORDS
C
      CALL PRTSPA
      IF (NAVPRT.LE.0) RETURN
      WRITE (IDAPRT,REC=NAVPRT) IY(1),LCVOLS,LBVOLS,IFINT,ONTCUR,
     >      OSPCT,OCVCUR,OSPCV,OMCCUR,OSPMC,OBFCUR,OSPBV,DBHIO,HTIO,
     >      IOICR,DGIO,PCTIO,PRBIO
C
C     INSURE THAT IFST IS ZERO, SO THAT NEW SAMPLE TREES WILL NOT
C     BE PICKED.  (SEE PROGNOSIS MODEL ROUTINE DISPLY TO SEE HOW
C     IFST IS HANDLED).
C
      IFST=0
C
      GOTO 40
   10 CONTINUE
C
C     COMPUTE THE OUTPUT AGE, IOAGE.
C
      IOAGE=IAGE+IY(ICYC)-IY(1)
C
C     IF THIS IS NORMAL CYCLING, WRITE THE PRINT-DATA.
C
      IF(ICL6.NE.0) GOTO 30
      JYR=IY(ICYC+1)
      IF (PDEBUG) WRITE(JOPPRT,5) 'NORMAL',NAVPRT
C
C     WRITE LIST IS 33 WORDS.
C
      WRITE (IDAPRT,REC=NAVPRT) IPTELS,IFST,IOAGE,IOSPAC,IOSPMO,
     >       IOSPCT,IOSPCV,IOSPMC,IOSPBV,IONSP
C
C     WRITE LIST IS 110 WORDS.
C
      CALL PRTSPA
      IF (NAVPRT.LE.0) RETURN
      WRITE (IDAPRT,REC=NAVPRT) JYR,OACC,OSPAC,OMORT,OSPMO,
     >       ONTCUR,OSPCT,OCVCUR,OSPCV,OMCCUR,OSPMC,
     >       OBFCUR,OSPBV,IOAGE,ORMSQD,OLDTPA,OLDBA,
     >       OLDAVH,RELDM1,IFINT,DBHIO,HTIO,
     >       IOICR,DGIO,PCTIO,PRBIO
      IFST=0
C
C     IF REMOVAL OCCURED, THEN WRITE REMOVAL DATA.
C
      IF (.NOT.LREMOV) GOTO 20
C
C     WRITE LIST IS 20 WORDS.
C
      CALL PRTSPA
      IF (NAVPRT.LE.0) RETURN
      WRITE (IDAPRT,REC=NAVPRT) IOSPTT,IOSPTV,IOSPMR,IOSPBR,IOSPRT
C
C     WRITE LIST IS 60 WORDS.
C
      CALL PRTSPA
      IF (NAVPRT.LE.0) RETURN
      WRITE (IDAPRT,REC=NAVPRT) ONTREM,OSPTT,OCVREM,OSPTV,OMCREM,OSPMR,
     >       OBFREM,OSPBR,ONTRES,OSPRT,ATAVD,ATTPA,ATBA,ATAVH,ATCCF
   20 CONTINUE
      GOTO 40
   30 CONTINUE
C
C     FINAL OUTPUT FOR STAND.  WRITE LIST IS 13 WORDS.
C
      IF (PDEBUG) WRITE(JOPPRT,5) 'FINAL',NAVPRT
      WRITE (IDAPRT,REC=NAVPRT) IPTELS,IOAGE,ORMSQD,OLDTPA,OLDBA,OLDAVH,
     >       RELDM1,LREMOV,ATAVD,ATTPA,ATBA,ATAVH,ATCCF
C
   40 CONTINUE
      RETURN
      END
