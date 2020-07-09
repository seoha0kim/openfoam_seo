#include <iostream>
#include <vector>
using namespace std;
int main(){
    vector<double> v2(3);
    vector<double> v3(4, 1.5);
    vector<double> v4(v3);
    cout << "v2: (" << v2[0] << "," << v2[1] << "," << v2[2] << ")" << endl;
    cout << "v3: (" << v3[0] << "," << v3[1] << "," << v3[2] << "," << v3[3] << ")" << endl;
    cout << "v4: (" << v4[0] << "," << v4[1] << "," << v4[2] << "," << v4[3] << ")" << endl;
    cout << "v2.size(): " << v2.size() << endl;

    // cout << "v2: " << v2 << endl;
}