      PROGRAM TDSPBL
C
C
C     ==================================================================
C     ==================================================================
C     ====  TDSPBL -- CERTIFY DOUBLE PRECISION SPARSE BLAS          ====
C     ==================================================================
C     ==================================================================
C
C     TDSPBL IS THE CERTIFICATION PROGRAM FOR THE DOUBLE PRECISION
C     SPARSE BLAS.  THE APPROACH USED TO CERTIFY THE SPARSE BLAS
C     IS AS FOLLOWS:
C
C     1.  READ IN USER SPECIFIED INPUT ON OUTPUT UNIT, THRESHOLD VALUE
C         FOR TEST RATIO, AND THE SPECIFICATIONS FOR NZ, A, C AND S.
C     2.  VERIFY THE CORRECTNESS OF THE USER SPECIFIED INPUT AND
C         ECHO TO THE OUTPUT UNIT.
C     3.  FOR EACH SUBPROGRAM IN THE DOUBLE PRECISION SPARSE BLAS
C         PERFORM ALL THE USER SPECIFIED TESTS AND PRINT A PASS/FAIL
C         MESSAGE.  TESTS WHICH FAIL GENERATE ADDITIONAL OUTPUT.
C
C     SPARSE BLAS SUBPROGRAMS WHICH ARE CERTIFIED BY THIS PROGRAM ARE
C
C         DAXPYI          DGTHR           DROTI
C         DDOTI           DGTHRZ          DSCTR
C
C     THIS PROGRAM REQUIRES AN INPUT FILE ASSIGNED TO UNIT NIN 
C     (CURRENTLY SET TO 5 BY A PARAMETER STATEMENT).  THE DATA ON
C     THIS INPUT FILE CONTROLS THE OUTPUT UNIT, THE THRESHOLD VALUE
C     FOR THE NUMERICAL TESTING, AND THE SPECIFICATIONS FOR THE
C     TEST VALUES FOR THE LENGTH OF THE SPARSE VECTORS AND THE SCALARS 
C     USED BY THE VARIOUS SUBPROGRAMS.  AN EXAMPLE OF THE INPUT FILE 
C     FOLLOWS
C
C LINE  1     'DBLATS.SUMM'           NAME OF OUTPUT FILE
C LINE  2     6                       UNIT NUMBER OF OUTPUT FILE
C LINE  3     100                     MAX. NO. OF PRINTED ERROR MESSAGES
C LINE  4     5.0                     THRESHOLD VALUE OF TEST RATIO
C LINE  5     6                       NUMBER OF VALUES OF NZ
C LINE  6     -1 0 1 2 5 9            VALUES OF NZ
C LINE  7     3                       NUMBER OF VALUES OF A FOR -AXPYI
C LINE  8     0.0 1.0 0.7             VALUES OF A
C LINE  9     5                       NUMBER OF VALUES OF C,S FOR -ROTI
C LINE 10     0. 1. 0. -.6  .8        VALUES OF C
C LINE 11     0. 0. 1   .8 -.6        VALUES OF S
C
C
C     THIS INPUT FILE IS READ USING FORTRAN-77 STANDARD LIST DIRECTED
C     INPUT.  SINGLE QUOTES ARE REQUIRED AROUND THE NAME OF THE OUTPUT
C     FILE ON LINE 1.  THE NUMBERS ON LINES 6, 8, 10, AND 11 CAN BE
C     DELIMITED BY BLANKS OR COMMAS.
C
C     THIS PROGRAM WAS WRITTEN BY ROGER G. GRIMES, BOEING
C     COMPUTER SERVICES, BELLEVUE, WA. DURING APRIL, 1987.
C
C     ==================================================================
C
C     ------------------------------------
C     ... PROBLEM SPECIFICATION PARAMETERS
C     ------------------------------------
C
C         NIN         INPUT UNIT
C         NZMAX       MAXIMUM VALUE OF ANY SINGLE NZ
C         NNZMAX      MAXIMUM NUMBER OF VALUES OF NZ 
C         NAMAX       MAXIMUM NUMBER OF VALUES OF A (-AXPYI
C                     SCALAR)
C         NGMAX       MAXIMUM NUMBER OF VALUES OF C AND S
C                     (-ROTI SCALARS FOR GIVENS ROTATION)
C
C     ==================================================================
C
      INTEGER             NIN,    NZMAX,  NNZMAX, NAMAX,  NGMAX
C
      PARAMETER         ( NIN = 5,        NZMAX = 320,
     1                    NNZMAX = 24,    NAMAX = 7,      NGMAX = 7 )
C
C     -----------------------
C     ... COMPUTED PARAMETERS
C     -----------------------
C
      INTEGER             NZMAX2
C
      PARAMETER         ( NZMAX2 = 2 * NZMAX )
C
C     ==================================================================
C
C     ------------------------
C     ... VARIABLE DECLARATION
C     ------------------------
C
      CHARACTER*32        NAMOUT
C
      INTEGER             ERRCNT, ERRMAX, I,      NOUT,   NUMA,   
     1                    NUMG,   NUMNZ
C
      INTEGER             INDX  (NZMAX2),     INDXT (NZMAX2),
     1                    LIST  (NZMAX2),     NZVALU(NNZMAX)
C
      DOUBLE PRECISION    EPSILN, EPSSAV, THRESH
C
      DOUBLE PRECISION    X     (NZMAX2),     Y     (NZMAX2),
     1                    XTRUE (NZMAX2),     YTRUE (NZMAX2),
     2                    XSAVE (NZMAX2),     YSAVE (NZMAX2),
     3                    AVALUE(NAMAX),      CVALUE(NGMAX),
     4                    SVALUE(NGMAX)
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      DOUBLE PRECISION    DDIFF
C
      EXTERNAL            TDXPYI, TDDOTI, TDGTHR, TDGTHZ, TDROTI,
     1                    TDSCTR, DDIFF
C
C     ==================================================================
C
      ERRCNT = 0
C
C     ------------------------------------------------
C     ... READ IN USER SPECIFIED INPUT FOR OUTPUT UNIT
C     ------------------------------------------------
C
      READ ( NIN, * ) NAMOUT
      READ ( NIN, * ) NOUT
C
C     --------------------
C     ... OPEN OUTPUT UNIT
C     --------------------
C
C      OPEN ( UNIT = NOUT, FILE = NAMOUT, STATUS = 'NEW' )
      OPEN ( UNIT = NOUT, FILE = NAMOUT )
