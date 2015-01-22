ryaw = 30;
syaw = 50;

xr = 5;
yr = 6;
xs = 2;
ys = 1;

l3 = 1;

ryaw= ryaw*pi/180;
syaw = syaw*pi/180;

aa = [1 0 xr;0 1 yr; 0 0 1];

bb = [ cos(ryaw), -sin(ryaw), 0;
	sin(ryaw), cos(ryaw), 0;
	0, 0, 1];

cc =  [1, 0, xs; 0, 1, ys; 0, 0, 1];

dd = [ cos(syaw), -sin(syaw), 0;
	sin(syaw), cos(syaw), 0;
	0, 0, 1];

ee =  [1, 0, l3; 0, 1, 0; 0, 0, 1];

hom=dd*ee*cc*bb*aa;

a=[0;0;1];
b=hom*a;
c=ee*a;
d=ee*dd*cc*a;

newplot();
plot(0, 0, 'ro');
hold on;
plot(b(1), b(2), 'ro');
plot(c(1), c(2), 'ro');
plot(d(1), d(2), 'ro');
%plot(ee(1), ee(2), 'ro');
axis([-10 10 -10 10], "square");

grid on;
hold off;