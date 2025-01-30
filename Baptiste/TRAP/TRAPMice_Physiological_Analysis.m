
clear all
Dir{1} = PathForExperimentsTRAPMice('TestA');
Dir{2} = PathForExperimentsTRAPMice('TestB');
Dir{3} = PathForExperimentsTRAPMice('TestC');

Day={'Day1','Day2','Day3'};
Mouse_names={'M923','M926','M927','M928','M929'};
Mouse=[923 926 927 928 929];

for sess=1:3
    Sess2.M923{sess}=Dir{1, 3}.path{1, 1}{sess};
    Sess2.M926{sess}=Dir{1, 3}.path{1, 2}{sess};
    Sess2.M927{sess}=Dir{1, 3}.path{1, 3}{sess};
    Sess2.M928{sess}=Dir{1, 3}.path{1, 4}{sess};
    Sess2.M929{sess}=Dir{1, 3}.path{1, 5}{sess};
end

for mouse=1:5
    for sess=1:3
        cd(Sess2.(Mouse_names{mouse}){sess})
        
        load('behavResources.mat')
        load('InstFreqAndPhase_B.mat')
        TotalEpoch = intervalSet(0,max(Range(MovAcctsd)));
        Non_FreezingAccEpoch=TotalEpoch-FreezeAccEpoch;
        
        % Freezing quantity
        Fz_time(mouse,sess) = sum(Stop(FreezeAccEpoch)-Start(FreezeAccEpoch))/1e4;

        % Get OB spectrum
        [Sp,t,f]=LoadSpectrumML('Bulb_deep',pwd,'low');
        Sptsd_OB  = tsd(t*1e4,Sp);
        
        SpecOB_Fz.(Mouse_names{mouse}).(Day{sess})= Restrict(Sptsd_OB,FreezeAccEpoch);
        SpecOB_Active.(Mouse_names{mouse}).(Day{sess})= Restrict(Sptsd_OB,Non_FreezingAccEpoch);
        
        RR_Fz.(Mouse_names{mouse}).(Day{sess})= RespiratoryRythmFromSpectrum_BM(Data(SpecOB_Fz.(Mouse_names{mouse}).(Day{sess})));
        RR_Active.(Mouse_names{mouse}).(Day{sess})= RespiratoryRythmFromSpectrum_BM(Data(SpecOB_Active.(Mouse_names{mouse}).(Day{sess})));
        
        InstFreq_Fz.(Mouse_names{mouse}).(Day{sess})= Restrict(LocalFreq.PT,FreezeAccEpoch);
        InstFreq_Active.(Mouse_names{mouse}).(Day{sess})= Restrict(LocalFreq.PT,Non_FreezingAccEpoch);
        
        % Get PFC spectrum
        [Sp,t,f]=LoadSpectrumML('PFCx_deep',pwd,'low');
        Sptsd_PFC  = tsd(t*1e4,Sp);
        
        SpecPFC_Fz.(Mouse_names{mouse}).(Day{sess})= Restrict(Sptsd_PFC,FreezeAccEpoch);
        SpecPFC_Active.(Mouse_names{mouse}).(Day{sess})= Restrict(Sptsd_PFC,Non_FreezingAccEpoch);
        
        cd([Sess2.(Mouse_names{mouse}){sess} 'ChannelsToAnalyse/'])
        if exist('EMG.mat')
            load('EMG.mat')
            cd([Sess2.(Mouse_names{mouse}){sess} 'LFPData/'])
            load(['LFP' num2str(channel) '.mat'])
            EMG.(Mouse_names{mouse}).(Day{sess})=LFP;
            
            EMG_Fz.(Mouse_names{mouse}).(Day{sess})=Restrict(EMG.(Mouse_names{mouse}).(Day{sess}),FreezeAccEpoch);
            EMG_Active.(Mouse_names{mouse}).(Day{sess})=Restrict(EMG.(Mouse_names{mouse}).(Day{sess}),Non_FreezingAccEpoch);
        
        end
    end
