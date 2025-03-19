clear all,
%close all

SlLocation = {'/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse667/Mouse667_20180402_PreKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PreKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse668/Mouse668_20180402_PreKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse669/Mouse669_20180331_PreKetamine/'};

KetLocation = {'/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse667/Mouse667_20180402_PostKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PostKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse668/Mouse668_20180402_PostKetamine/',...
    '/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse669/Mouse669_20180331_PostKetamine/'};

for f = 1:length(SlLocation)
    cd(SlLocation{f})
    load('StateEpochSB.mat','smooth_ghi','SWSEpoch','Wake')
    load('B_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    [Y,X] =hist(log(Data(smooth_ghi)),100);
    HistGammaSleepWake{f}=[X;Y];
    SleepAvGamma(f) = mean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    KetSleep{f} = smooth_ghi;
    MeanOBSpec_Sl(f,:) = nanmean(Data(Restrict(sptsd,SWSEpoch)));
    MeanOBSpec_Wk(f,:) = nanmean(Data(Restrict(sptsd,Wake)));
    
    clear smooth_ghi SWSEpoch TotalEpoch
    
    cd(KetLocation{f})
    load('StateEpochSB.mat','smooth_ghi')
    load('B_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    KetGamma{f} = smooth_ghi;
    smooth_ghi = Restrict(smooth_ghi,intervalSet(60*60*1e4,60*120*1e4));
    [Y,X] =hist(log(Data(smooth_ghi)),100);
    HistGamma{f}=[X;Y];
    MeanOBSpec_Ket(f,:) = nanmean(Data(Restrict(sptsd,intervalSet(60*60*1e4,60*120*1e4))));
    
    clear smooth_ghi
end

%% Make Figures

figure
for m= 1:4
    plot(HistGammaSleepWake{m}(1,:)-SleepAvGamma(m),HistGammaSleepWake{m}(2,:)./nansum(HistGammaSleepWake{m}(2,:)),'k','linewidth',2)
    hold on
    plot(HistGamma{m}(1,:)-SleepAvGamma(m),runmean(HistGamma{m}(2,:)./nansum(HistGamma{m}(2,:)),2),'color','r','linewidth',2)
end
legend('Wake/Sleep','Keta')

figure
for m= 1:4
subplot(4,1,m)
plot(Range(KetSleep{m}),Data(KetSleep{m})), hold on
plot(Range(KetGamma{m})+max(Range(KetSleep{m})),Data(KetGamma{m})), hold on
end


figure
[hl,hp]=boundedline(Spectro{3},runmean(nanmean(MeanOBSpec_Wk),smoofact),[stdError(MeanOBSpec_Wk);stdError(MeanOBSpec_Wk)]','k');
hold on
[hl,hp]=boundedline(Spectro{3},runmean(nanmean(MeanOBSpec_Sl),smoofact),[stdError(MeanOBSpec_Sl);stdError(MeanOBSpec_Sl)]','b');
[hl,hp]=boundedline(Spectro{3},runmean(nanmean(MeanOBSpec_Ket),smoofact),[stdError(MeanOBSpec_Ket);stdError(MeanOBSpec_Ket)]','r');

