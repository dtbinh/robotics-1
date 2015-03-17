d=0;
s=10;
w=0;

k=1;

%d = d+s;
%s = s+w;

x = [d;s]

A = [1,1;0,1];

B=0;

F=[0;1];

%x = A*x + F*w

V=1;

P = [2,0;0,3];

C = [1,0];

N = 2;

y(1)=0;
%y(2)=9;
%y(3)=19.5;
%y(4)=29;
for g=2:20
	y(g)=y(g-1)+10-rand(1)
end

xc=x

PC = P

pospr(0)=xz(1);pos(0)=xc(1);
spdpr(0)=xz(2);spd(0)=xc(2);


for k=1:19

	xz = A*xc+B*1

	PZ = A*PC*A'+F*V*F'


	PC = [(PZ^(-1)) + C'*(N^(-1))*C]^(-1)

	xc= xz+PC*C'*(N^(-1))*(y(k+1)-C*xz)
	pospr(k+1)=xz(1);pos(k+1)=xc(1);
	spdpr(k+1)=xz(2);spd(k+1)=xc(2);
end
k=1:20;
plot(k,pospr,k,pos,k,spdpr,k,spd,k,y);