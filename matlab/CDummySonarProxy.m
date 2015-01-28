classdef CDummySonarProxy < CDummyClientProxy
    %CDUMMYSONARPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cSignal = '';
        sLength = 0;
        SensorDistances = zeros(1,16);
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
    end
    
end

