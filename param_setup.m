function param = param_setup()
%==========================================================================
%Heemels version
    param.Tsim = 20;

    param.A = [1.1 2; 0 0.95];
    param.B = [0; 0.0787];
    param.C = [-1 1];
    param.x0 = [0.1; -0.1];
    param.N = 5;
    param.M = 5; % 트리거 인터벌의 최대값
    
    param.state_upperbound = 8;
    param.state_lowerbound = -8;
    param.input_upperbound = 1;
    param.input_lowerbound = -1;

    param.NumOfConstr = 6;
    param.F = [1/param.state_upperbound 0; 0 1/param.state_upperbound; 1/param.state_lowerbound 0; 0 1/param.state_lowerbound; 0 0; 0 0];
    param.G = [0;0;0;0; 1/param.input_upperbound; 1/param.input_lowerbound];

    param.nx = 2;
    param.nu = 1;

    temp = size(param.F);
    param.nc = temp(1);
    
    param.Q = param.C'* param.C;
    param.R = eye(param.nu);
    
    [P,K,L] = idare(param.A, param.B, param.Q, param.R);
    param.P = P;
    param.K = K;
    param.Tset = 4;
    param.beta = 1.1;
%==========================================================================
%autometica version
    z = zeros(param.nx + param.nu,param.nx + param.nu);
    AT = [param.A zeros(param.nx,param.nu); zeros(param.nu,param.nx) zeros(param.nu,param.nu)];
    ANT = [param.A param.B; zeros(param.nu, param.nx) eye(param.nu)];
    BT = [param.B;eye(param.nu)];

    tildeA = [];
    tildeB = [];
    for i = 1:param.M
        tildeA = [tildeA; [zeros((param.nx + param.nu),(param.nx + param.nu)*(param.M-1)) ANT^(i-1)*AT]];
        tildeB = [tildeB; ANT^(i-1)*BT];
    end
    param.tildeA = tildeA;
    param.tildeB = tildeB;

    tildeF = [];
    tildeG = [];
    param.FNT = [param.F param.G];
    param.FT = [param.F zeros(param.NumOfConstr, param.nu)];
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

    tildeQ = [];
    for i = 1:param.M-1
        tildeQ = blkdiag(tildeQ,QNT);
    end
    tildeQ = blkdiag(tildeQ,QT);
    param.tildeQ = tildeQ;
    % [QNT z z; z QNT z ; z z QT];

    [tildeP, tildeK, L] = idare(param.tildeA, param.tildeB, param.tildeQ, param.R);

    param.tildeP = tildeP;
    param.tildeK = tildeK;


    param.SizeOfTildeK = size(param.tildeK);
    param.Ka = param.tildeK(1,(param.M-1)*(param.nx+param.nu)+1:param.SizeOfTildeK(2));
    param.Kx = param.Ka(1,1:param.nx);

    A_BK = tildeA - tildeB*tildeK;
    param.A_BK = A_BK;
    param.SizeOfA_BK = size(A_BK)
    param.phi = A_BK(:,(param.M-1)*(param.nx+param.nu)+1:param.SizeOfA_BK(2)); 

end