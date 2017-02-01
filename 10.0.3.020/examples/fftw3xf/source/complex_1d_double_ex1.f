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
!   Complex-to-complex 1D transform for COMPLEX*16 data inplace.
!
!   Configuration parameters for MKL DFTI:
!           DFTI_FORWARD_DOMAIN = DFTI_COMPLEX             (obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE/DFTI_SINGLE  (obligatory)
!           DFTI_DIMENSION      = 1                        (obligatory)
!           DFTI_LENGTHS        = N                        (obligatory)
!           DFTI_PLACEMENT      = DFTI_OUTOFPLACE          (default)
!           DFTI_FORWARD_SCALE  = 1.0                      (default)
!           DFTI_BACKWARD_SCALE = 1.0/N                    (default=1.0)
!
!  Other default configuration parameters are in the mkl_dfti.f90 interface file
!******************************************************************************/

      PROGRAM COMPLEX_1D_DOUBLE_EX1

      INCLUDE 'fftw3.f'
      INCLUDE 'mkl_fftw_examples.fi'

      INTEGER N,I
      PARAMETER (N=10)
      INTEGER*8 FFTW_PLAN

      COMPLEX*16 IN(N),OUT(N),EXP_X(N)
      REAL*8 ERR,SCALE

!
!     Initialize IN and copy to expected EXP_X
!
      PRINT*,' Initialize data array'
      CALL INIT_COMPLEX_VECTOR_Z(IN,N)
      DO I=1,N
       EXP_X(I)=IN(I)
      END DO

!
!     Create FFTW plan for 1D forward transform
!
      PRINT*,' Create FFTW plan for 1D forward transform'
      CALL DFFTW_PLAN_DFT_1D(FFTW_PLAN, N, IN, IN, FFTW_FORWARD,
     $                       FFTW_ESTIMATE)

!
!     Compute Forward
!
      PRINT*,' Compute Forward'
      CALL DFFTW_EXECUTE(FFTW_PLAN)

      do I=1,N
          print *, 'Forward: IN(', I, ') = ', IN(I)
	end do
!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL DFFTW_DESTROY_PLAN(FFTW_PLAN)

!
!     Create FFTW plan for 1D backward transform
!
      PRINT*,' Create FFTW plan for 1D backward transform'
      CALL DFFTW_PLAN_DFT_1D(FFTW_PLAN, N, IN, IN, FFTW_BACKWARD,
     $                       FFTW_ESTIMATE)

!
!     Compute Backward
!
      PRINT*,' Compute Backward'
      CALL DFFTW_EXECUTE(FFTW_PLAN)

      do I=1,N
          print *, 'Backward: IN(', I, ') = ', IN(I)
	end do
!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL DFFTW_DESTROY_PLAN(FFTW_PLAN)

!
!     Scale result. FFTW can't do this itself.
!
      PRINT*,' Scale result by 1/N'
      SCALE=1.0D0/N
      DO I=1,N
       IN(I)=SCALE*IN(I)
      END DO

!
!     Check results
!
      PRINT*,' Check results'
      CALL CHECK_RESULT_Z(IN,EXP_X,N,ERR)
      PRINT*,' Accuracy=',ERR
      IF (ERR.GT.MAX_DOUBLE_ERR) THEN
       PRINT*,' TEST FAIL'
       GOTO 100
      END IF
      PRINT*,' TEST PASSED'

100   CONTINUE

      END PROGRAM
