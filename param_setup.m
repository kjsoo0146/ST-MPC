function param = param_setup()
    
    param.Tsim = 100;

    param.A = [1.1 2; 0 0.95];
    param.B = [0; 0.0787];
    param.C = [-1 1];
    param.x0 = [6; -0.5];
    param.N = 10;
    param.M = 5; % 트리거 인터벌의 최대값
    
    param.state_upperbound = 8;
    param.state_lowerbound = -8;
    param.input_upperbound = 1;
    param.input_lowerbound = -1;

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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    param.beta = 1.1;
end