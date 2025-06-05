
% This function calculates epochs of high delta (0.5-4Hz)
%

function [Epoch_Delta, smooth_Delta, Info] = Find_Delta_Epoch(SleepOB, Epoch, channel_bulb, minduration, varargin)

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
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDelta  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

Delta_thresh = GetGaussianThresh_BM(log10(Data(Restrict(SmoothDelta , SWSEpoch))), 0, 1);
Delta_thresh = 10^Delta_thresh;

Epoch_Delta = thresholdIntervals(SmoothDelta , Delta_thresh , 'Direction','Above');

disp('----------------------------------')
disp(' ')
disp(['Number of epochs after high thresholding:       ' num2str(length(Start(Epoch_Delta)))])

%% Continuity
if continuity
    Epoch_Delta = dropShortIntervals(Epoch_Delta, 2*1E4);
    disp('     --- Fixing continuity issues ---')
    LongEpoch_Delta = mergeCloseIntervals(Epoch_Delta, minduration*5*1E4); % long merge
    disp(['     Number of epochs after long merge:                   ' num2str(length(Start(LongEpoch_Delta)))])
    tmean = mean(Data(Restrict(smooth_Delta,SleepOB)));% find averaged theta
    nonEpoch_Delta = thresholdIntervals(Restrict(smooth_Delta,LongEpoch_Delta), ...
        thresh_Delta-(tmean/2), 'Direction','Below'); % 2nd thresh
    Epoch_Delta = mergeCloseIntervals(LongEpoch_Delta-nonEpoch_Delta, minduration*1E4);
    disp(['     Number of epochs after removal of non-0.1-0.5 epochs:  ' num2str(length(Start(Epoch_Delta)))])
    Epoch_Delta = dropShortIntervals(Epoch_Delta, minduration*1E4);
    disp(['     Number of epochs after removal of short intervals:   ' num2str(length(Start(Epoch_Delta)))])
else
    disp('      Warning: not fixing continuity issues. ')
    disp('      To fix such issues relaunch the function including ''continuity'',''1'' as parameters')
end
disp(' ')
disp('----------------------------------')
% -------------------------------------------------------

Epoch_Delta = mergeCloseIntervals(Epoch_Delta, minduration*1E4);
Epoch_Delta = dropShortIntervals(Epoch_Delta, minduration*1E4);

%% generate output
Info.thresh_Delta = thresh_Delta;
Info.mindur_Delta = minduration;
Info.channel_bulb = channel_bulb;

% Changed on 09/10/2024 by AG to align with SB SleepScoring
% save(strcat(filename,'StateEpochSB'),'Epoch_Delta', 'smooth_Delta','thresh_Delta','ThetaI','-v7.3','-append');
% save(strcat(filename,'SleepScoring_OBGamma'),'Epoch_Delta', 'smooth_Delta','thresh_Delta','ThetaI','-v7.3','-append');

end