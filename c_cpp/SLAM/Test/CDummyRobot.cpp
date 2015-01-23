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
	printf("Connecting to %s\n", sHostname.c_str());

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
	double dt = 0.0, prevTime = 0.0;

	getDeltaTime(&prevTime);

	if (-1 != iClientID) {
		std::list<tPlist>::iterator iProxies;
		for (iProxies = Proxies.begin(); iProxies != Proxies.end(); ++iProxies)
		{
			(*iProxies)->Call();
		}
	}
	dt = getDeltaTime(&prevTime);
//	printf("Robot::Read execution time: %f\n", dt);
}

CDummyRobot::CDummyRobot(std::string Hostname) {
	sHostname = Hostname;
	iClientID = -1;
	iPortNumber = 19999;
	this->Connect();
}

simxInt CDummyRobot::getClientId() const {
	return iClientID;
}

bool CDummyRobot::RegisterProxy(CDummyClientProxy * pProxy) {
	Proxies.push_back(pProxy);
	printf("Registering proxy: %08X\n", pProxy);
	return true;
}
