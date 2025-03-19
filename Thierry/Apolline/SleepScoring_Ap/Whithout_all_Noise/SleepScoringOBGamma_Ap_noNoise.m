% SleepScoringOBGamma_Ap_noNoise
% 31.05.2018 AF
%
% SleepScoringOBGamma_Ap_noNoise('PlotFigure',1)
%
% !!! MODIFIED FONCTION WHITHOUT ALL NOISE !!!
%
% Sleep Scoring Using Olfactory Bulb and Hippocampal LFP
% This function creates SleepScoring_OBGamma with sleep scoring variables
%
%
%INPUTS
% PlotFigure (optional) = overview figrue of sleep scoring if 1; default is 1
%
%
% APADTED from BulbSleepScript
% CALLS FindNoiseEpoch_SleepScoringOBGamma_Ap ;
% FindThetaEpoch_SleepScoringOBGamma ; FindGammaEpoch_SleepScoringOBGamma ;
%
% SEE
%   SleepScoringAccelerometer
%


function SleepScoringOBGamma_Ap_noNoise(varargin)

%% INITITATION
disp('Performing sleep scoring with OB gamma')

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'plotfigure'
            PlotFigure = varargin{i+1};
            if PlotFigure~=0 && PlotFigure ~=1
                error('Incorrect value for property ''PlotFigure''.');
            end
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        case 'minduration'
            minduration = varargin{i+1};
            if minduration<0
                error('Incorrect value for property ''minduration''.');
            end
        case 'user_confirmation'
            user_confirmation = varargin{i+1};
            if user_confirmation~=0 && user_confirmation ~=1
                error('Incorrect value for property ''user_confirmation''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('PlotFigure','var')
    PlotFigure=1;
end
if ~exist('recompute','var')
    recompute=0;
end
if ~exist('minduration','var')
    minduration = 3;     % abs cut off duration for epochs (sec)
end
if ~exist('user_confirmation','var')
    user_confirmation=1;
end

%check if already exist
if ~recompute
    if exist(fullfile(cd,'SleepScoring_OBGamma_Ap_noNoise.mat'),'file')==2
        disp('Already computed! ')
        return
    end
end

% create file
Info.minduration=minduration;
save('SleepScoring_OBGamma_Ap_noNoise','Info')
clear Info

%% Load necessary channels

foldername=pwd;
if foldername(end)~=filesep
    foldername(end+1)=filesep;
end

% OB

cd ..
cd ..
if exist('ChannelsToAnalyse/Bulb_deep.mat','file')==2
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel_bulb=channel;
else
    error('No OB channel, cannot do sleep scoring');
end

% HPC
if exist('ChannelsToAnalyse/dHPC_deep.mat','file')==2
    load('ChannelsToAnalyse/dHPC_deep.mat')
    channel_hpc=channel;
elseif exist('ChannelsToAnalyse/dHPC_rip.mat','file')==2
    load('ChannelsToAnalyse/dHPC_rip.mat')
    channel_hpc=channel;
else
    error('No HPC channel, cannot do sleep scoring');
end
if isempty(channel_hpc)
    try
        load('ChannelsToAnalyse/dHPC_rip.mat')
        channel_hpc=channel;
    catch
        error('No HPC channel, cannot do sleep scoring');
    end
end

cd('Test_SleepScoring/Without_all_Noise')

%% Get Noise epochs & save
disp('NoiseEpochs')
[Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info_temp] = FindNoiseEpoch_SleepScoring_Ap_noNoise(channel_hpc, 'foldername', foldername, 'user_confirmation', user_confirmation);
Info=Info_temp; clear Info_temp;
save('SleepScoring_OBGamma_Ap_noNoise','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')

%% Find theta and gamma epochs

% Gamma epoch
disp('Gamma Epochs')
[Sleep,SmoothGamma,Info_temp]=FindGammaEpoch_SleepScoring_Ap_noNoise(Epoch, channel_bulb, minduration, 'foldername', foldername, 'user_confirmation', user_confirmation);
Info=ConCatStruct(Info,Info_temp); clear Info_temp;
save('SleepScoring_OBGamma_Ap_noNoise','Sleep','SmoothGamma','-append')

% Theta epoch
disp('Theta Epochs')
[ThetaEpoch,SmoothTheta, ~, Info_temp] = FindThetaEpoch_SleepScoring_Ap_noNoise(Sleep, channel_hpc, minduration, 'foldername', foldername, 'user_confirmation', user_confirmation);
Info=ConCatStruct(Info,Info_temp); clear Info_temp;
save('SleepScoring_OBGamma_Ap_noNoise','ThetaEpoch','SmoothTheta','-append')


%% Define behavioural epochs
[REMEpoch,SWSEpoch,Wake] = ScoreEpochs_SleepScoring(TotalNoiseEpoch, Epoch, Sleep, ThetaEpoch, minduration);
save('SleepScoring_OBGamma_Ap_noNoise','REMEpoch','SWSEpoch','Wake','-append')


%% save Info 
save('SleepScoring_OBGamma_Ap_noNoise','Info','-append')


%% Make sleep scoring figure if PlotFigure is 1
if PlotFigure==1
    % Calculate spectra if they don't alread exist
    if ~(exist(fullfile(cd,'H_Low_Spectrum_Ap_noNoise.mat'), 'file') == 2)
        LowSpectrumSB_Ap_noNoise(foldername,channel_hpc,'H');
    end
    if ~(exist(fullfile(cd,'B_High_Spectrum_Ap_noNoise.mat'), 'file') == 2)
        HighSpectrum_Ap_noNoise(foldername,channel_bulb,'B');
    end
    
    % Make figure
    Figure_SleepScoring_OBGamma_Ap_noNoise(foldername)
end

end


