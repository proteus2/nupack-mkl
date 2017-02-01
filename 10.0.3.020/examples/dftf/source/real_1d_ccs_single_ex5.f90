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
!       Real-to-complex and complex-to-real multiple transform  column inplace
!       for single precision data which are allocated in two-dimension array.
!       CCS packed format for complex conjugate-symmetric data
!
!   Configuration parameters:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL                 (obligatory)
!           DFTI_PRECISION      = DFTI_SINGLE               (obligatory)
!           DFTI_DIMENSION      = 1                         (obligatory)
!           DFTI_LENGTHS        = n                         (obligatory)
!           DFTI_PACKED_FORMAT  = DFTI_CCS_FORMAT           (default)
!           DFTI_PLACEMENT      = DFTI_INPLACE              (default)
!
!           DFTI_INPUT_STRIDES  = {first_index, step_in}    (default={0,1})
!           DFTI_NUMBER_OF_TRANSFORMS = multiple            (default = 1)
!           DFTI_INPUT_DISTANCE       = dist_in             (obligatory,
!                                              if NUMBER_OF_TRANSFORMS >1)
!
!           DFTI_FORWARD_SCALE  = 1.0                       (default)
!           DFTI_BACKWARD_SCALE = 1.0/real(n)               (default=1.0)
!
!           DFTI_REAL_STORAGE   = DFTI_REAL_REAL            (default)
!           DFTI_CONJUGATE_EVEN_STORAGE = DFTI_COMPLEX_REAL (default)
!
!  Other default configuration parameters are in the mkl_dfti.f90 interface file
!*******************************************************************************

      Program REAL_1D_CCS_SINGLE_EX5

      Use MKL_DFTI
      include 'mkl_dfti_examples.fi'

      integer    n
      integer    first_index
      integer    multiple

      real :: X_IN_2D(M_MAX+2,N_MAX)
      real :: X_IN   ((M_MAX+2)*N_MAX)
      real :: X_EXP  ((M_MAX+2)*N_MAX)

      equivalence (X_IN,  X_IN_2D)

      type(DFTI_DESCRIPTOR), POINTER :: Desc_Handle
      integer   status
      real      Scale
      integer   strides_in(2)
      integer   dist_in

      real      maxerr
      real      eps
      parameter (eps=SINGLE_EPS)
      integer    i

!
!     Read input parameters from input file
!     n - size of transform
!     first_index - displacement from the first element of data array
!     multiple - number of multiple transform
!
      read*
      read*, n
      read*, first_index
      read*, multiple

!
!     Put transform parameters
!     In case of multiple columns transform  (Fortran interface):
!     column distance is equal to leading dimension and data are unit-stride
!
      strides_in(1) = first_index
      strides_in(2) = 1

      dist_in = M_MAX+2

      if(LEGEND_PRINT) then
          print*, 'REAL_1D_CCS_SINGLE_EX5'
          print*, 'Real-to-complex and complex-to-real transform for single precision data'
          print *
          print *, 'Configuration parameters:'
          print *
          print *, 'DFTI_FORWARD_DOMAIN       = DFTI_REAL'
          print *, 'DFTI_PRECISION            = DFTI_SINGLE '
          print *, 'DFTI_DIMENSION            =   1'
          print 903, n
          print *, 'DFTI_PACKED_FORMAT        = DFTI_CCS_FORMAT'
          print *, 'DFTI_PLACEMENT            = DFTI_INPLACE'
          print 905, multiple
          print 906, dist_in
          print 907, (strides_in(i),  i=1,2)
          print *, 'DFTI_FORWARD_SCALE        = 1.0 '
          print *, 'DFTI_BACKWARD_SCALE       = 1.0/real(n)'
          print *
      endif

!
!     Check input parameters
!
      if((first_index+multiple*n).gt.(M_MAX*N_MAX)) then
          print*, ' Error input parameters: (first_index+multiple*n)>(M_MAX*N_MAX) '
          print*, ' Please see mkl_dfti_examples.fi file'
          print*, ' TEST FAIL'
          goto 101
      endif

!
!     initialize X_IN and copy to expected X_EXP
!
      call ZERO_INIT_REAL_S(X_IN, (M_MAX+2)*N_MAX)

      call INIT_MULTIPLE_REAL_VECTOR_S(X_IN, n, multiple, dist_in, strides_in)

      call SCOPY((M_MAX+2)*N_MAX, X_IN, 1, X_EXP, 1)

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'INPUT vector X (for multiple=3)'
        call PRINT_THREE_VECTORS_S(X_IN, n, dist_in, strides_in)
      endif

!
!     Create Dfti descriptor for 1D single precision  transform
!

      Status = DftiCreateDescriptor( Desc_Handle, DFTI_SINGLE, &
      DFTI_REAL, 1, n )

      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      end if

!
!     Set parameters for multiple transform mode
!
      if( multiple .GT. 1 ) then
          Status = DftiSetValue( Desc_Handle, DFTI_NUMBER_OF_TRANSFORMS, multiple)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          end if

          Status = DftiSetValue( Desc_Handle, DFTI_INPUT_DISTANCE, dist_in)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          end if
      end if

!
!     Set data strides
!
      Status = DftiSetValue(Desc_Handle, DFTI_INPUT_STRIDES, strides_in)
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
!     Compute Forward transform
!
      print *
      print*,'Compute DftiComputeForward'
      Status = DftiComputeForward( Desc_Handle, X_IN)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
          goto 100
      end if

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'Forward OUTPUT vector X (for multiple=3)'
        call PRINT_THREE_VECTORS_S(X_IN, n+2, dist_in, strides_in)
      endif

!
!     Set Scale number for Backward transform
!
      Scale = 1.0/real(n, KIND=4)

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
      Status = DftiComputeBackward( Desc_Handle, X_IN)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
          goto 100
      end if

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'Backward OUTPUT vector X (for multiple=3)'
        call PRINT_THREE_VECTORS_S(X_IN, n, dist_in, strides_in)
      endif

!
!     Check result
!
      maxerr = CHECK_RESULT_S(X_IN, X_EXP,(M_MAX+2)*N_MAX)
      if(ACCURACY_PRINT) then
        print *
        print 904,  maxerr
      endif

      if(maxerr .LT.eps) then
        print*,'TEST PASSED'
      else
        print*,'TEST FAIL '
      endif

 100  continue
      Status = DftiFreeDescriptor(Desc_Handle)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR) ) then
          call dfti_example_status_print(Status)
      end if

 903  format(' DFTI_LENGTHS              =', I4)
 904  format(' ACCURACY = ', G15.6)
 905  format(' DFTI_NUMBER_OF_TRANSFORMS = ', I4)
 906  format(' DFTI_INPUT_DISTANCE       = ', I4)
 907  format(' DFTI_INPUT_STRIDES        = {',I4,',',I4,'}')
 101  continue
      print *
      end


