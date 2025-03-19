clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
num_bootstraps = 100;

SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
load('B_Low_Spectrum.mat')
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[2:0.15:11];
SpBins = [-3:0.1:3];

NoSleep = 1;

for mm=1:length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'Cond');
    
    ToKeep = find(cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    x2 = strfind(Dir,'SoundTest');
    ToKeep = find(cellfun(@isempty,x2));
    Dir = Dir(ToKeep);
    
    x2 = strfind(Dir,'EPM');
    ToKeep = find(cellfun(@isempty,x2));
    Dir = Dir(ToKeep);
    
    x2 = strfind(Dir,'TestPost');
    ToKeep = find(cellfun(@isempty,x2));
    Dir = Dir(ToKeep);
    
    
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(Dir,'spikes');
    % OB Spectrum
    OBSpec_concat=ConcatenateDataFromFolders_SB(Dir,'spectrum','prefix','B_Low');
    % Speed
    Speed=ConcatenateDataFromFolders_SB(Dir,'speed');
    Speed = Restrict(Speed,ts(Range(OBSpec_concat)));
    
    % NoiseEpoch
    NoiseEp_concat=ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    TotalEpoch = intervalSet(0,max(Range(OBSpec_concat)));
    TotalEpoch = TotalEpoch - NoiseEp_concat;
    
    % InstFreq
    instfreq_concat_PT=ConcatenateDataFromFolders_SB(Dir,'instfreq','suffix_instfreq','B','method','PT');
    y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
    instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
    instfreq_concat_WV=ConcatenateDataFromFolders_SB(Dir,'instfreq','suffix_instfreq','B','method','WV');
    instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
    y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
    y(y>15)=NaN;
    y=naninterp(y);
    instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
    instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
    
    if NoSleep
        Sleepstate=ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sleepstates');
        TotalEpoch = and(TotalEpoch,Sleepstate{1});
    end
    
    
    ToPlot=Data(Restrict(instfreq_concat_Both,TotalEpoch));
    Dat=zscore(log(Data(Restrict(OBSpec_concat,TotalEpoch)))');
    
    % get rid of ends
    ToPlot = ToPlot(3:end-3);
    Dat = Dat(:,3:end-3);
    
    
    OBData{mm}=[];
    Sp{mm} = [];
    SpHist{mm} = [];
    Sp2{mm} = [];
    SpHist2{mm} = [];
    
    
    Speeddata = Data(Speed);
    for k=1:length(FreqLims)-1
        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        [Y,X] = histcounts(log(Speeddata(Bins)),SpBins);
        SpHist{mm}(k,:) = Y;
        Sp{mm}(k,:)=nanmean(Speeddata(Bins)');
    end
    
    BinNumber = min(SpHist{mm});
    
    for k=1:length(FreqLims)-1
        BinsFreq=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        Speedtemp = log(Speeddata(BinsFreq));
        GoodBins{k} = [];
        for sp = 1 :length(SpBins)-1
            val(sp) = sum(Speedtemp>SpBins(sp) & Speedtemp<=SpBins(sp+1));
            BinsSpeed = find(Speedtemp>SpBins(sp) & Speedtemp<=SpBins(sp+1));
            BinsResampled = BinsSpeed(randsample(length(BinsSpeed),BinNumber(sp)));
            GoodBins{k}= [GoodBins{k};BinsFreq(BinsResampled)];
        end
        [Y,X] = histc(log(Speeddata(GoodBins{k} )),SpBins);
        SpHist2{mm}(k,:) = Y;
        OBData{mm}(k,:)=nanmean(Dat(:,GoodBins{k})');
        Sp2{mm}(k,:)=nanmean(Speeddata(GoodBins{k})');
    end
    
    MeanSpk{mm}=[];
    Occup{mm}=[];
    for sp=1:length(S_concat)
        [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
        spike_count=tsd(X,Y');
        dat=Data(Restrict(spike_count,TotalEpoch));
        dat = dat(3:end-3);
        AllSpkAnova=[];
        AllIdAnova = [];
        
        for k=1:length(FreqLims)-1
            MeanSpk{mm}(sp,k)=nansum(dat(GoodBins{k}))./length(GoodBins{k});
            Occup{mm}(k)=length(GoodBins{k});
            AllSpkAnova=[AllSpkAnova;dat(GoodBins{k})];
            AllIdAnova = [AllIdAnova;dat(GoodBins{k})*0+k];
        end
        [R,P]=corrcoef(ToPlot,dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
        
        [panova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
        PvalAnovaInfo{mm}(sp) = panova;
        
        
        
        occ  =(Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        occ  =(Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        FR{mm}(sp) = meanrate;
        
        %         for btstrp = 1:1000
        %             btstrp
        %             num=ceil(rand*length(ToPlot));
        %             ToPlot_rand = fliplr([ToPlot(num+1:end);ToPlot(1:num)]);
        %             [R,P]=corrcoef(ToPlot_rand,dat);
        %             RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
        %             PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
        %         end
    end
    
end


if NoSleep
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
    save('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleepNoFear.mat','OBData','PSpk','PvalAnovaInfo','RSpk','MeanSpk','Sp','SpHist','SpHist2','Sp2')
else
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
    save('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoFear.mat','OBData','PSpk','RSpk','MeanSpk','Sp','SpHist','SpHist2','Sp2')
end


AllR2 = [];
AllRRand = [];
AllInfo = [];
AllMutInfo = [];
AllPAnova= [];

for mm=1:length(MiceNumber)
    AllR2 = [AllR2,RSpk{mm}];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
    
end

ToDel = find(or(isnan(AllPAnova),isnan(AllPAnova1)));

AllR2 = [];
AllRRand = [];
AllSpk = [];
AllPAnova= [];
AllInfo= [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
for mm=1:length(MiceNumber)
    AllR2 = [AllR2,RSpk{mm}(find(IsPFCNeuron{mm}))];
    AllRRand = [AllRRand,(RSpk_btstrp{mm}(find(IsPFCNeuron{mm}),:)')];
    AllSpk=[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    AllInfo= [AllInfo,(Infospike{mm}(find(IsPFCNeuron{mm})))];
end