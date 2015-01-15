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
