classdef CMap < handle
    %CMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RawPoints = [];
        RobotEncoderPositions = [];
        RobotEncoderArray = [];
        RawSensorPoints = [];
    end
    
    methods
        function element = CMap()
        end
        
        function AddPoint(element, x, y)
            point = [x, y];
            element.RawPoints = [element.RawPoints; point];
        end
        
        function AddPointBySensor(element, sensorNumber, x, y)
            point = [sensorNumber, x, y];
            element.RawSensorPoints = [element.RawSensorPoints; point];
        end
        
        function AddRobotEncoderPositionPoint(element, point)
            element.RobotEncoderPositions = [element.RobotEncoderPositions; point];
            pt = [ point.PosX, point.PosY ];
            element.RobotEncoderArray = [ element.RobotEncoderArray; pt ];
        end
        
        function result = getSensorPoints(element, sensorNumber)
            pts = element.RawSensorPoints;
            result = [];
            if (~isempty(pts))
                for kk = 1:length(pts(:,1))
                    if (sensorNumber == pts(kk,1))
                        point = CPoint(pts(kk,2), pts(kk, 3));
                        result = [result; point];
                    end
                end
            end
        end
        
        function delete(element)
%             delete(element.RawPoints);
%             delete(element.RobotEncoderPositions);
        end
    end
    
end

