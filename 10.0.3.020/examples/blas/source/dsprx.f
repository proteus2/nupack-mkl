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
!      D S P R  Example Program Text
!*******************************************************************************

      program   DSPR_MAIN
*
      character*1      uplo
      integer          n, incx
      integer          apmax, xmax
      parameter        (apmax=15, xmax=5)
      double precision alpha
      double precision ap(apmax), x(xmax)
      integer          i
*       Intrinsic Functions
      intrinsic        abs
*       External Subroutines
      external         DSPR, PrintVectorD
*
*       Executable Statements
*
      print*
      print*, '   D S P R  EXAMPLE PROGRAM'
*
*       Read input data from input file
      read*
      read*, n
      read*, incx
      read*, alpha
      read 100, uplo
      if ( ((1+(n-1)*abs(incx)).gt.xmax).or.
     $     (n*(n+1))/2.gt.apmax ) then
          print*, ' Insufficient memory for arrays'
          goto 99
      end if
      read*, (x(i),i=1, 1+(n-1)*abs(incx))
      read*, (ap(i),i=1,(n*(n+1))/2)
*
*
*       Print input data
      print*
      print*, '     INPUT DATA'
      print 101, n
      print 102, alpha
      print 103, uplo
      call PrintVectorD(0,n,x,incx,'X ')
      call PrintVectorD(1,(n*(n+1))/2,ap,1,'AP')
*
*      Call DSPR subroutine
      call DSPR(uplo, n, alpha, x, incx, ap)
*
      print*
      print*, '     OUTPUT DATA'
      call PrintVectorD(1,(n*(n+1))/2,ap,1,'AP')

  99  continue
 100  format(a1)
 101  format(7x,'N=',i1)
 102  format(7x,'ALPHA=',f4.1)
 103  format(7x,'UPLO=',a1)
      stop
      end