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

            element.Experiment.Plot();
            
        end
        
        function element = delete(element)
            disp('Deleting CMainTask');
            element.Experiment.releaseInstance(element.Experiment);
%             delete(element.Experiment);
            delete(element.Robot);
            delete(element.Connection);
        end
        
    end
    
end

