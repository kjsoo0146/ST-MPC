function u = cmpc(state, param)
    %coder.extrinsic('optimproblem','optimvar','optimconstr', 'solve', 'ss', 'd2c', 'c2d', 'foo');
    %% Recall the parameters
    nx = param.nx;
    nu = param.nu;
    nc = param.nc;
    N = param.N;
    
    A = param.A_CMPC;
    B = param.B_CMPC;
    Q = param.Q_CMPC;
    R = param.R_CMPC;
    P = param.P_CMPC;
    F = param.F_CMPC;
    G = param.G_CMPC;
    K = param.K_CMPC;   
    mu = param.mu_CMPC;
        
    %% optimal problem setting
    prob = optimproblem;
    x = optimvar('x',nx,N);
    u = optimvar('u',nu,N-1);
    x0 = optimvar('x0',nx,1);
    u0 = optimvar('u0',nu,1);
    %% CostFunction
    CostFunc = x0'*Q*x0 + u0*R*u0;
    for i = 1:N-1
        CostFunc = CostFunc + x(:,i)'*Q*x(:,i) + u(:,i)'*R*u(:,i);
    end
    CostFunc = CostFunc + x(:,N)'*P*x(:,N);
    prob.Objective = CostFunc;
    %% Model Constraints
    model_constr = optimconstr(nx,N+1);
    for i = nx:N 
        model_constr(:,i) = x(:,i)== A*x(:,i-1) + B*u(:,i-1);
    end
    model_constr(:,1) = x(:,1) == A*x0+ B*u0;
    model_constr(:,N+1) = x0 == state;
    prob.Constraints.model_constr = model_constr;
    %% constraints on state and input  
    constr = optimconstr(nc,N);
    for i = 1:N-1
        constr(:,i) = F*x(:,i)+G*u(:,i) <= ones(nc,1);
    end
    constr(:,N) = F*x0 + G*u0 <= ones(nc,1);
    prob.Constraints.constr = constr;
    
    %% terminal constraints
    constrT = optimconstr(nc,mu);
    for i = 1:mu
        constrT(:,i) = (F - G*K)*((A-B*K)^(i-1))*x(:,N)<= ones(nc,1);
    end
    prob.Constraints.constrT=constrT;
    %%
    fprintf('Conventional MPC is running... \n')
    [sol,fval,exitflag,output,lambda] = solve(prob);
    u = sol.u0;
end
