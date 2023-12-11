function result = plotting_set(param)
    A = param.A_CMPC;
    B = param.B_CMPC;
    C = param.C_CMPC;
    Q = param.Q_CMPC;

    nx = param.nx;
    nu = param.nu;

    xmax = param.xmax;
    xmin = param.xmin;
    
    umax = param.umax;
    umin = param.umin;

    F = param.F_CMPC;
    G = param.G_CMPC;
    
    nc = param.nc;

    K = param.K_CMPC;

    xvert = [xmax xmax; xmax xmin; xmin xmax; xmin xmin];
    uvert = [umax; umin];

    x_set = Polyhedron(xvert);
    u_set = Polyhedron(uvert);

    i = 0;
    Amat = @(i) (F-G*K)*(A-B*K)^(i);
    Tset = Polyhedron(Amat(0), ones(nc,1));
    while(1)
        Tset_temp = Polyhedron(Amat(i+1), ones(nc,1));
        if Tset_temp.contains(Tset)==1
            break
        end
        Tset = and(Tset, Tset_temp);
        i = i+1
    end
    result = i;

    N = param.N;

    Fset = Tset;
    for i = 1:N
        Fset = inv(A)*Fset + B*(-1*u_set);
        Fset = and(Fset, x_set);
    end

end