clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=5;
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
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
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
    FreezeEpoch=dropShortIntervals(FreezeEpoch,timeatTransition*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
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
    
    for ep=1:length(Start(FreezeEpoch))-1
        ActualEpoch=subset(FreezeEpoch,ep);
        Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
        
        %% Look at Normalized periods
        % define epoch
        timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
        LittleEpoch=intervalSet(Start(ActualEpoch)-timebef*1e4,Stop(ActualEpoch)+timebef*1e4);
        
        % spectra + power
        % OB
        Spec_B=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        % HPC
        Spec_H=Data(Restrict(Sptsd_H,(LittleEpoch)));
        FreqBand=nanmean(Spec_H(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_H(:,sp),tps); hold on
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
        
        
        %% Look at onset periods
        % define epoch
        LittleEpoch=intervalSet(Start(ActualEpoch)-(timeatTransition-1)*1e4,Start(ActualEpoch)+timeatTransition*1e4);
        
        % spectra + power - OB
        Spec_B=Data(Restrict(Sptsd_B,LittleEpoch));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        
        % spectra + power - HPC
        Spec_H=Data(Restrict(Sptsd_H,LittleEpoch));
        FreqBand=nanmean(Spec_H(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_H(:,sp),tps); hold on
        end
        
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        if exist('MovAcctsd')
            MovAcc=Data(Restrict(MovAcctsd,(LittleEpoch)));
            InstAcc_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            MovAcc=Data(Restrict(MovAccSmotsd,(LittleEpoch)));
            InstAccSmoo_AllMice_Onset{m}(ep,:)=interp1([1/length(MovAcc):1/length(MovAcc):1],MovAcc,tps); hold on
            
        end
        
        
        
        %% Look at offset periods
        % define epoch
        LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+(timeatTransition-1)*1e4);
        
        % spectra + power - OB
        Spec_B=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        
        % spectra + power - HPC
        Spec_H=Data(Restrict(Sptsd_H,(LittleEpoch)));
        FreqBand=nanmean(Spec_H(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_H{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_H{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_H(:,sp),tps); hold on
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
        
    end
end




clear ParamFit_On_acc  ParamFit_Off_acc QualFit_Off_acc QualFit_On_acc Curve_on_OB4 Curve_off_OB4
%% Look at OB 4Hz
tpsrealigned=tps*10-5-0.2;
tpsinterp=[-2.5:0.01:2.5];
for m=[1:3,6:length(KeepFirstSessionOnly)]
    % Onset
    dattemp=(mean(FreqBandPower_AllMice_Onset_B{m}));
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_on_OB4(m,:)=dattemp;
    
    dat_inter = interp1(tpsrealigned,Curve_on_OB4(m,:),tpsinterp);
    [~,TimeMid_on_acc(m)]=find(dat_inter>0.5,1,'first');
    TimeMid_on_acc(m) = tpsinterp(TimeMid_on_acc(m));
    
    
    % Offset
    dattemp=mean(FreqBandPower_AllMice_Offset_B{m});
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_off_OB4(m,:)=dattemp;
    dat_inter = interp1(tpsrealigned,Curve_off_OB4(m,:),tpsinterp);
    [~,TimeMid_off_acc(m)]=find(dat_inter>0.5,1,'last');
    TimeMid_off_acc(m) = tpsinterp(TimeMid_off_acc(m));
    
    
end
TimeMid_on_acc(find(sum(Curve_on_OB4'==0)==20))=[];
TimeMid_off_acc(find(sum(Curve_off_OB4'==0)==20))=[];

Curve_off_OB4(find(sum(Curve_off_OB4'==0)==20),:) = [];
Curve_on_OB4(find(sum(Curve_on_OB4'==0)==20),:) = [];

[~,TimeMin_on_acc]=min((Curve_on_OB4(:,3:end)'));
[~,TimeMax_on_acc]=max((Curve_on_OB4'));
TimeMin_on_acc=TimeMin_on_acc+2;

[~,TimeMin_off_acc]=min((Curve_off_OB4(:,1:17)'));
[~,TimeMax_off_acc]=max((Curve_off_OB4'));



figure
subplot(121)
plot(tpsrealigned,(Curve_on_OB4),'color',[0.5 0.5 1],'linewidth',1), hold on
line(mean(tpsrealigned(TimeMin_on_acc))+[-std(tpsrealigned(TimeMin_on_acc)) +std(tpsrealigned(TimeMin_on_acc))],[-0 -0],'color','k','linewidth',3)
line(mean(tpsrealigned(TimeMax_on_acc))+[-std(tpsrealigned(TimeMax_on_acc)) +std(tpsrealigned(TimeMax_on_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_on_acc))+[-std((TimeMid_on_acc)) +std((TimeMid_on_acc))],[0.5 0.5],'color','k','linewidth',3)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 5])
title('Start Freezing')
box off


subplot(122)
plot(tpsrealigned,(Curve_off_OB4),'color',[1 0.5 0.5],'linewidth',1), hold on
line(mean(tpsrealigned(TimeMin_off_acc))+[-std(tpsrealigned(TimeMin_off_acc)) +std(tpsrealigned(TimeMin_off_acc))],[-0 -0],'color','k','linewidth',3)
line(mean(tpsrealigned(TimeMax_off_acc))+[-std(tpsrealigned(TimeMax_off_acc)) +std(tpsrealigned(TimeMax_off_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_off_acc))+[-std((TimeMid_off_acc)) +std((TimeMid_off_acc))],[0.5 0.5],'color','k','linewidth',3)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-5 4])
title('Stop Freezing')
box off


clear ParamFit_On_acc  ParamFit_Off_acc QualFit_Off_acc QualFit_On_acc Curve_on_acc Curve_off_acc
%% Look at OB 4Hz
tpsrealigned=tps*10-5-0.2;
tpsinterp=[-1.5:0.1:1.5];
for m=[1:3,6:length(KeepFirstSessionOnly)]
    % Onset
    dattemp=(mean(InstAccSmoo_AllMice_Onset{m}));
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_on_acc(m,:)=dattemp;
    
    dat_inter = interp1(tpsrealigned,Curve_on_acc(m,:),tpsinterp);
    [~,TimeMid_on_acc(m)]=find(dat_inter<0.5,1,'first');
    TimeMid_on_acc(m) = tpsinterp(TimeMid_on_acc(m));
    
    
    % Offset
    dattemp=mean(InstAccSmoo_AllMice_Offset{m});
    dattemp=(runmean(dattemp,2));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    Curve_off_acc(m,:)=dattemp;
    dat_inter = interp1(tpsrealigned,Curve_off_acc(m,:),tpsinterp);
    [~,TimeMid_off_acc(m)]=find(dat_inter<0.5,1,'last');
    TimeMid_off_acc(m) = tpsinterp(TimeMid_off_acc(m));
    
    
end
TimeMid_on_acc(find(sum(Curve_on_acc'==0)==20))=[];
TimeMid_off_acc(find(sum(Curve_off_acc'==0)==20))=[];

Curve_off_acc(find(sum(Curve_off_acc'==0)==20),:) = [];
Curve_on_acc(find(sum(Curve_on_acc'==0)==20),:) = [];

[~,TimeMin_on_acc]=min((Curve_on_acc'));
[~,TimeMax_on_acc]=max((Curve_on_acc(:,3:end)'));
TimeMax_on_acc=TimeMax_on_acc+2;

[~,TimeMin_off_acc]=min((Curve_off_acc(:,:)'));
[~,TimeMax_off_acc]=max((Curve_off_acc(:,1:17)'));



figure
subplot(121)
plot(tpsrealigned,(Curve_on_acc),'color',[0.5 0.5 1],'linewidth',1), hold on
line(mean(tpsrealigned(TimeMin_on_acc))+[-std(tpsrealigned(TimeMin_on_acc)) +std(tpsrealigned(TimeMin_on_acc))],[-0 -0],'color','k','linewidth',3)
line(mean(tpsrealigned(TimeMax_on_acc))+[-std(tpsrealigned(TimeMax_on_acc)) +std(tpsrealigned(TimeMax_on_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_on_acc))+[-std((TimeMid_on_acc)) +std((TimeMid_on_acc))],[0.5 0.5],'color','k','linewidth',3)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-4 5])
title('Start Freezing')
box off


subplot(122)
plot(tpsrealigned,(Curve_off_acc),'color',[1 0.5 0.5],'linewidth',1), hold on
line(mean(tpsrealigned(TimeMin_off_acc))+[-std(tpsrealigned(TimeMin_off_acc)) +std(tpsrealigned(TimeMin_off_acc))],[-0 -0],'color','k','linewidth',3)
line(mean(tpsrealigned(TimeMax_off_acc))+[-std(tpsrealigned(TimeMax_off_acc)) +std(tpsrealigned(TimeMax_off_acc))],[1 1],'color','k','linewidth',3)
line(mean((TimeMid_off_acc))+[-std((TimeMid_off_acc)) +std((TimeMid_off_acc))],[0.5 0.5],'color','k','linewidth',3)
ylim([-0.2 1.2])
line([0 0],ylim)
xlim([-5 4])
title('Stop Freezing')
box off