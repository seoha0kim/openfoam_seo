#include <iostream>
using namespace std;
int main(){
    double d1=2.1;
    double d2=3.7;
    double*d3; //d3 is a pointer, currently not pointing at anything
    d3 = &d1; //Now d3 points at the memory location of d1
    cout << "d1: " << d1 << endl;
    cout << "d2: " << d2 << endl;
    cout << "d3: " << d3 << endl;
    cout << "*d3: " <<*d3 << endl;
    d3 = &d2; //Now d3 points at the memory location of d2
    cout << "d3: " << d3 << endl;
    cout << "*d3: " <<*d3 << endl;
}
// Compile and run with:g++ basic7.C -o basic7; ./basic7