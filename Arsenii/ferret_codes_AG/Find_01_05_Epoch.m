% [Epoch_01_05, smooth_01_05, Info] = Find_01_05_Epoch(SleepOB, Epoch, channel_bulb, minduration, varargin)
%
% This function calculates epochs of high 0.1-0.5Hz
%
%
%%INPUT
% Epoch             : denoised epochs
% SleepEpoch        : sleep epochs
% minduration       : minimal duration  of theta epochs
% channel_bulb      : OB channel
% foldername        : location of data & save location
%
%
%OUTPUT
% Epoch_01_05       : epoch of high 0.1-0.5 during sleep
% smooth_01_05      : tsd of 0.1-0.5 power used for scoring
% Info              : structure with all parameters used
%
%
% SEE
%   SleepScoringOBGamma
%

function [Epoch_01_05, smooth_01_05, Info] = Find_01_05_Epoch(SleepOB, Epoch, channel_bulb, minduration, varargin)

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'foldername'
            foldername = (varargin{i+1});
        case 'smoothwindow'
            smootime = (varargin{i+1});
        case 'continuity'
            continuity = (varargin{i+1});
            
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%%
% load HPC LFP
load(strcat([foldername,'LFPData/LFP',num2str(channel_bulb),'.mat']));
% Time = Range(LFP);

LFP = Restrict(LFP,Epoch); % added by BM on 01/09/2022

% params
try
    smootime;
catch
    smootime=10; % added by BM for homogeneity with Theta Epoch definition for ferrets
end


% Changed on 09/10/2024 by AG to align with SB SleepScoring
% load('StateEpochSB.mat','sleepper')
% load('SleepScoring_OBGamma.mat', 'Sleep')

% find 0.1-0.5 epochs

disp(' ');
disp('... Creating 0.1-0.5 Epochs ');
Fil_01_05=FilterLFP(LFP,[.5 4],1024); % changed by BM on 02/03/2025 to focus on OB delta
hilbert_01_05=abs(hilbert(Data(Fil_01_05)));
tot_01_05=Restrict(tsd(Range(LFP), hilbert_01_05), Epoch);

% smooth 0.1-0.5 power
smooth_01_05 = tsd(Range(tot_01_05),runmean(Data(tot_01_05),ceil(smootime/median(diff(Range(tot_01_05,'s'))))));

% Get threshold
log_01_05 = log(Data(Restrict(smooth_01_05,SleepOB)));
% Changed on 09/10/2024 by AG to align with SB SleepScoring
% thresh_01_05 = GetThetaThresh(log(Data(Restrict(smooth_01_05,sleepper))));
thresh_01_05 = exp(GetThetaThresh(log_01_05));

% "ThetaI" is changed for "minduration" by AG 17/10/24
Epoch_01_05=thresholdIntervals(smooth_01_05 , thresh_01_05,'Direction','Above');
% Epoch_01_05=mergeCloseIntervals(Epoch_01_05, minduration*1E4);
% Epoch_01_05=dropShortIntervals(Epoch_01_05, minduration*1E4);

disp('----------------------------------')
disp(' ')
disp(['Number of epochs after high thresholding:                ' num2str(length(Start(Epoch_01_05)))])

%% Continuity
if continuity
    Epoch_01_05 = dropShortIntervals(Epoch_01_05, 2*1E4);
    disp('     --- Fixing continuity issues ---')
    LongEpoch_01_05 = mergeCloseIntervals(Epoch_01_05, minduration*5*1E4); % long merge
    disp(['     Number of epochs after long merge:                   ' num2str(length(Start(LongEpoch_01_05)))])
    tmean = mean(Data(Restrict(smooth_01_05,SleepOB)));% find averaged theta
    nonEpoch_01_05 = thresholdIntervals(Restrict(smooth_01_05,LongEpoch_01_05), ...
        thresh_01_05-(tmean/2), 'Direction','Below'); % 2nd thresh
    Epoch_01_05 = mergeCloseIntervals(LongEpoch_01_05-nonEpoch_01_05, minduration*1E4);
    disp(['     Number of epochs after removal of non-0.1-0.5 epochs:  ' num2str(length(Start(Epoch_01_05)))])
    Epoch_01_05 = dropShortIntervals(Epoch_01_05, minduration*1E4);
    disp(['     Number of epochs after removal of short intervals:   ' num2str(length(Start(Epoch_01_05)))])
else
    disp('      Warning: not fixing continuity issues. ')
    disp('      To fix such issues relaunch the function including ''continuity'',''1'' as parameters')
end
disp(' ')
disp('----------------------------------')
% -------------------------------------------------------

Epoch_01_05 = mergeCloseIntervals(Epoch_01_05, minduration*1E4);
Epoch_01_05 = dropShortIntervals(Epoch_01_05, minduration*1E4);

%% generate output
Info.thresh_01_05 = thresh_01_05;
Info.mindur_01_05 = minduration;
Info.channel_bulb = channel_bulb;

% Changed on 09/10/2024 by AG to align with SB SleepScoring
% save(strcat(filename,'StateEpochSB'),'Epoch_01_05', 'smooth_01_05','thresh_01_05','ThetaI','-v7.3','-append');
% save(strcat(filename,'SleepScoring_OBGamma'),'Epoch_01_05', 'smooth_01_05','thresh_01_05','ThetaI','-v7.3','-append');

end