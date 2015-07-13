#include "matrix.h"

int main()
{
	//This is not a good test. It's ony here to demonstrate the makefile	
	Matrix2 m = {2, 5, 10, 20};
	std::cout << norm_fro(m) << std::endl;

	return (norm_fro(m) == 23)?EXIT_SUCCESS:EXIT_FAILURE;

}
