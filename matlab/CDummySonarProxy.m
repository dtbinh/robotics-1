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
	0.1064, 0.1382, 0, 90; ...
	0.1554, 0.1251, 0, 50; ...
	0.1906, 0.0831, 0, 30; ...
	0.2092, 0.0273, 0, 10; ...
	0.2092, -0.0273, 0, -10; ...
	0.1906, -0.0785, 0, -30; ...
	0.1555, -0.1202, 0, -50; ...
	0.1064, -0.1381, 0, -90; ...
	-0.1103, -0.1382, 0, -90; ...
	-0.1595, -0.1202, 0, -130; ...
	-0.1946, -0.0785, 0, -150; ...
	-0.2132, -0.0273, 0, -170; ...
	-0.2132, 0.0273, 0, 170; ...
	-0.1946, 0.0785, 0, 150; ...
	-0.1595, 0.1203, 0, 130; ...
	-0.1103, 0.1382, 0, 90;
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
                csp.Alpha = element.sonarPos(kk, 4) * pi/180;
                sp = [sp; csp];
            end
            element.SensorPositions = sp;
        end
        
        function Call(element)
            clientID = element.Robot.ClientID;
            vrep = element.Robot.vrep;
            [err,data] = vrep.simxGetStringSignal( ...
                clientID, ...
                'sonarSensors', ...
                vrep.simx_opmode_oneshot_wait ...
            );
            if (err == vrep.simx_return_ok)
                element.SensorDistances = vrep.simxUnpackFloats(data);
            end    
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
                dist = element.MinDistance;
                if (element.SensorDistances(kk) <= element.MaxDistance)
                    dist = element.SensorDistances(kk);
                end
                m = CAlgorthms.GetTransformationMatrix( 0, ...
                    element.SensorPositions(kk) ...
                );
                meas(:, 1) = m * [dist;0;0;1];
                meas(:, 2) = m(:,4);
                plot(meas(1, :), meas(2, :), 'm-');
            end
            hold off;
        end
    end
    
end

