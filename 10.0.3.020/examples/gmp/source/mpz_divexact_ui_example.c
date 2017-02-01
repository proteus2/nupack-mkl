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
!*******************************************************************************
*/

#include "stdio.h"
#include "mkl_gmp.h"

int main(int argc, char *argv[])
{
/*                                                                   */
/*     mpz_t is the C data type for multiple precision integer       */
/*                                                                   */
	   mpz_t q, n;
       unsigned long int d;
	   char str2[] = "7400249944258160101211"; /*   = 11^21          */
/*                                                                   */
/*  Initialization of all multiple precision variables ( q, n )      */
/*         and assignment of data to entrance variables ( n, d )     */
/*                                                                   */
       mpz_init ( q );
       mpz_init ( n );
 /*                                                                  */
/*         call mpz_set_str                                          */
/*              to set n = 7400249944258160101216                    */
/*                                                                   */
	   mpz_set_str ( n, str2, 10);
       d = 11;
/*                                                                   */
/*     Call mpz_divexact_ui to set q to n/d                          */
/*                                                                   */
       mpz_divexact_ui( q, n, d);
/*                                                                   */
/*  Call mpz_get_str to convert q to a string of digits in base 10   */
/*              and printing of result ( q ) in the form of          */
/* q = 672749994932560009201                                         */
/*                                                                   */
       mpz_get_str ( str2, 10, q );
       printf( " q = %s\n", str2);
/*                                                                   */
/*             Free the space occupied by q, n                       */
/*                                                                   */
       mpz_clear ( q );
       mpz_clear ( n );
       return 0;
}