C
C     ------------------------------
C     ... READ IN REMAINDER OF INPUT
C     ------------------------------
C
      READ ( NIN, * ) ERRMAX
      READ ( NIN, * ) THRESH
      READ ( NIN, * ) NUMNZ
C
      IF ( NUMNZ .GT. NNZMAX ) THEN
          ERRCNT = 1
          WRITE ( NOUT, 1100 ) NUMNZ, NNZMAX
          GO TO 900
      END IF
C
      READ ( NIN, * ) ( NZVALU(I), I = 1, NUMNZ )
C
      READ ( NIN, * ) NUMA
C
      IF ( NUMA .GT. NAMAX ) THEN
          ERRCNT = 1
          WRITE ( NOUT, 1110 ) NUMA, NAMAX
          GO TO 900
      END IF
C
      READ ( NIN, * ) ( AVALUE(I), I = 1, NUMA  )
C
      READ ( NIN, * ) NUMG
C
      IF ( NUMG .GT. NGMAX ) THEN
          ERRCNT = 1
          WRITE ( NOUT, 1120 ) NUMG, NGMAX
          GO TO 900
      END IF
C
      READ ( NIN, * ) ( CVALUE(I), I = 1, NUMG  )
      READ ( NIN, * ) ( SVALUE(I), I = 1, NUMG  )
C
C     ------------------------------
C     ... PRINT USER SPECIFIED INPUT
C     ------------------------------
C
      WRITE ( NOUT, 1000 ) NAMOUT, NOUT, ERRMAX, THRESH
      WRITE ( NOUT, 1010 ) NUMNZ
      WRITE ( NOUT, 1020 ) ( NZVALU(I), I = 1, NUMNZ )
      WRITE ( NOUT, 1030 ) NUMA
      WRITE ( NOUT, 1040 ) ( AVALUE(I), I = 1, NUMA  )
      WRITE ( NOUT, 1050 ) NUMG
      WRITE ( NOUT, 1060 ) ( CVALUE(I), I = 1, NUMG  )
      WRITE ( NOUT, 1070 ) ( SVALUE(I), I = 1, NUMG  )
C
C     -------------------------------
C     ... VERIFY USER SPECIFIED INPUT
C     -------------------------------
C
      IF  ( THRESH .LE. 0.0D0 )  THEN
          WRITE ( NOUT, 1130 ) THRESH
          THRESH = 10.0D0
      END IF
C
      IF  ( NUMNZ .LE. 0 )  THEN
          WRITE ( NOUT, 1140 ) NUMNZ
          ERRCNT = 1
      END IF
C
      DO 100 I = 1, NUMNZ
          IF  ( NZVALU(I) .GT. NZMAX )  THEN
              WRITE ( NOUT, 1150 ) I, NZVALU(I), NZMAX
              NZVALU(I) = NZMAX
          END IF
  100 CONTINUE
C
      IF  ( ERRCNT .NE. 0 )  GO TO 900
C
C     ---------------------------
C     ... COMPUTE MACHINE EPSILON
C     ---------------------------
C
      EPSILN = 1.0D0
      EPSSAV = 1.0D0
C
  200 IF  ( DDIFF ( 1.0D0 + EPSILN, 1.0D0 ) .EQ. 0.0D0 )  GO TO 210
C
          EPSSAV = EPSILN
          EPSILN = EPSILN * .5D0
          GO TO 200
C
  210 EPSILN = EPSSAV
C
C     ==================================================================
C
C     -----------------------------------------
C     ... TEST THE DOUBLE PRECISION SPARSE BLAS
C     -----------------------------------------
C
C     ------------------
C     ... CERTIFY DAXPYI
C     ------------------
C
      CALL TDXPYI (   NOUT,   EPSILN, THRESH, NZMAX2,
     1                NUMNZ,  NZVALU, NUMA,   AVALUE,
     2                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     3                INDX,   INDXT,  LIST,   ERRCNT, ERRMAX )
