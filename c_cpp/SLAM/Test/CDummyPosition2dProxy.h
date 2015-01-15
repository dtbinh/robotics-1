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

class CDummyPosition2dProxy {
public:
	CDummyPosition2dProxy();
	virtual ~CDummyPosition2dProxy();

	double GetXSpeed();
	double GetYSpeed();
	double GetYawSpeed();
};

#endif /* CDUMMYPOSITION2DPROXY_H_ */
