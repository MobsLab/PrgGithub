function RecalcTemperatureFromVideo_SB(CalibrationFileName)

% CalibrationFileName is 'CalibrationOct2017IRCamera' or
% 'CalibrationIR_August2018'

load([dropbox '/Kteam/IRCameraCalibration/' CalibrationFileName])
TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];


load('behavResources.mat','PosMat','frame_limits','GotFrame','mask')
VideoFiles = dir('*.avi');
frame = 1;
clear Temp
for v=1:length(VideoFiles)
    disp(['Processing ', VideoFiles(v).name])
    CurrVideo = VideoReader(VideoFiles(v).name);
    
    while(hasFrame(CurrVideo))
        fr = readFrame(CurrVideo);
        fr = double(squeeze(fr(:,:,1)));
        fr = double(fr)/256;
        fr = (fr*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
        Temp(frame) = max(max(fr.*double(mask)));
        frame = frame+1;
    end
    
end

Temp = interp1(ValuesInput,TempOutput, Temp);
MouseTemp_InDegrees(:,2) = Temp;
if length(GotFrame)>size(PosMat,1)
GotFrame(1) = [];
end
if sum(GotFrame) == size(Temp,2)
MouseTemp_InDegrees(:,1) = PosMat(find(GotFrame),1);    
end

save('behavResources.mat','MouseTemp_InDegrees','-append')


end
