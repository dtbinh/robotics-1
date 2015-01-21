/*
 * CBaseTest.cpp
 *
 *  Created on: Dec 24, 2014
 *      Author: hristohristoskov
 */

#include "CBaseTest.h"
#include <string.h>

CBaseTest::CBaseTest() {
	FileWriter = CFileWriter::getInstance();
	sp1 = new CDummySonarProxy();

	minErr = 0.2;
	flagPredict = false;
	dx = dy = da = 0.0;
	currentX = currentY = currentAngle = 0.0;
	px = py = pa = 0;
	num = 0;
	maxSonarVal = 1.2;
	minDistance = 0.3;
	currentV = 0.0;
	currentW = 0.0;

	prevX = prevY = prevAngle = prevV = prevW = 0.0;

	sensPosition[0] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[1] 	= (tSensor) { 0.115, 0.115, 0, 50 };
	sensPosition[2] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[3] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[4] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[5] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[6] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[7] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[8] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[9] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[10] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[11] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[12] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[13] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[14] 	= (tSensor) { 0.075, 0.130, 0, 90 };
	sensPosition[15] 	= (tSensor) { 0.075, 0.130, 0, 90 };

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

}

CBaseTest::~CBaseTest() {
	// TODO Auto-generated destructor stub
}

int CBaseTest::addPoint(double x, double y, double &dx, double &dy, double &da, bool flagPredict, int num)
{

	pts points;
	std::list<pts>::iterator pI;
	std::list<pts>::iterator pN;
	std::list<lns>::iterator pL;
	double maxDistance = 999, d1, d2, dist, error, ex[2], ey[2];

	points.x = x;
	points.y = y;
	dx = 0;
	dy = 0;

	bool flagInsert = false;
	bool flagLine = false;

	if (lLines.size() > 0) {
		for (pL = lLines.begin(); pL != lLines.end(); ++pL) {

			double cth, cdist;
			cth = pL->th;
			cdist = pL->r;
			error = abs(cdist - x*cos(cth)-y*sin(cth));
			if (error < minErr) {
				ex[0] = pL->x[0];
				ex[1] = pL->x[1];
				ey[0] = pL->y[0];
				ey[1] = pL->y[1];
				if (isToSegment(ex[0], ey[0], ex[1], ey[1], x, y)) {
					getNewEdges(ex[0], ey[0], ex[1], ey[1], x, y);
					pL->x[0] = ex[0];
					pL->x[1] = ex[1];
					pL->y[0] = ey[0];
					pL->y[1] = ey[1];
					flagLine = true;
					return true;
				}
			}
		}
	}

	if (findIntersection(x, y, dx, dy, da, num)) {
		return false;
	}

	if (lPoints.size() > 0) {
		for (pI = lPoints.begin(); pI != lPoints.end(); ++pI) {
			dist = sqrt((x-pI->x)*(x-pI->x)+(y-pI->y)*(y-pI->y));
			if (dist < maxDistance) {
				maxDistance = dist;
				if ((pI!=lPoints.begin())&&(pI!=lPoints.end())) {
					pI--;
					d1 = sqrt((x-pI->x)*(x-pI->x)+(y-pI->y)*(y-pI->y));
					pI++;
					pI++;
					d2 = sqrt((x-pI->x)*(x-pI->x)+(y-pI->y)*(y-pI->y));
					if (d2<d1) {
						pN = pI;
						pI--;
					} else {
						pI--;
						pN = pI;
					}
				}
				if (pI==lPoints.begin()) {
					pI++;
					d2 = sqrt((x-pI->x)*(x-pI->x)+(y-pI->y)*(y-pI->y));
					if (d2<maxDistance) {
						pN = pI;
						pI--;
					} else {
						pI--;
						pN = pI;
					}
				}
				flagInsert = true;
			}
			if (dist==0) {
				flagInsert = false;
				maxDistance = 0;
			}
		}
		if (flagInsert&&!flagPredict) {
			lPoints.insert(pN, points);
		}
	} else {
		if (!flagPredict)
			lPoints.push_back(points);
		flagInsert = true;
	}
	if (flagInsert) {
		writePtsToFile();
	}

	return flagInsert||flagLine;
}

bool CBaseTest::isInSegment(lns segment, pts point) {
	//TODO: implement me
	return false;
}

