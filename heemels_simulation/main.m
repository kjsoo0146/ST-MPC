clc;
clear all;

param = param_setup();
param.heemesl_Tset = Tset_d(param);
save('param', 'param');

out = sim('self_triggered_mpc_simulation.slx');
figure(1)
plot(out.state)
figure(2)
plot(out.input)