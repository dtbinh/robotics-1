classdef CSensor < handle
    %CSENSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Inputs
        % Dynamics data only Yaw speed will be used
        Speed = sDynamicsData();
        
        % Outputs
        Distance = 0.0;
        Map = CLineSegmentMap();    % Map of line segments
        
        % Position data only X and Y position will be used
        Position = sPositionData();
    end
    
    properties (Access = private)
        
    end
    
    methods
        function element = CSensor()
        end
        
        function setPosition(element, positionData)
            element.Position = positionData;
        end
        
        function setPositionXY(element, x, y, gamma)
        % Sets position of the element in 2D space. This function always
        % sets the Z, Alpha and Beta dimmensions to 0.
            position = sPositionData();
            position.PosX = x;
            position.PosY = y;
            position.Gamma = gamma;
            element.setPosition(position);
        end
        
        function setSpeeds(element, speeds)
            element.Speed = speeds;
        end
        
        function setYaw(element, yaw)
            speed = sDynamicsData();
            speed.Yaw = yaw;
            element.setSpeeds(speed);
        end
        
        function addPoint(element, point)
            
        end
        
        function Run(element)
            
        end
        
    end
    
end

