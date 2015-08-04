robotPositions = [];
robotSpeeds = [];
sonarMeasurements = [];
cycleTimes = [];
cTime = 0;
for kk=1:length(task.Connection.DataBaseClass.PositionPoints)
    
    x = task.Connection.DataBaseClass.PositionPoints(kk).PosX;
    y = task.Connection.DataBaseClass.PositionPoints(kk).PosY;
    g = task.Connection.DataBaseClass.PositionPoints(kk).Gamma;
    robotPositions = [robotPositions; x, y, g];
    
    Vx = task.Connection.DataBaseClass.DynamicPoints(kk).XSpeed;
    Vy = task.Connection.DataBaseClass.DynamicPoints(kk).YSpeed;
    Yaw = task.Connection.DataBaseClass.DynamicPoints(kk).YawSpeed;
    robotSpeeds = [robotSpeeds; Vx, Vy, Yaw];
    
    sm = task.Connection.DataBaseClass.SonarPoints(kk).Measurements;
    sonarMeasurements = [sonarMeasurements; sm];
    
    cTime = cTime + task.Connection.DataBaseClass.Delta(kk);
    cycleTimes = [cycleTimes; cTime];
end


