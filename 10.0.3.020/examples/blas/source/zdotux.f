!*******************************************************************************
!                              INTEL CONFIDENTIAL
!   Copyright(C) 1999-2008 Intel Corporation. All Rights Reserved.
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
!      Z D O T U  Example Program Text
!*******************************************************************************

      program  ZDOTU_MAIN
*
      integer    n, incx, incy
      integer    xmax, ymax
      parameter  (xmax=20, ymax=20)
      complex*16 x(xmax), y(ymax), res
      integer    i
*       Intrinsic Functions
      intrinsic  abs
*       External Subroutines
      external   ZDOTU, PrintVectorZ
      complex*16 ZDOTU
*
*       Executable Statements
*
      print*
      print*,'   Z D O T U  EXAMPLE PROGRAM'
*
*       Read input data from input file
      read*
      read*, n
      read*, incx, incy
      if ( ((1+(n-1)*abs(incx)).gt.xmax).or.
     $     ((1+(n-1)*abs(incy)).gt.ymax) ) then
        print*, ' Insufficient memory for arrays'
        goto 99
      end if
      read*, (x(i),i=1,1+(n-1)*abs(incx))
      read*, (y(i),i=1,1+(n-1)*abs(incy))
*
*       Print input data
      print*
      print*, '     INPUT DATA'
      print 100, n
      call PrintVectorZ(0,n,x,incx,'X ')
      call PrintVectorZ(0,n,y,incy,'Y ')
*
*       Call ZDOTU subroutine
      res = ZDOTU(n,x,incx,y,incy)
*
      print*
      print*, '     OUTPUT DATA'
      print 101, res

  99  continue
 100  format(7x,'N=',i2)
 101  format(7x,'ZDOTU = (',f7.3,',',f7.3,')')
      stop
      end