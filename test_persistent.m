function y = test_persistent(const)
    persistent t;
    if isempty(t)==1
        t=1
        save ('NNN.mat', 't');
    else 
        temp = load('NNN.mat');
        temp = [temp temp(end)];
    end
end