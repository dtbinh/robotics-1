classdef CPoint < handle
    %CPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X = 0.0;
        Y = 0.0;
        Z = 0.0;
    end
    
    methods
        function element = CPoint(varargin)
            if (nargin == 2)
                element.X = varargin{1};
                element.Y = varargin{2};
            elseif (nargin == 3)
                element.X = varargin{1};
                element.Y = varargin{2};
                element.Z = varargin{3};
            else
                element.X = 0.0;
                element.Y = 0.0;
                element.Z = 0.0;
            end
        end
        
        function Plot(element)
            plot(element.X, element.Y, 'r+')
        end
    end
    
end

