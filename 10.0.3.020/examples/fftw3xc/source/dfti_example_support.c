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
!       MKL DFTI interface example program (C-interface)
!
!       Examples support function set
!
!******************************************************************************/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include "mkl_dfti_examples.h"

/*
/   initialize x_in and copy to expected x_exp
*/

int init_input_and_expected_vectors_c(void* x_init, void* res_exp, long n)
{
    float* x_in  = x_init;
    float* x_exp = res_exp;

    long    i;
    float   step, step0;
    /*
    /   put input data into X(1),...,X(n)
    */
    step = -MATH_PI;
    step0 = (2.0*MATH_PI)/(float)n;
    step = step + step0;
    for (i = 0; i < n; i++) {
        x_in[2*i]   = sin(step)*sqrt(3.0)/(float)2;
        x_in[2*i+1] = sin(step)/sqrt(3.0);
        step = step + step0;
    }

    /*
    /   put expected data into X_EXP(1),...,X_EXP(n)
    */
    for (i = 0; i < n; i++){
        x_exp[2*i]   = x_in[2*i];
        x_exp[2*i+1] = x_in[2*i+1];
    }
    return 0;
}/* init_input_and_expected_vectors_c */

int init_input_and_expected_vectors_z(void* x_init, void* res_exp, long n)
{
    double* x_in  = x_init;
    double* x_exp = res_exp;

    long    i;
    double   step, step0;
    /*
    /   put input data into X(1),...,X(n)
    */
    step = -MATH_PI;
    step0 = (2.0*MATH_PI)/(double)n;
    step = step + step0;
    for (i = 0; i < n; i++) {
        x_in[2*i]   = sin(step)*sqrt(3.0)/(double)2;
        x_in[2*i+1] = sin(step)/sqrt(3.0);
        step = step + step0;
    }

    /*
    /   put expected data into X_EXP(1),...,X_EXP(n)
    */
    for (i = 0; i < n; i++){
        x_exp[2*i]   = x_in[2*i];
        x_exp[2*i+1] = x_in[2*i+1];
    }
    return 0;
}/* init_input_and_expected_vectors_z */

int init_real_vectors_s(void* x, long n)
{
    float*  x_in = x;
    long    i;
    float   step;

    /*
    /   put input data into X(1),...,X(n)
    */
    for (i = 0; i < n; i++) {
          step  = (float)(i+1);
          x_in[i] = sin(step)*sqrt(3.0)/(float)2;
    }
    return 0;
}/* init_real_vectors_s */

int init_real_vectors_d(void* x, long n)
{
    double* x_in = x;
    long    i;
    double  step;

    /*
    /   put input data into X(1),...,X(n)
    */
    for (i = 0; i < n; i++) {
          step  = (double)(i+1);
          x_in[i] = sin(step)*sqrt(3.0)/(double)2;
    }
    return 0;
}/* init_real_vectors_d */

int zero_init_c(void* x, long n)
{
    float*  x_in = x;
    long    i;

    for (i = 0; i < n; i++) {
            x_in[2*i]   = 0.0;
            x_in[2*i+1] = 0.0;
    }/* for i */

    return 0;
}/* zero_init_c */

int zero_init_z(void* x, long n)
{
    double* x_in = x;
    long    i;

    for (i = 0; i < n; i++) {
            x_in[2*i]   = 0.0;
            x_in[2*i+1] = 0.0;
    }/* for i */

    return 0;
}/* zero_init_z */


int zero_init_s(void* x, long n)
{
    float*  x_in = x;
    long    i;
    for (i = 0; i < n; i++)
        x_in[i] = 0.0;
    return 0;
}/* zero_init_s */

int zero_init_d(void* x, long n)
{
    double*  x_in = x;
    long    i;
    for (i = 0; i < n; i++)
        x_in[i] = 0.0;
    return 0;
}/* zero_init_d */

