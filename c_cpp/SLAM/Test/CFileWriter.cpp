/*
 * CFileWriter.cpp
 *
 *  Created on: Jan 14, 2015
 *      Author: hristohristoskov
 */

#include "CFileWriter.h"

CFileWriter* CFileWriter::instance = NULL;
bool CFileWriter::instanceFlag = false;

CFileWriter::CFileWriter()
{
	FILE *fp = NULL;

	fp = fopen(MAP_FILENAME,"w");
	fclose(fp);
	fp = fopen(MAP2_FILENAME,"w");
	fclose(fp);
	fp = fopen(TRAJECTORY_FILENAME,"w");
	fclose(fp);
	fp = fopen(CALCULATIONS_FILENAME,"w");
	fclose(fp);
	fp = fopen(CALCULATIONS2_FILENAME,"w");
	fclose(fp);
	fp = fopen(ANGLES_FILENAME,"w");
	fclose(fp);
	fp = fopen(SCANNING_ERROR_FILENAME,"w");
	fclose(fp);

	instanceFlag = true;
}

CFileWriter::~CFileWriter()
{
	instanceFlag = false;
}

void CFileWriter::WritePointListToFile(std::list<pts>* pList, const char* cFileName) {
	std::list<pts>::iterator pI;
	FILE *fp = NULL;

	if ( ( NULL != cFileName ) && (NULL != pList) )
	{
		fp = fopen("./points.txt","w+");
		for (pI = pList->begin(); pI != pList->end(); ++pI) {
			fprintf(fp,"%f\t%f\n", pI->x, pI->y);
		}
		fclose(fp);
	}
}

CFileWriter* CFileWriter::getInstance() {
    if(! instanceFlag)
    {
        instance = new CFileWriter();
        return instance;
    }
    else
    {
        return instance;
    }
}

void CFileWriter::WriteLineListToFile(std::list<lns>* pList,
		const char* cFileName)
{
	std::list<lns>::iterator pI;
	FILE *fp = NULL;

	if ( ( NULL != cFileName ) && (NULL != pList) )
	{
		fp = fopen(cFileName,"w+");
		for (pI = pList->begin(); pI != pList->end(); ++pI) {
			fprintf(fp,"%f\t%f\t%f\t%f\t%f\t%f\n", pI->th, pI->r, pI->x[0], pI->y[0], pI->x[1], pI->y[1]);
		}
		fclose(fp);
	}
}

void CFileWriter::WritePointListToFile(std::list<tMapPoint>* pList, std::string FileName)
{
	std::list<tMapPoint>::iterator pI;
	FILE *fp = NULL;

	if ( (!FileName.empty()) && (NULL != pList) )
	{
		fp = fopen(FileName.c_str(),"w+");
		for (pI = pList->begin(); pI != pList->end(); ++pI) {
			fprintf(fp,"%f\t%f\n", pI->PosX, pI->PosY);
		}
		fclose(fp);
	}
}

void CFileWriter::WriteSensorData(double* sensorDistance, double* sensorDt,
		int length)
{
	FILE *fp = fopen(SENSOR_DATA_FILENAME, "a");
	for (int ii=0; ii<length; ii++)
	{
		///		SensorNum, Distance, dT
		fprintf(fp,"%d\t%f\t%f\n", ii+1, sensorDistance[ii], sensorDt[ii]);
	}
	fclose(fp);
}
