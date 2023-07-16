function [tmarr, marker] = trigger_plus_4(tm)
    nontm = find(~tm);
    SizeOfnontm = size(nontm);
    result_marker = [];
    result_tm=[];
%--------------------------------------------------------------------------
% tirriger time moment +0
    result_tm = [tm];
    temp = size(result_tm);
    result_marker = [result_marker, temp(1)];
%--------------------------------------------------------------------------
% tirriger time moment +1
    for a1 = 1:SizeOfnontm(2)
        tm = result_tm(1,:);
        tm(nontm(a1)) = 1;
        result_tm = [result_tm; tm];
        if a1 ==1
            temp = size(result_tm);
            result_marker = [result_marker, temp(1)]
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +2
    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            tm = result_tm(1,:);
            tm(nontm(a1)) = 1;
            tm(nontm(a2)) = 1;
            result_tm = [result_tm; tm];
            if a1==1 && a2==a1+1
                temp = size(result_tm);
                result_marker = [result_marker, temp(1)]
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +3

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                tm = result_tm(1,:);
                tm(nontm(a1)) = 1;
                tm(nontm(a2)) = 1;
                tm(nontm(a3)) = 1;
                result_tm = [result_tm; tm];
                if a1==1 && a2==a1+1 && a3==a2+1 
                    temp = size(result_tm);
                    result_marker = [result_marker, temp(1)]
                end
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +4

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                for a4 = a3+1:SizeOfnontm(2)
                    tm = result_tm(1,:);
                    tm(nontm(a1)) = 1;
                    tm(nontm(a2)) = 1;
                    tm(nontm(a3)) = 1;
                    tm(nontm(a4)) = 1;
                    result_tm = [result_tm; tm];
                    if a1==1 && a2==a1+1 && a3==a2+1 && a4==a3+1
                        temp = size(result_tm);
                        result_marker = [result_marker, temp(1)]
                    end
                end
            end
        end
    end
    marker = result_marker;
    tmarr = result_tm;
end