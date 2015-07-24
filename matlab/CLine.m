classdef CLine < handle
    %CLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Norm to the line
        r = 0.0;
        th = 0.0;
        phi = 0.0;
        
        % Polynomial parameters
        a = 0.0;
        b = 0.0;
        c = 0.0;
    end
    
    methods
        function element = CLine()
        end
        
        function setNorm(element, r, th, phi)
            element.r = r;
            element.th = th;
            element.phi = phi;
        end

        function setNormXY(element, r, th)
            element.setNorm(element, r, th, 0.0);
        end
        
        function lineFromXY(element, x, y)
            numPts = length(x);
            
            [element.a, element.b] = myLeastSuares(numPts, x, y);
        end
        
        function Plot(element)
            x = -1000:1000;
            y = element.a * x + element.b;
            figure();
            plot(x, y, 'k-');
        end

    end
    
end

