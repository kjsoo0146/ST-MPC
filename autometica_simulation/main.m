clc;
clear all;
close all;

param = param_setup();
param.autometica_Tset = 5
save('param', 'param');

clc;
autometica_ver_simulation;
figure(1);
hold on;
grid
stairs(time, state_scope(:,1)');
stairs(time, state_scope(:,2)');

figure(2);
grid
stairs(time(1:end-1), input_scope);

plot_f
figure(3);
hold on
grid
plot(state_scope(:,1)',state_scope(:,2)', '*r')
