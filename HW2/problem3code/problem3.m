clear all

load toWhiten.mat
load mixedImg.mat

% ai
remove_mean = @(A) A - mean(A);
normalized = remove_mean(toWhiten);

% aii
covariance = @(A) remove_mean(A)'*remove_mean(A)/(length(A)-1);
covm = covariance(toWhiten);

% aiii
[V, D] = eig(covm);
v1 = V(:,1);
v2 = V(:,2);
% scatter(normalized(:,1),normalized(:,2))
% hold on
% biplot(V)

% b
whitened = whiten(toWhiten);
% scatter(whitened(:,1),whitened(:,2))

% ci
% plotImgs(imMix)

% cii
whitened_ims = whiten(imMix);
% plotImgs(whitened_ims)

% ciii
% unwhitened learning
unw_ws = learnWeights(imMix);
unw_ica = imMix*unw_ws;
plotImgs(unw_ica)

% whitened learning
% w_ws = learnWeights(whitened_ims);
% w_ica = whitened_ims*w_ws;
% plotImgs(w_ica)

function y = whiten(A)
    [V, D] = eig(cov(A));
    y = A*V*diag(1./(diag(D)).^(1/2))*V';
end
