% Adapted from SleepScoringAccelerometer by KJ

%INPUTS
% PlotFigure (optional) = overview figure of sleep scoring if 1; default is 1
%
%
% CALLS FindNoiseEpoch_SleepScoring ; 
% FindThetaEpoch_SleepScoring ; FindMovementAccelero_SleepScoring ;
%
% SEE
% SleepScoringOBGamma
%


function SleepScoringAccelerometer_UseOBNoise_CH(varargin)

%% INITITATION
disp('Performing sleep scoring with Accelerometer')

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

% %check if already exist
% if ~recompute
%     if exist('StateEpochSB.mat','ImmobilityEpoch')==2
%         disp('Already computed! ')
%         return
%     end
% end

% % create file
% save('SleepScoring_Accelero','')

%% Load necessary channels

foldername=pwd;
if foldername(end)~=filesep
    foldername(end+1)=filesep;
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


%% Get Noise epochs & save
% disp('NoiseEpochs')
load('StateEpochSB.mat','TotalNoiseEpoch','GndNoiseEpoch','NoiseThresh','WeirdNoiseEpoch','ThresholdedNoiseEpoch','Epoch',...
    'GndNoiseThresh','NoiseEpoch','ThresholdedNoiseEpochThresh','TotalEpoch','chH')
HighNoiseEpoch = NoiseEpoch;
HighNoiseThresh= NoiseThresh;
channel_HPC = chH;
if exist('WeirdNoiseEpoch')==0
   WeirdNoiseEpoch=intervalSet([],[]) ;
end
if exist('ThresholdedNoiseEpoch')==0
   ThresholdedNoiseEpoch=intervalSet([],[]) ;
end
if exist('ThresholdedNoiseEpochThresh')==0
   ThresholdedNoiseEpochThresh=NaN;
end

% Define total noise and epoch with no noise
TotalNoiseEpoch = or(or(GndNoiseEpoch,HighNoiseEpoch),or(WeirdNoiseEpoch,ThresholdedNoiseEpoch));
Epoch = TotalEpoch-TotalNoiseEpoch;

% Group the parameters together
Info_temp.GndNoiseThresh=GndNoiseThresh;
Info_temp.HighNoiseThresh=HighNoiseThresh;
Info_temp.ThresholdedNoiseEpochThresh=ThresholdedNoiseEpochThresh;

% Group the different NoiseEpochs together
SubNoiseEpoch.GndNoiseEpoch=GndNoiseEpoch;
SubNoiseEpoch.HighNoiseEpoch=HighNoiseEpoch;
SubNoiseEpoch.WeirdNoiseEpoch=WeirdNoiseEpoch;
SubNoiseEpoch.ThresholdedNoiseEpoch=ThresholdedNoiseEpoch;

Info=Info_temp; clear Info_temp;
% save('SleepScoring_Accelero','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')

%% Find theta and movement epochs

% Movement Epoch
disp('MovementAccelero')
[ImmobilityEpoch, MovementEpoch, tsdMovement, Info_temp] = FindMovementAccelero_SleepScoring(Epoch, 'user_confirmation', user_confirmation);
Info=ConCatStruct(Info,Info_temp); clear Info_temp;
save('StateEpochSB','ImmobilityEpoch', 'MovementEpoch','tsdMovement','-append')

SleepEpochAcc = ImmobilityEpoch;

% Theta epoch
disp('Theta Epochs')
load('StateEpochSB.mat','smooth_Theta','ThetaRatioTSD')
SmoothTheta = smooth_Theta;
% Get threshold
log_theta = log(Data(Restrict((SmoothTheta), SleepEpochAcc)));
theta_thresh = exp(GetThetaThresh(log_theta, 1, user_confirmation));

% define high theta epochs
ThetaEpochAcc = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');
ThetaEpochAcc = mergeCloseIntervals(ThetaEpochAcc, minduration*1E4);
ThetaEpochAcc = dropShortIntervals(ThetaEpochAcc, minduration*1E4);

%% generate output
Info_temp.theta_thresh = theta_thresh;
Info_temp.theta_mindur = minduration;
Info_temp.theta_HPC_channel = channel_HPC;

Info=ConCatStruct(Info,Info_temp); clear Info_temp;
save('StateEpochSB','ThetaEpochAcc','SmoothTheta', 'ThetaRatioTSD', 'Info', '-append')


%% Define behavioural epochs
[REMEpochAcc, SWSEpochAcc, WakeAcc] = ScoreEpochs_SleepScoringAcc(TotalNoiseEpoch, Epoch, SleepEpochAcc, ThetaEpochAcc, minduration, SmoothTheta);
save('StateEpochSB','REMEpochAcc','SWSEpochAcc','WakeAcc','-append')

% 
% %% save Info 
% save('StateEpochSB','Info','-append')


%% Make sleep scoring figure if PlotFigure is 1
if PlotFigure==1
    % Make figure
    ratio_display_movement = (max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(tsdMovement))-min(Data(tsdMovement)));
    Figure_SleepScoring_Accelero(ratio_display_movement, foldername)
end

end