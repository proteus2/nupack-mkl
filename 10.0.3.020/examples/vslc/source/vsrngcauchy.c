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
!    vsRngCauchy  Example Program Text
!******************************************************************************/

#include <stdio.h>

#include "mkl_vsl.h"
#include "errcheck.inc"

#define SEED    777
#define BRNG    VSL_BRNG_R250
#define METHOD  0
#define N       1000
#define NN      10

main()
{
    float r[N];
    VSLStreamStatePtr stream;
    int i, errcode;
    float a=0.0,beta=1.0;

    /***** Initialize *****/
    errcode = vslNewStream( &stream, BRNG,  SEED );
    CheckVslError( errcode );

    /***** Call RNG *****/
    errcode = vsRngCauchy( METHOD, stream, N, r, a, beta );
    CheckVslError( errcode );

    /***** Printing results *****/
    printf("Sample of vsRngCauchy.\n");
    printf("----------------------\n\n");
    printf("Parameters:\n");
    printf("    a=%.4f\n",a);
    printf("    beta=%.4f\n\n",beta);

    printf("Results (first 10 of 1000):\n");
    printf("---------------------------\n");
    for(i=0;i<NN;i++) {
        printf("r[%d]=%.4f\n",i,r[i]);
    }

    printf("\n");

    /***** Deinitialize *****/
    errcode = vslDeleteStream( &stream );
    CheckVslError( errcode );

    return 0;
}
