classdef CRobot < handle
    %CROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Position = sPositionData;
        Dynamics = sDynamicsData;
        Robot = [];
        PositionProxy = [];
        SonarProxy = [];
        LastCallTime = tic;
    end
    
    methods
        function element = CRobot(robot)
            element.Robot = robot;
            element.PositionProxy = CDummyPosition2dProxy(element.Robot);
            element.SonarProxy = CDummySonarProxy(element.Robot);
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
            
            display(sprintf('Positions: %f, %f, %f\n', ...
                element.Position.PosX, ...
                element.Position.PosY, ...
                element.Position.Alpha ));
            
            
%             tmp = [element.Position.PosX, ...
%                 element.Position.PosY, ...
%                 element.Position.Alpha ];
%             global Positions;
%             Positions = [Positions; tmp];
        end
        
        function CalculatePointsPosition(element)
            
        end
    end
    
end

