function S = superficie_rivoluzione( P1, w1, ti1, u, v )

if nargin==3
    u = linspace(0,1,51);
    v = u;
end
P1 = [P1(:,1) P1(:,1) P1(:,2)];
[P2,w2,ti2] = circonf_inscritta( 1, 4 );
P2(:,3) = ones(9,1);
P(:,:,1) = P1(:,1)*P2(:,1)';
P(:,:,2) = P1(:,2)*P2(:,2)';
P(:,:,3) = P1(:,3)*P2(:,3)';
w = w1(:)*w2;
S = superficie_nurbs(P,w,ti1,ti2,u,v);

% figure(2), plot3(P(:,:,1),P(:,:,2),P(:,:,3),':o')
% hold on
% surf(S(:,:,1),S(:,:,2),S(:,:,3))
