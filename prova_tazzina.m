N = 50; % N = numero di punti (es. 200)
a = 0.1; % a = ampiezza delle ondulazioni

theta = linspace(0, 2*pi, N+1)';  % angolo [0,2pi]                  % rimuovo duplicato finale
NP = 20;
A = linspace(0,pi/2,NP);


z = sin(A);
y = zeros(size(z,2),1);
x = 0.5./(1-linspace(0,.5,NP));

plot3(x,y,z, 'r-o')
axis equal
xlabel('x'); ylabel('y'); zlabel('z');

% creo il vettore S per rimuovere i warning
S_tazzina = zeros(size(theta,1), NP, 3);
for j=1:NP
    R = x(j);

    % descrivo la curva desiderata attraverso i parametri r, theta
    r = R * (1 + a*cos(6*theta));    
    
    % applico un cambiamento di coordinate da polari a cartesiane
    x_p = r .* cos(theta);
    y_p = r .* sin(theta);
    z_p = ones(size(x_p))*z(j);
    
    hold on
    plot3(x_p, y_p, z_p);
    S_tazzina(:,j,1) = x_p;   % coordinate x
    S_tazzina(:,j,2) = y_p;   % coordinate y
    S_tazzina(:,j,3) = z_p;   % coordinate z
end

