*     DORGQR (F08AFF) Example Program Text
*     Mark 16 Release. NAG Copyright 1992.
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        (NIN=5,NOUT=6)
      INTEGER          MMAX, NMAX, LDA, LWORK
      PARAMETER        (MMAX=8,NMAX=8,LDA=MMAX,LWORK=64*NMAX)
*     .. Local Scalars ..
      INTEGER          I, IFAIL, INFO, J, M, N
      CHARACTER*30     TITLE
*     .. Local Arrays ..
      DOUBLE PRECISION A(LDA,NMAX), TAU(NMAX), WORK(LWORK)
*     .. External Subroutines ..
      EXTERNAL         DGEQRF, DORGQR, X04CAF
*     .. Executable Statements ..
      WRITE (NOUT,*) 'DORGQR Example Program Results'
*     Skip heading in data file
      READ (NIN,*)
      READ (NIN,*) M, N
      IF (M.LE.MMAX .AND. N.LE.NMAX .AND. M.GE.N) THEN
*
*        Read A from data file
*
         READ (NIN,*) ((A(I,J),J=1,N),I=1,M)
*
*        Compute the QR factorization of A
*
         CALL DGEQRF(M,N,A,LDA,TAU,WORK,LWORK,INFO)
*
*        Form the leading N columns of Q explicitly
*
         CALL DORGQR(M,N,N,A,LDA,TAU,WORK,LWORK,INFO)
*
*        Print the leading N columns of Q only
*
         WRITE (NOUT,*)
         WRITE (TITLE,99999) N
         IFAIL = 0
*
         CALL X04CAF('General',' ',M,N,A,LDA,TITLE,IFAIL)
*
      END IF
      STOP
*
99999 FORMAT ('The leading ',I2,' columns of Q')
      END
