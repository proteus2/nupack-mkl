/*******************************************************************************
!                             INTEL CONFIDENTIAL
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
!   Content:
!          MKL DFTI implementation through FFTW interface (via wrappers) example
!          program (C-interface)
!
!   Forward-Backward 3D complex transform for double precision data not inplace.
!
!   Configuration parameters:
!           DFTI_FORWARD_DOMAIN = DFTI_COMPLEX          (obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE           (obligatory)
!           DFTI_DIMENSION      = 3                     (obligatory)
!           DFTI_LENGTHS        = {m, n, k}             (obligatory)
!           DFTI_PLACEMENT      = DFTI_INPLACE          (default=DFTI_INPLACE)
!           DFTI_INPUT_STRIDES  = {0, N_MAX, 1}         (default = {0,n,1})
!           DFTI_FORWARD_SCALE  = 1.0                   (default)
!           DFTI_BACKWARD_SCALE = 1.0/(double)(m*n*k)   (default=1.0)
!
!   Other default configuration parameters are in the mkl_dfti.h interface file
!******************************************************************************/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "fftw3.h"

#include "mkl_dfti_examples.h"

int main()  /* COMPLEX_3D_DOUBLE_EX1 */
{
    /*
    /   DFT input parameters
    */
    int rank = 3;
    long     m;
    long     n;
    long     k;
    fftw_plan Desc_Handle;
    fftw_complex x_in[M_MAX][N_MAX][K_MAX];
    	/* */
    fftw_complex x_exp[M_MAX][N_MAX][K_MAX];
    double   Scale;
    double   maxerr;
    double   eps = DOUBLE_EPS;
    int nn[3] = {M_MAX, N_MAX, K_MAX};
    /*
    /  Put transform parameters
    */
    m = M_MAX;
    n = N_MAX;
    k = K_MAX;

    if(LEGEND_PRINT) {
        printf(" \n\n COMPLEX_3D_DOUBLE_EX1  \n");
        printf(" Forward-Backward 3D complex transform for double precision data\n\n");
        printf(" Configuration parameters:                  \n\n");
        printf(" DFTI_FORWARD_DOMAIN = DFTI_COMPLEX         \n");
        printf(" DFTI_PRECISION      = DFTI_DOUBLE          \n");
        printf(" DFTI_DIMENSION      = 3                    \n");
        printf(" DFTI_LENGTHS        = {%d,%d,%d)           \n", m, nn[1], k);
        printf(" DFTI_PLACEMENT      = DFTI_INPLACE     \n");
        printf(" DFTI_INPUT_STRIDES  = {0, %d, 1}           \n", N_MAX);
        printf(" DFTI_FORWARD_SCALE  = 1.0                  \n");
        printf(" DFTI_BACKWARD_SCALE = 1.0/(double)(m*n*k)  \n\n");
    }

    /*
    /   Check test input parameters
    */
    if((m*nn[1]*k) > (M_MAX*N_MAX*K_MAX)) {
        printf(" Error input parameters: (m*n*k)>(M_MAX*N_MAX*K_MAX)\n");
        printf(" Please see mkl_dfti_examples.h file\n");
        printf(" TEST FAIL\n");  goto END_OF_TEST;
    }

    /*
    /   put input data and expected result
    */
    zero_init_z(x_in,  M_MAX*N_MAX*K_MAX);

    init_multiple_columns_z(x_in, m, nn[1], 0, N_MAX);

    cblas_zcopy(M_MAX*N_MAX*K_MAX, x_in, 1, x_exp, 1);

    /*
    /   Create Dfti descriptor for 3D double precision forward transform
    */
    Desc_Handle = fftw_plan_dft_3d(nn[0], nn[1], nn[2], &x_in, &x_in, FFTW_FORWARD, FFTW_ESTIMATE);
    /*
    /   Compute DFT
    */
    fftw_execute(Desc_Handle);
    /*
    /   Destroy Dfti descriptor
    */
    fftw_destroy_plan(Desc_Handle);

    /*
    /   Set Scale number for Backward transform
    */
    Scale = 1.0/((double)(M_MAX*N_MAX*K_MAX));
    /*
    /   Create Dfti descriptor for 3D double precision backward transform
    */
    Desc_Handle = fftw_plan_dft_3d(nn[0], nn[1], nn[2], &x_in, &x_in, FFTW_BACKWARD, FFTW_ESTIMATE);
    /*
    /   Compute DFT
    */
    fftw_execute(Desc_Handle);
    /*
    /   Destroy Dfti descriptor
    */
    fftw_destroy_plan(Desc_Handle);
    /*
    /   Result scaling
    */
    scaling_d(x_in, Scale, M_MAX*N_MAX*K_MAX);

    /*
    /   Check result
    */
    maxerr = check_result_z(x_in, x_exp, M_MAX*N_MAX*K_MAX);
    if(ACCURACY_PRINT)
    printf("\n ACCURACY = %g\n\n", maxerr);

    if(maxerr < eps){
        printf(" TEST PASSED\n");
    } else {
        printf(" TEST FAIL\n");
    }
END_OF_TEST:
    return 0;
}
