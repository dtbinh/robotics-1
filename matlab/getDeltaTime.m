function [ Delta, NewTime ] = getDeltaTime( PreviousTime )
%GETDELTATIME Summary of this function goes here
%   Detailed explanation goes here
%     diff = 0;
%     timeNow = now();
% 
%     if PreviousTime > 0
%         diff = timeNow - PreviousTime;
%     end
%     NewTime = timeNow;
    Delta = toc(PreviousTime);
    NewTime = tic;
end