int init_multiple_columns_c(void* x, long n, long multiple,
                             long first_index, long step_x)
{
    float*  x_in = x;
    float   step;
    long    i, j;

    x_in += 2*first_index;

    for (i = 0; i < multiple; i++) {
        for (j = 0; j < n; j++) {
            step = (float)(i+1)*(float)(i+j+1);
            x_in[2*j*step_x]   = sin(step)*sqrt(3.0)/(float)2;
            x_in[2*j*step_x+1] = sin(step)/sqrt(3.0);
        }
        x_in += 2;
    }/* for i */
    return 0;
}/* init_multiple_columns_c */

int init_3d_columns_c(void* x, long m, long n, long k,
                       long* strides)
{
    float*  x_2d = x;
    float*  x_in;
    float   step;
    long    i, j, l;

    long    first_index;
    long    step_m, step_n, step_k;

    first_index = 2*strides[0];
    step_m      = 2*strides[1];
    step_n      = 2*strides[2];
    step_k      = 2*strides[3];

    x_2d += first_index;
    for (l = 0; l < k; l++) {
         x_in = x_2d;
         for (i = 0; i < n; i++) {
            for (j = 0; j < m; j++) {
                step = (float)(l+1)*(float)(i+1)*(float)(i+j+1);
                x_in[j*step_m]   = sin(step)*sqrt(3.0)/(float)2;
                x_in[j*step_m+1] = sin(step)/sqrt(3.0);
             }/* for j */
            x_in += step_n;
        }/* for i */
        x_2d += step_k;
    }/* for l */

    return 0;
}/* init_3d_columns_c */

int init_3d_columns_z(void* x, long m, long n, long k,
                       long* strides)
{
    double* x_2d = x;
    double* x_in;
    double  step;
    long    i, j, l;
    long    first_index;
    long    step_m, step_n, step_k;

    first_index = 2*strides[0];
    step_m      = 2*strides[1];
    step_n      = 2*strides[2];
    step_k      = 2*strides[3];

    x_2d += first_index;
    for (l = 0; l < k; l++) {
         x_in = x_2d;
         for (i = 0; i < n; i++) {
            for (j = 0; j < m; j++) {
                step = (float)(l+1)*(float)(i+1)*(float)(i+j+1);
                x_in[j*step_m]   = sin(step)*sqrt(3.0)/(float)2;
                x_in[j*step_m+1]   = sin(step)/sqrt(3.0);
            }
            x_in += step_n;
        }/* for i */
        x_2d += step_k;
    }/* for l */

    return 0;
}/* init_3d_columns_z */

int init_multiple_columns_z(void* x, long n, long multiple,
                             long first_index, long step_x)
{
    double*  x_in = x;
    double   step;
    long    i, j, index;

    x_in += 2*first_index;
    for (i = 0; i < multiple; i++) {
        for (j = 0; j < n; j++) {
            step = (double)(i+j+1);
            x_in[2*j*step_x]   = sin(step)*sqrt(3.0)/(double)2;
            x_in[2*j*step_x+1] = sin(step)/sqrt(3.0);
        }
        x_in += 2;
    }/* for i */
    return 0;
}/* init_multiple_columns_z */

 /*
/   Check result
*/

float check_result_c(void* x, void* res_exp, long n)
{
    float* x_in = x;
    float* x_exp  = res_exp;

    float  maxerr, d;
    long     i;

    maxerr = 0;
    for (i = 0; i < n; i++){
        d = x_exp[2*i]   - x_in[2*i];   if (d < 0) d = -d; if (d > maxerr) maxerr = d;
        d = x_exp[2*i+1] - x_in[2*i+1]; if (d < 0) d = -d; if (d > maxerr) maxerr = d;
    }/* for i */

    return maxerr;
}/* check_result_c */


double check_result_z(void* x, void* res_exp, long n)
{
    double* x_in = x;
    double* x_exp  = res_exp;

    double  maxerr, d;
    long     i;

    maxerr = 0;
    for (i = 0; i < n; i++){
        d = x_exp[2*i]   - x_in[2*i];   if (d < 0) d = -d; if (d > maxerr) maxerr = d;
        d = x_exp[2*i+1] - x_in[2*i+1]; if (d < 0) d = -d; if (d > maxerr) maxerr = d;
    }/* for i */

    return maxerr;
}/* check_result_z */

