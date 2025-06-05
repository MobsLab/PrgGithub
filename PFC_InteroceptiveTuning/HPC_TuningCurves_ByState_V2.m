function HPC_TuningCurves_ByState_V2(Parameter, Period,BinNumber,TempBinSize,SaveFolder)

%% Inputs
% Parameter : which paramater to study
%   - HR : heart rate
%   - BR : breathing rate
%   - speed : actually head mouvement of rnow because we don't have the
%   speed
%   - position : linear position, only works with UMaaze
%
% Period : which period in time
%   - Freezing : all freezing from the umaze conditionning
%   - Sleep : all sleep periods
%   - Wake : all wake
%   - Wake_Explo : all wake periods that do not involve freezing
%   - Habituation : All periods before fear so hab and test pre
%   - Conditionning : All the conditionning
%   - Conditionning_NoFreeze  : All the conditionning, no freezing
%   - Habituation_NoFreeze  : Habituation, no freezing
%   - Umaze_NoFreeze : UMaze (pre, cond, post), no freezing
%   - All
%

%%

% Basic parameters
% Basic parameters
Opts.Num_bootstraps = 100;
Opts.NeuronBins = [0:10]; 


Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);


% Right parameter
switch Parameter
    
    case 'BR'
        MinLim = 2.5;
        MaxLim = 11;
        StepSize = (MaxLim - MinLim) / BinNumber;
        Opts.ParamBinLims = [MinLim:StepSize:MaxLim];
    case 'HR'
        MinLim = 8;
        MaxLim = 13;
        StepSize = (MaxLim - MinLim) / BinNumber;
        Opts.ParamBinLims = [MinLim:StepSize:MaxLim];
        MiceNumber = MiceNumber(1:3);
    case 'speed'
    case 'position'
        MinLim = 0;
        MaxLim = 1;
        StepSize = (MaxLim - MinLim) / BinNumber;
        Opts.ParamBinLims = [MinLim:StepSize:MaxLim];
end

