classdef CDataBase < handle
    %CDATABASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SonarPoints = [];
        DynamicPoints = [];
        PositionPoints = [];
    end
    
    methods
        
        function AddSonarPoint(element, point, delta)
            pts = struct(sSonarData);
            pts.Measurements = point;
            pts.Delta = delta;
            element.SonarPoints = [element.SonarPoints; pts];
        end
        
        function AddPositionPoint(element, point)
            element.PositionPoints = [element.PositionPoints; point];
        end
        
        function AddDynamicsPoint(element, point)
            element.DynamicPoints = [element.DynamicPoints; point];
        end
    end
    
end

