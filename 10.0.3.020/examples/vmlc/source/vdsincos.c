/*******************************************************************************
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
!    vdSinCos  Example Program Text
!******************************************************************************/

#include <stdio.h>
#include <math.h>
#include "func_interv.h"

#include "mkl_vml.h"

int main()
{
  double dA1[VEC_LEN],dB1[VEC_LEN],dB2[VEC_LEN],dB3[VEC_LEN],dB4[VEC_LEN];

  MKL_INT i=0,vec_len=VEC_LEN;
  double CurRMS,MaxRMSsin=0.0,MaxRMScos=0.0;

  for(i=0;i<vec_len;i++) {
    dA1[i]=(double)(__DSINCOS_BEG+((__DSINCOS_END-__DSINCOS_BEG)*i)/vec_len);
    dB1[i]=0.0;
    dB2[i]=0.0;
    dB3[i]=sin(dA1[i]);
    dB4[i]=cos(dA1[i]);
  }

  vdSinCos(vec_len,dA1,dB1,dB2);

  printf("vdSinCos test/example program\n\n");
  printf("        Argument         vdSinCos:   Sin        Cos           Sin        Cos\n");
  printf("===============================================================================\n");
  for(i=0;i<vec_len;i++) {
    printf("% 22.14f % 20.6f % 10.6f % 13.6f % 10.6f\n",dA1[i],dB1[i],dB2[i],dB3[i],dB4[i]);
    CurRMS=fabs((dB1[i]-dB3[i])/(0.5*(dB1[i]+dB3[i])));
    if(MaxRMSsin<CurRMS) MaxRMSsin=CurRMS;
    CurRMS=fabs((dB2[i]-dB4[i])/(0.5*(dB2[i]+dB4[i])));
    if(MaxRMScos<CurRMS) MaxRMScos=CurRMS;
  }
  printf("\n");
  if(MaxRMSsin>=DEPS) {
    printf("Error! Relative accuracy (sin) is %.2f\n",MaxRMSsin);
    return 1;
  }
  else {
    printf("Relative accuracy (sin) is %.2f\n",MaxRMSsin);
  }
  if(MaxRMScos>=DEPS) {
    printf("Error! Relative accuracy (cos) is %.2f\n",MaxRMScos);
    return 1;
  }
  else {
    printf("Relative accuracy (cos) is %.2f\n",MaxRMScos);
  }

  return 0;
}
