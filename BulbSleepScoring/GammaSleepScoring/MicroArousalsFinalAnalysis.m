clear all
EmgMice
maxdur=20;
minsleepdur=20;

%% EMG microawakenings
% Look at EMG activity distribution
for mm=1:m
    mm
    cd (filename{(mm)})
    load('StateEpochEMGSB.mat','EMG_thresh','EMGData')
    load('StateEpochSB.mat','smooth_ghi','gamma_thresh','ThetaEpoch')
    
    % Get microarousals based on EMG
    WakePer=thresholdIntervals(EMGData,EMG_thresh,'Direction','Above');
    TotEpoch=intervalSet(0,max(Range(EMGData)));
    WakePer=mergeCloseIntervals(WakePer,1*1e4);
    SleepPer=TotEpoch-WakePer;
    SleepPer2=mergeCloseIntervals(SleepPer,30*1e4);
    SleepPer2=dropShortIntervals(SleepPer2,600*1e4);
    MicroArEp=And(SleepPer2,SandwichEpoch(WakePer,SleepPer,maxdur*1e4,minsleepdur*1e4));
    GammaWakePer=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    % Look at Gamma and EMG power during these MAs
    GammaOverlap=[];
    for kk=1:length(Start(MicroArEp))
        GammaOverlap=[GammaOverlap,(length(Data(Restrict(EMGData,And(GammaWakePer,subset(MicroArEp,kk)))))./(length(Data(Restrict(EMGData,subset(MicroArEp,kk))))))];
    end
    MicroArousals{mm,1}=MicroArEp;
    MicroArousals{mm,2}=GammaOverlap;
    
    
        % Get microarousals based on OB
    WakePer=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
    WakePer=mergeCloseIntervals(WakePer,1*1e4);
    SleepPer=TotEpoch-WakePer;
    SleepPer2=mergeCloseIntervals(SleepPer,30*1e4);
    SleepPer2=dropShortIntervals(SleepPer2,600*1e4);
    MicroArEp=And(SleepPer2,SandwichEpoch(WakePer,SleepPer,maxdur*1e4,minsleepdur*1e4));
    GammaWakePer=thresholdIntervals(EMGData,EMG_thresh,'Direction','Above');
    % Look at Gamma and EMG power during these MAs
    GammaOverlap=[];
    for kk=1:length(Start(MicroArEp))
        GammaOverlap=[GammaOverlap,(length(Data(Restrict(EMGData,And(GammaWakePer,subset(MicroArEp,kk)))))./(length(Data(Restrict(EMGData,subset(MicroArEp,kk))))))];
    end
    MicroArousals{mm,3}=MicroArEp;
    MicroArousals{mm,4}=GammaOverlap;

end


