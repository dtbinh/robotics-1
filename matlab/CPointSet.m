classdef CPointSet < handle
    %CPOINTSET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Points = [];
        Pointer = 0;
    end
    
    methods
        function element = CPointSet(varargin)
            if (nargin == 1)
                element.Points = varargin{1};
            else
            end
        end
        
        function addPoint(element, point)
            element.Points = [element.Points; point];
        end
        
        function result = getPoint(element)
            result = [];
            if ~isempty(element.Points)
                result = element.Points(1);
                element.Points(1) = [];
            end
        end

        function result = peekPoint(element)
            result = [];
            if ~isempty(element.Points)
                if element.Pointer > length(element.Points)
                    element.Pointer = 1;
                else
                    element.Pointer = element.Pointer + 1;
                end
                result = element.Points(element.Pointer);
            end
        end

        function result = getRandomPoint(element)
            result = [];
            if ~isempty(element.Points)
                num = randi(length(element.Points));
                result = element.Points(num);
                element.Points(num) = [];
            end
        end
    end
    
end

