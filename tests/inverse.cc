#include "matrix.h"
#include <random>
#include <iostream>
using namespace std;


int main()
{
	mt19937 rng;
	uniform_real_distribution<> r(-1, 1);
	int N=10000;
	double sum=0;
	
	for(int i=0; i < N; i++)
	{
		Matrix2 m = {r(rng), r(rng), r(rng), r(rng) };
		sum += norm_fro(m * inv(m))-sqrt(2);
	}

	cout << sum / N << endl;

	if(sum / N > 1e-8)
	{
		return EXIT_FAILURE;
	}

	cout << "OK\n";
}
