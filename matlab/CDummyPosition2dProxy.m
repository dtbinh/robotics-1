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
        
        function Call(element, database)
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
                
                % Manage database
                pts = sPositionData;
                pts = element.RealPosition;
                database.AddPositionPoint(pts);
                
                dpts = sDynamicsData;
                dpts.XSpeed = element.XSpeed;
                dpts.YSpeed = element.YSpeed;
                dpts.YawSpeed = element.YawSpeed;
                database.AddDynamicsPoint(dpts);
                
                % Set as initialized on first data read
                if (~element.IsInitialized)
                    element.IsInitialized = true;
                end
            end    
        end
        
        function OfflineCall(element, database)
            element.RealPosition = database.GetPositionPoint();
            
            dpts = database.GetDynamicsPoint();
            element.XSpeed = dpts.XSpeed;
            element.YSpeed = dpts.YSpeed;
            element.YawSpeed = dpts.YawSpeed;
            % Set as initialized on first data read
            if (~element.IsInitialized)
                element.IsInitialized = true;
            end
        end

    end
    
end

