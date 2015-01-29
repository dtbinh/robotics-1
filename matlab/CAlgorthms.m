classdef CAlgorthms
    %CALGORTHMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        function m = GetTransformationMatrix(element, positionData)
            % Currently implemented only for XY plane :]
            m = [...
                cos(positionData.Alpha) , -sin(positionData.Alpha)  , 0 , positionData.PosX;
                sin(positionData.Alpha) , cos(positionData.Alpha)   , 0 , positionData.PosY;
                0                       , 0                         , 1 , 0;
                0                       , 0                         , 0 , 1
                ];
                
        end
    end
    
end

