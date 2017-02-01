/*******************************************************************************
!                              INTEL CONFIDENTIAL
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
!   function    : rfftwnd_real_to_complex - interface FFTW computation function
!   Content     : wrapper from this function to DFTI MKL computation functions
!                 for double/float precision real data
!   input data  : pointer to FFTW plan
!*******************************************************************************
*/

#include "rfftw.h"
#include "fftw2_mkl.h"

void rfftwnd_real_to_complex(rfftwnd_plan plan, int howmany,
							 fftw_real* in, int istride, int idist,
							 fftw_complex* out, int ostride, int odist) {
    MKL_LONG Status;
	int rank;
	MKL_LONG strides[8];
	int i, odist_t;
	int commit = 0;
	MKL_LONG* nn;
    fftw_plan_mkl*  fftw_desc_mkl;

    fftw_desc_mkl = (fftw_plan_mkl*)plan;

	rank = fftw_desc_mkl->rank;
	nn = fftw_desc_mkl->n;

	if ( howmany != 1 ) {

		commit = 1;

		Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_NUMBER_OF_TRANSFORMS, (MKL_LONG)howmany);
        if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
            Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
            free(fftw_desc_mkl);
            return;
		}

        Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_INPUT_DISTANCE, (MKL_LONG)idist);
        if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
            Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
            free(fftw_desc_mkl);
            return;
		}

		if (! (fftw_desc_mkl->inplace)) {
            Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_OUTPUT_DISTANCE, (MKL_LONG)odist);
            if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
                Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
                free(fftw_desc_mkl);
                return;
			}
		} else {
			if (idist == 1 && idist < istride) {
				odist_t = 1;
			} else {
			    odist_t = idist / 2;
			}
            Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_OUTPUT_DISTANCE, (MKL_LONG)odist_t);
            if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
                Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
                free(fftw_desc_mkl);
                return;
			}
		}
	}

	if ( istride != 1 || fftw_desc_mkl->istride != istride ) {
		commit = 1;
	    strides[0] = 0;
		strides[rank] = (MKL_LONG)istride;
		for (i = rank-1; i>0; i--) {
			if (i == rank-1 && fftw_desc_mkl->inplace) {
		        strides[i] = 2 *(nn[i]/2+1) * strides[i+1];
			} else {
		        strides[i] = nn[i] * strides[i+1];
			}
		}

        Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_INPUT_STRIDES, strides);
        if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
            Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
            free(fftw_desc_mkl);
            return;
		}
        if (fftw_desc_mkl->inplace) {
	        strides[0] = 0;
		    strides[rank] = (MKL_LONG)istride;
			for (i = rank-1; i>0; i--) {
			    strides[i] = strides[i] / 2;
			}

            Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_OUTPUT_STRIDES, strides);
            if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
                Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
                free(fftw_desc_mkl);
                return;
			}
		}
	}


	if	(!(fftw_desc_mkl->inplace) && (ostride != 1 || fftw_desc_mkl->ostride != ostride) )  {
		commit = 1;
        strides[0] = 0;
		strides[rank] = (MKL_LONG)ostride;
		strides[rank-1] = (nn[rank-1]/2+1) * (MKL_LONG)ostride;
		for (i = rank-2; i>0; i--) {
		    strides[i] = nn[i] * strides[i+1];
		}

        Status = DftiSetValue( fftw_desc_mkl->mkl_desc, DFTI_OUTPUT_STRIDES, strides);
        if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
            Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
            free(fftw_desc_mkl);
            free(nn);
            return;
		}
	}

    if (commit == 1) {
        Status = DftiCommitDescriptor(fftw_desc_mkl->mkl_desc);
        if (! DftiErrorClass(Status, DFTI_NO_ERROR)) {
            free(fftw_desc_mkl);
            Status = DftiFreeDescriptor(&(fftw_desc_mkl->mkl_desc));
            return;
        }
	}

	if (fftw_desc_mkl->inplace) {
        Status = DftiComputeForward( fftw_desc_mkl->mkl_desc, (TYPE_PRECISION*)in);
	} else {
        Status = DftiComputeForward( fftw_desc_mkl->mkl_desc, (TYPE_PRECISION*)in,
			                         (TYPE_PRECISION*)out);
	}
    return;
}
