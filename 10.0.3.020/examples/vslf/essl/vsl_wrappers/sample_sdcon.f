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
!*******************************************************************************

      INCLUDE 'mkl_vsl.fi'

      SUBROUTINE SDCON(h,inch,x,incx,y,incy,nh,nx,iy0,ny,id)
      USE MKL_VSL_TYPE
      USE MKL_VSL
      IMPLICIT NONE
!
      REAL(KIND=4) h(*),x(*),y(*)
      INTEGER(KIND=4) iy0,id
      INTEGER inch,incx,incy,nh,nx,ny
!
      TYPE(VSL_CONV_TASK) task
      INTEGER(KIND=4) status,error
      INTEGER start(1),decimation(1)
      INTEGER mode
!
      start(1) = iy0
      decimation(1) = id
      mode = VSL_CORR_MODE_FFT
      status = vslsconvnewtask1d(task,mode,nh,nx,ny)
      status = vslconvsetstart(task,start)
      status = vslconvsetdecimation(task,decimation)
      status = vslsconvexec1d(task,h,inch,x,incx,y,incy)
      error  = vslconvdeletetask(task)
!
      IF (status .NE. VSL_STATUS_OK) THEN
      PRINT *, 'ERROR: sdcon(): bad status=',status
      STOP 1
      END IF
!
      IF (error .NE. 0) THEN
      PRINT *, 'ERROR: sdcon(): failed to destroy the task descriptor'
      STOP 1
      END IF
!
      RETURN
      END
