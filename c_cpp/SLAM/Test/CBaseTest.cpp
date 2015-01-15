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

	minErr = 0.2;
	flagPredict = false;
	dx = dy = da = 0.0;
	currentX = currentY = currentAngle = 0.0;
	px = py = pa = 0;
	num = 0;
	maxSonarVal = 1.2;

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

int CBaseTest::addPoint(double x, double y, double z) {

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
				if (isInSegment(ex[0], ey[0], ex[1], ey[1], x, y)) {
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

	// Debug output
	printf("Adding point with coordinates: x=%f, y=%f, z=%f\n", x, y, z);

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

void CBaseTest::writePtsToFile() {
//	pts points;
//	std::list<pts>::iterator pI;
//	FILE *fp = fopen("./points.txt","w+");
//	for (pI = lPoints.begin(); pI != lPoints.end(); ++pI) {
//		fprintf(fp,"%f\t%f\n", pI->x, pI->y);
//	}
//	fclose(fp);

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
			/*px = ((pL->x[0]*pL->y[1]-pL->y[0]*pL->x[1])*(currentX-x) -
				(pL->x[0]-pL->x[1])*(currentX*y-currentY*x))/
				((pL->x[0]-pL->x[1])*(currentY-y)-(pL->y[0]-pL->y[1])*(currentX-y));

			py = ((pL->x[0]*pL->y[1]-pL->y[0]*pL->x[1])*(currentY-y) -
				(pL->y[0]-pL->y[1])*(currentX*y-currentY*x))/
				((pL->x[0]-pL->x[1])*(currentY-y)-(pL->y[0]-pL->y[1])*(currentX-y));*/
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
			//			printf("x: %f y: %f\n", px, py);
			if ( (!flagParallel) &&
					(isInSegment(pL->x[0], pL->y[0], pL->x[1], pL->y[1], px, py)) &&
					(isInSegment(currentX, currentY, dPointX, dPointX, px, py))
					)
			{
				//fi = normalize(pL->th - cth);
				//double ralpha = dtor(90) - fi - pa + pL->th;
				//pa = normalize(ralpha - currentAngle);
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
					//if (abs(pa) > dtor(15)) { pa = 0.0; }
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
	//list<lns>::iterator lI;
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
		//printf("dist: %f th: %f\n", localLines[i].r, localLines[i].th);

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
	lns lin1;
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
			//printf("lp: %d\n", lPoints.size());
		} while ((pI != lPoints.end())&&(!lPoints.empty()));

		//printf("here\n");
		if (lTpts.size() > 25) {
			findLineSegment(cth, cdist);
			//lin1.th = cth;
			//lin1.r = cdist;
			//lLines.push_back(lin1);
			//writeLnsToFile();
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
	//do {

	//} while (n[0]==n[1]);
	pI = lPoints.begin();
	advance (pI, n);
//	for (int i=0; i<=n[0]; i++)
	//	pI++;
	//pI = n[0] + lPoints.begin();
	x[0] = pI->x;
	y[0] = pI->y;
	//lTpts.splice (lTpts.begin(), lPoints, pI);
	tpt.x = pI->x;
	tpt.y = pI->y;
	lTpts.push_back(tpt);
	lPoints.erase(pI);

	n = rand() % lPoints.size();
	pI = lPoints.begin();
	advance (pI, n);
	//for (int i=0; i<=n[1]; i++)
		//pI++;
	//pI = n[1] + lPoints.begin();
	x[1] = pI->x;
	y[1] = pI->y;
	//lTpts.splice (lTpts.begin()+1, lPoints, pI);
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
	lns points;
	std::list<lns>::iterator pI;
	//lLines.sort();
	//lLines.reverse();
	FILE *fp = fopen("./lines.txt","w+");
	for (pI = lLines.begin(); pI != lLines.end(); ++pI) {
		fprintf(fp,"%f\t%f\t%f\t%f\t%f\t%f\n", pI->th, pI->r, pI->x[0], pI->y[0], pI->x[1], pI->y[1]);
	}
	fclose(fp);
}
