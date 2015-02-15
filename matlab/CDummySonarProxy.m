classdef CDummySonarProxy < CDummyClientProxy
    %CDUMMYSONARPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cSignal = '';
        sLength = 0;
        MaxDistance = 1.2;
        MinDistance = 0.02;
        SensorDistances = zeros(1,16);
        SensorPositions = [];
        sonarPos = [ ...
0.106405, 0.138200, 0.000000, 180.000000; ...
0.155430, 0.125051, 0.000000, 140.000006; ...
0.190606, 0.083135, 0.000000, 120.000008; ...
0.209190, 0.027275, 0.000000, 100.000035; ...
0.209190, -0.027272, 0.000000, 79.999994; ...
0.190571, -0.078501, 0.000000, 59.999992; ...
0.155548, -0.120238, 0.000000, 39.999999; ...
0.106405, -0.138144, 0.000000, 0.000000; ...
-0.110295, -0.138150, 0.000000, 0.000109; ...
-0.159538, -0.120241, 0.000000, -40.019257; ...
-0.194552, -0.078501, 0.000000, -60.000001; ...
-0.213180, -0.027275, 0.000000, -79.955856; ...
-0.213180, 0.027274, 0.000000, -100.044483; ...
-0.194561, 0.078500, 0.000000, -119.999986; ...
-0.159538, 0.120265, 0.000000, -139.999999; ...
-0.110295, 0.138200, 0.000000, 179.999959;
    ];

    end
    
    methods
        function element = CDummySonarProxy(robot)
            element = element@CDummyClientProxy(robot);
            element.Robot.RegisterProxy(element);
            sp = [];
            csp = sPositionData;
            for kk = 1:16
                csp.PosX = element.sonarPos(kk, 1);
                csp.PosY = element.sonarPos(kk, 2);
                csp.PosZ = element.sonarPos(kk, 3);
                % Rotate on -90 around Z while we are working in 2D
                % environment
                csp.Gamma = (element.sonarPos(kk, 4) - 90) * pi/180;
                sp = [sp; csp];
            end
            element.SensorPositions = sp;
        end
        
        function Call(element, database)
%             disp('Sonar proxy task');
            clientID = element.Robot.ClientID;
            vrep = element.Robot.vrep;
            [err,data] = vrep.simxGetStringSignal( ...
                clientID, ...
                'sonarSensors', ...
                vrep.simx_opmode_oneshot_wait ...
            );
            if (err == vrep.simx_return_ok)
                element.SensorDistances = vrep.simxUnpackFloats(data);
                pts = sSonarData;
                pts.Measurements = element.SensorDistances;
                database.AddSonarPoint(pts);
            end    
        end
        
        function OfflineCall(element, database)
            element.SensorDistances = database.GetSonarPoint();
        end
        
        function PlotSonarPositions(element)
%             fig = figure(1);
            plot(0, 0, 'ro');
            hold on;
            for kk = 1:16
                element.PlotSonarSymbol(kk);
            end
            hold off;
        end
        
        function PlotSonarSymbol(element, number)
            m = CAlgorthms.GetTransformationMatrix( 0, ...
                element.SensorPositions(number) ...
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
%             pos(:, 2) = m * xyz(:, 2);
%             pos(:, 3) = m * xyz(:, 3);
%             pos(:, 4) = m * xyz(:, 4);
%             pos(:, 5) = m * xyz(:, 5);
%             figure(figure);
            plot(x, y, 'b-');
            plot(pos(1,:), pos(2, :), 'b-');
        end
        
        function PlotSonarMeasurements(element)
            meas = zeros(4,2);
            element.PlotSonarPositions();
            hold on;
            for kk = 1:16
                if (element.IsValidData(kk))
                    m = CAlgorthms.GetTransformationMatrix( 0, ...
                        element.SensorPositions(kk) ...
                    );
                    obj = element.GetObstacleTranslationMatrix(kk);
                    meas(:, 1) = m * obj;
                    meas(:, 2) = m(:,4);
                    plot(meas(1, :), meas(2, :), 'm-');
                end
            end
            axis([-2 2 -2 2]);
            axis('square');
            hold off;
        end
        
        % Gets the translation matrix based on distance measured. Does not
        % check for validity of the point
        function matrix = GetObstacleTranslationMatrix(element, number)
            matrix = [element.SensorDistances(number); 0; 0; 1];
        end
        
        function valid = IsValidData(element, number)
            valid = false;
            if ( (element.SensorDistances(number) <= element.MaxDistance) && ...
                    (element.SensorDistances(number) >= element.MinDistance) )
                valid = true;
            end
        end
    end
    
end

