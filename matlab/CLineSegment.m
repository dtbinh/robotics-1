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
    end
    
end

