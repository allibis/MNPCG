% TEIERA
clc; clear; close all



%% becco con variazione di diametro
[P, w, ti] = circonf_inscritta( 4, 1 ); P(:,3)=1;
P(:,1) = P(:,1) + 1; P(:,2) = P(:,2) + 1; P = P(:,[3 2 1]);
C1=de_boor_razionale(P,w,ti);

t = linspace(0,1,7)';
x = 0.9*(1 + [0, 0.4, 1, 1.6, 2.2, 2.8, 3.4])'; % parte quasi stazionario, poi accelera avanti
y = ones(size(t));
z = [1.0; 1.05; 1.1; 1.5; 2.5; 3.0; 3.1]*0.65; % z con salita lenta, poi rapida, poi quasi piatta

Q1=[x, y, z];
w1 = ones(1,size(Q1,1));
k = 3;  % grado
n = size(Q1,1);  % numero di punti di controllo
ti1 = [zeros(1,k), linspace(0,1,n - k + 1), ones(1,k)];
Q=de_boor_razionale(Q1,w1,ti1);
wQ = ones(1,size(Q,1));
tiQ=[0 0 linspace(0,1,size(Q,1)) 1 1];

nQ = size(Q,1); nP=size(P,1);
r = linspace(1, 0.2, nQ);  % raggio decrescente
for j = 1:nQ
    [P,w,ti]=circonf_inscritta(r(j),4);
    P(:,3)=1; P = P(:,[3 2 1]);
    % Ruota il profilo attorno all'asse Y
    % angolo = -pi/2 * (j-1)/(nQ-1);  % da 0 a  90°
    if j > nQ   % ultimi 3 profili
        angolo = -pi/2;
    else
        angolo = 0;
    end
    Ry = [cos(angolo)  0 sin(angolo);
        0        1      0;
        -sin(angolo) 0 cos(angolo)];
    P = (Ry * P')'; P(:,1) = P(:,1) + 1; P(:,2) = P(:,2) + 1; % ruota il profilo già posizionato
    for i=3:-1:1
        H(:,j,i)=P(:,i)+Q(j,i);
    end
end
wH=w'*wQ;
S=superficie_nurbs(H,wH,ti,tiQ);
S(:,:,2)=S(:,:,2)-2; S(:,:,3)=S(:,:,3)+1.9; S(:,:,1)=S(:,:,1)-.9;
S=S*0.8;

% ottiene la posizione dell'ultimo profilo del becco, per poter
% riposizionare lo spessore alla fine del becco
lastPoint = squeeze(S(end,end,:))';


% plot3(Q(:,1), Q(:,2), Q(:,3), 'r.-');  % verifica la forma della curva
% hold on
% plot3(C1(:,1),C1(:,2),C1(:,3),'-b')
% hold on
% plot3(C(:,1),C(:,2),C(:,3),'-k')
% hold on

%% spessore fine becco
R = [.16 0; .1 0];   R = [R(:,1), zeros(size(R,1),1), R(:,2)];
w1 = [1 1];
ti1 = [0 0 1 1];
T = superficie_rivoluzione(R, w1, ti1);
angolo = pi/2;  % 90 gradi
Ry = [cos(angolo)  0 sin(angolo);
    0        1      0;
    -sin(angolo) 0 cos(angolo)];

% rotazione dello spessore lungo l'asse Y
[nRows,nCols,~] = size(T);
Tvec = reshape(T,[],3)';    % tutti i punti in 3 x N
Tvec = Ry * Tvec;           % applico la rotazione
T = reshape(Tvec',nRows,nCols,3);  % rimette nella forma originale
% sposta lo spessore alla fine del becco per simulare uno spessore interno
% al becco.
T(:,:,1)=T(:,:,1)+lastPoint(1); T(:,:,3)=T(:,:,3)+lastPoint(3);

%% corpo della teiera

P_corpo = [
    0.3141    0.2422;
    0.4063    0.3181;
    0.4785    0.4290;
    0.4677    0.6177;
    0.3863    0.8006;
    0.3049    0.9270;
    0.3280    0.9446;
    0.3449    0.9348;
    0.4278    0.8064;
    0.5184    0.6196;
    0.5246    0.4251;
    0.4201    0.2870;
    0.3587    0.2422;
    0.3587    0.2422;
    0.3587    0.2022
    0.0000    0.2422;];

w_corpo=ones(1,size(P_corpo,1));
ti_corpo=[0 0 linspace(0,1,size(P_corpo,1)-1) 1 1];
[Q_corpo,wQ_corpo,tiQ_corpo]=circonf_inscritta(1,4);

% scala la superficie con fattore 4
S_corpo=4*superficie_rivoluzione(P_corpo,w_corpo,ti_corpo);
% "nascondo" il bordo creato dalla generazione della superficie
S_corpo(:,:,2)=S_corpo(:,:,2)*-1;
% X=S_corpo(:,:,1); Y= S_corpo(:,:,2); Z=S_corpo(:,:,3);
% X(X>1.8)=NaN; Y(X>1.8)=NaN; Z(X>1.8)=NaN; %ottengo array colonna
% S_corpo=cat(3,X,Y,Z);

%% coperchio della teiera
% profilo del coperchio
P_cop = [0.0330    0.9543;
    0.1237    0.9543;
    0.1237    0.9543;
    0.1467    0.9193;
    0.1467    0.9193;
    0.0914    0.8648;
    0.0914    0.8648;
    0.0929    0.8247;
    0.0929    0.8247;
    0.3602    0.7422;
    0.4109    0.7072;
    0.3618    0.6372;
    0.0991    0.6955;
    0.0991    0.6955;
    0.0991    0.6955
    0.0330    0.9543];
w_cop=ones(1,size(P_cop,1));
ti_cop=[0 0 linspace(0,1,size(P_cop,1)-1) 1 1];
S_cop= 3.15*superficie_rivoluzione( P_cop, w_cop, ti_cop); S_cop(:,:,3)=S_cop(:,:,3)+1.55;


%% manico teiera
Q1_man=[9.6851, 1.0000, 9.4066;
    1.9892, 1.0000, 9.0953;
    0.7143, 1.0000, 6.2549;
    4.0937, 1.0000, 2.7140;
    9.6390, 1.0000, 0.6518];
w1_man = ones(1,size(Q1_man,1));
k = 3;  % grado
n_man = size(Q1_man,1);  % numero di punti di controllo
ti1_man = [zeros(1,k), linspace(0,1,n_man - k + 1), ones(1,k)];
Q_man=de_boor_razionale(Q1_man,w1_man,ti1_man); %Q=[Q(:,1), ones(size(Q,1),1) Q(:,2)];
wQ_man = ones(1,size(Q_man,1));
tiQ_man=[0 0 linspace(0,1,size(Q_man,1)) 1 1];

nQ_man = size(Q_man,1);
for j = 1:nQ_man
    [P_man,w_man,ti_man]=circonf_inscritta(1,4);
    P_man(:,3)=1; P_man = P_man(:,[3 2 1]);
    C2=de_boor_razionale(P_man,w_man,ti_man);
    C2(:,3)=C2(:,3)*0.6; C2(:,2)= C2(:,2)*1.3;
    w_man= ones(1,size(C2,1));
    ti_man=[0 0 linspace(0,1,size(C2,1)) 1 1];
    % Ruota il profilo attorno all'asse Y
    alpha = -pi * (j-1)/(nQ_man-1);  % da 0 a  90°
    Ry = [cos(alpha)  0 sin(alpha);
        0        1      0;
        -sin(alpha) 0 cos(alpha)];
    C2 = (Ry * C2')'; C2(:,1) = C2(:,1) + 1; C2(:,2) = C2(:,2) + 1; % ruota il profilo già posizionato
    for i=3:-1:1
        H_man(:,j,i)=C2(:,i)+Q_man(j,i)';
    end
end
wH_man=w_man'*wQ_man;
S_man=.2*superficie_nurbs(H_man,wH_man,ti_man,tiQ_man);
S_man(:,:,1)=S_man(:,:,1)-3.5; S_man(:,:,3)=S_man(:,:,3)+1.5; S_man(:,:,2)=S_man(:,:,2)-0.4;



%% Piatto Tazzina
P_piatto = [
    0    1.1521
    0.3920    1.2635
    0.5939    1.3200
    1.1092    1.4539
    1.1375    1.4197
    1.1092    1.3815
    0.5939    1.2476
    0.3208    1.1541
    0.2908    1.1156
    0.2607    1.0770
    0.2307    1.0385
    0.2007    1.0000
    0.1605    1.0000
    0.1204    1.0000
    0.0803    1.0000
    0.0401    1.0000
    0    1.0000
    ];


w_piatto = ones(1,size(P_piatto,1));
k = 3;
ti_piatto = [0 0 linspace(0, 1, size(P_piatto,1)-1) 1 1];
S_piatto = superficie_rivoluzione(P_piatto,w_piatto,ti_piatto);
S_piatto(:,:,1) = 3+S_piatto(:,:,1);
S_piatto(:,:,2) = S_piatto(:,:,2) - 3;


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

S_tazzina(:,:,1) = 3+S_tazzina(:,:,1);
S_tazzina(:,:,2) = S_tazzina(:,:,2) - 3;
S_tazzina(:,:,3) = S_tazzina(:,:,3) + 1.3;


%% visualizzazione
figure
hold on
% Colore porcellana
porcellana = [.95, .95, .95];

% Disegna le superfici con lo stesso stile
surf(S(:,:,1), S(:,:,2), S(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(S_corpo(:,:,1), S_corpo(:,:,2), S_corpo(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(S_cop(:,:,1), S_cop(:,:,2), S_cop(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(S_man(:,:,1), S_man(:,:,2), S_man(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(T(:,:,1), T(:,:,2), T(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(S_piatto(:,:,1), S_piatto(:,:,2), S_piatto(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);
surf(S_tazzina(:,:,1), S_tazzina(:,:,2), S_tazzina(:,:,3), ...
    'FaceColor', porcellana, 'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', 'SpecularStrength', 0.2);

% Luce diffusa
camlight('headlight')
lighting gouraud
% luce posizionata in alto con colori caldi
light('Position', [-10 -10 10], 'Style', 'local', 'Color',[1 1 0.8]*0.7);
% Materiale lucidi tipo porcellana
material shiny  %  effetto lucido
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z')
view(3)