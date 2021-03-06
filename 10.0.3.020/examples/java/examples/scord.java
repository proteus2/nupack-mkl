/*******************************************************************************
!                             INTEL CONFIDENTIAL
!  Copyright(C) 2007-2008 Intel Corporation. All Rights Reserved.
!  The source code contained  or  described herein and all documents related to
!  the source code ("Material") are owned by Intel Corporation or its suppliers
!  or licensors.  Title to the  Material remains with  Intel Corporation or its
!  suppliers and licensors. The Material contains trade secrets and proprietary
!  and  confidential  information of  Intel or its suppliers and licensors. The
!  Material  is  protected  by  worldwide  copyright  and trade secret laws and
!  treaty  provisions. No part of the Material may be used, copied, reproduced,
!  modified, published, uploaded, posted, transmitted, distributed or disclosed
!  in any way without Intel's prior express written permission.
!  No license  under any  patent, copyright, trade secret or other intellectual
!  property right is granted to or conferred upon you by disclosure or delivery
!  of the Materials,  either expressly, by implication, inducement, estoppel or
!  otherwise.  Any  license  under  such  intellectual property  rights must be
!  express and approved by Intel in writing.
!******************************************************************************/

import com.intel.mkl.*;

/**
 * Example of using the analogy for the ESSL function <code>scord</code>.
 * The code of this example bases on the file <code>example_scord.c</code>
 * found inder the directory:
 * <ul>
 *   <li>${MKL}/examples/vslc/essl</li>
 * </ul>
 * The analogy of the ESSL's <code>scord</code> function is provided by
 * the C/C++ and FORTRAN wrappers found under the directories:
 * <ul>
 *   <li>${MKL}/examples/vslc/essl/vsl_wrappers</li>
 *   <li>${MKL}/examples/vslf/essl/vsl_wrappers</li>
 * </ul>
 * The Java interface to these wrappers is provided with the sample class
 * ESSL.
 *
 * @see ESSL
 */
final public class scord {
    /**
     * Instantiation prohibited.
     */
    private scord() {}

    /**
     * Official entry to the test; the args[] is ignored.
     */
    public static void main(String args[]) {
        int status;
        status = test();
        System.exit(status);
    }

    /**
     * Actually run the test; return 0 if the test passes,
     * or return 1 if the test fails.
     */
    public static int test() {
        int    inch, incx, incy;
        int    nh,   nx,   ny;
        int    iy0;
        float  h[], x[], y[];
        int    i;
        double r10;
        int    r1[] = new int [] { 2, 5, 8, 11, 14, 5 };
        int    r2[] = new int [] { 5, 8, 11 };
        /************* Initialize data *****/
        h = new float [3];
        x = new float [15];
        y = new float [24];
        r10 = 2.0e-5;
        inch = 2;
        incx = 3;
        incy = 4;
        nh   = 2;
        nx   = 5;
        ny   = 6;
        for ( i = 0; i < nh; i++ )
            h[i*inch] = (float)(i+1);
        System.out.println();
        for ( i = 0; i < nx; i++ )
            x[i*incx] = (float)(i+1);

        /****** 1-st Sample **********/

        iy0 = -1;

        /***** Call scord *****/

        ESSL.scord( h, inch, x, incx, y, incy, nh, nx, iy0, ny );

        /***** Printing results *****/

        System.out.println(" 1-st Sample of scord.");
        System.out.println("----------------------");
        System.out.println("Parameters:");
        System.out.println("    inch = " + inch +
                             ", incx = " + incx +
                             ", incy = " + incy );
        System.out.println("    nh   = " + nh +
                             ", nx   = " + nx +
                             ", ny   = " + ny );
        System.out.println("    iy0  = " + iy0 + "\n" );
        for( i=0; i < nh; i++ )
            System.out.println("h[" + (i*inch) + " ] = " + h[i*inch]);
        System.out.println();
        for( i=0; i < nx; i++ )
            System.out.println("x[" + (i*incx) + " ] = " + x[i*incx]);
        System.out.println();

        System.out.println("Results:");
        System.out.println("---------------------------");
        for( i=0; i < ny; i++ )
            System.out.println("y[" + (i*incy) + " ] = " + y[i*incy]);
        for( i = 0; i < 6; i++ ) {
            if(Math.abs(y[i*incy]-r1[i]) > r10) {
                System.out.println("ERROR: wrong result: i=" + i + ", y[i*incy]=" + y[i*incy]);
                System.out.println("---------------------------");
                System.out.println(" TEST FAILED");
                System.out.println("---------------------------");
                return 1;
            }
        }
        System.out.println();

        /****** 2-nd Sample **********/

        iy0 = 0;
        ny  = 3;

        /***** Call scord *****/

        ESSL.scord( h, inch, x, incx, y, incy, nh, nx, iy0, ny );

        /***** Printing results *****/

        System.out.println(" 2-nd Sample of scord.");
        System.out.println("----------------------");
        System.out.println("Parameters:");
        System.out.println("    inch = " + inch +
                             ", incx = " + incx +
                             ", incy = " + incy );
        System.out.println("    nh   = " + nh +
                             ", nx   = " + nx +
                             ", ny   = " + ny );
        System.out.println("    iy0  = " + iy0 + "\n" );
        for( i=0; i < nh; i++ )
            System.out.println("h[" + (i*inch) + " ] = " + h[i*inch]);
        System.out.println();
        for( i=0; i < nx; i++ )
            System.out.println("x[" + (i*incx) + " ] = " + x[i*incx]);
        System.out.println();

        System.out.println("Results:");
        System.out.println("---------------------------");
        for( i=0; i < ny; i++ )
            System.out.println("y[" + (i*incy) + " ] = " + y[i*incy]);
        System.out.println();
        for( i = 0; i < 3; i++ ) {
            if(Math.abs(y[i*incy]-r2[i]) > r10) {
                System.out.println("ERROR: wrong result: i=" + i + ", y[i*incy]=" + y[i*incy]);
                System.out.println("---------------------------");
                System.out.println(" TEST FAILED");
                System.out.println("---------------------------");
                return 1;
            }
        }
        System.out.println("---------------------------");
        System.out.println(" TEST PASSED");
        System.out.println("---------------------------");

        return 0;
    }
}
