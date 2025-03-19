%% load IR calibration to convert in degrees
load('/home/mobshamilton/Dropbox/Kteam/IRCameraCalibration/CalibrationIR_August2018.mat');

load('behavResources.mat','PosMat','GotFrame','frame_limits','mask','Xtsd')

%% get temperature from video
OBJ = VideoReader('F10122020-0000.avi');

%%use the mask limit to restrict the analysis to the mouse of interest
mask_conv = im2double(mask);
y1 = find(mean(mask_conv));
x1 = find(mean(mask_conv'));
    
%%
i=1;
while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(x1,y1,1));
    MouseTemp(i) = max(max(vidFrame));
    i=i+1;
end
TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];

MouseTemp_inDouble = im2double(MouseTemp); %%convert values in uint8 in double

%%
%%convert temperature in degrees
MouseTemp1 = (MouseTemp_inDouble*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
MouseTemp_InDegrees = interp1(ValuesInput,TempOutput, MouseTemp1);

%%save
save('behavResources.mat','MouseTemp_InDegrees','-append')
% save('behavResources_Offline.mat','MouseTemp_InDegrees','-append')

%%make TSD
VideoTimes=Range(Xtsd); 
MouseTemp_tsd=tsd(VideoTimes,MouseTemp_InDegrees');

save('behavResources.mat','MouseTemp_tsd','-append')
% save('behavResources_Offline.mat','MouseTemp_tsd','-append')