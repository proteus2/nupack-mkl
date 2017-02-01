!*******************************************************************************
!                              INTEL CONFIDENTIAL
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
!       MKL DFTI interface example program (Fortran-interface)
!
!       Forward-Backward 2D real transform for double precision data not inplace.
!       Multiple 2D transform along 2-nd dimension of 3D array.
!
!*******************************************************************************
!   Configuration parameters:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL						(obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE                   (obligatory)
!           DFTI_DIMENSION      = 2                             (obligatory)
!           DFTI_LENGTHS        = { m, n}                       (obligatory)
!           DFTI_PACKED_FORMAT  = DFTI_PACK_FORMAT              (default = DFTI_CCS_FORMAT)
!           DFTI_PLACEMENT      = DFTI_NOT_INPLACE              (default = DFTI_INPLACE)
!           DFTI_INPUT_STRIDES  = {first_index, stride_in_m, stride_in_n}
!                                                               (default={0,1, m})
!           DFTI_FORWARD_SCALE  = 1.0                           (default)
!           DFTI_BACKWARD_SCALE = 1.0/real(m*n)                 (default=1.0)
!
!           DFTI_NUMBER_OF_TRANSFORMS   = multiple              (default = 1)
!           DFTI_INPUT_DISTANCE         = dist_in               (obligatory,
!                                                       if NUMBER_OF_TRANSFORMS >1)
!
!   Other default configuration parameters are in the mkl_dfti.f90 interface file
!*******************************************************************************

      Program REAL_2D_PACK_DOUBLE_EX6

      Use MKL_DFTI
      include 'mkl_dfti_examples.fi'

      integer    m, n

      real(8) :: X_IN_3D (M_MAX,N_MAX,K_MAX)
      real(8) :: X_IN    (M_MAX*N_MAX*K_MAX)
      real(8) :: X_OUT_3D(M_MAX,N_MAX,K_MAX)
      real(8) :: X_OUT   (M_MAX*N_MAX*K_MAX)
      real(8) :: X_EXP   (M_MAX*N_MAX*K_MAX)
      real(8) :: X_EXP_3D(M_MAX,N_MAX,K_MAX)

      equivalence (X_EXP, X_EXP_3D)
      equivalence (X_IN,  X_IN_3D)
      equivalence (X_OUT, X_OUT_3D)

      type(DFTI_DESCRIPTOR), POINTER :: Desc_Handle
      integer   status
      real(8)   Scale
      integer   lengths(2)
      integer   strides_in(3)
      integer   strides_out(3)

      integer   first_index
      integer   multiple
      integer   dist_in
      integer   dist_out

      real(8)   maxerr, err
      real(8)   eps
      parameter (eps=DOUBLE_EPS)
      integer    i

!
!     Read input parameters from input file
!     m - size of transform  along first dimension
!     n - size of transform  along second dimension
!     first_index - displacement from the first element of data array
!     multiple - number of multiple transform
!
      read*
      read*, m
      read*, n
      read*, first_index
      read*, multiple

!
!     Put transform parameters
!
      lengths(1) = m
      lengths(2) = n

      strides_in(1) = first_index
      strides_in(2) = 1
      strides_in(3) = M_MAX*N_MAX

      strides_out(1) = first_index
      strides_out(2) = 1
      strides_out(3) = M_MAX*N_MAX

      dist_in  = M_MAX
      dist_out = M_MAX

      if(LEGEND_PRINT) then
          print*, 'REAL_2D_PACK_DOUBLE_EX6'
          print*, 'Forward-Backward 2D real transform for double precision data'
          print *, 'Multiple 2D transform along 2-nd dimension of 3D array'
          print *
          print *, 'Configuration parameters:'
          print *
          print *, 'DFTI_FORWARD_DOMAIN       = DFTI_REAL'
          print *, 'DFTI_PRECISION            = DFTI_DOUBLE '
          print *, 'DFTI_DIMENSION            =   2'
          print 903, m, n
          print 905, multiple
          print 906, dist_in
          print *, 'DFTI_PACKED_FORMAT        = DFTI_PACK_FORMAT'
          print *, 'DFTI_PLACEMENT            = DFTI_NOT_INPLACE'
          print 907, (strides_in(i),  i=1,3)
          print *, 'DFTI_FORWARD_SCALE        = 1.0 '
          print *, 'DFTI_BACKWARD_SCALE       = 1.0/real(m*n)'
          print *
      endif

!
!     Check input parameters
!
      if((m.GT.M_MAX).OR.(n.GT.K_MAX)) then
          print*, ' Error input parameters: (m.GT.M_MAX).OR.(n.GT.K_MAX) '
          print*, ' Please see mkl_dfti_examples.fi file'
          print*, ' TEST FAIL'
          goto 101
      endif

      if((first_index+m*multiple).GT.(M_MAX*N_MAX)) then
          print*, ' Error input parameter first_index '
           print*, ' Please see mkl_dfti_examples.fi file'
          print*, ' TEST FAIL'
          goto 101
      endif

!
!     initialize X_IN and copy to expected X_EXP
!
      call ZERO_INIT_REAL_D(X_IN, M_MAX*N_MAX*K_MAX)
      call ZERO_INIT_REAL_D(X_OUT,M_MAX*N_MAX*K_MAX)

      do i=1, multiple
        call INIT_MULTIPLE_2D_COLUMNS_D(X_IN_3D(1,i,1), m, n, strides_in)
      enddo

      call DCOPY(M_MAX*N_MAX*K_MAX, X_IN, 1, X_EXP, 1)

      if(ADVANCED_DATA_PRINT) then
        print *
        print*,'INPUT vector X (2D columns)'
          do i=1, multiple
              print *
              print 908, i
              call PRINT_THREE_FIRST_VECTORS_2D_D(X_IN_3D(1,i,1), lengths, strides_in)
          enddo
      endif

!
!     Create Dfti descriptor
!
      Status = DftiCreateDescriptor( Desc_Handle, DFTI_DOUBLE, &
      DFTI_REAL, 2, lengths)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      end if

!
!     Set packed format for output complex conjugate-symmetric data
!
      Status = DftiSetValue(Desc_Handle, DFTI_PACKED_FORMAT, DFTI_PACK_FORMAT)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
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

          Status = DftiSetValue( Desc_Handle, DFTI_OUTPUT_DISTANCE, dist_out)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          end if
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
!     Set Forward transform strides
!
      Status = DftiSetValue(Desc_Handle, DFTI_INPUT_STRIDES, strides_in)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      endif

      Status = DftiSetValue(Desc_Handle, DFTI_OUTPUT_STRIDES, strides_out)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
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
          do i=1, multiple
              print *
              print 908, i
              call PRINT_THREE_FIRST_VECTORS_2D_D(X_IN_3D(1,i,1), lengths, strides_in)
          enddo
      endif

!
!     Set Scale number for Backward transform
!
      Scale = 1.0/real(m*n, KIND=8)

      Status = DftiSetValue(Desc_Handle, DFTI_BACKWARD_SCALE, Scale)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 100
      end if

!
!     Set Backward transform distances
!
          Status = DftiSetValue( Desc_Handle, DFTI_INPUT_DISTANCE, dist_out)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          end if

          Status = DftiSetValue( Desc_Handle, DFTI_OUTPUT_DISTANCE, dist_in)
          if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
              call dfti_example_status_print(Status)
              goto 100
          end if

!
!     Set Backward transform strides
!
      Status = DftiSetValue(Desc_Handle, DFTI_INPUT_STRIDES, strides_out)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      endif

      Status = DftiSetValue(Desc_Handle, DFTI_OUTPUT_STRIDES, strides_in)
      if (.not. DftiErrorClass(Status, DFTI_NO_ERROR)) then
          call dfti_example_status_print(Status)
          goto 101
      endif

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
          do i=1, multiple
              print *
              print 908, i
              call PRINT_THREE_FIRST_VECTORS_2D_D(X_IN_3D(1,i,1), lengths, strides_in)
          enddo
      endif

!
!     Check result
!
      maxerr = 0.0
      do i=1, multiple
          err = CHECK_RESULT_2D_D(X_IN_3D(1,i,1), X_EXP_3D(1,i,1), lengths, strides_in)
          maxerr = max(err, maxerr)
      enddo

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
 905  format(' DFTI_NUMBER_OF_TRANSFORMS = ', I4)
 906  format(' DFTI_INPUT_DISTANCE       = ', I4)
 907  format(' DFTI_INPUT_STRIDES        = {',I4,',',I4,',',I4,'}')
 908  format(' Transform Serial =', I2)

 101  continue
      print *
      end


