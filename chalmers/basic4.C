#include <iostream>
using namespace std;
double average (double x1, double x2){
    int nvalues = 2;
    return (x1+x2)/nvalues;
}

int main(){
    double d1=2.1;
    double d2=3.7;
    cout << "Average: " << average(d1,d2) << endl;
}