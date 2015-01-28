classdef CDummyRobot < handle
    %CDUMMYROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Hostname = 'localhost';
        ClientID = -1;
        PortNumber = 19997;
        vrep=remApi('remoteApi');
        Proxies;
        ProxiesCount = 0;
    end
    
    methods
        function element = CDummyRobot()
            element.Connect();
            element.Proxies = cell(1);
            element.Proxies{1} = CDummyClientProxy(element);
        end
        
        function Connect(element)
            element.vrep.simxFinish(-1);
            element.ClientID = ...
                element.vrep.simxStart( ...
                    element.Hostname, ...
                    element.PortNumber, ...
                    true, ...
                    true, ...
                    500, ...
                    5 ...
                );
            disp(sprintf('Connection id: %d\n', element.ClientID));
        end
        
        function Read(element)
            for k = 1:element.ProxiesCount
                element.Proxies{k}.Call();
            end
        end
        
        function Disconnect(element)
            if (-1 ~= element.ClientID)
                element.vrep.simxFinish(element.ClientID);
            end
        end
        
        function RegisterProxy(element, proxy)
            if element.ProxiesCount > 0
                element.Proxies = [ element.Proxies, cell(1) ];
            end
            element.ProxiesCount = element.ProxiesCount + 1;
            element.Proxies{element.ProxiesCount} = proxy;
        end
        
        function delete(element)
            element.Disconnect();
        end
    end
    
end

