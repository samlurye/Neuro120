function im = string2im(str1,str2)

Nx = 1000;
Ny = 80;

% Create the text mask 
% Make an image the same size and put text in it 
hf = figure('color','white','units','normalized','position',[.1 .1 .8 .8],'visible','off'); 
image(ones(Ny,Nx)); 
set(gca,'units','pixels','position',[0 0 Nx-1 Ny-1],'visible','off')

% Text at arbitrary position 
text('units','pixels','position',[10 65],'fontsize',30,'fontweight','bold','string',str1) 
text('units','pixels','position',[10 25],'fontsize',30,'fontweight','bold','string',str2)

% Capture the text image 
% Note that the size will have changed by about 1 pixel 
tim = getframe(gca); 
close(hf) 

% Extract the cdata
tim2 = tim.cdata;

im = double(tim2(:,:,1)>0.4);