C
C     -----------------
C     ... CERTIFY DDOTI
C     -----------------
C
      CALL TDDOTI (   NOUT,   EPSILN, THRESH, NZMAX2,
     1                NUMNZ,  NZVALU, 
     2                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     3                INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     -----------------
C     ... CERTIFY DGTHR
C     -----------------
C
      CALL TDGTHR (   NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     2                INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ------------------
C     ... CERTIFY DGTHRZ
C     ------------------
C
      CALL TDGTHZ (   NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     2                INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     -----------------
C     ... CERTIFY DROTI
C     -----------------
C
      CALL TDROTI (   NOUT,   EPSILN, THRESH, NZMAX2,
     1                NUMNZ,  NZVALU, NUMG,   CVALUE, SVALUE,
     2                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     3                INDX,   INDXT,  LIST,   ERRCNT, ERRMAX )
C
C     -----------------
C     ... CERTIFY DSCTR
C     -----------------
C
      CALL TDSCTR (   NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                X,      XSAVE,  XTRUE,  Y,      YSAVE,  YTRUE,
     2                INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ==================================================================
C
C     -------------------------------------
C     ... PRINT GLOBAL PASS OR FAIL MESSAGE
C     -------------------------------------
C
  900 IF  ( ERRCNT .EQ. 0 )  THEN
          WRITE ( NOUT, 2000 )
      ELSE
          WRITE ( NOUT, 2100 ) ERRCNT
      END IF
C
C     -----------------------------------------------------
C     ... END OF CERTIFICATION PROGRAM FOR DOUBLE PRECISION
C         SPARSE BLAS
C     -----------------------------------------------------
C
      STOP
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT( '1' ///
     1          5X, 'START OF CERTIFICATION PROGRAM FOR THE DOUBLE ',
     2              'PRECISION SPARSE BLAS'
     3         /5X, '----------------------------------------------',
     4              '---------------------'
     5        //5X, 'NAME   OF OUTPUT UNIT              = ', A
     6         /5X, 'NUMBER OF OUTPUT UNIT              = ', I10
     7         /5X, 'MAX. NO. OF PRINTED ERROR MESSAGES = ', I10    
     8         /5X, 'THRESHOLD VALUE OF TEST RATIO      = ', F10.1 )
C 
 1010 FORMAT ( /5X, 'NUMBER OF VALUES OF NZ        = ', I10 )
C
 1020 FORMAT ( /5X, 'VALUES OF NZ = ', 10I5 )
C
 1030 FORMAT ( /5X, 'NUMBER OF VALUES OF A         = ', I10 )
C
 1040 FORMAT ( /5X, 'VALUES OF A = ', 1P, 5D13.4 )
C
 1050 FORMAT ( /5X, 'NUMBER OF VALUES OF C AND S   = ', I10 )
C
 1060 FORMAT ( /5X, 'VALUES OF C = ', 1P, 5D13.4 )
C
 1070 FORMAT ( /5X, 'VALUES OF S = ', 1P, 5D13.4 )
C
 1100 FORMAT ( /5X, 'USER SPECIFIED NUMBER OF TEST CASES FOR THE ',
     1              'NUMBER OF NONZEROES EXCEEDS PROGRAM LIMIT.'
     2         /5X, 'NUMBER SPECIFIED = ', I10, 2X, 'PROGRAM LIMIT =',
     3              I10 )
C
 1110 FORMAT ( /5X, 'USER SPECIFIED NUMBER OF TEST CASES FOR THE ',
     1              'SCALAR A EXCEEDS PROGRAM LIMIT.'
     2         /5X, 'NUMBER SPECIFIED = ', I10, 2X, 'PROGRAM LIMIT =',
     3              I10 )
C
 1120 FORMAT ( /5X, 'USER SPECIFIED NUMBER OF TEST CASES FOR THE ',
     1              'SCALARS C AND S EXCEEDS PROGRAM LIMIT.'
     2         /5X, 'NUMBER SPECIFIED = ', I10, 2X, 'PROGRAM LIMIT =',
     3              I10 )
C
 1130 FORMAT ( /5X, 'USER SPECIFIED VALUE FOR THRESHOLD IS ', 
     1              1PD15.5, ' WHICH IS NONPOSITIVE.  IT ',
     2              'HAS BEEN RESET TO 10.')
C
 1140 FORMAT ( /5X, 'USER SPECIFIED NUMBER OF VALUES OF NZ IS ', I5,
     1              ' WHICH IS NONPOSITIVE.  NO TESTING WILL OCCUR.' )
C
 1150 FORMAT ( /5X, 'THE ', I3, '-TH USER SPECIFIED VALUE OF NZ IS ', 
     1              I8, ' IS LARGER THAN THE MAXIMUM ALLOWABLE ',
     2              'VALUE OF NZ.  IT HAS BEEN RESET TO ', I5 )
C
 2000 FORMAT ( /5X, 'DOUBLE PRECISION SPARSE BLAS HAVE PASSED ALL ',
     1              'TESTS.' )
C
 2100 FORMAT ( /5X, 'DOUBLE PRECISION SPARSE BLAS HAVE FAILED ', I10,
     1              ' TESTS.  SEE ABOVE PRINTED ERROR MESSAGES.' )
C
C     ==================================================================
C
      END
      DOUBLE PRECISION FUNCTION DDIFF ( X, Y )
C
C     ==================================================================
C
C     DDIFF IS USED BY THE MAIN PROGRAM TO COMPARE 1.0 + EPSILN WITH
C     1.0.  ITS SOLE USE IS TO FOOL AN OPTIMIZING COMPILER.
C
C     ==================================================================
C
C     ------------------------
C     ... VARIABLE DECLARATION
C     ------------------------
C
      DOUBLE PRECISION    X, Y
C
C     ==================================================================
C
      DDIFF = X - Y
C
C     ==================================================================
C
      RETURN
      END
      LOGICAL FUNCTION   DVSAME   ( N, DX, DY )
C
C     ==================================================================
C
C     LOGICAL FUNCTION  DVSAME  DETERMINES IF THE VECTORS  DX  AND  DY
C     AGREE EXACTLY WITH EACH OTHER.
C
C     ==================================================================
C
C     ------------------------
C     ... VARIABLE DECLARATION
C     ------------------------
C
      INTEGER             I, N 
C
      DOUBLE PRECISION    DX (*), DY (*)
C
C     ==================================================================
C
      DVSAME = .TRUE.
C
      DO 10 I = 1, N
          IF  ( DX(I) .NE. DY(I) )  THEN
              DVSAME = .FALSE.
              GO TO 20
          ENDIF
   10 CONTINUE
C
   20 RETURN
      END

      SUBROUTINE   TDXPYI   ( NOUT,   EPSILN, THRESH, NZMAX2,
     1                        NUMNZ,  NZVALU, NUMA,   AVALUE,
     2                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     3                        YTRUE , INDX,   INDXT,  LIST,   ERRCNT, 
     4                        ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDXPYI  -- CERTIFY  DAXPYI                              ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDXPYI  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DAXPYI.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  NUMA,   ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*),
     1                    LIST (*)
C
      DOUBLE PRECISION    EPSILN, THRESH
C
      DOUBLE PRECISION    AVALUE (*),  
     1                    X (*),       XSAVE (*),   XTRUE (*),
     2                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      DOUBLE PRECISION    A,      ATRUE,  CLOBBR
C
      INTEGER             COUNT,  I,      ICLOBR, J,      KA,
     1                    KINDX,  KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    ERR,    S,      T
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME, DVSAME
C
      EXTERNAL            ICOPY,  DCOPY,  IINIT,  DINIT,  GNINDX, 
     1                    IVSAME, DVSAME, DAXPYI
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6*DBLE(I) )
         YSAVE(I) = SIN ( .7*DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 700 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -----------------------
C         ... FOR EACH VALUE OF A
C         -----------------------
C
          DO 600 KA = 1, NUMA
C
              ATRUE = AVALUE(KA)
C
C             -------------------------------
C             ... FOR EACH KIND OF INDX ARRAY
C             -------------------------------
C
              DO 500 KINDX = 1, 5
C
                  CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
                  CALL IINIT ( N, -1, LIST, 1 )
C
                  DO 150 I = 1, NZTRUE
                      LIST (INDXT(I)) = I
  150             CONTINUE
C
C                 -----------------------
C                 ... GENERATE INPUT DATA
C                 -----------------------
C
                  I = MIN ( N, N-NZTRUE )
                  J = N - I + 1
                  CALL DCOPY ( NZTRUE, XSAVE,  1, XTRUE, 1 )
                  CALL DINIT ( I,      CLOBBR, XTRUE(J), 1 )
                  CALL DINIT ( N,      CLOBBR, YTRUE, 1 )
C
                  DO 200 I = 1, NZTRUE
                      YTRUE (INDXT(I)) = YSAVE (INDXT(I))
  200             CONTINUE
C
C                 -------------------
C                 ... COPY TRUE INPUT
C                 -------------------
C
                  A  = ATRUE
                  NZ = NZTRUE
C
                  CALL DCOPY ( N, YTRUE, 1, Y, 1 )
                  CALL DCOPY ( N, XTRUE, 1, X, 1 )
                  CALL ICOPY ( N, INDXT, 1, INDX, 1 )
C
C                 --------------------------
C                 ... COMPUTE IN-LINE RESULT
C                 --------------------------
C
                  DO 300 I = 1, NZTRUE
                      YTRUE (INDXT(I)) = YTRUE (INDXT(I))  + 
     1                                   ATRUE * XTRUE(I)
  300             CONTINUE
C
C                 ---------------
C                 ... CALL DAXPYI
C                 ---------------
C
                  CALL DAXPYI ( NZ, A, X, INDX, Y )
C
C                 -----------------------------------------
C                 ... TEST ARGUMENTS OF DAXPYI THAT ARE NOT
C                     SUPPOSE TO CHANGE.
C                 -----------------------------------------
C
                  IF  ( NZ .NE. NZTRUE )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1000 ) NZTRUE, ATRUE, KINDX,
     1                                         NZ
                      END IF
                  END IF
C
                  IF  ( A .NE. ATRUE )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1100 ) NZTRUE, ATRUE, KINDX,
     1                                         A
                      END IF
                  END IF
C
                  IF  ( .NOT. DVSAME ( N, X, XTRUE ) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1200 ) NZTRUE, ATRUE, KINDX
                      END IF
                  END IF
C
                  IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1300 ) NZTRUE, ATRUE, KINDX
                      END IF
                  END IF
C
C                 ---------------------------
C                 ... TEST OUTPUT FROM DAXPYI
C                 ---------------------------
C
                  DO 400 J = 1, N
                      IF  ( LIST(J) .EQ. -1 )  THEN 
                          IF  ( Y(J) .NE. YTRUE(J) )  THEN
                              COUNT = COUNT + 1
                              IF  ( COUNT .LE. ERRMAX )  THEN 
                                  WRITE ( NOUT, 1400 ) NZTRUE, ATRUE, 
     1                                                 KINDX, J, 
     2                                                 Y(J), YTRUE(J)
                              END IF
                          END IF
C
                      ELSE
C
                          S   = ABS ( Y(J) - YTRUE(J) )
                          T   = ABS ( ATRUE) * ABS ( XTRUE (LIST(J)))  + 
     1                          ABS ( YSAVE(J))
                          ERR = S / ( EPSILN * T )
                          IF  ( ERR .GT. THRESH )  THEN
                              COUNT = COUNT + 1
                              IF  ( COUNT .LE. ERRMAX )  THEN 
                                  WRITE ( NOUT, 1500 ) NZTRUE, ATRUE, 
     1                                                 KINDX, J, Y(J),
     2                                                 YTRUE(J), ERR
                              END IF
                          END IF
C
                      END IF
C
  400             CONTINUE
C
  500         CONTINUE
C
  600     CONTINUE
C
  700 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDXPYI
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DAXPYI ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5,
     3             '.  ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DAXPYI ALTERED A FOR TEST WITH NZ = ', I5,
     1             ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5,
     3             '.  ALTERED VALUE OF A =', 1PD15.5 )
