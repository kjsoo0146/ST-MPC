function [control, computed_tm]= implement_autometica_mpc(trigger, state, rtm)
    persistent temp_control;
    persistent temp_nTM;
    
    if trigger == 1 %% trigger ==1 이면 MPC 연산 수행, trigger~=1이면 MPC 연산 스킵
        [temp_nTM, temp_control] = autometica_mpc(rtm, state);
        computed_tm = temp_nTM;
        control = temp_control;
    elseif trigger ==0
        temp_nTM = temp_nTM(2:end);
        computed_tm = temp_nTM;
        control = temp_control;%%trigger가 1이 아닐때는 computed_TM은 쓰이지 않는다.
    end
    
end