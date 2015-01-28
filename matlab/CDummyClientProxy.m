classdef CDummyClientProxy < handle
    %CDUMMYCLIENTPROXY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Robot = [];
    end
    
    methods
        function element = CDummyClientProxy(robot)
            element.Robot = robot;
        end
        
        function Call(element)
        end
    end
    
end