for mm = 1:length(MiceNumber)
    
    % Right periods
    cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data')
    switch Period
        case 'Freezing'
            SessionNames = {'Cond1','Cond2','Cond3','Cond4'};
            JustFreez = 1; % will just keep freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;

        case 'All_Home'
            SessionNames = {'PreSleep','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;


        case 'Sleep'
            SessionNames = {'PreSleep','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 1; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Wake_Home'
            SessionNames = {'PreSleep','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will just keep sleep from sleep sessions
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Wake'
            SessionNames = {'PreSleep','Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4' ,...
                'Cond1','Cond2','Cond3','Cond4','TestPost1','TestPost2','TestPost3','TestPost4','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Wake_Explo'
            SessionNames = {'PreSleep','Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4' ,...
                'Cond1','Cond2','Cond3','Cond4','TestPost1','TestPost2','TestPost3','TestPost4','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'All'
            SessionNames = {'PreSleep','Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4' ,...
                'Cond1','Cond2','Cond3','Cond4','TestPost1','TestPost2','TestPost3','TestPost4','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Habituation'
            SessionNames = {'Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Conditionning'
            SessionNames = {'Cond1','Cond2','Cond3','Cond4'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Conditionning_NoFreeze'
            SessionNames = {'Cond1','Cond2','Cond3','Cond4'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'Habituation_NoFreeze'
            SessionNames = {'Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'Umaze_NoFreeze'
            SessionNames = {'Hab1','Hab2' ,'TestPre1','TestPre2','TestPre3','TestPre4' ,...
                'Cond1','Cond2','Cond3','Cond4','TestPost1','TestPost2','TestPost3','TestPost4'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
    end
    
    % Get concatenated variables
    cd(AllMiceFolders{mm}{1})
    load('behavResources.mat', 'SessionEpoch')
    EpochOfInterest = intervalSet(0,0);
    for ss = 1:length(SessionNames)
        if strcmp(SessionNames{ss},'Hab1') | strcmp(SessionNames{ss},'Hab2')
            if isfield(SessionEpoch,'Hab1')
                EpochOfInterest = or(EpochOfInterest,SessionEpoch.(SessionNames{ss}));
            else
                EpochOfInterest = or(EpochOfInterest,SessionEpoch.Hab);
            end
        else
            EpochOfInterest = or(EpochOfInterest,SessionEpoch.(SessionNames{ss}));
        end
    end
    
    % NoiseEpoch
    load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
    TotalNoiseEpoch = and(TotalNoiseEpoch,EpochOfInterest);
    TotalEpoch = EpochOfInterest - TotalNoiseEpoch;
    
    if JustFreez
        % Freezing epoch
        load('behavResources.mat', 'FreezeAccEpoch')
        TotalEpoch = and(TotalEpoch,FreezeAccEpoch);
    elseif RemoveFreez
        % Freezing epoch
        load('behavResources.mat', 'FreezeAccEpoch')
        TotalEpoch = TotalEpoch - FreezeAccEpoch;
    end
    
    if JustSleep
        % Sleep epoch
        load('SleepScoring_OBGamma.mat', 'Wake')
        TotalEpoch = TotalEpoch -Wake; % remove wake
    elseif RemoveSleep
        % Sleep epoch
        load('SleepScoring_OBGamma.mat', 'Wake')
        TotalEpoch = and(TotalEpoch,Wake); % just the wake
    end
    
    
    % Deal with time
    % OB Spectrum - everything is realigned to this
    load('B_Low_Spectrum.mat')
    Sptsd_OB = tsd(Spectro{2}*1e4,(Spectro{1}));
    clear Spectro
    
    TimeBins = Range(Sptsd_OB);
    if TempBinSize>median(diff(TimeBins/1e4))
        SubSample = ceil(TempBinSize/median(diff(TimeBins/1e4)));
    else
        SubSample = 1;
    end
    Opts.TempBinsize = median(diff(TimeBins/1e4)*SubSample);
    
     % Spikes
    load('SpikeData.mat','S')
    
    % Main body parameter
    switch Parameter
        case 'BR'
            % InstFreq -  OB
            load('InstFreqAndPhase_B.mat', 'LocalFreq')

            instfreq_concat_PT = LocalFreq.PT;
            y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),TimeBins);
            instfreq_concat_PT = tsd(TimeBins,y);
            instfreq_concat_WV = LocalFreq.WV;
            instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(TimeBins));
            y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),TimeBins);
            y(y>15)=NaN;
            y=naninterp(y);
            instfreq_concat_WV = tsd(TimeBins,y);
            instfreq_concat_Both = tsd(TimeBins,nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
            VarOfInterest=Data(Restrict(instfreq_concat_Both,TotalEpoch));
            
        case 'HR'
            %  heartrate 
            load('HeartBeatInfo.mat')
            heartrate = EKG.HBRate;
            y=interp1(Range(heartrate),Data(heartrate),TimeBins);
            heartrate = tsd(TimeBins,y);
            VarOfInterest = Data(Restrict(heartrate,TotalEpoch));
                        
        case 'speed'
            % head mouvement (because we have ti in all mice)
            load('behavResources.mat', 'MovAcctsd')
            y=interp1(Range(MovAcctsd),Data(MovAcctsd),TimeBins);
            speed = tsd(TimeBins,y);
            speed = Data(Restrict(speed,TotalEpoch));
            speed(speed ==0) = NaN;
            VarOfInterest = log(speed);
            BinSize = (prctile(VarOfInterest,99)-prctile(VarOfInterest,1))/BinNumber;
            Opts.ParamBinLims = [prctile(VarOfInterest,1):BinSize:prctile(VarOfInterest,99)];
        
        case 'position'
            % position - only works in the maze
            load('behavResources.mat', 'LinearDist')
            y=interp1(Range(LinearDist),Data(LinearDist),TimeBins);
            linearposition = tsd(TimeBins,y);
            VarOfInterest = Data(Restrict(linearposition,TotalEpoch));
    end
    
    % get rid of ends
    VarOfInterest = VarOfInterest(3:end-3);
    
   
    
       % get the tuning curves and associated info
       for sp=1:length(S)
           [Y,X] = hist(Range(S{sp}),TimeBins);
           spike_count = tsd(X,Y');
           spike_dat = Data(Restrict(spike_count,TotalEpoch));
           spike_dat = spike_dat(3:end-3);
           [TuningCurves{mm}{sp},MutInfo{mm}{sp},CorrInfo{mm}{sp},...
               MutInfo_rand{mm}{sp},CorrInfo_rand{mm}{sp}] = GetTuningCurveDescriptions(spike_dat,VarOfInterest,Opts);
           
       end
end
save([SaveFolder filesep Parameter 'Tuning_',Period,'_HPC_',num2str(Opts.TempBinsize),'s_',num2str(BinNumber),'ParamBinNumber.mat'],'TuningCurves','MutInfo','CorrInfo','MutInfo_rand',...
    'CorrInfo_rand','Opts')

