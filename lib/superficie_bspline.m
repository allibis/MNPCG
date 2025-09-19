function S = superficie_bspline( P, tu, tv, u, v )

[n1,n2,d] = size(P);
m = length(tu);
k = m-n1-1;
if nargin==3
    u = linspace(tu(k+1),tu(n1+1),51)';
else
    if u(1)<tu(k+1) || u(end)>tu(n1+1)
        error('ho scelto valori fuori dell''intervallo di definizione')
    end
end
m = length(tv);
k = m-n2-1;
if nargin==4
    v = linspace(tv(k+1),tv(n2+1),51)';
else
    if v(1)<tv(k+1) || v(end)>tv(n2+1)
        error('ho scelto valori fuori dell''intervallo di definizione')
    end
end


m1 = length(u);
m2 = length(v);

S = zeros(m1,m2,d);
for i = 1:m1
    uu = u(i);
    Pu = zeros(n2,d);
    for j = 1:n2
        Pu(j,:) = de_boor(reshape(P(:,j,:),n1,d),tu,uu);
    end
    S(i,:,:) = de_boor(Pu,tv,v);
end
