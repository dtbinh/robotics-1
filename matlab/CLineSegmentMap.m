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
            % Check if it is on a line
            % Run regression
            % Add to point cloud
            element.PointMap.addPoint(point);
        end
        
        function result = isOnLine(element, point)
            result = false;
        end
        
        function resultList = DouglasPeucker(element, pointList, epsilon)
            % Find the point with the maximum distance
            dmax = 0;
            index = 0;
            pend = length(pointList);
            for kk = 2 : (pend - 1)
                d = shortestDistanceToSegment(pointList(kk), Line(pointList(1), pointList(end)));
                if ( d > dmax )
                    index = kk;
                    dmax = d;
                end
            end
            % If max distance is greater than epsilon, recursively simplify
            if ( dmax > epsilon )
                % Recursive call
                recResults1 = element.DouglasPeucker(pointList(1:index), epsilon);
                recResults2 = element.DouglasPeucker(pointList(index:end), epsilon);

                % Build the result list
                resultList = [recResults1(1:length(recResults1)-1), recResults2(1:length(recResults2))];
            else
                resultList = [pointList(1), pointList(end)];
            end
        end
        
        function result = shortestDistanceToSegment(element, segment)
            
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

