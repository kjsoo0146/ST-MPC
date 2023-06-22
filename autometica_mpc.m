function [TM, u, t] = autometica_mpc(TM, Nl, x)

    coder.extrinsic("optimconstr", "optimproblem", "optimvar");
%==========================================================================
 %parameter setting
    param = load("param.mat");
    param = param.param;

    param.N = Nl;
%==========================================================================
    %implement autometica vesion
    prob = optimproblem;
    x0 = optimvar('x0', param.nx);
    x = optimvar('x', param.nx, param.N);
    u0 = optimvar('x', param.nu);
    u = optimvar('u',param.nu, (param.N)-1);
    
    cost_function =x0'*param.Q*x0+u0*param.R*u0;
    for i=1:param.N-1
        cost_function = cost_function + x(:,i)'*param.Q*x(:,i)  + u(:,i)'*param.Q*u(:,i); % terminal cost 설정해야 됨
    end
    prob.Objective = cost_function;
    
%==========================================================================
% model constraints

    model_constr = optimconstr((param.N)+1);
    model_constr(1) = x(:,1) == param.A*x0 + param.B*u0;
    for i=1:param.N-1
        model_constr(i+1) = x(:,i+1) == param.A*x(:,i) + param.B*u(:,i);
    end
    model_constr((param.N)+1) = x0 == x;
    prob.Constraints.model_constr = model_constr;
    
%==========================================================================
%terminal set constraints
    constT = optimconstr(30,Tset+1);
       
    LL = param.tildeF - param.tildeG*param.tildeK;
    PHI = (param.tildeA - param.tildeB*param.tildeK);
    PSI = []
    for i= 1:Tset
        constT(:,i) = LL*(param.phi^(i))*x(:,M+Nl)<=[1; 1;1; 1;1; 1;];
    end
    constT(1:param.NumOfConstr,Tset+1) = (param.F-param.G*param.K)*x(:,M+Nl)<=1;
    prob.Constraints.ConstT = constT;
%==========================================================================
% triggering constraints
    SizeOfTM = size(TM);
    tm = TM(2:SizeOfTM(2));
    tmcomp = find(tm);
    SizeOfTmcomp = size(tmcomp);
    triggering_constr = optimconstr(param.N);
    triggering_constr(1) = u0 == u(:,1);
    for i = 1:param.N-2
        triggering_constr(i+1) = u(:,i)==u(:,i+1); %% i+1에서 triggering하면 u(:,i)~=u(:,i+1)
    end
    for i = 1:SizeOfTmcomp %% required triggering time moment setting
        if tmcomp(i)==1
            triggering_constr(tmcopm(i)) = u0 ~= u(:,1);
        else
            triggering_constr(tmcomp(i)) =  u(:,tmcomp(i)-1) ~= u(:,tmcomp(i));
        end
    end
    nontmcomp = find(~tm);
%==========================================================================
% implementing QP
end
    