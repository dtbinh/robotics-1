/*
 * CMap.h
 *
 *  Created on: 26 sty 2015
 *      Author: X240
 */

#ifndef CMAP_H_
#define CMAP_H_

#include "../basedef.h"
#include "CFileWriter.h"

class CMap {
private:
	std::string Filename;
	std::list<tMapPoint> RawPointData;
public:
	CMap(const char * sFileName);
	virtual ~CMap();

	void AddPoint(tMapPoint &Point);
	void Clear();
};

#endif /* CMAP_H_ */
