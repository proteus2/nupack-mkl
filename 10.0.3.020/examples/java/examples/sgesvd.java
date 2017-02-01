/*******************************************************************************
!                             INTEL CONFIDENTIAL
!   Copyright(C) 2007-2008 Intel Corporation. All Rights Reserved.
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
!******************************************************************************/

import com.intel.mkl.*;

public final class sgesvd {
    /**
     * Incarnation prohibited.
     */
    private sgesvd() {}

    /**
     * Individual name of this test.
     */
    private final static String test_name = "sgesvd";

    /**
     * No command-line options.
     */
    public static void main(String[] args) {
        boolean fault;
        try {
            fault = test();
        } catch (Exception statusException) {
            fault = true;
            statusException.printStackTrace(System.out);
            System.out.println("\nTEST FAILED");
            System.exit(1);
        }
        System.out.println("\nTEST PASSED");
    }

    /**
     * Demonstrate the LAPACK functions and test them.
     * @return true - If the test has failed.
     */
    public static boolean test()
    {
        // Parameters
        final int m = 5;
        final int n = 3;
        final int minmn = Math.min(m,n);

        int i, j, info;

        float[] A = new float[] { -2,  2,  6,  1, -2,
                                  -8, -5,  0,  0, 11,
                                   1,  6,  2,  4,  0 };

        float[] s = new float[minmn];
        float[] u = new float[m*m];
        float[] vt = new float[n*n];
        float[] sd = new float[minmn-1];

		float[] AA = new float[m*n];
        for(i=0;i<m*n;i++) {
			AA[i] = A[i];
        }

        System.out.println("The matrix A:");
        for(i=0;i<m;i++) {
            for(j=0;j<n;j++) {
                System.out.print(" " + A[i+j*m]);
            }
	        System.out.println("");
        }


        info = LAPACK.sgesvd(LAPACK.JOB.JobN,LAPACK.JOB.JobN,m,n,A,m,s,null,1,null,1,sd);


        System.out.print("s on exit:");
        for(i=0;i<minmn;i++) {
            System.out.print(" " + s[i]);
        }
        System.out.println("");

        System.out.println("info on exit: " + info);

        info = LAPACK.sgesvd(LAPACK.JOB.JobN,LAPACK.JOB.JobS,m,n,A,m,s,null,1,vt,minmn,sd);

        System.out.print("s on exit:");
        for(i=0;i<minmn;i++) {
            System.out.print(" " + s[i]);
        }
        System.out.println("");

        System.out.println("info on exit: " + info);

        return false;
    }
}