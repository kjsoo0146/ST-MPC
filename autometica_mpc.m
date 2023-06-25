function [nTM, u, t] = autometica_mpc(TM, Nl, state)

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
    u0 = optimvar('u0', param.nu);
    u = optimvar('u',param.nu, (param.N)-1);
    
    cost_function =x0'*param.Q*x0+u0*param.R*u0;
    for i=1:param.N-1
        cost_function = cost_function + x(:,i)'*param.Q*x(:,i) + u(:,i)'*param.R*u(:,i); % terminal cost 설정해야 됨
    end
    prob.Objective = cost_function;
    
%==========================================================================
% model constraints

    model_constr = optimconstr(param.nx,(param.N)+1);
    model_constr(:,1) = x(:,1) == param.A*x0 + param.B*u0;
    for i=1:param.N-1
        model_constr(:,i+1) = x(:,i+1) == param.A*x(:,i) + param.B*u(:,i);
    end
    model_constr(:,(param.N)+1) = x0 == state;
    prob.Constraints.model_constr = model_constr;
    
%==========================================================================
%terminal set constraints
    constT = optimconstr(30,Tset+1);
       
    LL = param.tildeF - param.tildeG*param.tildeK;
    %% d
    for i= 1:Tset
        constT(:,i) = LL*(param.phi)*x(:,M+Nl)<=[1; 1;1; 1;1; 1;];
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
    % triggering_constr = optimconstr(param.N);
    % triggering_constr(1) = u0 == u(:,1);
    % for i = 1:param.N-2
    %     triggering_constr(i+1) = u(:,i)==u(:,i+1); %% i+1에서 triggering하면 u(:,i)~=u(:,i+1)
    % end
    % for i = 1:SizeOfTmcomp %% required triggering time moment setting
    %     if tmcomp(i)==1
    %         triggering_constr(tmcopm(i)) = u0 ~= u(:,1);
    %     else
    %         triggering_constr(tmcomp(i)) =  u(:,tmcomp(i)-1) ~= u(:,tmcomp(i));
    %     end
    % end
    nontm = find(~tm); 
    SizeOfnontm = size(nontm);
%--------------------------------------------------------------------------
% nontrigger time moment in time sequence case 분류
%--------------------------------------------------------------------------
% 9
    tmarr = [];
    switch SizeOfnontm
        case 9
            [tmarr, marker] = trigger_plus_9(tm);
        case 8
            [tmarr, marker] = trigger_plus_8(tm);
        case 7
            [tmarr, marker] = trigger_plus_7(tm);
        case 6
            [tmarr, marker] = trigger_plus_6(tm);
        case 5
            [tmarr, marker] = trigger_plus_5(tm);
        case 4
            [tmarr, marker] = trigger_plus_4(tm);
        case 3
            [tmarr, marker] = trigger_plus_3(tm);
        case 2
            [tmarr, marker] = trigger_plus_2(tm);
        case 1
            [tmarr, marker] = trigger_plus_1(tm);
        case 0
            [tmarr, marker] = trigger_plus_0(tm);
    end
    SizeOftmarr = size(tmarr);
    SizeOfmarker = size(marker);

    triggering_constr = optimconstr(param.nu, SizeOftm(2))
    triggering_constr(:,1) = u0 == u(:,1); %SizeOfTM == param.N
    for i = 1:SizeFtm(2)
        triggering_constr(i+1) = u(:,i)==u(:,i+1); %% i+1에서 triggering하면 u(:,i)~=u(:,i+1)
    end
    for i = 1:SizeOfmarker(2)
        for j = marker(i):marker(i+1)-1
            for k = 1:SizeOftm(2) %% required triggering time moment setting
                if  tm(k) == 1
                    if k ==1
                        triggering_constr(:,k) = u0 ~= u(:,1);
                    else
                        triggering_constr(:,k) =  u(:,k-1) ~= u(:,k);
                    end
                end
            end
        end
    end

end
    

    % prob.Constraints.triggering_constr = triggering_constr;
    % [sol,fval,exitflag,output,lambda] = solve(prob);
    % if exitflag == 1
    %     u = sol;
    %     t = tmcomp(1);
    %     nTM = tm(tmcomp(1)+1:SizeOftm)
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