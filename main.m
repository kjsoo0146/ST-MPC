clc;
clear all;
close all;

param = param_setup();
param.autometica_Tset = autometica_Tset(param);
param.heemesl_Tset = Tset_d(param);
save('param', 'param');

sim('self_triggered_mpc_simulation.slx');