/*
 * basefcn.cpp
 *
 *  Created on: 23 sty 2015
 *      Author: X240
 */

#include "basefcn.h"
#include <sys/time.h>


double getDeltaTime(double *dPrevTime) {
	double diff = 0.0;
	struct timeval cTime;
	gettimeofday(&cTime, NULL);
	if (*dPrevTime > 0) {
		diff = ((cTime.tv_sec+(cTime.tv_usec/1000000.0)) - *dPrevTime);
		*dPrevTime = cTime.tv_sec+(cTime.tv_usec/1000000.0);
	} else {
		*dPrevTime = cTime.tv_sec+(cTime.tv_usec/1000000.0);
	}
	return diff;
}
