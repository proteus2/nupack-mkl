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
       mpz_t rop, op;
       char str[] = "672749994932560009201";
 /*                                                                  */
/* Initialization of all multiple precision variables ( rop, op )    */
/*         and assignment of data to entrance variables ( op )       */
/*                                                                   */
       mpz_init ( rop );
       mpz_init ( op );
/*                                                                   */
/*       Call mpz_set_str to set op = 672749994932560009201          */
/*                                                                   */
	   mpz_set_str ( op, str, 10 );
/*                                                                   */
/*       Call mpz_sqrt  to set rop to op to the 1/2 power            */
/*                                                                   */
       mpz_sqrt ( rop, op );
/*                                                                   */
/*      Call mpz_get_str to convert rop to a string of digits        */
/*     in base 10 and printing of result ( rop ) in the form of      */
/* rop = 25937424601                                                 */
/*                                                                   */
       mpz_get_str ( str, 10, rop );
       printf ( " rop = %s\n", str );
/*                                                                   */
/*             Free the space occupied by rop, base, mod2            */
/*                                                                   */
       mpz_clear ( rop );
       mpz_clear ( op );
       return 0;
}
