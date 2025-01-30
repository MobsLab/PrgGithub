%% Ripples study

load('Ripples.mat', 'RipplesEpochR')
Rg_Acc = Range(MovAcctsd);
i=1; bin_length = ceil(2/median(diff(Range(MovAcctsd,'s')))); % in 2s
for bin=1:bin_length:length(Rg_Acc)-bin_length
    SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+bin_length));
    RipDensity_Pre(i) = length(Start(and(RipplesEpochR , SmallEpoch)));
    TimeRange(i) = Rg_Acc(bin);
    i=i+1;
end
RipDensity_tsd = tsd(TimeRange' , RipDensity_Pre');
RipDensity = Restrict(RipDensity_tsd , Behav.FreezeAccEpoch);
VHigh_OnRipplesEpoch = Restrict(Sptsd.HPC_VHigh , RipplesEpochR);

figure
subplot(211)
plot(Data(RipDensity))
subplot(223)
bar([length(Start(and(RipplesEpochR , Behav.MovingEpoch)))/sum(Stop(Behav.MovingEpoch)-Start(Behav.MovingEpoch))*1e4 ; length(Start(and(RipplesEpochR , Behav.FreezeAccEpoch)))/sum(Stop(Behav.FreezeAccEpoch)-Start(Behav.FreezeAccEpoch))*1e4 ])

