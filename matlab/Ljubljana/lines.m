fp = fopen("calc1.txt", "r");
[a,cnt] = fscanf(fp, "%f\t%f\n",[2,Inf]);
fclose(fp);

x=1:5;
y = zeros(length(a(1,:)),length(x));

for k=1:length(a(1,:))
	y = a(2,k)*x + a(1,k);
	plot (x,y);
	hold on;
endfor
hold off