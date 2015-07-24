sensor = CSensor();


for kk = 1:20
    point = CPoint();
    point.X = kk;
    point.Y = 8*kk+13;
    sensor.Map.addPoint(point);
end

sensor.Map.PointMap.PlotMap();

