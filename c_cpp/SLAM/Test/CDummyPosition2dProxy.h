/*
 * CDummyPosition2dProxy.h
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 *
 *  Dummy interface to previously used player position 2D proxy
 */

#ifndef CDUMMYPOSITION2DPROXY_H_
#define CDUMMYPOSITION2DPROXY_H_

#include "CDummyClientProxy.h"

#define LEFT_MOTOR_NAME			"Pioneer_p3dx_leftMotor"
#define RIGHT_MOTOR_NAME		"Pioneer_p3dx_rightMotor"

class CDummyPosition2dProxy : public CDummyClientProxy
{
private:
	double XSpeed;
	double YSpeed;
	double YawSpeed;

	simxInt LeftMotorHandle;
	simxInt RightMotorHandle;

	/// xxx
	unsigned char* cSignal;
	simxInt sLength;

public:
	CDummyPosition2dProxy(CDummyRobot* pRobot);
	virtual ~CDummyPosition2dProxy();

	virtual void Call();

	double GetXSpeed();
	double GetYSpeed();
	double GetYawSpeed();
};

#endif /* CDUMMYPOSITION2DPROXY_H_ */
