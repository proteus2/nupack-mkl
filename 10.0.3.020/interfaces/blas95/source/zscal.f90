!*******************************************************************************
!                              INTEL CONFIDENTIAL
!   Copyright(C) 2005-2008 Intel Corporation. All Rights Reserved.
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
!  Content:
!      Intel(R) Math Kernel Library (MKL) F95 interface for BLAS routines
!*******************************************************************************
! This file was generated automatically!
!*******************************************************************************

PURE SUBROUTINE ZSCAL_MKL95(X,A)
    ! MKL Fortran77 call:
    ! ZSCAL(N,A,X,INCX)
    ! <<< Use statements >>>
    USE MKL77_BLAS, ONLY: MKL77_SCAL
    ! <<< Implicit statement >>>
    IMPLICIT NONE
    ! <<< Kind parameter >>>
    INTEGER, PARAMETER :: WP = KIND(1.0D0)
    ! <<< Scalar arguments >>>
    COMPLEX(WP), INTENT(IN) :: A
    ! <<< Array arguments >>>
    COMPLEX(WP), INTENT(INOUT) :: X(:)
    ! <<< Local declarations >>>
    ! <<< Parameters >>>
    CHARACTER(LEN=4), PARAMETER :: SRNAME = 'SCAL'
    ! <<< Local scalars >>>
    INTEGER :: INCX
    INTEGER :: N
    ! <<< Intrinsic functions >>>
    INTRINSIC SIZE
    ! <<< Executable statements >>>
    ! <<< Init optional and skipped scalars >>>
    INCX = 1
    N = SIZE(X)
    ! <<< Call blas77 routine >>>
    CALL MKL77_SCAL(N,A,X,INCX)
END SUBROUTINE ZSCAL_MKL95