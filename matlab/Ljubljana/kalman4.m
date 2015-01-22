d=20;
d1=15;
s=0.5;
tita = 0;
tita1 = 0;

w=0;

k=1;

%d = d+s;
%s = s+w;

x = [d;d1;s]

A = [1,0,-cos(tita*pi/180);0,1,-cos(tita1*pi/180);0,0,1];

B=0;

F=[0;0;1];

%x = A*x + F*w

V=2;

P = [2,0,0;0,2,0;0,0,2];

C = [1,0,0;0,1,0];

N = 2;

y(1)=d+0.1*randn(1);
y1(1)=d1+0.1*randn(1);
%y(2)=9;
%y(3)=19.5;
%y(4)=29;
for g=2:20
	y(g)=y(g-1)-s*cos(tita*pi/180)+0.02*randn(1)
	y1(g)=y1(g-1)-s*cos(tita1*pi/180)+0.02*randn(1)
endfor

xc=x

PC = P

pos(1)=xc(1);
pos2(1) = xc(2);
spd(1)=xc(3);


for k=1:19

% prediction
	xz = A*xc+B*1
	PZ = A*PC*A'+F*V*F'

% correction
	PC = [(PZ^(-1)) + C'*(N^(-1))*C]^(-1)
	xc= xz+PC*C'*(N^(-1))*([y(k+1); y1(k+1)]-C*xz)
	
	pospr(k)=xz(1);
	spdpr(k)=xz(3);
	
	

	pos(k+1)=xc(1);
	pos2(k+1)=xc(2);
	spd(k+1)=xc(3);
endfor
k=1:20;
plot(k,pos,'r*--',k,pos2,'g.--',k,spdpr*50,'b*--',k,spd*50,'m*--',k,y,'k*--',k,y1,'k*--');