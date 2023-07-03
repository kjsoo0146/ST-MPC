clc;
clear all;
close all;

param = param_setup();
param.autometica_Tset = autometica_Tset(param);
save('param', 'param');

clc;
autometica_ver_simulation;
figure(1);
hold on;
stairs(time, state_scope(:,1)');
stairs(time, state_scope(:,2)');

figure(2);
stairs(time(1:end-1), input_scope);
