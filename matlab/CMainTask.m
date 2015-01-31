classdef CMainTask < handle
    %CMAINTASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Experiment = [];
        Robot = [];
        Connection = [];
        
        Figure = [];
        Timer = [];
        Period = 0.1;
    end
    
    methods
        function element = CMainTask()
            % Init robot
            element.Connection = CDummyRobot;
            element.Robot = CRobot(element.Connection);
            element.Experiment = CExperiment();
            
            % Init task
            element.Start();
        end
        
        function TaskFcn(element, ~, ~)
            element.Run();
        end
        
        function Run(element)
%             disp('Running main');

            element.Robot.Update();

            
            subplot(2, 2, [1 3], 'replace');
            element.Experiment.PlotEncoderTrajectory(element.Robot);
            hold on;
            element.Robot.PlotElementSymbol();
            hold off;
            subplot(2,2,2);
            element.Robot.SonarProxy.PlotSonarMeasurements();
            hold on;
            element.Experiment.PlotRobotRawPoints(element.Robot);
            hold off;
            subplot(2,2,4);
            element.Experiment.PlotRawPoints(element.Robot);
            
        end
        
        function KeyPress(element, ~, event)
            cmd = event.Key;
            switch (cmd)
                case 'q'
                    disp('Main task stopped');
                    element.Stop();
            end
        end
        
        function Start(element)
            element.Figure = figure( ...
                'keypressfcn', @element.KeyPress, ...
                'Name', 'Experiment data: press ''q'' to stop...' ...
            );
            element.Timer = timer( ...
                'TimerFcn',{@element.TaskFcn}, ...
                'Period', element.Period, ...
                'ExecutionMode','fixedSpacing' ...
            );
            start(element.Timer);
            disp('Main task started');
        end
        
        function Stop(element)
            stop(element.Timer);
        end
        
        function element = delete(element)
            disp('Deleting CMainTask');
            element.Stop();
            element.Connection.Disconnect();
            delete(element.Experiment);
            delete(element.Robot);
            delete(element.Connection);
        end
        
    end
    
end

