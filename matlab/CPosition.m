classdef CPosition < handle
    %CPOSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PositionData = sPositionData;
    end
    
    methods
        function element = CPosition(varargin)
            method = 'default';
            if nargin > 0
                method = varargin{1};
            end
            
            switch method
                case 'pdata'
                    element.fromPositionData(varargin{2});
                case 'tmatrix'
                    element.fromTransformationMatrix(varargin{2});
                case 'XYg'
                    position = sPositionData;
                    position.PosX = varargin{2};
                    position.PosY = varargin{3};
                    position.Gamma = varargin{4};
                    element.fromPositionData(position);
                otherwise
            end
            
        end
        
        function fromPositionData(element, positionData)
            element.PositionData = positionData;
        end
        
        function fromTransformationMatrix(element, tMatrix)
            % Source: http://nghiaho.com/?page_id=846
            a = atan2(tMatrix(3,2), tMatrix(3,3));
            b = atan2(-tMatrix(3,1), sqrt(tMatrix(3,2)^2 + tMatrix(3,3)^2));
            g = atan2(tMatrix(2,1), tMatrix(1,1));
            x = tMatrix(1,4);
            y = tMatrix(2,4);
            z = tMatrix(3,4);
            
            position = sPositionData;
            position.PosX = x;
            position.PosY = y;
            position.PosZ = z;
            position.Alpha = a;
            position.Beta = b;
            position.Gamma = g;
            
            element.fromPositionData(position);
        end
        
        function m = GetTransformationMatrix(element)
            a = element.PositionData.Alpha;
            b = element.PositionData.Beta;
            g = element.PositionData.Gamma;
            x = element.PositionData.PosX;
            y = element.PositionData.PosY;
            z = element.PositionData.PosZ;

            m = [  cos(g)*cos(b),   cos(g)*sin(b)*sin(a)-sin(g)*cos(a),     cos(g)*sin(b)*cos(a)+sin(g)*sin(a), x; ...
                   sin(g)*cos(b),   sin(g)*sin(b)*sin(a)+cos(g)*cos(a),     sin(g)*sin(b)*cos(a)-cos(g)*sin(a), y; ...
                   -sin(b),         cos(b)*sin(a),                          cos(b)*cos(a),                      z; ...
                   0,               0,                                      0,                                  1 ];
        end

    end
    
end

