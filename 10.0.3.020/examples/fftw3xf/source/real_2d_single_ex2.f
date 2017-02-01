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
!   Real-to-complex and complex-to-real 2D transform for REAL*4 and COMPLEX*8
!   data not inplace.
!
!   Configuration parameters for MKL DFTI:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL             (obligatory)
!           DFTI_PRECISION      = DFTI_SINGLE  (obligatory)
!           DFTI_DIMENSION      = 1                        (obligatory)
!           DFTI_LENGTHS        = N                        (obligatory)
!           DFTI_PLACEMENT      = DFTI_OUTOFPLACE          (default)
!           DFTI_FORWARD_SCALE  = 1.0                      (default)
!           DFTI_BACKWARD_SCALE = 1.0/N                    (default=1.0)
!
!  Other default configuration parameters are in the mkl_dfti.f90 interface file
!******************************************************************************/

      PROGRAM REAL_2D_SINGLE_EX2

      INCLUDE 'fftw3.f'
      INCLUDE 'mkl_fftw_examples.fi'

      INTEGER N,M,OUT_N,I,J
      PARAMETER (M=10)
      PARAMETER (N=15)
      PARAMETER (OUT_N=N/2+1)
      INTEGER*8 FFTW_PLAN

      REAL*4 IN(N,M),EXP_X(N,M)
      COMPLEX*8 OUT(OUT_N,M)
      REAL*4 ERR,SCALE

!
!     Initialize IN and copy to expected EXP_X
!
      PRINT*,' Initialize data array'
      DO J=1,M
        DO I=1,N
         IN(I,J)=SIN(FLOAT(I*J))
         EXP_X(I,J)=IN(I,J)
        END DO
      END DO

!
!     Create FFTW plan for 2D real to complex transform
!
      PRINT*,' Create FFTW plan for 2D real to complex transform'
      CALL SFFTW_PLAN_DFT_R2C_2D(FFTW_PLAN,N,M,IN,OUT,FFTW_ESTIMATE)

!
!     Compute 2D real to complex transform
!
      PRINT*,' Compute 2D real to complex transform'
      CALL SFFTW_EXECUTE(FFTW_PLAN)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL SFFTW_DESTROY_PLAN(FFTW_PLAN)

!
!     Create FFTW plan for 2D complex to real transform
!
      PRINT*,' Create FFTW plan for 2D complex to real transform'
      CALL SFFTW_PLAN_DFT_C2R_2D(FFTW_PLAN,N,M,OUT,IN,FFTW_ESTIMATE)

!
!     Compute 2D complex to real transform
!
      PRINT*,' Compute 2D complex to real transform'
      CALL SFFTW_EXECUTE(FFTW_PLAN)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL SFFTW_DESTROY_PLAN(FFTW_PLAN)

!
!     Scale result. FFTW can't do this itself.
!
      PRINT*,' Scale result by 1/(N*M)'
      SCALE=1.0/(N*M)
      DO J=1,M
        DO I=1,N
         IN(I,J)=SCALE*IN(I,J)
        END DO
      END DO

!
!     Check results
!
      PRINT*,' Check results'
      CALL CHECK_RESULT_S(IN,EXP_X,N*M,ERR)
      PRINT*,' Accuracy=',ERR
      IF (ERR.GT.MAX_SINGLE_ERR) THEN
       PRINT*,' TEST FAIL'
       GOTO 100
      END IF
      PRINT*,' TEST PASSED'

100   CONTINUE

      END PROGRAM
