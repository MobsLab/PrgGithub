clear all,close all
Filename{1,1}='/media/DataMOBS33/DataLeo/Invivo/160527/TG31TG32/ProjetPFC-VLPO_20162705_SleepStim-wideband/TG32'; %% Mouse 32 control
Filename{1,2}='/media/DataMOBS33/DataLeo/Invivo/160525/TG32TG26/ProjetPFC-VLPO_20162505_SleepStim-wideband/TG32'; %% Mouse 32 stim
RipChan(1)=5; %Not very nice
SpinChan(1)=15; % Not very nice

Filename{2,1}='/media/DataMOBS33/DataLeo/Invivo/160525/TG32TG26/ProjetPFC-VLPO_20162505_SleepStim-wideband/TG26/'; %% Mouse 26 control
Filename{2,2}='/media/DataMOBS33/DataLeo/Invivo/160526/TG26TG31/ProjetPFC-VLPO_20162605_SleepStim/TG26/'; %% Mouse 26 stim
RipChan(2)=6; %Good ripples
SpinChan(2)=11; % Not much going on

Filename{3,1}='/media/DataMOBS33/DataLeo/Invivo/160526/TG26TG31/ProjetPFC-VLPO_20162605_SleepStim/TG31/'; %% Mouse 31 control
Filename{3,2}='/media/DataMOBS33/DataLeo/Invivo/160527/TG31TG32/ProjetPFC-VLPO_20162705_SleepStim-wideband/TG31/'; %% Mouse 31 stim
RipChan(3)=NaN; %No ripples
SpinChan(3)=7; % Amazing

for k=1:3
    k
    for kk=1:2
        kk
        % Ctl mouse:1, test mouse =2
        cd(Filename{k,kk})
        res=pwd;
        load([res,'/LFPData/InfoLFP']);
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);
        load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        WakeWiNoise=Or(Wake,Or(NoiseEpoch,GndNoiseEpoch));
        try
            WeirdNoiseEpoch;
            WakeWiNoise=Or(WakeWiNoise,WeirdNoiseEpoch);
            clear WeirdNoiseEpoch
        end
        load('TTLInfo.mat')
        Val{k,kk}(1)=length(Data(Restrict(LFP,SWSEpoch)))./length(Data(LFP));
        Val{k,kk}(2)=length(Data(Restrict(LFP,WakeWiNoise)))./length(Data(LFP));
        Val{k,kk}(3)=length(Data(Restrict(LFP,REMEpoch)))./length(Data(LFP));
        
        Val{k,kk}(4)=length(Data(Restrict(LFP,And(SWSEpoch,StimONPer))))./length(Data(Restrict(LFP,StimONPer)));
        Val{k,kk}(5)=length(Data(Restrict(LFP,And(WakeWiNoise,StimONPer))))./length(Data(Restrict(LFP,StimONPer)));
        Val{k,kk}(6)=length(Data(Restrict(LFP,And(REMEpoch,StimONPer))))./length(Data(Restrict(LFP,StimONPer)));
        
        Val{k,kk}(7)=length(Data(Restrict(LFP,And(SWSEpoch,StimOFFPer))))./length(Data(Restrict(LFP,StimOFFPer)));
        Val{k,kk}(8)=length(Data(Restrict(LFP,And(WakeWiNoise,StimOFFPer))))./length(Data(Restrict(LFP,StimOFFPer)));
        Val{k,kk}(9)=length(Data(Restrict(LFP,And(REMEpoch,StimOFFPer))))./length(Data(Restrict(LFP,StimOFFPer)));
        Val{k,kk}(10)=min(Start(StimONPer))<min(Start(StimOFFPer));
        
        for t=1:length(Start(StimONPer))
            Temp{k,kk}(1,t)= length(Data(Restrict(LFP,And(SWSEpoch,subset(StimONPer,t)))))./length(Data(Restrict(LFP,subset(StimONPer,t))));
            Temp{k,kk}(2,t)= length(Data(Restrict(LFP,And(WakeWiNoise,subset(StimONPer,t)))))./length(Data(Restrict(LFP,subset(StimONPer,t))));
            Temp{k,kk}(3,t)= length(Data(Restrict(LFP,And(REMEpoch,subset(StimONPer,t)))))./length(Data(Restrict(LFP,subset(StimONPer,t))));
        end
        
        for t=1:length(Start(StimOFFPer))
            Temp{k,kk}(4,t)= length(Data(Restrict(LFP,And(SWSEpoch,subset(StimOFFPer,t)))))./length(Data(Restrict(LFP,subset(StimOFFPer,t))));
            Temp{k,kk}(5,t)= length(Data(Restrict(LFP,And(WakeWiNoise,subset(StimOFFPer,t)))))./length(Data(Restrict(LFP,subset(StimOFFPer,t))));
            Temp{k,kk}(6,t)= length(Data(Restrict(LFP,And(REMEpoch,subset(StimOFFPer,t)))))./length(Data(Restrict(LFP,subset(StimOFFPer,t))));
        end
    end