C
 1200 FORMAT ( 5X, 'DAXPYI ALTERED ARRAY X FOR TEST WITH NZ = ', I5,
     1             ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5 )
C
 1300 FORMAT ( 5X, 'DAXPYI ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5 )
C
 1400 FORMAT ( 5X, 'DAXPYI OUTPUT ARRAY Y IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INCORRECT COMPONENT NO. ', I5, ' HAS VALUE =', 
     4             1PD15.5,
     5             ' TRUE VALUE =', 1PD15.5 )
C
 1500 FORMAT ( 5X, 'DAXPYI OUTPUT ARRAY Y IS INACCURATE FOR TEST WITH ',
     1             'NZ = ', I5, ' A =', 1PD15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE =', 
     4             1PD15.5, ' TRUE VALUE =',
     5             1PD15.5, ' ERROR = ', 1PD12.1 )
C
 2700 FORMAT ( /5X, 'DAXPYI PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DAXPYI FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
      SUBROUTINE   TDDOTI   ( NOUT,   EPSILN, THRESH, NZMAX2, 
     1                        NUMNZ,  NZVALU, 
     2                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     3                        YTRUE , INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDDOTI  --  CERTIFY  DDOTI                             ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDDOTI  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DDOTI.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*)
C
      DOUBLE PRECISION    EPSILN, THRESH
C
      DOUBLE PRECISION    X (*),       XSAVE (*),   XTRUE (*),
     1                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      INTEGER             COUNT,  I,      ICLOBR, J,      KINDX,
     1                    KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    ERR,    S,      T
C
      DOUBLE PRECISION    CLOBBR, V,      W
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME, DVSAME
C
      DOUBLE PRECISION    DDOTI
C
      EXTERNAL            ICOPY,  DCOPY,  DINIT,  GNINDX,
     1                    IVSAME, DVSAME, DDOTI
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6*DBLE(I) )
         YSAVE(I) = SIN ( .7*DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 600 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -------------------------------
C         ... FOR EACH KIND OF INDX ARRAY
C         -------------------------------
C
          DO 500 KINDX = 1, 5
C
              CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
C             -----------------------
C             ... GENERATE INPUT DATA
C             -----------------------
C
              I = MIN ( N, N-NZTRUE )
              J = N - I + 1
              CALL DCOPY ( NZTRUE, XSAVE,  1, XTRUE, 1 )
              CALL DINIT ( I,      CLOBBR, XTRUE(J), 1 )
              CALL DINIT ( N,      CLOBBR, YTRUE, 1 )
C
              DO 200 I = 1, NZTRUE
                  YTRUE (INDXT(I)) = YSAVE (INDXT(I))
  200         CONTINUE
C
C             -------------------
C             ... COPY TRUE INPUT
C             -------------------
C
              NZ = NZTRUE
C
              CALL DCOPY ( N, YTRUE, 1, Y, 1 )
              CALL DCOPY ( N, XTRUE, 1, X, 1 )
              CALL ICOPY ( N, INDXT, 1, INDX, 1 )
C
C             --------------------------
C             ... COMPUTE IN-LINE RESULT
C             --------------------------
C
              V = 0.0D0
C
              DO 300 I = 1, NZTRUE
                  V = V +  XTRUE(I) * YTRUE (INDXT(I))
  300         CONTINUE
C
C             --------------
C             ... CALL DDOTI
C             --------------
C
              W = DDOTI ( NZ, X, INDX, Y )
C
C             ----------------------------------------
C             ... TEST ARGUMENTS OF DDOTI THAT ARE NOT
C                     SUPPOSE TO CHANGE.
C             ----------------------------------------
C
              IF  ( NZ .NE. NZTRUE )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1000 ) NZTRUE, KINDX, NZ
                  END IF
              END IF
C
              IF  ( .NOT. DVSAME ( N, X, XTRUE ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1100 ) NZTRUE, KINDX
                  END IF
              END IF
C
              IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1200 ) NZTRUE, KINDX
                  END IF
              END IF
C
              IF  ( .NOT. DVSAME ( N, Y, YTRUE ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1300 ) NZTRUE, KINDX
                  END IF
              END IF
C
C             --------------------------
C             ... TEST OUTPUT FROM DDOTI
C             --------------------------
C
              S = ABS ( V - W )
C
              T = 0.0D0
              DO 400 I = 1, NZTRUE
                  T = T + ABS ( XTRUE(I) * YTRUE (INDXT(I)) )
  400         CONTINUE
C
              IF  ( T .EQ. 0.0D0 )  T = 1.0D0
C
              ERR = S / ( EPSILN * T )
C
              IF  ( ERR .GT. THRESH )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1400 ) NZTRUE, KINDX, 
     1                                     W, V, ERR
                  END IF
              END IF
C
  500     CONTINUE
C     
  600 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDDOTI
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DDOTI ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5,
     2             '.  ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DDOTI ALTERED ARRAY X FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1200 FORMAT ( 5X, 'DDOTI ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1300 FORMAT ( 5X, 'DDOTI ALTERED ARRAY Y FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1400 FORMAT ( 5X, 'DDOTI OUTPUT W IS INACCURATE FOR TEST WITH ',
     1             'NZ = ', I5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'DDOTI HAS VALUE =', 1PD15.5,
     3             ' TRUE VALUE =', 1PD15.5,
     4             ' ERROR = ', 1PD12.1 )
C
 2700 FORMAT ( /5X, 'DDOTI  PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DDOTI  FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
      SUBROUTINE   TDGTHR   ( NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     2                        YTRUE , INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDGTHR  --  CERTIFY  DGTHR                              ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDGTHR  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DGTHR.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*)
C
      DOUBLE PRECISION    X (*),       XSAVE (*),   XTRUE (*),
     1                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      INTEGER             COUNT,  I,      ICLOBR, KINDX,
     1                    KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    CLOBBR   
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME, DVSAME
C
      EXTERNAL            ICOPY,  DCOPY,  DINIT,  GNINDX,
     1                    IVSAME, DVSAME, DGTHR
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6*DBLE(I) )
         YSAVE(I) = SIN ( .7*DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 600 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -------------------------------
C         ... FOR EACH KIND OF INDX ARRAY
C         -------------------------------
C
          DO 500 KINDX = 1, 5
C
              CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
C             -----------------------
C             ... GENERATE INPUT DATA
C             -----------------------
C
              CALL DINIT ( N, CLOBBR, XTRUE, 1 )
              CALL DINIT ( N, CLOBBR, YTRUE, 1 )
C
              DO 200 I = 1, NZTRUE
                  YTRUE (INDXT(I)) = YSAVE (INDXT(I))
  200         CONTINUE
C
C             -------------------
C             ... COPY TRUE INPUT
C             -------------------
C
              NZ = NZTRUE
C
              CALL DCOPY ( N, YTRUE, 1, Y, 1 )
              CALL DCOPY ( N, XTRUE, 1, X, 1 )
              CALL ICOPY ( N, INDXT, 1, INDX, 1 )
C         
C             --------------------------
C             ... COMPUTE IN-LINE RESULT
C             --------------------------
C
              DO 300 I = 1, NZTRUE
                  XTRUE (I) = YTRUE (INDXT(I))
  300         CONTINUE
C
C             --------------
C             ... CALL DGTHR
C             --------------
C
              CALL DGTHR ( NZ, Y, X, INDX )
C
C             ----------------------------------------
C             ... TEST ARGUMENTS OF DGTHR THAT ARE NOT
C                 SUPPOSE TO CHANGE.
C             ----------------------------------------
C
              IF  ( NZ .NE. NZTRUE )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1000 ) NZTRUE, KINDX, NZ
                  END IF
              END IF
C
              IF  ( .NOT. DVSAME ( N, Y, YTRUE ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1100 ) NZTRUE, KINDX
                  END IF
              END IF
C
              IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1200 ) NZTRUE, KINDX
                  END IF
              END IF
C
C             --------------------------
C             ... TEST OUTPUT FROM DGTHR
C             --------------------------
C
              DO 400 I = 1, N
                  IF  ( X(I) .NE. XTRUE(I) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1300 ) NZTRUE, KINDX, I, 
     1                                         X(I), XTRUE(I)
                      END IF
                  END IF
  400         CONTINUE
C
  500     CONTINUE
C     
  600 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDGTHR
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DGTHR ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5,
     2             '.  ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DGTHR ALTERED ARRAY Y FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1200 FORMAT ( 5X, 'DGTHR ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1300 FORMAT ( 5X, 'DGTHR OUTPUT ARRAY X IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE =', 
     3             1PD15.5, ' TRUE VALUE = ', 1PD15.5 )
C
 2700 FORMAT ( /5X, 'DGTHR  PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DGTHR  FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
      SUBROUTINE   TDGTHZ   ( NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     2                        YTRUE , INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDGTHZ  --  CERTIFY  DGTHRZ                             ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDGTHZ  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DGTHRZ.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*)
C
      DOUBLE PRECISION    X (*),       XSAVE (*),   XTRUE (*),
     1                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      INTEGER             COUNT,  I,      ICLOBR, KINDX,
     1                    KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    CLOBBR   
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME, DVSAME
C
      EXTERNAL            ICOPY,  DCOPY,  DINIT,  GNINDX,
     1                    IVSAME, DVSAME, DGTHRZ
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6*DBLE(I) )
         YSAVE(I) = SIN ( .7*DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 600 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -------------------------------
C         ... FOR EACH KIND OF INDX ARRAY
C         -------------------------------
C
          DO 500 KINDX = 1, 5
C
              CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
C             -----------------------
C             ... GENERATE INPUT DATA
C             -----------------------
C
              CALL DINIT ( N, CLOBBR, XTRUE, 1 )
              CALL DINIT ( N, CLOBBR, YTRUE, 1 )
C
              DO 200 I = 1, NZTRUE
                  YTRUE (INDXT(I)) = YSAVE (INDXT(I))
  200         CONTINUE
C
C             -------------------
C             ... COPY TRUE INPUT
C             -------------------
C
              NZ = NZTRUE
C
              CALL DCOPY ( N, YTRUE, 1, Y, 1 )
              CALL DCOPY ( N, XTRUE, 1, X, 1 )
              CALL ICOPY ( N, INDXT, 1, INDX, 1 )
C         
C             --------------------------
C             ... COMPUTE IN-LINE RESULT
C             --------------------------
C
              DO 300 I = 1, NZTRUE
                  XTRUE (I) = YTRUE (INDXT(I))
                  YTRUE(INDXT(I)) = 0.0D0
  300         CONTINUE
C
C             ---------------
C             ... CALL DGTHRZ
C             ---------------
C
              CALL DGTHRZ ( NZ, Y, X, INDX )
C
C             -----------------------------------------
C             ... TEST ARGUMENTS OF DGTHRZ THAT ARE NOT
C                 SUPPOSE TO CHANGE.
C             -----------------------------------------
C
              IF  ( NZ .NE. NZTRUE )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1000 ) NZTRUE, KINDX, NZ
                  END IF
              END IF
C
              IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1100 ) NZTRUE, KINDX
                  END IF
              END IF
