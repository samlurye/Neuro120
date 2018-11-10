
%% Load AlexNet 
net = alexnet;  % Load neural net. 


%% Plot weights from the first convolution layer

% Get the network weights for the second convolutional layer
w1 = net.Layers(2).Weights;

% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5);

% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
montage(w1)
title('First convolutional layer weights')
% List all the layers in the network
net.Layers

%% Run the peppers image through AlexNet

im = imresize(imread('peppers.png'),[227 227]);
label = classify(net, im);

imshow(im)
text(10,20,char(label),'Color','white')

%% Plot the neural activities of different filters

f = activations(net, im, 'conv1');

for i = [3, 10, 59]
    filter = i;
    subplot(131)
    imshow(w1(:,:,:,filter))
    axis square
    title(sprintf('Filter #%d',filter))

    subplot(133)
    imshow(im)
    axis square
    title('Original image')

    subplot(132)
    imagesc(f(:,:,filter))
    axis square
    title('Response')
    pause
end

%% Load data from Kriegeskorte, N., Mur, M., Ruff, D. A., Kiani, R., Bodurka, J., Esteky, H., ? Bandettini, P. A. (2008). Matching Categorical Object Representations in Inferior Temporal Cortex of Man and Monkey. Neuron, 60(6), 1126?1141. http://doi.org/10.1016/j.neuron.2008.10.043

load RDM_stimuli


%% Test translation invariance
clear act_corr

im_num = 41; % German shephard image number.
im = images(:,:,:,im_num);

layers = {'data','conv1','pool1','conv5','pool5','fc7','prob'};
translations = linspace(0, 180, 19);
corrs = zeros(length(layers), length(translations));

for l = 1:7
    for t = 1:19
        im_t = imtranslate(im, [translations(t), 0]);
        a0 = activations(net, im, char(layers(l)), 'OutputAs', 'columns');
        a1 = activations(net, im_t, char(layers(l)), 'OutputAs', 'columns');
        corrs(l, t) = corr(a0, a1);
    end
end

figure();

plot(translations, corrs, 'linewidth', 2);
legend(layers);

%% Test rotation invariance
clear act_corr

im_num = 41; % German shephard
im = images(:,:,:,im_num);

layers = {'data','conv1','pool1','conv5','pool5','fc7','prob'};
rotations = linspace(0, 180, 30);
corrs = zeros(length(layers), length(rotations));

for l = 1:7
    for t = 1:30
        im_r = imrotate(im, rotations(t), 'crop');
        a0 = activations(net, im, char(layers(l)), 'OutputAs', 'columns');
        a1 = activations(net, im_r, char(layers(l)), 'OutputAs', 'columns');
        corrs(l, t) = corr(a0, a1);
    end
end

figure();

plot(rotations, corrs, 'linewidth', 2);
legend(layers);

%% Test correlation between AlexNet RDMs and neural RDMs
clear c h

layers={'data','conv1','pool1','pool2','relu3','relu4','relu5','pool5','fc6','fc7','fc8'};
R = zeros(92,92,length(layers));
corrs = zeros(1, 11, 2);

for l = 1:length(layers)
    F = zeros(length(activations(net, im, char(layers(l)), 'OutputAs', 'columns')),1);
    for im_num = 1:92
        im = images(:,:,:,im_num);
        F(:,im_num) = activations(net, im, char(layers(l)), 'OutputAs', 'columns');
    end
    
    d = 1-corr(F); % Compute AlexNet RDM at a specific layer
    R(:,:,l) = d;
    
    corrs(1, l, 1) = corr(d(:), RDM1(:));
    corrs(1, l, 2) = corr(d(:), RDM2(:));
    
    figure()
    subplot(131)
    imagesc(d)
    caxis([0 1])
    axis square

    d_data = RDM1; % Plot experimental RDM
    subplot(132)
    imagesc(d_data)
    caxis([0 1])
    axis square
    title(char(layers(l)))

    subplot(133) % Plot correlation
    plot(d(:),d_data(:),'.')
    xlim([0 1.5])
    ylim([0 1.5])
    axis square
end

