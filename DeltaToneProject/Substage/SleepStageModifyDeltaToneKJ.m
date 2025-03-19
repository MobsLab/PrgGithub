% SleepStageModifyDeltaToneKJ
%
% 14.06.2017 KJ
%
% - Classification of sleep stages after removing delta waves induced by
% tones/sham
%
%
% See 
%   FindSleepStageML
%
%



function [op,NamesOp,Dpfc,Epoch,noise,opNew]=SleepStageModifyDeltaToneKJ(tEvents, modification)

% [op,NamesOp,Dpfc]=FindNREMepochsML(Dirman,SlowEpochType)
%
% inputs:
%   tEvents - ts: Tones or Sham events
%   modification - string: 'add', 'remove' (default: 'remove')
%
% SlowEpochType (optional) = option in FindSlowOscBulb.m (default = 11)


%% INITIATION
disp('Running FindNREMepochsML.m')

NamesOp = {'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','SIEpoch','PFswa','OBswa'};

if ~exist('modification','var')
    modification = 'remove';
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< Find sleepStages from PFCx <<<<<<<<<<<<<<<<
try
    %temp=load('newDeltaPFCx.mat','tDelta'); temp.tDelta;
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxDeep
    try
        [dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deltadeep');
        if isempty(Start(dSWS)); error;end
    catch
        [dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deep');
    end
    %Epoch=dSWS;
    Epoch=Immob-noise;
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % sleepStages from PFCxSup
    try
        [sSWS,sREM,sWAKE,sOsciEpoch]=FindSleepStageML('PFCx_deltasup'); 
        if isempty(Start(sSWS)); 
            error;
        end
    catch
        [sSWS,sREM,sWAKE,sOsciEpoch]=FindSleepStageML('PFCx_sup');
    end
catch
    disp('no delta, run FindDeltaWavesChanGL')
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<< load delta PFCx and find BurstDeltaEpoch <<<<<<<<<<<

disp('... loading AllDeltaPFCx PFCxDeep channel')
if exist('Epoch','var')
    
    [tDelta,DeltaEpoch]=GetDeltaML('PFCx',Epoch,dSWS,1); %new method
    
    %% Add/Remove delta
    effect_period = 2000;
    start_deltas = Start(DeltaEpoch);
    events_tmp = Range(tEvents);
    
    event_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Sham and its window where an effect could be observed
    [status,~,~] = InIntervals(start_deltas, [Start(event_intv_post) End(event_intv_post)]);
    
    %remove deltas after events
    tDelta(status==1)=[];
    %add eventually
    if strcmpi(modification,'add')
        tDelta = sort([tDelta;events_tmp+1000]);
    end
        
    %% tDelta in 1E-4ms, middle of period above 2SD.
    Dpfc=ts(tDelta); 
    if ~isempty(tDelta) 
        disp('           run FindDeltaBurst2.m')
        BurstDeltaEpoch=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,0);
        BurstDeltaEpochNew1=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,1);
        BurstDeltaEpochNew2=FindDeltaBurst2(Restrict(Dpfc,Epoch),1,0);
        BurstDeltaEpochNew3=FindDeltaBurst2(Restrict(Dpfc,Epoch),1,1);
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<< Find strong delta activity in PFCx <<<<<<<<<<<<

if exist('Dpfc','var') && exist('tDelta','var') && ~isempty(tDelta) 
    try
        temp=load('ChannelsToAnalyse/PFCx_deep.mat');
        disp(['... loading PFCx_deep SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'])
        eval(['temp=load(''SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'');'])
        disp('... FindSlowOscBulb.m on PFCxDeep channel')
        
        %[EpochSlowPF,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % PFCx slow oscill
        %EpochSlowPF=EpochSlowPF{SlowEpochType};
        EpochSlowPF=FindSlowOscML(temp.Sp,temp.t,temp.f); % !!! not restricted to SWS !!!
        disp('Done.');close
    catch
        EpochSlowPF=intervalSet(NaN,NaN);
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< Find strong oscillation in OB <<<<<<<<<<<<<<

if exist('Dpfc','var') && ~isempty(tDelta) 
    
    clear channel Sp t f
    try
        temp=load('ChannelsToAnalyse/Bulb_deep.mat');
        disp(['... loading Bulb_deep SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'])
        eval(['temp=load(''SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'');'])
        disp('... FindSlowOscBulb.m on Bulb_deep channel')
        %         [EpochSlowOB,val,val2]=FindSlowOscBulb(Sp,t,f,Epoch,1,[5 6]); % Bulb slow oscill
        %         EpochSlowOB=EpochSlowOB{SlowEpochType};
        EpochSlowOB=FindSlowOscML(temp.Sp,temp.t,temp.f); % !!! not restricted to SWS !!!
        disp('Done.')
    catch
        EpochSlowOB=intervalSet(NaN,NaN);
    end
end



%% TERMINATION

if exist('Dpfc','var') && ~isempty(tDelta) && exist('Epoch','var')
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    try
        % raw epochs
        op{1}=sOsciEpoch; %S34
        op{2}=dOsciEpoch; %S34;
        op{3}=BurstDeltaEpoch; %N3
        op{4}=dREM;
        op{5}=dWAKE;
        op{6}=dSWS;
        op{7}=SIEpoch;% short immobility
        op{8}=EpochSlowPF; %PFCx
        op{9}=EpochSlowOB; %OB
    catch
        keyboard
    end
    
    try
        opNew=op;
        opNew{10}=BurstDeltaEpochNew1; %N3etN4
        opNew{11}=BurstDeltaEpochNew2; %N3etN4
        opNew{12}=BurstDeltaEpochNew3; %N3etN4
    end
else
    op={};opNew={};
end

if ~exist('Epoch','var')
    Epoch=intervalSet([],[]);
end
if ~exist('noise','var')
    noise=intervalSet([],[]);
end
%% FUNCTION FindSlowOscML

    function EpochSlow=FindSlowOscML(Sp,t,f)
        
        % parameters
        lim1=[2 4]; % band of interest
        lim2=[0.5 1.5]; % lower band
        lim3=[4.5 6]; % upper band
        th=2;
        
        % spectrograms value corresponding to those bands 
        V1=mean(Sp(:,f>lim1(1)&f<lim1(2)),2);
        V2=mean(Sp(:,f>lim2(1)&f<lim2(2)),2);
        V3=mean(Sp(:,f>lim3(1)&f<lim3(2)),2);
        
        % find slow osc epoch
        Vts1=tsd(t*1E4,(V1./V2));
        EpochSlow1=thresholdIntervals(Vts1,1.1,'Direction','Above');
        Vts2=tsd(t*1E4,(V1./V3));
        EpochSlow2=thresholdIntervals(Vts2,th,'Direction','Above');
        
        EpochSlow=and(EpochSlow1,EpochSlow2);
        EpochSlow=mergeCloseIntervals(EpochSlow,1E4);
        EpochSlow=dropShortIntervals(EpochSlow,1E4);
        
        I=intervalSet(t(1)*1E4,t(end)*1E4);
        val=100*sum(Stop(EpochSlow)-Start(EpochSlow))/sum(Stop(I)-Start(I));
        
        disp(sprintf('FindSlowOscML: %1.1f percent of epoch',val))
    end
end





