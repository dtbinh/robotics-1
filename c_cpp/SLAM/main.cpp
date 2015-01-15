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
	dTime = cb.getDeltaTime(&prevTime);

	printf("Delta time: %f\n", dTime);

	cb.runTask(NULL, NULL);

	delete FileWriter;

	return 0;
}
