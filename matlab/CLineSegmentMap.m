classdef CLineSegmentMap < handle
    %CLINESEGMENTMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % An array of segments
        Segments =  [];
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
        
        function result = RANSAC(element, points, epsilon)
            iterations = 20;
            pts = points;
            while ((iterations > 0)&&(~isempty(pts)))
                pts = element.RANSAC_iteration(pts, epsilon);
                iterations = iterations - 1;
            end
        end
        
        function result = RANSAC_iteration(element, points, epsilon)
            beginSet = CPointSet(points);
            inlierSet = CPointSet();
            inlierSet.addPoint(beginSet.getRandomPoint);
            inlierSet.addPoint(beginSet.getRandomPoint);
            segment = CLineSegment(inlierSet.Points(1), inlierSet.Points(2));
            point = beginSet.getPoint();
            notOnLineSet = CPointSet();
            while ~isempty(point)
                if (segment.distanceFromPoint < epsilon)
                    inlierSet.addPoint(point);
                else
                    notOnLineSet.addPoint(point);
                end
            end
            result = notOnLineSet.Points;
        end
        
        function result = DouglasPeucker(element, pointList, epsilon)
            % Find the point with the maximum distance
            resultList = [];
            dmax = 0;
            index = 0;
            pend = length(pointList);
            lin = CLineSegment(pointList(1), pointList(end));
            for kk = 2 : (pend - 1)
                d = element.shortestDistanceToSegment(pointList(kk), lin);
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
                resultList = [recResults1; recResults2];
            else
                if length(pointList) > 5
                resultList = CLineSegment(pointList(1), pointList(end));
                end
            end
            result = resultList;
        end
        
        function result = shortestDistanceToSegment(element, point, segment)
            result = segment.distanceFromPoint(point);
        end
        
        function PlotMap(element)
            len = length(element.Segments);
            if len < 1
                return;
            end
            for kk = 1:len
                element.Segments(kk).Plot;
            end
        end
    end
    
end

