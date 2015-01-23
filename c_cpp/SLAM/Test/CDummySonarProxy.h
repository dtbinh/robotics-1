/*
 * CDummySonarProxy.h
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 *
 *  Dummy interface to previously used player sonar proxy
 */

#ifndef CDUMMYSONARPROXY_H_
#define CDUMMYSONARPROXY_H_

#include "../basedef.h"
#include "CDummyClientProxy.h"

#define SENSOR_NAME_01		"Pioneer_p3dx_ultrasonicSensor1"
#define SENSOR_NAME_02		"Pioneer_p3dx_ultrasonicSensor2"
#define SENSOR_NAME_03		"Pioneer_p3dx_ultrasonicSensor3"
#define SENSOR_NAME_04		"Pioneer_p3dx_ultrasonicSensor4"
#define SENSOR_NAME_05		"Pioneer_p3dx_ultrasonicSensor5"
#define SENSOR_NAME_06		"Pioneer_p3dx_ultrasonicSensor6"
#define SENSOR_NAME_07		"Pioneer_p3dx_ultrasonicSensor7"
#define SENSOR_NAME_08		"Pioneer_p3dx_ultrasonicSensor8"
#define SENSOR_NAME_09		"Pioneer_p3dx_ultrasonicSensor9"
#define SENSOR_NAME_10		"Pioneer_p3dx_ultrasonicSensor10"
#define SENSOR_NAME_11		"Pioneer_p3dx_ultrasonicSensor11"
#define SENSOR_NAME_12		"Pioneer_p3dx_ultrasonicSensor12"
#define SENSOR_NAME_13		"Pioneer_p3dx_ultrasonicSensor13"
#define SENSOR_NAME_14		"Pioneer_p3dx_ultrasonicSensor14"
#define SENSOR_NAME_15		"Pioneer_p3dx_ultrasonicSensor15"
#define SENSOR_NAME_16		"Pioneer_p3dx_ultrasonicSensor16"


class CDummySonarProxy : public CDummyClientProxy
{
private:
	simxInt SensorHandles[16];
	simxFloat SensorDistances[16];

	/// xxx
	unsigned char* cSignal;
	simxInt sLength;
public:
	CDummySonarProxy(CDummyRobot * pRobot);
	virtual ~CDummySonarProxy();

	virtual void Call();

	double GetScan(int lNumber);
};

#endif /* CDUMMYSONARPROXY_H_ */
