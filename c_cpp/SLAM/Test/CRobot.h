/*
 * CRobot.h
 *
 *  Created on: 26 sty 2015
 *      Author: X240
 */

#ifndef CROBOT_H_
#define CROBOT_H_

#include "../basedef.h"
#include "../basefcn.h"
#include "CDummyRobot.h"
#include "CDummyPosition2dProxy.h"
#include "CDummySonarProxy.h"
#include "CMap.h"

typedef struct sPositionData
{
	double PosX;
	double PosY;
	double PosZ;
	double Alpha;
	double Betha;
	double Gamma;
} tPositionData;

typedef struct sDynamics
{
	double Vxy;		// translational speed in XY
	double Wxy;		// rotational speed in XY
} tDynamics;

class CRobot {
private:
	// These should be calculated values
	tPositionData Position;
	tDynamics Dynamics;
	CMap *Map;

	tSensor SensorPosition[16];

	CDummyRobot *_RobotInstance;
	CDummyPosition2dProxy *_PositionProxy;
	CDummySonarProxy *_SonarProxy;

	double LastUpdateTime;
public:
	CRobot(CDummyRobot *_Instance);
	virtual ~CRobot();

	void Update();
	const tDynamics& getDynamics() const;
	void setDynamics(const tDynamics& dynamics);
	const tPositionData& getPosition() const;
	void setPosition(const tPositionData& position);
};

#endif /* CROBOT_H_ */
