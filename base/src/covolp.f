      SUBROUTINE COVOLP (DEBUG,JOSTND,NTREES,INDEX,CRAREA,COVER)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     N.L.CROOKSTON - RMRS MOSCOW - OCTOBER 1997

C     OUTPUT:
C     COVER = PERCENT COVER THAT ACCOUNTS FOR CROWN OVERLAP 

C     INPUT:
C     DEBUG = .TRUE. IF DEBUGING OUTPUT IS REQUESTED.
C     JOSTND= THE DATA SET REF NUMBER FOR OUTPUT.
C     NTREES= THE NUMBER OF VALUES IN INDEX (COULD BE EQUAL TO ITRN).
C     INDEX = A VECTOR OF TREE RECORD POINTERS THAT WILL BE INCLUDED
C             IN THE CALCULATIONS (COULD BE PASSED AS IND).
C             IF INDEX(1) IS ZERO, THE INDICES ARE NOT USED.
C     CRAREA= LOADED WITH THE CROWN AREA (PER ACRE) PROJECTED BY EACH 
C             TREE RECORD

      REAL CRAREA(*),COVER,SUM
      INTEGER INDEX(*),NTREES,JOSTND,I
      LOGICAL   DEBUG

      COVER = 0.

      IF (DEBUG) WRITE (JOSTND,'('' IN COVOLP, NTREES ='',I4)') 
     >           NTREES

      IF (NTREES.EQ.0) GOTO 30

      SUM = 0.

      IF (INDEX(1).EQ.0) THEN
         DO I=1,NTREES
            SUM = SUM+CRAREA(I)
         ENDDO
      ELSE
         DO I=1,NTREES
            SUM = SUM+CRAREA(INDEX(I))
         ENDDO
      ENDIF
      
      IF (SUM.GT.1000000.) THEN
         COVER=100.
      ELSE
         COVER = (1.-(1./EXP(SUM/43560.)))*100.
      ENDIF

 30   CONTINUE
      IF (DEBUG) WRITE (JOSTND,40) SUM,COVER 
 40   FORMAT (' SUM=',E14.7,' COVER=',F8.1) 

      RETURN
      END

