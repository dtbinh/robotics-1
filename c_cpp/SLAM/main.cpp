/*
 * main.cpp
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */


#include "Test/CBaseTest.h"
#include "Test/CFileWriter.h"
#include "basedef.h"
#include "basefcn.h"
#ifdef __WIN32__
#include <windows.h>
#endif

int main(void)
{
	std::list<pts> lPoints;
	CFileWriter* FileWriter = CFileWriter::getInstance();
//	CBaseTest cb;
//
//	double prevTime = 0, dTime = 0;
//
//	getDeltaTime(&prevTime);
//	dTime = getDeltaTime(&prevTime);
//
//	printf("Delta time: %f\n", dTime);
//
//	cb.runTask(0, NULL);

	CDummyRobot robot("127.0.0.1");
	CDummySonarProxy sp(&robot);
	CDummyPosition2dProxy pp(&robot);

	for (;;)//int ii=0; ii<=10; ++ii)
	{
		robot.Read();
		extApi_sleepMs(5);
	}

	delete FileWriter;

	return 0;
}
