*     SSPRFS (F07PHE) Example Program Text
*     Mark 15 Release. NAG Copyright 1991.
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        (NIN=5,NOUT=6)
      INTEGER          NMAX, NRHMAX, LDB, LDX
      PARAMETER        (NMAX=8,NRHMAX=NMAX,LDB=NMAX,LDX=NMAX)
*     .. Local Scalars ..
      INTEGER          I, IFAIL, INFO, J, N, NRHS
      CHARACTER        UPLO
*     .. Local Arrays ..
      REAL             AFP(NMAX*(NMAX+1)/2), AP(NMAX*(NMAX+1)/2),
     +                 B(LDB,NRHMAX), BERR(NRHMAX), FERR(NRHMAX),
     +                 WORK(3*NMAX), X(LDX,NMAX)
      INTEGER          IPIV(NMAX), IWORK(NMAX)
*     .. External Subroutines ..
      EXTERNAL         F06QFE, SSPRFS, SSPTRF, SSPTRS, X04CAE
*     .. Executable Statements ..
      WRITE (NOUT,*) 'SSPRFS Example Program Results'
*     Skip heading in data file
      READ (NIN,*)
      READ (NIN,*) N, NRHS
      IF (N.LE.NMAX .AND. NRHS.LE.NRHMAX) THEN
*
*        Read A and B from data file, and copy A to AFP and B to X
*
         READ (NIN,*) UPLO
         IF (UPLO.EQ.'U') THEN
            READ (NIN,*) ((AP(I+J*(J-1)/2),J=I,N),I=1,N)
         ELSE IF (UPLO.EQ.'L') THEN
            READ (NIN,*) ((AP(I+(2*N-J)*(J-1)/2),J=1,I),I=1,N)
         END IF
         READ (NIN,*) ((B(I,J),J=1,NRHS),I=1,N)
         DO 20 I = 1, N*(N+1)/2
            AFP(I) = AP(I)
   20    CONTINUE
*
         CALL F06QFE('General',N,NRHS,B,LDB,X,LDX)
*
*        Factorize A in the array AFP
*
         CALL SSPTRF(UPLO,N,AFP,IPIV,INFO)
*
         WRITE (NOUT,*)
         IF (INFO.EQ.0) THEN
*
*           Compute solution in the array X
*
            CALL SSPTRS(UPLO,N,NRHS,AFP,IPIV,X,LDX,INFO)
*
*           Improve solution, and compute backward errors and
*           estimated bounds on the forward errors
*
            CALL SSPRFS(UPLO,N,NRHS,AP,AFP,IPIV,B,LDB,X,LDX,FERR,BERR,
     +                  WORK,IWORK,INFO)
*
*           Print solution
*
            IFAIL = 0
*
            CALL X04CAE('General',' ',N,NRHS,X,LDX,'Solution(s)',IFAIL)
*
            WRITE (NOUT,*)
            WRITE (NOUT,*) 'Backward errors (machine-dependent)'
            WRITE (NOUT,99999) (BERR(J),J=1,NRHS)
            WRITE (NOUT,*)
     +        'Estimated forward error bounds (machine-dependent)'
            WRITE (NOUT,99999) (FERR(J),J=1,NRHS)
         ELSE
            WRITE (NOUT,*) 'The factor D is singular'
         END IF
      END IF
      STOP
*
99999 FORMAT ((3X,1P,7E11.1))
      END