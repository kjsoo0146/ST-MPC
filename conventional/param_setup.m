function param = param_setup()
    param.A_CMPC = [1.2 3;0 2 ];
    param.B_CMPC = [0.05; 0.1];
    param.C_CMPC = [-1 1];
    param.Q_CMPC = param.C_CMPC'*param.C_CMPC;
    param.nx = size(param.A_CMPC, 1);
    param.nu = size(param.B_CMPC, 2);
    param.R_CMPC = eye(param.nu);
    [param.P_CMPC, param.K_CMPC, L] = idare(param.A_CMPC, param.B_CMPC, param.Q_CMPC, param.R_CMPC); 
    xmax = 8; 
    param.xmax = xmax;
    xmin = -8;
    param.xmin = xmin;
    umax = 2;
    param.umax = umax;
    umin = -2;
    param.umin = umin;
    param.F_CMPC = [1/xmax 0; 0 1/xmax; 1/xmin 0; 0 1/xmin; 0 0; 0 0];
    param.G_CMPC = [0;0;0;0;1/umax;1/umin];
    param.nc = size(param.F_CMPC,1);
    param.Tsim = 30;
    param.N = 5;
    param.mu_CMPC = plotting_set(param);
    param.init = [0.55; 0.15];


end