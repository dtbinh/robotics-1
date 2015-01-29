classdef CRobot < handle
    %CROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Position = [];
        Dynamics = [];
        Robot = [];
        PositionProxy = [];
        SonarProxy = [];
        LastCallTime = [];
    end
    
    methods
        function element = CRobot(robot)
            element.Robot = robot;
            element.PositionProxy = CDummyPosition2dProxy(element.Robot);
            element.SonarProxy = CDummySonarProxy(element.Robot);
            element.LastCallTime = tic;
            element.Position = sPositionData;
            element.Dynamics = sDynamicsData;
        end
        
        function Update(element)
            [dt, element.LastCallTime] = getDeltaTime(element.LastCallTime);
            element.Robot.Read();
            element.Position.PosX = element.PositionProxy.XSpeed*dt + element.Position.PosX;
            element.Position.PosY = element.PositionProxy.YSpeed*dt + element.Position.PosY;
            element.Position.Alpha = element.PositionProxy.YawSpeed*dt + element.Position.Alpha;
            
            exp = CExperiment.getInstance;
            exp.AddRobotPositions(element.Position);
            exp.AddSonarMeasurements(element.SonarProxy.SensorDistances);
            exp.releaseInstance(exp);
            
%             display(sprintf('Positions: %f, %f, %f\n', ...
%                 element.Position.PosX, ...
%                 element.Position.PosY, ...
%                 element.Position.Alpha ));
            
        end
        
        function CalculatePointsPosition(element)
            
        end
        
        function delete(element)
            disp('Deleting CRobot');
            delete(element.PositionProxy);
            delete(element.SonarProxy);
        end
    end
    
end

