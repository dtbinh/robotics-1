classdef CDummyPosition2dProxy < CDummyClientProxy
    %CDUMMYPOSITION2DPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XSpeed = 0;
        YSpeed = 0;
        YawSpeed = 0;
    end
    
    methods
        function element = CDummyPosition2dProxy(robot)
            element = element@CDummyClientProxy(robot);
            element.Robot.RegisterProxy(element);
        end
        
        function Call(element)
            clientID = element.Robot.ClientID;
            vrep = element.Robot.vrep;
            [err,data] = vrep.simxGetStringSignal( ...
                clientID, ...
                'speedValues', ...
                vrep.simx_opmode_oneshot_wait ...
            );
            if (err == vrep.simx_return_ok)
                speeds = vrep.simxUnpackFloats(data);
                element.XSpeed = speeds(1);
                element.YSpeed = speeds(2);
                element.YawSpeed = speeds(3);
            end    
        end
    end
    
end