bool CBaseTest::isInSegment(double dStartX, double dStartY, double dEndX,
		double dEndY, double lx, double ly)
{
	double d[3];
	d[0] = sqrt((dEndX-dStartX)*(dEndX-dStartX)+(dEndY-dStartY)*(dEndY-dStartY));
	d[1] = sqrt((dEndX-lx)*(dEndX-lx)+(dEndY-ly)*(dEndY-ly));
	d[2] = sqrt((dStartX-lx)*(dStartX-lx)+(dStartY-ly)*(dStartY-ly));

	return ((d[1] < d[0])&&(d[2] < d[0]));
}

void CBaseTest::getNewEdges(double& dStartX, double& dStartY, double& dEndX,
		double& dEndY, double lx, double ly)
{
	double d[3];
	d[0] = sqrt((dEndX-dStartX)*(dEndX-dStartX)+(dEndY-dStartY)*(dEndY-dStartY));
	d[1] = sqrt((dEndX-lx)*(dEndX-lx)+(dEndY-ly)*(dEndY-ly));
	d[2] = sqrt((dStartX-lx)*(dStartX-lx)+(dStartY-ly)*(dStartY-ly));
	if (d[0] < d[1]) {
		dStartX = lx;
		dStartY = ly;
	} else if (d[0] < d[2]) {
		dEndX = lx;
		dEndY = ly;
	}
}

double CBaseTest::getDeltaTime(double *dPrevTime) {
	double diff = 0.0;
	struct timeval cTime;
	gettimeofday(&cTime, NULL);
	if (*dPrevTime > 0) {
		diff = ((cTime.tv_sec+(cTime.tv_usec/1000000.0)) - *dPrevTime);
		*dPrevTime = cTime.tv_sec+(cTime.tv_usec/1000000.0);
	} else {
		*dPrevTime = cTime.tv_sec+(cTime.tv_usec/1000000.0);
	}
	return diff;
}

void CBaseTest::writePtsToFile()
{
	FileWriter->WritePointListToFile(&lPoints, "./points.txt");
}

bool CBaseTest::findIntersection(double dPointX, double dPointY, double dx,
		double dy, double da, int num) {
	std::list<lns>::iterator pL;
	//double px, py;

	double cx[2], cy[2], cth, cdist, a, c, tmp;

	cx[0] = currentX;
	cy[0] = currentY;
	cx[1] = dPointX;
	cy[1] = dPointY;


	if(abs((cy[0]-cy[1])/(cx[0]-cx[1]))>1) {
		tmp = cx[0];
		cx[0] = cy[0];
		cy[0] = -tmp;
		tmp = cx[1];
		cx[1] = cy[1];
		cy[1] = -tmp;
		cth = dtor(90);
	} else {
		cth = 0;
	}


	llsq(2, cx, cy, a, c);
	cth += atan2(sign(c)/sqrt(a*a+1), -a*sign(c)/sqrt(a*a+1));
	cth = normalize(cth);
	cdist = c*sign(c)/sqrt(a*a+1);
	int o = 0;
	for (int i=0; i<32; i++) {
		if (i<16)
			linNum[i] = 0;
		mMZ[i] = 0.0;
	}
	if (lLines.size() > 0) {
		for (pL = lLines.begin(); pL != lLines.end(); ++pL) {
			bool flagParallel = false;
			o++;
			if ( abs(sin(cth-pL->th)) > abs(sin(pL->th-cth)) ) {
				px = ( pL->r*sin(cth) - cdist*sin(pL->th) )/sin(cth-pL->th);
				if ( abs(sin(cth)) > abs(sin(pL->th)) )
					py = ( cdist - px*cos(cth) )/sin(cth);
				else
					py = ( pL->r - px*cos(pL->th) )/sin(pL->th);
			} else if ( sin(cth-pL->th) == sin(pL->th-cth) ) {
				flagParallel = true;
				px=0;
				py=0;
				pa=0;
			} else {
				py = ( pL->r*cos(cth) - cdist*cos(pL->th) )/sin(pL->th-cth);
				if (abs(cos(cth))>abs(cos(pL->th)))
					px = ( cdist - py*sin(cth) )/cos(cth);
				else
					px = ( pL->r - py*sin(pL->th) )/cos(pL->th);
			}
			if ( (!flagParallel) &&
					(isInSegment(pL->x[0], pL->y[0], pL->x[1], pL->y[1], px, py)) &&
					(isInSegment(currentX, currentY, dPointX, dPointX, px, py))
					)
			{
				FILE *fp = fopen("./scan_err.txt","a");
				fprintf(fp,"%f\t%f\n", px, py);
				fclose(fp);
				if (localLines[num].r > 0.0) {
					double r = localLines[num].r + currentX*cos(pL->th) + currentY*sin(pL->th);
					double d = r - pL->r;
					px = d*cos(pL->th);
					py = d*sin(pL->th);
					pa = normalize(localLines[num].th + currentAngle - pL->th);
					linNum[num] = o;
					printf("pa: %f px: %f py: %f\n", rtod(pa), px, py);
				} else {
					pa = 0;
					px = 0;
					py = 0;
				}
				return true;
			} else {
				pa = 0;
				px = 0;
				py = 0;
			}
		}
	}
	return false;
}