C
C             ---------------------------
C             ... TEST OUTPUT FROM DGTHRZ
C             ---------------------------
C
              DO 400 I = 1, N
C
                  IF  ( X(I) .NE. XTRUE(I) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1200 ) NZTRUE, KINDX, I, 
     1                                         X(I), XTRUE(I)
                      END IF
                  END IF
C
                  IF  ( Y(I) .NE. YTRUE(I) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1300 ) NZTRUE, KINDX, I, 
     1                                         Y(I), YTRUE(I)
                      END IF
                  END IF
C
  400         CONTINUE
C
  500     CONTINUE
C     
  600 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDGTHZ
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DGTHRZ ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5,
     2             '.  ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DGTHRZ ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1200 FORMAT ( 5X, 'DGTHRZ OUTPUT ARRAY X IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE =', 
     3             1PD15.5, ' TRUE VALUE =', 1PD15.5 )
C
 1300 FORMAT ( 5X, 'DGTHRZ OUTPUT ARRAY Y IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE =', 
     3             1PD15.5, ' TRUE VALUE =', 1PD15.5 )
C
 2700 FORMAT ( /5X, 'DGTHRZ PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DGTHRZ FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
      SUBROUTINE   TDROTI   ( NOUT,   EPSILN, THRESH, NZMAX2, 
     1                        NUMNZ,  NZVALU, NUMG,   CVALUE, SVALUE,
     2                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     3                        YTRUE , INDX,   INDXT,  LIST,   ERRCNT, 
     4                        ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDROTI  --  CERTIFY  DROTI                              ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDROTI  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DROTI.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  NUMG,   ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*),
     1                    LIST (*)
C
      DOUBLE PRECISION    EPSILN, THRESH
C
      DOUBLE PRECISION    CVALUE (*),  SVALUE (*),
     1                    X (*),       XSAVE (*),   XTRUE (*),
     2                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      INTEGER             COUNT,  I,      ICLOBR, J,      KG,
     1                    KINDX,  KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    C,      CLOBBR, CTRUE,  ERR,    S,     
     1                    STRUE,  V,      W
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME
C
      EXTERNAL            DCOPY,  DINIT,  ICOPY,  IINIT,  GNINDX,
     1                    IVSAME, DROTI
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6D0 * DBLE(I) )
         YSAVE(I) = SIN ( .7D0 * DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 700 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -----------------------------
C         ... FOR EACH VALUE OF C AND S
C         -----------------------------
C
          DO 600 KG = 1, NUMG
C
              CTRUE = CVALUE(KG)
              STRUE = SVALUE(KG)
C
C             -------------------------------
C             ... FOR EACH KIND OF INDX ARRAY
C             -------------------------------
C
              DO 500 KINDX = 1, 5
C
                  CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
                  CALL IINIT ( N, -1, LIST, 1 )
C
                  DO 150 I = 1, NZTRUE
                      LIST (INDXT(I)) = I
  150             CONTINUE
C
C                 -----------------------
C                 ... GENERATE INPUT DATA
C                 -----------------------
C
                  I = MIN ( N, N-NZTRUE )
                  J = N - I + 1
                  CALL DCOPY ( NZTRUE, XSAVE,  1, XTRUE, 1 )
                  CALL DINIT ( I,      CLOBBR, XTRUE(J), 1 )
                  CALL DINIT ( N,      CLOBBR, YTRUE   , 1 )
C
                  DO 200 I = 1, NZTRUE
                      YTRUE (INDXT(I)) = YSAVE (INDXT(I))
  200             CONTINUE
C
C                 -------------------
C                 ... COPY TRUE INPUT
C                 -------------------
C
                  C  = CTRUE
                  S  = STRUE
                  NZ = NZTRUE
C
                  CALL DCOPY ( N, YTRUE, 1, Y, 1 )
                  CALL DCOPY ( N, XTRUE, 1, X, 1 )
                  CALL ICOPY ( N, INDXT, 1, INDX, 1  )
C
C                 --------------------------
C                 ... COMPUTE IN-LINE RESULT
C                 --------------------------
C
                  DO 300 I = 1, NZTRUE
                      V                = XTRUE(I)
                      XTRUE(I)         =  CTRUE * V  + 
     1                                    STRUE * YTRUE (INDXT(I))
                      YTRUE (INDXT(I)) = -STRUE * V  + 
     1                                    CTRUE * YTRUE (INDXT(I))
  300             CONTINUE
C
C                 --------------
C                 ... CALL DROTI
C                 --------------
C
                  CALL DROTI ( NZ, X, INDX, Y, C, S )
C
C                 ----------------------------------------
C                 ... TEST ARGUMENTS OF DROTI THAT ARE NOT
C                     SUPPOSE TO CHANGE.
C                 ----------------------------------------
C
                  IF  ( NZ .NE. NZTRUE )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1000 ) NZTRUE, CTRUE, STRUE, 
     1                                         KINDX,  NZ
                      END IF
                  END IF
