/*
 * CFileWriter.h
 *
 *  Created on: Jan 14, 2015
 *      Author: hristohristoskov
 */

#ifndef CFILEWRITER_H_
#define CFILEWRITER_H_

#include "../basedef.h"

#define POINTS_FILENAME 			"./points.txt"
#define LINES_FILENAME 				"./lines.txt"
#define MAP_FILENAME 				"./map.txt"
#define MAP2_FILENAME 				"./map1.txt"
#define TRAJECTORY_FILENAME 		"./trajectory.txt"
#define CALCULATIONS_FILENAME		"./calc.txt"
#define CALCULATIONS2_FILENAME		"./calc1.txt"
#define ANGLES_FILENAME				"./angle.txt"
#define SCANNING_ERROR_FILENAME 	"./scan_err.txt"
#define SENSOR_DATA_FILENAME		"./sensor_data.txt"


class CFileWriter {
private:
    static bool instanceFlag;
    static CFileWriter *instance;
    CFileWriter();
public:
    static CFileWriter* getInstance();
	virtual ~CFileWriter();

	void WritePointListToFile(std::list<pts>* pList, const char* cFileName);
	void WriteLineListToFile(std::list<lns>* pList, const char* cFileName);

	void WriteSensorData(double *sensorDistance, double *sensorDt, int length);
};

#endif /* CFILEWRITER_H_ */
