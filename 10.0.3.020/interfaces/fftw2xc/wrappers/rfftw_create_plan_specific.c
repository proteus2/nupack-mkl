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
!   function    : rfftw_create_plan_specific - wrapper for interface FFTW function
!   Content     : wrapper returns NULL because there is no
!               : the same implementation of REAL DFT in MKL
!   output data : plan address or NULL
!*******************************************************************************
*/

#include "rfftw.h"
#include "fftw2_mkl.h"

rfftw_plan rfftw_create_plan_specific(int n, fftw_direction dir, int flags,
									  fftw_real *in, int istride,
									  fftw_real *out, int ostride) {

    return NULL;
}
