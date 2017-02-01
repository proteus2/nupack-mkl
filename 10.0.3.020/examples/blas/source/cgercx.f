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
!      C G E R C  Example Program Text
!*******************************************************************************

      program   CGERC_MAIN
*
      integer          m, n, lda, incx, incy
      integer          mmax, nmax, xmax, ymax
      parameter        (mmax=4, nmax=5, xmax=5, ymax=5)
      parameter        (lda=mmax)
      complex          alpha
      complex          a(mmax,nmax), x(xmax), y(ymax)
      integer          i, j
*       Intrinsic Functions
      intrinsic        abs
*       External Subroutines
      external         CGERC, PrintVectorC, PrintArrayC
*
*       Executable Statements
*
      print*
      print*, '   C G E R C  EXAMPLE PROGRAM'
*
*       Read input data from input file
      read*
      read*, m, n
      read*, incx, incy
      read*, alpha
      if ( ((1+(m-1)*abs(incx)).gt.xmax).or.
     $     ((1+(n-1)*abs(incy)).gt.ymax).or.
     $     (m.gt.mmax.or.n.gt.nmax) ) then
        print*, ' Insufficient memory for arrays'
        goto 99
      end if
      read*, (x(i),i=1, 1+(m-1)*abs(incx))
      read*, (y(i),i=1, 1+(n-1)*abs(incy))
      read*, ((a(i,j),j=1,n),i=1,m)
*
*
*       Print input data
      print*
      print*, '     INPUT DATA'
      print 101, m, n
      print 102, alpha
      call PrintVectorC(0,m,x,incx,'X ')
      call PrintVectorC(0,n,y,incy,'Y ')
      call PrintArrayC(0,0,m,n,a,lda,'A')
*
*      Call CGERC subroutine
      call CGERC( m, n, alpha, x, incx, y, incy, a, lda )
*
      print*
      print*, '     OUTPUT DATA'
      call PrintArrayC(0,0,m,n,a,lda,'A')

  99  continue
 101  format(7x,'M=',i1,'  N=',i1)
 102  format(7x,'ALPHA=(',f4.1,',',f4.1,')')
      stop
      end
