!*******************************************************************************
!                             INTEL CONFIDENTIAL
!   Copyright(C) 2006-2008 Intel Corporation. All Rights Reserved.
!   The source code contained  or  described herein and all documents related to
!   the source code ("Material") are owned by Intel Corporation or its suppliers
!   or licensors.  Title to the  Material remains with  Intel Corporation or its
!   suppliers and licensors. The Material contains trade secrets and proprietary
!   and  confidential  information of  Intel or its suppliers and licensors. The
!   Material  is  protected  by  worldwide  copyright  and trade secret laws and
!   treaty  provisions. No part of the Material may be used, copied, reproduced,
!   modified, published, uploaded, posted, transmitted, distributed or disclosed
!   in any way without Intel's prior express written permission.
!   No license  under any  patent, copyright, trade secret or other intellectual
!   property right is granted to or conferred upon you by disclosure or delivery
!   of the Materials,  either expressly, by implication, inducement, estoppel or
!   otherwise.  Any  license  under  such  intellectual property  rights must be
!   express and approved by Intel in writing.
!
!*******************************************************************************
!   Content:
!          MKL DFTI implementation through FFTW interface (via wrappers) example
!          program (Fortran-interface)
!
!   Real-to-complex and complex-to-real 3D transform for REAL*8 and COMPLEX*16
!   data not inplace.
!
!   Configuration parameters for MKL DFTI:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL             (obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE (obligatory)
!           DFTI_DIMENSION      = 1                        (obligatory)
!           DFTI_LENGTHS        = N                        (obligatory)
!           DFTI_PLACEMENT      = DFTI_OUTOFPLACE          (default)
!           DFTI_FORWARD_SCALE  = 1.0                      (default)
!           DFTI_BACKWARD_SCALE = 1.0/N                    (default=1.0)
!
!  Other default configuration parameters are in the mkl_dfti.f90 interface file
!******************************************************************************/

      PROGRAM REAL_3D_DOUBLE_EX2

      INCLUDE 'fftw_f77.i'
      INCLUDE 'mkl_fftw_examples.fi'

      INTEGER N,M,L,OUT_N,I,J,K
      PARAMETER (L=3)
      PARAMETER (M=10)
      PARAMETER (N=15)
      PARAMETER (OUT_N=N/2+1)
      INTEGER*8 FFTW_PLAN

      REAL*8 IN(N,M,L),EXP_X(N,M,L)
      COMPLEX*16 OUT(OUT_N,M,L)
      REAL*8 ERR,SCALE

!
!     Initialize IN and copy to expected EXP_X
!
      PRINT*,' Initialize data array'
      DO K=1,L
        DO J=1,M
          DO I=1,N
            IN(I,J,K)=DSIN(DFLOAT(I*J*K))
            EXP_X(I,J,K)=IN(I,J,K)
          END DO
        END DO
      END DO

!
!     Create FFTW plan for 3D real to complex transform
!
      PRINT*,' Create FFTW plan for 3D real to complex transform'
      CALL RFFTW3D_F77_CREATE_PLAN(FFTW_PLAN,N,M,L,FFTW_REAL_TO_COMPLEX,
     *FFTW_ESTIMATE)

!
!     Compute 3D real to complex transform
!
      PRINT*,' Compute 3D real to complex transform'
      CALL RFFTWND_F77_ONE_REAL_TO_COMPLEX(FFTW_PLAN,IN,OUT)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL RFFTWND_F77_DESTROY_PLAN(FFTW_PLAN)

!
!     Create FFTW plan for 3D complex to real transform
!
      PRINT*,' Create FFTW plan for 3D complex to real transform'
      CALL RFFTW3D_F77_CREATE_PLAN(FFTW_PLAN,N,M,L,FFTW_COMPLEX_TO_REAL,
     *FFTW_ESTIMATE)

!
!     Compute 3D complex to real transform
!
      PRINT*,' Compute 3D complex to real transform'
      CALL RFFTWND_F77_ONE_COMPLEX_TO_REAL(FFTW_PLAN,OUT,IN)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL RFFTWND_F77_DESTROY_PLAN(FFTW_PLAN)

!
!     Scale result. FFTW can't do this itself.
!
      PRINT*,' Scale result by 1/(N*M*L)'
      SCALE=1.0D0/(N*M*L)
      DO K=1,L
        DO J=1,M
          DO I=1,N
            IN(I,J,K)=SCALE*IN(I,J,K)
          END DO
        END DO
      END DO

!
!     Check results
!
      PRINT*,' Check results'
      CALL CHECK_RESULT_D(IN,EXP_X,N*M*L,ERR)
      PRINT*,' Accuracy=',ERR
      IF (ERR.GT.MAX_DOUBLE_ERR) THEN
       PRINT*,' TEST FAIL'
       GOTO 100
      END IF
      PRINT*,' TEST PASSED'

100   CONTINUE

      END PROGRAM