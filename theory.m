x0=10;y0=10;
x1=20;y1=20;
x2=30;y2=30;
theta=[0:0.01:1*pi];
p0=sqrt(x0^2+y0^2)*sin(theta);
p1=sqrt(x1^2+y1^2)*sin(theta);
p2=sqrt(x2^2+y2^2)*sin(theta);
figure(1);
plot(theta,p0); 
hold on 
plot(theta,p1);
plot(theta,p2);
hold off
