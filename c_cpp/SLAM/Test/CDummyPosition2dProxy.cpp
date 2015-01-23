/*
 * CDummyPosition2dProxy.cpp
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 */

#include "CDummyPosition2dProxy.h"

CDummyPosition2dProxy::CDummyPosition2dProxy(CDummyRobot* pRobot) : CDummyClientProxy(pRobot)
{
	const simxInt clientID = pRobot->getClientId();
	XSpeed = YSpeed = YawSpeed = 0.0;
//	printf("Position proxy: %08X\n", this);
	pRobot->RegisterProxy((CDummyClientProxy *)this);
	simxGetObjectHandle(clientID, LEFT_MOTOR_NAME, &LeftMotorHandle, simx_opmode_oneshot_wait);
	simxGetObjectHandle(clientID, RIGHT_MOTOR_NAME, &RightMotorHandle, simx_opmode_oneshot_wait);
}

CDummyPosition2dProxy::~CDummyPosition2dProxy() {
}

double CDummyPosition2dProxy::GetXSpeed() {
	return XSpeed;
}

double CDummyPosition2dProxy::GetYSpeed() {
	return YSpeed;
}

double CDummyPosition2dProxy::GetJointSpeed(const char* cJountName) {

	return 0.0;
}

void CDummyPosition2dProxy::Call() {
//	printf("Calling P2dP\n");
	simxInt clientId = pRobot->getClientId();
	simxFloat Lvelocities[3], LangVelocities[3];
	simxFloat Rvelocities[3], RangVelocities[3];
	simxGetObjectVelocity(clientId, LeftMotorHandle, Lvelocities, LangVelocities, simx_opmode_oneshot_wait);
//	printf("V: %f %f %f, W: %f %f %f\n", Lvelocities[0], Lvelocities[1], Lvelocities[2], LangVelocities[0], LangVelocities[1], LangVelocities[2]);
	simxGetObjectVelocity(clientId, RightMotorHandle, Rvelocities, RangVelocities, simx_opmode_oneshot_wait);
//	printf("V: %f %f %f, W: %f %f %f\n", Rvelocities[0], Rvelocities[1], Rvelocities[2], RangVelocities[0], RangVelocities[1], RangVelocities[2]);
	XSpeed = (Lvelocities[0] + Rvelocities[0])/2;
	YSpeed = (Lvelocities[1] + Rvelocities[1])/2;
	YawSpeed = (LangVelocities[2] + RangVelocities[2])/2;
//	printf("Speeds: %f %f %f\n", XSpeed, YSpeed, YawSpeed);
}

double CDummyPosition2dProxy::GetYawSpeed() {
	return YawSpeed;
}
