function [nTM, input] = autometica_mpc(tm, state)
% tm은 t=0에서의 triggering sign이 없음
%==========================================================================
 %parameter setting
    param = load("param.mat");
    param = param.param;
    Nl = size(tm);
    param.Nl = Nl(2);
%==========================================================================
    %implement autometica vesion
    prob = optimproblem;
    x0 = optimvar('x0', param.nx);
    x = optimvar('x', param.nx, param.Nl);
    u0 = optimvar('u0', param.nu);
    u = optimvar('u',param.nu, (param.Nl)-1);
    size(u)
    cost_function =x0'*param.Q*x0+u0*param.R*u0;
    terminal_weight = param.tildeP(end-param.nx:end-param.nu,end-param.nx:end-param.nu);
    for i=1:param.Nl-1
        cost_function = cost_function + x(:,i)'*param.Q*x(:,i) + u(:,i)'*param.R*u(:,i); % terminal cost 설정해야 됨
    end
    cost_function = cost_function + x(:,param.Nl)'*terminal_weight*x(:,param.Nl);
    prob.Objective = cost_function;
    
%==========================================================================
% model constraints
    model_constr = optimconstr(param.nx,(param.Nl)+1);
    model_constr(:,1) = x(:,1) == param.A*x0 + param.B*u0;
    for i=1:param.Nl-1
        model_constr(:,i+1) = x(:,i+1) == param.A*x(:,i) + param.B*u(:,i);
    end
    model_constr(:,(param.Nl)+1) = x0 == state;
    prob.Constraints.model_constr = model_constr;
    
%==========================================================================
%constraints on state and input
    constr_ineq = optimconstr(param.NumOfConstr, param.Nl);
    constr_ineq(:,param.Nl) = param.F*x0+param.G*u0<=1;
    for i=2:param.Nl-1
        constr_ineq(:,i)=param.F*x(:,i)+param.G*u(:,i)<=1;
    end
    prob.Constraints.constr_ineq=constr_ineq;
%==========================================================================
%terminal set constraints
    constT = optimconstr(30,param.autometica_Tset+1);
       
    LL = param.tildeF - param.tildeG*param.tildeK;
    for i= 1:param.autometica_Tset
        constT(:,i) = LL*(param.A_BK^(i))*param.phi(:,1:2)*x(:,param.Nl)<=ones(30,1);
    end
    constT(1:param.NumOfConstr,param.autometica_Tset+1) = (param.F-param.G*param.K)*x(:,param.Nl)<=1;
    prob.Constraints.ConstT = constT;
%==========================================================================
% triggering constraints
    SizeOftm = size(tm);
    tmcomp = find(tm);
    SizeOfTmcomp = size(tmcomp);
    nontm = find(~tm); 
    SizeOfnontm = size(nontm);
%==========================================================================
% required trigger time moment sequence에서 triggering time moment 추가하기
% 이부분에서 tmarr marker를 결과로 얻는데 tmarr는 triggering time moment sequence에서
% triggering time moment를 추가하여 얻을 수 있는 모든 sequence를 묶어 tmarr로 받는다

    tmarr = [];
    switch SizeOfnontm(2)
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

%==========================================================================
%% exitflag error 수정해야함!!
    apSizeOftmarr = size(tmarr);
    SizeOfmarker = size(marker);

    for i = 1:SizeOfmarker(2)
        solArr = [];
        fvalArr = [];
        exitflagArr = [];
        if i ~= SizeOfmarker(2)
            for j = marker(i):marker(i+1)-1 

                tm_setting = tmarr(j,:) %tm이 정해짐
                triggering_constr = optimconstr(param.nu, SizeOftm(2));

                for k = 1:SizeOftm(2) %% required triggering time moment setting
                    if  tm_setting(k) == 0 %% nontriggering time moment에서 input에 대한 constraints (u==u)
                        if k ==1
                            triggering_constr(:,k) = u0 == u(:,1);
                        else
                            triggering_constr(:,k) =  u(:,k-1) == u(:,k);
                        end
                    end
                end
                prob.Constraints.triggering_constr = triggering_constr;
                [sol,fval,exitflag,output,lambda] = solve(prob);
                if exitflag == 1
                    solArr = [solArr sol]
                    fvalArr = [fvalArr fval]
                    exitflagArr = [exitflagArr exitflag]
                end
            end
        else
            for j = marker(i):marker(end)

                tm_setting = tmarr(j,:) %tm이 정해짐
                triggering_constr = optimconstr(param.nu, SizeOftm(2));

                for k = 1:SizeOftm(2) %% required triggering time moment setting
                    if  tm_setting(k) == 0 %% nontriggering time moment에서 input에 대한 constraints (u==u)
                        if k ==1
                            triggering_constr(:,k) = u0 == u(:,1);
                        else
                            triggering_constr(:,k) =  u(:,k-1) == u(:,k);
                        end
                    end
                end
                prob.Constraints.triggering_constr = triggering_constr;
                [sol,fval,exitflag,output,lambda] = solve(prob);
                if exitflag == 1
                    solArr = [solArr sol]
                    fvalArr = [fvalArr fval]
                    exitflagArr = [exitflagArr exitflag]
                end 
            end
        end
       
        if isempty(solArr)==0
            temp = min(fvalArr);
            [row, col] = find(fvalArr == temp);
            input=solArr(row, col).u0;
            nTM = tmarr(marker(i)+col-1,:);
            return;
        end
    end
end