clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=4;
timebefprop=0.3;
timebefxpos=timebefprop./(1+timebefprop*2);

%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';


for m=1:length(KeepFirstSessionOnly)
    
    %% Go to file location
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    %% load data
    % Epochs
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,4*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-4*1e4,Stop(LitEp)+4*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    % OB and HPC Spectra
    load(['B_Low_Spectrum.mat'])
    Sptsd_B=tsd(Spectro{2}*1e4,Spectro{1});
    load(['H_Low_Spectrum.mat'])
    Sptsd_H=tsd(Spectro{2}*1e4,Spectro{1});
    
    % Spikes
    load('SpikeData.mat')
    numNeurons = GetSpikesFromStructure('PFCx');
    
    for ep=1:length(Start(FreezeEpoch))-1
        ActualEpoch=subset(FreezeEpoch,ep);
        Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
        
        %% Look at Normalized periods
        % define epoch
        timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
        LittleEpoch=intervalSet(Start(ActualEpoch)-timebef*1e4,Stop(ActualEpoch)+timebef*1e4);
        
        % spectra + power
        % OB
        Spec=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        % HPC
        Spec=Data(Restrict(Sptsd_H,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,LittleEpoch));
        InstSpeed_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_normPer{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_normPer{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
        end
%         
%         % Neuron firing
%         for sp=1:length(numNeurons)
%             NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(MovAcctsd,'s'))]);
%             S_temp = tsd([0.1:0.1:max(Range(MovAcctsd,'s'))]*1e4,NeurFiring);
%             Sp_temp=Data(Restrict(S_temp,LittleEpoch));
%             PFCFiring_AllMice_normPer{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
%         end
%         
        %% Look at onset periods
        % define epoch
        LittleEpoch=intervalSet(Start(ActualEpoch)-timeatTransition*1e4,Start(ActualEpoch)+timeatTransition*1e4);
        
        % spectra + power
        Spec_B=Data(Restrict(Sptsd_B,LittleEpoch));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        Spec_H=Data(Restrict(Sptsd_H,LittleEpoch));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
%         
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            
        end
        
%         % Neuron firing
%         for sp=1:length(numNeurons)
%             NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(MovAcctsd,'s'))]);
%             S_temp = tsd([0.1:0.1:max(Range(MovAcctsd,'s'))]*1e4,NeurFiring);
%             Sp_temp=Data(Restrict(S_temp,LittleEpoch));
%             PFCFiring_AllMice_Onset{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
%         end
        
        %% Look at offset periods
        % define epoch
        LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+timeatTransition*1e4);
        % spectra + power
        Spec=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        Spec=Data(Restrict(Sptsd_H,(LittleEpoch)));
         FreqBand=nanmean(Spec(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_Offset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_Offset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
        end
%         
%         % Neuron firing
%         for sp=1:length(numNeurons)
%             NeurFiring = hist(Range(S{numNeurons(sp)},'s'),[0.1:0.1:max(Range(MovAcctsd,'s'))]);
%             S_temp = tsd([0.1:0.1:max(Range(MovAcctsd,'s'))]*1e4,NeurFiring);
%             Sp_temp=Data(Restrict(S_temp,LittleEpoch));
%             PFCFiring_AllMice_Offset{m}(ep,sp,:)=interp1([1/length(Sp_temp):1/length(Sp_temp):1],Sp_temp,tps); hold on
%         end
        
    end
end

cd /home/gruffalo/Dropbox/MOBS_workingON/OB4Hz-manuscrit/DebFinFreezing
load('triggeredEvents_CleanedFreezing.mat','InstAcc_AllMice_Offset','InstAcc_AllMice_Onset','InstAcc_AllMice_normPer',...
    'InstSpeed_AllMice_Offset','InstSpeed_AllMice_Onset', 'InstSpeed_AllMice_normPer',...
    'FreqBandPower_AllMice_Offset','FreqBandPower_AllMice_Onset', 'FreqBandPower_AllMice_normPer',...
    'Spectro_AllMice_Offset','Spectro_AllMice_Onset', 'Spectro_AllMice_normPer','Dur',...
    'InstAccSmoo_AllMice_Offset','InstAccSmoo_AllMice_Onset','InstAccSmoo_AllMice_normPer')


%% Look at accelero
clear ParamFit_On_acc  ParamFit_Off_acc QualFit_Off_acc QualFit_On_acc Curve_off_acc Curve_on_acc TimeMid_on_acc TimeMid_off_acc
tpsinterp=[-1.5:0.01:1.5];
for m=[1:3,6:length(KeepFirstSessionOnly)]
    %Onset
    dattemp=(mean(InstAccSmoo_AllMice_Onset{m}));
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_on_acc(m,:)=dattemp;
    
     [fitresult, gof] = createFit_Sigmoid_Freezing(tps(1:end), fliplr((dattemp(1:end))),1);
    ParamFit_On_acc(m,:)=coeffvalues(fitresult);
    if ParamFit_On_acc(m,2)>100
        [fitresult, gof] = createFit_Sigmoid_Freezing(tps(1:end-5), fliplr((dattemp(6:end))),1);
        ParamFit_On_acc(m,:)=coeffvalues(fitresult);
    end
    QualFit_On_acc(m)=gof.rsquare;
    
    dat_inter = interp1(tpsrealigned,Curve_on_acc(m,:),tpsinterp);
    [~,TimeMid_on_acc(m)]=find(dat_inter>0.5,1,'last');
    TimeMid_on_acc(m) = tpsinterp(TimeMid_on_acc(m));
    
    if TimeMid_on_acc(m) >1
        keyboard
    end
    
    % Offset
    dattemp=mean(InstAccSmoo_AllMice_Offset{m});
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_off_acc(m,:)=dattemp;
    
    [fitresult, gof] = createFit_Sigmoid_Freezing(tps, dattemp,0);
    ParamFit_Off_acc(m,:)=coeffvalues(fitresult);
    if ParamFit_Off_acc(m,2)>100
        keyboard
    end
    QualFit_Off_acc(m)=gof.rsquare;
    
    dat_inter = interp1(tpsrealigned,Curve_off_acc(m,:),tpsinterp);
    [~,TimeMid_off_acc(m)]=find(dat_inter>0.5,1,'first');
    TimeMid_off_acc(m) = tpsinterp(TimeMid_off_acc(m));
    
end
QualFit_On_acc(QualFit_On_acc==0)=[];
ParamFit_On_acc(ParamFit_On_acc(:,1)==0,:)=[];
QualFit_Off_acc(QualFit_Off_acc==0)=[];
ParamFit_Off_acc(ParamFit_Off_acc(:,1)==0,:)=[];
TimeMin_off_acc(TimeMin_off_acc==0)=[];
TimeMax_off_acc(TimeMax_off_acc==0)=[];
TimeMin_on_acc(TimeMin_on_acc==0)=[];
TimeMax_on_acc(TimeMax_on_acc==0)=[];

Curve_off_acc(find(sum(Curve_off_acc'==0)==20),:) = [];
Curve_on_acc(find(sum(Curve_on_acc'==0)==20),:) = [];

[~,TimeMin_off_acc]=min((Curve_off_acc(:,3:end)'));
TimeMin_off_acc=TimeMin_off_acc+2;
[~,TimeMax_off_acc]=max((Curve_off_acc(:,1:18)'));

[~,TimeMin_on_acc]=min((Curve_on_acc(:,1:18)'));
[~,TimeMax_on_acc]=max((Curve_on_acc(:,3:end)'));
TimeMax_on_acc=TimeMax_on_acc+2;

figure
subplot(121)
plot(tpsrealigned,(Curve_on_acc),'color',[0.5 0.5 1],'linewidth',1), hold on
% line(mean(tpsrealigned(TimeMin_on_acc))+[-std(tpsrealigned(TimeMin_on_acc)) +std(tpsrealigned(TimeMin_on_acc))],[-0 -0],'color','k','linewidth',3)
% line(mean(tpsrealigned(TimeMax_on_acc))+[-std(tpsrealigned(TimeMax_on_acc)) +std(tpsrealigned(TimeMax_on_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_on_acc))+[-std((TimeMid_on_acc)) +std((TimeMid_on_acc))],[0.5 0.5],'color','k','linewidth',8)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 4])
box off
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlabel('Time to onset (s)')
ylabel('Acceleration - norm')


subplot(122)
plot(tpsrealigned,(Curve_off_acc),'color',[1 0.5 0.5],'linewidth',1), hold on
% line(mean(tpsrealigned(TimeMin_off_acc))+[-std(tpsrealigned(TimeMin_off_acc)) +std(tpsrealigned(TimeMin_off_acc))],[-0 -0],'color','k','linewidth',3)
% line(mean(tpsrealigned(TimeMax_off_acc))+[-std(tpsrealigned(TimeMax_off_acc)) +std(tpsrealigned(TimeMax_off_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_off_acc))+[-std((TimeMid_off_acc)) +std((TimeMid_off_acc))],[0.5 0.5],'color','k','linewidth',8)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 4])
box off
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlabel('Time to offser (s)')
ylabel('Acceleration - norm')



figure
plot(tpsrealigned,nanmean(Curve_on_acc),'color',[0.5 0.5 1],'linewidth',3), hold on
plot(tpsrealigned,fliplr(nanmean(Curve_off_acc)),'color',[1 0.5 0.5],'linewidth',3), hold on
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlim([-4 4])
box off
xlabel('Time to transition (s)')
ylabel('Acceleration - norm')

figure
clf
Vals = {ParamFit_On_acc(:,2); ParamFit_Off_acc(:,2)};
XPos = [1.1,1.9];

Cols = [0.9,0.9,1;1,0.9,0.9];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Cols(k,:),'lineColor',Cols(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',Cols(k,:)*0.8,'xValues',XPos(k),'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 2.4])
ylim([0 65])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Onset','Offset'},'linewidth',1.5,'YTick',[0:20:80])
ylabel('Slope of sigmoid fit')
box off


%%% OB 4Hz spec
clear ParamFit_On_OB  ParamFit_Off_OB QualFit_Off_OB QualFit_On_OB Curve_off_OB Curve_on_OB TimeMid_on_OB TimeMid_off_OB
tpsinterp=[-2:0.1:2];
for m=[1:3,6:length(KeepFirstSessionOnly)]
    %Onset
    dattemp=(mean(FreqBandPower_AllMice_Onset{m}));
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_on_OB(m,:)=dattemp;
    
    [fitresult, gof] = createFit_Sigmoid_Freezing(tps(1:end), ((dattemp(1:end))),1);
    ParamFit_On_OB(m,:)=coeffvalues(fitresult);
    if ParamFit_On_OB(m,2)>100
        [fitresult, gof] = createFit_Sigmoid_Freezing(tps(1:end-5), fliplr((dattemp(6:end))),1);
        ParamFit_On_OB(m,:)=coeffvalues(fitresult);
    end
    QualFit_On_OB(m)=gof.rsquare;
    
    dat_inter = interp1(tpsrealigned,Curve_on_OB(m,:),tpsinterp);
    [~,TimeMid_on_OB(m)]=find(dat_inter<0.5,1,'last');
    TimeMid_on_OB(m) = tpsinterp(TimeMid_on_OB(m));
    
 
    
    % Offset
    dattemp=mean(FreqBandPower_AllMice_Offset{m});
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_off_OB(m,:)=dattemp;
    
    [fitresult, gof] = createFit_Sigmoid_Freezing(tps, fliplr(dattemp),0);
    ParamFit_Off_OB(m,:)=coeffvalues(fitresult);
    if ParamFit_Off_OB(m,2)>100
        keyboard
    end
    QualFit_Off_OB(m)=gof.rsquare;
    
    dat_inter = interp1(tpsrealigned,Curve_off_OB(m,:),tpsinterp);
    [~,TimeMid_off_OB(m)]=find(dat_inter>0.5,1,'first');
    TimeMid_off_OB(m) = tpsinterp(TimeMid_off_OB(m));
    
end
QualFit_On_OB(QualFit_On_OB==0)=[];
ParamFit_On_OB(ParamFit_On_OB(:,1)==0,:)=[];
QualFit_Off_OB(QualFit_Off_OB==0)=[];
ParamFit_Off_OB(ParamFit_Off_OB(:,1)==0,:)=[];

Curve_off_OB(find(sum(Curve_off_OB'==0)==20),:) = [];
Curve_on_OB(find(sum(Curve_on_OB'==0)==20),:) = [];

[~,TimeMin_off_OB]=min((Curve_off_OB(:,3:end)'));
TimeMin_off_OB=TimeMin_off_OB+2;
[~,TimeMax_off_OB]=max((Curve_off_OB(:,1:18)'));

[~,TimeMin_on_OB]=min((Curve_on_OB(:,1:18)'));
[~,TimeMax_on_OB]=max((Curve_on_OB(:,3:end)'));
TimeMax_on_OB=TimeMax_on_OB+2;

figure
subplot(121)
plot(tpsrealigned,(Curve_on_OB),'color',[0.5 0.5 1],'linewidth',1), hold on
% line(mean(tpsrealigned(TimeMin_on_OB))+[-std(tpsrealigned(TimeMin_on_OB)) +std(tpsrealigned(TimeMin_on_OB))],[-0 -0],'color','k','linewidth',3)
% line(mean(tpsrealigned(TimeMax_on_OB))+[-std(tpsrealigned(TimeMax_on_OB)) +std(tpsrealigned(TimeMax_on_OB))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_on_OB))+[-std((TimeMid_on_OB)) +std((TimeMid_on_OB))],[0.5 0.5],'color','k','linewidth',8)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 4])
box off
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlabel('Time to onset (s)')
ylabel('OBeleration - norm')


subplot(122)
plot(tpsrealigned,(Curve_off_OB),'color',[1 0.5 0.5],'linewidth',1), hold on
% line(mean(tpsrealigned(TimeMin_off_OB))+[-std(tpsrealigned(TimeMin_off_OB)) +std(tpsrealigned(TimeMin_off_OB))],[-0 -0],'color','k','linewidth',3)
% line(mean(tpsrealigned(TimeMax_off_OB))+[-std(tpsrealigned(TimeMax_off_OB)) +std(tpsrealigned(TimeMax_off_OB))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_off_OB))+[-std((TimeMid_off_OB)) +std((TimeMid_off_OB))],[0.5 0.5],'color','k','linewidth',8)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 4])
box off
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlabel('Time to offser (s)')
ylabel('OBeleration - norm')



figure
plot(tpsrealigned,nanmean(Curve_on_OB),'color',[0.5 0.5 1],'linewidth',3), hold on
plot(tpsrealigned,fliplr(nanmean(Curve_off_OB)),'color',[1 0.5 0.5],'linewidth',3), hold on
set(gca,'FontSize',18,'linewidth',1.5,'XTick',[-4,0,4])
xlim([-4 4])
box off
xlabel('Time to transition (s)')
ylabel('OBeleration - norm')

figure
clf
Vals = {ParamFit_On_OB(:,2); ParamFit_Off_OB(:,2)};
XPos = [1.1,1.9];

Cols = [0.9,0.9,1;1,0.9,0.9];
for k = 1:2
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Cols(k,:),'lineColor',Cols(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    
    handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors',Cols(k,:)*0.8,'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',12)
    
end

xlim([0.5 2.4])
ylim([0 40])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Onset','Offset'},'linewidth',1.5,'YTick',[0:20:80])
ylabel('Slope of sigmoid fit')
box off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(121)
tpsrealigned=tps*8-4-0.2;
plot(tpsrealigned,fliplr(Curve_on_acc),':k'), hold on
plot(tpsrealigned,nanmean(fliplr(Curve_on_acc)),'--k','linewidth',4), hold on
plot(mean(tpsrealigned(TimeMin_on_acc)),-0.1,'k.','MarkerSize',20)
line(mean(tpsrealigned(TimeMin_on_acc))+[-std(tpsrealigned(TimeMin_on_acc)) +std(tpsrealigned(TimeMin_on_acc))],[-0.1 -0.1],'color','k','linewidth',2)
plot(mean(tpsrealigned(TimeMax_on_acc)),1.1,'k.','MarkerSize',20)
line(mean(tpsrealigned(TimeMax_on_acc))+[-std(tpsrealigned(TimeMax_on_acc)) +std(tpsrealigned(TimeMax_on_acc))],[1.1 1.1],'color','k','linewidth',2)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4.2 4.2])
title('Start Freezing')
box off

subplot(122)
plot(tpsrealigned,(Curve_off_acc),'color',[0.65 0.65 0.65]), hold on
plot(tpsrealigned,nanmean((Curve_off_acc)),'color',[0.5 0.5 0.5],'linewidth',4), hold on
% plot(mean(tpsrealigned(TimeMin_off_acc)),-0.1,'.','color',[0.4 0.4 0.4],'MarkerSize',20)
% line(mean(tpsrealigned(TimeMin_off_acc))+[-std(tpsrealigned(TimeMin_off_acc)) +std(tpsrealigned(TimeMin_off_acc))],[-0.1 -0.1],'color','k','linewidth',2)
% plot(mean(tpsrealigned(TimeMax_off_acc)),1.1,'.','color',[0.4 0.4 0.4],'MarkerSize',20)
% line(mean(tpsrealigned(TimeMax_off_acc))+[-std(tpsrealigned(TimeMax_off_acc)) +std(tpsrealigned(TimeMax_off_acc))],[1.1 1.1],'color','k','linewidth',2)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 4])
title('Stop Freezing')
box off

figure
plot(tpsrealigned,nanmean(fliplr(Curve_on_acc)),':','color','k','linewidth',4), hold on
plot(tpsrealigned,nanmean(fliplr(Curve_off_acc)),'color',[0.5 0.5 0.5],'linewidth',4), hold on
line([0 0],ylim)
box off


figure
line([0.7 1.3],[1 1]*nanmedian(ParamFit_On_acc(:,2)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ParamFit_Off_acc(:,2)),'color','k','linewidth',2)
handlesplot=plotSpread({ParamFit_On_acc(:,2),ParamFit_Off_acc(:,2)},'distributionColors',[0 0 0;0.4 0.4 0.4]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'FZ start','FZ end'})



figure
subplot(121)
PlotErrorBarN_KJ([QualFit_On_acc;QualFit_Off_acc]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'On','Off'})
ylabel('Fit error')
subplot(122)
PlotErrorBarN_KJ([ParamFit_On_acc(:,2),ParamFit_Off_acc(:,2)],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'On','Off'})
ylabel('Mid_der - sigmoid')



%%
figure
AllSpec=zeros(263,20);
clear AllPow
for m=1:length(KeepFirstSessionOnly)
    dattemp=squeeze(nanmean(Spectro_AllMice_normPer{m},1));
    dattemp=dattemp./norm(dattemp(:));
    AllSpec=AllSpec+dattemp;
    AllPow(m,:)=nanmean(FreqBandPower_AllMice_normPer{m});
end
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
subplot(3,1,1:2)
imagesc(tpsrealigned,Spectro{3},(AllSpec)), axis xy
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
subplot(3,1,3)
plot(tpsrealigned,zscore(AllPow'),'color','k'), hold on
plot(tpsrealigned,mean(zscore(AllPow')'),'color','k','linewidth',3)
line([0 0],ylim,'color','k','linewidth',3)
line([1 1],ylim,'color','k','linewidth',3)
xlim([min(tpsrealigned) max(tpsrealigned)])
ylim([-3 3])
box off



% %%%%%%%% other figrues
figure
subplot(321)
imagesc(tps*8-4,1:11,fliplr(Curve_on_acc))
title('Start Freezing')
ylabel('Acc')
subplot(322)
imagesc((Curve_off_acc))
title('Start Freezing')

subplot(323)
imagesc(Curve_on_sp)
ylabel('Speed')
subplot(324)
imagesc(fliplr(Curve_off_sp))

subplot(325)
imagesc(Curve_on)
ylabel('Accelero')
subplot(326)
imagesc(fliplr(Curve_off))

%%

AllPow=[];
Duration=[];
for m=1:length(KeepFirstSessionOnly)
    Duration=[Duration,Dur{m}];
    AllPow=[AllPow;(FreqBandPower_AllMice_normPer{m})./norm(FreqBandPower_AllMice_normPer{m})];
end
 NewMat=sortrows([Duration',AllPow]);
tpsrealigned=tps*(1+(timebefprop*2))-timebefprop;
imagesc(tpsrealigned,1:size(NewMat,1),NewMat(:,2:end))
clim([0 0.11])
line([0 0],ylim,'color','w','linewidth',3)
line([1 1],ylim,'color','w','linewidth',3)


figure
AllPow=[];
Duration=[];
for m=1:length(KeepFirstSessionOnly)
    Duration=[Duration,Dur{m}];
    AllPow=[AllPow;(FreqBandPower_AllMice_Offset{m})./norm(FreqBandPower_AllMice_Offset{m})];
end
 NewMat=sortrows([Duration',AllPow]);
tpsrealigned=tps*8-4;
imagesc(tpsrealigned,1:size(NewMat,1),NewMat(:,2:end)), hold on
clim([0 0.11])
line([0 0],ylim,'color','w','linewidth',3)
plot(2./NewMat(:,1),1:size(NewMat,1),'k','linewidth',3)

figure
AllPow=[];
Duration=[];
for m=1:length(KeepFirstSessionOnly)
    Duration=[Duration,Dur{m}];
    AllPow=[AllPow;(FreqBandPower_AllMice_Onset{m})./norm(FreqBandPower_AllMice_Onset{m})];
end
 NewMat=sortrows([Duration',AllPow]);
tpsrealigned=tps*8-4;
imagesc(tpsrealigned,1:size(NewMat,1),NewMat(:,2:end)), hold on
clim([0 0.11])
line([0 0],ylim,'color','w','linewidth',3)
plot(2./NewMat(:,1),1:size(NewMat,1),'k','linewidth',3)


% 
% %%%
% 
% figure
% NewMatBis=[];DurBis=[];
% for m=1:length(KeepFirstSessionOnly)
%     NewMatBis=[NewMatBis;NewDat{m}./(max(max(NewDat{m}))-min(min(NewDat{m})))];
%     DurBis=[DurBis;Dur{m}'];
% end
% subplot(4,4,[1,5,9])
% plot(fliplr(sort(DurBis)'),1:length(DurBis),'linewidth',3),ylim([1,length(DurBis)])
% hold on
% line([20,20],ylim,'color','k'), xlim([0 120])
% subplot(4,4,[2,3,4,6,7,8,10,11,12])
% NewMatAllmice=sortrows([DurBis*1000,NewMatBis]);
% NewMatAllmice=NewMatAllmice(:,2:end);
% imagesc(tps,1:length(DurBis),NewMatAllmice)
% line([0.1875 0.1875],ylim,'color','w','linewidth',3)
% line(1-[0.1875 0.1875],ylim,'color','w','linewidth',3)
% XL=xlim;
% clim([0.1 0.8])
% subplot(4,4,[14,15,16])
% plot([0.05:0.05:1],nanmean(NewMatAllmice),'linewidth',3), hold on
% [val,ind]=max(NewMatAllmice(:,3:end-3)');
% [Y,X]=hist(tps(ind+2),12);
% stairs(X,0.5*Y/max(Y))
% ylim([0 0.7])
% xlim(XL)
% line([1 1]*timebefxpos,ylim,'color','k','linewidth',3)
% line(1-[1 1]*timebefxpos,ylim,'color','k','linewidth',3)
% 
% % 
% %   figure
% %     subplot(141)
% %     plot(fliplr(sort(Dur{m})),1:length(Start(FreezeEpoch)),'linewidth',3),ylim([1,length(Start(FreezeEpoch))])
% %     hold on
% %     line([20,20],ylim,'color','k'), xlim([0 120])
% %     subplot(1,4,2:4)
% %     NewMat=sortrows([Dur{m}',NewDat{m}]);NewMat=NewMat(:,2:end);
% %     imagesc([0:0.05:1],1:length(Start(FreezeEpoch)),NewMat)
% %     line([0.1875 0.1875],ylim,'color','w','linewidth',3)
% %     line(1-[0.1875 0.1875],ylim,'color','w','linewidth',3)