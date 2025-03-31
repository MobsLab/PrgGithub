clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
num_bootstraps = 100;
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPreSound
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
load('B_Low_Spectrum.mat')
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[2:0.15:11];
NoSleep = 1;
for mm=1:length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'EPM');
    
    ToKeep = find(not(cellfun(@isempty,x1)));
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
            Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
            MeanSpk{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
            Occup{mm}(k)=length(Bins);
            AllSpkAnova=[AllSpkAnova;dat(Bins)];
            AllIdAnova = [AllIdAnova;dat(Bins)*0+k];
            
        end
        [panova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
        PvalAnovaInfo{mm}(sp) = panova;
        
        
        [R,P]=corrcoef(ToPlot,dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
        occ  =(Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        occ  =(Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        FR{mm}(sp) = meanrate;
    end
    
    OBData{mm}=[];
    Sp{mm} = [];
    SpHist{mm} = [];
    Speeddata = Data(Speed);
    for k=1:length(FreqLims)-1
        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        OBData{mm}(k,:)=nanmean(Dat(:,Bins)',1);
        [Y,X] = hist(log(Speeddata(Bins)),[-3:0.1:3]);
        SpHist{mm}(k,:) = Y./nansum(Y);
        Sp{mm}(k,:)=nanmean(Speeddata(Bins)');
    end
    
end



cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
save('PFCUnitFiringOnOBFrequencyEPMOnlySpeedCorrBroadFreq.mat','OBData','PSpk','PvalAnovaInfo','RSpk','MeanSpk','Sp','SpHist')
