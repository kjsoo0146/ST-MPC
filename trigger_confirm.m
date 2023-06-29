function [trigger, rtm] = trigger_confirm(TM) 
%%이전 triggering step에서 계산된 triggering time moment sequnce를 받아와서
%%현재의 required triggering time moment sequence 를 구하고 self-triggered mpc 연산을 할 지 말지 결정하는 함수

    param = load("param.mat");
    param = param.param;
    
    SizeOfTM = size(TM);
    persistent tm
    persistent last_trigger
    if isempty(tm)==1
        tm = [1 0 0 0 0 1];
    end
    if last_trigger == 1
        tm = tm | TM ;
    end
    if tm(1) == 0
        SizeOftm = size(tm);
        trigger = 0;
        tm = tm(2:SizeOftm(2));
        rtm = tm; %% nontrigger time 일때 trigger time moment는 사용되지 않는 쓰래기값이다. 
        last_trigger=0;
    elseif tm(1)==1
        SizeOftm = size(tm);
        trigger = 1;
        tm = tm(2:SizeOftm(2));
        if SizeOftm(2)-1>=param.M
            rtm = tm;
        else
            rtm = [tm zeros(1,param.M-1), 1];
        end
        last_trigger=1;
    end
end
% if tm(1) == 0
%     SizeOftm = size(tm);
%     trigger = 0;
%     tm = tm(2:SizeOftm(2));
%     rtm = tm; %% nontrigger time 일때 trigger time moment는 사용되지 않는 쓰래기값이다. 
% else
% 