lp = sPositionData;
lp.PosX = 2;
lp.PosY = 3;
lp.Gamma = 0;

% Set robot position
pr = CPosition('XYg', 0, 0, 0);

% Set sensor position in robot
sensor = CSensor(lp);

% Set translation
tp = CPosition('XYg', 0, 0, pi/2);

Tt = tp.GetTransformationMatrix;
Tr = pr.GetTransformationMatrix;

Tr = Tt * Tr;
rt = CPosition('tmatrix', Tr);

sensor.PlotSymbol;
hold on;
sensor.TranslateParent(rt.PositionData);
sensor.PlotSymbol;

% Set translation
tp = CPosition('XYg', 4, 0, 0);

Tt = tp.GetTransformationMatrix;

Tr = Tt * Tr;
rt = CPosition('tmatrix', Tr);

sensor.TranslateParent(rt.PositionData);
sensor.PlotSymbol;

hold off;