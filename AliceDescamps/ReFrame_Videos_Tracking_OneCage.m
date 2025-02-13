%% load IR calibration to convert in degrees
load('/home/mobshamilton/Dropbox/Kteam/IRCameraCalibration/CalibrationIR_August2018.mat');

load('behavResources.mat','PosMat','GotFrame','frame_limits','mask','Xtsd')

%% get temperature from video
OBJ = VideoReader('F03042024-0000.avi');
outputVideo = VideoWriter('F03042024-0000_zoom', 'Uncompressed AVI'); 
open(outputVideo);

%%use the mask limit to restrict the analysis to the mouse of interest
mask_conv = im2double(mask);
y1 = find(mean(mask_conv));
x1 = find(mean(mask_conv'));
    
%%
figure
i=1;
subplot(2,2,[1 3])
while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(x1,y1,1));
    writeVideo(outputVideo, vidFrame);
    imagesc(vidFrame)
    i=i+1;
end
close(outputVideo);
