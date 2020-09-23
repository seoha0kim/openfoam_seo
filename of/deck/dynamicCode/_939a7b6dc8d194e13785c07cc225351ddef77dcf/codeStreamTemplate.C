/*---------------------------------------------------------------------------*  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) YEAR OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

Description
    Template for use with codeStream.

\*---------------------------------------------------------------------------*/

#include "dictionary.H"
#include "Ostream.H"
#include "Pstream.H"
#include "unitConversion.H"

//{{{ begin codeInclude
#line 23 "/home/sbkim/Work/git/openfoam_seo/of/deck/system/blockMeshDict/#codeStream"
#include "pointField.H"
//}}} end codeInclude

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{

// * * * * * * * * * * * * * * * Local Functions * * * * * * * * * * * * * * //

//{{{ begin localCode

//}}} end localCode


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    void codeStream_939a7b6dc8d194e13785c07cc225351ddef77dcf
    (
        Ostream& os,
        const dictionary& dict
    )
    {
//{{{ begin code
        #line 28 "/home/sbkim/Work/git/openfoam_seo/of/deck/system/blockMeshDict/#codeStream"
pointField points(110);
        points[0] = point(-1.500000, -1.500000, -0.500000);
        points[1] = point(-0.308750, -1.500000, -0.500000);
        points[2] = point(-0.154375, -1.500000, -0.500000);
        points[3] = point(-0.145672, -1.500000, -0.500000);
        points[4] = point(-0.135061, -1.500000, -0.500000);
        points[5] = point(-0.131804, -1.500000, -0.500000);
        points[6] = point(-0.106312, -1.500000, -0.500000);
        points[7] = point(-0.085993, -1.500000, -0.500000);
        points[8] = point(-0.084825, -1.500000, -0.500000);
        points[9] = point(0.000000, -1.500000, -0.500000);
        points[10] = point(0.084825, -1.500000, -0.500000);
        points[11] = point(0.085993, -1.500000, -0.500000);
        points[12] = point(0.106312, -1.500000, -0.500000);
        points[13] = point(0.131804, -1.500000, -0.500000);
        points[14] = point(0.135061, -1.500000, -0.500000);
        points[15] = point(0.145672, -1.500000, -0.500000);
        points[16] = point(0.154375, -1.500000, -0.500000);
        points[17] = point(0.617500, -1.500000, -0.500000);
        points[18] = point(4.500000, -1.500000, -0.500000);
        points[19] = point(-1.500000, -0.200000, -0.500000);
        points[20] = point(-0.286153, -0.231178, -0.500000);
        points[21] = point(-0.132624, -0.215041, -0.500000);
        points[22] = point(-0.123968, -0.214131, -0.500000);
        points[23] = point(-0.113416, -0.213022, -0.500000);
        points[24] = point(-0.110176, -0.212682, -0.500000);
        points[25] = point(-0.084824, -0.210017, -0.500000);
        points[26] = point(-0.064616, -0.207893, -0.500000);
        points[27] = point(-0.063455, -0.207771, -0.500000);
        points[28] = point(0.020906, -0.198904, -0.500000);
        points[29] = point(0.105266, -0.190038, -0.500000);
        points[30] = point(0.106427, -0.189916, -0.500000);
        points[31] = point(0.126635, -0.187792, -0.500000);
        points[32] = point(0.151988, -0.185127, -0.500000);
        points[33] = point(0.155227, -0.184787, -0.500000);
        points[34] = point(0.165779, -0.183678, -0.500000);
        points[35] = point(0.174435, -0.182768, -0.500000);
        points[36] = point(0.635023, -0.134358, -0.500000);
        points[37] = point(4.500000, -0.200000, -0.500000);
        points[38] = point(-1.500000, -0.019386, -0.500000);
        points[39] = point(-0.305032, -0.051553, -0.500000);
        points[40] = point(-0.151503, -0.035416, -0.500000);
        points[41] = point(-0.142847, -0.034506, -0.500000);
        points[42] = point(-0.132295, -0.033397, -0.500000);
        points[43] = point(-0.129056, -0.033057, -0.500000);
        points[44] = point(-0.103703, -0.030392, -0.500000);
        points[45] = point(-0.083495, -0.028268, -0.500000);
        points[46] = point(-0.082270, -0.028757, -0.500000);
        points[47] = point(0.002091, -0.019890, -0.500000);
        points[48] = point(0.086451, -0.011024, -0.500000);
        points[49] = point(0.087548, -0.010291, -0.500000);
        points[50] = point(0.107756, -0.008167, -0.500000);
        points[51] = point(0.133108, -0.005502, -0.500000);
        points[52] = point(0.136348, -0.005162, -0.500000);
        points[53] = point(0.146900, -0.004053, -0.500000);
        points[54] = point(0.155556, -0.003143, -0.500000);
        points[55] = point(0.616144, 0.045267, -0.500000);
        points[56] = point(4.500000, -0.019386, -0.500000);
        points[57] = point(-1.500000, -0.013326, -0.500000);
        points[58] = point(-0.305666, -0.045526, -0.500000);
        points[59] = point(-0.152136, -0.029390, -0.500000);
        points[60] = point(-0.143481, -0.028480, -0.500000);
        points[61] = point(-0.132928, -0.027371, -0.500000);
        points[62] = point(-0.129689, -0.027030, -0.500000);
        points[63] = point(-0.104337, -0.024366, -0.500000);
        points[64] = point(-0.080887, -0.021901, -0.500000);
        points[65] = point(0.083673, -0.004605, -0.500000);
        points[66] = point(0.107123, -0.002140, -0.500000);
        points[67] = point(0.132475, 0.000524, -0.500000);
        points[68] = point(0.135714, 0.000865, -0.500000);
        points[69] = point(0.146267, 0.001974, -0.500000);
        points[70] = point(0.154922, 0.002884, -0.500000);
        points[71] = point(0.615510, 0.051293, -0.500000);
        points[72] = point(4.500000, -0.013326, -0.500000);
        points[73] = point(-1.500000, 0.012391, -0.500000);
        points[74] = point(-0.308354, -0.019950, -0.500000);
        points[75] = point(-0.154824, -0.003814, -0.500000);
        points[76] = point(-0.146191, -0.002688, -0.500000);
        points[77] = point(-0.135042, -0.007255, -0.500000);
        points[78] = point(-0.132436, -0.000893, -0.500000);
        points[79] = point(-0.107151, 0.002405, -0.500000);
        points[80] = point(-0.088376, 0.000444, -0.500000);
        points[81] = point(0.086352, 0.018808, -0.500000);
        points[82] = point(0.104309, 0.024630, -0.500000);
        points[83] = point(0.129728, 0.026661, -0.500000);
        points[84] = point(0.133600, 0.020980, -0.500000);
        points[85] = point(0.143556, 0.027766, -0.500000);
        points[86] = point(0.152234, 0.028459, -0.500000);
        points[87] = point(0.612822, 0.076869, -0.500000);
        points[88] = point(4.500000, 0.012391, -0.500000);
        points[89] = point(-1.500000, 0.016141, -0.500000);
        points[90] = point(-0.308746, -0.016221, -0.500000);
        points[91] = point(-0.155216, -0.000084, -0.500000);
        points[92] = point(-0.002091, 0.019890, -0.500000);
        points[93] = point(0.151842, 0.032189, -0.500000);
        points[94] = point(0.612430, 0.080599, -0.500000);
        points[95] = point(4.500000, 0.016141, -0.500000);
        points[96] = point(-1.500000, 0.200000, -0.500000);
        points[97] = point(-0.327964, 0.166631, -0.500000);
        points[98] = point(-0.174435, 0.182768, -0.500000);
        points[99] = point(-0.020906, 0.198904, -0.500000);
        points[100] = point(0.132624, 0.215041, -0.500000);
        points[101] = point(0.593212, 0.263451, -0.500000);
        points[102] = point(4.500000, 0.200000, -0.500000);
        points[103] = point(-1.500000, 1.500000, -0.500000);
        points[104] = point(-0.308750, 1.500000, -0.500000);
        points[105] = point(-0.154375, 1.500000, -0.500000);
        points[106] = point(0.000000, 1.500000, -0.500000);
        points[107] = point(0.154375, 1.500000, -0.500000);
        points[108] = point(0.617500, 1.500000, -0.500000);
        points[109] = point(4.500000, 1.500000, -0.500000);

        // Duplicate z points
        label sz = points.size();
        points.setSize(2*sz);
        for (label i = 0; i < sz; i++)
        {
            const point& pt = points[i];
            points[i+sz] = point(pt.x(), pt.y(), -pt.z());
        }

        os << points;
//}}} end code
    }
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

