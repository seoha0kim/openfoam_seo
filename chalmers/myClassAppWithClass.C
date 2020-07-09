#include <iostream> //Just for cout
using namespace std; //Just for cout

// class myClass{
//     private:
//     protected:
//     public:
//         // int i_=19; //Member data (underscore is OpenFOAM convention)
//         // myClass(){
//         //     cout << "i_ = " << i_ << endl;
//         // };
//         // ~myClass()
//         // {};

//         int i_; //Member data (underscore is OpenFOAM convention)
//         float j_;
//         myClass():i_(20),j_(21.5){
//             cout << "i_ = " << i_ << endl;
//             cout << "j_ = " << j_ << endl;
//         };
//         ~myClass()
//         {};
// };

class myClass{
    private:
    protected:
    public:
        int i_; //Member data (underscore is OpenFOAM convention)
        float j_;
        myClass();
        ~myClass();
};
myClass::myClass()
:i_(20),j_(21.5){
    cout<< "i_ = " << i_ << endl;
}
myClass::~myClass(){}

int main(){
    myClass myClassObject;
    cout << "myClassObject.i_:  " << myClassObject.i_ << endl;
    // return 0;

    cout<< "myClassObject.i_: " << myClassObject.i_ << endl;
    cout<< "myClassObject.j_: " << myClassObject.j_ << endl;

    myClass myClassObject2;
    cout<< "myClassObject2.i_: " << myClassObject2.i_ << endl;
    myClassObject2.i_= 30;
    cout<< "myClassObject.i_: " << myClassObject.i_ << endl;
    cout<< "myClassObject2.i_: " << myClassObject2.i_ << endl;

    myClass& myClassObjectRef = myClassObject;

    cout<< "myClassObjectRef.i_: " << myClassObjectRef.i_ <<endl;
    myClassObject.i_=42;

    cout<< "myClassObject.i_: " << myClassObject.i_ << endl;
    cout<< "myClassObjectRef.i_: " << myClassObjectRef.i_ <<endl;myClassObjectRef.i_=43;
    cout<< "myClassObject.i_: " << myClassObject.i_ << endl;
    cout<< "myClassObjectRef.i_: " << myClassObjectRef.i_ <<endl;

    return 0;
}