float check_result_s(void* x, void* y, long n)
{
    float*  x_in  = x;
    float*  x_exp = y;
    float   maxerr, d;
    long    i;

    maxerr = 0;
    for (i = 0; i < n; i++){
        d = x_exp[i] - x_in[i];
        if (d < 0) d = -d; if (d > maxerr) maxerr = d;
    }
    return maxerr;
}/* check_result_s */

double check_result_d(void* x, void* y, long n)
{
    double* x_in = x;
    double*  x_exp = y;
    double  maxerr, d;
    long    i;

    maxerr = 0;
    for (i = 0; i < n; i++){
        d = x_exp[i] - x_in[i];
        if (d < 0) d = -d; if (d > maxerr) maxerr = d;
    }
    return maxerr;
}/* check_result_d */

void scaling_d(void* xx, double Scale, int n) {
    int i;
    double* x_in;

    x_in = (double*)xx;

    for (i=0; i<2*n; i++) {

        x_in[i] = x_in[i]*Scale;
    }
    return;
}
void scaling_dr(void* xx, double Scale, int n) {
    int i;
    double* x_in;

    x_in = (double*)xx;

    for (i=0; i<n; i++) {

        x_in[i] = x_in[i]*Scale;
    }
    return;
}
void scaling_f(void* xx, float Scale, int n) {
    int i;
    float* x_in;

    x_in = (float*)xx;

    for (i=0; i<2*n; i++) {

        x_in[i] = x_in[i]*Scale;
    }
    return;
}
void scaling_fr(void* xx, float Scale, int n) {
    int i;
    float* x_in;

    x_in = (float*)xx;

    for (i=0; i<n; i++) {

        x_in[i] = x_in[i]*Scale;
    }
    return;
}

void scaling_dr_multiple(void* xx, double Scale,
					  int n, int multiple, int istride, int idist) {
    int i, j, id, is;
    double* x_in;

    x_in = (double*)xx;
	id = 0;
	for (i=0; i<multiple; i++) {
		for (j=0; j<n; j++) {
			is = id+j*istride;
			x_in[is] = x_in[is]*Scale;
		}
        id = id + idist;
	}
	return;
}

void scaling_dr_3d_multiple(void* xx, double Scale,
					  int* nn, int multiple, int* stride, int idist) {
    int i, j, id, is, k, s, p;
    double* x_in;

    x_in = (double*)xx;
	id = 0;
	for (i=0; i<multiple; i++) {
		for (p=0; p<nn[0]; p++) {
		    for (s=0; s<nn[1]; s++) {
		        for (j=0; j<nn[2]; j++) {
			    is = id + j*stride[2] + s*stride[1] + p*stride[0];
			    x_in[is] = x_in[is]*Scale;
				}
			}
		}
        id = id + idist;
	}
	return;
}

int init_3d_columns_s(void* x, long m, long n, long k,
                       long* strides)
{
    float*  x_2d = x;
    float*  x_in;
    float   step;
    long    i, j, l;

    long    first_index;
    long    step_m, step_n, step_k;

    first_index = strides[0];
    step_m      = strides[1];
    step_n      = strides[2];
    step_k      = strides[3];

    x_2d += first_index;
    for (l = 0; l < k; l++) {
         x_in = x_2d;
         for (i = 0; i < n; i++) {
            for (j = 0; j < m; j++) {
                step = (float)(l+1)*(float)(i+1)*(float)(i+j+1);
                x_in[j*step_m]   = sin(step)*sqrt(3.0)/(float)2;
             }/* for j */
            x_in += step_n;
        }/* for i */
        x_2d += step_k;
    }/* for l */

    return 0;
}/* init_3d_columns_s */

