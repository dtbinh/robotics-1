classdef (Sealed) CExperiment < handle
    %CEXPERIMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RobotPositions = [];
        SonarMeasurements = [];
        
        Clients = 0;
    end
    
    methods (Static)
        function element = getInstance()
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                localObj = CExperiment;
            end
            element = localObj;
            element.Clients = element.Clients + 1;
            disp(['Experiment clients: ', num2str(element.Clients)]);
        end
        
        function releaseInstance(element)
            element.Clients = element.Clients - 1;
            disp(['Experiment clients: ', num2str(element.Clients)]);
            if (element.Clients <= 0)
%                 delete(element);
            end
        end
    end
    
    methods
        function element = CExperiment()
            disp('Experiment created');
        end
        
        function AddRobotPositions(element, positions)
            element.RobotPositions = [ ...
                element.RobotPositions; ...
                positions.PosX, ...
                positions.PosY, ...
                positions.Alpha ...
            ];
        end
        
        function AddSonarMeasurements(element, measurements)
            element.SonarMeasurements = [element.SonarMeasurements; measurements];
        end
        
        function Plot(element)
            plot(element.RobotPositions(:,1), element.RobotPositions(:,2));
        end
        
        function delete(element)
            disp('Deleting experiment');
        end
    end
    
end

