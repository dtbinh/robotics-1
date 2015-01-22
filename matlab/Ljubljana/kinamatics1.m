alpha = 60;
beta = 45;
gama = 5;

l1 = 5;
l2 = 2;
l3 = 5;

alpha = alpha*pi/180;
beta = beta*pi/180;
gama = gama*pi/180;

aa = [ cos(alpha), -sin(alpha), 0, 0;
	sin(alpha), cos(alpha), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

bb = [1, 0, 0, l1; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

cc  = [ cos(beta), -sin(beta), 0, 0;
	sin(beta), cos(beta), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

dd =  [1, 0, 0, l2; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

ff  = [ cos(gama), -sin(gama), 0, 0;
	sin(gama), cos(gama), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

gg =  [1, 0, 0, l3; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

hom=aa*bb*cc*dd*ff*gg;

a=[0;0;0;1];
b=hom*a;
c=aa*bb*a;
d=aa*bb*cc*a;
ee=aa*bb*cc**dd*a;

newplot();
plot([0 l1*cos(alpha)], [0 l1*sin(alpha)]);
hold on;
plot([0 l2*cos(alpha+beta)]+l1*cos(alpha), [0 l2*sin(alpha+beta)]+ l1*sin(alpha));
plot([0 l3*cos(alpha+beta+gama)]+l2*cos(alpha+beta)+l1*cos(alpha), [0 l3*sin(alpha+beta+gama)]+l2*sin(alpha+beta)+l1*sin(alpha));
plot(b(1), b(2), 'ro');
plot(c(1), c(2), 'ro');
plot(d(1), d(2), 'ro');
plot(ee(1), ee(2), 'ro');
axis([-5 15], [-5 15]);

grid on;
hold off;