clear all
%% pour Julie
Dir=PathForExperimentsMLnew('BASAL');
figure; numF=gcf;
for man=1:length(Dir.path)
    disp(' ');disp(Dir.path{man})
    try
    cd(Dir.path{man}); disp('ok')
    clear Movtsd MovAcctsd Mmov MovThresh
    load('behavResources.mat','Movtsd','MovAcctsd')
    if ~exist('Movtsd','var');
        disp('use MovAcctsd')
        Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
        rg=Range(Movtsd);
        val=SmoothDec(Data(Movtsd),5);
        Mmov=tsd(rg(1:10:end),val(1:10:end));
    else
        Mmov=Movtsd;
        disp('use Movtsd')
    end
    MovThresh=GetGammaThresh(Data(Mmov));%close
    MovThresh=exp(MovThresh); % c'est cette etape qui est mega important
    Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
    mergeSleep=3; %3s
    Immob=mergeCloseIntervals(Immob,mergeSleep*1E4);
    Immob=dropShortIntervals(Immob,mergeSleep*1E4);
    figure(numF),subplot(3,10,man), hist(Stop(Immob,'s')-Start(Immob,'s'),1000)
    title(Dir.name{man})
    catch
    disp('problem')
    end
end
%% initiate
DoSB=1;
Dir=PathForExperimentsMLnew('BASALlongSleep');  
%Dir=PathForExperimentsMLnew('BASAL');
%Dir=PathForExperimentsMLnew('Spikes');% code SB

