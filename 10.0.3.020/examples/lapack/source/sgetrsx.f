*     SGETRS (F07AEE) Example Program Text
*     Mark 15 Release. NAG Copyright 1991.
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        (NIN=5,NOUT=6)
      INTEGER          NMAX, LDA, NRHMAX, LDB
      PARAMETER        (NMAX=8,LDA=NMAX,NRHMAX=NMAX,LDB=NMAX)
      CHARACTER        TRANS
      PARAMETER        (TRANS='N')
*     .. Local Scalars ..
      INTEGER          I, IFAIL, INFO, J, N, NRHS
*     .. Local Arrays ..
      REAL             A(LDA,NMAX), B(LDB,NRHMAX)
      INTEGER          IPIV(NMAX)
*     .. External Subroutines ..
      EXTERNAL         SGETRF, SGETRS, X04CAE
*     .. Executable Statements ..
      WRITE (NOUT,*) 'SGETRS Example Program Results'
*     Skip heading in data file
      READ (NIN,*)
      READ (NIN,*) N, NRHS
      IF (N.LE.NMAX .AND. NRHS.LE.NRHMAX) THEN
*
*        Read A and B from data file
*
         READ (NIN,*) ((A(I,J),J=1,N),I=1,N)
         READ (NIN,*) ((B(I,J),J=1,NRHS),I=1,N)
*
*        Factorize A
*
         CALL SGETRF(N,N,A,LDA,IPIV,INFO)
*
         WRITE (NOUT,*)
         IF (INFO.EQ.0) THEN
*
*           Compute solution
*
            CALL SGETRS(TRANS,N,NRHS,A,LDA,IPIV,B,LDB,INFO)
*
*           Print solution
*
            IFAIL = 0
            CALL X04CAE('General',' ',N,NRHS,B,LDB,'Solution(s)',IFAIL)
         ELSE
            WRITE (NOUT,*) 'The factor U is singular'
         END IF
      END IF
      STOP
*
      END