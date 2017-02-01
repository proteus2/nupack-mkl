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
!   Real-to-complex and complex-to-real 1D transform for REAL*8 and COMPLEX*16
!   data in inplace with strides.
!
!   Configuration parameters for MKL DFTI:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL             (obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE              (obligatory)
!           DFTI_DIMENSION      = 1                        (obligatory)
!           DFTI_LENGTHS        = N                        (obligatory)
!           DFTI_PLACEMENT      = DFTI_INPLACE          (default)
!           DFTI_FORWARD_SCALE  = 1.0                      (default)
!           DFTI_BACKWARD_SCALE = 1.0/N                    (default=1.0)
!
!  Other default configuration parameters are in the mkl_dfti.f90 interface file
!******************************************************************************/

      PROGRAM REAL_1D_DOUBLE_EX7

      INCLUDE 'fftw_f77.i'
      INCLUDE 'mkl_fftw_examples.fi'

      INTEGER SIZE,N,RANK,OUT_N,IDIST,ODIST,ISTRIDE,OSTRIDE,HOWMANY,I
      INTEGER NTHREADS
      PARAMETER (RANK=1)
      PARAMETER (N=16)
      PARAMETER (OUT_N=N/2+1)
      PARAMETER (ISTRIDE=2)
      PARAMETER (IDIST=OUT_N*2*ISTRIDE)
      PARAMETER (HOWMANY=2)
      PARAMETER (SIZE=HOWMANY*IDIST)
      PARAMETER (NTHREADS=2)
      INTEGER*8 FFTW_PLAN

      REAL*8 IN(SIZE),EXP_X(SIZE)
      REAL*8 ERR,SCALE

!
!     Initialize IN and copy to expected EXP_X
!
      PRINT*,' Initialize data array'
      DO I=1,SIZE
        IN(I)=DSIN(DFLOAT(I))
        EXP_X(I)=IN(I)
      END DO

      CALL FFTW_F77_THREADS_INIT(STATUS)
!
!     Create FFTW plan for 1D real to complex transform
!
      PRINT*,' Create FFTW plan for 1D real to complex transform'
      CALL RFFTWND_F77_CREATE_PLAN(FFTW_PLAN,RANK,N,
     *FFTW_REAL_TO_COMPLEX,FFTW_ESTIMATE + FFTW_IN_PLACE)

      ODIST = IDIST/2

!
!     Compute 1D real to complex transform
!
      PRINT*,' Compute 1D real to complex transform'
      CALL RFFTWND_F77_THREADS_REAL_TO_COMPLEX(NTHREADS,FFTW_PLAN,
     *HOWMANY,IN,ISTRIDE,IDIST,IN,ISTRIDE,ODIST)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL RFFTWND_F77_DESTROY_PLAN(FFTW_PLAN)

!
!     Create FFTW plan for 1D complex to real transform
!
      PRINT*,' Create FFTW plan for 1D complex to real transform'
      CALL RFFTWND_F77_CREATE_PLAN(FFTW_PLAN,RANK,N,
     *FFTW_COMPLEX_TO_REAL,FFTW_ESTIMATE + FFTW_IN_PLACE)

!
!     Compute 1D complex to real transform
!
      PRINT*,' Compute 1D complex to real transform'
      CALL RFFTWND_F77_THREADS_COMPLEX_TO_REAL(NTHREADS,FFTW_PLAN,
     *HOWMANY,IN,ISTRIDE,ODIST,IN,ISTRIDE,IDIST)

!
!     Destroy FFTW plan
!
      PRINT*,' Destroy FFTW plan'
      CALL RFFTWND_F77_DESTROY_PLAN(FFTW_PLAN)

!
!     Scale result. FFTW can't do this itself.
!
      PRINT*,' Scale result by 1/N'
      SCALE=1.0D0/N
      CALL SCALE_WITH_STRIDES_D(IN,SCALE,HOWMANY,N,ISTRIDE,IDIST)

!
!     Check results
!
      PRINT*,' Check results'
      CALL CHECK_RESULT_MULTIPLE_D(IN,EXP_X,N,HOWMANY,
     *ISTRIDE,IDIST,ERR)
      PRINT*,' Accuracy=',ERR
      IF (ERR.GT.MAX_DOUBLE_ERR) THEN
       PRINT*,' TEST FAIL'
       GOTO 100
      END IF
      PRINT*,' TEST PASSED'

100   CONTINUE

      END PROGRAM
