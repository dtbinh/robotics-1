classdef CDummySonarProxy < CDummyClientProxy
    %CDUMMYSONARPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cSignal = '';
        sLength = 0;
        SensorDistances = zeros(1,16);
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
            x = element.sonarPos(number, 1);
            y = element.sonarPos(number, 2);
%             figure(figure);
            plot(x, y, 'bo');
        end
    end
    
end

