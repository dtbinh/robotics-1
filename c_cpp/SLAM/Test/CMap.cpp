/*
 * CMap.cpp
 *
 *  Created on: 26 sty 2015
 *      Author: X240
 */

#include "CMap.h"

CMap::CMap(const char * sFileName) {
	Filename = sFileName;
}

CMap::~CMap() {
	// TODO Auto-generated destructor stub
}

void CMap::AddPoint(tMapPoint& Point)
{
	CFileWriter *FileWriter = CFileWriter::getInstance();
	RawPointData.push_back(Point);
	FileWriter->WritePointListToFile(&RawPointData, Filename);
	delete FileWriter;
}

void CMap::Clear() {
}
