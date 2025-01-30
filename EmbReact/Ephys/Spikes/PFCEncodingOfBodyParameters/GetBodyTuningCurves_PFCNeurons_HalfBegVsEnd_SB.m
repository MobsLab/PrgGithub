function GetBodyTuningCurves_PFCNeurons_HalfBegVsEnd_SB(Parameter, Period)

%% Inputs
% Parameter : which paramater to study
%   - HR : heart rate
%   - BR : breathing rate
%   - HRV : heart rate variability
%
% Period : which period in time
%   - Freezing : all freezing from the umaze conditionning
%   - Sleep : all sleep periods
%   - Wake : all wake periods that do not involve freezing
%   - All
%

%%

% Basic parameters
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves/';
SpBins = [-3:0.3:3];

% Right parameter
switch Parameter
    
    case 'BR'
        FreqLims = [2.5:0.3:11];
        MiceNumber=[490,507,508,509,510,512,514];
    case 'HR'
        FreqLims=[6:0.2:13];
        MiceNumber=[507,508,509,510];
    case 'HRV'
        FreqLims = [-5:0.3:1];
        MiceNumber=[507,508,509,510];
        
end

for mm = 1:length(MiceNumber)
    
    % Right periods
    switch Period
        case 'Freezing'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'UMazeCond');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 1; % will just keep freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;

        case 'Sleep'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Sleep');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 1; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Wake'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Cond');
            ToKeep = find(cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'SoundTest');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'Sleep');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
             case 'Wake_Explo'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Cond');
            ToKeep = find(cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'SoundTest');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'All'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
    end
    
    % Get concatenated variables
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
    % OB Spectrum - everything is realigned to this
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
    % NoiseEpoch
    NoiseEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
    TotalEpoch = intervalSet(0,max(Range(OBSpec_concat)));
    TotalEpoch = TotalEpoch - NoiseEp_concat;
    
    if JustFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = and(TotalEpoch,FzEp_concat);
    elseif RemoveFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = TotalEpoch - FzEp_concat;
    end
    
    if JustSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = TotalEpoch - Sleepstate{1}; % remove wake
    else RemoveSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = and(TotalEpoch,Sleepstate{1}); % just the wake
    end
    
    % Main body parameter
    switch Parameter
        case 'BR'
            % InstFreq -  OB
            instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
            y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
            instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
            instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
            instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
            y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
            y(y>15)=NaN;
            y=naninterp(y);
            instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
            instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
            VarOfInterest=Data(Restrict(instfreq_concat_Both,TotalEpoch));
            
        case 'HR'
            % InstFreq - heartrate and heart rate variability
            heartrate = ConcatenateDataFromFolders_SB(FolderList,'heartrate');
            heartrate_variability =  tsd(Range(heartrate),log(runmean(movstd(Data(heartrate),3),3)));
            
            y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
            heartrate = tsd(Range(OBSpec_concat),y);
            VarOfInterest=Data(Restrict(heartrate,TotalEpoch));
            
        case 'HRV'
            % InstFreq - heartrate and heart rate variability
            heartrate = ConcatenateDataFromFolders_SB(FolderList,'heartrate');
            heartrate_variability =  tsd(Range(heartrate),log(runmean(movstd(Data(heartrate),3),3)));
            
            y=interp1(Range(heartrate_variability),Data(heartrate_variability),Range(OBSpec_concat));
            heartrate_variability = tsd(Range(OBSpec_concat),y);
            VarOfInterest=Data(Restrict(heartrate_variability,TotalEpoch));
            
    end
    
    % get rid of ends
    VarOfInterest = VarOfInterest(3:end-3);
    
    % get the tuning curves
    MeanSpk{mm}=[];
    Occup{mm}=[];
    
    for sp=1:length(S_concat)
        [Y,X] = hist(Range(S_concat{sp}),Range(OBSpec_concat));
        spike_count = tsd(X,Y');
        spike_dat = Data(Restrict(spike_count,TotalEpoch));
        spike_dat = spike_dat(3:end-3);
        AllSpkAnova=[];
        AllIdAnova = [];
        
        for k=1:length(FreqLims)-1
            
            Bins=find(VarOfInterest>FreqLims(k) & VarOfInterest<FreqLims(k+1));
            MeanSpk{mm}(sp,k)=nansum(spike_dat(Bins))./length(Bins);
            Occup{mm}(k)=length(Bins);
            occup = length(Bins)/length(VarOfInterest);
            % do the anova on one half o data, get tuning curve
            % on other
            MeanSpk_Half{mm}(sp,k)=nansum(spike_dat(Bins(1:end/2)))./(length(Bins)/2);
            MeanSpk_HalfAn{mm}(sp,k)=nansum(spike_dat(Bins(end/2+1:end)))./(length(Bins)/2);
            AllSpkAnova=[AllSpkAnova;spike_dat(Bins(2:2:end))];
            AllIdAnova = [AllIdAnova;spike_dat(Bins(2:2:end))*0+k];
            
            
        end
        
        [pvalanova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
        PvalAnovaInfo{mm}(sp) = pvalanova;
        % Get error bars on tuning curve
        if pvalanova<0.01
            MinBins =  floor(min(Occup{mm})/5);
            for k=1:length(FreqLims)-1
                Bins=find(VarOfInterest>FreqLims(k) & VarOfInterest<FreqLims(k+1));
                RandTrials = randperm(Occup{mm}(k));
                for perm = 1:5
                    MeanSpk_Err{mm}(sp,k,perm) = nansum(spike_dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                end
            end
        end
        
        
        occ  = (Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        
        
        [R,P]=corrcoef(VarOfInterest,spike_dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
      
        
        for btstrp = 1:1000
            num=ceil(rand*length(VarOfInterest));
            VarOfInterest_rand = fliplr([VarOfInterest(num+1:end);VarOfInterest(1:num)]);
            [R,P]=corrcoef(VarOfInterest_rand,spike_dat);
            RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
            PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
        end
    end
    
    
end

save([SaveFolder filesep Parameter 'Tuning_SplitBegEnd_',Period,'_PFC.mat'],'RSpk','RSpk_btstrp','PSpk_btstrp',...
    'Info','MeanSpk_Half','MeanSpk_HalfAn','PvalAnovaInfo','Infospike','MiceNumber','MeanSpk_Err','FreqLims')
