clear all

%% Configure input current

% Basic step input at t=100
Iapp = @(t) (t>100)*16;

% Two pulses spaced t_sep ms apart
t_sep = 12;
Iapp = @(t) (t>10 & t < 12)*10 + (t>10+t_sep & t < 12+t_sep)*10;

% Step up from 0 to 6.3 microA at t=100
%Iapp = @(t) (t>0 & t < 100)*0 + 6.3*(t>100);

% Step up from 0 to 8 microA at t=100
%Iapp = @(t) (t>0 & t < 100)*0 + 8*(t>100);

% Step down from 10 to 8 microA at t=100
%Iapp = @(t) (t>0 & t < 100)*10 + 8*(t>100);

% Turn off from 10 to 0 microA at t=100
%Iapp = @(t) (t>0 & t < 100)*10;

% Sinusoid plus constant amplitude
%I0 = 0;
%I1 = 7;
%hz = 50;
%omega = hz/1000*2*pi;
%Iapp  = @(t) I0 + I1*sin(omega*t);

%% Simulate HH dynamics
use_euler = false;
theta0 = [0.0003    0.0529    0.3177    0.5961]; % Initial state
Tfinal = 200; % Duration of simulation in ms
dt = .01;
if use_euler
    [t,theta] = euler_solver(@(t,x) hh_deriv(t,x,Iapp), [0 Tfinal], theta0, dt);
else
    [t,theta] = ode45(@(t,x) hh_deriv(t,x,Iapp), [0 Tfinal], theta0);
end
%% Plot results
plot_ax(1) = subplot(311)
plot(t,Iapp(t),'linewidth',2)
ylabel('Input current (\mu A)')

plot_ax(2) = subplot(312)
plot(t,theta(:,1),'linewidth',2)
ylabel('Membrane potential (mV)')
xlabel('Time (ms)')

linkaxes(plot_ax,'x')

%% Estimate firing rate
vthresh = 20; % Consider a spike to have occured when voltage crosses this threshold (mV)
t_thresh = 100; % Only compute firing rate using spikes occuring after this time (in ms)
v = theta(:,1);
tspike = t(v(1:end-1) <= vthresh & v(2:end) > vthresh);
tspike(tspike < t_thresh) = []; % Throw away spikes occuring before t_thresh ms
if isempty(tspike) % Handle zero firing rate
   tspike = [0 inf];
end
for ts = tspike
    vline(ts)
end

fr = 1000/median(diff(tspike));
text(10,[.1 .9]*get(gca,'YLim')',sprintf('Firing rate: %g Hz', fr))

%% Plot gating variables
plot_ax(3) = subplot(313)
plot(t,theta(:,2:end))
ylabel('Gating variable')
legend('m','n','h')
xlabel('Time (ms)')

linkaxes(plot_ax,'x')
