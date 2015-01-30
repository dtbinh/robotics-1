classdef CAlgorthms
    %CALGORTHMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        function m = GetTransformationMatrix(element, positionData)
            % Currently implemented only for XY plane :]
            m = [...
                cos(positionData.Gamma) , -sin(positionData.Gamma)  , 0 , positionData.PosX;
                sin(positionData.Gamma) , cos(positionData.Gamma)   , 0 , positionData.PosY;
                0                       , 0                         , 1 , 0;
                0                       , 0                         , 0 , 1
                ];
                
        end
    end
    
end

