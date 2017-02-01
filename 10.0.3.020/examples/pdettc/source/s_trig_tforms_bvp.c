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
!  Content:
!  Single precision C test example for trigonometric transforms
!*******************************************************************************
!
! This example gives the solution of the 1D differential problems
! with the equation  -u"+u=f(x), 0<x<1, and with 3 types of boundary conditions:
! u(0)=u(1)=0 (DD case), or u'(0)=u'(1)=0 (NN case), or u'(0)=u(1)=0 (ND case)
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mkl_trig_transforms.h"

int main(void)
{
	MKL_INT n=8, i, k, tt_type;
	MKL_INT ir, ipar[128];
	float pi=3.14159265358979324, xi, c;
	float c1, c2, c3, c4, c5, c6;
	float *u, *f, *spar, *lambda;
	DFTI_DESCRIPTOR_HANDLE handle = 0;

	/* Printing the header for the example */
	printf("\n Example of use of MKL Trigonometric Transforms\n");
	printf(" **********************************************\n\n");
	printf(" This example gives the the solutions of the 1D differential problems\n");
	printf(" with the equation -u\"+u=f(x), 0<x<1, \n");
	printf(" and with 3 types of boundary conditions:\n");
	printf(" DD case: u(0)=u(1)=0,\n");
	printf(" NN case: u'(0)=u'(1)=0,\n");
	printf(" ND case: u'(0)=u(1)=0.\n");
	printf(" -----------------------------------------------------------------------\n");
	printf(" In general, the error should be of order O(1.0/n**2)\n");
	printf(" For this example, the value of n is %d\n", n);
	printf(" The approximation error should be of order 5.0e-002 if everything is OK\n");
	printf(" -----------------------------------------------------------------------\n");
	printf("                      SINGLE PRECISION COMPUTATIONS                     \n");
	printf(" =======================================================================\n\n");

	u=(float*)malloc((n+1)*sizeof(float));
	f=(float*)malloc((n+1)*sizeof(float));
	/* NOTE: This example uses shorter spar array of size 3n/2+2 instead of 5n/2+2 
	as only sine, cosine, and staggered cosine transforms are used. More details
	can be found in Chapter 13 of MKL Manual. */
	spar=(float*)malloc((3*n/2+2)*sizeof(float));
	lambda=(float*)malloc((n+1)*sizeof(float));

	for(i=0;i<=2;i++)
	{
		/* Varying the type of the transform */
		tt_type=i;

		/* Computing test solutions u(x) */
		for(k=0;k<=n;k++)
		{
			xi=(float)1.0E0*(float)k/(float)n;
			u[k]=pow(sin(pi*xi),(float)2.0E0);
		}
		/* Computing the right-hand side f(x) */
		for(k=0;k<=n;k++)
		{
			f[k]=((float)4.0E0*(pi*pi)+(float)1.0E0)*u[k]-(float)2.0E0*(pi*pi);
		}
		/* Computing the right-hand side for the algebraic system */
		for(k=0;k<=n;k++)
		{
			f[k]=f[k]/(n*n);
		}
		if (tt_type==0)
		{
			/* The Dirichlet boundary conditions */
			f[0]=(float)0.0E0;
			f[n]=(float)0.0E0;
		}
		if (tt_type==2)
		{
			/* The mixed Neumann-Dirichlet boundary conditions */
			f[n]=(float)0.0E0;
		}

		/* Computing the eigenvalues for the three-point finite-difference problem */
		if (tt_type==0||tt_type==1)
		{
			for(k=0;k<=n;k++)
			{
				lambda[k]=pow((float)2.0E0*sin((float)0.5E0*pi*(float)k/(float)n),(float)2.0E0)+(float)1.0E0/(float)(n*n);
			}
		}
		if (tt_type==2)
		{
			for(k=0;k<=n;k++)
			{
				lambda[k]=pow((float)2.0E0*sin((float)0.25E0*pi*(float)(2*k+1)/(float)n),(float)2.0E0)+(float)1.0E0/(float)(n*n);
			}
		}

		/* Computing the solution of 1D problem using trigonometric transforms
		First we initialize the transform */
		s_init_trig_transform(&n,&tt_type,ipar,spar,&ir);
		if (ir!=0) goto FAILURE;
		/* Then we commit the transform. Note that the data in f will be changed at this stage !
		If you want to keep them, save them in some other array before the call to the routine */
		s_commit_trig_transform(f,&handle,ipar,spar,&ir);
		if (ir!=0) goto FAILURE;
		/* Now we can apply trigonometric transform */
		s_forward_trig_transform(f,&handle,ipar,spar,&ir);
		if (ir!=0) goto FAILURE;

		/* Scaling the solution by the eigenvalues */
		for(k=0;k<=n;k++)
		{
			f[k]=f[k]/lambda[k];
		}

		/* Now we can apply trigonometric transform once again as ONLY input vector f has changed */
		s_backward_trig_transform(f,&handle,ipar,spar,&ir);
		if (ir!=0) goto FAILURE;
		/* Cleaning the memory used by handle
		Now we can use handle for other kind of trigonometric transform */
		free_trig_transform(&handle,ipar,&ir);
		if (ir!=0) goto FAILURE;

		/* Performing the error analysis */
		c1=(float)0.0E0;
		c2=(float)0.0E0;
		c3=(float)0.0E0;
		for(k=0;k<=n;k++)
		{
			/* Computing the absolute value of the exact solution */
			c4=fabs(u[k]);
			/* Computing the absolute value of the computed solution
			Note that the solution is now in place of the former right-hand side ! */
			c5=fabs(f[k]);
			/* Computing the absolute error */
			c6=fabs(f[k]-u[k]);
			/* Computing the maximum among the above 3 values c4-c6 */
			if (c4>c1) c1=c4;
			if (c5>c2) c2=c5;
			if (c6>c3) c3=c6;
		}

		/* Printing the results */
		if (tt_type==0)
		{
			printf("The computed solution of DD problem is\n\n");
		}
		if (tt_type==1)
		{
			printf("The computed solution of NN problem is\n\n");
		}
		if (tt_type==2)
		{
			printf("The computed solution of ND problem is\n\n");
		}
		for(k=0;k<=n;k++)
		{
			printf("u[%d]=", k);
			printf("%6.3f\n",f[k]);
		}
		printf("\nError=%6.3e\n\n",c3/c1);
		if (c3/c1>0.05)
		{
			printf("The computed solution seems to be inaccurate. ");
			goto FAILURE;
		}
		/* End of the loop over the different kind of transforms and problems */
	}

	/* Success message to print if everything is OK */
	printf("This example has successfully PASSED through all steps of computation!\n");
	/* Jumping over failure message */
	goto SUCCESS;
	/* Failure message to print if something went wrong */
FAILURE: printf("Failed to compute the solution(s)...\n");

SUCCESS: return 0;
	/* End of the example code */
}
