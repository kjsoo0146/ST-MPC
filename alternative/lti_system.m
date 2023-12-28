function nstate = lti_system(input)

    param = load("param.mat");
    param = param.param;

    persistent state;
    if isempty(state)==1
        state = param.x0;
    end
    A = param.origin_A;
    B = param.B;
    nstate = A*state + B*input;
    state = nstate;
end