classdef CDummyRobot < handle
    %CDUMMYROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Hostname = 'localhost';
        ClientID = -1;
        PortNumber = 19997;
        vrep= [];
        Proxies;
        ProxiesCount = 0;
        
        OfflineMode = false;
        DataBaseClass = [];%CDataBase(false);
        Delta = 0;
        LastCallTime = [];
    end
    
    methods
        function element = CDummyRobot(offlineMode)
            element.OfflineMode = offlineMode;
            if (~offlineMode)
                element.vrep = remApi('remoteApi');
                element.Connect();
            end
            element.LastCallTime = tic;
            element.DataBaseClass = CDataBase(offlineMode);
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
        
        function result = Read(element)
            result = false;
            if (-1 ~= element.ClientID)
                element.DataBaseClass.AddStep();
                for k = 1:element.ProxiesCount
%                     display(sprintf('Reading proxies: %d',k));
                        element.Proxies{k}.Call(element.DataBaseClass);
                end
                [element.Delta, element.LastCallTime] = getDeltaTime(element.LastCallTime);
                result = true;
            elseif (element.OfflineMode)
                for k = 1:element.ProxiesCount
                    element.Proxies{k}.OfflineCall(element.DataBaseClass);
                end
                element.Delta = element.DataBaseClass.GetDelta();
%                 element.DataBaseClass.StepNumber = element.DataBaseClass.StepNumber + 1;
                result = element.DataBaseClass.IncrementStep();
            end
        end
        
        function result = GetDelta(element)
            result = element.Delta;
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
            disp('Deleting CDummyRobot');
            if (~element.OfflineMode)
                element.Disconnect();
            end
            element.vrep.delete();
        end
    end
    
end