end

%% Spectrogramm of each mouse for each session
figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,5*(sess-1)+mouse)
        
        imagesc(Range(SpecOB_Fz.(Mouse_names{mouse}).(Day{sess}),'s'),f,Data(SpecOB_Fz.(Mouse_names{mouse}).(Day{sess}))'); axis xy; hold on
        makepretty
        ylim([0 10])
        caxis([0 5e5])
        hline(4,'-r')
        
        if mouse==1 & sess=1
            a=text(0,3,'Day 1'); a.FontSize=25;
            set(a,'Rotation',90);
        end
        if mouse==2 & sess=1
            a=text(-50,3,'Day 2'); a.FontSize=25;
            set(a,'Rotation',90);
        end
        if mouse==3 & sess=1
            a=text(0,3,'Day 3'); a.FontSize=25;
            set(a,'Rotation',90);
        end
    end
end

xlabel('time'); ylabel('Frequency (Hz)')
title('Mouse #1')
a=suptitle('Spectrograms during freezing for contextual fear recall'); a.FontSize=20;

        
GoodSpectogramSessions{1}=Data(SpecOB_Fz.M923.Day1);
GoodSpectogramSessions{2}=Data(SpecOB_Fz.M923.Day2);
GoodSpectogramSessions{3}=Data(SpecOB_Fz.M923.Day3);
GoodSpectogramSessions{4}=Data(SpecOB_Fz.M926.Day1);
GoodSpectogramSessions{5}=Data(SpecOB_Fz.M926.Day2);
GoodSpectogramSessions{6}=Data(SpecOB_Fz.M926.Day3);
GoodSpectogramSessions{7}=Data(SpecOB_Fz.M927.Day1);
GoodSpectogramSessions{8}=Data(SpecOB_Fz.M927.Day2);
GoodSpectogramSessions{9}=Data(SpecOB_Fz.M927.Day3);
GoodSpectogramSessions{10}=Data(SpecOB_Fz.M928.Day3);


for sess=1:length(GoodSpectogramSessions)
    for col=1:size(GoodSpectogramSessions{sess},2)
        
        SpectroEpInterp{sess}(:,col)  = interp1(linspace(0,1,size(GoodSpectogramSessions{sess},1)),GoodSpectogramSessions{sess}(:,col),linspace(0,1,300));
    
    end
end

figure
% mean spectro for each mice
for sess=1:length(GoodSpectogramSessions)
    AllMiceOBSpectrum(sess,:,:) = (zscore(SpectroEpInterp{sess}')')';
end
imagesc([1:300],f,squeeze(nanmean(AllMiceOBSpectrum,1))); axis xy
xticklabels({''})
makepretty
title('Spectrogram of all freezing episodes')
h=hline(4,'--r'); h.LineWidth=2;

%% Mean spectrum
figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,5*(sess-1)+mouse)
        
        plot(f,mean(10*(Data(SpecOB_Fz.(Mouse_names{mouse}).(Day{sess})))),'Color',[0.4940, 0.1840, 0.5560],'linewidth',2); hold on
       % plot(f,mean(10*(Data(SpecOB_Active.(Mouse_names{mouse}).(Day{sess})))),'Color',[0.4660, 0.6740, 0.1880],'linewidth',2)
        makepretty
        xlim([0 10])
        
    end
end

figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,5*(sess-1)+mouse)
        
        plot(f,mean(10*(Data(SpecPFC_Fz.(Mouse_names{mouse}).(Day{sess})))),'Color',[0.4940, 0.1840, 0.5560],'linewidth',2); hold on
        plot(f,mean(10*(Data(SpecPFC_Active.(Mouse_names{mouse}).(Day{sess})))),'Color',[0.4660, 0.6740, 0.1880],'linewidth',2)
        makepretty
        xlim([0 10])
        
    end
end


