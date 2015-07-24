clear all
clear classes
close all

sensor = CSensor();

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

tmp = load('PositionData001');

len=length(tmp.pts(:,1));
for kk=1:len
    point = CPoint();
    point.X = tmp.pts(kk, 1);
    point.Y = tmp.pts(kk, 2);
    point.Z = tmp.pts(kk, 3);
    sensor.Map.addPoint(point);
end

sensor.Map.PointMap.PlotMap();



