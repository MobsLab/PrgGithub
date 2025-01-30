clear all
% Get list of mice to use
EMGmice;

%% First step: Get transition zone


figure
clear emg gam
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitions.mat','EMGthresh','emg','gamma')
for mm=1:m
    mm
    cd(filename{mm,1})
    load('StateEpochSB.mat')
    load(['LFPData/LFP',num2Str(filename{mm,2}),'.mat'])
    
    FilLFP=FilterLFP(LFP,[50 300],1024);
    smootime=1;
    EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    EMGData=Restrict(EMGData,Epoch);
        subplot(3,2,mm)
        [Y,X]=hist(log(Data(Restrict(EMGData,Epoch))),1000);
        Y=Y/sum(Y);
        st_ = [1.07e-2 9 0.101 3.49e-3 13 0.21];
        [cf2,goodness2]=createFit2gauss(X,Y,st_);
        a= coeffvalues(cf2);
        b=intersect_gaussians(a(2), a(5), a(3), a(6));
        [~,ind]=max(Y);
        EMGthresh{mm}=b(b>X(ind));
        subplot(121)
        plot(X,Y)
        hold on
        h_ = plot(cf2,'fit',0.95);
        set(h_(1),'Color',[1 0 0],...
            'LineStyle','-', 'LineWidth',2,...
            'Marker','none', 'MarkerSize',6);
        line([(EMGthresh{mm}) (EMGthresh{mm})],[0 max(Y)],'linewidth',4,'color','R')
        keyboard
    WakeEMG=thresholdIntervals(EMGData,exp(EMGthresh{mm}),'Direction','Above');
    WakeEMG=mergeCloseIntervals(WakeEMG,0.1*1e4);
    WakeEMG=dropShortIntervals(WakeEMG,0.1*1e4);
    SleepEMG=Epoch-WakeEMG;
    SleepEMG=mergeCloseIntervals(SleepEMG,0.1*1e4);
    SleepEMG=dropShortIntervals(SleepEMG,0.1*1e4);
    MicroWakeEMG=SandwichEpoch(WakeEMG,SleepEMG,5*1e4,10*1e4);
    WakeGamma=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    WakeGamma=mergeCloseIntervals(WakeGamma,0.1*1e4);
    WakeGamma=dropShortIntervals(WakeGamma,0.1*1e4);
    
    load('B_High_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    load('H_Low_Spectrum.mat')
    SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
    load('H_High_Spectrum.mat')
    SptsdHH=tsd(Spectro{2}*1e4,Spectro{1});
    load('PFC_High_Spectrum.mat')
    SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
    dat{mm}=[]; datH{mm}=[]; sortdat{mm}=[];sortdat2{mm}=[];RorS{mm}=[];datHH{mm}=[];datP{mm}=[];
    for k=1:length(Start(MicroWakeEMG))
        temp=log(Data(Restrict(Sptsd,subset(MicroWakeEMG,k)))');
        sortdat{mm}(k)=mean(mean(temp(13:20,:)));
        sortdat2{mm}(k)=mean(Data(Restrict(smooth_ghi,subset(MicroWakeEMG,k))));
        dat{mm}=[dat{mm},(nanmean(log(Data(Restrict(Sptsd,subset(MicroWakeEMG,k)))'),2))];
        datH{mm}=[datH{mm},(nanmean(log(Data(Restrict(SptsdH,subset(MicroWakeEMG,k)))'),2))];
        datHH{mm}=[datHH{mm},(nanmean(log(Data(Restrict(SptsdHH,subset(MicroWakeEMG,k)))'),2))];
        datP{mm}=[datP{mm},(nanmean(log(Data(Restrict(SptsdP,subset(MicroWakeEMG,k)))'),2))];
        rlong=length(Data(Restrict(LFP,And(REMEpoch,subset(MicroWakeEMG,k)))));
        slong=length(Data(Restrict(LFP,And(SWSEpoch,subset(MicroWakeEMG,k)))));
        if slong>rlong
            RorS{mm}=[RorS{mm},1];
        elseif rlong>slong
            RorS{mm}=[RorS{mm},2];
        else
            RorS{mm}=[RorS{mm},0];
        end
    end
    Dur{mm}=(Stop(MicroWakeEMG)-Start(MicroWakeEMG))/1e4;
    Gam_Thresh{mm}=gamma_thresh;
    
    %% Transitions
    sizedt=25000;
    %     [aft_cell,bef_cell]=transEpoch(SWSEpoch,wakeper);
    %     [emg{mm},gamma{mm}]=GetTransitionData(aft_cell,EMGData,smooth_ghi,sizedt);
    %
    sizedt=25000;
    [aft_cell,bef_cell]=transEpoch(REMEpoch,wakeper);
    [emgR{mm},gammaR{mm}]=GetTransitionData(aft_cell,EMGData,smooth_ghi,sizedt);
    
    MicroWakeEMGEp{mm}=MicroWakeEMG;
    WakeGammaEp{mm}=WakeGamma;
    
    close all
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    [Rip,usedEpoch]=FindRipplesKarimSB(LFP,SWSEpoch);
    [M,T]=PlotRipRaw(LFP,Rip,50,0);
    saveas(gcf,'RipplesPlot.png')
    saveas(gcf,'RipplesPlot.fig')
    save('RipplesDat.mat','Rip','usedEpoch')
end
save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitions.mat','EMGthresh','emg','gamma','MicroWakeEMGEp',...
    'WakeGammaEp','emgR','gammaR','RorS','dat','datHH','datH','datP','Dur','Gam_Thresh','sortdat','sortdat2')


%%% Transitions
figure
dt=20;
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt-median(diff(Range(smooth_ghi,'s')))];
for mm=1:m
    subplot(212)
    plot(timeaxis,(mean(gamma{mm}{2})-mean(mean(gamma{mm}{2})))/(std(mean(gamma{mm}{2}))),'color',[0.5 0.3 1],'linewidth',2)
    hold on
    plot(timeaxis,(mean(emg{mm}{2})-mean(mean(emg{mm}{2})))/(std(mean(emg{mm}{2}))),'color',[0.9 0.3 0.1],'linewidth',2)
    line([0 0],[-2 4],'color','k','linewidth',3)
    subplot(211)
    plot(timeaxis,(mean(gamma{mm}{1})-mean(mean(gamma{mm}{1})))/(std(mean(gamma{mm}{1}))),'color',[0.5 0.3 1],'linewidth',2)
    hold on
    plot(timeaxis,(mean(emg{mm}{1})-mean(mean(emg{mm}{1})))/(std(mean(emg{mm}{1}))),'color',[0.9 0.3 0.1],'linewidth',2)
    line([0 0],[-2 4],'color','k','linewidth',3)
end


figure
subplot(212)
temp=[];
for mm=1:m
    temp=[temp;(mean(gamma{mm}{2})-mean(mean(gamma{mm}{2})))/(std(mean(gamma{mm}{2})))];
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'r'), hold on
set(g.patch,'FaceColor',[0.5 0.3 1]);set(g.mainLine,'color',[0.5 0.3 1]*0.6);set(g.edge,'color',[0.5 0.3 1]*0.6)
temp=[];
for mm=1:m
    temp=[temp;(mean(emg{mm}{2})-mean(mean(emg{mm}{2})))/(std(mean(emg{mm}{2})))];
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'b'), hold on
set(g.patch,'FaceColor',[0.9 0.3 0.1]);set(g.mainLine,'color',[0.9 0.3 0.1]*0.6);set(g.edge,'color',[0.9 0.3 0.1]*0.6)
line([0 0],[-2 4],'color','k','linewidth',3),ylim([-2 4])

subplot(211)
temp=[];
for mm=1:m
    temp=[temp;(mean(gamma{mm}{1})-mean(mean(gamma{mm}{1})))/(std(mean(gamma{mm}{1})))];
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'r'), hold on
set(g.patch,'FaceColor',[0.5 0.3 1]);set(g.mainLine,'color',[0.5 0.3 1]*0.6);set(g.edge,'color',[0.5 0.3 1]*0.6)
temp=[];
for mm=1:m
    temp=[temp;(mean(emg{mm}{1})-mean(mean(emg{mm}{1})))/(std(mean(emg{mm}{1})))];
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'b'), hold on
set(g.patch,'FaceColor',[0.9 0.3 0.1]);set(g.mainLine,'color',[0.9 0.3 0.1]*0.6);set(g.edge,'color',[0.9 0.3 0.1]*0.6)
line([0 0],[-2 4],'color','k','linewidth',3)
ylim([-2 4])

%REM to wake
figure
temp=[];
for mm=1:m
    try
        temp=[temp;(mean(gammaR{mm}{1})-mean(mean(gammaR{mm}{1})))/(std(mean(gammaR{mm}{1})))];
    end
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'r'), hold on
set(g.patch,'FaceColor',[0.5 0.3 1]);set(g.mainLine,'color',[0.5 0.3 1]*0.6);set(g.edge,'color',[0.5 0.3 1]*0.6)
temp=[];
for mm=1:m
    try
        temp=[temp;(mean(emgR{mm}{1})-mean(mean(emgR{mm}{1})))/(std(mean(emgR{mm}{1})))];
    end
end
g=shadedErrorBar(timeaxis,mean(temp),[stdError(temp);stdError(temp)],'b'), hold on
set(g.patch,'FaceColor',[0.9 0.3 0.1]);set(g.mainLine,'color',[0.9 0.3 0.1]*0.6);set(g.edge,'color',[0.9 0.3 0.1]*0.6)
line([0 0],[-2 4],'color','k','linewidth',3)
ylim([-2 4])


%% Spectra HPC
figure
temp=[];
for mm=1:m
    temp=[temp;(mean(datH{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}~=2)'))];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
end
g=shadedErrorBar(f,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on

temp=[];
for mm=1:m
    temp=[temp;(mean(datH{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==2)'))];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
end
g=shadedErrorBar(f,nanmean(temp),[stdError(temp);stdError(temp)],'r'), hold on

temp=[];
for mm=1:m
    temp=[temp;mean(datH{mm}(:,Gam_Thresh{mm}<sortdat2{mm})')];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==0)')), hold on
end
g=shadedErrorBar(f,nanmean(temp),[stdError(temp);stdError(temp)],'k'), hold on

figure
subplot(131)
temp=[];
for mm=1:m
    temp=[temp;(mean(datH{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==1)'))];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
end
g=shadedErrorBar(f,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on

% temp=[];
% for mm=1:m
%     temp=[temp;(mean(dat{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==2)'))];
% % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
% end
% g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'r'), hold on

temp=[];
for mm=1:m
    temp=[temp;mean(datH{mm}(:,Gam_Thresh{mm}<sortdat2{mm} & RorS{mm}==0)')];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==0)')), hold on
end
g=shadedErrorBar(f,nanmean(temp),[stdError(temp);stdError(temp)],'k'), hold on

subplot(132)
temp=[];
for mm=1:m
    temp=[temp;(mean(datHH{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==1)'))];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
end
g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on

% temp=[];
% for mm=1:m
%     temp=[temp;(mean(datHH{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==2)'))];
% % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
% end
% g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'r'), hold on
%
temp=[];
for mm=1:m
    temp=[temp;mean(datHH{mm}(:,Gam_Thresh{mm}<sortdat2{mm} & RorS{mm}==0)')];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==0)')), hold on
end
g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'k'), hold on

subplot(133)
temp=[];
for mm=1:m
    temp=[temp;(mean(datP{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==1)'))];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
end
g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on

% temp=[];
% for mm=1:m
%     temp=[temp;(mean(datP{mm}(:,Gam_Thresh{mm}>sortdat2{mm} & RorS{mm}==2)'))];
% % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==1)')), hold on
% end
% g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'r'), hold on

temp=[];
for mm=1:m
    temp=[temp;mean(datP{mm}(:,Gam_Thresh{mm}<sortdat2{mm} & RorS{mm}==0)')];
    % plot(Spectro{3}, mean(datH{mm}(:,RorS{mm}==0)')), hold on
end
g=shadedErrorBar(f2,nanmean(temp),[stdError(temp);stdError(temp)],'k'), hold on

figure
for mm=1:m
    plot(Dur{mm}(RorS{mm}==1),sortdat2{mm}(RorS{mm}==1)-Gam_Thresh{mm},'*'), hold on
end
for mm=1:m
    plot(Dur{mm}(RorS{mm}==2),sortdat2{mm}(RorS{mm}==2)-Gam_Thresh{mm},'r*'), hold on
end
for mm=1:m
    plot(Dur{mm}(RorS{mm}==0),sortdat2{mm}(RorS{mm}==0)-Gam_Thresh{mm},'k*'), hold on
end
line([0 5],[0 0],'color','k','linewidth',3)


%% Ripples relation to microWake

for mm=1:m
    close all
    cd(filename{mm,1})
    load('StateEpochSB.mat','Epoch')
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    [Rip,usedEpoch]=FindRipplesKarimSB(LFP,Epoch);
    [M,T]=PlotRipRaw(LFP,Rip,50,0);
    saveas(gcf,'RipplesPlot2.png')
    saveas(gcf,'RipplesPlot2.fig')
    save('RipplesDat2.mat','Rip','usedEpoch')
end


clf
tempS=[];
tempW=[];
for mm=1:m
    cd(filename{mm,1})
    load('RipplesDat2.mat')
    [C, BS] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEMGEp{mm},RorS{mm}==1)), 1000, 40);
    tempS=[tempS,C];
    plot(BS/1E3,C,'b'), hold on
    [C, BW] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEMGEp{mm},RorS{mm}==0)), 1000, 40);
    plot(BW/1E3,C,'k'), hold on
    tempW=[tempW,C];
end

figure
plot(BW/1E3,mean(tempW'),'k')
hold on
plot(BS/1E3,mean(tempS'),'b')