AllMeanSpectrum_OB_Fz(1,:)=mean([Data(SpecOB_Fz.M923.Day1) ; Data(SpecOB_Fz.M923.Day2) ; Data(SpecOB_Fz.M923.Day3)]);
AllMeanSpectrum_OB_Fz(2,:)=mean([Data(SpecOB_Fz.M926.Day1) ; Data(SpecOB_Fz.M926.Day2) ; Data(SpecOB_Fz.M926.Day3)]);
AllMeanSpectrum_OB_Fz(3,:)=mean([Data(SpecOB_Fz.M927.Day1) ; Data(SpecOB_Fz.M927.Day2) ; Data(SpecOB_Fz.M927.Day3)]);
AllMeanSpectrum_OB_Fz(4,:)=mean([Data(SpecOB_Fz.M928.Day3)]);

AllMeanSpectrum_OB_Active(1,:)=mean([Data(SpecOB_Active.M923.Day1) ; Data(SpecOB_Active.M923.Day2) ; Data(SpecOB_Active.M923.Day3)]);
AllMeanSpectrum_OB_Active(2,:)=mean([Data(SpecOB_Active.M926.Day1) ; Data(SpecOB_Active.M926.Day2) ; Data(SpecOB_Active.M926.Day3)]);
AllMeanSpectrum_OB_Active(3,:)=mean([Data(SpecOB_Active.M927.Day1) ; Data(SpecOB_Active.M927.Day2) ; Data(SpecOB_Active.M927.Day3)]);
AllMeanSpectrum_OB_Active(4,:)=mean([Data(SpecOB_Active.M928.Day3)]);

AllMeanSpectrum_PFC_Fz(1,:)=mean([Data(SpecPFC_Fz.M923.Day1) ; Data(SpecPFC_Fz.M923.Day2) ; Data(SpecPFC_Fz.M923.Day3)]);
AllMeanSpectrum_PFC_Fz(2,:)=mean([Data(SpecPFC_Fz.M926.Day1) ; Data(SpecPFC_Fz.M926.Day2) ; Data(SpecPFC_Fz.M926.Day3)]);
AllMeanSpectrum_PFC_Fz(4,:)=mean([Data(SpecPFC_Fz.M928.Day3)]);

AllMeanSpectrum_PFC_Active(1,:)=mean([Data(SpecPFC_Active.M923.Day1) ; Data(SpecPFC_Active.M923.Day2) ; Data(SpecPFC_Active.M923.Day3)]);
AllMeanSpectrum_PFC_Active(2,:)=mean([Data(SpecPFC_Active.M926.Day1) ; Data(SpecPFC_Active.M926.Day2) ; Data(SpecPFC_Active.M926.Day3)]);
AllMeanSpectrum_PFC_Active(4,:)=mean([Data(SpecPFC_Active.M928.Day3)]);

AllMeanSpectrum_OB_Fz_Day1(1,:)=mean([Data(SpecOB_Fz.M923.Day1)]);
AllMeanSpectrum_OB_Fz_Day1(2,:)=mean([Data(SpecOB_Fz.M926.Day1)]);
AllMeanSpectrum_OB_Fz_Day1(3,:)=mean([Data(SpecOB_Fz.M927.Day1)]);


figure
value_to_use=AllMeanSpectrum_OB_Active;
Conf_Inter=nanstd(value_to_use)/sqrt(size(value_to_use,1));
h=shadedErrorBar(f,nanmean(value_to_use),Conf_Inter,'-b',1); hold on
value_to_use=AllMeanSpectrum_OB_Fz;
Conf_Inter=nanstd(value_to_use)/sqrt(size(value_to_use,1));
shadedErrorBar(f,nanmean(value_to_use),Conf_Inter,'-r',1); hold on
makepretty
fj=get(gca,'Children');
legend([fj(1),fj(5)],'Freezing','Active')
xlim([0 10])
xlabel('Frequency (Hz)')
ylabel('Power (A.U)')
title('Mean OB spectrum during fear contextual recall')