figure
subplot(311)
imagesc(Range(VHigh_OnRipplesEpoch) , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
colormap jet
caxis([0 4e3])
subplot(312)
imagesc(Range(VHigh_OnRipplesEpoch,'s') , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
caxis([0 6e3]); ylim([120 200])
subplot(313)
imagesc(Range(VHigh_OnRipplesEpoch,'s') , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
caxis([0 6e3]); ylim([120 200])

Data_VHigh_OnRipplesEpoch = Data(VHigh_OnRipplesEpoch);


figure
subplot(211)
plot(nanmean(Data_VHigh_OnRipplesEpoch'))
subplot(212)
plot(nanmean(Data_VHigh_OnRipplesEpoch(:,45:74)'))


ep=1;
GZ = Restrict(Sptsd.HPC_VHigh , subset(RipplesEpochR,ep)); DataGZ = Data(GZ); plot(nanmean(DataGZ(:,45:74)')); ep=ep+1;

plot(Derivated__From_NormPower(V>1e3,:)')


histogram(h(V>1e3),20)
histogram(V(V>1e3),20)

for i=1:length(Start(RipplesEpochR))

    h(i)=sum(Stop(subset(RipplesEpochR,i))-Start(subset(RipplesEpochR,i)));
    GZ = Restrict(Sptsd.HPC_VHigh , subset(RipplesEpochR,i)); DataGZ = Data(GZ);
    V(i)=nanmean(nanmean(DataGZ(:,45:74)'));
    Vbis(i,1:length(nanmean(DataGZ(:,45:74)')))=nanmean(DataGZ(:,45:74)');
    
end
Vbis(Vbis==0)=NaN;

figure; plot(Vbis(V>1e3,:)')
for ep=1:size(Vbis,1)
    Vbis_norm(ep,:)= interp1(linspace(0,1,sum(~isnan(Vbis(ep,:)))) , Vbis(ep,1:sum(~isnan(Vbis(ep,:)))),linspace(0,1,40));
end
plot(Vbis_norm(V>1e3,:)')
for ep=1:size(Vbis_norm,1)
    for bin=2:40
        Derivated__From_NormPower(ep,1)=0;
        Derivated__From_NormPower(ep,bin)=(Vbis_norm(ep,bin)-Vbis_norm(ep,bin-1))/nanmean(Vbis_norm(ep,:));
    end
    if and(sum(Derivated__From_NormPower(ep,1:20)>0) , sum(Derivated__From_NormPower(ep,21:40)<0))
        vector_u(ep)=1;
    else
        vector_u(ep)=0;
    end
end
sum(vector_u(V>1e3))

figure
subplot(121)
plot(Vbis_norm(and(vector_u,V>1e3),:)')
subplot(122)
plot(Vbis_norm(and(~vector_u,V>1e3),:)')

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])

X=1:127; Y=X(and(~vector_u,V>1e3)); Y2=X(and(vector_u,V>1e3));

figure
for i=1:10
    subplot(2,5,i)
    %plot(Data(Restrict(LFP,subset(RipplesEpochR , Y(i)))))
    plot(Data(Restrict(LFP,subset(RipplesEpochR , Y2(i)))))
end

plot(Data(Restrict(LFP,subset(RipplesEpochR ,18)))



figure
plot(Vbis_norm(18,:)')



%% second day analyses


%% Sleep
cd('/media/nas6/ProjetEmbReact/Mouse1189/20210317')

load('SWR.mat')
load('Ripples.mat')








%% Maze
cd('/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_UMazeCondBlockedShock_PostDrug/Cond2')

load('SWR.mat')
load('Ripples.mat')

figure


rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpochR , rip))-3000 , Stop(subset(RipplesEpochR , rip))+3000); plot(Range(Restrict(LFP , RipplesEpoch_extended)) , Data(Restrict(LFP , RipplesEpoch_extended)))


rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip))-3000 , Stop(subset(RipplesEpoch , rip))+3000); plot(Range(Restrict(LFP , RipplesEpoch_extended)) , Data(Restrict(LFP , RipplesEpoch_extended))); vline(Start(subset(RipplesEpoch , rip)),'--r'); vline(Stop(subset(RipplesEpoch , rip)),'--r')


rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(and(RipplesEpochR , Behav.FreezeAccEpoch) , rip))-3000 , Stop(subset(and(RipplesEpochR , Behav.FreezeAccEpoch) , rip))+3000); plot(Range(Restrict(LFP , RipplesEpoch_extended)) , Data(Restrict(LFP , RipplesEpoch_extended)))

rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(and(RipplesEpoch , Behav.FreezeAccEpoch) , rip))-3000 , Stop(subset(and(RipplesEpoch , Behav.FreezeAccEpoch) , rip))+3000); plot(Range(Restrict(LFP , RipplesEpoch_extended)) , Data(Restrict(LFP , RipplesEpoch_extended))); vline(Start(subset(and(RipplesEpoch , Behav.FreezeAccEpoch) , rip)),'--r'); vline(Stop(subset(and(RipplesEpoch , Behav.FreezeAccEpoch) , rip)),'--r')




load('H_VHigh_Spectrum.mat')
Sptsd.HPC_VHigh = tsd(Spectro{2}*1e4 , Spectro{1});
Data_VHigh = Data(Sptsd.HPC_VHigh);
VHigh_OnRipplesEpoch = Restrict(Sptsd.HPC_VHigh , RipplesEpoch);
DataVHigh_OnRipplesEpoch = Data(VHigh_OnRipplesEpoch);
RangeVHigh_OnRipplesEpoch = Range(VHigh_OnRipplesEpoch);
a=RangeVHigh_OnRipplesEpoch(1:end-1)-RangeVHigh_OnRipplesEpoch(2:end);
a_log = a<-49; X=[1:1:length(a)]; Xa=X(a_log);
Sptsd.HPC_VHigh_120_250 = tsd(Range(Sptsd.HPC_VHigh) , nanmean(Data_VHigh(:,45:94)')');


figure
subplot(311)
imagesc(Range(Sptsd.HPC_VHigh) , Spectro{3} , Data_VHigh'); axis xy
caxis([0 1e3])
subplot(312)
imagesc(Range(VHigh_OnRipplesEpoch) , Spectro{3} , Data(VHigh_OnRipplesEpoch)'); axis xy
caxis([0 1e3])
subplot(313)
imagesc(Range(VHigh_OnRipplesEpoch) , Spectro{3} , DataVHigh_OnRipplesEpoch(:,45:94)'); axis xy
caxis([0 1e3])

figure
plot(nanmean(DataVHigh_OnRipplesEpoch(:,45:94)')) % Restrict between 120 and 250
vline(Xa,'--r')
ylim([0 1e3])

figure
plot(nanmean(Data_VHigh(:,45:94)')) % Restrict between 120 and 250
hline(120,'--r')
ylim([0 1e3])



% New method using power to detect ripples
RipplesPotentials1=thresholdIntervals(Sptsd.HPC_VHigh_120_250,120,'Direction','Above');
RipplesPotentials2=dropShortIntervals(RipplesPotentials1 , 200);
RipplesPotentials3=dropLongIntervals(RipplesPotentials2 , 2000);
RipplesPotentials4=mergeCloseIntervals(RipplesPotentials3 , 150);

NewMethod = Restrict(LFP , RipplesEpoch);

figure
imagesc(Data(NewMethod)'); axis xy; caxis([0 1e3])

figure
plot(Range(NewMethod) , Data(NewMethod)); 
plot(Data(NewMethod));
plot(Data(Restrict(NewMethod , RipplesPotentials4))); 

% cleaning epochs where ripples are not good
clear RipplesEpoch_clean BadRipplesEpoch
RipplesEpoch_clean = RipplesEpoch; BadRipplesEpoch = intervalSet(0,0);
for rip_numb = 1:length(Start(RipplesEpoch))
    clear HPC_VHigh_OnRipplesEpoch_Data
    HPC_VHigh_OnRipplesEpoch_Data = Data(Restrict(Sptsd.HPC_VHigh , subset(RipplesEpoch,rip_numb)));
    if nanmean(nanmean(HPC_VHigh_OnRipplesEpoch_Data(:,45:94)'))<125
        RipplesEpoch_clean = RipplesEpoch_clean - subset(RipplesEpoch,rip_numb);
        BadRipplesEpoch = or(BadRipplesEpoch , subset(RipplesEpoch,rip_numb));
    end
end

length(Start(and(RipplesEpoch_clean,BadRipplesEpoch)))

length(Start(RipplesEpoch))
length(Start(RipplesEpoch_clean))
length(Start(BadRipplesEpoch))


VHigh_OnRipplesEpoch_clean = Restrict(Sptsd.HPC_VHigh , RipplesEpoch_clean);
DataVHigh_OnRipplesEpoch_clean = Data(VHigh_OnRipplesEpoch_clean);
plot(nanmean(DataVHigh_OnRipplesEpoch_clean(:,45:94)')) % Restrict between 120 and 250

rip=0;
rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(BadRipplesEpoch , rip))-3000 , Stop(subset(BadRipplesEpoch , rip))+3000); plot(Range(Restrict(LFP , RipplesEpoch_extended)) , Data(Restrict(LFP , RipplesEpoch_extended))); vline(Start(subset(BadRipplesEpoch , rip)),'--r'); vline(Stop(subset(BadRipplesEpoch , rip)),'--r')

rip = rip+1;  RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip))-3000 , Stop(subset(RipplesEpoch , rip))+3000); imagesc(Range(Restrict(Sptsd.HPC_VHigh , RipplesEpoch_extended)) , Spectro{3} , Data(Restrict(Sptsd.HPC_VHigh , RipplesEpoch_extended))'); axis xy; vline(Start(subset(RipplesEpoch , rip)),'--r'); vline(Stop(subset(RipplesEpoch , rip)),'--r'); caxis([0 1e3])


figure
histogram(nanmean(DataVHigh_OnRipplesEpoch_clean(:,45:94)'),100)

%% Pharmaco
cd('')

load('SWR.mat')
load('Ripples.mat')




%% Ripples type
load('ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_deep = LFP;

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_rip = LFP;


load('SWR.mat')

for rip_numb = 1:length(Start(RipplesEpoch))
    clear HPC_VHigh_OnRipplesEpoch_Data
    HPC_VHigh_OnRipplesEpoch_Data = Data(Restrict(Sptsd.HPC_VHigh , subset(RipplesEpoch,rip_numb)));
    Power_DruingRipple(rip_numb) = nanmean(nanmean(HPC_VHigh_OnRipplesEpoch_Data(:,45:94)'));
end

rip=rip+1; clf
RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip))-200 , Stop(subset(RipplesEpoch , rip))+200); plot(Range(Restrict(LFP4 , RipplesEpoch_extended)) , Data(Restrict(LFP4 , RipplesEpoch_extended))); vline(Start(subset(RipplesEpoch , rip)),'--r'); vline(Stop(subset(RipplesEpoch , rip)),'--r')
hold on
RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip))-200 , Stop(subset(RipplesEpoch , rip))+200); plot(Range(Restrict(LFP5 , RipplesEpoch_extended)) , runmean(Data(Restrict(LFP5 , RipplesEpoch_extended)),3)); vline(Start(subset(RipplesEpoch , rip)),'--r'); vline(Stop(subset(RipplesEpoch , rip)),'--r')

for rip_numb = 1:length(Start(RipplesEpoch))
    RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip_numb))-200 , Stop(subset(RipplesEpoch , rip_numb))+200);
    HPC_deep_Amplitude(rip_numb) = max(runmean(Data(Restrict(LFP5 , RipplesEpoch_extended)),3))-min(runmean(Data(Restrict(LFP5 , RipplesEpoch_extended)),3));
end

figure
subplot(121)
histogram(log10(HPC_deep_Amplitude),100)
title('Sharp-wave amplitude distribution')
xlabel('amplitude (log scale)')
ylabel('#'); makepretty
subplot(122)
histogram(log10(Power_DruingRipple),100)
title('Ripples power (120-250 Hz)')
xlabel('power (log scale)'); 
ylabel('#'); ylim([0 300]); makepretty

figure
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude , Power_DruingRipple , 10);

figure
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:3:end) , Power_DruingRipple(1:3:end) , 15);

i=1; x = [0 round(linspace(max(HPC_deep_Amplitude(1:3:end))/10,max(HPC_deep_Amplitude(1:3:end)),10))];
for i=1:length(x)-1
    
    y(i) = nanmean(Power_DruingRipple(and(x(i)<HPC_deep_Amplitude , HPC_deep_Amplitude<x(i+1))));
    i=i+1;
    
end

figure
subplot(121)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:3:end) , Power_DruingRipple(1:3:end) , 10);
plot((x(1:end-1)+x(2:end))/2,y,'.k','MarkerSize',40)
plot((x(1:end-1)+x(2:end))/2,y,'k','Linewidth',2)
xlabel('sharp-wave amplitude (a.u.)'); ylabel('ripples power (a.u.)')
makepretty; title('regular scale')
subplot(122)
[R,P]=PlotCorrelations_BM(log10(HPC_deep_Amplitude(1:3:end)) , log10(Power_DruingRipple(1:3:end)) , 10);
plot(log10((x(1:end-1)+x(2:end))/2),log10(y),'.k','MarkerSize',40)
plot(log10((x(1:end-1)+x(2:end))/2),log10(y),'k','Linewidth',2)
xlabel('sharp-wave amplitude (log scale)'); ylabel('ripples power (log scale)')
makepretty; title('log scale')

a=suptitle('Power 120-250 Hz on ripples channel = f(sharp-wave amplitude on deep channel)'); a.FontSize=20;

figure
subplot(121)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude , Power_DruingRipple , 10);
plot((x(1:end-1)+x(2:end))/2,y,'.k','MarkerSize',40)
plot((x(1:end-1)+x(2:end))/2,y,'k','Linewidth',2)
subplot(122)
[R,P]=PlotCorrelations_BM(log10(HPC_deep_Amplitude) , log10(Power_DruingRipple) , 10);
plot(log10((x(1:end-1)+x(2:end))/2),log10(y),'.k','MarkerSize',40)
plot(log10((x(1:end-1)+x(2:end))/2),log10(y),'k','Linewidth',2)



figure
subplot(221)
plot(runmean(ripples(:,4),50))
title('Duration evolution')
ylabel('time (s)')
hline(38,'--r'); hline(32.5,'--r')
makepretty
subplot(222)
plot(runmean(ripples(:,5),50))
title('Frequency evolution')
ylabel('Frequency (Hz)')
hline(165,'--r'); hline(150,'--r')
makepretty
subplot(223)
plot(runmean(ripples(:,6),50))
xlabel('ripples events')
ylabel('amplitude (a.u.)')
title('Amplitude evolution')
hline(2009,'--r'); hline(1800,'--r')
makepretty
subplot(224)
plot(runmean(Power_DruingRipple,50))
hline(2.3,'--r'); hline(2.05,'--r')
xlabel('ripples events')
ylabel('Power (log scale)')
title('Power evolution')
makepretty

a=suptitle('Ripples features evolution along events, baseline sleep'); a.FontSize=20;

Ripples_Frequency_tsd = tsd(ripples(:,2)*1e4 , ripples(:,5));
Ripples_Frequency_tsd_Wake = Restrict(Ripples_Frequency_tsd , Wake);
Ripples_Power_tsd = tsd(ripples(:,2)*1e4 , Power_DruingRipple');
Ripples_Power_tsd_Wake = Restrict(Ripples_Power_tsd , Wake);
Ripples_Power_tsd_Sleep = Restrict(Ripples_Power_tsd , Sleep);
SW_Amplitude_tsd = tsd(ripples(:,2)*1e4 , HPC_deep_Amplitude');
SW_Amplitude_tsd_Wake = Restrict(SW_Amplitude_tsd , Wake);
SW_Amplitude_tsd_Sleep = Restrict(SW_Amplitude_tsd , Sleep);

% plot with wake/sleep
Data_Ripples_Power_tsd_Sleep = Data(Ripples_Power_tsd_Sleep);
Data_Ripples_Power_tsd_Wake = Data(Ripples_Power_tsd_Wake);
Data_SW_Amplitude_tsd_Sleep = Data(SW_Amplitude_tsd_Sleep);
Data_SW_Amplitude_tsd_Wake = Data(SW_Amplitude_tsd_Wake);

plot(Data_SW_Amplitude_tsd_Sleep(1:3:end) , Data_Ripples_Power_tsd_Sleep(1:3:end) , '.r','MarkerSize',10);
hold on
plot(Data_SW_Amplitude_tsd_Wake(1:3:end) , Data_Ripples_Power_tsd_Wake(1:3:end) , '.b','MarkerSize',10);
makepretty

i=1; x_wake = [0 round(linspace(max(Data(SW_Amplitude_tsd_Wake))/10 , max(Data(SW_Amplitude_tsd_Wake)) , 10))];
for i=1:length(x_wake)-1
    
    y_wake(i) = nanmean(Data_Ripples_Power_tsd_Wake(and(x_wake(i)<Data(SW_Amplitude_tsd_Wake) , Data(SW_Amplitude_tsd_Wake)<x_wake(i+1))));
    i=i+1;
    
end
i=1; x_sleep = [0 round(linspace(max(Data(SW_Amplitude_tsd_Sleep))/10 , max(Data(SW_Amplitude_tsd_Sleep)) , 10))];
for i=1:length(x_sleep)-1
    
    y_sleep(i) = nanmean(Data_Ripples_Power_tsd_Sleep(and(x_sleep(i)<Data(SW_Amplitude_tsd_Sleep) , Data(SW_Amplitude_tsd_Sleep)<x_sleep(i+1))));
    i=i+1;
    
end

plot((x_wake(1:end-1)+x_wake(2:end))/2 , y_wake,'.c','MarkerSize',40)
plot((x_wake(1:end-1)+x_wake(2:end))/2 , y_wake,'c','Linewidth',2)

plot((x_sleep(1:end-1)+x_sleep(2:end))/2 , y_sleep , '.m','MarkerSize',40)
plot((x_sleep(1:end-1)+x_sleep(2:end))/2 , y_sleep , 'm','Linewidth',2)

f=get(gca,'Children');
legend([f(1),f(3),f(5),f(6)],'Wake','Sleep','Wake mean','Sleep mean');
xlabel('sharp-wave amplitude (a.u.)'); ylabel('ripples power (a.u.)')
title('Power 120-250 Hz on ripples channel = f(sharp-wave amplitude on deep channel)')

%%
figure
plot(runmean(HPC_deep_Amplitude,50))
hline(5000,'--r'); hline(4000,'--r')
xlabel('ripples events')
ylabel('amplitude (a.u.)')
title('Sharp wave amplitude evolution')
makepretty

figure
plot(runmean(zscore(HPC_deep_Amplitude),50))
plot(log10(abs(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple))))
plot(runmean(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple),50))
plot(runmean(zscore(HPC_deep_Amplitude),50)./runmean(zscore(Power_DruingRipple),50))
plot(runmean(HPC_deep_Amplitude./Power_DruingRipple,100))

histogram(runmean(HPC_deep_Amplitude./Power_DruingRipple,100),100)
histogram(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple),100,'BinLimits',[-5 5],'NumBins',100)
histogram(log10(abs(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple))),100)
histogram(log10(abs(log10(abs(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple))))),100)
histogram(abs(log10(abs(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple)))),100)
vline(0,'--r')

histogram(zscore(HPC_deep_Amplitude)./zscore(Power_DruingRipple),100,'BinLimits',[-5 5],'NumBins',100)

HPC_deep_Amplitude_Zscored = zscore(HPC_deep_Amplitude);
Power_DruingRipple_Zscored = zscore(Power_DruingRipple);
i=1; x_zscore = [linspace(min(HPC_deep_Amplitude_Zscored) , max(HPC_deep_Amplitude_Zscored) , 40)];
for i=1:length(x_zscore)-1
    
    y_zscore(i) = nanmean(Power_DruingRipple_Zscored(and(x_zscore(i)<HPC_deep_Amplitude_Zscored , HPC_deep_Amplitude_Zscored<x_zscore(i+1))));
    i=i+1;
    
end
HPC_deep_Amplitude_Zscored_New = HPC_deep_Amplitude_Zscored(HPC_deep_Amplitude_Zscored>x_change);
Power_DruingRipple_Zscored_New = Power_DruingRipple_Zscored(HPC_deep_Amplitude_Zscored>x_change);

HPC_deep_Amplitude_Zscored_New2 = HPC_deep_Amplitude_Zscored(HPC_deep_Amplitude_Zscored<x_change);
Power_DruingRipple_Zscored_New2 = Power_DruingRipple_Zscored(HPC_deep_Amplitude_Zscored<x_change);

figure
plot(HPC_deep_Amplitude_Zscored , Power_DruingRipple_Zscored, '.r')
hold on
plot(HPC_deep_Amplitude_Zscored_New , Power_DruingRipple_Zscored_New, '.c')

plot((x_zscore(1:end-1)+x_zscore(2:end))/2 , y_zscore,'.k','MarkerSize',40)
plot((x_zscore(1:end-1)+x_zscore(2:end))/2 , y_zscore,'k','Linewidth',2)
xlabel('sharp-wave amplitude (zscore)'); ylabel('ripples power (zscore)')

x_change = 1.041; y_change = 0.87;
vline(x_change,'--k')

Prop = sum(HPC_deep_Amplitude_Zscored<x_change)/length(HPC_deep_Amplitude_Zscored);
figure; [R,P,a,b]=PlotCorrelations_BM(HPC_deep_Amplitude_Zscored_New' , Power_DruingRipple_Zscored_New' , 10 , 1); close
figure; [R2,P2,a2,b2]=PlotCorrelations_BM(HPC_deep_Amplitude_Zscored_New2' , Power_DruingRipple_Zscored_New2' , 10 , 1); close

ylim([-3 4.5])
text(-2,3.7,['Prportion = ' num2str(Prop)])
text(-2,3.5,['R =    ' num2str(R(2,1)) '    P = ' num2str(P(2,1))])
text(-2,3.2,['a = ' num2str(a) '    b = ' num2str(b)])

text(2,3.7,['Prportion = ' num2str(1-Prop)])
text(2,3.5,['R =    ' num2str(R2(2,1)) '    P = ' num2str(P2(2,1))])
text(2,3.2,['a = ' num2str(a2) '    b = ' num2str(b2)])

title('Ripples Power = f(sharp-wave amplitude)')


figure; imagesc(HPC_deep_Amplitude_Zscored>1.041)



figure
subplot(221)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:6:end)' , ripples(1:6:end,4) , 10 , 1);
title('Duration correlation')
ylabel('time (s)')
makepretty
subplot(222)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:6:end)' , ripples(1:6:end,5) , 10 , 1);
title('Frequency correlation')
ylabel('Frequency (Hz)')
makepretty
subplot(223)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:6:end)' , ripples(1:6:end,6) , 10 , 1);
title('Amplitude correlation')
ylabel('amplitude (a.u.)')
makepretty
xlabel('sharp wave amplitude (a.u.)')
subplot(224)
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude(1:6:end)' , Power_DruingRipple(1:6:end)' , 10 , 1);
title('Power correlation')
ylabel('amplitude (a.u.)')
makepretty
xlabel('sharp wave amplitude (a.u.)')

a=suptitle('Sharp wave corelations with ripples features'); a.FontSize=20;


figure
[R,P]=PlotCorrelations_BM(ripples(1:6:end,4) , ripples(1:6:end,5) , 10 , 1);






