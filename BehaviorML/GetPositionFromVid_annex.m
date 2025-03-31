temp=load('InfoTrackingTemp.mat');

IMref=temp.ref;
mask=temp.mask;
shape_ratio=temp.shape_ratio;
th_ObjSize=temp.smaller_object_size;
th_BW=temp.BW_threshold;
VideoParams=[temp.b_default, temp.c_default, temp.e_default];


save InfoVideoTemp IMref mask shape_ratio th_ObjSize th_BW VideoParams

% in case plantage => reset video on VideoParams !


% in Gen_code_ML3 

%start video
imaqreset;
vid = videoinput('winvideo',1,'RGB24_320x240');
src = getselectedsource(vid);
nameParams={'BacklightCompensation','Brightness','Contrast','Exposure','ExposureMode',...
    'Focus','FocusMode','FrameRate','Gain','HorizontalFlip','Pan','Saturation',...
    'Sharpness','Tilt','VerticalFlip','WhiteBalance','WhiteBalanceMode','Zoom'};
defaultValues={'on',128,32,-7,'auto',51,'auto','30.0000',64,'off',0,32,...
    22,0,'off',4000,'auto',1};
try
    tempInfo=load('InfoTrackingTemp.mat');
    for dd=1:length(nameParams)
        eval(['defaultValues{dd}=tempInfo.VideoParams.',nameParams{dd},';']);
    end
    disp('Video parameters from last session has been reloaded');
end

VideoParams=get(src);
save('InfoTrackingTemp.mat','VideoParams','-append');



set(src,'Brightness',b_default);
set(src,'Contrast',c_default);
set(src,'Exposure',e_default);
disp('Video Object Created');
set(vid,'FramesPerTrigger',1); % Acquire only one frame each time
set(vid,'TriggerRepeat',Inf); % Go on forever until stopped
set(vid,'ReturnedColorSpace','grayscale'); % Get a grayscale image : less computation time
disp('Parameters set');
save('InfoTrackingTemp.mat','b_default','c_default','e_default','-append');