function tmarr = trigger_plus_9(tm)
    original_tm = tm;
    % M=5이라고 할때 nontriggering time moment의 횟수가 9라는 것은 mode1의 길이가 9이고 TM = [1 0 0 0 0 0 0 0 0 0]임과 동치이다.
    nontm = find(~tm);
    SizeOfnontm = size(nontm);
%--------------------------------------------------------------------------
% tirriger time moment +0
    result = [tm];

%--------------------------------------------------------------------------
% tirriger time moment +1
    for a1 = 1:SizeOfnontm(2)
        tm = result(1,:);
        tm(nontm(a1)) = 1;
        result = [result; tm]
    end

%--------------------------------------------------------------------------
% tirriger time moment +2

