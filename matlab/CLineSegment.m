classdef CLineSegment < CLine
    %CLINESEGMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Ends = [CPoint(); CPoint()];
    end
    
    methods
        function element = CLineSegment(sBegin, sEnd)
            element.Ends = [sBegin; sEnd];
            
        end
    end
    
end