C
                  IF  ( C .NE. CTRUE )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1100 ) NZTRUE, CTRUE, STRUE,
     1                                         KINDX,  C,     S
                      END IF
                  END IF
C
                  IF  ( S .NE. STRUE )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1200 ) NZTRUE, CTRUE, STRUE,
     1                                         KINDX,  C,     S
                      END IF
                  END IF
C
                  IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1300 ) NZTRUE, CTRUE, STRUE, 
     1                                         KINDX
                      END IF
                  END IF
C
C                 --------------------------
C                 ... TEST OUTPUT FROM DROTI
C                 --------------------------
C
                  DO 400 J = 1, N
C
                      IF  ( LIST(J) .EQ. -1 )  THEN 
C
C   This part is commented because it is incorrect
C   X vector checking is in the next part ( when LIST(J) .NE. -1 )
C  
C                          IF  ( X(J) .NE. XTRUE(J) )  THEN
C                              COUNT = COUNT + 1
C                              IF  ( COUNT .LE. ERRMAX )  THEN 
C                                  WRITE ( NOUT, 1400 ) NZTRUE, CTRUE, 
C     1                                                 STRUE, KINDX, J, 
C     2                                                 X(J), XTRUE(J)
C                              END IF
C                          END IF
C
                          IF  ( Y(J) .NE. YTRUE(J) )  THEN
                              COUNT = COUNT + 1
                              IF  ( COUNT .LE. ERRMAX )  THEN 
                                  WRITE ( NOUT, 1500 ) NZTRUE, CTRUE, 
     1                                                 STRUE, KINDX, J, 
     2                                                 Y(J), YTRUE(J)
                              END IF
                          END IF
