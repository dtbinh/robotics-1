
% Copyright 2006-2014 Coppelia Robotics GmbH. All rights reserved. 
% marc@coppeliarobotics.com
% www.coppeliarobotics.com
% 
% -------------------------------------------------------------------
% THIS FILE IS DISTRIBUTED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
% WARRANTY. THE USER WILL USE IT AT HIS/HER OWN RISK. THE ORIGINAL
% AUTHORS AND COPPELIA ROBOTICS GMBH WILL NOT BE LIABLE FOR DATA LOSS,
% DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR
% MISUSING THIS SOFTWARE.
% 
% You are free to use/modify/distribute this file for whatever purpose!
% -------------------------------------------------------------------
%
% This file was automatically created for V-REP release V3.1.2 on June 16th 2014

% Make sure to have the server side running in V-REP: 
% in a child script of a V-REP scene, add following command
% to be executed just once, at simulation start:
%
% simExtRemoteApiStart(19999)
%
% then start simulation, and run this program.
%
% IMPORTANT: for each successful call to simxStart, there
% should be a corresponding call to simxFinish at the end!

function Pioneer3DX_connector()
	disp('Program started');
	% vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
	vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID=vrep.simxStart('127.0.0.1',19997,true,true,500,5);
	try
		if (clientID>-1)
			disp('Connected to remote API server');
% 			[res,objs]=vrep.simxGetObjects(clientID,vrep.sim_handle_all,vrep.simx_opmode_oneshot_wait);
% 			if (res==vrep.simx_return_ok)
% 				fprintf('Number of objects in the scene: %d\n',length(objs));
% 			else
% 				fprintf('Remote API function call returned with error code: %d\n',res);
% 			end

            sensorHandles = zeros(16,1);
            sensorAnalog = zeros(16,3);
            sensorDigital = zeros(16);
            

            for ii = 1:16
                [err, sensorHandles(ii)] = vrep.simxGetObjectHandle(clientID, ...
                    sprintf('Pioneer_p3dx_ultrasonicSensor%d', ii), ...
                    vrep.simx_opmode_oneshot_wait);
            end

            while (1)
                error = vrep.simx_return_ok;
                for ii = 1:16
                    [err, sensorDigital(ii), sensorAnalog(ii,:)] = vrep.simxReadProximitySensor(clientID, ...
                        sensorHandles(ii), vrep.simx_opmode_oneshot);
                    if (err ~= vrep.simx_return_ok)
                        error = err;
                        disp(err);
                    end
                end

                if (error == vrep.simx_return_ok)
                    str = '';
                    for ii = 1:16
                        str = [str, sprintf('s%d: %0.2f\t', ii, sensorAnalog(ii,3))];
                    end
                        disp(str);
                end
            end
			vrep.simxFinish(clientID);
		else
			disp('Failed connecting to remote API server');
		end
		vrep.delete(); % call the destructor!
	catch err
		vrep.simxFinish(clientID); % close the line if still open
		vrep.delete(); % call the destructor!
	end;
	
	disp('Program ended');
end

