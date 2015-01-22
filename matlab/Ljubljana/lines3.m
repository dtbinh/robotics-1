newplot();
fp = fopen("lines121211.txt", "r");
[a,cnt] = fscanf(fp, "%f\t%f\t%f\t%f\t%f\t%f\n",[6,Inf]);
fclose(fp);

fp = fopen("map121211.txt", "r");
[b,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("map1_121211.txt", "r");
[l,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("points121211.txt", "r");
[d,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("scan_err121211.txt", "r");
[f,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("trajectory121211.txt", "r");
[g,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

fp = fopen("calc1_121211.txt", "r");
[h,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

plot(b(1,:),b(2,:),'g*');
hold on;
%plot(l(1,:),l(2,:),'b*');

%plot(d(1,:),d(2,:),'bo');
plot(f(1,:),f(2,:),'ro');
plot(g(1,:),g(2,:),'co');
plot(h(1,:),h(2,:),'mo');

%x=1:50;
%y = zeros(length(a(1,:)),length(x));
for k=1:length(a(1,:))
	x = [a(3,k), a(5,k)];
	y = [a(4,k), a(6,k)];
	plot(x,y, 'k');
endfor

hold off