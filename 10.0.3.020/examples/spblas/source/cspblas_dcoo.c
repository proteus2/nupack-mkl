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
!   Content : MKL Sparse BLAS C example
!
!*******************************************************************************
!
! Example program for using MKL Sparse BLAS Level 2 and 3
! for matrices represented in the coordinate storage scheme.
! The following Sparse  Blas routines are used in the example:
!          MKL_DCOOSM  MKL_DCOOSV  MKL_DCOOMM  MKL_DCOOMV
!          MKL_CSPBLAS_DCOOGEMV    MKL_CSPBLAS_DCOOSYMV
!		   MKL_CSPBLAS_DCOOTRSV.
!
! Consider the matrix A (see Appendix 'Sparse Storage Formats for Sparse Blas
! level 2-3')
!
!                 |   1       -1     -3    0     0   |
!                 |  -2        5      0    0     0   |
!   A    =        |   0        0      4    6     4   |,
!                 |  -4        0      2    7     0   |
!                 |   0        8      0    0    -5   |
!
!
! decomposed as
!
!                      A = L + D + U,
!
!  where L is the strict  lower triangle of A, U is the strictly  upper triangle
!  of A, D is the main diagonal. Namely
!
!        |   0    0   0    0     0   |       |  0   -1   -3    0   0   |
!        |  -2    0   0    0     0   |       |  0    0    0    0   0   |
!   L  = |   0    0   0    0     0   |,  U=  |  0    0    0    6   4   |
!        |  -4    0   2    0     0   |       |  0    0    0    0   0   |
!        |   0    8   0    0     0   |       |  0    0    0    0   0   |
!
!
!           |   1  0  0   0   0   |
!           |   0  5  0   0   0   |
!   D    =  |   0  0  4   0   0   |.
!           |   0  0  0   7   0   |
!           |   0  0  0   0  -5   |
!
!  The matrix A given above is represented in the coordinate storage scheme with the help of three
!  arrays of length nnz=13 (see Appendix 'Sparse Storage Formats for Sparse Blas level 2-3'
!
!          values  = (1 -1 -3 -2 5 4 6 4 -4 2 7 8 -5)
!          rows    = (0  0  0  1 1 2 2 2  3 3 3 4  4)
!          columns = (0  1  2  0 1 2 3 4  0 2 3 1  4)
!
!  In what follows the symbol ' means taking of transposed.
!
!  The test performs the following operations :
!
!       1. The code computes (L+D)'*S = F using MKL_DCOOMM where S is a known 5 by 2
!          matrix and then the code solves the system (L+D)'*X = F with the help of MKL_DCOOSM.
!          It's evident that X should be equal to S.
!
!       2. The code computes (U+I)'*S = F using MKL_DCOOMV where S is a vector
!          and then the code calls MKL_DCOOTRSV solves the system (U+I)'*X = F with the single right
!          hand side. It's evident that X should be equal to S.
!
!       3. The code computes D*S = F using MKL_DCOOMV where S is a vector
!          and then the code solves the system D*X = F with the single right hand side.
!          It's evident that X should be equal to S.
!
!       4. The next step is the computation (U-U') S = F using MKL_DCOOMV where S is
!          a vector. It is easy to see that U-U' is a skew-symmetric matrix.
!
!       5. The next step is the computation (L+D+L') S = F using MKL_CSPBLAS_DCOOSYMV
!			where S is a vector. It is easy to see that L+D+L' is a symmetric matrix.
!
!       6. The next step is the computation A'* S = F using MKL_CSPBLAS_DCOOGEMV
!			where S is a vector.
!
! The code given below uses only one sparse representation for the all operations.
!*******************************************************************************
*/
#include <stdio.h>
#include "mkl_types.h"
#include "mkl_spblas.h"

int main () {
//*******************************************************************************
//     Definition arrays for sparse representation of  the matrix A in
//     the coordinate format:
//*******************************************************************************
#define M 5
#define NNZ 13
		MKL_INT		m = M, nnz = NNZ;
        double		values[NNZ]	  = {1.0, -1.0, -3.0, -2.0, 5.0, 4.0, 6.0, 4.0, -4.0, 2.0, 7.0, 8.0, -5.0};
		MKL_INT		columns[NNZ]  = {0, 1, 2, 0, 1, 2, 3, 4, 0, 2, 3, 1, 4};
		MKL_INT		rows[NNZ]	  = {0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4};
        MKL_INT		pointerB[M] , pointerE[M];
//*******************************************************************************
//    Declaration of local variables :
//*******************************************************************************
#define N 2
        MKL_INT		n = N;
		double		sol[M][N]	= {1.0, 5.0, 1.0, 4.0, 1.0, 3.0, 1.0, 2.0, 1.0,1.0};
		double		rhs[M][N]	= {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
		double		temp[M][N]	= {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
		double		sol_vec[M]	= {1.0, 1.0, 1.0, 1.0, 1.0};
		double		rhs_vec[M]	= {0.0, 0.0, 0.0, 0.0, 0.0};
		double		temp_vec[M]	= {0.0, 0.0, 0.0, 0.0, 0.0};
        double		alpha = 1.0, beta = 0.0;
        MKL_INT		i, j, is;
		char		transa, uplo, nonunit;
		char		matdescra[6];

		printf("\n EXAMPLE PROGRAM FOR COORDINATE FORMAT ROUTINES \n");

//*******************************************************************************
//    Task 1.    Obtain matrix-matrix multiply (L+D)' *sol --> rhs
//    and solve triangular system   (L+D)' *temp = rhs with multiple right hand sides
//    Array temp must be equal to the array sol
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR MKL_DCOOMM \n");
        printf("   WITH TRIANGULAR MATRIX    \n");
        printf("     M = %1.1i   N = %1.1i\n", m, n);
        printf("     ALPHA = %4.1f  BETA = %4.1f \n", alpha, beta);
        printf("     TRANS = '%c' \n", 'T');
        printf("   Input matrix              \n");
		for (i = 0; i < m; i++) {
			for (j = 0; j < n; j++) {
				printf("%7.1f", sol[i][j]);
			};
			printf("\n");
		};

		transa = 't';
		matdescra[0] = 't';
		matdescra[1] = 'l';
		matdescra[2] = 'n';
		matdescra[3] = 'c';


        mkl_dcoomm(&transa, &m, &n, &m, &alpha, matdescra, values, rows, columns, &nnz, &(sol[0][0]), &n,  &beta, &(rhs[0][0]),  &n);

		printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOMM\n");
        printf("   WITH TRIANGULAR MATRIX    \n");
		for (i = 0; i < m; i++) {
			for (j = 0; j < n; j++) {
				printf("%7.1f", rhs[i][j]);
			};
			printf("\n");
		};
        printf("-----------------------------------------------\n");
        printf("   Solve triangular system   \n");
        printf("   with obtained             \n");
        printf("   right hand side           \n");
        mkl_dcoosm(&transa, &m, &n, &alpha, matdescra, values, rows, columns, &nnz, &(rhs[0][0]), &n, &(temp[0][0]), &n);


        printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOSM\n");
		for (i = 0; i < m; i++) {
			for (j = 0; j < n; j++) {
				printf("%7.1f", temp[i][j]);
			};
			printf("\n");
		};
        printf("-----------------------------------------------\n");

//*******************************************************************************
//    Task 2.    Obtain matrix-vector multiply (U+I)' *sol --> rhs
//    and solve triangular system   (U+I)' *temp = rhs with single right hand sides
//    Array temp must be equal to the array sol
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR MKL_DCOOMV \n");
        printf("   WITH TRIANGULAR MATRIX    \n");
        printf("     ALPHA = %4.1f  BETA = %4.1f \n", alpha, beta);
        printf("     TRANS = '%c' \n", 'T');
        printf("   Input vector              \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", sol_vec[i]);
		};

		transa = 't';
		matdescra[0] = 't';
		matdescra[1] = 'u';
		matdescra[2] = 'u';
		matdescra[3] = 'c';

        mkl_dcoomv(&transa, &m, &m, &alpha, matdescra, values, rows, columns, &nnz, sol_vec, &beta, rhs_vec);

		printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOMV\n");
        printf("   WITH TRIANGULAR MATRIX    \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", rhs_vec[i]);
		};
        printf("-----------------------------------------------\n");
        printf("   Solve triangular system   \n");
        printf("   with obtained             \n");
        printf("   right hand side           \n");

		uplo		= 'u';
		nonunit		= 'u';
        mkl_cspblas_dcootrsv(&uplo, &transa, &nonunit, &m, values, rows, columns, &nnz, rhs_vec, temp_vec);

		printf("                             \n");
        printf("   OUTPUT DATA FOR           \n");
		printf("   MKL_CSPBLAS_DCOOTRSV      \n");
        printf("   WITH TRIANGULAR MATRIX    \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", temp_vec[i]);
		};
        printf("-----------------------------------------------\n");

//*******************************************************************************
//    Task 3.  Obtain matrix-vector multiply D *sol --> rhs
//    and solve triangular system   D *temp = rhs with single right hand side
//    Array temp must be equal to the array sol
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR MKL_DCOOMV \n");
        printf("   WITH DIAGONAL MATRIX    \n");
        printf("     M = %1.1i   N = %1.1i\n", m, n);
        printf("     TRANS = '%c' \n", 'T');
        printf("   Input vector              \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", sol_vec[i]);
		};

		transa = 'n';
		matdescra[0] = 'd';
		matdescra[1] = 'u';
		matdescra[2] = 'n';
		matdescra[3] = 'c';

        mkl_dcoomv(&transa, &m, &m, &alpha, matdescra, values, rows, columns, &nnz, sol_vec, &beta, rhs_vec);

        printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOMV\n");
        printf("   WITH DIAGONAL MATRIX      \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", rhs_vec[i]);
		};
        printf("-----------------------------------------------\n");
        printf("   Multiply by inverse      \n");
        printf("   matrix with the help     \n");
        printf("   of MKL_DCSRSV            \n");

        mkl_dcoosv(&transa, &m, &alpha, matdescra, values, rows, columns, &nnz,  rhs_vec, temp_vec);

        printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOSV\n");
        printf("   WITH DIAGONAL MATRIX      \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", temp_vec[i]);
		};
        printf("-----------------------------------------------\n");


//*******************************************************************************
//    Task 4.  Obtain matrix-vector multiply (U -U')*sol --> rhs
//    Array temp must be equal to the array sol
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR MKL_DCOOMV \n");
        printf("   WITH SKEW-SYMMETRIC MATRIX\n");
        printf("     ALPHA = %4.1f  BETA = %4.1f \n", alpha, beta);
        printf("     TRANS = '%c' \n", 'N');
        printf("   Input vector              \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", sol_vec[i]);
		};

		transa = 'n';
		matdescra[0] = 'a';
		matdescra[1] = 'u';
		matdescra[2] = 'n';
		matdescra[3] = 'c';

        mkl_dcoomv(&transa, &m, &m, &alpha, matdescra, values, rows, columns, &nnz, sol_vec, &beta, rhs_vec);

		printf("                             \n");
        printf("   OUTPUT DATA FOR MKL_DCOOMV\n");
        printf("   WITH SKEW-SYMMETRIC MATRIX\n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", rhs_vec[i]);
		};
        printf("-----------------------------------------------\n");
