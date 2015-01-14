/*
 * main.cpp
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */


#include "Test/CBaseTest.h"
#include "Test/CFileWriter.h"

int main(void)
{
	std::list<pts> lPoints;
	CFileWriter* FileWriter = CFileWriter::getInstance();
	CBaseTest cb;

	double prevTime = 0, dTime = 0;

	cb.getDeltaTime(&prevTime);
	cb.addPoint(19,55,3);
	cb.addPoint(29,55,3);
	cb.addPoint(39,55,3);
	cb.addPoint(49,55,3);
	cb.addPoint(59,55,3);
	dTime = cb.getDeltaTime(&prevTime);

	printf("Delta time: %f\n", dTime);

	delete FileWriter;

	return 0;
}
