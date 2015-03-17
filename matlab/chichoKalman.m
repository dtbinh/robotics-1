A = 1;
H = 1;
B = 0;
Q = 0.0001;
R = 0.1;
xhat = 3;
P = 0.2;

u = 0;
x = xhat;


filtered = [];

for kk = 1:length(data(:, 1))
    xm = data(kk, 1);
    
    % Predict
    xp = A*x + B*u;
    Pp = A*P*A' + Q;

    % Observe
    innov = xm - H*xp;
    filtered = [filtered; innov];
    innovP = H*Pp*H' + R;

    % Update

    K = Pp*H*innovP;
    x = xp + K * innov;
    P = (1 - K*H)*Pp;

end


vx = 0.01;
vy = 0;

v = 0.01;
d = 100;
WallX = 100;
RoboX = 0;
dt = 1;

figure();
hold on;
plot([WallX, WallX], [-1, 1]);
for kk = 1:1000
    d = d - v*dt;
    RoboX = RoboX + v*dt;
    dmeas = WallX - RoboX;
    plot(RoboX, 0, 'g^');
end



