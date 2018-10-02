function dy = hh_deriv(t,y,Iapp)
% y: the state vector containing [v m n h].
% t: the time t in ms
% Iapp: a function handle describing the applied input current in micro amps 
% (such that the applied input current at time t is Iapp(t))
% Returns: dy, a vector of time derivatives [dv dm dn dh]'

Cm = 1;

% Equilibrium condunctances
gK = 36;
gNa = 120;
gL = 0.3;

% Reversal potentials
vK = -12;
vNa = 115;
vL = 10.6;

% Voltage-dependent conductance
alpha_m = @(x) 0.1.*(25 - x)./(exp((25-x)./10) - 1);
alpha_h = @(x) 0.07.*exp(-x./20);
alpha_n = @(x) 0.01.*(10-x)./(exp((10-x)./10) - 1);

beta_m = @(x) 4.*exp(-x./18);
beta_h = @(x) 1./(exp((30-x)./10) + 1);
beta_n = @(x) 0.125.*exp(-x./80);

[v,m,n,h] = unpack(y);

dv = 1./Cm.*( -gK.*n.^4.*(v - vK) - gNa.*m.^3.*h.*(v - vNa) - gL.*(v - vL) + Iapp(t) );
dm = alpha_m(v).*(1-m) - beta_m(v).*m;
dn = alpha_n(v).*(1-n) - beta_n(v).*n;
dh = alpha_h(v).*(1-h) - beta_h(v).*h;

dy = [dv; dm; dn; dh];