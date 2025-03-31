cd /media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPost
load('StateEpochSB.mat','gamma_thresh')
smootime=3;
Numbers=[1,4,9];
clf
for t=1:2
    cd(['/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Cond/Cond', num2str(Numbers(t))])
    load('B_Low_Spectrum.mat')
    load('behavResources.mat')
    load('LFPData/LFP8.mat')
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=tsd(Range(LFP),H);
    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    subplot(3,3,[1,4]+(t-1))
    imagesc(Range(Sptsd,'s'),Spectro{3},log(Data(Sptsd)')),axis xy,hold on
    ylim([0.1 15])
    line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+12,'color','c','linewidth',5)
    set(gca,'LineWidth',2,'XTick',[])
    box off
    ylabel('Frequency (Hz)')
    
    try,plot(StimTimes/1e4,10,'r*'), end
    subplot(3,3,[7]+(t-1))
    plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'k','linewidth',2)
    line(xlim,[gamma_thresh gamma_thresh],'color','r','linewidth',2)
    ylabel('OB Gamma power')
    ylim([100 600])
    set(gca,'LineWidth',2,'XTick',[])
    
    xlim([0 250])
    box off
end

t=3;
cd /media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPost
load('B_Low_Spectrum.mat')
load('StateEpochSB.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
subplot(3,3,[1,4]+(t-1))
imagesc(Range(Sptsd,'s'),Spectro{3},log(Data(Sptsd)')),axis xy,hold on
xlim([3380 3380+250])
ylim([0.1 15])
line([Start(sleepper,'s') Stop(sleepper,'s')]',[Start(sleepper,'s') Stop(sleepper,'s')]'*0+12,'color','c','linewidth',5)
set(gca,'LineWidth',2,'XTick',[])
box off

subplot(3,3,[7]+(t-1))
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'k','linewidth',2)
line(xlim,[gamma_thresh gamma_thresh],'color','r','linewidth',2)
xlim([3380 3380+250])
ylim([100 600])
ylabel('OB Gamma power')

set(gca,'LineWidth',2,'XTick',[])
box off

