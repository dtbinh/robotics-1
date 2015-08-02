% close all
% clear all
% clear classes


% sensor = CSensor();

% pts = [];
% len=length(element.PositionPoints);
% for kk=1:len
%     point = CPoint();
%     point.X = element.PositionPoints(kk).PosX;
%     point.Y = element.PositionPoints(kk).PosY;
%     point.Z = element.PositionPoints(kk).PosZ;
%     sensor.Map.addPoint(point);
%     pts = [pts; point.X, point.Y, point.Z];
% end

% for kk = 1:20
%     point = CPoint();
%     point.X = kk;
%     point.Y = 8*kk+13;
%     sensor.Map.addPoint(point);
% end



% maxDistance = 0.02;
% 
% tmp = load('PointPositionData001');
% len=length(tmp.pts(:,1));
% for kk=1:len
% %     point = CPoint();
% %     point.X = tmp.pts(kk, 1);
% %     point.Y = tmp.pts(kk, 2);
% %     point.Z = tmp.pts(kk, 3);
%     sensor.Map.addPoint(tmp.pts(kk));
% end
% 
% sensor.Map.PointMap.PlotMap();
% hold on
% segments = sensor.Map.DouglasPeucker(sensor.Map.PointMap.Points, maxDistance);
% sensor.Map.Segments = segments;
% sensor.Map.PlotMap
% hold off


% robotPositions = [];
% sonarMeasurements = [];
% for kk=1:length(task.Connection.DataBaseClass.PositionPoints)
%     x = task.Connection.DataBaseClass.PositionPoints(kk).PosX;
%     y = task.Connection.DataBaseClass.PositionPoints(kk).PosY;
%     g = task.Connection.DataBaseClass.PositionPoints(kk).Gamma;
%     robotPositions = [robotPositions; x, y, g];
%     sm = task.Connection.DataBaseClass.SonarPoints(kk).Measurements;
%     sonarMeasurements = [sonarMeasurements; sm];
% end

% Sensor No: 4
sp = CPosition('XYg', 0.209190, 0.027275, 10 * pi/180);
sensor = CSensor(sp.PositionData);

figure;
hold on;
rob = load('RobotPositions001');
son = load('SonarMeasurements001');
robotPositions = rob.robotPositions;
sonarMeasurements = son.sonarMeasurements;
for kk=1:length(robotPositions(:,1))
    robotPosition = CPosition('XYg', robotPositions(kk, 1), ...
        robotPositions(kk, 2), robotPositions(kk, 3));
    sensor.TranslateParent(robotPosition.PositionData);
    sensor.Distance = sonarMeasurements(kk, 4);
    
    plot(robotPosition.PositionData.PosX, ...
        robotPosition.PositionData.PosY, 'go');
    sensor.PlotSymbol;
    sensor.PlotMeasurement;
end
hold off;
