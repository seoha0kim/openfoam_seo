/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
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
#line 23 "/media/sbkim/011015fa-005e-40ac-b96a-ffbde3bf46c6/Krieg/Work/OpenFOAM/sbkim-5.0/run/bridgeDeck/Myanmar/00/system/blockMeshDict.#codeStream"
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
    void codeStream_7f62c419f31db2b968bb862320388d911f9cf26c
    (
        Ostream& os,
        const dictionary& dict
    )
    {
//{{{ begin code
        #line 28 "/media/sbkim/011015fa-005e-40ac-b96a-ffbde3bf46c6/Krieg/Work/OpenFOAM/sbkim-5.0/run/bridgeDeck/Myanmar/00/system/blockMeshDict.#codeStream"
pointField points(87);
        points[0] = point(-1.500000, -1.500000, -0.500000);
        points[1] = point(-0.302500, -1.500000, -0.500000);
        points[2] = point(-0.151250, -1.500000, -0.500000);
        points[3] = point(-0.120045, -1.500000, -0.500000);
        points[4] = point(-0.108125, -1.500000, -0.500000);
        points[5] = point(-0.089375, -1.500000, -0.500000);
        points[6] = point(-0.077391, -1.500000, -0.500000);
        points[7] = point(0.000000, -1.500000, -0.500000);
        points[8] = point(0.077391, -1.500000, -0.500000);
        points[9] = point(0.089375, -1.500000, -0.500000);
        points[10] = point(0.108125, -1.500000, -0.500000);
        points[11] = point(0.120045, -1.500000, -0.500000);
        points[12] = point(0.151250, -1.500000, -0.500000);
        points[13] = point(0.302500, -1.500000, -0.500000);
        points[14] = point(4.500000, -1.500000, -0.500000);
        points[15] = point(-1.500000, -0.062500, -0.500000);
        points[16] = point(-0.302500, -0.062500, -0.500000);
        points[17] = point(-0.151250, -0.062500, -0.500000);
        points[18] = point(-0.120045, -0.062500, -0.500000);
        points[19] = point(-0.108125, -0.062500, -0.500000);
        points[20] = point(-0.089375, -0.062500, -0.500000);
        points[21] = point(-0.077391, -0.062500, -0.500000);
        points[22] = point(0.000000, -0.062500, -0.500000);
        points[23] = point(0.077391, -0.062500, -0.500000);
        points[24] = point(0.089375, -0.062500, -0.500000);
        points[25] = point(0.108125, -0.062500, -0.500000);
        points[26] = point(0.120045, -0.062500, -0.500000);
        points[27] = point(0.151250, -0.062500, -0.500000);
        points[28] = point(0.302500, -0.062500, -0.500000);
        points[29] = point(4.500000, -0.062500, -0.500000);
        points[30] = point(-1.500000, -0.012500, -0.500000);
        points[31] = point(-0.302500, -0.012500, -0.500000);
        points[32] = point(-0.151250, -0.012500, -0.500000);
        points[33] = point(-0.120045, -0.012500, -0.500000);
        points[34] = point(-0.108125, -0.012500, -0.500000);
        points[35] = point(-0.089375, -0.012500, -0.500000);
        points[36] = point(-0.077391, -0.012500, -0.500000);
        points[37] = point(0.000000, -0.012500, -0.500000);
        points[38] = point(0.077391, -0.012500, -0.500000);
        points[39] = point(0.089375, -0.012500, -0.500000);
        points[40] = point(0.108125, -0.012500, -0.500000);
        points[41] = point(0.120045, -0.012500, -0.500000);
        points[42] = point(0.151250, -0.012500, -0.500000);
        points[43] = point(0.302500, -0.012500, -0.500000);
        points[44] = point(4.500000, -0.012500, -0.500000);
        points[45] = point(-1.500000, 0.006350, -0.500000);
        points[46] = point(-0.302500, 0.006350, -0.500000);
        points[47] = point(-0.151250, 0.006350, -0.500000);
        points[48] = point(-0.120045, 0.006974, -0.500000);
        points[49] = point(-0.110664, 0.005273, -0.500000);
        points[50] = point(-0.086766, 0.005765, -0.500000);
        points[51] = point(-0.077391, 0.007827, -0.500000);
        points[52] = point(0.000000, 0.009375, -0.500000);
        points[53] = point(0.077391, 0.007827, -0.500000);
        points[54] = point(0.086766, 0.005765, -0.500000);
        points[55] = point(0.110668, 0.005287, -0.500000);
        points[56] = point(0.120045, 0.006974, -0.500000);
        points[57] = point(0.151250, 0.006350, -0.500000);
        points[58] = point(0.302500, 0.006350, -0.500000);
        points[59] = point(4.500000, 0.006350, -0.500000);
        points[60] = point(-1.500000, 0.009525, -0.500000);
        points[61] = point(-0.302500, 0.009525, -0.500000);
        points[62] = point(-0.151250, 0.009525, -0.500000);
        points[63] = point(-0.148750, 0.009525, -0.500000);
        points[64] = point(0.000000, 0.012500, -0.500000);
        points[65] = point(0.148750, 0.009525, -0.500000);
        points[66] = point(0.151250, 0.009525, -0.500000);
        points[67] = point(0.302500, 0.009525, -0.500000);
        points[68] = point(4.500000, 0.009525, -0.500000);
        points[69] = point(-1.500000, 0.062500, -0.500000);
        points[70] = point(-0.302500, 0.062500, -0.500000);
        points[71] = point(-0.151250, 0.062500, -0.500000);
        points[72] = point(-0.148750, 0.062500, -0.500000);
        points[73] = point(0.000000, 0.062500, -0.500000);
        points[74] = point(0.148750, 0.062500, -0.500000);
        points[75] = point(0.151250, 0.062500, -0.500000);
        points[76] = point(0.302500, 0.062500, -0.500000);
        points[77] = point(4.500000, 0.062500, -0.500000);
        points[78] = point(-1.500000, 1.500000, -0.500000);
        points[79] = point(-0.302500, 1.500000, -0.500000);
        points[80] = point(-0.151250, 1.500000, -0.500000);
        points[81] = point(-0.148750, 1.500000, -0.500000);
        points[82] = point(0.000000, 1.500000, -0.500000);
        points[83] = point(0.148750, 1.500000, -0.500000);
        points[84] = point(0.151250, 1.500000, -0.500000);
        points[85] = point(0.302500, 1.500000, -0.500000);
        points[86] = point(4.500000, 1.500000, -0.500000);

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

