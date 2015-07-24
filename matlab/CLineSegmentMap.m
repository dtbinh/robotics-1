classdef CLineSegmentMap < handle
    %CLINESEGMENTMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % An array of segments
        Segments =  CLineSegment;
        PointMap = CPointMap();
    end
    
    methods
        function element = CLineSegmentMap()
        end
        
        function addSegment(element, segment)
            element.Segments = [element.Segments, segment];
        end
        
        function addPoint(element, point)
            element.PointMap.addPoint(point);
        end

        
        function PlotMap(element)
            len = length(element.Segments);
            if len < 1
                return;
            end
            figure();
            hold on;
            for kk = 1:len
                x = element.Segments(kk).Ends(:,1);
                y = element.Segments(kk).Ends(:,2);
                plot(x, y);
            end
            hold off;
        end
    end
    
end

