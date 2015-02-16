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
        
        OfflineMode = false;
    end
    
    methods
        function element = CMainTask(offlineMode)
            % Init robot
            element.OfflineMode = offlineMode;
            element.Connection = CDummyRobot(offlineMode);
            element.Robot = CRobot(element.Connection);
            element.Experiment = CExperiment();
            
            element.Timer = [];
            element.Figure = [];
            
            
            if (~element.OfflineMode)
                % Init task
                element.Start();
            else
                element.RunOfflineCalculations();
            end
        end
        
        function TaskFcn(element, ~, ~)
            element.Run();
        end
        
        function Run(element)
%             disp('Running main');

            element.Robot.Update();

            element.PlotTask();
         
        end
        
        function RunOfflineCalculations(element)
            for kk = 1:100
                element.Robot.Update();
                element.PlotTask();
            end
        end
        
        function PlotTask(element)
            subplot(2, 2, [1 3], 'replace');
            element.Experiment.PlotEncoderTrajectory(element.Robot);
            hold on;
            element.PlotAllSensors();
            element.Robot.PlotElementSymbol();
            axis('equal');
            hold off;
            subplot(2,2,2);
            element.Robot.SonarProxy.PlotSonarMeasurements();
            axis('equal');
            hold on;
            element.Experiment.PlotRobotRawPoints(element.Robot);
            axis('equal');
            hold off;
            subplot(2,2,4);
            element.Experiment.PlotRawPoints(element.Robot);
            axis('equal');
%             axis([-10, 10, -10, 10]);   
        end
        
        function PlotAllSensors(element)
            element.Experiment.PlotRawSensorPoints(element.Robot, 1, 'g*');
            element.Experiment.PlotRawSensorPoints(element.Robot, 2, 'r*');
            element.Experiment.PlotRawSensorPoints(element.Robot, 3, 'c*');
            element.Experiment.PlotRawSensorPoints(element.Robot, 4, 'm*');
            element.Experiment.PlotRawSensorPoints(element.Robot, 5, 'go');
            element.Experiment.PlotRawSensorPoints(element.Robot, 6, 'ro');
            element.Experiment.PlotRawSensorPoints(element.Robot, 7, 'co');
            element.Experiment.PlotRawSensorPoints(element.Robot, 8, 'mo');
            element.Experiment.PlotRawSensorPoints(element.Robot, 9, 'g+');
            element.Experiment.PlotRawSensorPoints(element.Robot, 10, 'r+');
            element.Experiment.PlotRawSensorPoints(element.Robot, 11, 'c+');
            element.Experiment.PlotRawSensorPoints(element.Robot, 12, 'm+');
            element.Experiment.PlotRawSensorPoints(element.Robot, 13, 'g^');
            element.Experiment.PlotRawSensorPoints(element.Robot, 14, 'r^');
            element.Experiment.PlotRawSensorPoints(element.Robot, 15, 'c^');
            element.Experiment.PlotRawSensorPoints(element.Robot, 16, 'm^');
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
            element.Timer = timer( 'Name', 'CMainTaskTmr', ...
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
            if (~element.OfflineMode)
                element.Stop();
                delete(element.Timer);
            end
            element.Connection.Disconnect();
            delete(element.Experiment);
            delete(element.Robot);
            delete(element.Connection);
        end
        
    end
    
end