int init_3d_columns_d(void* x, long m, long n, long k,
                       long* strides)
{
    double*  x_2d = x;
    double*  x_in;
    double   step;
    long    i, j, l;

    long    first_index;
    long    step_m, step_n, step_k;

    first_index = strides[0];
    step_m      = strides[1];
    step_n      = strides[2];
    step_k      = strides[3];

    x_2d += first_index;
    for (l = 0; l < k; l++) {
         x_in = x_2d;
         for (i = 0; i < n; i++) {
            for (j = 0; j < m; j++) {
                step = (double)(l+1)*(double)(i+1)*(double)(i+j+1);
                x_in[j*step_m]   = sin(step)*sqrt(3.0)/(double)2;
             }/* for j */
            x_in += step_n;
        }/* for i */
        x_2d += step_k;
    }/* for l */

    return 0;
}/* init_3d_columns_d */

int init_3d_columns_d_multiple(void* x, long m, long n, long k,
                       long* strides, long multiple, long dist)
{
    double*  x_2d = x;
    double*  x_in;
    double   step;
    long    i, j, l, im;

    long    first_index;
    long    step_m, step_n, step_k;

    first_index = strides[0];
    step_m      = strides[1];
    step_n      = strides[2];
    step_k      = strides[3];

    x_2d += first_index;
	for (im=0; im<multiple; im++) {
        for (l = 0; l < k; l++) {
             x_in = x_2d;
             for (i = 0; i < n; i++) {
                for (j = 0; j < m; j++) {
                    step = (double)(l+1)*(double)(i+1)*(double)(i+j+1);
                    x_in[im*dist + j*step_m]   = sin(step)*sqrt(3.0)/(double)2;
                 }/* for j */
                x_in += step_n;
            }/* for i */
            x_2d += step_k;
        }/* for l */
	}

    return 0;
}/* init_3d_columns_d_multiple */

void scaling_2d_d(double* x_in, double Scale, int m, int n)
{

    int i, j, nf;

	nf = n+2-n%2;

	for (j = 0; j < m; j++)
	{
		for (i = 0; i < n; i++)
		{
			x_in[i+j*nf] *= Scale;
		}
	}
	return;
}/* scaling_2d_d */

void scaling_2d_f(float* x_in, float Scale, int m, int n)
{

    int i, j, nf;

	nf = 2*(n/2+1);

	for (j = 0; j < m; j++)
	{
		for (i = 0; i < n; i++)
		{
			x_in[i+j*nf] *= Scale;
		}
	}
	return;
}/* scaling_2d_f */

void scaling_2d_d_multiple(double* x_in, double Scale, int m, int n,
						   int multiple, long* stride, int dist) {
    int i, j, nf, im;

	for (im = 0; im < multiple; im++)
	{
		for (j = 0; j < m; j++)
		{
			for (i = 0; i < n; i++)
			{
				nf = i*stride[2] + j*stride[1];
				x_in[im*dist + nf] *= Scale;
			}
		}
	}
	return;
}/* scaling_2d_d_multiple */

void scaling_2d_f_multiple(float* x_in, float Scale, int m, int n,
						   int multiple, long* stride, int dist) {
    int i, j, nf, im;

	for (im = 0; im < multiple; im++)
	{
		for (j = 0; j < m; j++)
		{
			for (i = 0; i < n; i++)
			{

				nf = i*stride[2] + j*stride[1];
				x_in[im*dist + nf] *= Scale;
			}
		}
	}
	return;
}/* scaling_2d_f_multiple */

void scaling_3d_d(double* x_in, double Scale, int m, int n, int k)
{

    int i, j, nf, s, nf1;

	nf = 2*(k/2+1);
	nf1 = 2*(k/2+1)*n;

	for (s = 0; s < m; s++) {
		for (j = 0; j < n; j++)
		{
			for (i = 0; i < k; i++)
			{
				x_in[i+j*nf+s*nf1] *= Scale;
			}
		}
	}
	return;
}/* scaling_3d_d */

void scaling_3d_f(float* x_in, float Scale, int m, int n, int k)
{

    int i, j, nf, s, nf1;

	nf = 2*(k/2+1);
	nf1 = 2*(k/2+1)*n;

	for (s = 0; s < m; s++) {
		for (j = 0; j < n; j++)
		{
			for (i = 0; i < k; i++)
			{
				x_in[i+j*nf+s*nf1] *= Scale;
			}
		}
	}
	return;
}/* scaling_3d_f */

