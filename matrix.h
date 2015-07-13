#ifndef MATRIX_H
#define MATRIX_H

#include <cmath>
#include <initializer_list>
#include <array>
#include <cassert>
#include <iostream>
struct Matrix2
{
	
	std::array<std::array<double, 2>, 2> data;

	public:

		Matrix2(std::initializer_list<double> i)
		{
			assert(i.size() == 4);
			auto d = i.begin();
			data ={ *(d+0), *(d+1), *(d+2), *(d+3)};
		}

		std::array<double,2>& operator[](int i)
		{
			return data[i];
		}	

		const std::array<double,2>& operator[](int i) const
		{
			return data[i];
		}	


		Matrix2 operator*(const Matrix2& m) const
		{
			Matrix2 ret = {0,0,0,0};

			for(int r=0; r < 2; r++)	
				for(int c=0; c < 2; c++)	
					for(int i=0; i < 2; i++)
						ret[r][c] += (*this)[r][i] * m[i][c];
			return ret;
		}

};

inline double norm_fro(const Matrix2& m)
{
	double f=0;
	for(int r=0; r < 2; r++)	
		for(int c=0; c < 2; c++)	
			f+=m[r][c]*m[r][c];

	return sqrt(f);
}

inline Matrix2 inv(const Matrix2& m)
{
	double d = 1./(m[0][0]*m[1][1] - m[1][0]*m[0][1]);

	return {
		 m[1][1]*d,  -m[0][1]*d ,
		 -m[1][0]*d,  m[0][0]*d 
	};
}

std::ostream& operator<<(std::ostream& o, const Matrix2& m)
{
	o<< m[0][0] << " " << m[0][1] << std::endl;
	o<< m[1][0] << " " << m[1][1] << std::endl;
	return o;
}

#endif
