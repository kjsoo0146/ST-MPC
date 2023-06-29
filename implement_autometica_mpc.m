function [control, nTM] = implement_autometica_mpc(vari)
    SizeOfvari = size(vari);
    
    trigger = vari(1);
    
    state = vari(2:3);
    
    rtm = vari(4:SizeOfvari);
    
    persistent temp_control;
    persistent temp_nTM;
    
    if trigger == 1
        [temp_nTM, temp_control] = autometica_mpc(rtm, state);
        nTM = temp_nTM;
        control = temp_control;
    elseif trigger ==0
        nTM = temp_nTM;
        control = temp_control;
    end
    
end