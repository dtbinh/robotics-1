/*
 * basedef.h
 *
 *  Created on: Jan 14, 2015
 *      Author: hristohristoskov
 */

#ifndef BASEDEF_H_
#define BASEDEF_H_

#include <iostream>
#include <cmath>
#include <list>
#ifdef __WIN32__
#include <stdio.h>
#endif

#define PI 				(double) (std::atan(1) * 4)
#define rtod(deg)  		(double) ((deg) * PI / 180)
#define dtor(rad)  		(double) ((rad) * 180 / PI)
#define sign(number) 	(number >= 0) ? 1 : -1


typedef struct sMapPoint
{
	double PosX;
	double PosY;
}tMapPoint;

typedef struct sSensor {
	double PosX;
	double PosY;
	double PosZ;
	double Theta;
}tSensor;

typedef struct sSensorData
{
	double Distance;
	double dt;
} tSensorData;

class pts {
    public:
        double x;
        double y;

    	bool operator < (const pts& rhs) const {
    		bool bResult = false;
        	if (this->x < rhs.x)
        	{
        		bResult =  true;
        	}
        	else if ( (this->x == rhs.x) && (this->y < rhs.y) )
        	{
        		bResult = true;
        	}
			//if (sqrt((x-rhs.x)*(x-rhs.x)+(y-rhs.y)*(y-rhs.y)) < maxDist) {
				//maxDist = sqrt((x-rhs.x)*(x-rhs.x)+(y-rhs.y)*(y-rhs.y));
				//return true;
			//}
        	return bResult;
   		}

		bool operator == (const pts& rhs) {
			return ((rhs.x == this->x)&&(rhs.y == this->y));
		}

};

class lns {
    public:
		double r;
		double th;
        double x[2];
        double y[2];

		double lineSize() {
			return sqrt((x[1]-x[0])*(x[1]-x[0])+(y[1]-y[0])*(y[1]-y[0]));
		}

		bool operator < (lns& rhs) {
			return (this->lineSize() < rhs.lineSize());
		}
};



#endif /* BASEDEF_H_ */
