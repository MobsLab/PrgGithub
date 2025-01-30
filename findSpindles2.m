function tSpindles = findSpindles2(EEG, DetectThresholdSTD, LimitThresholdSTD, varargin)
% [S, E, M] = findRipples(Filt_EEG, DetectThreshold, LimitThreshold, varargin)
% 
% INPUTS: 
% Filt_EEG: EEG tsd 
% DetectThreshold: Threshold for detection of ripples 
% LimitThreshold: Threshold for finding the ripple boundaries
%
% PARAMETERS:
% Q1: number of cycles to check to find boundaries
% CloseThreshold: Closeness threhshold,if two ripple events are closer than
%   this,  lump them together
% MinRippleDuration: discard theta evants shorter than this
% OUTPUTS:
% S: ts object with spindles events start times
% E: ts object with spindles events end times
% M: ts object with spindles events peak times

% batta 1999
% status: beta


% parameters
Q1 = 4;
MinRippleDuration = 500 * 10;

%Extract_varargin;
% do it in chunks;
%MinRippleDuration


LIMmin=10; %default 8
LIMmax=20; %default 20

% Filt_EEG = filterEEG(EEG, 7, 0.5, 20, 10);
try
    Filt_EEG = FilterLFP(EEG, [LIMmin LIMmax], 1024);
catch
    Filt_EEG = FilterLFP(EEG, [LIMmin LIMmax], 128);
    disp('128')
end

EEGStart = StartTime(Filt_EEG);
EEGEnd = EndTime(Filt_EEG);

eegd=Data(Filt_EEG)';
td=Range(Filt_EEG,'s')';

 de = diff(eegd);
  de1 = [de 0];
  de2 = [0 de];
  
  %finding peaks
  upPeaksIdx = find(de1 < 0 & de2 > 0);
  downPeaksIdx = find(de1 > 0 & de2 < 0);
  
  PeaksIdx = [upPeaksIdx downPeaksIdx];
  PeaksIdx = sort(PeaksIdx);
  
  Peaks = eegd(PeaksIdx);
 %Peaks = abs(Peaks);
  
 tSpindlesTempIni=td(PeaksIdx);

DetectThreshold=mean(Data(Filt_EEG))+DetectThresholdSTD*std(Data(Filt_EEG));
LimitThreshold=mean(Data(Filt_EEG))+LimitThresholdSTD*std(Data(Filt_EEG));

% DetectThreshold=+mean(Data(Filt_EEG))+thD*std(Data(Filt_EEG));
%DetectThresholdT=mean(Data(Filt_EEGd))-thD*std(Data(Filt_EEGd));

% length(tDeltatemp)

ids=find((Peaks>DetectThreshold));
tSpindlesTemp=tSpindlesTempIni(ids);

idl=find((Peaks>LimitThreshold));
tSpindlesTempL=tSpindlesTempIni(idl);

burst = burstinfo(tSpindlesTemp, 0.5);

tSpindlesTemp=ts(tSpindlesTemp*1E4);
tSpindlesTempL=ts(tSpindlesTempL*1E4);
spiEpoch=intervalSet((burst.t_start-0.15)*1E4,(burst.t_end+0.15)*1E4);

tSpindlesTemp3=[];

% keyboard
for i=1:length(Start(spiEpoch))

    tSpindlesTemp2=Restrict(tSpindlesTempL,subset(spiEpoch,i));
%     length(Range(tSpindlesTemp2))
    if length(Range(tSpindlesTemp2))>2
    tSpindlesTemp3=[tSpindlesTemp3;Range(tSpindlesTemp2)];
    end
end


tSpindles=ts(sort(tSpindlesTemp3));

% keyboard



