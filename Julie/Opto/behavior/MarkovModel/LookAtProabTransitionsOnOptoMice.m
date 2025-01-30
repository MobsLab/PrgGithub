clear all
close all
%29.11.2017

cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;
% load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
%     'csm','csp','CSplInt','CSmiInt')
% load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')

load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
    'csm','csp','CSplInt','CSmiInt')
load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer')
sav=0;
colori={[0 0 0]; [0 0.7 1]};
%% distribution
% if 1
maxlength=100;
pas=2;
EpisodeDurAllmice_gfp=[];
n=4;
h_cumsum=figure('Position',[ 88         537        1618         400]);
Xlabels={'2 CS- no laser';'2 CS+ no laser'; 'CS+ +laser';};
NbEp_gfp=nan(length(gfpmice),4);
NbEp_ch=nan(length(chr2mice),4);
MeanDurEp_gfp=nan(length(gfpmice),4);
MeanDurEp_ch=nan(length(chr2mice),4);
EpAboveTh_gfp=nan(length(gfpmice),4);
EpAboveTh_ch=nan(length(chr2mice),4);
PropEpAboveTh_gfp=nan(length(gfpmice),4);
PropEpAboveTh_ch=nan(length(chr2mice),4);

EndSessionTime = 1400;

DurTh=20;
EPOI_All = {CsminPer,CspluPer0,CspluPer1,CspluPer2,CspluPer3};

