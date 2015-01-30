classdef (Sealed) CExperiment < handle
    %CEXPERIMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RobotPositions = [];
        SonarMeasurements = [];
        PositionFigure = [];% figure('keypressfcn',@CExperiment.KeyPress);
        
        Timer = [];
        TaskFunction = [];
        Period = 0.1;
       
        Clients = 0;
    end
    
    methods (Static)
        function element = getInstance()
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                localObj = CExperiment();
            end
            element = localObj;
            element.Clients = element.Clients + 1;
%             disp(['Experiment clients: ', num2str(element.Clients)]);
        end
        
        function releaseInstance(element)
            element.Clients = element.Clients - 1;
%             disp(['Experiment clients: ', num2str(element.Clients)]);
            if (element.Clients == 0)
                delete(element);
            end
        end
        
               
    end
    
    methods (Access = private)
        function element = CExperiment()
            disp('CExperiment created');
        end
        
        function delete(element)
            delete(element.Timer);
            delete(element.PositionFigure);
            element.TaskFunction = [];
            disp('Deleting CExperiment');
        end
    end
    
    methods
        function AddRobotPositions(element, positions)
            element.RobotPositions = [ ...
                element.RobotPositions; ...
                positions.PosX, ...
                positions.PosY, ...
                positions.Gamma ...
            ];
        end
        
        function AddSonarMeasurements(element, measurements)
            element.SonarMeasurements = [element.SonarMeasurements; measurements];
        end
        
        function Start(element, task)
            element.TaskFunction = task;
%             element.Period = period;
            element.PositionFigure = figure( ...
                'keypressfcn', @element.KeyPress, ...
                'Name', 'Experiment data: press ''q'' to stop...' ...
            );
            element.Timer = timer( ...
                'TimerFcn',{@element.TaskFcn}, ...
                'Period', element.Period, ...
                'ExecutionMode','fixedSpacing' ...
            );
            start(element.Timer);
            disp('Experiment started');
        end
        
        function Stop(element)
            stop(element.Timer);
%             delete(element.Timer);
%             delete(element.PositionFigure);
        end
        
        function KeyPress(element, ~, event)
            cmd = event.Key;
            switch (cmd)
                case 'q'
                    disp('Experiment stopped');
                    element.Stop();
            end
        end
        
        function TaskFcn(element, ~, ~)
            element.TaskFunction();
        end
        
        function PlotRawPoints(element, robot)
            pts = robot.Map.RawPoints;
            if (~isempty(pts))
                x = pts(:, 1);
                y = pts(:,2);
                plot(x,y,'*');
                axis('equal');
            end
        end
        
        function PlotRobotRawPoints(element, robot)
            pts = robot.RawPoints;
            if (~isempty(pts))
                x = pts(:, 1);
                y = pts(:,2);
                plot(x,y,'*');
            end
        end
        
        function Plot(element)
            figure(element.PositionFigure);
            if (~isempty(element.RobotPositions))
                plot(element.RobotPositions(:,1), element.RobotPositions(:,2));
                axis('equal');
            end
        end
    end
    
end