double CBaseTest::normalize(double dAngleRad) {
	double dAngleDeg = fmod(rtod(dAngleRad) + 180, 360);
	if (dAngleDeg < 0)
		dAngleDeg += 180;
	return dtor(dAngleDeg - 180);
}

void CBaseTest::llsq(int n, double cx[], double cy[], double& a, double& b) {
	double bot;
	int i;
	double top;
	double xbar;
	double ybar;

	if ( n == 1 )
	{
		a = 0.0;
		b = cy[0];
		return;
	}

	xbar = 0.0;
	ybar = 0.0;
	for ( i = 0; i < n; i++ )
	{
		xbar = xbar + cx[i];
		ybar = ybar + cy[i];
	}
	xbar = xbar / ( double ) n;
	ybar = ybar / ( double ) n;

	top = 0.0;
	bot = 0.0;
	for ( i = 0; i < n; i++ )
	{
		top = top + ( cx[i] - xbar ) * ( cy[i] - ybar );
		bot = bot + ( cx[i] - xbar ) * ( cx[i] - xbar );
	}
	a = top / bot;
	b = ybar - a * xbar;
	return;
}

void CBaseTest::findLocalLines() {
	double x[2], y[2], cth, cdist;

	for (int i = 0; i<15; i++) {
		if ((sp[i]<maxSonarVal)&&(sp[i+1]<maxSonarVal)) {
			x[0] = sp[i]*cos(dtor(sensPosition[i].Theta))+sensPosition[i].PosX;
			y[0] = sp[i]*sin(dtor(sensPosition[i].Theta))+sensPosition[i].PosY;
			x[1] = sp[i+1]*cos(dtor(sensPosition[i+1].Theta))+sensPosition[i+1].PosX;
			y[1] = sp[i+1]*sin(dtor(sensPosition[i+1].Theta))+sensPosition[i+1].PosY;
			tllsq(x,y,cth,cdist);
			localLines[i].th = cth;
			localLines[i].r = cdist;
			localLines[i].x[0] = x[0];
			localLines[i].x[1] = x[1];
			localLines[i].y[0] = y[0];
			localLines[i].y[1] = y[1];
		} else {
			localLines[i].r = 0;
			localLines[i].th = 0;
		}
	}
	if ((sp[15]<maxSonarVal)&&(sp[0]<maxSonarVal)) {
		x[0] = sp[15]*cos(dtor(sensPosition[15].Theta))+sensPosition[15].PosX;
		y[0] = sp[15]*sin(dtor(sensPosition[15].Theta))+sensPosition[15].PosY;
		x[1] = sp[0]*cos(dtor(sensPosition[0].Theta))+sensPosition[0].PosX;
		y[1] = sp[0]*sin(dtor(sensPosition[0].Theta))+sensPosition[0].PosY;
		tllsq(x,y,cth,cdist);
		localLines[15].th = cth;
		localLines[15].r = cdist;
		localLines[15].x[0] = x[0];
		localLines[15].x[1] = x[1];
		localLines[15].y[0] = y[0];
		localLines[15].y[1] = y[1];
	} else {
		localLines[15].r = 0;
		localLines[15].th = 0;
	}
}

