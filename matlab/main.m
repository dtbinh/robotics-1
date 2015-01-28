clear all;

Positions = [];

conn = CDummyRobot;

% pause(0.05);
% sp = CDummySonarProxy(rob);
% pp = CDummyPosition2dProxy(rob);

% pause(0.05);

% sp.Call();
% pp.Call();

% rob.Read()

rob = CRobot(conn);

Experiment = CExperiment.getInstance();

for kk=0:200
    rob.Update();
    
    Experiment.Plot();
end

