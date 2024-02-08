function [u, t] = self_triggered_mpc_heemels(x0);
    x0
    param = param_setup();
    A = param.A;
    B = param.B;
    C = param.C;

    Q = param.Q;
    R = param.R;
    K = param.K;
    P = param.P;

    F = param.F;
    G = param.G;

    nx = param.nx;
    nu = param.nu;

    N = param.N;
    beta = param.beta;
    Mmax = param.M;
    
    state_upperbound = param.state_upperbound;
    state_lowerbound = param.state_lowerbound;
    input_upperbound = param.input_upperbound;
    input_lowerbound = param.input_lowerbound;

    Tset = 10;

    for jj = 0:Mmax-1
        M = Mmax - jj;
        prob = optimproblem;
        u=optimvar('u',[nu,M+N-1], 'UpperBound', input_upperbound, 'LowerBound',input_lowerbound);
        x=optimvar('x',[nx, M+N], 'UpperBound', state_upperbound, 'LowerBound',state_lowerbound);
        U0=optimvar('U0', 1,  'UpperBound', input_upperbound, 'LowerBound', input_lowerbound);
        
        %% cost function
        costpart1 = x0'*Q*x0 +U0'*R*U0;
        costpart2 = 0;
        for i = 1:M-1
            costpart1 = costpart1 + x(:,i)'*Q*x(:,i) + u(:,i)'*R*u(:,i);
        end
        for i = M:M+N-1
            costpart2 = costpart2 + beta*(x(:,i)'*Q*x(:,i) + u(:,i)'*R*u(:,i));
        end
        prob.Objective = costpart1 + costpart2 + beta*(x(:,M+N)'*P*x(:,M+N));
        
        %% constraint
        
        uconst = optimconstr(M-1);
        if M>1
            uconst(1) = u(1)==U0;
        end
        for i = 2:M-1
            uconst(i) = u(i) == u(i-1);
        end
        
        const = optimconstr(2,M);
        const(:,1) = x(:,1) == A*x0+ B*U0;
        for i = 2:M+N
            const(:,i) = x(:,i) == A*x(:,i-1)+ B*u(i-1);
        end
        
        constT = optimconstr(6,Tset+1);
       
        LL = F - G*K;
        PHI = (A - B*K);
        for i= 0:Tset
            constT(:,i+1) = LL*(PHI^(i))*x(:,M+N)<=[1; 1;1; 1;1; 1;];
        end
        
        prob.Constraints.uconst = uconst;
        prob.Constraints.const = const;
        prob.Constraints.constT = constT;
        
        [result, feval, exitflag, output, lambda] = solve(prob);
        temp = beta * cost_cal(x0);
        if exitflag == 1 && feval <= temp
            u = result.U0;
            t = M;
            break;
        else
            fprintf("%d에서 적절한 해가 없습니다\n",M)
            feval
            temp
        end
    end
    
end