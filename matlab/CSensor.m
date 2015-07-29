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
        
        function result = getRAWMeasurement(element)
            result = element.Distance;
        end
        
        function result = getCalculatedMeasurement(element)
%             a = element.Position.Alpha;
%             b = element.Position.Beta;
%             g = element.Position.Gamma;
%             x = element.Position.PosX;
%             y = element.Position.PosY;
%             z = element.Position.PosZ;
%             
%             syms s(h) c(h);
%             s(h) = sin(h);
%             c(h) = cos(h);
%             
%             % Source http://planning.cs.uiuc.edu/node104.html
%             TM = [ c(a)*c(b),   c(a)*s(b)*s(g)-s(a)*c(g),   c(a)*s(b)*c(g)+s(a)*s(g),   x; ...
%                    s(a)*c(b),   s(a)*s(b)*s(g)+c(a)*c(g),   s(a)*s(b)*c(g)-c(a)*s(g),   y; ...
%                    -s(b),       c(b)*s(g),                  c(b)*c(g),                  z; ...
%                    0,           0,                          0,                          1 ];
%                
%             TM = double(TM);
            TM = CAlgorthms.GetTransformationMatrix(0, element.Position);
            d = element.Distance;
            M = [ d; 0; 0; 1 ];
            
            V = TM*M;
            result = CPoint(V(1), V(2), V(3));
        end
        
        function PlotSymbol(element)
            m = CAlgorthms.GetTransformationMatrix( 0, ...
                element.Position ...
            );
            xy = [ ...
                1, 0, -1, -1, 0; ...
                0, 0, -1, 1, 0
                ];
            x = xy(1, :) ...
                /2 ... % to be 1 unit
                /100 ...
                *1;  % 0.01 m
            y = xy(2, :)/2/100*2;   % 0.02 m
            xyz = [ ...
                x(1), x(2), x(3), x(4), x(5); ...
                y(1), y(2), y(3), y(4), y(5); ...
                0, 0, 0, 0, 0; ...
                1, 1, 1, 1, 1 ...
                ];
            for kk = 1: length(x)
                pos(:, kk) = m * xyz(:, kk);
            end
            plot(x, y, 'b-');
            plot(pos(1,:), pos(2, :), 'b-');
        end
        
        function PlotMeasurement(element)
            pt = element.getCalculatedMeasurement;
            pt.Plot;
        end
        
        function Run(element)
            
        end
        
    end
    
end

