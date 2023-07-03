function output= implement_autometica_mpc(vari)
    SizeOfvari = size(vari);  %% vari=[trigger, state, rtm] trigger,state의 사이즈는 고정이지만 rtm의 사이즈는 time varying 하다.
    
    trigger = vari(1);
    
    state = [vari(2); vari(3)];
    
    rtm = vari(4:SizeOfvari(2));
    
    persistent temp_control;
    persistent temp_nTM;
    
    if trigger == 1 %% trigger ==1 이면 MPC 연산 수행, trigger~=1이면 MPC 연산 스킵
        [temp_nTM, temp_control] = autometica_mpc(rtm, state);
        computed_tm = temp_nTM;
        control = temp_control;
        output = [control, computed_tm]
    elseif trigger ==0
        SizeOftemp_nTM=size(temp_nTM)
        computed_tm = temp_nTM(2:SizeOftemp_nTM(2));
        control = temp_control;
        output = [control, computed_tm]%%trigger가 1이 아닐때는 computed_TM은 쓰이지 않는다.
    end
    
end