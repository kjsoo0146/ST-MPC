clc;
clear all;
close all;

param = param_setup();
param.heemesl_Tset = Tset_d(param);
save('param', 'param');

sim('self_triggered_mpc_simulation.slx');