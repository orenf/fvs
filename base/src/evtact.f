      SUBROUTINE EVTACT
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     ESTABLISHES THE LINKAGE BETWEEN AN EVENT, REFERENCED BY THE MOST
C     RECENTLY ASSIGNED INTERNAL EVENT NUMBER (IENV), AND A GROUP OF
C     ACTIVITIES.
C
C     EVENT MONITOR ROUTINE - NL CROOKSTON - AUG 1982 - MOSCOW, ID
C     MODIFIED TO ADD LABEL PROCESSING IN JAN 1987
C
C     ENTRY   DESCRIPTION
C     -----   ----------------------------------------------------------
C     EVTHEN  CALLED WHEN THE THEN KEYWORD IS SPECIFIED, THE OPTION
C             ACTIVITY KEYWORDS WHICH FOLLOW ARE LINKED TO AN EVENT
C             NUMBER AND STORED FOR FUTURE SCHEDULING.
C     EVALSO  CALLED WHEN ALSOTRY KEYWORD IS SPECIFIED.  EVALSO THEN
C             FINDS OUT IF THE PPE IS AN ACTIVE SYSTEM, CLOSES OFF
C             A PREVIOUS ENTRY IN IEVACT, ESTABLISHES NEW ENTRY IN
C             IEVACT, AND ACCOMPLISHES SOME ERROR CHECKING.
C     EVEND   CALLED WHEN ENDIF IS SPECIFIED, CLOSES OFF PREVIOUS
C             ENTRY IN IEVACT, RETURN ACTIVITY STORAGE MODE TO NORMAL.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
COMMONS
C
      LOGICAL LNOTBK(7),DEBUG,LKECHO
      CHARACTER KEYWRD*8,KARD(7)*10,RECORD*80
      REAL ARRAY(7)
      INTEGER IPRMPT,IRECNT,IREAD,JOSTND,ICEX,J,K,I,IAMP,IRC,IRTNCD
      EQUIVALENCE (RECORD,WKSTR3)
C
      ENTRY EVALSO (DEBUG,JOSTND,IREAD,IRECNT,KEYWRD,ARRAY,LNOTBK,
     >              KARD,IPRMPT)
C
C     IF LOPEVN IS FALSE, THE ALSOTRY KEYWORD HAS BEEN SPECIFIED
C     WITHOUT SPECIFYING AN EVENT AND A THEN KEYWORD, AND IS THEREFORE
C     ILLEGAL.
C
      IF (.NOT.LOPEVN) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,16)
         RETURN
      ENDIF
C
C     CLOSE OFF THE LAST ENTRY IN IEVACT, THE EVENT/ACTIVITY LINKAGE
C     ARRAY.  IF NO ACTIVITIES HAVE BEEN SPECIFIED, THE ACTIVITY GROUP
C     IS TERMED A NULL ALTERNATIVE; THEN: SET THE POINTERS TO ZERO.
C
      IF (IEVACT(IEVA,4).LE.IEPT) THEN
         IEVACT(IEVA,4)=0
         IEVACT(IEVA,5)=0
      ELSE
C
C        ELSE: SET THE SECOND POINTER EQUAL TO THE LAST ACTIVITY ENTRY
C        (NOTE THAT IEPT IS DECREMENTED AS ACTIVITIES ARE ENTERED).
C
         IEVACT(IEVA,5)=IEPT+1
      ENDIF
C
C     INCREMENT IEVA, SO THAT IT POINTS TO THE NEXT AVAILABLE ROW
C     IN IEVACT
C
      IEVA=IEVA+1
      GOTO 5
C
C
      ENTRY EVTHEN (DEBUG,JOSTND,IREAD,IRECNT,KEYWRD,ARRAY,LNOTBK,
     >              KARD,IPRMPT,LKECHO)
C
C     IF LOPEVN IS TRUE AND THE LEG COUNT IS ZERO, THIS THEN IS LEGAL
C     AS IT FOLLOWS AN IF AND NOT ANOTHER THEN OR ALSOTRY.
C
      IF (.NOT.LOPEVN .OR. ILGNUM.GT.0) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,16)
         RETURN
      ENDIF
    5 CONTINUE
C
C     VERIFY THAT THERE IS ROOM IN IEVACT TO STORE THE ACTIVITIY GROUP.
C
      IF (IEVA.GT.MAXEVA) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,17)
         RETURN
      ENDIF
C
C     INCREMENT THE BRANCH LEG COUNTER.
C
      ILGNUM=ILGNUM+1
C
C     IF THERE ARE OVER 9 ACTIVITY GROUPS, ISSUE ERROR MSG
C
      IF (ILGNUM.GT.9) CALL ERRGRO (.TRUE.,22)
C
C     ESTABLISH AN ENTRY IN IEVACT.
C
      IEVACT(IEVA,1)=IEVT
      IEVACT(IEVA,2)=0
      IEVACT(IEVA,3)=ILGNUM
      IEVACT(IEVA,4)=IEPT
C
C     WRITE INITIAL KEYWORD MESSAGE.
C
      IF(LKECHO)WRITE(JOSTND,6) KEYWRD
    6 FORMAT (/1X,A8,'   ACTIVITIES WHICH FOLLOW WILL NOT BE ',
     >        'SCHEDULED UNTIL THE EVENT HAPPENS (WHEN THE ',
     >        'LOGICAL EXPRESSION IS TRUE).')
