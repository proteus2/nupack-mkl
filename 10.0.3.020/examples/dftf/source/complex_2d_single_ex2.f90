!*******************************************************************************
!                              INTEL CONFIDENTIAL
!   Copyright(C) 2003-2008 Intel Corporation. All Rights Reserved.
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
!       MKL DFTI interface example program (Fortran-interface)
!
!       Forward-Backward 2D complex transform for single precision data not inplace.
!
!*******************************************************************************
!   Configuration parameters:
!           DFTI_FORWARD_DOMAIN = DFTI_COMPLEX          (obligatory)
!           DFTI_PRECISION      = DFTI_SINGLE           (obligatory)
!           DFTI_DIMENSION      = 2                     (obligatory)
!           DFTI_LENGTHS        = { m, n}               (obligatory)
!           DFTI_PLACEMENT      = DFTI_NOT_INPLACE      (default= DFTI_INPLACE)
!           DFTI_INPUT_STRIDES  = {0, 1, M_MAX}         (default={0,1, m})
!           DFTI_OUTPUT_STRIDES = {0, 1, M_MAX}         (default={0,1, m})
!
!           DFTI_FORWARD_SCALE  = 1.0                   (default)
!           DFTI_BACKWARD_SCALE = 1.0/real(m*n)         (default=1.0)
!
!   Other default configuration parameters are in the mkl_dfti.f90 interface file
!*******************************************************************************

      Program COMPLEX_2D_SINGLE_EX2

      Use MKL_DFTI
      include 'mkl_dfti_examples.fi'

      integer    m, n

      complex :: X_IN_2D (M_MAX,N_MAX)
      complex :: X_OUT_2D(M_MAX,N_MAX)

      complex :: X_IN  (M_MAX*N_MAX)
      complex :: X_OUT (M_MAX*N_MAX)
      complex :: X_EXP (M_MAX*N_MAX)

      equivalence (X_IN,  X_IN_2D)
      equivalence (X_OUT, X_OUT_2D)

      type(DFTI_DESCRIPTOR), POINTER :: Desc_Handle
      integer   status
      real      Scale
      integer   lengths(2)
      integer   strides_in(3)
      integer   strides_out(3)

      real      maxerr
      real      eps
      parameter (eps=SINGLE_EPS)
      integer    i

!
!     Read input parameters from input file
!     m - size of transform  along first dimension
!     n - size of transform  along second dimension
!
      read*
      read*, m
      read*, n

!
!     Put transform parameters
!
      lengths(1) = m
      lengths(2) = n

      strides_in(1) = 0
      strides_in(2) = 1
      strides_in(3) = M_MAX

      strides_out(1) = 0
      strides_out(2) = 1
      strides_out(3) = M_MAX

      if(LEGEND_PRINT) then
          print*, 'COMPLEX_2D_SINGLE_EX2'
          print*, 'Forward-Backward 2D complex transform for single precision data'
          print *
          print *, 'Configuration parameters:'
          print *
          print *, 'DFTI_FORWARD_DOMAIN       = DFTI_COMPLEX'
          print *, 'DFTI_PRECISION            = DFTI_SINGLE '
          print *, 'DFTI_DIMENSION            =   2'
          print 903, m, n
          print *, 'DFTI_PLACEMENT            = DFTI_NOT_INPLACE'
          print 907, (strides_in(i),  i=1,3)
          print 908, (strides_out(i), i=1,3)
          print *, 'DFTI_FORWARD_SCALE        = 1.0 '
          print *, 'DFTI_BACKWARD_SCALE       = 1.0/real(m*n)'
          print *
      endif

!
!     Check input parameters
!
      if((m*n).GT.(M_MAX* N_MAX)) then
          print*, ' Error input parameters: (m*n)>(M_MAX*N_MAX) '
          print*, ' Please see mkl_dfti_examples.fi file'
          print*, ' TEST FAIL'
          goto 101
      endif

!
!     initialize X_IN and copy to expected X_EXP
!
      call ZERO_INIT_COMPLEX_C(X_IN, M_MAX*N_MAX)

      call INIT_MULTIPLE_VECTOR_C(X_IN, m, n, M_MAX, strides_in)

      call CCOPY(M_MAX*N_MAX, X_IN, 1, X_EXP, 1)

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'INPUT vector X (2D columns)'
        call PRINT_THREE_VECTORS_C(X_IN, m,  M_MAX, strides_in)
      endif

!
!     Create Dfti descriptor
!

      Status = DftiCreateDescriptor( Desc_Handle, DFTI_SINGLE, &
      DFTI_COMPLEX, 2, lengths)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      end if

!
!     Set placement of result DFTI_NOT_INPLACE
!
      Status = DftiSetValue( Desc_Handle, DFTI_PLACEMENT, DFTI_NOT_INPLACE)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
      end if

!
!     In case of data allocation in the 2D array(M_MAX*N_MAX)(Fortran interface):
!     srides(3) = M_MAX is not default parameter if m is not equal to M_MAX
!

      if(m .NE. M_MAX) then
          Status = DftiSetValue(Desc_Handle, DFTI_INPUT_STRIDES, strides_in)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          endif

          Status = DftiSetValue(Desc_Handle, DFTI_OUTPUT_STRIDES, strides_out)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          endif
      endif


!     Commit Dfti descriptor
!
!
      Status = DftiCommitDescriptor( Desc_Handle )
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
      end if

!
!     Compute Forward transform
!
      print *
      print*,'Compute DftiComputeForward'
      Status = DftiComputeForward( Desc_Handle, X_IN, X_OUT)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
          goto 100
      end if

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'Forward OUTPUT vector X (2D columns)'
        call PRINT_THREE_VECTORS_C(X_OUT, m, M_MAX, strides_out)
      endif

!
!     Set Scale number for Backward transform
!
      Scale = 1.0/real(m*n, KIND=4)

      Status = DftiSetValue(Desc_Handle, DFTI_BACKWARD_SCALE, Scale)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
      end if

!
!     Commit Dfti descriptor
!
      Status = DftiCommitDescriptor( Desc_Handle )
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
      end if

!
!     Compute Backward transform
!
      print *
      print*,'Compute DftiComputeBackward'
      Status = DftiComputeBackward( Desc_Handle, X_OUT, X_IN)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
          goto 100
      end if

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'Backward OUTPUT vector X (2D columns)'
        call PRINT_THREE_VECTORS_C(X_IN, m, M_MAX, strides_in)
      endif

!
!     Check result
!
      maxerr = CHECK_RESULT_C(X_IN, X_EXP, M_MAX*N_MAX)
      if(ACCURACY_PRINT) then
        print *
        print 904,  maxerr
      endif

      if(maxerr .lt. eps) then
        print*,'TEST PASSED'
      else
        print*,'TEST FAIL '
      endif

 100  continue
      Status = DftiFreeDescriptor(Desc_Handle)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
      end if

 903  format(' DFTI_LENGTHS              = {', I4,',',I4,'}' )
 904  format(' ACCURACY = ', G15.6)
 907  format(' DFTI_INPUT_STRIDES        = {',I4,',',I4,',',I4,'}')
 908  format(' DFTI_OUTPUT_STRIDES       = {',I4,',',I4,',',I4,'}')

 101  continue
      print *
      end


