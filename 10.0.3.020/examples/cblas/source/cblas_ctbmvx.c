/*******************************************************************************
!                             INTEL CONFIDENTIAL
!   Copyright(C) 1999-2008 Intel Corporation. All Rights Reserved.
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
!  Content:
!      C B L A S _ C T B M V  Example Program Text ( C Interface )
!******************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#include "mkl_example.h"
#include "mkl_cblas.h"

int main(int argc, char *argv[])
{
      FILE *in_file;
      char *in_file_name;

      MKL_INT         n, k, incx, lda;
      MKL_INT         rmaxa, cmaxa;
      MKL_Complex8   *a, *x;
      CBLAS_ORDER     order;
      CBLAS_UPLO      uplo;
      CBLAS_TRANSPOSE trans;
      CBLAS_DIAG      diag;
      MKL_INT         kl, ku, len_x;

      printf("\n     C B L A S _ C T B M V  EXAMPLE PROGRAM\n");

/*       Get input parameters                                  */

      if( argc == 1 ) {
         printf("\n You must specify in_file data file as 1-st parameter");
         return 0;
      }
      in_file_name = argv[1];

/*       Get input data                                        */

      if( (in_file = fopen( in_file_name, "r" )) == NULL ) {
         printf("\n ERROR on OPEN '%s' with mode=\"r\"\n", in_file_name);
         return 0;
      }
      if( GetIntegerParameters(in_file, &n, &k) != 2 ) {
          printf("\n ERROR of n, k reading\n");
          return 0;
      }
      if( GetIntegerParameters(in_file, &incx) != 1 ) {
          printf("\n ERROR of incx reading\n");
          return 0;
      }
      if( GetCblasCharParameters(in_file, &uplo, &trans, &diag, &order) != 4 ) {
          printf("\n ERROR of uplo, trans, diag, order reading\n");
          return 0;
      }

      rmaxa = k + 1;
      cmaxa = n;
      len_x = 1+(n-1)*abs(incx);
      a = (MKL_Complex8 *)calloc( rmaxa*cmaxa, sizeof(MKL_Complex8) );
      x = (MKL_Complex8 *)calloc( len_x, sizeof(MKL_Complex8) );
      if( a == NULL || x == NULL ) {
          printf( "\n Can't allocate memory for arrays\n");
          return 0;
      }
      if( GetVectorC(in_file, n, x, incx) != len_x ) {
        printf("\n ERROR of vector X reading\n");
        return 0;
      }
      lda=rmaxa;
      if( uplo == CblasUpper )  {
          kl = 0;
          ku = k;
      } else {
          kl = k;
          ku = 0;
      }
      if( GetBandArrayC(in_file, &order, kl, ku, n, n, a, lda) != 0 ) {
        printf("\n ERROR of array A reading\n");
        return 0;
      }
      fclose(in_file);

/*       Print input data                                      */
      printf("\n     INPUT DATA");
      printf("\n       N=%d  K=%d", n, k);
      PrintParameters("UPLO", uplo);
      PrintParameters("TRANS", trans);
      PrintParameters("ORDER", order);
      PrintVectorC(FULLPRINT, n, x, incx, "X");
      PrintBandArrayC(&order, SHORTPRINT, kl, ku, n, n, a, lda, "A");

/*      Call CBLAS_CTBMV subroutine ( C Interface )            */

      cblas_ctbmv(order, uplo, trans, diag, n, k, a, lda, x, incx);

/*       Print output data                                     */

      printf("\n\n     OUTPUT DATA");
      PrintVectorC(FULLPRINT, n, x, incx, "X");

      free(a);
      free(x);

      return 0;
}

