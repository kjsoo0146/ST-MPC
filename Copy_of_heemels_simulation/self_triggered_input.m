function input=self_triggered_input(x0)
    persistent clk
    persistent a
    persistent TYPE
    param = param_setup();
    if norm(x0, inf) <= 0.1
        if (isempty(clk))
            [u, t]=self_triggered_mpc_heemels(x0);
            clk= param.M;
            a = u;
            TYPE =1;
            input = [a, clk, TYPE]';
        elseif (clk==1)
            [u, t]=self_triggered_mpc_heemels(x0);
            clk= param.M;
            a = u;
            TYPE =1;
            input = [a clk TYPE];
        else
            clk = clk -1;
    %       y = [0 clk]; %sparse input
            input = [a clk TYPE];
        end
    else
        if (clk==1) 
            [u, t]=self_triggered_mpc_heemels(x0);
            clk= t;
            a = u;
            TYPE =2;
            input = [a clk TYPE];
        elseif (isempty(clk))
            [u, t]=self_triggered_mpc_heemels(x0);
            clk= t;
            a = u;
            TYPE =2;
            input = [a clk TYPE];
        else
            clk = clk -1;
    %       y = [0 clk]; %sparse input
            input = [a clk TYPE];
        end

    end
 
end