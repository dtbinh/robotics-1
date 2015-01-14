/*
 * CBaseTest.h
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */

#ifndef CBASETEST_H_
#define CBASETEST_H_

#include "../basedef.h"
#include <stdio.h>
#include <sys/time.h>
#include "CFileWriter.h"


struct locLines {
	double r;
	double th;
	double x[2];
	double y[2];
};


typedef struct sSensor {
	double PosX;
	double PosY;
//	double PosZ = 0;
	double Theta;
}tSensor;


//sSensor sensors[16] = {
//		{ 0.075, 0.130, 90 },
//		{ 0.115, 0.115, 50 },
//		{ 0.150, 0.080, 30 },
//		{ 0.170, 0.025, 10 },
//		{ 0.170, -0.025, -10 },
//		{ 0.150, -0.080, -30 },
//		{ 0.115, -0.115, -50 },
//		{ 0.075, -0.130, -90 },
//		{ -0.155, -0.130, -90 },
//		{ -0.195, -0.115, -130 },
//		{ -0.230, -0.080, -150 },
//		{ -0.250, -0.025, -170 },
//		{ -0.250, 0.025, 170 },
//		{ -0.230, 0.080, 150 },
//		{ -0.195, 0.115, 130 },
//		{ -0.155, 0.130, 90 }
//};

class CBaseTest {
private:
	std::list<lns> lLines;
	std::list<pts> lPoints;

	CFileWriter* FileWriter;


	// Temporary variables
	double minErr;
	bool flagPredict;
	double dx, dy, da;
	double currentX, currentY;
	double px, py, pa;
	locLines localLines[16];
	double currentAngle;
	int linNum[16];
	double mMZ[32];
	int num;
public:
	CBaseTest();
	virtual ~CBaseTest();

	void WritePointListToFile(std::list<pts>* pList, char* cFileName);


	// Not optimized
	int addPoint(double x, double y, double z);
	bool isInSegment(lns segment, pts point);

	double getDeltaTime(double *dPrevTime);
	double normalize(double dAngleRad);
	void llsq (int n, double cx[], double cy[], double &a, double &b);
	bool isInSegment(double dStartX, double dStartY, double dEndX, double dEndY, double lx, double ly);
	void getNewEdges(double& dStartX, double& dStartY, double& dEndX, double& dEndY, double lx, double ly);
	bool findIntersection(double dPointX, double dPointY, double dx, double dy, double da, int num);
	void writePtsToFile();

	// Temporary methods

};

#endif /* CBASETEST_H_ */
