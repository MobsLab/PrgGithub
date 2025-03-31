clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
num_bootstraps = 100;
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPostSound
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
load('B_Low_Spectrum.mat')
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[2:0.25:11];
NoSleep = 0;

for mm=1:length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'Cond');
    
    ToKeep = find(cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    x2 = strfind(Dir,'SoundTest');
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
    
    MeanSpk{mm}=[];
    Occup{mm}=[];
    for k=1:length(FreqLims)-1
        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        Occup{mm}(k)=length(Bins);
    end
    NumBins = min(Occup{mm});
    
    for k=1:length(FreqLims)-1
        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        BinsToUse{k} = Bins(randsample(length(Bins),NumBins));
    end
    
    for sp=1:length(S_concat)
        [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
        spike_count=tsd(X,Y');
        dat=Data(Restrict(spike_count,TotalEpoch));
        dat = dat(3:end-3);
        for k=1:length(FreqLims)-1
            MeanSpk{mm}(sp,k)=nansum(dat(BinsToUse{k}))./length(BinsToUse{k});
            Occup{mm}(k)=length(BinsToUse{k});
        end
        [R,P]=corrcoef(ToPlot,dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
        for btstrp = 1:1000
            btstrp
            num=ceil(rand*length(ToPlot));
            ToPlot_rand = fliplr([ToPlot(num+1:end);ToPlot(1:num)]);
            [R,P]=corrcoef(ToPlot_rand,dat);
            RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
            PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
        end
    end
    OBData{mm}=[];
    Sp{mm} = [];
    SpHist{mm} = [];
    Speeddata = Data(Speed);
    for k=1:length(FreqLims)-1
        OBData{mm}(k,:)=nanmean(Dat(:,BinsToUse{k})');
        [Y,X] = hist(log(Speeddata(BinsToUse{k})),[-3:0.1:3]);
        SpHist{mm}(k,:) = Y./nansum(Y);
        Sp{mm}(k,:)=nanmean(Speeddata(BinsToUse{k})');
    end
end

if NoSleep
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
    save('PFCUnitFiringOnOBFrequencyAllSessBroadFreqNoSleepSubSample.mat','OBData','PSpk','RSpk','PSpk_btstrp','RSpk_btstrp','MeanSpk','Sp','SpHist')
else
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
    save('PFCUnitFiringOnOBFrequencyAllSessBroadFreqSubSample.mat','OBData','PSpk','RSpk','PSpk_btstrp','RSpk_btstrp','MeanSpk','Sp','SpHist')
end