//*******************************************************************************
//    Task 5.  Obtain matrix-vector multiply (L+D+L')*sol --> rhs whith the help of
//    MKL_CSPBLAS_DCOOSYMV
//
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR            \n");
		printf("   MKL_CSPBLAS_DCOOSYMV      \n");
        printf("   WITH SYMMETRIC MATRIX     \n");
        printf("     ALPHA = %4.1f  BETA = %4.1f \n", alpha, beta);
        printf("   Input vector              \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", sol_vec[i]);
		};
        uplo = 'l';

        mkl_cspblas_dcoosymv(&uplo, &m, values, rows, columns, &nnz, sol_vec, rhs_vec);

        printf("                             \n");
        printf("   OUTPUT DATA FOR           \n");
		printf("   MKL_CSPBLAS_DCOOSYMV      \n");
        printf("   WITH SYMMETRIC MATRIX     \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", rhs_vec[i]);
		};
        printf("-----------------------------------------------\n");

//*******************************************************************************
//    Task 6. Obtain matrix-vector multiply A'*sol --> rhs whith the help
//    of MKL_CSPBLAS_DCOOGEMV
//
//*******************************************************************************
        printf("                             \n");
        printf("   INPUT DATA FOR            \n");
		printf("   MKL_CSPBLAS_DCOOGEMV      \n");
        printf("   WITH GENERAL MATRIX       \n");
        printf("     ALPHA = %4.1f  BETA = %4.1f \n", alpha, beta);
        printf("     TRANS = '%c' \n", 'T');
        printf("   Input vector              \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", sol_vec[i]);
		};

		transa = 't';

        mkl_cspblas_dcoogemv(&transa, &m, values, rows, columns, &nnz, sol_vec, rhs_vec);

		printf("                             \n");
        printf("   OUTPUT DATA FOR           \n");
		printf("   MKL_CSPBLAS_DCOOGEMV      \n");
        printf("   WITH GENERAL MATRIX       \n");
		for (i = 0; i < m; i++) {
			printf("%7.1f\n", rhs_vec[i]);
		};
        printf("-----------------------------------------------\n");

		return 0;
}
