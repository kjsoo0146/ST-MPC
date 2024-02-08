T = 0;
computed_tm = zeros(1,param.M+1);
state = param.x0;
state_scope = [transpose(state)];
input_scope = [];
Tsim = param.Tsim;
time = seconds(0:Tsim);
triggering_time = [];
while(1)
    T
    [trigger, rtm] = trigger_confirm(computed_tm)
    if trigger == 1
        triggering_time = [triggering_time T];
    end
    [control, computed_tm]= implement_autometica_mpc(trigger, state, rtm)
    state = lti_system(control);
    T = T+1;
    state_scope = [state_scope; transpose(state)];
    input_scope = [input_scope; control];
    if T == Tsim
        input_scope = [input_scope; control];
        break;
    end
end