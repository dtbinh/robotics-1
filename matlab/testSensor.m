close all
clear all
clear classes


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

sensor = [];

% Sensor No: 1
sp = CPosition('XYg', 0.061905, 0.138200, 90.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 2
sp = CPosition('XYg', 0.110930, 0.125051, 50.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 3
sp = CPosition('XYg', 0.146105, 0.083135, 30.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 4
sp = CPosition('XYg', 0.164690, 0.027275, 10.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 5
sp = CPosition('XYg', 0.164690, -0.027272, -10.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 6
sp = CPosition('XYg', 0.146071, -0.078500, -30.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 7
sp = CPosition('XYg', 0.111048, -0.120238, -50.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 8
sp = CPosition('XYg', 0.061905, -0.138143, -90.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 9
sp = CPosition('XYg', -0.154795, -0.138150, -90.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 10
sp = CPosition('XYg', -0.204038, -0.120241, -130.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 11
sp = CPosition('XYg', -0.239053, -0.078500, -150.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 12
sp = CPosition('XYg', -0.257680, -0.027274, -170.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 13
sp = CPosition('XYg', -0.257680, 0.027274, 170.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 14
sp = CPosition('XYg', -0.239061, 0.078500, 150.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 15
sp = CPosition('XYg', -0.204039, 0.120265, 130.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

% Sensor No: 16
sp = CPosition('XYg', -0.154795, 0.138200, 90.000000 * pi/180);
sensor = [sensor; CSensor(sp.PositionData)];

figure;
hold on;
rob = load('ExperimentData001');
robotPositions = rob.robotPositions;
sonarMeasurements = rob.sonarMeasurements;
robotSpeeds = rob.robotSpeeeds;
cycleTimes = rob.cycleTimes;
cTime = 0;
% prevPos = CPosition('XYg', robotPositions(1, 1), ...
%         robotPositions(1, 2), robotPositions(1, 3));
for kk=1:length(robotPositions(:,1))
    robotPosition = CPosition('XYg', robotPositions(kk, 1), ...
        robotPositions(kk, 2), robotPositions(kk, 3));
%     sensor.TranslateParent(robotPosition.PositionData);
    
%     Vx = 0;
%     Vy = 0;
%     W = 0;
%     if kk > 1
%         Vx = (robotPositions(kk, 1) - prevPos.PositionData.PosX) / (cycleTimes(kk) - cTime);
%         Vy = (robotPositions(kk, 2) - prevPos.PositionData.PosY) / (cycleTimes(kk) - cTime);
%         W = (robotPositions(kk, 3) - prevPos.PositionData.Gamma) / (cycleTimes(kk) - cTime);
%     end
%     prevPos = CPosition('XYg', robotPositions(1, 1), ...
%         robotPositions(1, 2), robotPositions(1, 3));

    speed = sDynamicsData;
    speed.Vx = robotSpeeds(kk, 1);
    speed.Vy = robotSpeeds(kk, 2);
    speed.Yaw = robotSpeeds(kk, 3);

    for ll=1:16
        sensor(ll).Distance = sonarMeasurements(kk, ll);
        sensor(ll).setInputs(speed);
        sensor(ll).Delta = cycleTimes(kk) - cTime;
        sensor(ll).Run();
%         sensor(ll).PlotSymbol;
%         sensor(ll).PlotMeasurement;
    end

    cTime = cycleTimes(kk);
    
%     plot(robotPosition.PositionData.PosX, ...
%         robotPosition.PositionData.PosY, 'go');

end
hold off;
