classdef CAlgorthms
    %CALGORTHMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        function m = GetTransformationMatrix(element, positionData)
            a = positionData.Alpha;
            b = positionData.Beta;
            g = positionData.Gamma;
            x = positionData.PosX;
            y = positionData.PosY;
            z = positionData.PosZ;
            
%             syms s(h) c(h);
%             s(h) = sin(h);
%             c(h) = cos(h);
%             
%             % Source http://planning.cs.uiuc.edu/node104.html
%             TM = [ c(a)*c(b),   c(a)*s(b)*s(g)-s(a)*c(g),   c(a)*s(b)*c(g)+s(a)*s(g),   x; ...
%                    s(a)*c(b),   s(a)*s(b)*s(g)+c(a)*c(g),   s(a)*s(b)*c(g)-c(a)*s(g),   y; ...
%                    -s(b),       c(b)*s(g),                  c(b)*c(g),                  z; ...
%                    0,           0,                          0,                          1 ];
%                
%             m = double(TM);

            m = [  cos(g)*cos(b),   cos(g)*sin(b)*sin(a)-sin(g)*cos(a),     cos(g)*sin(b)*cos(a)+sin(g)*sin(a), x; ...
                   sin(g)*cos(b),   sin(g)*sin(b)*sin(a)+cos(g)*cos(a),     sin(g)*sin(b)*cos(a)-cos(g)*sin(a), y; ...
                   -sin(b),         cos(b)*sin(a),                          cos(b)*cos(a),                      z; ...
                   0,               0,                                      0,                                  1 ];
        end
    end
    
end

