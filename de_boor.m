function C = de_boor( P, ti, t )

[n,d] = size(P);
m = length(ti);   % m = n+k+1
k = m-n-1;
if nargin==2
    t = linspace(ti(k+1),ti(n+1),501)';
else
    t = t(:);
    if t(1)<ti(k+1) || t(end)>ti(n+1)
        error('ho scelto valori fuori dell''intervallo di definizione')
    end
end
m = length(t);

C = zeros(m,d);
for i = 1:m
    j = find(t(i)>=ti(1:end-1) & t(i)<ti(2:end));
    if t(i)==ti(n+1)
        j = find(t(i)>=ti(1:end-1) & t(i)<=ti(2:end),1,'first');
    end
    P1 = P(j-k:j,:);
    for s = 0:k-1 %oppure 0:k-1
        a = (t(i)-ti(j-k+s+1:j))./(ti(j+1:j+k-s)-ti(j-k+s+1:j));
        P1 = diag(1-a)*P1(1:end-1,:)+diag(a)*P1(2:end,:);
    end
    C(i,:) = P1;
end
