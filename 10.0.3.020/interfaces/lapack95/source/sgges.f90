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

PURE SUBROUTINE SGGES_MKL95(A,B,ALPHAR,ALPHAI,BETA,VSL,VSR,SELECT,SDIM, &
     &                                                             INFO)
    ! MKL Fortran77 call:
    ! SGGES(JOBVSL,JOBVSR,SORT,SELECT,N,A,LDA,B,LDB,SDIM,ALPHAR,ALPHAI,
    !   BETA,VSL,LDVSL,VSR,LDVSR,WORK,LWORK,BWORK,INFO)
    ! <<< Use statements >>>
    USE MKL77_LAPACK, ONLY: MKL77_GGES, MKL77_XERBLA
    ! <<< Implicit statement >>>
    IMPLICIT NONE
    ! <<< Kind parameter >>>
    INTEGER, PARAMETER :: WP = KIND(1.0E0)
    ! <<< Scalar arguments >>>
    INTEGER, INTENT(OUT), OPTIONAL :: SDIM
    INTEGER, INTENT(OUT), OPTIONAL :: INFO
    ! <<< Array arguments >>>
    REAL(WP), INTENT(INOUT) :: A(:,:)
    REAL(WP), INTENT(INOUT) :: B(:,:)
    REAL(WP), INTENT(OUT) :: ALPHAR(:)
    REAL(WP), INTENT(OUT) :: ALPHAI(:)
    REAL(WP), INTENT(OUT) :: BETA(:)
    REAL(WP), INTENT(OUT), OPTIONAL, TARGET :: VSL(:,:)
    REAL(WP), INTENT(OUT), OPTIONAL, TARGET :: VSR(:,:)
    ! <<< Function arguments >>>
    INTERFACE
        PURE LOGICAL FUNCTION SELECT(ALPHAR,ALPHAI,BETA)
            INTEGER, PARAMETER :: WP = KIND(1.0E0)
            REAL(WP), INTENT(IN) :: ALPHAR,ALPHAI,BETA
        END FUNCTION SELECT
    END INTERFACE
    OPTIONAL :: SELECT
    ! <<< Local declarations >>>
    ! <<< Parameters >>>
    CHARACTER(LEN=4), PARAMETER :: SRNAME = 'GGES'
    ! <<< Local scalars >>>
    INTEGER :: O_SDIM
    INTEGER :: O_INFO
    CHARACTER(LEN=1) :: JOBVSL
    CHARACTER(LEN=1) :: JOBVSR
    CHARACTER(LEN=1) :: SORT
    INTEGER :: N
    INTEGER :: LDA
    INTEGER :: LDB
    INTEGER :: LDVSL
    INTEGER :: LDVSR
    INTEGER :: LWORK
    INTEGER :: L_STAT_ALLOC, L_STAT_DEALLOC
    ! <<< Local arrays >>>
    REAL(WP), POINTER :: O_VSL(:,:)
    REAL(WP), POINTER :: O_VSR(:,:)
    REAL(WP), POINTER :: WORK(:)
    LOGICAL, POINTER :: BWORK(:)
    ! <<< Arrays to request optimal sizes >>>
    REAL(WP) :: S_WORK(1)
    ! <<< Stubs to "allocate" optional arrays >>>
    LOGICAL, TARGET :: L_A1_LOGI(1)
    REAL(WP), TARGET :: L_A2_REAL(1,1)
    ! <<< Intrinsic functions >>>
    INTRINSIC MAX, PRESENT, SIZE
    ! <<< Executable statements >>>
    ! <<< Init optional and skipped scalars >>>
    IF(PRESENT(VSL)) THEN
        JOBVSL = 'V'
    ELSE
        JOBVSL = 'N'
    ENDIF
    IF(PRESENT(VSR)) THEN
        JOBVSR = 'V'
    ELSE
        JOBVSR = 'N'
    ENDIF
    LDA = MAX(1,SIZE(A,1))
    LDB = MAX(1,SIZE(B,1))
    IF(PRESENT(VSL)) THEN
        LDVSL = MAX(1,SIZE(VSL,1))
    ELSE
        LDVSL = 1
    ENDIF
    IF(PRESENT(VSR)) THEN
        LDVSR = MAX(1,SIZE(VSR,1))
    ELSE
        LDVSR = 1
    ENDIF
    N = SIZE(A,2)
    IF(PRESENT(SELECT)) THEN
        SORT = 'S'
    ELSE
        SORT = 'N'
    ENDIF
    ! <<< Init allocate status >>>
    L_STAT_ALLOC = 0
    ! <<< Allocate local and work arrays >>>
    IF(PRESENT(VSL)) THEN
        O_VSL => VSL
    ELSE
        O_VSL => L_A2_REAL
    ENDIF
    IF(PRESENT(VSR)) THEN
        O_VSR => VSR
    ELSE
        O_VSR => L_A2_REAL
    ENDIF
    IF(.NOT.PRESENT(SELECT)) THEN
        BWORK => L_A1_LOGI
    ELSE
        ALLOCATE(BWORK(N), STAT=L_STAT_ALLOC)
    ENDIF
    ! <<< Request work array(s) size >>>
    LWORK = -1
    CALL MKL77_GGES(JOBVSL,JOBVSR,SORT,SELECT,N,A,LDA,B,LDB,O_SDIM,     &
     &   ALPHAR,ALPHAI,BETA,O_VSL,LDVSL,O_VSR,LDVSR,S_WORK,LWORK,BWORK, &
     &                                                           O_INFO)
    ! <<< Exit if error: bad parameters >>>
    IF(O_INFO /= 0) THEN
        GOTO 200
    ENDIF
    LWORK = S_WORK(1)
    ! <<< Allocate work arrays with requested sizes >>>
    IF(L_STAT_ALLOC==0) THEN
        ALLOCATE(WORK(LWORK), STAT=L_STAT_ALLOC)
    ENDIF
    ! <<< Call lapack77 routine >>>
    IF(L_STAT_ALLOC==0) THEN
        CALL MKL77_GGES(JOBVSL,JOBVSR,SORT,SELECT,N,A,LDA,B,LDB,O_SDIM, &
     &     ALPHAR,ALPHAI,BETA,O_VSL,LDVSL,O_VSR,LDVSR,WORK,LWORK,BWORK, &
     &                                                           O_INFO)
    ELSE; O_INFO = -1000
    ENDIF
    ! <<< Set output optional scalar parameters >>>
    IF(PRESENT(SDIM)) THEN
        SDIM = O_SDIM
    ENDIF
    ! <<< Deallocate work arrays with requested sizes >>>
    DEALLOCATE(WORK, STAT=L_STAT_DEALLOC)
200    CONTINUE
    ! <<< Deallocate local and work arrays >>>
    IF(PRESENT(SELECT)) THEN
        DEALLOCATE(BWORK, STAT=L_STAT_DEALLOC)
    ENDIF
    ! <<< Error handler >>>
    IF(PRESENT(INFO)) THEN
        INFO = O_INFO
    ELSEIF(O_INFO <= -1000) THEN
        CALL MKL77_XERBLA(SRNAME,-O_INFO)
    ENDIF
END SUBROUTINE SGGES_MKL95
