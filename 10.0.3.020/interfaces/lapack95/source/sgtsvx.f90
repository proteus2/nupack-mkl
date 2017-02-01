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

PURE SUBROUTINE SGTSVX_MKL95(DL,D,DU,B,X,DLF,DF,DUF,DU2,IPIV,FACT,TRANS,&
     &                                             FERR,BERR,RCOND,INFO)
    ! MKL Fortran77 call:
    ! SGTSVX(FACT,TRANS,N,NRHS,DL,D,DU,DLF,DF,DUF,DU2,IPIV,B,LDB,X,LDX,
    !   RCOND,FERR,BERR,WORK,IWORK,INFO)
    ! <<< Use statements >>>
    USE MKL77_LAPACK, ONLY: MKL77_GTSVX, MKL77_XERBLA
    ! <<< Implicit statement >>>
    IMPLICIT NONE
    ! <<< Kind parameter >>>
    INTEGER, PARAMETER :: WP = KIND(1.0E0)
    ! <<< Scalar arguments >>>
    CHARACTER(LEN=1), INTENT(IN), OPTIONAL :: FACT
    CHARACTER(LEN=1), INTENT(IN), OPTIONAL :: TRANS
    REAL(WP), INTENT(OUT), OPTIONAL :: RCOND
    INTEGER, INTENT(OUT), OPTIONAL :: INFO
    ! <<< Array arguments >>>
    REAL(WP), INTENT(IN) :: DL(:)
    REAL(WP), INTENT(IN) :: D(:)
    REAL(WP), INTENT(IN) :: DU(:)
    REAL(WP), INTENT(IN) :: B(:,:)
    REAL(WP), INTENT(OUT) :: X(:,:)
    REAL(WP), INTENT(INOUT), OPTIONAL, TARGET :: DLF(:)
    REAL(WP), INTENT(INOUT), OPTIONAL, TARGET :: DF(:)
    REAL(WP), INTENT(INOUT), OPTIONAL, TARGET :: DUF(:)
    REAL(WP), INTENT(INOUT), OPTIONAL, TARGET :: DU2(:)
    INTEGER, INTENT(INOUT), OPTIONAL, TARGET :: IPIV(:)
    REAL(WP), INTENT(OUT), OPTIONAL, TARGET :: FERR(:)
    REAL(WP), INTENT(OUT), OPTIONAL, TARGET :: BERR(:)
    ! <<< Local declarations >>>
    ! <<< Parameters >>>
    CHARACTER(LEN=5), PARAMETER :: SRNAME = 'GTSVX'
    ! <<< Local scalars >>>
    CHARACTER(LEN=1) :: O_FACT
    CHARACTER(LEN=1) :: O_TRANS
    REAL(WP) :: O_RCOND
    INTEGER :: O_INFO
    INTEGER :: N
    INTEGER :: NRHS
    INTEGER :: LDB
    INTEGER :: LDX
    INTEGER :: L_STAT_ALLOC, L_STAT_DEALLOC
    ! <<< Local arrays >>>
    REAL(WP), POINTER :: O_DLF(:)
    REAL(WP), POINTER :: O_DF(:)
    REAL(WP), POINTER :: O_DUF(:)
    REAL(WP), POINTER :: O_DU2(:)
    INTEGER, POINTER :: O_IPIV(:)
    REAL(WP), POINTER :: O_FERR(:)
    REAL(WP), POINTER :: O_BERR(:)
    REAL(WP), POINTER :: WORK(:)
    INTEGER, POINTER :: IWORK(:)
    ! <<< Intrinsic functions >>>
    INTRINSIC MAX, PRESENT, SIZE
    ! <<< Executable statements >>>
    ! <<< Init optional and skipped scalars >>>
    IF(PRESENT(FACT)) THEN
        O_FACT = FACT
    ELSE
        O_FACT = 'N'
    ENDIF
    IF(PRESENT(TRANS)) THEN
        O_TRANS = TRANS
    ELSE
        O_TRANS = 'N'
    ENDIF
    LDB = MAX(1,SIZE(B,1))
    LDX = MAX(1,SIZE(X,1))
    N = SIZE(D)
    NRHS = SIZE(B,2)
    ! <<< Init allocate status >>>
    L_STAT_ALLOC = 0
    ! <<< Allocate local and work arrays >>>
    IF(PRESENT(BERR)) THEN
        O_BERR => BERR
    ELSE
        ALLOCATE(O_BERR(NRHS), STAT=L_STAT_ALLOC)
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(DF)) THEN
            O_DF => DF
        ELSE
            ALLOCATE(O_DF(N), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(DLF)) THEN
            O_DLF => DLF
        ELSE
            ALLOCATE(O_DLF(N-1), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(DU2)) THEN
            O_DU2 => DU2
        ELSE
            ALLOCATE(O_DU2(N-2), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(DUF)) THEN
            O_DUF => DUF
        ELSE
            ALLOCATE(O_DUF(N-1), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(FERR)) THEN
            O_FERR => FERR
        ELSE
            ALLOCATE(O_FERR(NRHS), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        IF(PRESENT(IPIV)) THEN
            O_IPIV => IPIV
        ELSE
            ALLOCATE(O_IPIV(N), STAT=L_STAT_ALLOC)
        ENDIF
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        ALLOCATE(IWORK(N), STAT=L_STAT_ALLOC)
    ENDIF
    IF(L_STAT_ALLOC==0) THEN
        ALLOCATE(WORK(3*N), STAT=L_STAT_ALLOC)
    ENDIF
    ! <<< Call lapack77 routine >>>
    IF(L_STAT_ALLOC==0) THEN
        CALL MKL77_GTSVX(O_FACT,O_TRANS,N,NRHS,DL,D,DU,O_DLF,O_DF,O_DUF,&
     & O_DU2,O_IPIV,B,LDB,X,LDX,O_RCOND,O_FERR,O_BERR,WORK,IWORK,O_INFO)
    ELSE; O_INFO = -1000
    ENDIF
    ! <<< Set output optional scalar parameters >>>
    IF(PRESENT(RCOND)) THEN
        RCOND = O_RCOND
    ENDIF
    ! <<< Deallocate local and work arrays >>>
    IF(.NOT. PRESENT(BERR)) THEN
        DEALLOCATE(O_BERR, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(DF)) THEN
        DEALLOCATE(O_DF, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(DLF)) THEN
        DEALLOCATE(O_DLF, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(DU2)) THEN
        DEALLOCATE(O_DU2, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(DUF)) THEN
        DEALLOCATE(O_DUF, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(FERR)) THEN
        DEALLOCATE(O_FERR, STAT=L_STAT_DEALLOC)
    ENDIF
    IF(.NOT. PRESENT(IPIV)) THEN
        DEALLOCATE(O_IPIV, STAT=L_STAT_DEALLOC)
    ENDIF
    DEALLOCATE(IWORK, STAT=L_STAT_DEALLOC)
    DEALLOCATE(WORK, STAT=L_STAT_DEALLOC)
    ! <<< Error handler >>>
    IF(PRESENT(INFO)) THEN
        INFO = O_INFO
    ELSEIF(O_INFO <= -1000) THEN
        CALL MKL77_XERBLA(SRNAME,-O_INFO)
    ENDIF
END SUBROUTINE SGTSVX_MKL95
