/*
 * CRobot.cpp
 *
 *  Created on: 26 sty 2015
 *      Author: X240
 */

#include "CRobot.h"
#include "../newmat10/newmat.h"

CRobot::CRobot(CDummyRobot *_Instance)
{
//	Position = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
//	Dynamics = { 0.0, 0.0 };
	LastUpdateTime = 0.0;

	SensorPosition[0] 	= (tSensor) { 0.1064, 0.1382, 0, 90 };
	SensorPosition[1] 	= (tSensor) { 0.1554, 0.1251, 0, 50 };
	SensorPosition[2] 	= (tSensor) { 0.1906, 0.0831, 0, 30 };
	SensorPosition[3] 	= (tSensor) { 0.2092, 0.0273, 0, 10 };
	SensorPosition[4] 	= (tSensor) { 0.2092, -0.0273, 0, -10 };
	SensorPosition[5] 	= (tSensor) { 0.1906, -0.0785, 0, -30 };
	SensorPosition[6] 	= (tSensor) { 0.1555, -0.1202, 0, -50 };
	SensorPosition[7] 	= (tSensor) { 0.1064, -0.1381, 0, -90 };
	SensorPosition[8] 	= (tSensor) { -0.1103, -0.1382, 0, -90 };
	SensorPosition[9] 	= (tSensor) { -0.1595, -0.1202, 0, -130 };
	SensorPosition[10] 	= (tSensor) { -0.1946, -0.0785, 0, -150 };
	SensorPosition[11] 	= (tSensor) { -0.2132, -0.0273, 0, -170 };
	SensorPosition[12] 	= (tSensor) { -0.2132, 0.0273, 0, 170 };
	SensorPosition[13] 	= (tSensor) { -0.1946, 0.0785, 0, 150 };
	SensorPosition[14] 	= (tSensor) { -0.1595, 0.1203, 0, 130 };
	SensorPosition[15] 	= (tSensor) { -0.1103, 0.1382, 0, 90 };

	Map = new CMap("./points.txt");

	_RobotInstance = _Instance;
	_PositionProxy = new CDummyPosition2dProxy(_RobotInstance);
	_SonarProxy = new CDummySonarProxy(_RobotInstance);

}

CRobot::~CRobot() {
	// TODO Auto-generated destructor stub
}

const tDynamics& CRobot::getDynamics() const {
	return Dynamics;
}

void CRobot::setDynamics(const tDynamics& dynamics) {
	Dynamics = dynamics;
}

const tPositionData& CRobot::getPosition() const {
	return Position;
}

void CRobot::setPosition(const tPositionData& position) {
	Position = position;
}

void CRobot::Update()
{
	double dt = 0.0;
	int iCnt = 0;

	if ( NULL != _RobotInstance )
	{
		_RobotInstance->Read();
		dt = getDeltaTime(&LastUpdateTime);
		Position.PosX += _PositionProxy->GetXSpeed()*dt;
		Position.PosY += _PositionProxy->GetYSpeed()*dt;
		Position.Alpha += _PositionProxy->GetYawSpeed()*dt;

		for (iCnt=0; iCnt<16; iCnt++)
		{
			double dDistance = _SonarProxy->GetScan(iCnt);
			if ( (MAX_SONAR_DISTANCE > dDistance) && (MIN_SONAR_DISTANCE < dDistance) )
			{
				Matrix SensorMatrix(4, 4);
				Matrix MeasureMatrix(4, 4);
				Matrix ObstacleMatrix(4, 4);
				Matrix RobotMatrix(4, 4);
//				Matrix RC(3,3);
//				Matrix RY(3,3);
//				Matrix SC(3,3);
//				Matrix SY(3,3);
//				Matrix SM(3,3);
//				Matrix OD(3,1);
//				Matrix OC(3,1);
				tMapPoint point;

//				double matrRC[] = { 1,0,Position.PosX,0,1,Position.PosY,0,0,1 };
//				double matrRY[] = { cos(Position.Alpha),-sin(Position.Alpha),0,sin(Position.Alpha),cos(Position.Alpha),0,0,0,1 };
//				double matrSC[] = { 1,0,SensorPosition[iCnt].PosX,0,1,SensorPosition[iCnt].PosY,0,0,1 };
//				double matrSY[] = {
//						cos(dtor(SensorPosition[iCnt].Theta)),
//						-sin(dtor(SensorPosition[iCnt].Theta)),
//						0,
//						sin(dtor(SensorPosition[iCnt].Theta)),
//						cos(dtor(SensorPosition[iCnt].Theta)),
//						0,
//						0,
//						0,
//						1
//				};
//				double matrSM[] = { 1,0,dDistance,0,1, 0,0,0,1 };
//				double matrOD[] = { 0,0,1 };
//
//				RC << matrRC;
//				RY << matrRY;
//				SC << matrSC;
//				SY << matrSY;
//				SM << matrSM;
//				OD << matrOD;
//
//				OC = RC*RY*SC*SY*SM*OD;

				double SM[] = {
					cos(dtor(SensorPosition[iCnt].Theta)), -sin(dtor(SensorPosition[iCnt].Theta)), 0, SensorPosition[iCnt].PosX-0.0445,
					sin(dtor(SensorPosition[iCnt].Theta)), cos(dtor(SensorPosition[iCnt].Theta)), 0, SensorPosition[iCnt].PosY,
					0, 0, 1, SensorPosition[iCnt].PosZ,
					0, 0, 0, 1
				};
				SensorMatrix << SM;

				double MM[] = {
					1, 0, 0, dDistance,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1
				};
				MeasureMatrix << MM;

				double RM[] = {
					cos(Position.Alpha), -sin(Position.Alpha), 0, Position.PosX,
					sin(Position.Alpha), cos(Position.Alpha), 0, Position.PosY,
					0, 0, 1, 0,
					0, 0, 0, 1
				};
				RobotMatrix << RM;


				ObstacleMatrix = RobotMatrix * SensorMatrix;

//				printf("Sensor distance: %f\n", dDistance);
				point.PosX = ObstacleMatrix(1, 4);
				point.PosY = ObstacleMatrix(2, 4);
				Map->AddPoint(point);
//				point.PosX = point.PosY = 0.0;

//				point.PosX = Position.PosX;
//				point.PosY = Position.PosY;
//				Map->AddPoint(point);
			}
		}

//		printf("Robot position (%0.2f,%0.2f,%0.2f)\n", Position.PosX, Position.PosY, Position.Alpha);
	}
}