[a,b]=max(mean(AllMeanSpectrum_OB_Fz));
vline(f(b),'--r')


figure
Conf_Inter=nanstd(AllMeanSpectrum_PFC_Active)/sqrt(size(AllMeanSpectrum_PFC_Active,1));
h=shadedErrorBar(f,nanmean(AllMeanSpectrum_PFC_Active),Conf_Inter,'-b',1); hold on
Conf_Inter=nanstd(AllMeanSpectrum_PFC_Fz)/sqrt(size(AllMeanSpectrum_PFC_Fz,1));
shadedErrorBar(f,nanmean(AllMeanSpectrum_PFC_Fz),Conf_Inter,'-r',1); hold on
makepretty
fj=get(gca,'Children');
legend([fj(1),fj(5)],'Freezing','Active')
xlim([0 10])
xlabel('Frequency (Hz)')
ylabel('Power (A.U)')
title('Mean PFC spectrum during fear contextual recall')

[a,b]=max(mean(AllMeanSpectrum_PFC_Fz));
vline(f(b),'--r')


figure
Conf_Inter=nanstd(AllMeanSpectrum_OB_Fz_Day1)/sqrt(size(AllMeanSpectrum_OB_Fz_Day1,1));
h=shadedErrorBar(f,nanmean(AllMeanSpectrum_OB_Fz_Day1),Conf_Inter,'-g',1); hold on
makepretty
xlim([0 10])
xlabel('Frequency (Hz)')
ylabel('Power (A.U)')
title('Mean PFC spectrum during fear contextual recall')

[a,b]=max(mean(AllMeanSpectrum_PFC_Fz));
vline(f(b),'--r')




%% RR
figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,3*(mouse-1)+sess)
        
        plot(RR_Fz.(Mouse_names{mouse}).(Day{sess}),'Color',[0.4940, 0.1840, 0.5560]); hold on
        makepretty
        
    end
end

figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,3*(mouse-1)+sess)
        
        plot(RR_Active.(Mouse_names{mouse}).(Day{sess}),'Color',[0.4660, 0.6740, 0.1880])
        makepretty
        
    end
end

GoodSpectrumSessions{1}=RR.M923.Day1 ;
GoodSpectrumSessions{2}=RR.M923.Day2 ;
GoodSpectrumSessions{3}=RR.M926.Day1 ;
GoodSpectrumSessions{4}=RR.M926.Day2 ;
GoodSpectrumSessions{5}=RR.M926.Day3 ;
GoodSpectrumSessions{6}=RR.M927.Day1 ;
GoodSpectrumSessions{7}=RR.M927.Day2 ;
GoodSpectrumSessions{8}=RR.M927.Day1 ;

for sessions=1:8
    
   To_use = interp1(linspace(0,1,length(GoodSpectrumSessions{sessions})),GoodSpectrumSessions{sessions}',linspace(0,1,300));
    
    TRAP_Mice_RR(sessions,:)=To_use;
    
end

figure
Conf_Inter=nanstd(TRAP_Mice_RR)/sqrt(size(TRAP_Mice_RR,1));
shadedErrorBar([1:900],[NaN(1,300) nanmean(TRAP_Mice_RR) NaN(1,300)],[NaN(1,300) Conf_Inter NaN(1,300)],'-g',1); hold on;


title('Respiratory rate')
ylabel('Frequency (Hz)')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  


%% InstFreq
figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,3*(mouse-1)+sess)
        
        plot(Data(InstFreq_Fz.(Mouse_names{mouse}).(Day{sess})),'Color',[0.4940, 0.1840, 0.5560]); hold on
        makepretty
        
    end
end

figure
for mouse=1:5
    for sess=1:3
        subplot(3,5,3*(mouse-1)+sess)
        
        plot(Data(InstFreq_Active.(Mouse_names{mouse}).(Day{sess})),'Color',[0.4660, 0.6740, 0.1880])
        makepretty
        
    end
