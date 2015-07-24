classdef sDynamicsData < handle
    %SDYNAMICSDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Linear speeds
        Vx = 0.0;
        Vy = 0.0;
        Vz = 0.0;
        
        % Angular speeds
        Roll = 0.0;     % Over X
        Pitch = 0.0;    % Over Y
        Yaw = 0.0;      % Over Z
        
        XSpeed = 0.0;
        YSpeed = 0.0;
        YawSpeed = 0.0;
        Delta = 0;
    end

end

