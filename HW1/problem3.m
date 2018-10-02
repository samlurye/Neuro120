
theta0 = [0.0003    0.0529    0.3177    0.5961]; % Initial state
Tfinal = 200; % Duration of simulation in ms

firing_rates = zeros(100);

i = 1;
for Iapp = linspace(0, 15, 100)
    [t,theta] = ode45(@(t,x) hh_deriv(t,x, @(t) Iapp), [0 Tfinal], theta0);
    firing_rates(i) = firing_rate(t, theta);
    disp(i);
    i = i + 1;
end

plot(linspace(0, 15, 100), firing_rates,'linewidth',2);
ylabel("Firing Rate (Hz)");
xlabel("Current (\mu A)");
