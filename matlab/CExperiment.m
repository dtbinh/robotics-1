classdef (Sealed) CExperiment < handle
    %CEXPERIMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        RobotPositions = [];
        SonarMeasurements = [];
    end
    
    methods
        function element = CExperiment()
            disp('CExperiment created');
        end
        
        function delete(element)
            disp('Deleting CExperiment');
        end
        
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
        
        function PlotEncoderTrajectory(element, robot)
            pts = robot.Map.RobotEncoderArray;
            if (~isempty(pts))
                x = pts(:, 1);
                y = pts(:,2);
                plot(x,y);
            end
        end
        
        
        function Plot(element)
            if (~isempty(element.RobotPositions))
                plot(element.RobotPositions(:,1), element.RobotPositions(:,2));
                axis('equal');
            end
        end
    end
    
end

