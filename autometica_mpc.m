function [TM, u, t] = autometica_mpc(TM, x, Nl)

    coder.extrinsic("optimconstr", "optimproblem", "optimvar");
    %==========================================================================
    %parameter setting
    param = struct;

    param.Tsim = 20;

    param.A = [1.1 2; 0 0.95];
    param.B = [0; 0.0787];
    param.C = [-1 1];
    param.x0 = [6; -0.5];
    param.N = Nl;
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

    %==========================================================================
    %implement autometica vesion
    prob = optimproblem;
    x0 = optimvar('x0', param.nx);
    x = optimvar('x', param.nx,N);
    u0 = optimvar('x', param.nu);
    u = optimvar('u',param.nu, N-1);
    
    cost_function =x0'*param.Q*x0+u0*param.R*u0;
    for i=1:param.N-1
        cost_function = cost_function + x(:,i)'*param.Q*x(:,i)  + u(:,i)'*param.Q*u(:,i); % terminal cost 설정해야 됨
    end
    prob.Objective = cost_function;
    
    %==========================================================================
    % model constraints

    model_constr = optimconstr((param.N)+1)
    model_constr(1) = x(:,1) == param.A*x0 + param.B*u0;
    for i=1:param.N-1;
        model_constr(i+1) = x(:,i+1) == param.A*x(:,i) + param.B*u(:,i);
    end
    model_constr((param.N)+1) = x0 == x;
    y= 0;
    