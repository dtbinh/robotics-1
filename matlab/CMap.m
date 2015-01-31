classdef CMap < handle
    %CMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RawPoints = [];
        RobotEncoderPositions = [];
        RobotEncoderArray = [];
    end
    
    methods
        function element = CMap()
        end
        
        function AddPoint(element, x, y)
            point = [x, y];
            element.RawPoints = [element.RawPoints; point];
        end
        
        function AddRobotEncoderPositionPoint(element, point)
            element.RobotEncoderPositions = [element.RobotEncoderPositions; point];
            pt = [ point.PosX, point.PosY ];
            element.RobotEncoderArray = [ element.RobotEncoderArray; pt ];
        end
        
        function delete(element)
%             delete(element.RawPoints);
%             delete(element.RobotEncoderPositions);
        end
    end
    
end

