function cost = cost_cal(state)
    %coder.extrinsic('optimproblem','optimvar','optimconstr', 'solve', 'ss', 'd2c', 'c2d', 'foo');
    %% Recall the parameters
    param = param_setup();
    nx = param.nx;
    nu = param.nu;
    nc = param.nc;
    N = param.N;
    
    A = param.A;
    B = param.B;
    Q = param.Q;
    R = param.R;
    P = param.P;
    F = param.F;
    G = param.G;
    K = param.K;   
    mu = param.Tset;
        
    state_upperbound = param.state_upperbound;
    state_lowerbound = param.state_lowerbound;
    input_upperbound = param.input_upperbound;
    input_lowerbound = param.input_lowerbound;
    
    %% optimal problem setting
    prob = optimproblem;
    x = optimvar('x',nx,N, 'UpperBound', state_upperbound, 'LowerBound',state_lowerbound);
    u = optimvar('u',nu,N-1, 'UpperBound', input_upperbound, 'LowerBound',input_lowerbound);
    x0 = optimvar('x0',nx,1, 'UpperBound', state_upperbound, 'LowerBound',state_lowerbound);
    u0 = optimvar('u0',nu,1, 'UpperBound', input_upperbound, 'LowerBound',input_lowerbound);
    %% CostFunction
    CostFunc = x0'*Q*x0 + u0*R*u0;
    for i = 1:N-1
        CostFunc = CostFunc + x(:,i)'*Q*x(:,i) + u(:,i)'*R*u(:,i);
    end
    CostFunc = CostFunc + x(:,N)'*P*x(:,N);
    prob.Objective = CostFunc;
    %% Model Constraints
    model_constr = optimconstr(nx,N+1);
    for i = 2:N 
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
    if exitflag ==1
        cost = fval;
    else
        error("state is NOT in feasible set!!!")
end