end


GoodInstFreqSessions_Active{1}=Data(InstFreq_Active.M923.Day1) ;
GoodInstFreqSessions_Active{2}=Data(InstFreq_Active.M923.Day2) ;
GoodInstFreqSessions_Active{3}=Data(InstFreq_Active.M923.Day3) ;
GoodInstFreqSessions_Active{4}=Data(InstFreq_Active.M926.Day1) ;
GoodInstFreqSessions_Active{5}=Data(InstFreq_Active.M926.Day2) ;
GoodInstFreqSessions_Active{6}=Data(InstFreq_Active.M926.Day3) ;
GoodInstFreqSessions_Active{7}=Data(InstFreq_Active.M927.Day1) ;
GoodInstFreqSessions_Active{8}=Data(InstFreq_Active.M927.Day2) ;
GoodInstFreqSessions_Active{9}=Data(InstFreq_Active.M927.Day3) ;
GoodInstFreqSessions_Active{10}=Data(InstFreq_Active.M928.Day3) ;

GoodInstFreqSessions_Fz{1}=Data(InstFreq_Fz.M923.Day1) ;
GoodInstFreqSessions_Fz{2}=Data(InstFreq_Fz.M923.Day2) ;
GoodInstFreqSessions_Fz{3}=Data(InstFreq_Fz.M923.Day3) ;
GoodInstFreqSessions_Fz{4}=Data(InstFreq_Fz.M926.Day1) ;
GoodInstFreqSessions_Fz{5}=Data(InstFreq_Fz.M926.Day2) ;
GoodInstFreqSessions_Fz{6}=Data(InstFreq_Fz.M926.Day3) ;
GoodInstFreqSessions_Fz{7}=Data(InstFreq_Fz.M927.Day1) ;
GoodInstFreqSessions_Fz{8}=Data(InstFreq_Fz.M927.Day2) ;
GoodInstFreqSessions_Fz{9}=Data(InstFreq_Fz.M927.Day3) ;
GoodInstFreqSessions_Fz{10}=Data(InstFreq_Fz.M928.Day3) ;


for sessions=1:length(GoodInstFreqSessions_Fz)
    
   To_use = interp1(linspace(0,1,length(GoodInstFreqSessions_Active{sessions})),GoodInstFreqSessions_Active{sessions}',linspace(0,1,300));
   
   TRAP_Mice_InstFreq_Active(sessions,:)=To_use;
   
   To_use2 = interp1(linspace(0,1,length(GoodInstFreqSessions_Fz{sessions})),GoodInstFreqSessions_Fz{sessions}',linspace(0,1,300));
   
   TRAP_Mice_InstFreq_Fz(sessions,:)=To_use2;
   
end

figure
Conf_Inter=nanstd(TRAP_Mice_InstFreq_Active)/sqrt(size(TRAP_Mice_InstFreq_Active,1));
shadedErrorBar([1:900],[NaN(1,300) nanmean(TRAP_Mice_InstFreq_Active) NaN(1,300)],[NaN(1,300) Conf_Inter NaN(1,300)],'-b',1); hold on;
Conf_Inter=nanstd(TRAP_Mice_InstFreq_Fz)/sqrt(size(TRAP_Mice_InstFreq_Fz,1));
shadedErrorBar([1:900],[NaN(1,300) nanmean(TRAP_Mice_InstFreq_Fz) NaN(1,300)],[NaN(1,300) Conf_Inter NaN(1,300)],'-r',1); hold on;
makepretty



%% EMG

figure
for mouse=1:5
 i=1;
   for sess=1:3
        
        try
            mean_EMG_Fz(mouse,i)=mean(abs(Data( EMG_Fz.(Mouse_names{mouse}).(Day{sess}))));
            mean_EMG_Active(mouse,i)=mean(abs(Data( EMG_Active.(Mouse_names{mouse}).(Day{sess}))));
            i=i+1;
        end
        
    end
end