void CBaseTest::findNewLines() {
	std::list<pts>::iterator pI;
	pts tpt;
	double cth, cdist, x, y, error = 2;
	int iterrations = 200;
	while ((iterrations > 0)&&(lPoints.size() > 20)&&(getInlier(cth, cdist))) {
		pI = lPoints.begin();
		do {
			x = pI->x;
			y = pI->y;
			error = abs(cdist - x*cos(cth)-y*sin(cth));
			if (error < minErr) {
				tpt.x = pI->x;
				tpt.y = pI->y;
				lTpts.push_back(tpt);
				pI = lPoints.erase(pI);
			} else {
				pI++;
			}
		} while ((pI != lPoints.end())&&(!lPoints.empty()));
		if (lTpts.size() > 25) {
			findLineSegment(cth, cdist);
		}
		if (lTpts.size() > 0) {
			lPoints.splice(lPoints.begin(), lTpts);
		}
		iterrations--;
	}
}

void CBaseTest::tllsq(double cx[], double cy[], double& cth, double& cdist) {
	double tmp, a, c;

	if(abs((cy[0]-cy[1])/(cx[0]-cx[1]))>1) {
		tmp = cx[0];
		cx[0] = cy[0];
		cy[0] = -tmp;
		tmp = cx[1];
		cx[1] = cy[1];
		cy[1] = -tmp;
		cth = dtor(90);
	} else {
		cth = 0;
	}

	llsq(2, cx, cy, a, c);
	cth += atan2(sign(c)/sqrt(a*a+1), -a*sign(c)/sqrt(a*a+1));
	cth = normalize(cth);
	cdist = c*sign(c)/sqrt(a*a+1);
}

bool CBaseTest::getInlier(double& cth, double& cdist) {
	std::list<pts>::iterator pI;
	pts tpt;
	int n;
	double x[5], y[5], a, c, tmp;
	if (lPoints.size()<20)
		return false;

	if (!lTpts.empty())
		lTpts.clear();

	n = rand() % lPoints.size();
	pI = lPoints.begin();
	advance (pI, n);
	x[0] = pI->x;
	y[0] = pI->y;
	tpt.x = pI->x;
	tpt.y = pI->y;
	lTpts.push_back(tpt);
	lPoints.erase(pI);

	n = rand() % lPoints.size();
	pI = lPoints.begin();
	advance (pI, n);
	x[1] = pI->x;
	y[1] = pI->y;
	tpt.x = pI->x;
	tpt.y = pI->y;
	lTpts.push_back(tpt);
	lPoints.erase(pI);

	if(abs((y[0]-y[1])/(x[0]-x[1]))>1) {
		tmp = x[0];
		x[0] = y[0];
		y[0] = -tmp;
		tmp = x[1];
		x[1] = y[1];
		y[1] = -tmp;
		cth = dtor(90);
	} else {
		cth = 0;
	}

	llsq(2, x, y, a, c);
	cth += atan2(sign(c)/sqrt(a*a+1), -a*sign(c)/sqrt(a*a+1));
	cth = normalize(cth);
	cdist = c*sign(c)/sqrt(a*a+1);
	return true;
}

bool CBaseTest::isToSegment(double x1, double y1, double x2, double y2,
		double lx, double ly)
{
	double d[2];
	d[0] = sqrt((x2-lx)*(x2-lx)+(y2-ly)*(y2-ly));
	d[1] = sqrt((x1-lx)*(x1-lx)+(y1-ly)*(y1-ly));
	if (isInSegment(x1, y1, x2, y2, lx, ly))
		return true;
	return ((d[0] < minDistance)||(d[1] < minDistance));
}

void CBaseTest::setSpeeds(void* ptr) {
//    struct timespec timeOut,remains;
//
//    timeOut.tv_sec = 0;
//    timeOut.tv_nsec = 200000000;

//    nanosleep(&timeOut, &remains);
}

double CBaseTest::roundDec(double num) {
    num *= 100;
    num += 0.5;
    return floor(num)/100;
}

