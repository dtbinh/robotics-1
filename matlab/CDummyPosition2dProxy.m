classdef CDummyPosition2dProxy < CDummyClientProxy
    %CDUMMYPOSITION2DPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XSpeed = 0;
        YSpeed = 0;
        YawSpeed = 0;
        RealPosition = sPositionData;
        IsInitialized = false;
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
                element.RealPosition.PosX  = speeds(4);
                element.RealPosition.PosY  = speeds(5);
                element.RealPosition.PosZ  = speeds(6);
                element.RealPosition.Alpha  = speeds(7);
                element.RealPosition.Betha  = speeds(8);
                element.RealPosition.Gamma  = speeds(9);
                
                % Set as initialized on first data read
                if (~element.IsInitialized)
                    element.IsInitialized = true;
                end
            end    
        end
    end
    
end

