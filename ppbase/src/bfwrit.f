      SUBROUTINE BFWRIT (BUFFER,IPNT,ILIMIT,VARBLE,ILEN,IBEGIN)
      IMPLICIT NONE
C----------
C  **BFWRIT--PPBASE    DATE OF LAST REVISION:  07/31/08          
C----------
C
C     WRITE A VARIABLE TO THE DIRECT ACCESS FILE USING BUFFERING.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     P.W. THOMAS--FORESTRY SCIENCES LAB, MOSCOW, ID--SEPT 1985
C
C     CALLED FROM:
C
C       PUTSTD - STORE A STAND ON DIRECT ACCESS FILE IDAIO.
C       MSTRPT - STORE THE MASTER SCHEDULED OPTION LIST.
C       PPAUSE - PAUSE THE PARALLEL PROCESSINT EXTENSION BY
C                WRITING ITS DATA TO DIRECT ACCESS FILE IDAIO.
C
C     SUBROUTINES CALLED:
C
C       STASH  - STORE A RECORD IN THE DIRECT ACCESS FILE IDAIO.
C
C     PARAMETERS:
C
C        BUFFER - A SINGLE DIMENSIONAL WORK ARRAY USED AS A PRINT
C                 BUFFER.
C        IPNT   - POINTER TO THE CURRENT WORD IN THE BUFFER.
C                 WHEN READING THE FIRST RECORD IN A SERIES,
C                 IPNT IS SET TO THE END OF THE BUFFER IN ORDER
C                 BE RESET TO ZERO ON THE FIRST READ.
C        ILIMIT - END OF BUFFER.  MAX NUMBER OF WORDS WHICH CAN
C                 BE STORED IN BUFFER.
C        VARBLE - THE ARRAY WHICH IS WRITTEN TO THE BUFFER.
C        ILEN   - THE NUMBER OF WORDS IN VARBLE.
C        IBEGIN - SIGNAL DESCRIBING WHETHER WE ARE BEGINNING A
C                 SERIES OF CALLS TO BFWRIT, IN THE MIDDLE OF A
C                 SERIES OF CALLS, OR AT THE END OF A SERIES OF CALLS.
C
C                 1 - THIS IS THE FIRST CALL IN A GROUP TO BFWRIT.
C                     THE BUFFER IS SET EMPTY, SO WE WILL
C                     BEGIN WRITING TO A NEW RECORD.
C                 2 - THIS IS A MIDDLE CALL TO BFWRIT.
C                 3 - THIS IS THE LAST CALL TO BFWRIT, WHICH
C                     DUMPS THE CONTENTS OF THE BUFFER, AND
C                     FINALIZES THE WRITE.
C
      REAL BUFFER (*), VARBLE (*)
      INTEGER IBEGIN,ILEN,ILIMIT,IPNT,IWORD
      IF (IBEGIN.EQ.1) IPNT=0
  100 CONTINUE
      IF (ILEN.LT.1) GOTO 1000
      DO 900 IWORD=1,ILEN
      IF (IPNT.LT.ILIMIT) GOTO 500
      CALL STASH (BUFFER,ILIMIT)
      IPNT=0
  500 CONTINUE
      IPNT=IPNT+1
      BUFFER (IPNT)=VARBLE (IWORD)
  900 CONTINUE
 1000 CONTINUE
      IF (IBEGIN.EQ.3) CALL STASH (BUFFER,ILIMIT)
      RETURN
      END