clear  DatHE JustDelBandE DurE JustDelBandPE DurPE DatPE DatHG JustDelBandG DurG JustDelBandPG DurPG DatPG
% All transitions --> before and after
lim=0.5;
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochSB.mat','ThetaEpoch')

    load('H_Low_Spectrum.mat');
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    temp=intervalSet(Start(MicroArousals{mm,1})-8e4,Start(MicroArousals{mm,1})+8e4);
    a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
    a=a(1:80);
    RefEp=ts(a);
    DatHE{1,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
    JustDelBandE{mm}=mean(DatHE{1,mm}(:,20:60)');
    DurE{mm}=Stop(subset(temp,2),'s')-Start(subset(temp,2),'s');
    PrevEp=intervalSet(Start(subset(temp,2))-5*1e4,Start(subset(temp,2)));
    IsRemE{mm}=(size(Data(Restrict(Sptsd,And(ThetaEpoch,PrevEp))),1))./(size(Data(Restrict(Sptsd,PrevEp)),2));
    for s=3:length(Start(temp))
        Ep=ts(Range(RefEp)+Start(subset(temp,s)));
        DatHE{s,mm}=Data(Restrict(Sptsd,Ep));
        JustDelBandE{mm}=[JustDelBandE{mm};mean(DatHE{s,mm}(:,20:60)')];
        DurE{mm}=[DurE{mm},Stop(subset(temp,s),'s')-Start(subset(temp,s),'s')];
        PrevEp=intervalSet(Start(subset(temp,s))-5*1e4,Start(subset(temp,s)));
        IsRemE{mm}=[IsRemE{mm},(size(Data(Restrict(Sptsd,And(ThetaEpoch,PrevEp))),1))./(size(Data(Restrict(Sptsd,PrevEp)),2))];
    end
    
    temp=intervalSet(Start(MicroArousals{mm,3})-8e4,Start(MicroArousals{mm,3})+8e4);
    a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
    a=a(1:80);
    RefEp=ts(a);
    DatHG{1,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
    JustDelBandG{mm}=mean(DatHG{1,mm}(:,20:60)');
    DurG{mm}=Stop(subset(temp,2),'s')-Start(subset(temp,2),'s');
    PrevEp=intervalSet(Start(subset(temp,2))-5*1e4,Start(subset(temp,2)));
    IsRemG{mm}=(size(Data(Restrict(Sptsd,And(ThetaEpoch,PrevEp))),1))./(size(Data(Restrict(Sptsd,PrevEp)),2));
    for s=3:length(Start(temp))
        Ep=ts(Range(RefEp)+Start(subset(temp,s)));
        DatHG{s,mm}=Data(Restrict(Sptsd,Ep));
        JustDelBandG{mm}=[JustDelBandG{mm};mean(DatHG{s,mm}(:,20:60)')];
        DurG{mm}=[DurG{mm},Stop(subset(temp,s),'s')-Start(subset(temp,s),'s')];
        PrevEp=intervalSet(Start(subset(temp,s))-5*1e4,Start(subset(temp,s)));
        IsRemG{mm}=[IsRemG{mm},(size(Data(Restrict(Sptsd,And(ThetaEpoch,PrevEp))),1))./(size(Data(Restrict(Sptsd,PrevEp)),2))];
    end

    
    load('PF_Low_Spectrum.mat');
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    temp=intervalSet(Start(MicroArousals{mm,1})-8e4,Start(MicroArousals{mm,1})+8e4);
    a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
    a=a(1:80);
    RefEp=ts(a);
    DatPE{1,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
    JustDelBandPE{mm}=mean(DatPE{1,mm}(:,20:60)');
    for s=3:length(Start(temp))
        Ep=ts(Range(RefEp)+Start(subset(temp,s)));
        DatPE{s,mm}=Data(Restrict(Sptsd,Ep));
        JustDelBandPE{mm}=[JustDelBandPE{mm};mean(DatPE{s,mm}(:,20:60)')];
    end
    
    load('PF_Low_Spectrum.mat');
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    temp=intervalSet(Start(MicroArousals{mm,3})-8e4,Start(MicroArousals{mm,3})+8e4);
    a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
    a=a(1:80);
    RefEp=ts(a);
    DatPG{1,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
    JustDelBandPG{mm}=mean(DatPG{1,mm}(:,20:60)');
    for s=3:length(Start(temp))
        Ep=ts(Range(RefEp)+Start(subset(temp,s)));
        DatPG{s,mm}=Data(Restrict(Sptsd,Ep));
        JustDelBandPG{mm}=[JustDelBandPG{mm};mean(DatPG{s,mm}(:,20:60)')];
    end
end


figure
a=[];
for mm=1:m
a=[a;[(MicroArousals{mm,2}(2:end))',JustDelBandE{mm}./sum(sum(JustDelBandE{mm}))]];
end
b=sortrows(a);
b=b(:,2:end);
subplot(121)
imagesc(zscore(b')')
subplot(122)
imagesc(log(b))
figure
subplot(121)
nhist([MicroArousals{:,2}],'noerror')
temp=[];
subplot(122)
for mm=1:m
    temp=[temp,MicroArousals{mm,2}(2:end)];
end
plot(temp,[DurE{:}])



figure
a=[];
for mm=1:m
a=[a;[(MicroArousals{mm,4}(2:end))',JustDelBandG{mm}./sum(sum(JustDelBandG{mm}))]];
end
b=sortrows(a);
b=b(:,2:end);
subplot(121)
imagesc(zscore(b')')
subplot(122)
imagesc(log(b))

