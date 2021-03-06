/*******************************************************************************
!                             INTEL CONFIDENTIAL
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
!
!*******************************************************************************
!   Content:
!          MKL DFTI implementation through FFTW interface (via wrappers) example
!          program (C-interface)
!
!   Real 1D transform for double/float precision data inplace.
!
!   Configuration parameters for MKL DFTI:
!           DFTI_FORWARD_DOMAIN = DFTI_REAL   (obligatory)
!           DFTI_PRECISION      = DFTI_DOUBLE/DFTI_SINGLE    (obligatory)
!           DFTI_DIMENSION      = 1              (obligatory)
!           DFTI_LENGTHS        = n              (obligatory)
!           DFTI_PLACEMENT      = DFTI_NOT_INPLACE   (default)
!           DFTI_FORWARD_SCALE  = 1.0            (default)
!           DFTI_BACKWARD_SCALE = 1.0/(double/float)n  (default=1.0)
!
!  Other default configuration parameters are in the mkl_dfti.h interface file
!******************************************************************************/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "rfftw.h"

#include "mkl_dfti_examples.h"

int main()  /* REAL_1D_EX6 */
{
    /*
    /   DFT input parameters
    */
    int  n=4;
	int rank = 1;
	int multiple = 5;
	int istride = 5;
	int idist = 1;
	int ostride = 6;
	int odist = 1;
    rfftwnd_plan Desc_Handle;
    rfftwnd_plan Desc_Handle_out;
    fftw_real* x_in;
    fftw_complex* x_out;
	fftw_direction dir;
    /* */
    fftw_real* x_exp;
    TYPE_PRECISION  Scale;
    TYPE_PRECISION  maxerr;
    TYPE_PRECISION  eps= EPS;
	int nn, lda, lda_out, i;

    if(LEGEND_PRINT) {
        printf(" \n\n REAL_1D_EX6 \n");
        printf(" Forward-Backward 1D complex transform for double/float precision data\n\n");
        printf(" Configuration parameters:            \n\n");
        printf(" DFTI_FORWARD_DOMAIN = DFTI_REAL   \n");
        printf(" DFTI_PRECISION      = DFTI_DOUBLE/DFTI_SINGLE    \n");
        printf(" DFTI_DIMENSION      = 1              \n");
        printf(" DFTI_LENGTHS        = %d             \n", n);
        printf(" DFTI_PLACEMENT      = DFTI_INPLACE   \n");
        printf(" DFTI_FORWARD_SCALE  = 1.0            \n");
        printf(" DFTI_BACKWARD_SCALE = 1.0/(double/float)n  \n\n");
    }

    /*
    /   Allocate array for input data
    */
    nn = n/2+1;
	lda = n*istride*multiple;
	if (idist > n*istride) lda = idist*multiple;
	lda_out = nn*ostride*multiple;
	if (odist > nn*ostride) lda_out = odist*multiple;

    x_in = (fftw_real*)malloc(lda*sizeof(TYPE_PRECISION));
    x_exp = (fftw_real*)malloc(lda*sizeof(TYPE_PRECISION));
    x_out = (fftw_complex*)malloc(2*lda_out*sizeof(TYPE_PRECISION));
    /*
    /   initialize x_in and copy to expected x_exp
    */
#ifdef MKL_DOUBLE
    zero_init_d(x_in, lda);
    init_real_vectors_d(x_in, lda);
    cblas_dcopy(lda, x_in, 1, x_exp, 1);
#else
    zero_init_s(x_in, lda);
    init_real_vectors_s(x_in, lda);
    cblas_scopy(lda, x_in, 1, x_exp, 1);
#endif

   /*
    /   Create Dfti descriptor for 1D double precision forward transform
    */
    Desc_Handle = rfftwnd_create_plan( rank, &n, FFTW_REAL_TO_COMPLEX, FFTW_ESTIMATE);
    /*
    /   Compute DFT
    */
    rfftwnd_real_to_complex(Desc_Handle, multiple, x_in, istride, idist, x_out, ostride, odist);

	/*
    /   Destroy Dfti descriptor
    */
    rfftwnd_destroy_plan(Desc_Handle);

   /*
    /   Set Scale number for Backward transform
    */
    Scale = 1.0/(TYPE_PRECISION)n;
    /*
    /   Create Dfti descriptor for 1D double precision backward transform
    */
    Desc_Handle = rfftwnd_create_plan(rank, &n, FFTW_COMPLEX_TO_REAL, FFTW_ESTIMATE);
    /*
    /   Compute DFT
    */
	rfftwnd_complex_to_real(Desc_Handle, multiple, x_out, ostride, odist, x_in, istride, idist);

    /*
    /   Destroy Dfti descriptor
    */
    rfftwnd_destroy_plan(Desc_Handle);
    /*
    /   Result scaling
    */
   scaling_r_multiple(x_in, Scale, n, multiple, istride, idist);

    /*
    /   Check result
    */
    maxerr = check_result_multiple(x_in, x_exp, n, multiple, istride, idist);
    if(ACCURACY_PRINT)
        printf("\n ACCURACY = %g\n\n", maxerr);

    if(maxerr < eps){
        printf(" TEST PASSED\n");
    } else {
        printf(" TEST FAIL\n");
    }

    free(x_exp);
    free(x_in);
    free(x_out);

    return 0;
}
