function [x,y,immob_val,tempBW]=GetPositionFromImage(IM,prevBW,IMRef,mask,r_IMonREAL,th_BW,th_ObjectSize,shape_ratio)

% function GetPositionFromImage.m

% INPUTS :
% IM = Image from webcam (double)
% prevBW = Image of the previous time point (double)
% IMRef = Image of reference  (double)
% mask = to ignore part of the image (double)
% r_IMonREAL = ration image pixel on real distance (px -> cm conversion)
% th_BW = threshold for image binary conversion (im2bw.m)
% th_ObjectSize = threshold for rognage (bwareaopen.m)
% shape_ratio = ration L/l for affining mouse detection
%
% OUTPUTS :
% x,y = position of the mouse, NaN if undefined
% immob_val = immobility i.e. difference between two images
% tempBW = treated image for defining immobility in next loop 
% <><><> IMPORTANT : for immobility, lower image sampling to 4Hz !!! <><><> 

%% defaults values

% prevBW = zeros(size(double(IM)));
% IMRef = max(max(double(IM)))*ones(size(double(IM)));
% mask = ones(size(double(IM)));
% r_IMonREAL = 10;
% th_BW = 0.4;
% th_ObjectSize = 130;
% shape_ratio = 4;



%%  TREAT IMAGE 

% Substract reference image
subimage = IMRef-IM;
subimage = uint8(subimage.*mask);

% Convert the resulting grayscale image into a binary image.
diff_im = im2bw(subimage,th_BW);

% Remove all the objects less large than th_ObjectSize
diff_im = bwareaopen(diff_im,th_ObjectSize);
            
% Label all the connected components in the image.
bw = logical(diff_im); %CHANGED


%% EVALUATE FREEZING / IMMOBILITY

immob_IM = bw - prevBW;
diffshow=ones(size(immob_IM,1),size(immob_IM,2));
diffshow(bw==1)=0;
%                 immob_IM=imerode(immob_IM,se);
diffshow(immob_IM==1)=0.4;
diffshow(immob_IM==-1)=0.7;

immob_val=(sum(sum(((immob_IM).*(immob_IM)))))/r_IMonREAL.^2;


% save converted image for next loop
tempBW=bw;


%% EVALUATE FREEZING / IMMOBILITY

stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
centroids = cat(1, stats.Centroid);
maj = cat(1, stats.MajorAxisLength);
mini = cat(1, stats.MinorAxisLength);
rap=maj./mini;
centroids=centroids(rap<shape_ratio,:); %CHANGED

if size(centroids) == [1 2]
    x=centroids(1)/r_IMonREAL;
    y=centroids(2)/r_IMonREAL;
else
    x=NaN;
    y=NaN;
end
