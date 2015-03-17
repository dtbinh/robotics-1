classdef CDataBase < handle
    %CDATABASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SonarPoints = [];
        DynamicPoints = [];
        PositionPoints = [];
        Delta = [];
        
        LastCallTime = [];
        
        OfflineMode = 0;
        StepNumber = 1;
    end
    
    methods
        function element = CDataBase(offlineMode)
            element.OfflineMode = offlineMode;
            if (element.OfflineMode)
                tmp = load('OfflineData.mat');
                element = tmp.element;
                element.OfflineMode = true;
            end
            element.LastCallTime = tic;
        end
        
        function AddStep(element)
            [dt, element.LastCallTime] = getDeltaTime(element.LastCallTime);
            element.Delta = [element.Delta; dt];
        end
        
        function AddSonarPoint(element, point)
            point.Delta = length(element.Delta);
            element.SonarPoints = [element.SonarPoints; point];
        end
        
        function point = GetSonarPoint(element)
            point = element.SonarPoints(element.StepNumber).Measurements;
        end
        
        function point = GetSonarPointAsArray(element)
            totalSteps = length(element.Delta);
            point = zeros(totalSteps, 16);
            for kk = 1:totalSteps
                tmp = element.SonarPoints(kk).Measurements;
                for pp = 1:16
                    if (tmp(pp) == 99)
                        tmp(pp) = NaN;
                    end
                end
                point(kk,:) = tmp;
            end
            
        end

        
        function AddPositionPoint(element, point)
            point.Delta = length(element.Delta);
            element.PositionPoints = [element.PositionPoints; point];
        end
        
        function point = GetPositionPoint(element)
            point = element.PositionPoints(element.StepNumber);
        end
        
        function AddDynamicsPoint(element, point)
            point.Delta = length(element.Delta);
            element.DynamicPoints = [element.DynamicPoints; point];
        end

        function point = GetDynamicsPoint(element)
            point = element.DynamicPoints(element.StepNumber);
        end
        
        function result = GetDelta(element)
            result = element.Delta(element.StepNumber);
        end
        
        function result = IncrementStep(element)
            result = false;
            stp = element.StepNumber;
            if (stp < length(element.Delta))
                element.StepNumber = stp + 1;
                result = true;
            end
        end

        function delete(element)
            if (~element.OfflineMode)
                save('data.mat', 'element');
            end
        end
    end
    
end