bool CBaseTest::findLineSegment(double cth, double cdist) {
//	std::list<pts>::iterator pI, pP;
//	lns lin1;
//	pts tpt;
//	int num = 0;
//	double x[2], y[2];
//
//	lTpts.sort();
//
//	pP = pI = lTpts.begin();
//	while ((pI != lTpts.end())&&(!lTpts.empty())) {
//		x[0] = pI->x;
//		y[0] = pI->y;
//		num = 0;
//		chkDist(num, pI, pI->x, pI->y);
//		if (num > 20) {
//			advance(pP, num-1);
//			x[1] = pP->x;
//			y[1] = pP->y;
//			lin1.th = cth;
//			lin1.r = cdist;
//			lin1.x[0] = x[0];
//			lin1.x[1] = x[1];
//			lin1.y[0] = y[0];
//			lin1.y[1] = y[1];
//			lLines.push_back(lin1);
//			writeLnsToFile();
//			pP++;
//			pP = pI = lTpts.erase(pI, pP);
//		} else {
//			if (num > 0) {
//				advance(pI, num);
//				advance(pP, num);
//			} else {
//				pI++;
//				pP++;
//			}
//		}
//	}
	return false;
}

void CBaseTest::chkDist(int& num, std::list<pts>::iterator pN, double x,
		double y) {
	if (pN != lTpts.end()) {
		++pN;
		if (sqrt((x-pN->x)*(x-pN->x)+(y-pN->y)*(y-pN->y))<minDistance) {
			chkDist(++num, pN, pN->x, pN->y);
		}
	}
	return;
}

void CBaseTest::writeLnsToFile() {
	FileWriter->WriteLineListToFile(&lLines, "./lines.txt");
}

