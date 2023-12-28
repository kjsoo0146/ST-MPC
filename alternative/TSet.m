function y = TSet(param)
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

    Amat = @(i) (tildeF-tildeG*tildeK)*(tildeA-tildeB*tildeK)^(i)*phi;
    P =@(i) Polyhedron('A', Amat(i), 'b', ones(size(tildeF,1), 1));
    Tset = P(0);
    i = 0
    while(1)
        i = i+1
        Ptemp = P(i+1)
        if Ptemp.contains(Tset) == 1
            break;
        else
            Tset = and(Tset, Ptemp);
        end
    end
    y = i;
end