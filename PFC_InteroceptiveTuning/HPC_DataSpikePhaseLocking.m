function  [spikephase,spikefreq] = HPC_DataSpikePhaseLocking(Parameter, Period,Opts)


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
        MaxLim = 12;
        StepSize = (MaxLim - MinLim) / Opts.BinNumber;
        Opts.ParamBinLims = [MinLim:StepSize:MaxLim];
    case 'HR'
        MinLim = 8;
        MaxLim = 14;
        StepSize = (MaxLim - MinLim) / Opts.BinNumber;
        Opts.ParamBinLims = [MinLim:StepSize:MaxLim];
        MiceNumber = MiceNumber(1:3);
  
end

    
    % Right periods
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

 for mm = 1:length(MiceNumber)
   
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
    load('B_Low_Spectrum.mat');
    Sptsd_OB = tsd(Spectro{2}*1e4,Spectro{1});
    clear Spectro
    
    
    TimeBins = Range(Sptsd_OB);
    if Opts.TempBinsize>(median(diff(TimeBins/1e4))+0.01) % to take care of rounding error
        SubSample = ceil(Opts.TempBinsize/median(diff(TimeBins/1e4)));
    else
        SubSample = 1;
    end
    TempBinsize = median(diff(TimeBins/1e4)*SubSample);
    TimeBins = TimeBins(1:SubSample:end);
    
    
    % Spikes
    load('SpikeData.mat','S')
    
    % Main body parameter
    switch Parameter
        case 'BR'
            % InstFreq -  OB
            load('InstFreqAndPhase_B.mat', 'LocalFreq')
            instfreq_concat_PT = LocalFreq.PT;
            % smooth according to timebin
            instfreq_concat_PT  = ReSampleDataInTime_ForPFCInterTuning(instfreq_concat_PT,SubSample,TimeBins,Opts.TempBinsize);
            instfreq_concat_WV = LocalFreq.WV;
            % smooth according to timebin
            instfreq_concat_WV  = ReSampleDataInTime_ForPFCInterTuning(instfreq_concat_WV,SubSample,TimeBins,Opts.TempBinsize);
            % Sort out big errors in frequency estimate
            y = Data(instfreq_concat_WV);
            y(y>15)=NaN;
            y=naninterp(y);
            instfreq_concat_WV = tsd(TimeBins,y);
            instfreq_concat_Both = tsd(TimeBins,nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
            load('InstFreqAndPhase_B_SpikeLocking.mat')
            spikephase{mm} = PhaseSpikes;
   for sp = 1:length(spikephase{mm}.WV)
                spikephase{mm}.PT{sp}.Transf = Restrict(spikephase{mm}.PT{sp}.Transf,TotalEpoch);
                spikephase{mm}.WV{sp}.Transf = Restrict(spikephase{mm}.WV{sp}.Transf,TotalEpoch);
                spikephase{mm}.PT{sp}.Nontransf = Restrict(spikephase{mm}.PT{sp}.Nontransf,TotalEpoch);
                spikephase{mm}.WV{sp}.Nontransf = Restrict(spikephase{mm}.WV{sp}.Nontransf,TotalEpoch);
                spikefreq{mm}{sp} = Restrict(instfreq_concat_Both,ts(Range(spikephase{mm}.WV{sp}.Transf)));
            end
            

        case 'HR'
            %  heartrate
            load('HeartBeatInfo.mat')
            heartrate = EKG.HBRate;
            heartrate  = ReSampleDataInTime_ForPFCInterTuning(heartrate,SubSample,TimeBins,Opts.TempBinsize);
            load('HeartBeatPhaseLocing_Spikes.mat')
            spikephase{mm} = PhaseSpikes;
            for sp = 1:length(spikephase{mm})
                spikephase{mm}{sp}.Transf = Restrict(spikephase{mm}{sp}.Transf,TotalEpoch);
                spikephase{mm}{sp}.Nontransf = Restrict(spikephase{mm}{sp}.Nontransf,TotalEpoch);
                spikefreq{mm}{sp} = Restrict(heartrate,ts(Range(spikephase{mm}{sp}.Transf)));
            end
    end
    
  
end

   


end








