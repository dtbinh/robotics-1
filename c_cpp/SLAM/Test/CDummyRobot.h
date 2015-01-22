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
#include <string>
#include "CDummyClientProxy.h"

#define MAX_EXT_API_CONNECTIONS 255

extern "C" {
    #include "extApi.h"
	#include "extApiCustom.h"
	#include "extApiPlatform.h"
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
