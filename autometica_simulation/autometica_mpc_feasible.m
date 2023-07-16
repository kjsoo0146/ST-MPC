function exitflag_result = autometica_mpc_feasible(state)
%==========================================================================
%parameter setting
    param = load("param.mat");
    param = param.param;
    Nl = param.M;
%==========================================================================
%implement autometica vesion
    prob = optimproblem;
    x0 = optimvar('x0', param.nx);
    x = optimvar('x', param.nx, Nl);
    u0 = optimvar('u0', param.nu);
    u = optimvar('u',param.nu, Nl-1);
    cost_function =x0'*param.Q*x0+u0*param.R*u0; 
    terminal_weight = param.tildeP(13:14,13:14)
    for i=1:Nl-1
        cost_function = cost_function + x(:,i)'*param.Q*x(:,i) + u(:,i)'*param.R*u(:,i); % terminal cost 설정해야 됨
    end
    cost_function = cost_function + x(:,Nl)'*terminal_weight*x(:,Nl);
    prob.Objective = cost_function;
        
%==========================================================================
% model constraints
    
    model_constr = optimconstr(param.nx,(Nl)+1);
    model_constr(:,1) = x(:,1) == param.A*x0 + param.B*u0;
    for i=1:Nl-1
        model_constr(:,i+1) = x(:,i+1) == param.A*x(:,i) + param.B*u(:,i);
    end
    model_constr(:,(Nl)+1) = x0 == state;
    prob.Constraints.model_constr = model_constr;
        
%==========================================================================
%constraints on state and input
    constr_ineq = optimconstr(param.NumOfConstr, Nl);
    constr_ineq(:,Nl) = param.F*x0+param.G*u0<=1;
    for i=2:Nl-1
        constr_ineq(:,i)=param.F*x(:,i)+param.G*u(:,i)<=1;
    end
    prob.Constraints.constr_ineq=constr_ineq;
%==========================================================================
%terminal set constraints
    constT = optimconstr(30,param.autometica_Tset+1);
       
    LL = param.tildeF - param.tildeG*param.tildeK;
    for i= 1:param.autometica_Tset
        constT(:,i) = LL*(param.A_BK^(i))*param.phi(:,1:2)*x(:,Nl)<=ones(30,1);
    end
    constT(1:param.NumOfConstr,param.autometica_Tset+1) = (param.F-param.G*param.K)*x(:,Nl)<=1;
    prob.Constraints.ConstT = constT;
    [sol,fval,exitflag,output,lambda] = solve(prob);
    exitflag_result = exitflag;
end
    