C
                      ELSE
C
                          V = ABS ( X (LIST(J)) - XTRUE (LIST(J)) )
                          W = ABS ( CTRUE ) * ABS ( XSAVE (LIST(J)) )  +
     1                        ABS ( STRUE ) * ABS ( YSAVE(J) )
                          IF  ( W .EQ. 0.0D0 )  W = 1.0D0
                          ERR = V / ( EPSILN * W )
                          IF  ( ERR .GT. THRESH )  THEN
                              COUNT = COUNT + 1
                              IF  ( COUNT .LE. ERRMAX )  THEN 
                                  WRITE ( NOUT, 1600 ) NZTRUE, CTRUE, 
     1                                                 STRUE, KINDX, I,
     2                                                 X (LIST(J)), 
     3                                                 XTRUE (LIST(J)), 
     4                                                 ERR
                              END IF
                          END IF
C
                          V = ABS ( Y(J) - YTRUE(J) )
                          W = ABS ( STRUE ) * ABS ( XSAVE (LIST(J)) )  +
     1                        ABS ( CTRUE ) * ABS ( YSAVE(J) )
                          IF  ( W .EQ. 0.0D0 )  W = 1.0D0
                          ERR = V / ( EPSILN * W )
                          IF  ( ERR .GT. THRESH )  THEN
                              COUNT = COUNT + 1
                              IF  ( COUNT .LE. ERRMAX )  THEN 
                                  WRITE ( NOUT, 1700 ) NZTRUE, CTRUE, 
     1                                                 STRUE, KINDX, J,
     2                                                 Y(J), YTRUE(J), 
     3                                                 ERR
                              END IF
                          END IF
C
                      END IF
C
  400             CONTINUE
C
  500         CONTINUE
C
  600     CONTINUE
C
  700 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDROTI
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DROTI ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' C, S = ', 1P, 2D15.5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DROTI ALTERED C FOR TEST WITH NZ = ', I5,
     1             ' C, S = ', 1P, 2D15.5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'ALTERED VALUE OF C = ', 1PD15.5 )
C
 1200 FORMAT ( 5X, 'DROTI ALTERED S FOR TEST WITH NZ = ', I5,
     1             ' C, S = ', 1P, 2D15.5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'ALTERED VALUE OF S = ', 1PD15.5 )
C
 1300 FORMAT ( 5X, 'DROTI ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' C, S = ', 1P, 2D15.5, ' AND THE INDX TYPE NO. ', 
     2             I5 )
C
 1400 FORMAT ( 5X, 'DROTI OUTPUT ARRAY X IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' C, S = ', 1P, 2D15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INCORRECT COMPONENT NO. ', I5, ' HAS VALUE = ', 
     4             1PD15.5, ' TRUE VALUE = ', 1PD15.5 )
C
 1500 FORMAT ( 5X, 'DROTI OUTPUT ARRAY Y IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' C, S = ', 1P, 2D15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INCORRECT COMPONENT NO. ', I5, ' HAS VALUE = ', 
     4             1PD15.5, ' TRUE VALUE = ', 1PD15.5 )
C
 1600 FORMAT ( 5X, 'DROTI OUTPUT ARRAY X IS INACCURATE FOR TEST WITH ',
     1             'NZ = ', I5, ' C, S = ', 1P, 2D15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE = ', 
     4             1PD15.5, ' TRUE VALUE = ', 1PD15.5, ' ERROR = ', 
     5             1PD12.1 )
C
 1700 FORMAT ( 5X, 'DROTI OUTPUT ARRAY Y IS INACCURATE FOR TEST WITH ',
     1             'NZ = ', I5, ' C, S = ', 1P, 2D15.5,
     2             ' AND THE INDX TYPE NO. ', I5
     3        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE = ', 
     4             1PD15.5, ' TRUE VALUE = ', 1PD15.5, ' ERROR = ', 
     5             1PD12.1 )
