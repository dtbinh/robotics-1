/*
 * CDummyRobot.cpp
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 */

#include "CDummyRobot.h"
#include "stdio.h"

CDummyRobot::CDummyRobot() {
	sHostname = "localhost";
	iClientID = -1;
	iPortNumber = 19999;
	this->Connect();
}

CDummyRobot::~CDummyRobot() {
	Disconnect();
}

void CDummyRobot::Connect() {
	printf("Connectiong to %s\n", sHostname.c_str());
	iClientID = simxStart(
			(simxChar*) sHostname.c_str(),
			iPortNumber,
			true,
			true,
			2000,
			5
	);
	printf("Client id: %d\n", iClientID);
}

void CDummyRobot::Disconnect() {
	if (-1 != iClientID)
	{
		simxFinish(iClientID);
	}
}

void CDummyRobot::Read() {
	if (-1 != iClientID) {
		simxInt leftMotorHandle = 0;
		simxGetObjectHandle(iClientID, "Pioneer_p3dx_leftMotor", &leftMotorHandle, simx_opmode_oneshot);
		simxSetJointTargetVelocity(iClientID, leftMotorHandle, 0.4, simx_opmode_oneshot);
	}
}

CDummyRobot::CDummyRobot(std::string Hostname) {
	sHostname = Hostname;
	iClientID = -1;
	iPortNumber = 19999;
	this->Connect();
}
