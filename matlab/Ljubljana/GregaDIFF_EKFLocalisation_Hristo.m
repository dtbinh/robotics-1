% Example of EKF localisation for PhD student Hristo
% Gregor Klancar, 15.12.2011

function GregaDIFF_EKFLocalisation_Hristo
close all; clear all;

nSteps = 1000;
dT = 0.1; %time steps size

% estimate standard deviation of the noise in the input velocities 
SigmaV = 0.2; % ?? estimate standard deviation of the noise (can be also fixed)
SigmaW = 0.2; % ?? estimate standard deviation of the noise
UTrue = diag([SigmaV^2 SigmaW^2]);  % estimated input variance for linear and angular speed

% estimate observation variances - variances for displacement which
% depends on linear and angular velocity
SigmadX  = 0.2;  % ???
SigmadY  = 0.2;  % ??? 
SigmadFI = 0.2;  % ???
RTrue = diag([SigmadX , SigmadY, SigmadFI]).^2;    %observation kovariance 


UEst = 1.0*UTrue;
REst = 1.0*RTrue;

xTrue = [0;0;0]; % true initial pose


%initial conditions:
xEst =xTrue;
PEst = diag([0.2, 0.2, (1*pi/180)]).^2;


% store initial values for plotting
    XTrueStore(:,1) = xTrue;
    XStore(:,1) = xEst;
    XErrStore(:,1) = xTrue-xEst;




for k = 2:nSteps
    
 % Simulation or real proces. Input to the odometry : linear and angular velocity 
 u=[.4; .2];  %v, w
 uNoise= u + sqrt(UTrue)*randn(2,1);  % adding noise to the input
 xTrue = xTrue+ dT*[ uNoise(1)*cos(xTrue(3)); ...
                     uNoise(1)*sin(xTrue(3)); ... 
                     uNoise(2)             ];
 xTrue(3) = AngleWrap(xTrue(3));


 % do prediction based on odometry
 xPred = xEst + dT*[ u(1)*cos(xEst(3)); ...
                     u(1)*sin(xEst(3)); ... 
                     u(2)             ];
 xPred(3) = AngleWrap(xPred(3));
 
 
 % calculate Jacobians for noise propagation
 % Fx=par(Xpred)/par(xEst)
 Fx=[1 0 -dT*u(1)*sin(xEst(3));
     0 1  dT*u(1)*cos(xEst(3));
     0 0  1 ];

 % Fv=par(Xpred)/par(u)
 Fv=[dT*cos(xEst(3))     0;
     dT*sin(xEst(3))     0;
     0                   1];
  
% estimate standard deviation of the noise in the input velocities 
SigmaV = 0.2; % ?? estimate standard deviation of the noise (can be also fixed)
SigmaW = 0.2; % ?? estimate standard deviation of the noise
UEst = diag([SigmaV^2 SigmaW^2]);  % estimated input variance for linear and angular speed
    
% calculate predicted state variance     
PPred = Fx* PEst *Fx' + Fv* UEst * Fv';
    
    
 
    
    %observe - get mesurments points from the sonars
    %[z] = GetObservation(...);
    
    % do observation of lines and calculate displacements for position and
    % angle:
    % dX, dY, dFI
    
    IsObservationValid=round(rand(1)); % if there is no observation then set it to 0, or to 1 if there is valid observation
    
    if(IsObservationValid)
        %predict observation
        % calculate points zPred where measured points should be (where line of the sonar intersect line from the map)
        %zPred = PredictObservation(...);
        
        % get observation Jacobian jH=parc(displacments)/parc(Xest)
        jH = [1 0 0; 0 1 0; 0 0 1];
        
        
        %%%%%%%%%do Kalman update:
        
        % calculate inovation
        %Innov = z-zPred;
        dX=0; dY=0; dFI=0;      % this are your avarage displacments     
        Innov = [dX; dY; dFI];
        % suppose we set it here to some values, close to true ones
        Innov = (xTrue-xEst)*(1-0.3*rand(1)); 
        Innov(3) = AngleWrap(Innov(3));
        
        % estimate observation variances - variances for displacement which
        % depends on linear and angular velocity
        SigmadX  = 0.2;  % ???
        SigmadY  = 0.2;  % ??? 
        SigmadFI = 0.2;  % ???
        REst = diag([SigmadX , SigmadY, SigmadFI]).^2;    %observation kovariance 

        S = jH*PPred*jH'+REst;
        W = PPred*jH'*inv(S);
        xEst = xPred+ W*Innov;
        xEst(3) = AngleWrap(xEst(3));

        PEst = PPred - W*S*W';                             
        PEst = 0.5*(PEst+PEst');  % not necessery, it just makes PEst diagonal symetric
        
                
    else
        %There was no observation available
        xEst = xPred;
        PEst = PPred;
        Innov = [NaN;NaN];
        S = NaN*eye(2);
    end;
            
   
    %store results:
    XTrueStore(:,k) = xTrue;
    XStore(:,k) = xEst;
    XErrStore(:,k) = xTrue-xEst;

    

end;


figure, plot(XStore(1,:),XStore(2,:), '--',XTrueStore(1,:),XTrueStore(2,:))
title('position: estimated --, true -')
    
figure, plot( 1:length(XStore),XStore(3,:),'--',1:length(XTrueStore),XTrueStore(3,:))
title('angle: estimated --, true -')
    





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = AngleWrap(a)

a=atan2(sin(a),cos(a));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    



