/*
 * CDummySonarProxy.cpp
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 */

#include "CDummySonarProxy.h"

CDummySonarProxy::~CDummySonarProxy() {
	// TODO Auto-generated destructor stub
}

void CDummySonarProxy::Call() {
	simxUChar poin;
	simxFloat vector[3], pos[3];
	simxInt clientId = pRobot->getClientId();
	char data[1024] = "Distances: ";
	for (int cnt=0; cnt<16; cnt++)
	{
		simxReadProximitySensor(clientId, SensorHandles[cnt], &poin, pos, NULL, vector, simx_opmode_oneshot_wait);
		// xxx: fix me
		simxFloat dist = sign((vector[0]*pos[0]+vector[1]*pos[1]+vector[2]*pos[2]))*(vector[0]*pos[0]+vector[1]*pos[1]+vector[2]*pos[2])/sqrt(vector[0]*vector[0]+vector[1]*vector[1]+vector[2]*vector[2]);
		if (!poin) dist = 0.0;
//		printf("Sonar: reading robId: %d, vector: %f %f %f, detected: %d, distance: %f\n", clientId, vector[0], vector[1], vector[2], poin, dist);
		sprintf(data, "%s s%d: %1.2f", data, cnt+1, dist);
		SensorDistances[cnt] = dist;
	}
//	printf("%s\n", data);
}

double CDummySonarProxy::GetScan(int lNumber) {
	return (double) SensorDistances[lNumber];
}

CDummySonarProxy::CDummySonarProxy(CDummyRobot* pRobot) : CDummyClientProxy(pRobot)
{
	const simxInt clientID = pRobot->getClientId();
//	printf("Sonar proxy: %08X\n", this);
	pRobot->RegisterProxy((CDummyClientProxy *)this);
	for (int cnt=0; cnt<16; cnt++)
	{
		char name[255];
		sprintf(name, "Pioneer_p3dx_ultrasonicSensor%d", cnt+1);
		simxGetObjectHandle(clientID, name, &SensorHandles[cnt], simx_opmode_oneshot_wait);
	}
}
