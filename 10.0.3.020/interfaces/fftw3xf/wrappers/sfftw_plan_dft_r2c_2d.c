/*******************************************************************************
!                              INTEL CONFIDENTIAL
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
!   function    : sfftw_plan_dft_r2c_2d - wrapper for interface FFTW function
!   Content     : wrapper returns NULL because there is no the same implementation
!               : of 2D REAL DFT in MKL
!   output data : NULL
!*******************************************************************************
*/

#include "fftw3.h"
#include "fftw3_mkl.h"

void sfftw_plan_dft_r2c_2d(fftwf_plan* plan, int* nx, int* ny, float *in, fftwf_complex *out,
						   unsigned* flags) {

    *plan = fftwf_plan_dft_r2c_2d(*ny, *nx, in, out, *flags);
    return;
}