end


CtrlVals=reshape([Val{:,1}],10,3);
TestVals=reshape([Val{:,2}],10,3);
close all
titre={'SWS','Wake','REM'}

figure
for t=1:3
    subplot(1,3,t)
    A=CtrlVals(t,:);
    B=TestVals(t,:);
    bar([1,2],mean([A;B]'),'FaceColor',[0.6 0.6 0.6]), hold on
    plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
    plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
    %plot([A;B],'k')
    xlim([0.5 2.5])
    box off
    title(titre{t})
    set(gca,'XTick',[1,2],'XTickLabel',{'Ctrl','Stim'})
end


titre={'SWS','Wake','REM'}
figure
for t=1:3
    subplot(1,3,t)
    A=CtrlVals(6+t,:);
    B=CtrlVals(3+t,:);
    bar([1,2],mean([A;B]'),'FaceColor',[0.6 0.6 0.6]), hold on
    plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
    plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
    plot([A;B],'k')
    xlim([0.5 2.5])
    box off
    title(titre{t})
    set(gca,'XTick',[1,2],'XTickLabel',{'OFF','ON'})
end


titre={'SWS','Wake','REM'}
figure
for t=1:3
    subplot(1,3,t)
    A=TestVals(6+t,:);
    B=TestVals(3+t,:);
    bar([1,2],mean([A;B]'),'FaceColor',[0.6 0.6 0.6]), hold on
    plot(1*ones(length(A),1),A,'ko','markerfacecolor','w')
    plot(2*ones(length(B),1),B,'ko','markerfacecolor','w')
    plot([A;B],'k')
    xlim([0.5 2.5])
    box off
    title(titre{t})
    set(gca,'XTick',[1,2],'XTickLabel',{'OFF','ON'})
end

for kk=1:2
    figure
    for k=1:3
        Temp{k,kk}(Temp{k,kk}==0)=NaN;
        scatter(Temp{k,kk}(1,:),Temp{k,kk}(4,:),50,[1:length(Temp{k,kk}(4,:))],'filled'), hold on
        plot(Temp{k,kk}(1,:),Temp{k,kk}(4,:),'k')
    end
    xlabel('SWS stim on')
    ylabel('SWS stim off')
    plot([0:1],[0:1])
end


close all
for k=1:3
    figure
    scatter(Temp{k,1}(1,1:4),Temp{k,2}(1,1:4),50,[1:length(Temp{k,1}(1,1:4))],'filled'), hold on
    plot(Temp{k,1}(1,1:4),Temp{k,2}(1,1:4),'k')
    
    xlabel('SWS stim on ctrl')
    ylabel('SWS stim on test')
    plot([0:1],[0:1])
end

%close all
for k=1:3
    k
    for kk=1:2
        kk
        % Ctl mouse:1, test mouse =2
        cd(Filename{k,kk})
        res=pwd;
        load([res,'/LFPData/InfoLFP']);
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);
        load('StateEpochEMGSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        WakeWiNoise=Or(Wake,Or(NoiseEpoch,GndNoiseEpoch));
        try
            WeirdNoiseEpoch;
            WakeWiNoise=Or(WakeWiNoise,WeirdNoiseEpoch);
            clear WeirdNoiseEpoch
        end
        load('TTLInfo.mat');StimTime=ts(Start(Stim));
        load('PFC_Low_Spectrum.mat')
        Stsd=tsd(Spectro{2}*1e4,Spectro{1});
        AverageSpectrogram(Stsd,Spectro{3},Restrict(StimTime,SWSEpoch),200,200,1,0,0);
    end
end



clear all,close all
Filename{1,1}='/media/DataMOBS33/DataLeo/Invivo/160527/TG31TG32/ProjetPFC-VLPO_20162705_SleepStim-wideband/TG32'; %% Mouse 32 control
Filename{1,2}='/media/DataMOBS33/DataLeo/Invivo/160525/TG32TG26/ProjetPFC-VLPO_20162505_SleepStim-wideband/TG32'; %% Mouse 32 stim
RipChan(1)=5; %Not very nice
SpinChan(1)=15; % Not very nice

Filename{2,1}='/media/DataMOBS33/DataLeo/Invivo/160525/TG32TG26/ProjetPFC-VLPO_20162505_SleepStim-wideband/TG26/'; %% Mouse 26 control
Filename{2,2}='/media/DataMOBS33/DataLeo/Invivo/160526/TG26TG31/ProjetPFC-VLPO_20162605_SleepStim/TG26/'; %% Mouse 26 stim
RipChan(2)=6; %Good ripples
SpinChan(2)=11; % Not much going on

Filename{3,1}='/media/DataMOBS33/DataLeo/Invivo/160526/TG26TG31/ProjetPFC-VLPO_20162605_SleepStim/TG31/'; %% Mouse 31 control
Filename{3,2}='/media/DataMOBS33/DataLeo/Invivo/160527/TG31TG32/ProjetPFC-VLPO_20162705_SleepStim-wideband/TG31/'; %% Mouse 31 stim
RipChan(3)=NaN; %No ripples
SpinChan(3)=7; % Amazing

for k=1:3
    for kk=1:2
        cd(Filename{k,kk})
        LowSpectrumSB(Filename{k,kk},SpinChan(k),'PFC');
    end
end



%close all
for k=1:3
    k
    for kk=1:2
        kk
        % Ctl mouse:1, test mouse =2
        cd(Filename{k,kk})
        res=pwd;
        load([res,'/LFPData/InfoLFP']);
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);
        load('StateEpochEMGSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        WakeWiNoise=Or(Wake,Or(NoiseEpoch,GndNoiseEpoch));
        try
            WeirdNoiseEpoch;
            WakeWiNoise=Or(WakeWiNoise,WeirdNoiseEpoch);
            clear WeirdNoiseEpoch
        end
        load('TTLInfo.mat');StimTime=ts(Start(Stim));
        load('B_High_Spectrum.mat')
        Stsd=tsd(Spectro{2}*1e4,Spectro{1});
        AverageSpectrogram(Stsd,Spectro{3},Restrict(StimTime,SWSEpoch),400,200,1,0,0);
    end
end


close all
for k=1:3
    k
    for kk=1:2
        kk
        % Ctl mouse:1, test mouse =2
        cd(Filename{k,kk})
        res=pwd;
        load([res,'/LFPData/InfoLFP']);
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);
        load('StateEpochEMGSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        WakeWiNoise=Or(Wake,Or(NoiseEpoch,GndNoiseEpoch));
        try
            WeirdNoiseEpoch;
            WakeWiNoise=Or(WakeWiNoise,WeirdNoiseEpoch);
            clear WeirdNoiseEpoch
        end
        load('TTLInfo.mat');StimTime=ts(Start(Stim));
        load('H_Low_Spectrum.mat')
        Stsd=tsd(Spectro{2}*1e4,Spectro{1});
        StimTime=Restrict(StimTime,SWSEpoch);
        St=Range(StimTime);
        for t=1:length(St)
            StUse=ts(St(t));
            temp=AverageSpectrogram(Stsd,Spectro{3},StUse,200,200,0,0,0);
            ValSp{k,kk}(t,1)=mean(mean(temp([find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')],1:99)));
            ValSp{k,kk}(t,2)=mean(mean(temp([find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')],101:201)));
        end
    end
end
KeepSp1=ValSp;


Titre={'Ctrl','Stim'};
for k=1:3
    k
    figure
    for kk=1:2
        kk
        subplot(1,2,kk)
        bar(mean(ValSp{k,kk}),'FaceColor',[0.3 0.3 0.3]), hold on
        plot(1,ValSp{k,kk}(:,1),'k*')
        plot(2,ValSp{k,kk}(:,2),'k*')
        plot([ValSp{k,kk}(:,1),ValSp{k,kk}(:,2)]','color','k')
        title(Titre{kk})
        [h,p]=ttest(ValSp{k,kk}(:,1),ValSp{k,kk}(:,2));
        p
        sigstar({[1,2]},p)
    end
end

clear ValSp;
%close all
for k=1:3
    k
    for kk=1:2
        kk
        % Ctl mouse:1, test mouse =2
        cd(Filename{k,kk})
        res=pwd;
        load([res,'/LFPData/InfoLFP']);
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);
        load('StateEpochEMGSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        WakeWiNoise=Or(Wake,Or(NoiseEpoch,GndNoiseEpoch));
        try
            WeirdNoiseEpoch;
            WakeWiNoise=Or(WakeWiNoise,WeirdNoiseEpoch);
            clear WeirdNoiseEpoch
        end
        load('TTLInfo.mat');StimTime=ts(Start(Stim));
        load('PFC_Low_Spectrum.mat')
        Stsd=tsd(Spectro{2}*1e4,Spectro{1});
        StimTime=Restrict(StimTime,SWSEpoch);
        St=Range(StimTime);
        for t=1:length(St)
            StUse=ts(St(t));
            temp=AverageSpectrogram(Stsd,Spectro{3},StUse,200,200,0,0,0);
            ValSp{k,kk}(t,1)=mean(mean(temp([find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')],1:99)));
            ValSp{k,kk}(t,2)=mean(mean(temp([find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')],101:201)));
        end
    end
end

KeepSp2=ValSp;

Titre={'Ctrl','Stim'};
for k=1:3
    k
    figure
    for kk=1:2
        kk
        subplot(1,2,kk)
        bar(mean(ValSp{k,kk}),'FaceColor',[0.3 0.3 0.3]), hold on
        plot(1,ValSp{k,kk}(:,1),'k*')
        plot(2,ValSp{k,kk}(:,2),'k*')
        plot([ValSp{k,kk}(:,1),ValSp{k,kk}(:,2)]','color','k')
        title(Titre{kk})
        [h,p]=ttest(ValSp{k,kk}(:,1),ValSp{k,kk}(:,2));
        p
        sigstar({[1,2]},p)
    end
end



cd /media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG26
load('/media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG26/StateEpochSB.mat')
load('/media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG26/TTLInfo.mat')
load('/media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG26/H_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
figure,
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimONPer)))),'b')
hold on
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimOFFPer)))),'--b')
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimONPer)))),'r')
hold on
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimOFFPer)))),'--r')
plot(mean(Data(Restrict(Sptsd,And(Wake,StimONPer)))),'k')
hold on
plot(mean(Data(Restrict(Sptsd,And(Wake,StimOFFPer)))),'--k')

     LowSpectrumSB([cd '/'],7,'PFC');

load('/media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG26/PFC_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,10*log10(Spectro{1}));
figure,
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimONPer)))),'b')
hold on
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimOFFPer)))),'--b')
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimONPer)))),'r')
hold on
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimOFFPer)))),'--r')
plot(mean(Data(Restrict(Sptsd,And(Wake,StimONPer)))),'k')
hold on
plot(mean(Data(Restrict(Sptsd,And(Wake,StimOFFPer)))),'--k')



