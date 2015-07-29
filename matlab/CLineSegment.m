classdef CLineSegment < CLine
    %CLINESEGMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Ends = [CPoint(); CPoint()];
    end
    
    methods
        function element = CLineSegment(sBegin, sEnd)
            element@CLine('points', sBegin, sEnd);            
            element.Ends = [sBegin; sEnd];
        end
        
        function Plot(element)
            x = [element.Ends(1).X; element.Ends(2).X];
            y = [element.Ends(1).Y; element.Ends(2).Y];
            plot(x,y, 'b-');
        end
        
        function result = distanceFromPoint(element, point)
            result = element.distanceFromPoint@CLine(point);
            
            % Source: http://forums.codeguru.com/printthread.php?t=194400
            Ax = element.Ends(1).X;
            Ay = element.Ends(1).Y;
            Bx = element.Ends(2).X;
            By = element.Ends(2).Y;
            Cx = point.X;
            Cy = point.Y;
            
            L = sqrt( (Bx-Ax)^2 + (By-Ay)^2 );
            r = ((Cx-Ax)*(Bx-Ax) + (Cy-Ay)*(By-Ay)) / L^2;
            if r < 0
                result = sqrt((Cx-Ax)^2 + (Cy-Ay)^2);
            end
            
            if r > 1
                result = sqrt((Cx-Bx)^2 + (Cy-By)^2);
            end
            
        end
    end
    
end

