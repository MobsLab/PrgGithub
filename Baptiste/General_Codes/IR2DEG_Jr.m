%Takes the path to the mouse folder and temperature values from infrared
%video, and converts it to degrees celcius.
%
function [Temp_body_InDegrees]=IR2DEG(FileName,TemperatureCurve)

    load('/home/mobsjunior/Dropbox/Kteam/IRCameraCalibration/CalibrationOct2017IRCamera.mat')
    TempOutput(isnan(ValuesInput))=[];
    ValuesInput(isnan(ValuesInput))=[];

    cd(FileName)
    load('behavResources.mat','frame_limits')
% 
%     if isfield(ExpeInfo,'RecordingRoom')
% 
%     switch ExpeInfo.RecordingRoom
%     
%         case '

    Temp_body_InDegrees = double(TemperatureCurve)./256;
    Temp_body_InDegrees = (Temp_body_InDegrees.*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
    Temp_body_InDegrees = interp1(ValuesInput,TempOutput, Temp_body_InDegrees);
end