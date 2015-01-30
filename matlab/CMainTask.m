classdef CMainTask < handle
    %CMAINTASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Experiment = [];
        Robot = [];
        Connection = [];
    end
    
    methods
        function element = CMainTask()
            
            % Init robot
            element.Connection = CDummyRobot;
            element.Robot = CRobot(element.Connection);
            element.Experiment = CExperiment.getInstance();
            
            % Init task
            element.Experiment.Start(@element.Run);
        end
        
        function Run(element)
%             disp('Running main');

            element.Robot.Update();

            
            subplot(2, 2, [1 3], 'replace');
            element.Experiment.Plot();
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
        
        function element = delete(element)
            disp('Deleting CMainTask');
            element.Connection.Disconnect();
            element.Experiment.releaseInstance(element.Experiment);
%             delete(element.Experiment);
            delete(element.Robot);
            delete(element.Connection);
        end
        
    end
    
end

