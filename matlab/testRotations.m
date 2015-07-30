lp = sPositionData;
lp.PosX = 2;
lp.PosY = 3;
lp.Gamma = pi/4;
tp = sPositionData;
tp.Gamma = pi/4;

sensor = CSensor(lp);
sensor.TranslateParent(tp);