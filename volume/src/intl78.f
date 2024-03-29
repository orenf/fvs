!== last modified  03-29-2004
      SUBROUTINE INTL78 (DBHOB, HT1PRD, VOL,ERRFLAG)

C    PROGRAM INTERNATIONAL 1/4 FORM CLASS 78
      REAL DBHOB, HT1PRD, THT1, VOL(15), INTL(31,11)
      INTEGER ERRFLAG,I,INDEX

      DATA ((INTL(J,I),I=1,11),J=1,31) /
     >  36,48,59,66,73,0,0,0,0,0,0,
     >  46,61,76,86,96,0,0,0,0,0,0,
     >  56,74,92,106,120,128,137,0,0,0,0,
     >  67,90,112,130,147,158,168,0,0,0,0,
     >  78,105,132,153,174,187,200,0,0,0,0,
     >  92,124,156,182,208,225,242,0,0,0,0,
     >  106,143,180,210,241,263,285,0,0,0,0,
     >  121,164,206,242,278,304,330,0,0,0,0,
     >  136,184,233,274,314,344,374,0,0,0,0,
     >  154,209,264,311,358,392,427,0,0,0,0,
     >  171,234,296,348,401,440,480,511,542,0,0,
     >  191,262,332,391,450,496,542,579,616,0,0,
     >  211,290,368,434,500,552,603,647,691,0,0,
     >  231,318,404,478,552,608,663,714,766,0,0,
     >  251,346,441,523,605,664,723,782,840,0,0,
     >  275,380,484,574,665,732,800,865,930,0,0,
     >  299,414,528,626,725,801,877,949,1021,0,0,
     >  323,448,572,680,788,870,952,1032,1111,0,0,
     >  347,482,616,733,850,938,1027,1114,1201,1280,1358,
     >  375,521,667,794,920,1016,1112,1210,1308,1398,1488,
     >  403,560,718,854,991,1094,1198,1306,1415,1517,1619,
     >  432,602,772,921,1070,1184,1299,1412,1526,1640,1754,
     >  462,644,826,988,1149,1274,1400,1518,1637,1762,1888,
     >  492,686,880,1053,1226,1360,1495,1622,1750,1888,2026,
     >  521,728,934,1119,1304,1447,1590,1727,1864,2014,2163,
     >  555,776,998,1196,1394,1548,1702,1851,2000,2156,2312,
     >  589,826,1063,1274,1485,1650,1814,1974,2135,2298,2461,
     >  622,873,1124,1351,1578,1752,1926,2099,2272,2444,2616,
     >  656,921,1186,1428,1670,1854,2038,2224,2410,2590,2771,
     >  694,976,1258,1514,1769,1968,2166,2359,2552,2744,2937,
     >  731,1030,1329,1598,1868,2081,2294,2494,2693,2898,3103/


      DO 10 I=1,15
        VOL(I) = 0.0
 10   CONTINUE

      
      ERRFLAG = 0
      IF(DBHOB .LE. 1.0)THEN
        ERRFLAG = 3
        RETURN
      ENDIF
      IF(HT1PRD .LE. 0.0) THEN
        ERRFLAG = 7
        RETURN
      ENDIF
 
      INDEX = ANINT(DBHOB) - 9
      THT1 = HT1PRD / 10.0

      IF (INDEX.LE.0) THEN
        VOL(2) = 0.0
      ELSEIF (THT1 .EQ. 1) THEN
        VOL(2) = INTL(INDEX,1)   
      ELSEIF (THT1 .EQ. 1.5) THEN
        VOL(2) = INTL(INDEX,2)
      ELSEIF (THT1 .EQ. 2.0) THEN
        VOL(2) = INTL(INDEX,3)
      ELSEIF (THT1 .EQ. 2.5) THEN
        VOL(2) = INTL(INDEX,4)
      ELSEIF (THT1 .EQ. 3.0) THEN
        VOL(2) = INTL(INDEX,5)
      ELSEIF (THT1 .EQ. 3.5) THEN
        VOL(2) = INTL(INDEX,6)
      ELSEIF (THT1 .EQ. 4.0) THEN
        VOL(2) = INTL(INDEX,7)
      ELSEIF (THT1 .EQ. 4.5) THEN
        VOL(2) = INTL(INDEX,8)
      ELSEIF (THT1 .EQ. 5.0) THEN
        VOL(2) = INTL(INDEX,9)
      ELSEIF (THT1 .EQ. 5.5) THEN
        VOL(2) = INTL(INDEX,10)
      ELSEIF (THT1 .EQ. 6.0) THEN
        VOL(2) = INTL(INDEX,11)
      ENDIF

      VOL(3) = VOL(2)

      RETURN
      END
