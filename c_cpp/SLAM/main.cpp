/*
 * main.cpp
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */


#include "Test/CBaseTest.h"
#include "Test/CFileWriter.h"
#include "basedef.h"
#ifdef __WIN32__
#include <windows.h>
#endif

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

//	CDummyRobot robot("127.0.0.1");
//	CDummySonarProxy sp(&robot);
//
//	for (int ii=0; ii<=10; ++ii)
//	{
//		robot.Read();
//		Sleep(100);
//	}

//	delete FileWriter;

	return 0;
}