int CBaseTest::runTask(int argc, char* argv[])
{

//	Already done with initialization of CFileWriter
//	sprintf(filename, "./map.txt");
//	fp = fopen(filename,"w");
//	fclose(fp);
//	sprintf(filename, "./map1.txt");
//	fp = fopen(filename,"w");
//	fclose(fp);
//	fp = fopen("./trajectory.txt","w");
//	fclose(fp);
//	fp = fopen("./calc1.txt","w");
//	fclose(fp);
//	fp = fopen("./calc.txt","w");
//	fclose(fp);
//	fp = fopen("./angle.txt","w");
//	fclose(fp);
//	fp = fopen("./scan_err.txt","w");
//	fclose(fp);

	int numScan = 0;

	Matrix A(3,3);
	Matrix B(3,2);
	Matrix BB(3,2);
	Matrix C(48,48);
	Matrix F(3,1);
	Matrix P(3,3);
	Matrix U(2,1);

	Matrix N(48,3);

	Matrix V(2,2);

	Matrix XC(3,1);
	Matrix PC(3,3);
	Matrix OPC(3,3);
	Matrix XZ(3,1);
	Matrix PZ(3,3);
	Matrix Y(3,1);
	Matrix VU(3,1);
	Matrix MS(3,3);
	Matrix MW(3,3);

	Matrix RC(3,3);		//Robot coordinates
	Matrix RY(3,3);		//Robot yaw
	Matrix SC(3,3);		//Sensor coordinates
	Matrix SY(3,3);		//Sensor yaw
	Matrix SM(3,3);		//Sensor measurment
	Matrix OD(3,1);		//Obstacle displacement
	Matrix OC(3,1);		//Obstacle coordinates
	Matrix GL(2,1);
	Matrix H(2,3);
	Matrix MZ(32, 1);
	Matrix MM(32, 1);

//	robot.Read();

	char msh[256];
	double dT;

	double matrXC[] = { currentX, currentY, currentAngle };
	XC << matrXC;

	double xdp = 0, ydp = 0, adp = 0;

	for(;;)
  	{
//    	robot.Read();
		dT = getDeltaTime(&dT);
		currentV = sqrt(pp.GetXSpeed()*pp.GetXSpeed() + pp.GetYSpeed()*pp.GetYSpeed());
		currentW = pp.GetYawSpeed();
		if (numScan == 0) {

		}

		for (int i=0; i<16; i++) {
			sp[i] = sp1->GetScan(i);
		}
	  	numScan = (numScan<=1) ? 1:0;

		findLocalLines();

		double dx[16], dy[16], da[16];
		double xdisp=0, ydisp=0, adisp = 0, cntDisp = 0;

		try {
			int matrAsize = lLines.size()*2 + 3;
			IdentityMatrix IM(matrAsize);
			DiagonalMatrix DM(matrAsize);

///************************************************************** Kalman filter


			if (numScan == 0) {
				PC.ReSize(matrAsize, matrAsize);
				PC = PC*0.0;
				PC = PC*IM;
				PC = PC*0.04;
				//cout << DD+IM << endl;
			}// else {

			OPC.ReSize(PC.Nrows(), PC.Ncols());
			OPC = PC;
			PC.ReSize(matrAsize, matrAsize);
			PC = PC*0.0;
			PC = PC*IM;
			PC = PC*0.04;
//			printf("mA size: %d\n", OPC.Nrows());
			for (int i = 1; i <= OPC.Nrows(); i++) {
				for (int j = 1; j <= OPC.Ncols(); j++) {
					PC(i,j) = OPC(i,j);
				}
			}
			XC.ReSize(matrAsize, 1);
			XC(1,1) = currentX;
			XC(2,1) = currentY;
			XC(3,1) = currentAngle;

			//printf("mA size: %d\n", matrAsize);
			int n = 4;
			std::list<lns>::iterator pL;
			if (!lLines.empty())
				for (pL = lLines.begin(); pL != lLines.end(); ++pL) {
					XC(n++,1) = pL->r;
					XC(n++,1) = pL->th;
				}

			U << currentV << currentW;

			B.ReSize(matrAsize, 2);
			B = B*0.0;
			B(1,1) = dT*cos(XC(3,1));
			B(2,1) = dT*sin(XC(3,1));
			B(3,2) = dT;

			A.ReSize(matrAsize, matrAsize);
			A = A*0.0;
			A = A*IM;
			A(1,3) = -dT*sin(XC(3,1));
			A(2,3) = dT*cos(XC(3,1));

//----------------------------------------------------------------------predict
			//V.ReSize(2, 2);
			//V = V*0.0;
			V(1,1) =  0.04;
			V(2,2) =  0.04;

			BB.ReSize(matrAsize, 2);
			BB = BB*0.0;

			BB(1,1) = 1;
			BB(2,2) = 1;

			XZ.ReSize(matrAsize, 1);
			XZ = A*XC+BB*U;
			XZ(3,1) = normalize(XZ(3,1));
			PZ.ReSize(matrAsize, matrAsize);
			PZ = A*PC*A.t()+B*V*B.t();

			currentX = XZ(1,1);
			currentY = XZ(2,1);
			currentAngle = XZ(3,1);

			for (int i=0; i<16; i++) {
				double d1, beta, oxr, oyr;

				oxr = sp[i]*cos(dtor(sensPosition[i].Theta))+(sensPosition[i].Theta);
				oyr = sp[i]*sin(dtor(sensPosition[i].Theta))+sensPosition[i].PosY;

				d1 = sqrt(oxr*oxr+oyr*oyr);
				beta = atan2(oyr,oxr);

				obstacleX[i] = oxr;
				obstacleY[i] = oyr;

				double obX, obY;

				//try
				{
					double matrRC[] = { 1,0,currentX,0,1,currentY,0,0,1 };
					double matrRY[] = { cos(currentAngle),-sin(currentAngle),0,sin(currentAngle),cos(currentAngle),0,0,0,1 };
					double matrSC[] = { 1,0,sensPosition[i].PosX,0,1,sensPosition[i].PosY,0,0,1 };
					double matrSY[] = {
							cos(dtor(sensPosition[i].Theta)),
							-sin(dtor(sensPosition[i].Theta)),
							0,
							sin(dtor(sensPosition[i].Theta)),
							cos(dtor(sensPosition[i].Theta)),
							0,
							0,
							0,
							1
					};
					double matrSM[] = { 1,0,sp[i],0,1, 0,0,0,1 };
					double matrOD[] = { 0,0,1 };

					RC << matrRC;
					RY << matrRY;
					SC << matrSC;
					SY << matrSY;
					SM << matrSM;
					OD << matrOD;

					OC = RC*RY*SC*SY*SM*OD;
							//cout << OC;

					obX = OC(1,1);
					obY = OC(2,1);

				} //CatchAll { cout << BaseException::what(); }


				//obX = currentX + (sp[i] + sD)*cos(dtor(sensPosition[i][2])+currentAngle);
				//obY = currentY + (sp[i] + sD)*sin(dtor(sensPosition[i][2])+currentAngle);
				dx[i] = 0;
				dy[i] = 0;
				//da[i] = normalize(dtor(sensPosition[i][2]));
				da[i] = 0;
				if (sp[i] < maxSonarVal) {
					if(!addPoint(roundDec(obX), roundDec(obY), dx[i], dy[i], da[i], true, i)) {
					}
				}
			}

			xdisp = 0;
			ydisp = 0;
			adisp = 0;
			cntDisp = 0;
			for (int i=0; i<16; i++) {
				if ((dx[i]!=0)||(dy[i]!=0)||(da[i]!=0)) {
					xdisp += dx[i];
					ydisp += dy[i];
					adisp += da[i];//+= (da[i]-normalize(dtor(sensPosition[i][2]+90)));
					cntDisp++;
				}
			}

			if ((cntDisp > 0)&&((currentV != 0.0)||(currentW != 0.0))) {
				if (cntDisp > 0) {
					xdisp /= cntDisp;
					ydisp /= cntDisp;
					adisp /= cntDisp;
					adisp = normalize(adisp);
				}
//				double xko = 0.5, yko = 0.5, ako = 5.0;

//------------------------------------------------------------------ correction

				int llinNum[16];
				int q=0;
//				int outLen = 0;
				double matMZ[16][2];
				for (int i=0; i<16; i++) {
					if (linNum[i]!=0) {
						llinNum[q] = linNum[i];
						matMZ[q][0] = localLines[i].r;
						matMZ[q][1] = localLines[i].th;
						q++;
					}
				}


				C.ReSize(matrAsize, matrAsize);
				C = C*0.0;
				C = C*IM;
				C = C*0.04;

				N.ReSize(q*2, matrAsize);
				MM.ReSize(q*2,1);
				MM = MM*0.0;
				MZ.ReSize(q*2,1);
				N = N*0.0;

				for (int i=0; i<q; i++) {
					double Ci,ci, ai, pi, xr, yr, fir;
					int j;
					MZ(i*2+1, 1) = matMZ[i][0];
					MZ(i*2+2, 1) = matMZ[i][1];
					j = llinNum[i];
					pi = XZ(j+3,1);
					ai = XZ(j+4,1);
					xr = XZ(1,1);
					yr = XZ(2,1);
					fir = XZ(3,1);
					Ci = pi - xr*cos(ai) - yr*sin(ai);
					ci = sign(Ci);
					N(i*2+1, 1) = -ci*cos(ai);
					N(i*2+1, 2) = -ci*sin(ai);
					N(i*2+1, 3) = 0.0;
					N(i*2+1, j+3) = ci;
					N(i*2+1, j+4) = ci*(xr*sin(ai)-yr*cos(ai));
					N(i*2+2, 3) = -1.0;
					N(i*2+2, j+2) = 1.0;

					MM(i*2+1, 1) = abs(Ci);
					MM(i*2+2, 1) = normalize(ai - fir + (1-ci)*dtor(180));
				}


				MS = N*PZ*N.t() + C;

				MW = PZ*N.t()*MS.i();

				PC.ReSize(matrAsize, matrAsize);
				XC.ReSize(matrAsize, 1);

				XC = XZ + MW*(MZ - MM);
				XC(3,1) = normalize(XC(3,1));

				PC = PZ - MW*MS*MW.t();

				printf("x: %f, y: %f, a: %f\n", currentX, currentY, rtod(currentAngle));
			} else {
				PC.ReSize(matrAsize, matrAsize);
				XC.ReSize(matrAsize, 1);
				XC = XZ;
				PC = PZ;
			}
				currentX = XC(1,1);
				currentY = XC(2,1);
				currentAngle = XC(3,1);
				prevX = XC(1,1);
				prevY = XC(2,1);
				prevAngle = XC(3,1);
				prevV = currentV;
				prevW = currentW;

			n = 4;
			//list<lns>::iterator pL;
			if (!lLines.empty())
				for (pL = lLines.begin(); pL != lLines.end(); ++pL) {
					pL->r = XC(n++,1);
					pL->th = normalize(XC(n++,1));
				}
			writeLnsToFile();
						//printf("x: %f, y: %f, a: %f\n", cntDisp, currentY, rtod(currentAngle));
				//}
			if (cntDisp == 0)
			for (int i=0; i<16; i++) {

				//double sD = sqrt((sensPosition[i][0]+0.04)*(sensPosition[i][0]+0.04)+sensPosition[i][1]*sensPosition[i][1]);

				double d1, beta, oxr, oyr;

				oxr = sp[i]*cos(dtor(sensPosition[i].Theta))+(sensPosition[i].PosX);
				oyr = sp[i]*sin(dtor(sensPosition[i].Theta))+sensPosition[i].PosY;

				d1 = sqrt(oxr*oxr+oyr*oyr);
				beta = atan2(oyr,oxr);

				obstacleX[i] = oxr;
				obstacleY[i] = oyr;

				double obX, obY;

				//try
				{
					double matrRC[] = { 1,0,currentX,0,1,currentY,0,0,1 };
					double matrRY[] = { cos(currentAngle),-sin(currentAngle),0,sin(currentAngle),cos(currentAngle),0,0,0,1 };
					double matrSC[] = { 1,0,sensPosition[i].PosX,0,1,sensPosition[i].PosY,0,0,1 };
					double matrSY[] = {
							cos(dtor(sensPosition[i].Theta)),
							-sin(dtor(sensPosition[i].Theta)),
							0,
							sin(dtor(sensPosition[i].Theta)),
							cos(dtor(sensPosition[i].Theta)),
							0,
							0,
							0,
							1
					};
					double matrSM[] = { 1,0,sp[i],0,1, 0,0,0,1 };
					double matrOD[] = { 0,0,1 };

					RC << matrRC;
					RY << matrRY;
					SC << matrSC;
					SY << matrSY;
					SM << matrSM;
					OD << matrOD;

					OC = RC*RY*SC*SY*SM*OD;

					obX = OC(1,1);
					obY = OC(2,1);

				} // CatchAll { cout << BaseException::what(); }


				//obX = currentX + (sp[i] + sD)*cos(dtor(sensPosition[i][2])+currentAngle);
				//obY = currentY + (sp[i] + sD)*sin(dtor(sensPosition[i][2])+currentAngle);
				dx[i] = 0;
				dy[i] = 0;
				da[i] = normalize(dtor(sensPosition[i].Theta+90));

				if (sp[i] < maxSonarVal) {
					if(!addPoint(roundDec(obX), roundDec(obY), dx[i], dy[i], da[i], false, i)) {
					}
					//da[i] = normalize(da[i] - dtor(sensPosition[i][2]));
					char filename[256];
					sprintf(filename, "./map.txt");
					FILE *fp = fopen(filename,"a");
					fprintf(fp,"%f\t%f\n", obX, obY);
					fclose(fp);
					sprintf(filename, "./map1.txt");
					fp = fopen(filename,"a");
					fprintf(fp,"%f\t%f\n", obX+dx[i], obY+dy[i]);
					fclose(fp);
				}
			}
		} CatchAll { cout << BaseException::what(); }

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  -kalman

		//printf("calc angle: %f calc x: %f calc y: %f deltaТ: %f\n", rtod(currentAngle), currentX, currentY, dT);
		//printf("real angle: %f real x: %f real y: %f deltaТ: %f\n", rtod(pp.GetYaw()), pp.GetXPos(), pp.GetYPos(), dT);
		//printf("calc spd W: %f spd V: %f\n", rtod(currentW), currentV);
		//pp.SetOdometry(currentX+xdisp, currentY+ydisp, currentAngle);
	  	//pp.GoTo(currentX+xdisp, currentY+ydisp, currentAngle);
		FILE *fp = fopen("./calc1.txt","a");
			fprintf(fp,"%f\t%f\n", currentX+xdisp, currentY+ydisp);
		  	xdp = xdisp;
		  	ydp = ydisp;
		  	adp = normalize(adisp+adp);
			fclose(fp);
		  	//printf
		//}

		if (lPoints.size()>20) {
			findNewLines();
		}
		//if (scCycle>2)
		//	findLines(sp);
		//else
		//	scCycle++;

		fp = fopen("./trajectory.txt","a");
		fprintf(fp,"%f\t%f\n", currentX, currentY);
		fclose(fp);

		//printf ("round: %f %f %f %f\n", roundDec(3.33), roundDec(3.38), roundDec(-3.33), roundDec(-3.38));

		setSpeeds((void *) msh);
	}

	return 0;
}
