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
!    vslCorrSetDecimation  Example Program Text
!******************************************************************************/

#include "mkl_vsl.h"

#include <stdio.h>

int main()
{
    VSLCorrTaskPtr task;
    int status,ok;
    MKL_INT mode,rank,xshape,yshape,zshape,decimation;

    ok = 1;
    printf("EXAMPLE setting decimation parameter\n");

    mode = VSL_CORR_MODE_AUTO;
    rank = 1;
    xshape = 100;
    yshape = 1000;
    zshape = (xshape-1) + (yshape-1) + 1;
    vslsCorrNewTask(&task,mode,rank,&xshape,&yshape,&zshape);

    decimation = 1;
    status = vslCorrSetDecimation(task,&decimation);

    if (status != VSL_STATUS_OK) {
        printf("ERROR: bad status: %d\n",status);
        ok = 0;
    }

    printf("EXAMPLE %s\n", ok? "PASSED": "FAILED");
    return !ok;
}
