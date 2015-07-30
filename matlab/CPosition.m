classdef CPosition < handle
    %CPOSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PositionData = sPositionData;
    end
    
    methods
        function element = CPosition(varargin)
            if nargin > 0
                method = varargin{1};
            end
            
            switch method
                case 'pdata'
                    element.fromPositionData(varargin{2});
                case 'tmatrix'
                    element.fromTransformationMatrix(varargin{2});
                otherwise
            end
            
        end
        
        function fromPositionData(element, positionData)
            element.PositionData = positionData;
        end
        
        function fromTransformationMatrix(element, tMatrix)
            element.PositionData.PosX = tMatrix(1,4);
        end

    end
    
end

