function HPC_TuningCurves_ByState(Parameter, Period,BinNumber,SaveFolder)

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
num_bootstraps = 100;
Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);
NeuronBins = [0:10];


% Right parameter
switch Parameter
    
    case 'BR'
        MinLim = 2.5;
        MaxLim = 11;
        StepSize = (MaxLim - MinLim) / BinNumber;
        BinLims = [MinLim:StepSize:MaxLim];
        MiceNumber=[490,507,508,509,510,512,514];
    case 'HR'
        MinLim = 6;
        MaxLim = 13;
        StepSize = (MaxLim - MinLim) / BinNumber;
        BinLims = [MinLim:StepSize:MaxLim];
        MiceNumber=[507,508,509,510];
    case 'speed'
        MiceNumber=[490,507,508,509,510,512,514];
    case 'position'
        MinLim = 0;
        MaxLim = 1;
        StepSize = (MaxLim - MinLim) / BinNumber;
        BinLims = [MinLim:StepSize:MaxLim];
        MiceNumber=[490,507,508,509,510,512,514];
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

        case 'Sleep'
            SessionNames = {'PreSleep','PostSleep'};
            JustFreez = 0; % will ignore freezing
            JustSleep = 1; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
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
    
     % Spikes
    load('SpikeData.mat','S')
    % OB Spectrum - everything is realigned to this
    load('B_Low_Spectrum.mat')
    Sptsd_OB = tsd(Spectro{2}*1e4,(Spectro{1}));
    clear Spectro 
    
    % Main body parameter
    switch Parameter
        case 'BR'
            % InstFreq -  OB
            load('InstFreqAndPhase_B.mat', 'LocalFreq')

            instfreq_concat_PT = LocalFreq.PT;
            y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(Sptsd_OB));
            instfreq_concat_PT = tsd(Range(Sptsd_OB),y);
            instfreq_concat_WV = LocalFreq.WV;
            instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(Sptsd_OB)));
            y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(Sptsd_OB));
            y(y>15)=NaN;
            y=naninterp(y);
            instfreq_concat_WV = tsd(Range(Sptsd_OB),y);
            instfreq_concat_Both = tsd(Range(Sptsd_OB),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
            VarOfInterest=Data(Restrict(instfreq_concat_Both,TotalEpoch));
            
        case 'HR'
            %  heartrate 
            load('HeartBeatInfo.mat')
            heartrate = EKG.HBRate;
            y=interp1(Range(heartrate),Data(heartrate),Range(Sptsd_OB));
            heartrate = tsd(Range(Sptsd_OB),y);
            VarOfInterest = Data(Restrict(heartrate,TotalEpoch));
                        
        case 'speed'
            % head mouvement (because we have ti in all mice)
            load('behavResources.mat', 'MovAcctsd')
            y=interp1(Range(MovAcctsd),Data(MovAcctsd),Range(Sptsd_OB));
            speed = tsd(Range(Sptsd_OB),y);
            speed = Data(Restrict(speed,TotalEpoch));
            speed(speed ==0) = NaN;
            VarOfInterest = log(speed);
            BinSize = (prctile(VarOfInterest,99)-prctile(VarOfInterest,1))/BinNumber;
            BinLims = [prctile(VarOfInterest,1):BinSize:prctile(VarOfInterest,99)];
        
        case 'position'
            % position - only works in the maze
            load('behavResources.mat', 'LinearDist')
            y=interp1(Range(LinearDist),Data(LinearDist),Range(Sptsd_OB));
            linearposition = tsd(Range(Sptsd_OB),y);
            VarOfInterest = Data(Restrict(linearposition,TotalEpoch));
    end
    
    % get rid of ends
    VarOfInterest = VarOfInterest(3:end-3);
    
    % get the tuning curves
    MeanSpk{mm}=[];
    Occup{mm}=[];
    
    for sp=1:length(S)
        [Y,X] = hist(Range(S{sp}),Range(Sptsd_OB));
        spike_count = tsd(X,Y');
        spike_dat = Data(Restrict(spike_count,TotalEpoch));
        spike_dat = spike_dat(3:end-3);
        AllSpkAnova=[];
        AllIdAnova = [];
        Distrib_Spikes = [];
        dt = median(diff(Range(Sptsd_OB,'s')));
        Distrib_Spikes = hist(log(spike_dat),NeuronBins)/(length(spike_dat));
        clear Distrib_Spikes_Pos
        for k=1:length(BinLims)-1
            
            Bins=find(VarOfInterest>BinLims(k) & VarOfInterest<BinLims(k+1));
            MeanSpk{mm}(sp,k)=nansum(spike_dat(Bins))./(length(Bins));
            Occup{mm}(k)=length(Bins);
            Distrib_Spikes_Pos(k,:) = hist(spike_dat(Bins),NeuronBins)/(length(Bins));
            
            % do the anova on one half o data, get tuning curve
            % on other
            MeanSpk_Half{mm}(sp,k)=nansum(spike_dat(Bins(1:2:end)))./(length(Bins)/2);
            MeanSpk_HalfAn{mm}(sp,k)=nansum(spike_dat(Bins(2:2:end)))./(length(Bins)/2);
            AllSpkAnova=[AllSpkAnova;spike_dat(Bins(2:2:end))];
            AllIdAnova = [AllIdAnova;spike_dat(Bins(2:2:end))*0+k];
            
        end
    
        [pvalanova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
        PvalAnovaInfo{mm}(sp) = pvalanova;
        % Get error bars on tuning curve
        if pvalanova<0.01
            MinBins =  floor(min(Occup{mm})/5);
            for k=1:length(BinLims)-1
                Bins=find(VarOfInterest>BinLims(k) & VarOfInterest<BinLims(k+1));
                RandTrials = randperm(Occup{mm}(k));
                for perm = 1:5
                    MeanSpk_Err{mm}(sp,k,perm) = nansum(spike_dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                end
            end
        end
        
        
        occ  = (Occup{mm}/sum(Occup{mm}));
        meanrate = sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        % Mutual information - full
        clear pro
        for k=1:length(BinLims)-1
            for n = 1:length(NeuronBins)
                pro(k,n) = occ(k) * Distrib_Spikes_Pos(k,n) * log2(Distrib_Spikes_Pos(k,n)/Distrib_Spikes(n));
            end
        end
        Info_Full{mm}(sp) = nansum(pro(:))/dt;
        Info_Fullspike{mm}(sp) = dt*nansum(pro(:))/meanrate;

        % Mutual information - Skaggs
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate))/dt; % bits per second
        Infospike{mm}(sp) = dt*Info{mm}(sp)/meanrate; % bits per spike
        
        % Correlation
        [R,P]=corrcoef(VarOfInterest,spike_dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
      
        
        for btstrp = 1:1000
            num=ceil(rand*length(VarOfInterest));
            VarOfInterest_rand = fliplr([VarOfInterest(num+1:end);VarOfInterest(1:num)]);
            [R,P]=corrcoef(VarOfInterest_rand,spike_dat);
            
            % Randomized correlation
            RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
            PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
            
            % Randomized information
             clear MeanSpk_btstrp 
            for k=1:length(BinLims)-1
                
                Bins=find(VarOfInterest_rand>BinLims(k) & VarOfInterest_rand<BinLims(k+1));
                MeanSpk_btstrp(k)=nansum(spike_dat(Bins))./(length(Bins)*dt);
            
            end
            
            Info_bstrp{mm}(sp,btstrp) = nansum(occ.*MeanSpk_btstrp.*log2(MeanSpk_btstrp/meanrate))/dt; % bits per second
            Infospike_bstrp{mm}(sp,btstrp) = dt*Info_bstrp{mm}(sp)/meanrate; % bits per spike
            
        end
    end
end

save([SaveFolder filesep Parameter 'Tuning_',Period,'_HPC.mat'],'RSpk','RSpk_btstrp','PSpk_btstrp',...
    'MeanSpk','Info','MeanSpk_Half','MeanSpk_HalfAn','PvalAnovaInfo','Infospike','Info_bstrp','Infospike_bstrp',...
    'Info_Full','Info_Fullspike','MiceNumber','MeanSpk_Err','BinLims','Occup')


