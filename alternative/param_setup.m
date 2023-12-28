function param = param_setup()

    origin_A = [1.2 3;0 2 ];
    param. origin_A = origin_A;
    delta = eye(2)*0.001
    A = origin_A + delta ;
    B = [0.05; 0.1];
    nx = size(A,1);
    nu = size(B,2);
    C = [-1 1];
    param.Tsim = 30;
    param.x0 = [1.25; 0.1];
    param.origin_A = origin_A;
    param.A = A;
    param.delta= delta;
    param.B = B;
    param.C = C;
    param.nx = nx;
    param.nu = nu;
    param.Q = C'*C;
    param.R = 1
    M = 4;
    
    param.N = 4;
    param.M = M;

    param.xmax = 8;
    param.xmin = -8;
    param.umax = 2;
    param.umin = -2;

    param.F = [eye(nx)*1/param.xmax;eye(nx)*1/param.xmin;zeros(nu*2,nx)];
    param.G = [zeros(nx*2,nu); eye(nu)*1/param.umax; eye(nu)*1/param.umin];

    param.NumOfConstr=size(param.F,1);

    param.nc = size(param.F,1);

    [P,K,L] = idare(param.A, param.B, param.Q, param.R);
    param.P = P;
    param.K = K;

    % stack_sys = ss(tildeA, tildeB, tildeC, zeros(size(tildeA,1), size(tildeB,2)),5);
    % [G1 G2] = stabsep(stack_sys);
    % eig(G1.A)
    % size(ctrb(G2.A, G2.B))
    % rank(ctrb(G2.A, G2.B))

    AT = [A zeros(nx, nu); zeros(nu,nx) zeros(nu, nu)];
    ANT = [A B; zeros(nu, nx) eye(nu)];
    BT = [B;eye(nu)];

    tildeA =[];
    tildeB =[];
    tildeC =[];
    for i = 1:M
        tildeA = [tildeA; [zeros((nx + nu),(nx + nu)*(M-1)) ANT^(i-1)*AT]];
        tildeB = [tildeB; ANT^(i-1)*BT];
    end
    param.tildeA = tildeA;
    param.tildeB = tildeB;

    tildeF = [];
    tildeG = [];
    param.FNT = [param.F param.G];
    param.FT = [param.F zeros(param.nc, param.nu)];
    for i = 1:param.M-1
        tildeF = blkdiag(tildeF, param.FNT);
        tildeG = [tildeG; zeros(param.nc,1)];
    end
    tildeF = blkdiag(tildeF,param.FT);
    tildeG = [tildeG;param.G];

    param.tildeF = tildeF;
    param.tildeG = tildeG;

    QNT = [param.Q,zeros(param.nx, param.nu); zeros(param.nu, param.nx) param.R];
    QT = [param.Q,zeros(param.nx, param.nu); zeros(param.nu, param.nx) zeros(param.nu, param.nu)];
    
    param.QNT = QNT;
    param.QT = QT;

    tildeQ = [];
    for i = 1:param.M-1
        tildeQ = blkdiag(tildeQ,QNT);
    end
    tildeQ = blkdiag(tildeQ,QT);
    param.tildeQ = tildeQ;
    [tildeP, tildeK, L] = idare(param.tildeA, param.tildeB, param.tildeQ, param.R);

    param.tildeP = tildeP;
    param.tildeK = tildeK;


    param.SizeOfTildeK = size(param.tildeK);
    param.Ka = param.tildeK(:,(param.M-1)*(param.nx+param.nu)+1:end);
    param.Kx = param.Ka(1,1:param.nx);

    A_BK = tildeA - tildeB*tildeK;
    param.A_BK = A_BK;
    param.SizeOfA_BK = size(A_BK)
    param.phi = A_BK(:,(param.M-1)*(param.nx+param.nu)+1:end); 
    param.nT = TSet(param);

end