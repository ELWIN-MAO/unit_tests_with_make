#include "matrix.h"

using namespace std;

int main()
{
	Matrix2 m = {1, 1, 0, 1};
	cout << "Hello, this is a matrix:\n" << m << endl 
	     << "and this is its inverse:\n" << inv(m) << endl;

}
