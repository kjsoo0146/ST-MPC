function [nTM, u, t] = autometica_mpc(TM, Nl, x)

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
    for i= 1:Tset
        constT(:,i) = LL*(param.phi^(i))*x(:,M+Nl)<=[1; 1;1; 1;1; 1;];
    end
    constT(1:param.NumOfConstr,Tset+1) = (param.F-param.G*param.K)*x(:,M+Nl)<=1;
    prob.Constraints.ConstT = constT;
%==========================================================================
% triggering constraints
    SizeOfTM = size(TM);
    tm = TM(2:SizeOfTM(2));
    SizeOftm = size(tm)
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
    SizeOfnontmcomp = size(nontmcomp);
%==========================================================================
% implementing QP
%--------------------------------------------------------------------------
% +0
    original_tm = tm;
    for a= 0:SizeOfnontmcomp %% 트리거 횟수 추가
        for b = 0:a 
            fvalArr = [];
            solArr = [];
            tmarr = []
            ttime =a;
            % while(1)
            %      이전 스텝에서 받은 required trigger time moment sequence에서 trigger일때를 1 nontrigger 일때를 0으로 하여 벡터로 만들었다.
            %      이때 QP가 feasible 해질 때까지 trigger time을 추가하면서 QP를 풀어야 하는데, 즉 a =0,1,.... time sequence에서 a개의 nontrigger time을 뽑아 trigger time으로 변환해서 
            %      QP를 풀어함...
            % end
            
        end
    end
    % prob.Constraints.triggering_constr = triggering_constr;
    % [sol,fval,exitflag,output,lambda] = solve(prob);
    % if exitflag == 1
    %     u = sol;
    %     t = tmcomp(1);
    %     nTM = tm(tmcomp(1)+1:SizeOftm)
end
    

% fevalArr = [];
%             
%             for c = 0:SizeOfnontmcomp %% 트리거 어디다 놓을지
%                 plustime = a
%                 while(1)
%                     tm(nontmcomp(c)) = 1;
                    
%                 for i = 1:SizeOfTmcomp %% required triggering time moment setting
%                     if tmcomp(i)==1
%                         triggering_constr(tmcopm(i)) = u0 ~= u(:,1);
%                     else
%                         triggering_constr(tmcomp(i)) =  u(:,tmcomp(i)-1) ~= u(:,tmcomp(i));
%                     end
%                 end
%                 [sol, fval, exitflag, output, lambda] = solve(prob);
               
%                 fevalArr = [feasible exitflag];
%                 fvalArr = [fvalArr, fval];
%                 solArr = [solArr, sol];
%             end
%             feasible = find(fevalArr,1);
%             if isempty(feasible) == 0
%                [row col]= min(fvalArr);
%                utemp = solarr(col);
%                u = utemp.u0;
%                ttemp = 