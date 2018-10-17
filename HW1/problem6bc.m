
theta0 = [0.0003    0.0529    0.3177    0.5961]; % Initial state
Tfinal = 200; % Duration of simulation in ms

firing_rates = zeros(100);

i = 1;
for I = linspace(0,200,100)
    
    % Sinusoid plus constant amplitude 
    I0 = I(1);
    I1 = 7;
    hz = 50;
    omega = hz/1000*2*pi;
    Iapp  = @(t) I0 + I1*sin(omega*t);
    
    [t,theta] = ode45(@(t,x) hh_deriv(t,x, Iapp), [0 Tfinal], theta0);
    firing_rates(i) = firing_rate(t, theta);
    disp(i);
    i = i + 1;
end

plot(linspace(0, 200, 100), firing_rates,'linewidth',2);
ylabel("Firing Rate (Hz)");
xlabel("I_0");