C
C     PROCESS THE BRANCH WEIGHT MULTIPLIER CODED ON THE KEYWORD.
C
C     IF IPRMPT IS ZERO, CHECK ARRAY(1)...IF NOT BLANK STORE IT AS
C     THE MULTIPLIER AND WRITE OUT A MESSAGE.
C
      IF (IPRMPT.EQ.0) THEN
         IF (LNOTBK(1)) THEN
            IF (IMPL.LE.ITOPRM) THEN
               PARMS(IMPL)=ARRAY(1)
               IEVACT(IEVA,6)=IMPL
               IMPL=IMPL+1
               IF(LKECHO)
     >         WRITE(JOSTND,'(T13,''BRANCH WEIGHT MULTIPLIER = '',
     >                F12.5)') ARRAY(1)
            ELSE
               IEVACT(IEVA,6)=0
               CALL ERRGRO (.TRUE.,10)
               WRITE (JOSTND,'(T13,''MULTIPLIER IGNORED.'')')
            ENDIF
         ENDIF
      ELSE
C
C        MOVE THE EXPRESSION INTO CEXPRS.
C
         ICEX=0
         DO 10 J=IPRMPT,7
         DO 10 K=1,10
         ICEX=ICEX+1
         CEXPRS(ICEX)=KARD(J)(K:K)
         CALL UPCASE(CEXPRS(ICEX))
   10    CONTINUE
C
C        WRITE THE FIRST LINE.
C
         WRITE (JOSTND,20) (CEXPRS(I),I=1,ICEX)
   20    FORMAT (T13,'MULTIPLIER= ',70A1)
C
C        LOOK FOR AN AMPERSAND
C
         IAMP=0
         DO 30 I=1,ICEX
         IF (CEXPRS(I).EQ.'&') THEN
            IAMP=I
            GOTO 35
         ENDIF
   30    CONTINUE
   35    CONTINUE
C
C        IF THERE IS AN AMPERSAND, READ ANOTHER RECORD, ADD IT TO CEXPRS
C
         IF (IAMP.GT.0) THEN
            ICEX=IAMP
            READ (IREAD,'(A)',END=200) RECORD
            DO 40 I=80,1,-1
            IF (RECORD(I:I).EQ.' ') GOTO 40
            J=I
            GOTO 45
   40       CONTINUE
            J=1
   45       CONTINUE
            IRECNT=IRECNT+1
            IAMP=0
            DO 50 I=1,J
            CALL UPCASE (RECORD(I:I))
            CEXPRS(ICEX)=RECORD(I:I)
            IF (CEXPRS(ICEX).EQ.'&') THEN
               IAMP=ICEX
               GOTO 55
            ENDIF
            ICEX=ICEX+1
            IF (ICEX.GT.MXEXPR) THEN
               WRITE (JOSTND,'(T13,A)') RECORD
               CALL ERRGRO (.TRUE.,4)
               IEVACT(IEVA,6)=-I
               RETURN
            ENDIF
   50       CONTINUE
            ICEX=ICEX-1
   55       CONTINUE
            WRITE (JOSTND,'(T13,A)') RECORD
            GOTO 35
         ENDIF
C
C        TRIM OFF TRAILING BLANKS.
C
         K=ICEX
         DO 60 I=K,1,-1
         IF (CEXPRS(I).EQ.' ') GOTO 60
         ICEX=I
         GOTO 65
   60    CONTINUE
   65    CONTINUE
C
C        STORE THE LOCATION OF THE OPCODE IN KODE.
C
         I=ICOD
C
C        COMPILE THE EXPRESSION.
C
         CALL ALGCMP(IRC,.FALSE.,CEXPRS,ICEX,JOSTND,DEBUG,1000,
     >      IPTODO,MXPTDO,IEVCOD,ICOD,MAXCOD,PARMS,IMPL,ITOPRM,MAXPRM)
C
C        IF THE RETURN CODE FROM THE COMPILATION IS NON ZERO, ISSUE
C        AN ERROR MESSAGE AND SET THE BRANCH MULT CODE TO ZERO.
C
         IF (IRC.GT.0) THEN
            IEVACT(IEVA,6)=0
            CALL ERRGRO (.TRUE.,12)
         ELSE
C
C        STORE LOCATION OF THE OPERATION CODE (SET THE POINTER NEG).
C
            IEVACT(IEVA,6)=-I
         ENDIF
      ENDIF
      RETURN
  200 CONTINUE
      CALL ERRGRO(.FALSE.,2)
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN

      RETURN
C
C
      ENTRY EVEND (DEBUG,JOSTND,IRECNT,KEYWRD,ARRAY,LNOTBK,KARD,
     &             IPRMPT,LKECHO)
C
C     SET THE ACTIVITY STORAGE MODE TO NORMAL,
C     CLOSE THE EVENT ACTIVITY GROUP LINKAGE ARRAY, AND
C     INCREMENT THE INTERNAL EVENT NUMBER.
C     IF THE ACTIVITY STORAGE MODE IS NORMAL, THEN THE ENDIF WAS IN
C     THE INCORRECT SEQUENCE.
C
      IF (.NOT.LOPEVN .OR. ILGNUM.LE.0) THEN
C
C        IF IPRMPT IS LE -1, CALL WAS MADE WHEN A PROCESS KEYWORD
C        WAS DETECTED. SUPPRESS WRITING AN ERROR MESSAGE.
C
         IF (IPRMPT.LE.-1) RETURN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,16)
      ELSE
         LOPEVN=.FALSE.
         ILGNUM=0
         IEVT=IEVT+1
         IF (IEVACT(IEVA,4).LE.IEPT) THEN
            IEVACT(IEVA,4)=0
            IEVACT(IEVA,5)=0
         ELSE
            IEVACT(IEVA,5)=IEPT+1
         ENDIF
         IEVA=IEVA+1
         IF(LKECHO)WRITE(JOSTND,300) KEYWRD
  300    FORMAT (/1X,A8,'   ACTIVITIES WHICH FOLLOW WILL BE SCHEDULED.')
      ENDIF
      END
