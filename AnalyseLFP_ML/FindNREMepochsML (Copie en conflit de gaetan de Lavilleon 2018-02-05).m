function [op,NamesOp,Dpfc,Epoch]=FindNREMepochsML(SlowEpochType)

% [op,NamesOp,Dpfc]=FindNREMepochsML(Dirman,SlowEpochType)
%
% inputs:
% SlowEpochType (optional) = option in FindSlowOscBulb.m (default = 11)


%% INITIATION
disp('Running FindNREMepochsML.m')
if ~exist('SlowEpochType','var')
    SlowEpochType=11;
end
NamesOp = {'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'};  

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<< load delta PFCx and find BurstDeltaEpoch <<<<<<<<<<<

disp('... loading newDeltaPFCx PFCxDeep channel')
try
    load('newDeltaPFCx.mat','tDelta'); 
    Dpfc=ts(tDelta);
    disp('           run FindDeltaBurst2.m')
    BurstDeltaEpoch=FindDeltaBurst2(Dpfc,0.7,0);
catch
    disp('no delta -> cannot proceed to find NREMepochs');
end



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< Find sleepStages from PFCx <<<<<<<<<<<<<<<<

if exist('Dpfc','var') && ~isempty(tDelta)
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxDeep 
    [dSWS,dREM,dWAKE,dOsciEpoch]=FindSleepStageML('PFCx_Deep');
    Epoch=dSWS;
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxSup
    [sSWS,sREM,sWAKE,sOsciEpoch]=FindSleepStageML('PFCx_Sup');
end
    
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<< Find strong delta activity in PFCx <<<<<<<<<<<<

if exist('Dpfc','var') && ~isempty(tDelta) && exist('Epoch','var')
    try
        load('ChannelsToAnalyse/PFCx_deep.mat')
        disp(['... loading PFCx_deep SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])
        disp('... FindSlowOscBulb.m on PFCxDeep channel')
        [EpochSlowPF,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % PFCx slow oscill
        EpochSlowPF=EpochSlowPF{SlowEpochType};
    catch
        EpochSlowPF=intervalSet(NaN,NaN);
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< Find strong oscillation in OB <<<<<<<<<<<<<<

if exist('Dpfc','var') && ~isempty(tDelta) && exist('Epoch','var')
    
    clear channel Sp t f
    try
        load('ChannelsToAnalyse/Bulb_deep.mat')
        disp(['... loading Bulb_deep SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])
        disp('... FindSlowOscBulb.m on Bulb_deep channel')
        [EpochSlowOB,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % Bulb slow oscill
        EpochSlowOB=EpochSlowOB{SlowEpochType};
    catch
        EpochSlowOB=intervalSet(NaN,NaN);
    end
end



%% TERMINATION
   
if exist('Dpfc','var') && ~isempty(tDelta) && exist('Epoch','var')
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % raw epochs
    op{1}=sOsciEpoch; %S34
    op{2}=dOsciEpoch; %S34;
    op{3}=BurstDeltaEpoch; %N3
    op{4}=dREM;
    op{5}=dWAKE;
    op{6}=dSWS;
    op{7}=EpochSlowPF; %PFCx
    op{8}=EpochSlowOB; %OB 
else
    op={};
end


if ~exist('Dpfc','var')
    Dpfc=ts([]);
end
if ~exist('Epoch','var')
    Epoch=intervalSet([],[]);
end
