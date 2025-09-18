function S = superficie_nurbs( P, w, tu, tv, u, v )

[n1,n2,d] = size(P);
m = length(tu);
k = m-n1-1;
if nargin==4
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

Pw(:,:,d+1) = w;
Pw(:,:,1:d) = w.*P;
Sw = superficie_bspline(Pw,tu,tv,u,v);
S = Sw(:,:,1:end-1)./Sw(:,:,end);

