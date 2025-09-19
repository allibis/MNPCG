function [P,w,ti,C] = circonf_inscritta( r, n )
%r=1.2; n=4;
alpha=2*pi/n;
l=2*r*tan(alpha/2);
P=[0 -r; l/2 -r];
for i = 1:n-1
    P(i*2+1:(i+1)*2,:) = P(i*2-1:i*2,:)*[cos(alpha) sin(alpha); -sin(alpha) cos(alpha)];
end
P(n*2+1,:) = P(1,:);
w2 = cos(alpha/2);
w = ones(1,n*2+1);
w(2:2:end) = w2;
tt = linspace(0,1,n+1);
ti = [0 reshape([1; 1]*tt,1,2*n+2) 1];
C = de_boor_razionale(P,w,ti);
%plot(P(:,1),P(:,2),':o',C(:,1),C(:,2),'r')
%axis square