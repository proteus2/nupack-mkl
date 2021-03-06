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
!    vslsConvExec1D  Example Program Text
!******************************************************************************/

#include "mkl_vsl.h"

#include <stdio.h>

#define XSHAPE 100
#define YSHAPE 1000
#define ZSHAPE (XSHAPE-1)+(YSHAPE-1)+1

int main()
{
    VSLConvTaskPtr task;
    MKL_INT mode,xshape,yshape,zshape;
    static float x[XSHAPE],y[YSHAPE],z[ZSHAPE];
    MKL_INT xstride=1,ystride=1,zstride=1;
    int status,ok,i;

    xshape=XSHAPE;
    yshape=YSHAPE;
    zshape=ZSHAPE;

    for (i=0; i<xshape; i++)
        x[i] = 0;
    for (i=0; i<yshape; i++)
        y[i] = 0;

    ok = 1;
    printf("EXAMPLE executing a convolution task\n");

    mode = VSL_CONV_MODE_AUTO;
    vslsConvNewTask1D(&task,mode,xshape,yshape,zshape);

    status = vslsConvExec1D(task,x,xstride,y,ystride,z,zstride);

    if (status != VSL_STATUS_OK) {
        printf("ERROR: bad status: %d\n",status);
        ok = 0;
    }

    for (i=0; i<zshape; i++)
        if (z[i] != 0) {
            printf("ERROR: wrong result: z[%d]=%g\n",i,z[i]);
            ok = 0;
        }

    printf("EXAMPLE %s\n", ok? "PASSED": "FAILED");
    return !ok;
}
