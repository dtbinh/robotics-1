alpha = 60;
bet = -45;
gama = 20;

l1 = 5;
l2 = 2;
l3 = 1;

alpha = alpha*pi/180;
bet = bet*pi/180;
gama = gama*pi/180;

aa = [ cos(alpha), -sin(alpha), 0, 0;
	sin(alpha), cos(alpha), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

%bb = [1, 0, 0, l1; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

ab = [1 0 0 l1*cos(alpha);0 1 0 l1*sin(alpha);0 0 1 0; 0 0 0 1];

cc  = [ cos(bet), -sin(bet), 0, 0;
	sin(bet), cos(bet), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

dc =  [1, 0, 0, l2*cos(bet); 0, 1, 0, l2*sin(bet); 0, 0, 1, 0; 0, 0, 0, 1];

%dd =  [1, 0, 0, l2; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

ff  = [ cos(gama), -sin(gama), 0, 0;
	sin(gama), cos(gama), 0, 0;
	0, 0, 1, 0;
	0, 0, 0, 1];

gg =  [1, 0, 0, l3; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

hom=ab*aa*dc*cc*ff*gg;

a=[0;0;0;1];
b=hom*a;
c=ab*aa*a;
d=ab*aa*dc*a;
ee=ab*aa*dc*cc*a;

newplot();
plot([0 l1*cos(alpha)], [0 l1*sin(alpha)]);
hold on;
plot([0 l2*cos(alpha+bet)]+l1*cos(alpha), [0 l2*sin(alpha+bet)]+ l1*sin(alpha));
plot([0 l3*cos(alpha+bet+gama)]+l2*cos(alpha+bet)+l1*cos(alpha), [0 l3*sin(alpha+bet+gama)]+l2*sin(alpha+bet)+l1*sin(alpha));
plot(b(1), b(2), 'ro');
plot(c(1), c(2), 'ro');
plot(d(1), d(2), 'ro');
plot(ee(1), ee(2), 'ro');
axis([-5 15 -5 15], "square");

grid on;
hold off;