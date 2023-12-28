function [tmarr, marker] = trigger_plus_1(tm)
    nontm = find(~tm);
    SizeOfnontm = size(nontm);
    marker = [];
%--------------------------------------------------------------------------
% tirriger time moment +0
    result = [tm];
    temp = size(result);
    marker = [marker, temp(1)];
%--------------------------------------------------------------------------
% tirriger time moment +1
    for a1 = 1:SizeOfnontm(2)
        tm = result(1,:);
        tm(nontm(a1)) = 1;
        result = [result; tm];
        if a1 ==1
            temp = size(result);
            marker = [marker, temp(1)];
        end
    end
    tmarr = result;
end