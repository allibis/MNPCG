function C = de_boor_razionale( P, w, ti, t )

n = size(P,1);
m = length(ti);   % m = n+k+1
k = m-n-1;
if nargin==3
    t = linspace(ti(k+1),ti(n+1),501)';
else
    t = t(:);
    if t(1)<ti(k+1) || t(end)>ti(n+1)
        error('ho scelto valori fuori dell''intervallo di definizione')
    end
end

Pw = [diag(w)*P w(:)];
Cw = de_boor( Pw, ti, t );
C = Cw(:,1:end-1)./Cw(:,end);
