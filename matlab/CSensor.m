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
        Position = CPosition();
        LocalPosition = CPosition();    % Position based on the robot CS
        GlobalPosition = CPosition();   % Position based on the world CS
        
        % Temporary cycle time
        Delta = 0.0;
    end
    
    properties (Access = private)
        
    end
    
    methods
        function element = CSensor(localPosition)
            lp = CPosition('pdata', localPosition);
            element.LocalPosition = lp;
            gp = CPosition('pdata', localPosition);
            element.GlobalPosition = gp;
        end
        
        function TranslateParent(element, positionData)
            % Get translation based on robot CS
            Ts = element.LocalPosition.getTransformationMatrix();
            position = CPosition('pdata', positionData);
            Tr = position.GetTransformationMatrix();
            
            Tsw = Tr * Ts;
            position = CPosition('tmatrix', Tsw);
            element.GlobalPosition = position;
        end
        
        function setInputs(element, parentSpeeds)
            
%             Tm = element.LocalPosition.getTransformationMatrix;
            Vpx = parentSpeeds.Vx;
            Vpy = parentSpeeds.Vy;
%             Vpz = parentSpeeds.Vz;
%             Wpx = parentSpeeds.Roll;
%             Wpy = parentSpeeds.Pitch;
            Wpz = parentSpeeds.Yaw;
            % Wikipedia Denavit-Hartenberg_parameters
%             W = [ 0,        -pYaw,  pPitch, pVx; ...
%                   pYaw,     0,      -pRoll, pVy; ...
%                   -pPitch,  pRoll,  0       pVz; ...
%                   0,        0,      0,      0 ];
%             Ws = Tm * W;
%             
%             speeds = sDynamicsData;
%             speeds.Vx = Ws(1,4);
%             speeds.Vy = Ws(2,4);
%             speeds.Vz = Ws(3,4);
%             speeds.Roll = pRoll;% Ws(3,2);
%             speeds.Pitch = pPitch;% Ws(1,3);
%             speeds.Yaw = pYaw;% Ws(2,1);
            
            Sx = element.LocalPosition.PositionData.PosX;
            Sy = element.LocalPosition.PositionData.PosX;
            
            Vx = Vpx + Wpz * (sqrt(Sx^2 + Sy^2));
            Vy = Vpy + Wpz * (sqrt(Sx^2 + Sy^2));
            Wz = Wpz;

            speeds = sDynamicsData;
            speeds.Vx = Vx;
            speeds.Vy = Vy;
            speeds.Yaw = Wz;
            
            element.Speed = speeds;
        end
        
        function result = getGlobalPosition(element)
            result = element.GlobalPosition;
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
            TM = element.GlobalPosition.getTransformationMatrix();
            d = element.Distance;
            M = [ d; 0; 0; 1 ];
            
            V = TM*M;
            result = CPoint(V(1), V(2), V(3));
        end
        
        function PlotSymbol(element)
            m = element.GlobalPosition.getTransformationMatrix();
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
            if element.Distance < 2
                pt = element.getCalculatedMeasurement;
                pt.Plot;
            end
        end
        
        function Run(element)
            Tm = element.GlobalPosition.getTransformationMatrix;
            pVx = element.Speed.Vx;
            pVy = element.Speed.Vy;
            pVz = element.Speed.Vz;
            pRoll = element.Speed.Roll;
            pPitch = element.Speed.Pitch;
            pYaw = element.Speed.Yaw;
            W = [ 0,        -pYaw,  pPitch, pVx; ...
                  pYaw,     0,      -pRoll, pVy; ...
                  -pPitch,  pRoll,  0       pVz; ...
                  0,        0,      0,      0 ];
            Tmn = Tm + W.*element.Delta;
            position = CPosition('tmatrix', Tmn);
            element.GlobalPosition = position;
        end
        
    end
    
end

