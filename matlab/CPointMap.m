classdef CPointMap < handle
    %CPOINTMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Points = [];
        Pointer = 0;
    end
    
    methods
        function element = CPointMap()
            element.Points = [];
        end
        
        function addPoint(element, point)
            element.Points = [element.Points; point];
        end
        
        function [X, Y, Z] = getPointArrays(element)
            len = length(element.Points);
            X = zeros(len, 1);
            Y = zeros(len, 1);
            Z = zeros(len, 1);
            for kk = 1:len
                X(kk) = element.Points(kk).X;
                Y(kk) = element.Points(kk).Y;
                Z(kk) = element.Points(kk).Z;
            end
        end

        function PlotMap(element)
            len = length(element.Points);
            if len < 1
                return;
            end
            x = [];
            y = [];
            for kk = 1:len
                x = [x; element.Points(kk).X];
                y = [y; element.Points(kk).Y];
            end
            plot(x, y, 'r+');
        end
        
        function result = getNexPoint(element)
        end
    end
    
end

