classdef CPointMap < handle
    %CPOINTMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Points = CPoint;
    end
    
    methods
        function element = CPointMap()
            element.Points = [];
        end
        
        function addPoint(element, point)
            element.Points = [element.Points; point];
        end

        function PlotMap(element)
            len = length(element.Points);
            if len < 1
                return;
            end
            figure();
            hold on;
            for kk = 1:len
                x = element.Points(kk).X;
                y = element.Points(kk).Y;
                plot(x, y, 'r+');
            end
            hold off;
        end
    end
    
end

