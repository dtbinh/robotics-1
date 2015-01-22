/*
 * CDummyClientProxy.h
 *
 *  Created on: 22 sty 2015
 *      Author: X240
 */

#ifndef CDUMMYCLIENTPROXY_H_
#define CDUMMYCLIENTPROXY_H_

#include "CDummyRobot.h"

class CDummyRobot;

class CDummyClientProxy {
protected:
	CDummyRobot *pRobot;
public:
	CDummyClientProxy(CDummyRobot * pRobot);
	virtual ~CDummyClientProxy();

	virtual void Call();
};

#endif /* CDUMMYCLIENTPROXY_H_ */
