!*******************************************************************************
!                             INTEL CONFIDENTIAL
!  Copyright(C) 2001-2008 Intel Corporation. All Rights Reserved.
!  The source code contained  or  described herein and all documents related to
!  the source code ("Material") are owned by Intel Corporation or its suppliers
!  or licensors.  Title to the  Material remains with  Intel Corporation or its
!  suppliers and licensors. The Material contains trade secrets and proprietary
!  and  confidential  information of  Intel or its suppliers and licensors. The
!  Material  is  protected  by  worldwide  copyright  and trade secret laws and
!  treaty  provisions. No part of the Material may be used, copied, reproduced,
!  modified, published, uploaded, posted, transmitted, distributed or disclosed
!  in any way without Intel's prior express written permission.
!  No license  under any  patent, copyright, trade secret or other intellectual
!  property right is granted to or conferred upon you by disclosure or delivery
!  of the Materials,  either expressly, by implication, inducement, estoppel or
!  otherwise.  Any  license  under  such  intellectual property  rights must be
!  express and approved by Intel in writing.
!
!*******************************************************************************
!  Content:
!    viRngNegbinomial  Example Program Text
!*******************************************************************************

      include 'mkl_vsl.fi'
      include "errcheck.inc"

      program MKL_VSL_TEST

      USE MKL_VSL_TYPE
      USE MKL_VSL

      integer(kind=4) i,nn
      integer n
      integer(kind=4) errcode

      real(kind=8) a,p
      integer(kind=4) r(1000)
      integer brng,method,seed

      real(kind=8) tM,tD,tQ,tD2
      real(kind=8) sM,sD
      real(kind=8) sum, sum2
      real(kind=8) s
      real(kind=8) DeltaM,DeltaD

      TYPE (VSL_STREAM_STATE) :: stream

      n=1000
      nn=10

      brng=VSL_BRNG_MCG31
      method=0
      seed=1

      a=1.0
      p=0.75

!     ***** Initialize *****
      errcode=vslnewstream( stream, brng,  seed )
      call CheckVslError(errcode)

!     ***** Call RNG *****
      errcode=virngnegbinomial( method, stream, n, r, a, p )
      call CheckVslError(errcode)

!     ***** Theoretical moments *****
      tM=a*(1-p)/p
      tD=a*(1-p)/(p*p)
      tQ=(a*(1-p)*(p*p-3*a*p-6*p+3*a+6))/(p*p*p*p)

!     ***** Sample moments *****
      sum=0.0
      sum2=0.0
      do i=1,n
        sum=sum+r(i)
        sum2=sum2+r(i)*r(i)
      end do
      sM=sum/n
      sD=sum2/n-sM*sM

!     ***** Comparison of theoretical and sample moments *****
      tD2=tD*tD
      s=((tQ-tD2)/n)-(2*(tQ-2*tD2)/(n*n))+((tQ-3*tD2)/(n*n*n))
      DeltaM=(tM-sM)/sqrt(tD/n)
      DeltaD=(tD-sD)/sqrt(s)

!     ***** Printing results *****
      print *,"Sample of viRngNegbinomial."
      print *,"---------------------------"
      print *,""
      print *,"Parameters:"
      print 11,"    a=",a
      print 11,"    p=",p

      print *,""
      print *,"Results (first 10 of 1000):"
      print *,"---------------------------"
      do i=1,nn
        print 10,r(i)
      end do

      print *,""
      if (DeltaM>3.0 .OR. DeltaD>3.0) then
        print 12,"Error: sample moments (mean=",                        &
     &    sM,", variance=",sD,                                          &
     &    ") are disagreed with theory (mean=",                         &
     &    tM,", variance=",tD,")."
        stop 1
      else
        print 12,"Sample moments (mean=",sM,                            &
     &    ", variance=",sD,") are agreed with theory (mean=",           &
     &    tM,", variance=",tD,")."
      end if

!     ***** Deinitialize *****
      errcode=vsldeletestream( stream )
      call CheckVslError(errcode)

10    format(I5)
11    format(A,F5.2)
12    format(A,F5.2,A,F5.2,A,F5.2,A,F5.2,A)

      end
