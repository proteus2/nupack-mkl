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
!      Intel(R) Math Kernel Library (MKL) F95 interface for LAPACK routines
!*******************************************************************************
! This file was generated automatically!
!*******************************************************************************

PURE SUBROUTINE CHPGV_MKL95(A,B,W,ITYPE,UPLO,Z,INFO)
    ! MKL Fortran77 call:
    ! CHPGV(ITYPE,JOBZ,UPLO,N,A,B,W,Z,LDZ,WORK,RWORK,INFO)
    ! <<< Use statements >>>
    USE MKL77_LAPACK, ONLY: MKL77_HPGV, MKL77_XERBLA
    ! <<< Implicit statement >>>
    IMPLICIT NONE
    ! <<< Kind parameter >>>
    INTEGER, PARAMETER :: WP = KIND(1.0E0)
    ! <<< Scalar arguments >>>
    INTEGER, INTENT(IN), OPTIONAL :: ITYPE
    CHARACTER(LEN=1), INTENT(IN), OPTIONAL :: UPLO
    INTEGER, INTENT(OUT), OPTIONAL :: INFO
    ! <<< Array arguments >>>
    COMPLEX(WP), INTENT(INOUT) :: A(:)
    COMPLEX(WP), INTENT(INOUT) :: B(:)
    REAL(WP), INTENT(OUT) :: W(:)
    COMPLEX(WP), INTENT(OUT), OPTIONAL, TARGET :: Z(:,:)
    ! <<< Local declarations >>>
    ! <<< Parameters >>>
    CHARACTER(LEN=4), PARAMETER :: SRNAME = 'HPGV'
    ! <<< Local scalars >>>
    INTEGER :: O_ITYPE
    CHARACTER(LEN=1) :: O_UPLO
    INTEGER :: O_INFO
    CHARACTER(LEN=1) :: JOBZ
    INTEGER :: N
    INTEGER :: LDZ
    INTEGER :: L_STAT_ALLOC, L_STAT_DEALLOC
    INTEGER :: L_NN
    ! <<< Local arrays >>>
    COMPLEX(WP), POINTER :: O_Z(:,:)
    COMPLEX(WP), POINTER :: WORK(:)
    REAL(WP), POINTER :: RWORK(:)
    ! <<< Stubs to "allocate" optional arrays >>>
    COMPLEX(WP), TARGET :: L_A2_COMP(1,1)
    ! <<< Intrinsic functions >>>
    INTRINSIC INT, MAX, PRESENT, REAL, SIZE, SQRT
    ! <<< Executable statements >>>
    ! <<< Init optional and skipped scalars >>>
    IF(PRESENT(ITYPE)) THEN
        O_ITYPE = ITYPE
    ELSE
        O_ITYPE = 1
    ENDIF
    IF(PRESENT(UPLO)) THEN
        O_UPLO = UPLO
    ELSE
        O_UPLO = 'U'
    ENDIF
    IF(PRESENT(Z)) THEN
        JOBZ = 'V'
    ELSE
        JOBZ = 'N'
    ENDIF
    IF(PRESENT(Z)) THEN
        LDZ = MAX(1,SIZE(Z,1))
    ELSE
        LDZ = 1
    ENDIF
    L_NN = SIZE(A)
    IF(L_NN <= 0) THEN
        N = L_NN
    ELSE
        ! Packed matrix "A(N*(N+1)/2)", therefore: N=(-1+8*(SIZE(A)))/2
        N = INT((-1+SQRT(1+8*REAL(L_NN,WP)))*0.5)
    ENDIF
    ! <<< Init allocate status >>>
    L_STAT_ALLOC = 0
    ! <<< Allocate local and work arrays >>>
    IF(PRESENT(Z)) THEN
        O_Z => Z
    ELSE
        O_Z => L_A2_COMP
    ENDIF
    ALLOCATE(RWORK(MAX(1,3*N-2)), STAT=L_STAT_ALLOC)
    IF(L_STAT_ALLOC==0) THEN
        ALLOCATE(WORK(MAX(1,2*N-1)), STAT=L_STAT_ALLOC)
    ENDIF
    ! <<< Call lapack77 routine >>>
    IF(L_STAT_ALLOC==0) THEN
        CALL MKL77_HPGV(O_ITYPE,JOBZ,O_UPLO,N,A,B,W,O_Z,LDZ,WORK,RWORK, &
     &                                                           O_INFO)
    ELSE; O_INFO = -1000
    ENDIF
    ! <<< Deallocate local and work arrays >>>
    DEALLOCATE(RWORK, STAT=L_STAT_DEALLOC)
    DEALLOCATE(WORK, STAT=L_STAT_DEALLOC)
    ! <<< Error handler >>>
    IF(PRESENT(INFO)) THEN
        INFO = O_INFO
    ELSEIF(O_INFO <= -1000) THEN
        CALL MKL77_XERBLA(SRNAME,-O_INFO)
    ENDIF
END SUBROUTINE CHPGV_MKL95