void scaling_3d_d_multiple(double* x_in, double Scale, int m, int n, int k,
						   int multiple, long* stride, int dist) {

    int i, j, nf, s, nf1, im;

	for (im = 0; im < multiple; im++) {
		for (s = 0; s < m; s++) {
			for (j = 0; j < n; j++)
			{
				for (i = 0; i < k; i++)
				{
					nf = i*stride[3] + j*stride[2] + s*stride[1];
					x_in[im*dist + nf] *= Scale;
				}
			}
		}
	}
	return;
}/* scaling_3d_d_multiple */

void scaling_3d_f_multiple(float* x_in, float Scale, int m, int n, int k,
						   int multiple, long* stride, int dist) {

    int i, j, nf, s, nf1, im;

	for (im = 0; im < multiple; im++) {
		for (s = 0; s < m; s++) {
			for (j = 0; j < n; j++)
			{
				for (i = 0; i < k; i++)
				{
					nf = i*stride[3] + j*stride[2] + s*stride[1];
					x_in[im*dist + nf] *= Scale;
				}
			}
		}
	}
	return;
}/* scaling_3d_f_multiple */

double check_result_2d_d(double* x_in, double* x_exp, int m, int n)
{
    double  maxerr = 0, d = 0;
    long    i = 0, j = 0, nf = 0;

	nf = 2*(n/2+1);

	for (j = 0; j < m; j++)
	{
		for (i = 0; i < n; i++)
		{
	        d = x_exp[i+j*nf] - x_in[i+j*nf];
	        if (d < 0) d = -d;
			if (d > maxerr) maxerr = d;
		}
	}
return maxerr;
}/* check_result_2d_d */

double check_result_2d_d_multiple(double* x_in, double* x_exp, int m, int n,
										  int multiple, long* stride, int idist)
{
    double maxerr = 0, d = 0;
    int  i, j, nf, im;

	for (im = 0; im < multiple; im++)
	{
		for (j = 0; j < m; j++)
		{
			for (i = 0; i < n; i++)
			{
				nf = i*stride[2] + j*stride[1];
		        d = x_exp[im*idist + nf] - x_in[im*idist + nf];
		        if (d < 0) d = -d;
				if (d > maxerr) maxerr = d;
			}
		}
	}
    return maxerr;
}/* check_result_2d_d_multiple */

float check_result_2d_f_multiple(float* x_in, float* x_exp, int m, int n,
										  int multiple, long* stride, int idist)
{
    float  maxerr = 0, d = 0;
    int  i, j, nf, im;

	for (im = 0; im < multiple; im++)
	{
		for (j = 0; j < m; j++)
		{
			for (i = 0; i < n; i++)
			{
				nf = i*stride[2] + j*stride[1];
		        d = x_exp[im*idist + nf] - x_in[im*idist + nf];
		        if (d < 0) d = -d;
				if (d > maxerr) maxerr = d;
			}
		}
	}
    return maxerr;
}/* check_result_2d_f_multiple */

double check_result_3d_d(double* x_in, double* x_exp, int m, int n, int k)
{
    double  maxerr = 0, d = 0;
    int  i, j, nf, s, nf1;

	nf = 2*(k/2+1);
	nf1 = 2*(k/2+1)*n;

	for (s = 0; s < m; s++)
	{
		for (j = 0; j < n; j++)
		{
			for (i = 0; i < k; i++)
			{
		        d = x_exp[i+j*nf+s*nf1] - x_in[i+j*nf+s*nf1];
		        if (d < 0) d = -d;
				if (d > maxerr){
					maxerr = d;
				}
			}
		}
	}
    return maxerr;
}/* check_result_3d_d */

float check_result_3d_f(float* x_in, float* x_exp, int m, int n, int k)
{
    float  maxerr = 0, d = 0;
    int  i, j, nf, s, nf1;

	nf = 2*(k/2+1);
	nf1 = 2*(k/2+1)*n;

	for (s = 0; s < m; s++)
	{
		for (j = 0; j < n; j++)
		{
			for (i = 0; i < k; i++)
			{
		        d = x_exp[i+j*nf+s*nf1] - x_in[i+j*nf+s*nf1];
		        if (d < 0) d = -d;
				if (d > maxerr){
					maxerr = d;
				}
			}
		}
	}
    return maxerr;
}/* check_result_3d_f */