DirORX{1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017';
DirORX{2}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
DirORX{3}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';

for orms=1:length(DirORX)
    cd(DirORX{orms})
    try 
        load('IdFigureData.mat','percentvalues_NREM','time_substages')
    catch
        load('previous_data_NREM_substages/IdFigureData_.mat','percentvalues_NREM','time_substages')
    end
    Vals(orms,:)=percentvalues_NREM;
    Time(orms,:)=time_substages./sum(time_substages);
    if DoSB
        load('StateEpochSB.mat','Wake','Sleep'); disp('using sleepscoringSB');
    else
        load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
        Wake=MovEpoch;
        Sleep=or(SWSEpoch,REMEpoch);
        Sleep=Sleep-TotalNoiseEpoch;
        Wake=Wake-TotalNoiseEpoch;
    end
    [aft_cell,bef_cell]=transEpoch(Sleep,Wake);
    TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
    Transition(orms,:)=length(Start(aft_cell{2,1}))./TotDur;
    SlWkRat(orms,:)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
    clear Sleep Wake
end


%% length of substage epochs
Vals_WT=nan(length(Dir.path),3);
Transition_WT=nan(length(Dir.path),1);
Time_WT=nan(length(Dir.path),5);
SlWkRat_WT=nan(length(Dir.path),1);

for man=1:length(Dir.path)
    cd(Dir.path{man}); disp(' ');disp(Dir.path{man})
    clear percentvalues_NREM time_substages
    if exist('IdFigureData.mat')>0
        load('IdFigureData.mat','percentvalues_NREM','time_substages');
    end
    try
        percentvalues_NREM; time_substages;
    catch
        clear op NamesOp Dpfc Epoch noise N1 N2 N3 REM WAKE SWS
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        [EP,NamesEP]=DefineSubStages(op,noise);
        N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};
        Rec=or(or(SWS,REM),WAKE);
        Epochs={N1,N2,N3,REM,WAKE};
        num_substage=[2 1.5 1 3 4]; %ordinate in graph
        
        indtime=min(Start(Rec)):500:max(Stop(Rec));
        timeTsd=tsd(indtime,zeros(length(indtime),1));
        SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
        rg=Range(timeTsd);
        sample_size = median(diff(rg))/10; %in ms
        time_substages = zeros(1,5);
        meanDuration_substages = zeros(1,5);
        for ep=1:length(Epochs)
            idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
            SleepStages(idx)=num_substage(ep);
            time_substages(ep) = length(idx) * sample_size;
            meanDuration_substages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
        end
        SleepStages=tsd(rg,SleepStages');
        percentvalues_NREM = zeros(1,3);
        for ep=1:3
            percentvalues_NREM(ep) = time_substages(ep)/sum(time_substages(1:3));
        end
        percentvalues_NREM = round(percentvalues_NREM*100,2);
    end
    
    try
        Vals_WT(man,:) = percentvalues_NREM;
        Time_WT(man,:) = time_substages./sum(time_substages);
        
        try
            if DoSB, error; end
            load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
            Wake=MovEpoch;
            Sleep=or(SWSEpoch,REMEpoch);
            Sleep=Sleep-TotalNoiseEpoch;
            Wake=Wake-TotalNoiseEpoch;
        catch
            load('StateEpochSB.mat','Wake','Sleep'); disp('using sleepscoringSB');
        end
        [aft_cell,bef_cell]=transEpoch(Sleep,Wake);
        TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
        Transition_WT(man)=length(Start(aft_cell{2,1}))./TotDur;
        SlWkRat_WT(man)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
        clear Sleep Wake
        
    catch
        disp('problem'); %keyboard
    end
end

%% pool sessions of the same mouse
mice=unique(Dir.name);
if 1
    disp('Pooling sessions from the same mouse')
    Time_WTindiv=Time_WT;
    Time_WT=nan(length(mice),5);
    Transition_WTindiv=Transition_WT;
    Transition_WT=nan(length(mice),1);
    Vals_WTindiv=Vals_WT;
    Vals_WT=nan(length(mice),3);
    
    for mi=1:length(mice)
        Time_WT(mi,:)=nanmean(Time_WTindiv(find(strcmp(Dir.name,mice{mi})),:),1);
        Transition_WT(mi,:)=nanmean(Transition_WTindiv(find(strcmp(Dir.name,mice{mi})),:),1);
        Vals_WT(mi,:)=nanmean(Vals_WTindiv(find(strcmp(Dir.name,mice{mi})),:),1);
    end
    
end
%%

% Plot time in each phase for orx and ctrl mice
figure
subplot(211), bar([mean(100*Time_WT);mean(100*Time)]')
legend({'WT','ORX'}); ylabel('% substage')
set(gca,'XTick',[1:5],'XTickLabel',{'N1','N2','N3','REM','Wake'})
subplot(212), 
for i=1:5
    text(i,2-i*0.2,[NamesEP{i},sprintf(' WT: %1.1f +-%1.1f',100*mean(Time_WT(:,i)),std(100*Time_WT(:,i)))]);
    text(i,1-i*0.2,[NamesEP{i},sprintf(' ORX: %1.1f +-%1.1f',100*mean(Time(:,i)),std(100*Time(:,i)))]);
end
    xlim([1 i+2]);ylim([-0.1 2]); axis off
numF=gcf;saveFigure(numF.Number,'NREM_ORX_AllStates','/home/mobsmorty/Dropbox/NREMsubstages-Manuscrit/NewFigs/')

%%
% Bar plot of two main variables : number of transitions and %of N1
figure
subplot(121)
g=bar(1,mean(Transition_WT(:,1)*3600),'FaceColor',[0.6 0.6 0.6]); hold on
plot(1,Transition_WT(:,1)*3600,'.w','MarkerSize',30),
plot(1,Transition_WT(:,1)*3600,'.k','MarkerSize',20),
g=bar(2,mean(Transition(:,1)*3600),'FaceColor',[0.6 0.6 0.6]); hold on
plot(2,Transition(:,1)*3600,'.w','MarkerSize',30),
plot(2,Transition(:,1)*3600,'.k','MarkerSize',20),
set(gca,'XTick',[1:2],'XTickLabel',{'WT','ORX'})
ylabel('number of transitions (per hour)')
p=ranksum(Transition_WT(:,1),Transition(:,1));
title(sprintf('ranksum : p=%1.4f',p))

subplot(122)
g=bar(1,mean(Vals_WT(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(1,Vals_WT(:,1),'.w','MarkerSize',30),
plot(1,Vals_WT(:,1),'.k','MarkerSize',20),
g=bar(2,mean(Vals(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(2,Vals(:,1),'.w','MarkerSize',30),
plot(2,Vals(:,1),'.k','MarkerSize',20),
ylabel('% N1')
set(gca,'XTick',[1:2],'XTickLabel',{'WT','ORX'})
p=ranksum(Vals_WT(:,1),Vals(:,1));
title(sprintf('ranksum : p=%1.4f',p))
%numF=gcf;saveFigure(numF.Number,'NREM_ORX_TransitionAndN1','/home/mobsmorty/Dropbox/NREMsubstages-Manuscrit/NewFigs/')

%%
% Compare time per state and %of NREM in each substage
figure
subplot(2,2,1)
PlotErrorBarN_KJ(Time*100,'newfig',0)
set(gca,'XTick',[1:5],'XTickLabel',{'N1','N2','N3','REM','Wake'})
text()

ylim([0 100])
title('ORX')
subplot(2,2,2)
PlotErrorBarN_KJ(Time_WT*100,'newfig',0)
set(gca,'XTick',[1:5],'XTickLabel',{'N1','N2','N3','REM','Wake'})
ylim([0 100])
title('CTRL')
subplot(2,2,3)
PlotErrorBarN_KJ(Vals,'newfig',0)
set(gca,'XTick',[1:3],'XTickLabel',{'N1','N2','N3'})
ylim([0 100])
subplot(2,2,4)
PlotErrorBarN_KJ(Vals_WT,'newfig',0)
set(gca,'XTick',[1:3],'XTickLabel',{'N1','N2','N3'})
ylim([0 100])

% Plot transitions vs time in each state
figure
subplot(211)
plot(Transition_WT,Time_WT(:,1),'b.')
hold on
plot(Transition,Time(:,1),'r.')
xlabel('Transitions per ??')
ylabel('%NREM in N1')
subplot(212)
plot(Transition_WT,Vals_WT(:,1),'b.')
hold on
plot(Transition,Vals(:,1),'r.')
xlabel('Transitions per ??')
ylabel('%time in N1')


%% get wake %
NMouse{1}='Mouse-554';
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017
load('StateEpochSB.mat','wakeper','Wake')
TotWakeSB(1)=sum(Stop(Wake,'s')-Start(Wake,'s'));
TotWakePerSB(1)=sum(Stop(wakeper,'s')-Start(wakeper,'s'));
[WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages; close
Totrec(1)=max(Range(SleepStages,'s'))-min(Range(SleepStages,'s'));
TotWake(1)=sum(Stop(WAKE,'s')-Start(WAKE,'s'));
TotWakeNoise(1)=sum(Stop(WAKEnoise,'s')-Start(WAKEnoise,'s'));

NMouse{2}='Mouse-570';
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h
load('StateEpochSB.mat','wakeper','Wake')
TotWakeSB(2)=sum(Stop(Wake,'s')-Start(Wake,'s'));
TotWakePerSB(2)=sum(Stop(wakeper,'s')-Start(wakeper,'s'));
[WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages; close
Totrec(2)=max(Range(SleepStages,'s'))-min(Range(SleepStages,'s'));
TotWake(2)=sum(Stop(WAKE,'s')-Start(WAKE,'s'));
TotWakeNoise(2)=sum(Stop(WAKEnoise,'s')-Start(WAKEnoise,'s'));

NMouse{3}='Mouse-571';
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h
load('StateEpochSB.mat','wakeper','Wake')
TotWakeSB(3)=sum(Stop(Wake,'s')-Start(Wake,'s'));
TotWakePerSB(3)=sum(Stop(wakeper,'s')-Start(wakeper,'s'));
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h/previous_data_NREM_substages
[WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages; close
Totrec(3)=max(Range(SleepStages,'s'))-min(Range(SleepStages,'s'));
TotWake(3)=sum(Stop(WAKE,'s')-Start(WAKE,'s'));
TotWakeNoise(3)=sum(Stop(WAKEnoise,'s')-Start(WAKEnoise,'s'));
%%
disp(NMouse')
fprintf('Dur total rec: %1.0fs   \n',Totrec);
fprintf('Dur total wake: %1.0fs   \n',TotWake);
fprintf('wake (percTotal): %1.1f perc   \n',100*TotWake./Totrec);
fprintf('wake (percTotal): mean = %1.1f; std= %1.1f \n', mean(100*TotWake./Totrec),std(100*TotWake./Totrec))
disp('Add Noise')
fprintf('Dur total wake Noise: %1.0fs  \n',TotWakeNoise);
fprintf('wake Noise (percTotal): %1.1f perc  \n',100*TotWakeNoise./Totrec);

disp('SleepScoringSB')
fprintf('Dur total wakeSB: %1.0fs   \n',TotWakeSB);
fprintf('wakeSBper: %1.0fs   \n',TotWakePerSB);
fprintf('wakeSBper (perc): %1.1f perc   \n',100*TotWakePerSB./Totrec);

%% Code Sophie

clear all

orms=1;
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017
load('IdFigureData.mat','percentvalues_NREM','time_substages')
Vals(orms,:)=percentvalues_NREM;
Time(orms,:)=time_substages./sum(time_substages);
load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
Wake=MovEpoch;
Sleep=or(SWSEpoch,REMEpoch);
Sleep=Sleep-TotalNoiseEpoch;
Wake=Wake-TotalNoiseEpoch;
[aft_cell,bef_cell]=transEpoch(Sleep,Wake);
TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
Transition(orms,:)=length(Start(aft_cell{2,1}))./TotDur;
SlWkRat(orms,:)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
clear Sleep Wake

orms=2;
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h
load('IdFigureData.mat','percentvalues_NREM','time_substages')
Vals(orms,:)=percentvalues_NREM;
Time(orms,:)=time_substages./sum(time_substages);
load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
Wake=MovEpoch;
Sleep=or(SWSEpoch,REMEpoch);
Sleep=Sleep-TotalNoiseEpoch;
Wake=Wake-TotalNoiseEpoch;
[aft_cell,bef_cell]=transEpoch(Sleep,Wake);
TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
Transition(orms,:)=length(Start(aft_cell{2,1}))./TotDur;
SlWkRat(orms,:)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
clear Sleep Wake

orms=3;
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h/previous_data_NREM_substages
load('IdFigureData_.mat','percentvalues_NREM','time_substages')
Vals(orms,:)=percentvalues_NREM;
Time(orms,:)=time_substages./sum(time_substages);
cd /media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h
load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
Wake=MovEpoch;
Sleep=or(SWSEpoch,REMEpoch);
Sleep=Sleep-TotalNoiseEpoch;
Wake=Wake-TotalNoiseEpoch;
[aft_cell,bef_cell]=transEpoch(Sleep,Wake);
TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
Transition(orms,:)=length(Start(aft_cell{2,1}))./TotDur;
SlWkRat(orms,:)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
clear Sleep Wake

Dir=PathForExperimentsMLnew('Spikes');
nn=1;
clear Transition_WT  Vals_WT Time_WT
for f=1:length(Dir.path)
    cd(Dir.path{f})
    if exist('IdFigureData.mat')>0
        try
            
            load('IdFigureData.mat','percentvalues_NREM','time_substages')
            Vals_WT(nn,:) = percentvalues_NREM;
            Time_WT(nn,:) = time_substages./sum(time_substages);
            clear percentvalues_NREM time_substages
            load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','TotalNoiseEpoch')
            Wake=MovEpoch;
            Sleep=or(SWSEpoch,REMEpoch);
            Sleep=Sleep-TotalNoiseEpoch;
            Wake=Wake-TotalNoiseEpoch;
            [aft_cell,bef_cell]=transEpoch(Sleep,Wake);
            TotDur=sum(Stop(Sleep,'s')-Start(Sleep,'s'))+sum(Stop(Wake,'s')-Start(Wake,'s'));
            Transition_WT(nn,:)=length(Start(aft_cell{2,1}))./TotDur;
            SlWkRat_WT(nn,:)=sum(Stop(Sleep,'s')-Start(Sleep,'s'))./TotDur;
            clear Sleep Wake
            %             res=pwd;
            %             load('AllDeltaPFCx.mat')
            %             load([res,'/LFPData/LFP',num2str(ch1.channel)],'LFP');
            %             LFP1=LFP;clear LFP
            %             load([res,'/LFPData/LFP',num2str(ch2.channel)],'LFP');
            %             LFP2=LFP;clear LFP
            %             [m,s,tps]=mETAverage(tDelta, Range(LFP1),Data(LFP1),10,70);
            %             [m2,s2,tps2]=mETAverage(tDelta, Range(LFP2),Data(LFP2),10,70);
            %             id1=find(tps>=0);
            %             id2=find(tps2>=0);
            %             AmpD(nn)=abs(m(id1(1))-m2(id2(1)));
            
            nn
            nn=nn+1;
        end
    end
end

% Plot time in each phase for orx and ctrl mice
figure
g=bar([1:3:15],mean(Time)*100,'r'); hold on
g.BarWidth=0.2;
g=bar([1:3:15]+1,mean(Time_WT)*100,'b');hold on
g.BarWidth=0.2;
set(gca,'XTick',[1:3:15]+0.5,'XTickLabel',{'N1','N2','N3','REM','Wake'})
box off
ylabel('%time in state out of total')

% Bar plot of two main variables : number of transitions and %of N1
figure
subplot(121)
g=bar(1,mean(Transition_WT(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(1,Transition_WT(:,1),'.w','MarkerSize',30),
plot(1,Transition_WT(:,1),'.k','MarkerSize',20),
g=bar(2,mean(Transition(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(2,Transition(:,1),'.w','MarkerSize',30),
plot(2,Transition(:,1),'.k','MarkerSize',20),
subplot(122)
g=bar(1,mean(Vals_WT(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(1,Vals_WT(:,1),'.w','MarkerSize',30),
plot(1,Vals_WT(:,1),'.k','MarkerSize',20),
g=bar(2,mean(Vals(:,1)),'FaceColor',[0.6 0.6 0.6]); hold on
plot(2,Vals(:,1),'.w','MarkerSize',30),
plot(2,Vals(:,1),'.k','MarkerSize',20),


% Compare time per state and %of NREM in each substage
figure
subplot(2,2,1)
PlotErrorBarN_KJ(Time*100,'newfig',0)
set(gca,'XTick',[1:5],'XTickLabel',{'N1','N2','N3','REM','Wake'})
ylim([0 100])
title('ORX')
subplot(2,2,2)
PlotErrorBarN_KJ(Time_WT*100,'newfig',0)
set(gca,'XTick',[1:5],'XTickLabel',{'N1','N2','N3','REM','Wake'})
ylim([0 100])
title('CTRL')
subplot(2,2,3)
PlotErrorBarN_KJ(Vals,'newfig',0)
set(gca,'XTick',[1:3],'XTickLabel',{'N1','N2','N3'})
ylim([0 100])
subplot(2,2,4)
PlotErrorBarN_KJ(Vals_WT,'newfig',0)
set(gca,'XTick',[1:3],'XTickLabel',{'N1','N2','N3'})
ylim([0 100])

% Plot transitions vs time in each state
figure
subplot(211)
plot(Transition_WT,Time_WT(:,1),'b.')
hold on
plot(Transition,Time(:,1),'r.')
xlabel('Transitions per ??')
ylabel('%NREM in N1')
subplot(212)
plot(Transition_WT,Vals_WT(:,1),'b.')
hold on
plot(Transition,Vals(:,1),'r.')
xlabel('Transitions per ??')
ylabel('%time in N1')

