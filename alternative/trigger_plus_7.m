function [tmarr, marker] = trigger_plus_7(tm)
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
%--------------------------------------------------------------------------
% tirriger time moment +2
    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            tm = result(1,:);
            tm(nontm(a1)) = 1;
            tm(nontm(a2)) = 1;
            result = [result; tm];
            if a1 ==1 && a2 == a1+1
                temp = size(result);
                marker = [marker, temp(1)];
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +3

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                tm = result(1,:);
                tm(nontm(a1)) = 1;
                tm(nontm(a2)) = 1;
                tm(nontm(a3)) = 1;
                result = [result; tm];
                if a1 ==1 && a2 == a1+1 && a3 == a2+1
                    temp = size(result);
                    marker = [marker, temp(1)];
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
                    tm = result(1,:);
                    tm(nontm(a1)) = 1;
                    tm(nontm(a2)) = 1;
                    tm(nontm(a3)) = 1;
                    tm(nontm(a4)) = 1;
                    result = [result; tm];
                    if a1 ==1 && a2 == a1+1 && a3 == a2+1 && a4 == a3+1
                        temp = size(result);
                        marker = [marker, temp(1)];
                    end
                end
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +5

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                for a4 = a3+1:SizeOfnontm(2)
                    for a5 = a4+1:SizeOfnontm(2)
                        tm = result(1,:);
                        tm(nontm(a1)) = 1;
                        tm(nontm(a2)) = 1;
                        tm(nontm(a3)) = 1;
                        tm(nontm(a4)) = 1;
                        tm(nontm(a5)) = 1;
                        result = [result; tm];
                        if a1 ==1 && a2 == a1+1 && a3 == a2+1 && a4 == a3+1 && a5 == a4+1
                            temp = size(result);
                            marker = [marker, temp(1)];
                        end
                    end
                end
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +6

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                for a4 = a3+1:SizeOfnontm(2)
                    for a5 = a4+1:SizeOfnontm(2)
                        for a6 = a5+1:SizeOfnontm(2)
                            tm = result(1,:);
                            tm(nontm(a1)) = 1;
                            tm(nontm(a2)) = 1;
                            tm(nontm(a3)) = 1;
                            tm(nontm(a4)) = 1;
                            tm(nontm(a5)) = 1;
                            tm(nontm(a6)) = 1;
                            result = [result; tm];
                            if a6 == a5+1
                                temp = size(result);
                                marker = [marker, temp(1)];
                            end
                        end
                    end
                end
            end
        end
    end
%--------------------------------------------------------------------------
% tirriger time moment +7

    for a1 = 1:SizeOfnontm(2)
        for a2 = a1+1:SizeOfnontm(2)
            for a3 = a2+1:SizeOfnontm(2)
                for a4 = a3+1:SizeOfnontm(2)
                    for a5 = a4+1:SizeOfnontm(2)
                        for a6 = a5+1:SizeOfnontm(2)
                            for a7 = a6+1:SizeOfnontm(2)
                                tm = result(1,:);
                                tm(nontm(a1)) = 1;
                                tm(nontm(a2)) = 1;
                                tm(nontm(a3)) = 1;
                                tm(nontm(a4)) = 1;
                                tm(nontm(a5)) = 1;
                                tm(nontm(a6)) = 1;
                                tm(nontm(a7)) = 1;
                                result = [result; tm];
                                if a1 ==1 && a2 == a1+1 && a3 == a2+1 && a4 == a3+1 && a5 == a4+1 && a7 == a6+1
                                    temp = size(result);
                                    marker = [marker, temp(1)];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    tmarr = result;
end