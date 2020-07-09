#include <iostream>     //Just for cout
using namespace std;    //Just for cout
#include "tensor.H"     //From OpenFOAM
#include "symmTensor.H" //From OpenFOAM
using namespace Foam;   //From OpenFOAM
int main(){
    tensor t1(1, 2, 3, 4, 5, 6, 7, 8, 9); //From OpenFOAM
    cout << "t1[0]: " << t1[0] << endl;
    symmTensor st1(1, 2, 3, 4, 5, 6);     //From OpenFOAM
    cout << "st1[5]: " << st1[5] << endl;
    return 0;
}

// Compile and run with (some trial-and-error, looking at output from wmake for test/tensor):
// g++ -std=c++0x basic8.C -DWM_DP -DWM_LABEL_SIZE=32 -I$FOAM_SRC/OpenFOAM/lnInclude \
//     -L$WM_PROJECT_DIR/lib/$WM_OPTIONS/libOpenFOAM.so -o basic8; ./basic8

// Here, -DWM_DP is for double precision floats and
// -DWM_LABEL_SIZE=32 is for 32 bit int.
// We include header files (declarations) from $FOAM_SRC/OpenFOAM/lnInclude
// We link to library (definitions) $WM_PROJECT_DIR/lib/$WM_OPTIONS/libOpenFOAM.so