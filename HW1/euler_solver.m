function [t, y] = euler_solver(odefun, tspan, y0, dt)
% Solve differential equation y' = f(t,y), from time tspan = [t0 t_final], 
% with initial condition y0. Here odefun must be a function with signature 
% odefun(t,y), which for a scalar t and a vector y returns a column vector 
% corresponding to f(t,y). The solver uses the integration timestep dt. 
% Each row in the solution array y corresponds to a time returned in the 
% column vector t.
    y0 = transpose(y0);
    y = y0;
    y_prev = y0;
    t_i = tspan(1);
    t = t_i;
    y_t = y0;
    i = 1;
    while t_i < tspan(2)
        i = i + 1;
        y_t = y_prev + odefun(t_i, y_t) * dt;
        y_prev = y_t;
        t_i = t_i + dt;
        y(:, i) = y_t;
        t(i) = t_i;
    end
    y = transpose(y);
end
        
