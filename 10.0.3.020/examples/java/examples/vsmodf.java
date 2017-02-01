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

public final class vsmodf {
    /**
     * Incarnation prohibited.
     */
    private vsmodf() {}

    /**
     * Individual name of this test.
     */
    private final static String test_name = "vsmodf";

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
     * Demonstrate the VML functions and test them.
     * @return true - If the test has failed.
     */
    public static boolean test()
    {
        // Parameters
        final int VEC_LEN = 11;
        final float __SMODF_BEG = -2.00f;
        final float __SMODF_END = 2.00f;

        float[] fA1 = new float[VEC_LEN];
        float[] fB1 = new float[VEC_LEN];
        float[] fB2 = new float[VEC_LEN];

        int i=0,vec_len=VEC_LEN;

        for(i=0;i<vec_len;i++) {
                fA1[i]=(float)(__SMODF_BEG+((__SMODF_END-__SMODF_BEG)*i)/vec_len);
                fB1[i]=0.0f;
                fB2[i]=0.0f;
        }

        VML.vsModf(vec_len,fA1,fB1,fB2);

        System.out.println("vsModf test/example program\n");
        System.out.println("        Argument                     vsModf");
        System.out.println("===============================================================================");
        for(i=0;i<vec_len;i++) {
                System.out.println("" + fA1[i] + " " + fB1[i] + " " + fB2[i] + "");
        }

        return false;
    }
}
