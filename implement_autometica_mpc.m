function [nTM, control] = implement_autometica_mpc(trigger, rtm, state)
    persistent temp_control;
    persistent temp_nTM;
    if trigger == 1
        [temp_nTM, temp_control] = autometica_mpc(rtm, state)
    else
        

end