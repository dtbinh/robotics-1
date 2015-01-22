xr=0;
yr=0;
fr=0;

vr=0.5;
wr=20*pi/180;

%d=20;
%d1=15;
%s=0.5;
%tita = 0;
%tita1 = 0;

w=0;

k=1;

%d = d+s;
%s = s+w;

x = [xr;yr;fr];

u=[vr;wr];

A = [1,0,0;0,1,0;0,0,1];

B=[cos(fr),0;sin(fr),0;0,1];

F=[1;1;1];

%x = A*x + F*w

V=2;

P = [2,0,0;0,2,0;0,0,2];

C = [1,0,0;0,1,0;0,0,1];

N = 2;

xr1(1)=0;
yr1(1)=0;
fr1(1)=0;
vr1(1) = vr;
wr1(1) = wr;
	
for g=2:20
	vr1(g) = vr+0.05*randn;
	wr1(g) = wr+0.05*randn;
	fr1(g) = fr1(g-1)+wr1(g-1)+0.05*randn;
	xr1(g)=xr1(g-1)+vr1(g-1)*cos(fr1(g-1))+0.05*randn;
	yr1(g)=yr1(g-1)+vr1(g-1)*sin(fr1(g-1))+0.05*randn;
endfor

xc=x

PC = P

pos(1)=xc(1);
pos2(1) = xc(2);
ang(1)=xc(3);


for k=1:19

	u = [vr1(k);wr1(k)];
	B=[cos(xc(3)),0;sin(xc(3)),0;0,1];
% prediction
	xz = A*xc+B*u
	PZ = A*PC*A'+F*V*F'

% correction
	PC = [(PZ^(-1)) + C'*(N^(-1))*C]^(-1)
	xc= xz+PC*C'*(N^(-1))*([xr1(k+1); yr1(k+1);fr1(k+1)]-C*xz)
	
	pospr(k)=xc(1);
	pos2pr(k)=xc(2);
	angpr(k)=xc(3);

	pos(k)=xr1(k+1);
	pos2(k)=yr1(k+1);
	ang(k)=fr1(k+1);
endfor
k=1:20;
plot(k,pos,'r*--',k,pos2,'g.--',k,ang,'b*--',k,pospr,'m*--',k,pos2pr,'k*--',k,angpr,'k*--');