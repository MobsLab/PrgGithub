% Figure_SleepScoring_EMG
% 28/03/2025 SB
%
%
% This function makes an overview of sleep scoring using the accelerometer
%
%%INPUT
% coeff_display     : coefficient for the display of signals
% foldername        : location of data & save location
%
%
% SEE
%   SleepScoringAccelerometer Figure_SleepScoring_OBGamma
%


function VerifyScoringManual_VeroniqueData


%% INITIATION
foldername = pwd;

if foldername(end)~=filesep
    foldername(end+1) = filesep;
end


% load sleep scoring info
load([foldername 'SleepScoring_EMG'])
if exist('ManuallyCorrectedSleecpScoring.mat')
    load('ManuallyCorrectedSleecpScoring.mat','REMEpoch','SWSEpoch','Wake','ii_curr')
    ii_start = ii_curr;
    clear ii_curr;
else
    ii_start = 1;
end
% load HPC spectrum
load([foldername,'H_Low_Spectrum.mat']);
sptsdH = tsd(Spectro{2}*1e4,Spectro{1});
fH = Spectro{3};
clear Spectro

% load EEG
load('LFPData/LFP3.mat')
EEG = LFP;


% theta power : restrict to non-noisy epoch
SmoothThetaNew = Restrict(SmoothTheta,Epoch);
t = Range(SmoothThetaNew);
ti = t(5:1200:end);
SmoothThetaNew = (Restrict(SmoothThetaNew,ts(ti)));


%% Display one REMEpoch at a time
REMStart = Start(REMEpoch);
SleepScoringFigure = figure;
set(SleepScoringFigure,'color',[1 1 1],'Position',[1 1 1600 600])
TotalEpoch = intervalSet(min(Range(SmoothThetaNew)),max(Range(SmoothThetaNew)));

disp(['Starting at ' num2str(ii_start)])
for ii = ii_start:length(REMStart)
    
    Epoch = intervalSet(REMStart(ii)-100*1e4, REMStart(ii)+100*1e4);
    MakeSleepScoringFigure_VeroniqueData_CorrectREM(SleepScoringFigure,Epoch,sptsdH,EMGData,SmoothThetaNew,...
        REMEpoch,SWSEpoch,Wake,fH,Info,EEG)
    
    
    happy = input('are you happy? 0/1');
    if happy ==0
        while happy ==0
            subplot(5,1,1)
            title('Please choose zone to delete old REM ')
            [time_oldREM,~] = ginput(2);
            title('Please redefine REM , choose as many episodes as you want')
            [time,~] = ginput;
            for lg = 1:length(time)/2
            UserDefinedREM = intervalSet(time((lg-1)*2+1)*3600*1e4,time((lg-1)*2+2)*3600*1e4);
            end
            NewREMEpoch = REMEpoch - intervalSet(time_oldREM(1)*3600*1e4,time_oldREM(2)*3600*1e4);
            NewREMEpoch = or(NewREMEpoch,intervalSet(time(1)*3600*1e4,time(2)*3600*1e4));
            NewWakeEpoch = Wake - UserDefinedREM;
            NewSWSEpoch = (TotalEpoch - NewWakeEpoch) - NewREMEpoch;
            
            MakeSleepScoringFigure_VeroniqueData_CorrectREM(SleepScoringFigure,Epoch,sptsdH,EMGData,SmoothThetaNew,...
                NewREMEpoch,NewSWSEpoch,NewWakeEpoch,fH,Info,EEG)
            happy = input('are you happy? 0/1');
        end
        REMEpoch = NewREMEpoch;
        Wake = NewWakeEpoch;
        SWSEpoch = NewSWSEpoch;
    end
    ii_curr = ii;
    save('ManuallyCorrectedSleecpScoring.mat','REMEpoch','SWSEpoch','Wake','ii_curr')
    
    
end

