close all

param = param_setup;
time_arr = [];
state_arr = [param.init'];
input_arr = [];
state = param.init;
for T = 0:param.Tsim
    input = cmpc(state, param);
    input_arr = [input_arr; input];
    state = param.A_CMPC *state +param.B_CMPC*input;
    state_arr = [state_arr; state'];
    time_arr = [time_arr; T];
end
figure();
stairs(time_arr, input_arr);
figure();
hold on;
stairs(time_arr, state_arr(1:end-1,1))
stairs(time_arr, state_arr(1:end-1,2))