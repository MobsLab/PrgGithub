% SleepScoring_Accelero_OBgamma
% 01.12.2017 SB
%
% SleepScoring_Accelero_OBgamma('PlotFigure',1)
%
% Sleep Scoring Using Olfactory Bulb and Hippocampal LFP
% This function creates SleepScoring_OBGamma with sleep scoring variables
%
%
%INPUTS
% PlotFigure (optional) = overview figrue of sleep scoring if 1; default is 1
%
%
% SEE
%   SleepScoringAccelerometer SleepScoringOBGamma
%


function SleepScoring_Accelero_OBgamma_AddToFlx_SB(varargin)

%% INITITATION
disp('Performing sleep scoring with OB gamma and with Accelerometer')

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
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('PlotFigure','var')
    PlotFigure=1;
end
%recompute?
if ~exist('recompute','var')
    recompute=0;
end

% params
minduration = 3;     % abs cut off duration for epochs (sec)

%check if already exist
if ~recompute
    if exist('SleepScoring_OBGamma.mat','file')==2 && exist('SleepScoring_Accelero.mat','file')==2
        disp('Scoring both already generated')
        return
    end
end

% create file
Info.minduration=minduration;
save('SleepScoring_OBGamma','Info')

save('SleepScoring_Accelero','Info')
clear Info

%% Load necessary channels

foldername=pwd;
if foldername(end)~=filesep
    foldername(end+1)=filesep;
end

% OB
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


%% Get Noise epochs & save
disp('NoiseEpochs')
clear('GndNoiseEpoch','GndNoiseThresh','Epoch','ThresholdedNoiseEpoch','ThresholdedNoiseEpochThreshold','NoiseEpoch','NoiseThresh','TotalNoiseEpoch','ThresholdedNoiseEpochThresh','HighNoiseThresh','HighNoiseEpoch')

if exist([cd filesep 'StateEpochSB.mat'])>0
    
    load('StateEpochSB.mat','GndNoiseEpoch','Epoch','GndNoiseThresh','ThresholdedNoiseEpoch','ThresholdedNoiseEpochThreshold','NoiseEpoch','NoiseThresh','TotalNoiseEpoch')
    HighNoiseThresh = NoiseThresh;
    HighNoiseEpoch = NoiseEpoch;
    WeirdNoiseEpoch = intervalSet(0,0.1);
    ThresholdedNoiseEpochThresh = ThresholdedNoiseEpochThreshold;
    % Group the parameters together
    Info_temp.GndNoiseThresh=GndNoiseThresh;
    Info_temp.HighNoiseThresh=HighNoiseThresh;
    Info_temp.ThresholdedNoiseEpochThresh=ThresholdedNoiseEpochThresh;
    
    % Group the different NoiseEpochs together
    SubNoiseEpoch.GndNoiseEpoch=GndNoiseEpoch;
    SubNoiseEpoch.HighNoiseEpoch=HighNoiseEpoch;
    SubNoiseEpoch.WeirdNoiseEpoch=WeirdNoiseEpoch;
    SubNoiseEpoch.ThresholdedNoiseEpoch=ThresholdedNoiseEpoch;
    
        Info_OB = Info_temp;
        Info_accelero = Info_temp;

    clear Info_temp
    save('SleepScoring_OBGamma','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')
    save('SleepScoring_Accelero','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')
    clear('GndNoiseEpoch','GndNoiseThresh','WeirdNoiseEpoch','ThresholdedNoiseEpoch','ThresholdedNoiseEpochThreshold','NoiseEpoch','NoiseThresh','ThresholdedNoiseEpochThresh','HighNoiseThresh','HighNoiseEpoch')

else
    
    [Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info_temp] = FindNoiseEpoch_SleepScoring(channel_hpc, 'foldername', foldername);
    Info_OB = Info_temp;
    Info_accelero = Info_temp;
    
    clear Info_temp
    save('SleepScoring_OBGamma','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')
    save('SleepScoring_Accelero','Epoch','SubNoiseEpoch','TotalNoiseEpoch','-append')
end

%% Find gamma epochs
disp('Gamma Epochs')
[SleepOB,SmoothGamma,Info_temp]=FindGammaEpoch_SleepScoring(Epoch, channel_bulb, minduration, 'foldername', foldername);
Info_OB=ConCatStruct(Info_OB,Info_temp); clear Info_temp;

Sleep = SleepOB;
save('SleepScoring_OBGamma','Sleep','SmoothGamma','-append');
clear Sleep


%% Find immobility epochs
[ImmobilityEpoch, MovementEpoch, tsdMovement, Info_temp] = FindMovementAccelero_SleepScoring;
Info_accelero=ConCatStruct(Info_accelero,Info_temp); clear Info_temp;
save('SleepScoring_Accelero','ImmobilityEpoch','tsdMovement', 'MovementEpoch','-append');


%% Find Theta epoch
disp('Theta Epochs')

% restricted to sleep with OB gamma
[ThetaEpoch_OB, SmoothTheta, ~, Info_temp] = FindThetaEpoch_SleepScoring(SleepOB, channel_hpc, minduration, 'foldername', foldername);
Info_OB=ConCatStruct(Info_OB,Info_temp); clear Info_temp;
ThetaEpoch = ThetaEpoch_OB;
save('SleepScoring_OBGamma','ThetaEpoch','SmoothTheta','-append');
clear ThetaEpoch;

% restricted to immobility epoch
[ThetaEpoch_acc, SmoothTheta, ThetaRatioTSD, Info_temp] = FindThetaEpoch_SleepScoring(ImmobilityEpoch, channel_hpc, minduration,...
    'foldername', foldername);
Info_accelero = ConCatStruct(Info_accelero,Info_temp); clear Info_temp;
ThetaEpoch = ThetaEpoch_acc;
save('SleepScoring_Accelero','ThetaEpoch','SmoothTheta', 'ThetaRatioTSD', '-append');
clear ThetaEpoch;


%% Define behavioural epochs
[REMEpoch,SWSEpoch,Wake] = ScoreEpochs_SleepScoring(TotalNoiseEpoch, Epoch, SleepOB, ThetaEpoch_OB, minduration);
save('SleepScoring_OBGamma','REMEpoch','SWSEpoch','Wake','-append');

[REMEpoch,SWSEpoch,Wake] = ScoreEpochs_SleepScoring(TotalNoiseEpoch, Epoch, ImmobilityEpoch, ThetaEpoch_acc, minduration);
save('SleepScoring_Accelero','REMEpoch','SWSEpoch','Wake','-append')


%% save Info 
Info = Info_OB;
save('SleepScoring_OBGamma','Info','-append')
Info = Info_accelero;
save('SleepScoring_Accelero','Info','-append')


%% Make sleep scoring figure if PlotFigure is 1
if PlotFigure==1
    
    %OB
    % Calculate spectra if they don't alread exist
    if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
        LowSpectrumSB(foldername,channel_hpc,'H');
    end
    if ~(exist('B_High_Spectrum.mat', 'file') == 2)
        HighSpectrum(foldername,channel_bulb,'B');
    end
    % Make figure
    Figure_SleepScoring_OBGamma(foldername)
    
    %Accelerometer
    % Make figure
    ratio_display_movement = (max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(tsdMovement))-min(Data(tsdMovement)));
    Figure_SleepScoring_Accelero(ratio_display_movement, foldername)
    
end


end


