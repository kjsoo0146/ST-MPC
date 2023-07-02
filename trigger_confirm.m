function result = trigger_confirm(computed_tm) 
%%이전 triggering step에서 계산된 computed_tm를 받아와서
%%현재의 required triggering time moment sequence(tm | computed_tm) 를 구하고 
%%self-triggered mpc 연산을 할 지 말지 결정하는 함수


%%%% simulink에서 돌릴때 persistent variable의 사이즈가 바뀌지 않는다
    param = load("param.mat");
    param = param.param;
    SizeOfTM = size(computed_tm);
    persistent last_trigger
    persistent temp;
    
    rtm = [];
    trigger = [];
    if isempty(temp)==1
        tm = [1 0 0 0 0 1];
    else
        tm = load("data.mat");
    end
    if isempty(last_trigger) == 1
        last_trigger =0;
    end

    if last_trigger == 1
        tm = tm | computed_tm ;
    end
    
    if tm(1) == 0
        SizeOftm = size(tm);
        trigger = 0;
        rtm = tm(2:end); %% nontrigger time 일때 trigger time moment는 사용되지 않는 쓰래기값이다. 
        save ("data.mat", rtm);
        last_trigger=0;
        result = [trigger, rtm];
        temp = 1
    elseif tm(1)==1
        SizeOftm = size(tm);
        trigger = 1;
        tm = tm(2:end);
        if SizeOftm(2)-1>=param.M
            rtm = tm;
        else
            rtm = [tm zeros(1,param.M-1), 1];
        end
        save ("data.mat", 'rtm');
        result = [trigger, rtm];
        last_trigger=1;
        clear tm;
        temp =1;
    end
end
% if tm(1) == 0
%     SizeOftm = size(tm);
%     trigger = 0;
%     tm = tm(2:SizeOftm(2));
%     rtm = tm; %% nontrigger time 일때 trigger time moment는 사용되지 않는 쓰래기값이다. 
% else
% 