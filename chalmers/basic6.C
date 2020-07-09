#include <iostream>
using namespace std;
double average (double& x1, double& x2, int nvalues=2){
    x1 = 7.5;
    return (x1+x2)/nvalues;
}
int main(){
    double d1=2.1;
    double d2=3.7;
    cout << "Modified average: " << average(d1,d2) << endl;
    cout << "Half modified average: " << average(d1,d2,4) << endl;
    cout << "d1: " << d1 << ", d2: " << d2 << endl;
}