/*
 * main.cpp
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */


#include "Test/CBaseTest.h"
#include "Test/CFileWriter.h"
#include "basedef.h"
#include <v_repConst.h>

int main(void)
{
	std::list<pts> lPoints;
	CFileWriter* FileWriter = CFileWriter::getInstance();
	CBaseTest cb;

	double prevTime = 0, dTime = 0;

	cb.getDeltaTime(&prevTime);
	dTime = cb.getDeltaTime(&prevTime);

	printf("Delta time: %f\n", dTime);

//	cb.runTask(NULL, NULL);

	simxInt portNb = 99999;

	int clientID=simxStart((simxChar*)"127.0.0.1",portNb,true,true,2000,5);
	if (clientID!=-1)
	{

		while (simxGetConnectionId(clientID)!=-1)
		{
			simxInt leftMotorHandle = 0;
			simxGetObjectHandle(clientID, "Pioneer_p3dx_leftMotor", &leftMotorHandle, simx_opmode_oneshot);
			simxSetJointTargetVelocity(clientID, leftMotorHandle, 0.0, simx_opmode_oneshot);
			extApi_sleepMs(5);
		}
		simxFinish(clientID);
	}

	delete FileWriter;

	return 0;
}
