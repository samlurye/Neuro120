clear all

%% Make mach band image

sz = 1000;
slope = -.003;
[x,y]=meshgrid(-sz/2:sz/2,-sz/2:sz/2);
im_mach = max(-.5,min(.5,x*slope));

imagesc(im_mach)
colormap gray

figure();
%% Create and plot DoG filter

s1 = 3;
s2 = 7;
dog = fspecial('gaussian', 51, s1) - fspecial('gaussian', 51, s2);
surf(dog)

%% Convolve image and plot the result

figure();

res = conv2(im_mach, dog, 'valid');

imagesc(res);
colormap gray

figure();

f = dog + 0.00001;

res = conv2(im_mach, f, 'valid');

imagesc(res);
colormap gray

%% Create checkerboard image

sz = 1000;
stripe_width = 10;
num_stripes = 10;

im_cb = -.5*ones(sz,sz);

for c = round(linspace(1,sz,num_stripes))
    im_cb(c:c+stripe_width,:) = .5;
    im_cb(:,c:c+stripe_width) = .5;
end

figure();

imagesc(im_cb)
colormap gray

% Convolve image and plot the result

res = conv2(im_cb, dog, 'valid');

figure();

imagesc(res)
colormap gray

dog_fovea = fspecial('gaussian', 51, 0.5) - fspecial('gaussian', 51, 1);
figure();
surf(dog_fovea);
res = conv2(im_cb, dog_fovea, 'valid');
figure();
imagesc(res);
colormap gray

%% Load built-in natural image
im_natural = double(rgb2gray(imread('peppers.png')));
figure();
imagesc(im_natural)
colormap gray

%% Convolve and plot the result

figure();

res = conv2(im_natural, dog, 'valid');
imagesc(res)
colormap gray

figure();

res = conv2(im_natural, dog_fovea, 'valid');
imagesc(res)
colormap gray