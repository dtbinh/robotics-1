classdef CLine < handle
    %CLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Norm parameters
        r = 0.0;
        th = 0.0;
    end
    
    methods
        function element = CLine(varargin)
            if nargin > 2
                method = varargin{1};
            else
                method = 'default';
            end
            
            switch (method)
                case 'general'
                    A = varargin{2};
                    B = varargin{3};
                    C = varargin{4};
                    element.lineFromGeneralParamsXY(A, B, C);
                case 'angle'
                    m = varargin{2};
                    n = varargin{3};
                    element.lineFromAngularParamsXY(m, n);                    
                case 'polar'
                    r = varargin{2};
                    th = varargin{3};
                    element.lineFromPolarParamsXY(r, th);                    
                case 'points'
                    pt1 = varargin{2};
                    pt2 = varargin{3};
                    x = [pt1.X; pt2.X];
                    y = [pt1.Y; pt2.Y];
                    element.lineFromPointsXY(x, y);
                otherwise
                    % Do something
            end
        end
        
        function lineFromGeneralParamsXY(element, a, b, c)
            
        end
        
        function lineFromPolarParamsXY(element, r, th)
            element.th = th;
            element.r = r;
        end
        
        function lineFromAngularParamsXY(element, m, n)
            lSign = 1;
            if (n<0)
                lSign = -1;
            end
            cth = atan2(lSign/sqrt(m^2+1), -m * lSign/sqrt(m^2+1));
            cdist = abs(n)/sqrt(m^2+1);
            
            element.th = cth;
            element.r = cdist;
        end
        
        function lineFromPointsXY(element, x, y)
            numPts = length(x);
            
            [m, n] = myLeastSuares(numPts, x, y);
            element.lineFromAngularParamsXY(m, n);
        end

        function setNormXY(element, r, th)
            element.setNorm(element, r, th, 0.0);
        end
        
        function Plot(element)
            x = [];
            y = [];
            cth = element.th;
            cr = element.r;
            if (abs(sin(cth)) < sin(pi/4))
                y= -10:0.1:10;
                x = (cr-sin(cth)*y)/cos(cth);
            else
                x= -10:0.1:10;
                y = (cr-cos(cth)*x)/sin(cth);
            end
            plot(x, y, 'k-');
        end
        
        function result = distanceFromPoint(element, point)
            xp = point.X;
            yp = point.Y;
            cr = element.r;
            cth = element.th;
            x = [];
            y = [];
            if (abs(sin(cth)) < sin(pi/4))
                y= [-10,10];
                x = (cr-sin(cth)*y)/cos(cth);
            else
                x= [-10,10];
                y = (cr-cos(cth)*x)/sin(cth);
            end
            
            result = abs( (y(2)-y(1))*xp - (x(2)-x(1))*yp + x(2)*y(1) - y(2)*x(1) )/sqrt((y(2)-y(1))^2 + (x(2)-x(1))^2);
        end

    end
    
end

