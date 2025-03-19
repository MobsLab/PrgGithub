%SleepStagesDistributionML.m


Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);
%Dir=RestrictPathForExperiment(Dir,'nMice',[51 60]);
%Dir=Dir2;

MinPeriod=10*60; %10min of rec minimum to include period
HourDay=9:0.5:20;
MATREM=nan(length(Dir.path),length(HourDay)-1);
MATWake=MATREM; MATSWS=MATREM; MATPeriod=MATREM;
    h = waitbar(0,'Analysing Rhythms');
for man=1:length(Dir.path)
    
    disp(Dir.path{man})
    cd(Dir.path{man})
    waitbar(man/length(Dir.path))
    
    %---------------  SleepEpoch -------------------
    clear tempLoad SWS REM Wake NewtsdZT
    try
        tempLoad=load('StateEpoch.mat','MovEpoch','REMEpoch','SWSEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
        Wake=(tempLoad.MovEpoch-tempLoad.GndNoiseEpoch)-tempLoad.NoiseEpoch;
    catch
        tempLoad=load('StateEpochSB.mat','SWSEpoch','Epoch','REMEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch');
        Wake=((tempLoad.Epoch-tempLoad.SWSEpoch-tempLoad.REMEpoch)-tempLoad.GndNoiseEpoch)-tempLoad.NoiseEpoch;
        disp('using StateEpochSB.mat')
    end
    SWS=(tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch)-tempLoad.NoiseEpoch;
    REM=(tempLoad.REMEpoch-tempLoad.GndNoiseEpoch)-tempLoad.NoiseEpoch;
    if exist('tempLoad.WeirdNoiseEpoch','var')
        Wake=Wake-tempLoad.WeirdNoiseEpoch;
        SWS=SWS-tempLoad.WeirdNoiseEpoch;
        REM=REM-tempLoad.WeirdNoiseEpoch;
    end
    
    %---------------  load ZT  ----------------------------------------
    NewtsdZT=GetZT_ML(Dir.path{man});
    rg=Range(NewtsdZT);
    dt=Data(NewtsdZT)/1E4;
    %------------------------------------------------------------------
    
    for hd=1:length(HourDay)-1
        I=intervalSet([],[]);
        ind=find(dt>=HourDay(hd)*3600 & dt<HourDay(hd+1)*3600);
        if ~isempty(ind), I=intervalSet(rg(min(ind)),rg(max(ind))); end
        if sum(Stop(I,'s')-Start(I,'s'))>MinPeriod
            MATPeriod(man,hd)=sum(Stop(I,'s')-Start(I,'s'));
            MATSWS(man,hd)=sum(Stop(and(I,SWS),'s')-Start(and(I,SWS),'s'));
            MATREM(man,hd)=sum(Stop(and(I,REM),'s')-Start(and(I,REM),'s'));
            MATWake(man,hd)=sum(Stop(and(I,Wake),'s')-Start(and(I,Wake),'s'));
        end
    end
end
close (h)

% pool mice
Umice=unique(Dir.name);
MiREM=nan(length(Umice),length(HourDay)-1); MiWake=MiREM; MiSWS=MiREM; MiPeriod=MiREM;
for mi=1:length(Umice)
    ind=strcmp(Dir.name,Umice{mi});
    MiREM(mi,:)=nanmean(MATREM(ind,:),1);
    MiWake(mi,:)=nanmean(MATWake(ind,:),1);
    MiSWS(mi,:)=nanmean(MATSWS(ind,:),1);
    MiPeriod(mi,:)=nanmean(MATPeriod(ind,:),1);
end

% display stacked bars
for f=1:2
    clear M1 M2 M3 M4
    if f==1
        M1=MiWake; M2=MiREM; M3=MiSWS; M4=MiPeriod;
        ntemp=['(N=',num2str(length(Umice)),')'];
    else
        M1=MATWake; M2=MATREM; M3=MATSWS; M4=MATPeriod;
        ntemp=['(n=',num2str(length(Dir.path{man})),' expe)'];
    end
    mattemp=[nanmean(100*M1./M4);nanmean(100*M2./M4);nanmean(100*M3./M4)];    
    matbar=[mattemp(1,:);[100-sum(mattemp,1)];mattemp(2:3,:)];
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.1 0.4 0.5 0.5])
    subplot(2,3,[3,6]), bar(matbar','stacked'); ylim([0 100])
    legend({'Wake','undefined','REM','SWS'})
    
    for hd=1:length(HourDay)-1; leg{hd}=sprintf('%dh',floor(HourDay(hd)));end
    %leg{hd}=sprintf('%dh%02d-%dh%02d',floor(HourDay(hd)),rem(HourDay(hd),floor(HourDay(hd)))*60,floor(HourDay(hd+1)),rem(HourDay(hd+1),floor(HourDay(hd+1)))*60);
    set(gca,'Xtick',1:4:length(HourDay)-1)
    set(gca,'XtickLabel',leg(1:4:end))
    
    % display ErrorbarN
    subplot(2,3,1), PlotErrorBar(M4,0); title(['ALL ',ntemp,' - excluded if <',num2str(MinPeriod/60),'min']);
    set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end));ylabel('Rec Duration (s)');
    
    subplot(2,3,2), PlotErrorBar(100*M1./M4,0);
    title('% Wake');set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
    
    subplot(2,3,4), PlotErrorBar(100*M2./M4,0); xlabel('Time of the day (30min periods)');
    title('% REM');set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
    
    subplot(2,3,5), PlotErrorBar(100*M3./M4,0); xlabel('Time of the day (30min periods)');
    title('% SWS');set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
    
    saveFigure(gcf,['EvolutionSleepPeriodsAddGL',num2str(f)],'/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/FIguresPosterSFN2015/')
end
