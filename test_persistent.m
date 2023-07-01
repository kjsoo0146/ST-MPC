function []=test_persistent()
    persistent t;
    persistent arr;
    if isempty(t)==1
        t =1;
    end
    if isempty(arr)==1
        arr=[t]
    end
    arr = [arr t]
    t = t+1
end