[tDelta,DeltaEpoch]=FindDeltaWavesChanGL('PFCx',SWSEpoch,[8,6],1);
[tDelta,DeltaEpoch]=FindDeltaWavesChanGL('PFC',SWSEpoch,[14,6],1);

load('LFPData/LFP7.mat')
tbins=4;nbbins=300;
figure
[ma1,sa1,tpsa1]=mETAverage(Range(ts(tDelta(2:end-1))), Range(LFP),Data(LFP),tbins,nbbins);
plot(tpsa1,ma1,'b','linewidth',2),hold on
plot(tpsa1,ma1+sa1,'b','linewidth',1),
plot(tpsa1,ma1-sa1,'b','linewidth',1),



cd /media/DataMOBS33/DataLeo/Invivo/160603/TG31TG26/ProjetPFC-VLPO_20160306_SleepStim-wideband/All/TG31
load('StateEpochSB.mat')
load('TTLInfo.mat')
load('H_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
figure,
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimONPer)))),'b')
hold on
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimOFFPer)))),'--b')
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimONPer)))),'r')
hold on
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimOFFPer)))),'--r')
plot(mean(Data(Restrict(Sptsd,And(Wake,StimONPer)))),'k')
hold on
plot(mean(Data(Restrict(Sptsd,And(Wake,StimOFFPer)))),'--k')

     LowSpectrumSB([cd '/'],6,'PFCx');

load('PFCx_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,10*log10(Spectro{1}));
figure,
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimONPer)))),'b')
hold on
plot(mean(Data(Restrict(Sptsd,And(SWSEpoch,StimOFFPer)))),'--b')
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimONPer)))),'r')
hold on
plot(mean(Data(Restrict(Sptsd,And(REMEpoch,StimOFFPer)))),'--r')
plot(mean(Data(Restrict(Sptsd,And(Wake,StimONPer)))),'k')
hold on
plot(mean(Data(Restrict(Sptsd,And(Wake,StimOFFPer)))),'--k')
