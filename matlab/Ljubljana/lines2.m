newplot();
fp = fopen("lines.txt", "r");
[a,cnt] = fscanf(fp, "%f\t%f\t%f\t%f\t%f\t%f\n",[6,Inf]);
fclose(fp);

fp = fopen("map.txt", "r");
[b,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("points.txt", "r");
[d,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("scan_err.txt", "r");
[f,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

plot(b(1,:),b(2,:),'g*');
hold on;
%plot(d(1,:),d(2,:),'ro');
plot(f(1,:),f(2,:),'ro');

%y = zeros(length(a(1,:)),length(x));
for k=1:length(a(1,:))
	x=-10:0.1:10;
	if (abs(sin(a(1,k)))< sin(pi/4))
		y=-10:0.1:10;
		%y = x;%a(2,k) + 0*x;
		x = (a(2,k)-sin(a(1,k))*x)/cos(a(1,k));
	else
		x=-10:0.1:10;
		y = (a(2,k)-cos(a(1,k))*x)/sin(a(1,k));
	endif
	if and((y<20), (y>-20))
		plot (x,y);
	endif
	
	
endfor

hold off