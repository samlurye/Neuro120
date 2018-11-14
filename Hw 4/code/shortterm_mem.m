clear all

N = 50; % Number of neurons in network

dt = .1; % Discretization timestep
tau = .4; % Time constant

T = 10; % Max time
S = ceil(T/dt); % num simulation steps
t = ((1:S)-1)*dt; % time

%% Simulate network

% Set up recurrent weight structure

W = zeros(N,N); % No recurrent connections

%weight_scale = 1;
%W = weight_scale*eye(N); % Autapses

%[U,~,~] = svd(randn(N,N)); % Random orthonormal connections
%W = weight_scale*U;

noise_scale = 0;
W = W + noise_scale/sqrt(N)*randn(N,N);


% Create input
I = zeros(1,S);
I(t>1 & t<2)=1;

% Create weights from stimulus into neural population
V = ones(N,1);

r = zeros(N,S);
for s = 1:S-1
  %  r(:,s+1) = r(:,s) + (...your code here...)*dt/tau;
end

% Calculate eigenvalues of recurrent weights

lam = eig(W);

subplot(311)
plot(t,r')
xlabel('Time (a.u.)')
ylabel('Activity')
subplot(312)
plot(t,I)
xlabel('Time (a.u.)')
ylabel('Input')
ylim([0,1.5])
subplot(313) % Plot eigenvalues of W in sorted order
plot(sort(abs(lam),'descend'),'.')
ylim([0,1.5])
xlabel('Eigenvalue #')
ylabel('Eigenvalue Magnitude |\lambda|')