for stepsize = 2
    for k=1:3
        if k==1
            EPOI = CsminPer;
        elseif k==2
            EPOI = CspluPer0;
        elseif k==3
            EPOI = CspluPer1;
        end
        
        a=1;
        for man=gfpmice
            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_GFP(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_GFP(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            
            NumInit_GFP(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./length(BinData_FZ_val);
            TutDur_GFP(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            
            DurFzEp_GFP(a,k)=nanmean(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s')-Start(and(EPOI,bilanFreezeAccEpoch{man}),'s'));
            
            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-bilanFreezeAccEpoch{man});
            DurActEp_GFP(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));

            
            
            a=a+1;
        end
        
        
        a=1;
        for man=chr2mice
            
            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_CHR2(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_CHR2(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            NumInit_CHR2(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./length(BinData_FZ_val);
            TutDur_CHR2(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            
            DurFzEp_CHR2(a,k)=nanmean(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s')-Start(and(EPOI,bilanFreezeAccEpoch{man}),'s'));
            
            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-bilanFreezeAccEpoch{man});
            DurActEp_CHR2(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
            
            a=a+1;
        end
        
        
    end
    Xlabels={'2 CS- no laser';'2 CS+ no laser'; 'CS+ +laser';};
    %% Figures with probabilities
    figure
    subplot(211)
    hold on
    errorbar([1:3],nanmean(StayFz_CHR2),stdError(StayFz_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
    errorbar([1:3],nanmean(StayFz_GFP),stdError(StayFz_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
    handles = plotSpread({StayFz_CHR2(:,1);StayFz_CHR2(:,2);StayFz_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
    set(handles{1},'MarkerSize',15)
    handles = plotSpread({StayFz_GFP(:,1);StayFz_GFP(:,2);StayFz_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
    set(handles{1},'MarkerSize',15)
    for k=1:3
        [p,h]=ranksum(StayFz_CHR2(:,k),StayFz_GFP(:,k));
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
        end
    end
    
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Proba Fz --> Fz')
    subplot(212)
    errorbar([1:3],nanmean(ChangeAct_CHR2),stdError(ChangeAct_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
    errorbar([1:3],nanmean(ChangeAct_GFP),stdError(ChangeAct_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
    handles = plotSpread({ChangeAct_CHR2(:,1);ChangeAct_CHR2(:,2);ChangeAct_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
    set(handles{1},'MarkerSize',15)
    handles = plotSpread({ChangeAct_GFP(:,1);ChangeAct_GFP(:,2);ChangeAct_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
    set(handles{1},'MarkerSize',15)
    for k=1:3
        [p,h]=ranksum(ChangeAct_CHR2(:,k),ChangeAct_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
            
        end
    end
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Proba Act --> Fz')
    box off
    
    
    figure
    subplot(211)
    errorbar([1:3],nanmean(StayFz_CHR2),stdError(StayFz_CHR2),'b','linewidth',3), hold on
    errorbar([1:3],nanmean(StayFz_GFP),stdError(StayFz_GFP),'g','linewidth',3)
    for k=1:3
        [p,h]=ranksum(StayFz_CHR2(:,k),StayFz_GFP(:,k));
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
        end
    end
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Proba Fz/Fz')
    
    subplot(212)
    errorbar([1:3],nanmean(ChangeAct_CHR2),stdError(ChangeAct_CHR2),'b','linewidth',3), hold on
    errorbar([1:3],nanmean(ChangeAct_GFP),stdError(ChangeAct_GFP),'g','linewidth',3)
    for k=1:3
        [p,h]=ranksum(ChangeAct_CHR2(:,k),ChangeAct_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
            
        end
    end
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Proba Act/Fz')
    
    %% Figures with duration
    figure
    subplot(211)
    hold on
    errorbar([1:3],nanmean(DurFzEp_CHR2),stdError(DurFzEp_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
    errorbar([1:3],nanmean(DurFzEp_GFP),stdError(DurFzEp_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
    handles = plotSpread({DurFzEp_CHR2(:,1);DurFzEp_CHR2(:,2);DurFzEp_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
    set(handles{1},'MarkerSize',15)
    handles = plotSpread({DurFzEp_GFP(:,1);DurFzEp_GFP(:,2);DurFzEp_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
    set(handles{1},'MarkerSize',15)
    for k=1:3
        [p,h]=ranksum(DurFzEp_CHR2(:,k),DurFzEp_GFP(:,k));
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
        end
    end
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Mean freezing episode duration')
    subplot(212)
    errorbar([1:3],nanmean(DurActEp_CHR2),stdError(DurActEp_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
    errorbar([1:3],nanmean(DurActEp_GFP),stdError(DurActEp_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
    handles = plotSpread({DurActEp_CHR2(:,1);DurActEp_CHR2(:,2);DurActEp_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
    set(handles{1},'MarkerSize',15)
    handles = plotSpread({DurActEp_GFP(:,1);DurActEp_GFP(:,2);DurActEp_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
    set(handles{1},'MarkerSize',15)
    for k=1:3
        [p,h]=ranksum(DurActEp_CHR2(:,k),DurActEp_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
            
        end
    end
    xlim([0.5 3.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Mean active episode duration')
 
    box off
    
    %% correlate mean episode duration of two types of behaviour
    %% same axes
    figure
    for k = 1:3
        subplot(1,3,k)
        plot(DurFzEp_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        ylabel('Mean active episode duration')
        xlabel('Mean freezing episode duration')
        xlim([0 30]), ylim([0 30])
    end
    
    %% free axes
    figure
    for k = 1:3
        subplot(1,3,k)
        plot(DurFzEp_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        ylabel('Mean active episode duration')
        xlabel('Mean freezing episode duration')
    end
    
    %% correlate mean episode duration of two types of behaviour and start stop
    figure
    for k = 1:3
        subplot(3,3,k)
        plot(DurFzEp_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        ylabel('Act Ep dur')
        xlabel('Fz Ep dur')
        [R,P] = corrcoef(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'Rows','complete');
        if P(1,2)<0.05
            text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
            text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))
        end
        
        title(Xlabels{k})
        subplot(3,3,3+k)
        plot(DurFzEp_CHR2(:,k),NumInit_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),NumInit_GFP(:,k),'g.','MarkerSize',20), hold on
        xlabel('Fz Ep dur')
        ylabel('Num of fz ep')
        [R,P] = corrcoef(DurFzEp_GFP(:,k),NumInit_GFP(:,k),'Rows','complete');
        if P(1,2)<0.05
            text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
            text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))
        end
        
        subplot(3,3,6+k)
        plot(NumInit_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(NumInit_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        xlabel('Num of fz ep')
        ylabel('Act Ep dur')
        [R,P] = corrcoef(NumInit_GFP(:,k),DurActEp_GFP(:,k),'Rows','complete');
        if P(1,2)<0.05
            text(max(xlim)*0.8,max(ylim)*0.8,num2str(round(P(1,2)*1000)/1000))
            text(max(xlim)*0.8,max(ylim)*0.6,num2str(round(R(1,2)*1000)/1000))
        end
        
    end
    
    figure
    for k = 1:3
        subplot(3,3,k)
        plot(DurFzEp_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        ylabel('Act Ep dur')
        xlabel('Fz Ep dur')
        xlim([0 30]), ylim([0 30])
        title(Xlabels{k})
        subplot(3,3,3+k)
        plot(DurFzEp_CHR2(:,k),NumInit_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(DurFzEp_GFP(:,k),NumInit_GFP(:,k),'g.','MarkerSize',20), hold on
        xlabel('Fz Ep dur')
        ylabel('Num of fz ep')
        xlim([0 30]), ylim([0 30])
        subplot(3,3,6+k)
        plot(NumInit_CHR2(:,k),DurActEp_CHR2(:,k),'b.','MarkerSize',20), hold on
        plot(NumInit_GFP(:,k),DurActEp_GFP(:,k),'g.','MarkerSize',20), hold on
        xlabel('Num of fz ep')
        ylabel('Act Ep dur')
        xlim([0 30]), ylim([0 30])
        
    end
    
    %%%
    figure
    subplot(211)
    plot([1:3],(DurFzEp_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(DurFzEp_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Stay Freezing')
    xlim([0.5 3.5])
    subplot(212)
    plot([1:3],(DurActEp_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(DurActEp_GFP'),'g','linewidth',2)
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Sart Freezing')
    xlim([0.5 3.5])
    
      
    figure
    subplot(211)
    plot([1:3],(StayFz_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(StayFz_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Stay Freezing')
    xlim([0.5 3.5])
    subplot(212)
    plot([1:3],(ChangeAct_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(ChangeAct_GFP'),'g','linewidth',2)
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    ylabel('Sart Freezing')
    xlim([0.5 3.5])

    figure
    subplot(211)
    errorbar([1:3],nanmean(NumInit_CHR2),stdError(NumInit_CHR2),'b','linewidth',3), hold on
    errorbar([1:3],nanmean(NumInit_GFP),stdError(NumInit_GFP),'g','linewidth',3)
    for k=1:3
        [p,h]=ranksum(NumInit_CHR2(:,k),NumInit_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,30,num2str(p))
        end
    end
    xlim([0.5 3.5])
    subplot(212)
    plot([1:3],(NumInit_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(NumInit_GFP'),'g','linewidth',2)
    xlim([0.5 3.5])

    figure
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
    
    
    figure   
    subplot(211)
    errorbar([1:3],nanmean(TutDur_CHR2),stdError(TutDur_CHR2),'b','linewidth',3), hold on
    errorbar([1:3],nanmean(TutDur_GFP),stdError(TutDur_GFP),'g','linewidth',3)
    for k=1:3
        [p,h]=ranksum(TutDur_CHR2(:,k),TutDur_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,300,num2str(p))
        end
    end
    subplot(212)
    plot([1:3],(TutDur_CHR2'),'b','linewidth',2), hold on
    plot([1:3],(TutDur_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
end


%%%
clear all
%29.11.2017

cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;
% load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
%     'csm','csp','CSplInt','CSmiInt')
% load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')

load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
    'csm','csp','CSplInt','CSmiInt')
load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')
sav=0;
colori={[0 0 0]; [0 0.7 1]};
%% distribution
% if 1
maxlength=100;
pas=2;
EpisodeDurAllmice_gfp=[];
n=4;
h_cumsum=figure('Position',[ 88         537        1618         400]);
Xlabels={'2 CS- no laser';'2 CS+ no laser'; '2 CS+ +laser'; '4 CS+ +laser'; '4 CS+ +laser'; };
NbEp_gfp=nan(length(gfpmice),4);
NbEp_ch=nan(length(chr2mice),4);
MeanDurEp_gfp=nan(length(gfpmice),4);
MeanDurEp_ch=nan(length(chr2mice),4);
EpAboveTh_gfp=nan(length(gfpmice),4);
EpAboveTh_ch=nan(length(chr2mice),4);
PropEpAboveTh_gfp=nan(length(gfpmice),4);
PropEpAboveTh_ch=nan(length(chr2mice),4);
DurTh=20;
EPOI_All = {CsminPer,CspluPer0,CspluPer1,CspluPer2,CspluPer3};
for stepsize = 0.5
    for k=1:5
     EPOI = EPOI_All{k};
        
        a=1;
        for man=gfpmice
            tps = [0:stepsize:1200]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_GFP(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_GFP(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            NumInit_GFP(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1);
            TutDur_GFP(a,k)=sum(BinData_FZ_val==1);
            
            EpisodeDur=End(and(bilanFreezeAccEpoch{man}, EPOI))-Start(and(bilanFreezeAccEpoch{man}, EPOI));
            MeanEp_GFP(a,k)=nanmean(EpisodeDur);

            a=a+1;
        end
        
        
        a=1;
        for man=chr2mice
            
            tps = [0:stepsize:1200]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_CHR2(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_CHR2(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            NumInit_CHR2(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1);
            TutDur_CHR2(a,k)=sum(BinData_FZ_val==1);
            
            EpisodeDur=End(and(bilanFreezeAccEpoch{man}, EPOI))-Start(and(bilanFreezeAccEpoch{man}, EPOI));
            MeanEp_CHR2(a,k)=nanmean(EpisodeDur);

                    
            a=a+1;
        end
        
        
    end
    
    
    figure
    subplot(211)
    errorbar([1:5],nanmean(StayFz_CHR2),stdError(StayFz_CHR2),'b','linewidth',3), hold on
    errorbar([1:5],nanmean(StayFz_GFP),stdError(StayFz_GFP),'g','linewidth',3)
    for k=1:5
        [p,h]=ranksum(StayFz_CHR2(:,k),StayFz_GFP(:,k));
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
        end
    end
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    ylabel('Stay Freezing')
    subplot(212)
    errorbar([1:5],nanmean(ChangeAct_CHR2),stdError(ChangeAct_CHR2),'b','linewidth',3), hold on
    errorbar([1:5],nanmean(ChangeAct_GFP),stdError(ChangeAct_GFP),'g','linewidth',3)
    for k=1:5
        [p,h]=ranksum(ChangeAct_CHR2(:,k),ChangeAct_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,0.9,num2str(p))
            
        end
    end
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    ylabel('Sart Freezing')
    
    figure
    subplot(211)
    plot([1:5],(StayFz_CHR2'),'b','linewidth',2), hold on
    plot([1:5],(StayFz_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    ylabel('Stay Freezing')
    subplot(212)
    plot([1:5],(ChangeAct_CHR2'),'b','linewidth',2), hold on
    plot([1:5],(ChangeAct_GFP'),'g','linewidth',2)
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    ylabel('Sart Freezing')
    
    figure
    subplot(211)
    errorbar([1:5],nanmean(NumInit_CHR2),stdError(NumInit_CHR2),'b','linewidth',3), hold on
    errorbar([1:5],nanmean(NumInit_GFP),stdError(NumInit_GFP),'g','linewidth',3)
    for k=1:5
        [p,h]=ranksum(NumInit_CHR2(:,k),NumInit_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,30,num2str(p))
        end
    end
    subplot(212)
    plot([1:5],(NumInit_CHR2'),'b','linewidth',2), hold on
    plot([1:5],(NumInit_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    
    
    figure   
    subplot(211)
    errorbar([1:5],nanmean(TutDur_CHR2),stdError(TutDur_CHR2),'b','linewidth',3), hold on
    errorbar([1:5],nanmean(TutDur_GFP),stdError(TutDur_GFP),'g','linewidth',3)
    for k=1:5
        [p,h]=ranksum(TutDur_CHR2(:,k),TutDur_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,300,num2str(p))
        end
    end
    subplot(212)
    plot([1:5],(TutDur_CHR2'),'b','linewidth',2), hold on
    plot([1:5],(TutDur_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
    
    
     figure   
    subplot(211)
    errorbar([1:5],nanmean(MeanEp_CHR2),stdError(MeanEp_CHR2),'b','linewidth',3), hold on
    errorbar([1:5],nanmean(MeanEp_GFP),stdError(MeanEp_GFP),'g','linewidth',3)
    for k=1:5
        [p,h]=ranksum(MeanEp_CHR2(:,k),MeanEp_GFP(:,k))
        if p<0.05
            plot(k,1,'r*')
            text(k,300,num2str(p))
        end
    end
    subplot(212)
    plot([1:5],(MeanEp_CHR2'),'b','linewidth',2), hold on
    plot([1:5],(MeanEp_GFP'),'g','linewidth',2)
    xlim([0.5 5.5])
    set(gca,'XTick',[1:5],'XTickLabel',Xlabels)
end