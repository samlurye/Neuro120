clear all

Nhs = 1:40;
errors = zeros(40, 2000);
for nh = Nhs
    for i = 1:2000
        errors(nh, i) = run_nn(nh, false);
    end
end

plot(Nhs, mean(errors, 2));
xlabel("N_h");
ylabel("Average MSE (2000 Trials)");

function mean_squared_error = run_nn(Nh, make_plots)

%% Set up parameters
N = 40; % Number of training samples
epsilon = 0.0; % Amount of label noise
Nh = Nh;
lambda = 0.000001;

%% Make dataset
target_fn = @(t) sin(t);
x = linspace(-pi,pi,N);
y = target_fn(x) + epsilon*randn(size(x));

Ntest = 100;
x_test = linspace(-pi,pi,Ntest);
y_test = target_fn(x_test);

Ni = 2;

%% Compute network activity

J = randn(Nh,Ni)/Nh;

h = J*[x; ones(1,N)];
h(h<0)=0;

h_test = J*[x_test; ones(1,Ntest)];
h_test(h_test<0)=0;


%% Now train linear regression to map from h to y

w = y * h' * pinv(h * h' + lambda * eye(Nh));

y_pred = w*h_test;
% the distribution code was calculating the total squared error
% rather than the mean squared error
mean_squared_error = norm(y_test-y_pred).^2 / length(y_test);

if make_plots
    plot(x,y,'ob')
    hold on
    plot(x_test,y_test)
    hold on
    plot(x_test,y_pred)

    %text(-pi,[.1 .9]*get(gca,'YLim')',sprintf('MSE: %g ', mean_squared_error))
    xlabel('Input')
    ylabel('Output')
    legend('Training data','Test data','Prediction')
end

end