double check_result_3d_d_multiple(double* x_in, double* x_exp, int m, int n, int k,
										  int multiple, long* stride, int idist)
{
    double maxerr = 0, d = 0;
    int  i, j, nf, s, nf1, im;

	for (im = 0; im < multiple; im++) {
		for (s = 0; s < m; s++) {
			for (j = 0; j < n; j++)
			{
				for (i = 0; i < k; i++)
				{
				    nf = i*stride[3] + j*stride[2] + s*stride[1];
		            d = x_exp[im*idist + nf] - x_in[im*idist + nf];
			        if (d < 0) d = -d;
					if (d > maxerr){
						maxerr = d;
					}
				}
			}
		}
	}
    return maxerr;
}/* check_result_3d_d_multiple */

float check_result_3d_f_multiple(float* x_in, float* x_exp, int m, int n, int k,
										  int multiple, long* stride, int idist)
{
    float maxerr = 0, d = 0;
    int  i, j, nf, s, nf1, im;

	for (im = 0; im < multiple; im++) {
		for (s = 0; s < m; s++) {
			for (j = 0; j < n; j++)
			{
				for (i = 0; i < k; i++)
				{
				    nf = i*stride[3] + j*stride[2] + s*stride[1];
		            d = x_exp[im*idist + nf] - x_in[im*idist + nf];
			        if (d < 0) d = -d;
					if (d > maxerr){
						maxerr = d;
					}
				}
			}
		}
	}
    return maxerr;
}/* check_result_3d_f_multiple */

float check_result_2d_f(float* x_in, float* x_exp, int m, int n)
{
    float  maxerr = 0, d = 0;
    long    i = 0, j = 0, nf = 0;

	nf = 2*(n/2+1);

	for (j = 0; j < m; j++)
	{
		for (i = 0; i < n; i++)
		{
	        d = x_exp[i+j*nf] - x_in[i+j*nf];
	        if (d < 0) d = -d;
			if (d > maxerr) maxerr = d;
		}
	}
return maxerr;
}/* check_result_2d_f */

int init_2d_columns_mult_z(void* x, long m, long n, long* strides, long multiple, long dist)
{
	double* x_2d = x;
	double* x_in;
	double  step;
	long    i, j, l;
	long    first_index;
	long    step_m, step_n;

	first_index = 2*strides[0];
	step_m      = 2*strides[1];
	step_n      = 2*strides[2];

	x_2d += first_index;
	for ( j = 0; j < multiple; j++)
	{
		for (l = 0; l < n; l++)
		{
			x_in = x_2d;
		    for (i = 0; i < m; i++)
			{
				step = (float)(l+1)*(float)(i+1)*(float)(i+j+1);
				x_in[i*step_m+(dist+m*j)]   = sin(step)*sqrt(3.0)/(float)2;
				x_in[i*step_m+1+(dist+m*j)] = sin(step)/sqrt(3.0);
			}
			x_2d += step_n;
		}
	}
return 0;
}/* init_2d_columns_mult_z */

int init_2d_columns_z(void* x, long m, long n, long* strides)
{
    double* x_2d = x;
    double* x_in;
    double  step;
    long    i, j, l;
    long    first_index;
    long    step_m, step_n;

    first_index = 2*strides[0];
    step_m      = 2*strides[1];
    step_n      = 2*strides[2];

    x_2d += first_index;
    for (l = 0; l < n; l++)
	{
		x_in = x_2d;
		for (i = 0; i < m; i++)
		{
			step = (float)(l+1)*(float)(i+1)*(float)(i+j+1);
			x_in[i*step_m]   = sin(step)*sqrt(3.0)/(float)2;
			x_in[i*step_m+1]   = sin(step)/sqrt(3.0);
		}
		x_2d += step_n;
	}

    return 0;
}/* init_2d_columns_z */