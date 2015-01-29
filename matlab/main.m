% 
% Positions = [];
% 
% conn = CDummyRobot;
% 
% rob = CRobot(conn);
% 
% Experiment = CExperiment.getInstance();
% 
% Experiment.Start();
% 
% Conduct();

% for kk=0:200
%     rob.Update();
%     
%     Experiment.Plot();
% end


% tim = timer('TimerFcn', {@MainTask, rob, Experiment}, 'Period', 0.02, 'ExecutionMode', 'fixedRate');
% start(tim);
% 
% % input('Enter to stop: ');
% 
% pause(10);
% 
% stop(tim);
% delete(tim);


if (exist('task', 'var'))
    task.delete();
end
clear all;
pause(1);

task = CMainTask();

% clear all;

