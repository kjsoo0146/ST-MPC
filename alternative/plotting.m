
param = param_setup;

F = param.F;
G = param.G;
A = param.A;
B = param.B;
Kx = param.Kx;
M = param.M;
tildeA = param.tildeA;
tildeB = param.tildeB;
tildeK = param.tildeK;

tildeF = param.tildeF;
tildeG = param.tildeG;

tildeK = param.tildeK;

xmax =param.xmax;
xmin =param.xmin;
umax =param.umax;
umin =param.umin;

Phi = param.phi
phi = Phi(:,1:2)

Vx = [xmax xmax; xmax xmin; xmin xmax; xmin xmin];
xset = Polyhedron(Vx);

Vu = [umax; umin];
uset = Polyhedron(Vu);

F = param.F;
G = param.G;
A = param.A;
B = param.B;
K = param.K;

%% Terminal set 
Amat = @(i) (tildeF-tildeG*tildeK)*(tildeA-tildeB*tildeK)^(i)*phi;
P =@(i) Polyhedron('A', Amat(i), 'b', ones(size(tildeF,1), 1));
Tset = P(0);
i = 0
while(1)
    i = i+1
    Ptemp = P(i)
    if Ptemp.contains(Tset) == 1
        break;
    else
        Tset = and(Tset, Ptemp);
    end
end
PP = Polyhedron('A', F-G*Kx, 'b', ones(size(F,1),1))
Tset = and(Tset, PP);


%% Feasible set
Fset = Tset;
Vx = [xmax xmax; xmin xmax; xmax xmin; xmin xmin];
Vu = [umax; umin];
xset = Polyhedron(Vx);
uset = Polyhedron(Vu);
for i = 1:M
    Fset = inv(A)*(Fset + B*(-1*uset));
    Fset = and(Fset, xset);
end
figure(1)
hold on
Tset.plot('show_set', true, 'color', 'lightyellow', 'linewidth', 4, 'linestyle', '--')