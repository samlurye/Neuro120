clear all

%% Midterm questions to memorize

questions = {'What is the approximate voltage inside of a neuron?',...
             'Which is at a higher concentration inside (outside) of a neuron?',...
             'What are the aims of computational neuroscience?',...
             'If Na+ enters a neuron, will that depolarize or hyperpolarize it?',...
             'What does STA mean?',...
             'Assume {\Phi}w=t cannot be solved exactly. Write the normal equations.',...
             'In the Gaussian probability density why is there  1/(2\pi\sigma^2)^{1/2}?'}



answers = {'-65mv',...
           'K+ (Na+)',...
           'Figure out ways to understand neural activity data',...
           'Depolarize',...
           'Spike-triggered average',...
           '\Phi^T\Phi w=\Phi^T t   or   w=(\Phi^T\Phi)^{-1}\Phi^T t',...
           'So that the integral over all x = 1, as befits a probability density'}


%% Generate and plot images to be stored

Ny = 32; % Image height
Nx = 400; % Image width
N = Ny*Nx; 
P = length(questions)

% Helper functions
reshape_to_image = @(x) reshape(x,Ny,Nx)
plot_mem = @(x) imshow(reshape_to_image(1-x),'InitialMagnification',400)
make_input = @(q,a) 1-imresize(string2im(['Q: ' q],['A: ' a]),[Ny Nx],'nearest')

xi=[]

for i = 1:P
    tmp = make_input(questions{i},answers{i});
    xi(:,i) = tmp(:);

    plot_mem(xi(:,i))
end

%% Generate recurrent weights using perceptron learning
W = zeros(N,N);
eta = .0001;
err = 1;
while(err>0)

    % Standard Generalized Perceptron LR 
    n = W*xi;

    kappa = 1/2;

    omega = (n-1/2).*(2*(xi-1/2)) - kappa < 0;
    err = sum(omega(:));

    err
    W = W + eta*(omega .* (2*(xi-1/2)))*xi';
end
disp('Done')

%% Implement Hopfield net update

hopfield_update = @(h) (W * h - 0.5) >= 0;

%% Run a probe: give it a question, and see if it fills in the answer
% wrong: 3, 5
for question_num = 1:P
    xi0 = make_input(questions{question_num},' ');

    T = 10;
    h = zeros(N,T);
    h(:,1) = xi0(:);

    figure(1)
    subplot(2,1,1)
    plot_mem(h(:,1))
    title(sprintf('Question (#%d)',question_num))
    for t = 1:T-1
        h(:,t+1) = hopfield_update(h(:,t));
        
        subplot(2,1,2)
        plot_mem(h(:,t))
        title(sprintf('Recalled pattern at step %d',t))
        drawnow
    end
    
end

%% Look at one question in more detail
question_num = 7;
question = questions{question_num};
answer = ''; 
xi0 = make_input(question,answer);

T = 10;
h = zeros(N,T);
h(:,1) = xi0(:);

figure(1)
subplot(10,1,1)
plot_mem(h(:,1))
title(sprintf('Corrupted input (#%d)',question_num))
for t = 1:T-1
    h(:,t+1) = hopfield_update(h(:,t));

    subplot(10,1,t+1)
    plot_mem(h(:,t))
    title(sprintf('Recalled pattern at step %d',t))
    drawnow
end

% both question 3 and question 5 require just 1 character of the answer in
% order to be correct

%% Determine extent of basin of attraction

question_num = 7;
xi0 = make_input(questions{question_num},'');

% Add noise
corruption_probability = 0.05;
corrupted_bits = rand(Ny,Nx)<corruption_probability;
xi0 = xi0.*(1-corrupted_bits)+(1-xi0).*corrupted_bits;

T = 20;
h = zeros(N,T);
h(:,1) = xi0(:);

figure(1)
subplot(211)
plot_mem(h(:,1))
title('Corrupted input')
for t = 1:T-1
    
    h(:,t+1) = hopfield_update(h(:,t));
    subplot(212)
    plot_mem(h(:,t))
    title('Recalled pattern')
    drawnow
end