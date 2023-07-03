function y=self_triggered_input(x0)
    persistent clk
    persistent a
    if (clk==1) 
        [u, t]=self_triggered_mpc_heemels(x0);
        clk= t;
        a = u;
        y = [a clk];
    elseif (isempty(clk))
        [u, t]=self_triggered_mpc_heemels(x0);
        clk= t;
        a = u;
        y = [a clk];
    else
        clk = clk -1;
 %       y = [0 clk]; %sparse input
        y = [a clk]; 
    end
 
end