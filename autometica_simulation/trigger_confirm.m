function [trigger, rtm] = trigger_confirm(computed_tm) 
%%이전 triggering step에서 계산된 computed_tm를 받아와서
%%현재의 required triggering time moment sequence(tm | computed_tm) 를 구하고 
%%self-triggered mpc 연산을 할 지 말지 결정하는 함수

%%%% simulink에서 돌릴때 persistent variable의 사이즈가 바뀌지 않는다
    param = load("param.mat"); % param_setting
    param = param.param;
    persistent last_trigger
    persistent tm;
    if isempty(tm)==1
        tm = [1 0 0 0 0 1];
    end
    if isempty(last_trigger) == 1
        last_trigger =0;
    end

    if last_trigger == 1
        fprintf("tm과 computed_tm의 결합\n")
        tm
        computed_tm
        tm = tm | computed_tm 
    end
    
    if tm(1) == 0
        trigger = 0;
        tm = tm(2:end); %% nontrigger time 일때 trigger time moment는 사용되지 않는 쓰래기값이다. 
        rtm = tm;
        last_trigger=0;
    elseif tm(1) == 1
        trigger = 1;
        tm = tm(2:end);
        if size(tm,2)-1>=param.M
            rtm = tm;
        else
            rtm = [tm zeros(1,param.M-1), 1];
        end
        tm = rtm;
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