/**
 * CDummyRobot.h
 *
 *  Created on: Jan 15, 2015
 *      Author: hristohristoskov
 *
 *  Describes dummy robot with methods and properties of previously used
 *  player robot interface.
 *  Currently contains fancy methods
 */

#ifndef CDUMMYROBOT_H_
#define CDUMMYROBOT_H_

#include "../basedef.h"
#include "../basefcn.h"
#include <string>
#include "CDummyClientProxy.h"

extern "C" {
    #include "../vrep/extApi.h"
	#include "../vrep/extApiCustom.h"
	#include "../vrep/extApiPlatform.h"
}

class CDummyClientProxy;

typedef CDummyClientProxy * tPlist;

class CDummyRobot {
	std::string sHostname;
	simxInt iClientID;
	simxInt iPortNumber;
	std::list<tPlist> Proxies;

	void Connect();
	void Disconnect();
public:
	CDummyRobot();
	CDummyRobot(std::string Hostname);
	virtual ~CDummyRobot();

	void Read();
	bool RegisterProxy(CDummyClientProxy * pProxy);
	simxInt getClientId() const;
};

#endif /* CDUMMYROBOT_H_ */
