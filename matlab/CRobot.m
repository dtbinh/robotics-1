classdef CRobot < handle
    %CROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Position = [];
        Dynamics = [];
        Connection = [];
        PositionProxy = [];
        SonarProxy = [];
        LastCallTime = [];
        RawPoints = []; %% zeros(16,2);
        Map = CMap();
        IsInitialized = false;
    end
    
    methods
        function element = CRobot(connection)
            element.Connection = connection;
            element.PositionProxy = CDummyPosition2dProxy(element.Connection);
            element.SonarProxy = CDummySonarProxy(element.Connection);
            element.LastCallTime = tic;
            element.Position = sPositionData;
            element.Dynamics = sDynamicsData;
        end
        
        function result = Update(element)
%             result = false;
            %[dt, element.LastCallTime] = getDeltaTime(element.LastCallTime);
            result = element.Connection.Read();
            dt = element.Connection.GetDelta();
            if (element.PositionProxy.IsInitialized)
                if (~element.IsInitialized)
                    element.IsInitialized = true;
                    % Match initial orientation
                    element.Position.Gamma = element.PositionProxy.RealPosition.Gamma;
                end
                element.Position.PosX = element.PositionProxy.XSpeed*dt + element.Position.PosX;
                element.Position.PosY = element.PositionProxy.YSpeed*dt + element.Position.PosY;
                element.Position.Gamma = element.PositionProxy.YawSpeed*dt + element.Position.Gamma;
                
                element.Map.AddRobotEncoderPositionPoint(element.Position);
                
                element.CalculatePointsPosition();
            end
        end
        
        % This function should calculate measured from sonars point
        % coordinates in world coordinate system and append them to the map
        function CalculatePointsPosition(element)
            % Get robot in world matrix
            robotMatrix  = CAlgorthms.GetTransformationMatrix( 0, ...
                element.Position ...
                );
            element.RawPoints = [];
            for kk = 1:16
                if (element.SonarProxy.IsValidData(kk))
                    % Get sensor in robot matrix - will be constant
                    sensorMatrix = CAlgorthms.GetTransformationMatrix( 0, ...
                        element.SonarProxy.SensorPositions(kk) ...
                        );
                    % Get obstacle in sensor translation matrix
                    obstacleMatrix = element.SonarProxy.GetObstacleTranslationMatrix(kk);
                    % Calculate local point positions
                    pointMatrix = sensorMatrix * obstacleMatrix;
                    lx = pointMatrix(1,1);
                    ly = pointMatrix(2,1);
                    element.RawPoints = [ element.RawPoints; lx, ly ];
                    pointMatrix = robotMatrix * sensorMatrix * obstacleMatrix;
                    x = pointMatrix(1,1);
                    y = pointMatrix(2,1);
                    element.Map.AddPoint(x, y);
                    element.Map.AddPointBySensor(kk, x, y);
                end
                
            end
        end
        
        function PlotElementSymbol(element)
            m = CAlgorthms.GetTransformationMatrix( 0, ...
                element.Position ...
            );
            xy = [ ...
                0, 3, 0, 0; ...
                -1, 0, 1, -1
                ];
            koef = 1 ...
                /2 ... % to be 1 unit
                /100 ... % to be 1 cm
                *10;  % 0.01 m
            x = xy(1, :) * koef;
            y = xy(2, :) * koef;
            pos = zeros(4, length(x));
            for kk = 1: length(x)
                xyz = [ x(kk), y(kk), 0, 1 ]';
                pos(:, kk) = m * xyz;
            end
            plot(x, y, 'b-');
            plot(pos(1,:), pos(2, :), 'b-');
        end
        
        function delete(element)
            disp('Deleting CRobot');
            delete(element.PositionProxy);
            delete(element.SonarProxy);
%            delete(element.Map);
        end
    end
    
end