C
 2700 FORMAT ( /5X, 'DROTI  PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DROTI  FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
      SUBROUTINE   TDSCTR   ( NOUT,   NZMAX2, NUMNZ,  NZVALU, 
     1                        X,      XSAVE,  XTRUE,  Y,      YSAVE, 
     2                        YTRUE , INDX,   INDXT,  ERRCNT, ERRMAX )
C
C     ==================================================================
C     ==================================================================
C     ====  TDSCTR  --  CERTIFY  DSCTR                              ====
C     ==================================================================
C     ==================================================================
C
C     SUBROUTINE  TDSCTR  IS THE CERTIFICATION MODULE FOR THE SPARSE
C     BASIC LINEAR ALGEBRA SUBROUTINE MODULE  DSCTR.
C
C     WRITTEN BY      ROGER G GRIMES
C                     APRIL 1987
C
C     ==================================================================
C
C     -------------
C     ... ARGUMENTS
C     -------------
C
      INTEGER             NOUT,   NZMAX2, NUMNZ,  ERRCNT,
     1                    ERRMAX
C
      INTEGER             NZVALU (*),  INDX (*),    INDXT (*)
C
      DOUBLE PRECISION    X (*),       XSAVE (*),   XTRUE (*),
     1                    Y (*),       YSAVE (*),   YTRUE (*)
C
C     -------------------
C     ... LOCAL VARIABLES
C     -------------------
C
      INTEGER             COUNT,  I,      ICLOBR, J,      KINDX,
     1                    KNZ,    N,      NZ,     NZTRUE
C
      DOUBLE PRECISION    CLOBBR   
C
C     --------------------
C     ... SUBPROGRAMS USED
C     --------------------
C
      LOGICAL             IVSAME, DVSAME
C
      EXTERNAL            ICOPY,  DCOPY,  DINIT,  GNINDX,
     1                    IVSAME, DVSAME, DSCTR
C
C     ==================================================================
C
C     ------------------
C     ... INITIALIZATION
C     ------------------
C
      COUNT     =   0
C
      CLOBBR    =   -1.0D10
      ICLOBR    =   -10000000
C
C     ------------------------------------
C     ... GENERATE SOME VALUES FOR X AND Y
C     ------------------------------------
C
      DO 100 I = 1, NZMAX2
         XSAVE(I) = COS ( .6*DBLE(I) )
         YSAVE(I) = SIN ( .7*DBLE(I) )
  100 CONTINUE
C
C     ------------------------
C     ... FOR EACH VALUE OF NZ
C     ------------------------
C
      DO 600 KNZ = 1, NUMNZ
C
          NZTRUE = NZVALU(KNZ)
          N      = 2 * MAX ( NZTRUE, 1 )
C
C         -------------------------------
C         ... FOR EACH KIND OF INDX ARRAY
C         -------------------------------
C
          DO 500 KINDX = 1, 5
C
              CALL GNINDX ( NZTRUE, N, ICLOBR, KINDX, INDXT )
C
C             -----------------------
C             ... GENERATE INPUT DATA
C             -----------------------
C
              I = MIN ( N, N-NZTRUE )
              J = N - I + 1
              CALL DCOPY ( NZTRUE, XSAVE,  1, XTRUE, 1 )
              CALL DINIT ( I,      CLOBBR, XTRUE(J), 1 )
              CALL DINIT ( N,      CLOBBR, YTRUE, 1 )
C
C             -------------------
C             ... COPY TRUE INPUT
C             -------------------
C
              NZ = NZTRUE
C
              CALL DCOPY ( N, YTRUE, 1, Y, 1 )
              CALL DCOPY ( N, XTRUE, 1, X, 1 )
              CALL ICOPY ( N, INDXT, 1, INDX, 1 )
C         
C             --------------------------
C             ... COMPUTE IN-LINE RESULT
C             --------------------------
C
              DO 300 I = 1, NZTRUE
                  YTRUE (INDXT(I)) = XTRUE (I)
  300         CONTINUE
C
C             --------------
C             ... CALL DSCTR
C             --------------
C
              CALL DSCTR ( NZ, X, INDX, Y )
C
C             ----------------------------------------
C             ... TEST ARGUMENTS OF DSCTR THAT ARE NOT
C                 SUPPOSE TO CHANGE.
C             ----------------------------------------
C
              IF  ( NZ .NE. NZTRUE )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1000 ) NZTRUE, KINDX, NZ
                  END IF
              END IF
C                                          
              IF  ( .NOT. DVSAME ( N, X, XTRUE ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1100 ) NZTRUE, KINDX
                  END IF
              END IF
C
              IF  ( .NOT. IVSAME ( N, INDX, INDXT ) )  THEN
                  COUNT = COUNT + 1
                  IF  ( COUNT .LE. ERRMAX )  THEN 
                      WRITE ( NOUT, 1200 ) NZTRUE, KINDX
                  END IF
              END IF
C
C             --------------------------
C             ... TEST OUTPUT FROM DSCTR
C             --------------------------
C
              DO 400 I = 1, N
                  IF  ( Y(I) .NE. YTRUE(I) )  THEN
                      COUNT = COUNT + 1
                      IF  ( COUNT .LE. ERRMAX )  THEN 
                          WRITE ( NOUT, 1300 ) NZTRUE, KINDX, I, 
     1                                         Y(I), YTRUE(I)
                      END IF
                  END IF
  400         CONTINUE
C
  500     CONTINUE
C     
  600 CONTINUE
C
C     ==================================================================
C
C     ------------------
C     ... END OF TESTING
C     ------------------
C
      ERRCNT = ERRCNT + COUNT
      IF  ( COUNT .NE. 0 )  GO TO 800
C
C     -----------------------------------
C     ... WRITE PASSED MESSAGE AND RETURN
C     -----------------------------------
C
      WRITE ( NOUT, 2700 )
      GO TO 900
C
C     -----------------------------------
C     ... WRITE FAILED MESSAGE AND RETURN
C     -----------------------------------
C
  800 WRITE ( NOUT, 2800 ) COUNT
C
C     ------------------------
C     ... END OF MODULE TDSCTR
C     ------------------------
C
  900 CONTINUE
      RETURN
C
C     ==================================================================
C
C     -----------
C     ... FORMATS
C     -----------
C
 1000 FORMAT ( 5X, 'DSCTR ALTERED NZ FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5,
     2             '.  ALTERED VALUE OF NZ = ', I5 )
C
 1100 FORMAT ( 5X, 'DSCTR ALTERED ARRAY X FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1200 FORMAT ( 5X, 'DSCTR ALTERED ARRAY INDX FOR TEST WITH NZ = ', I5,
     1             ' AND THE INDX TYPE NO. ', I5 )
C
 1300 FORMAT ( 5X, 'DSCTR OUTPUT ARRAY Y IS INCORRECT FOR TEST WITH ',
     1             'NZ = ', I5, ' AND THE INDX TYPE NO. ', I5
     2        /5X, 'INACCURATE COMPONENT NO. ', I5, ' HAS VALUE =', 
     3             1PD15.5, ' TRUE VALUE =', 1PD15.5 )
C
 2700 FORMAT ( /5X, 'DSCTR  PASSED ALL TESTS.' ) 
C
 2800 FORMAT ( /5X, 'DSCTR  FAILED', I10, ' TESTS.'  )
C
C     ==================================================================
C
      END
