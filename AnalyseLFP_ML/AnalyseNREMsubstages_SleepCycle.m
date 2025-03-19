%AnalyseNREMsubstages_SleepCycle
%
% list of related scripts in NREMstages_scripts.m 

% based on KB codes
if 0
edit ComputeSleepCycle.m
edit TrioHumanSleepCycle.m %??
edit ParcoursSleepCycle.m
edit BilanParcoursSleepCycle.m
edit AnalysisSleepCycle
edit FigureSleepCycleEvolutionMarie.m
edit LastFigureBilanParcoursSleepCycle.m
end

FolderToSave='/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/NewFigs';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureArticleNREM';
savFig=1;

%% plot Cycle Humans

load('/media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman/DatabaseSubjects.mat','SleepCylcesHumanAASM')
Stages={'N3','N2','N1','REM','WAKE'};
%colori=[1 0 1 ;1 0.8 1;0.6 0 0.6 ;0.1 0.7 0 ;0.5 0.2 0.1; 0 0 0];
colori=[1 0 0; 1 0.2 0.8;0.5 0 1;0 0 0 ;0.5 0.5 0.5];
step=5; % epoch = 5s
Tfin=8*3600;%sec
tpsb=0:0.001:1;

AllCycles=[];
CycleMan={};TotMan={};
for man=1:length(SleepCylcesHumanAASM)
    fprintf('\n Subject #%d\n',man)
    temp=SleepCylcesHumanAASM{man};
    temp(1:min(find(temp<5))-1)=[]; % start at sleep onset
    Sleep=tsd([1:length(temp)]*step*1E4,temp);
    % discard wake
    tempWrm=temp; tempWrm(tempWrm>4)=[];
    SleepWrm=tsd([1:length(tempWrm)]*step*1E4,tempWrm);
    
    % get evol across night
    Nsleep=Restrict(Sleep,intervalSet(0,Tfin*1E4));
    NsleepWrm=Restrict(SleepWrm,intervalSet(0,Tfin*1E4));
    tempT=zeros(length(Stages),ceil(Tfin/step));
    tempTWrm=zeros(length(Stages),ceil(Tfin/step));
    for n=1:length(Stages)
        tempT(n,1:length(Data(Nsleep)))=(Data(Nsleep)==n);
        tempTWrm(n,1:length(Data(NsleepWrm)))=(Data(NsleepWrm)==n);
    end
    TotMan{man,1}=tempT;
    TotMan{man,2}=tempTWrm;
    
    % get cycle
    REMEpoch1=thresholdIntervals(Sleep,3.5,'Direction','Above');
    REMEpoch2=thresholdIntervals(Sleep,4.5,'Direction','Below');
    REM=and(REMEpoch1,REMEpoch2);
    EnRem=End(REM);
    rg=Range(Sleep);dt=Data(Sleep);
%     tfirstCycle=min(rg(find(dt~=5))); % already done, see temp above
%     SleepCycle=intervalSet([max([0,tfirstCycle]);EnRem(1:end-1)],EnRem);
    SleepCycle=intervalSet([0;EnRem(1:end-1)],EnRem);
    AllCycles=[AllCycles;Stop(SleepCycle,'s')-Start(SleepCycle,'s')];
    AllCyclesMan{man} = Stop(SleepCycle,'s')-Start(SleepCycle,'s');
    for do=[1,3,4]
        tempCycl=zeros(length(Stages),length(tpsb));
        if do==1 % all cylces
            indR=1:length(EnRem);
        elseif do==3 % first cycles
            indR=1:2;
        else % last cycles
            indR=length(EnRem)+[-1 0];
        end
            
        for ep=1:length(indR)
            Mat=Restrict(Sleep,subset(SleepCycle,indR(ep)));
            rg=Range(Mat);
            MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
            for n=1:length(Stages)
                tempCycl(n,:)=tempCycl(n,:)+(Data(Restrict(MatTemp,tpsb))==n)';
            end
        end
        tempCycl=tempCycl/length(indR);
        CycleMan{man,do}=tempCycl;
    end
    
    % remove wake
    REMEpoch1=thresholdIntervals(SleepWrm,3.5,'Direction','Above');
    REMEpoch2=thresholdIntervals(SleepWrm,4.5,'Direction','Below');
    REM=and(REMEpoch1,REMEpoch2);
    EnRem=End(REM);
    SleepCycle=intervalSet([0;EnRem(1:end-1)],EnRem);
    tempCyclWrm=zeros(length(Stages),length(tpsb));
    for ep=1:length(EnRem)
        MatWrm=Restrict(SleepWrm,subset(SleepCycle,ep));
        rgWrm=Range(MatWrm);
        MatTempWrm=tsd((rgWrm-rgWrm(1))/(rgWrm(end)-rgWrm(1)),Data(MatWrm));
        for n=1:length(Stages)
            tempCyclWrm(n,:)=tempCyclWrm(n,:)+(Data(Restrict(MatTempWrm,tpsb))==n)';
        end
    end
    tempCyclWrm=tempCyclWrm/length(EnRem);
    CycleMan{man,2}=tempCyclWrm;
end
%----------------------------------------------------------------- 
%% Display
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.6 0.7]), numF=gcf;
tit={'All','Wake Removed'};
for cc=1:2
    subplot(2,2,2*cc-1),hold on
    for n=1:length(Stages)
        tt=zeros(1,size(CycleMan{1,cc},2));
        for i=1:length(CycleMan)
            tt=tt+CycleMan{i,cc}(n,:);
        end
        plot(tpsb,tt/length(CycleMan),'Color',colori(n,:))
    end
    title({'Cycle Humans',tit{cc}}); xlabel('Normed cycle')
    
    subplot(2,2,2*cc),hold on
    for n=1:length(Stages)
        tt=zeros(1,size(TotMan{1,cc},2));
        for i=1:length(TotMan)
            tt=tt+TotMan{i,cc}(n,:);
        end
        plot([1:length(tt)]/length(tt)*Tfin/3600,smooth(tt/length(TotMan),50),'Color',colori(n,:))
    end
    title('Evolution across night of sleep'); xlabel({'Time (h)','start at sleep onset'})
    legend(Stages)
end

if savFig, saveFigure(numF.Number,'HumanSleepCycleAndNightEvol',FolderToSave);end


%% first and last sleep cycles
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.6 0.3]), numF=gcf;
smo=3;
for n=1:length(Stages)
    subplot(2,length(Stages),n),hold on
    tt=zeros(1,size(CycleMan{1,3},2)); tt2=tt;
    for i=1:length(CycleMan)
        tt=tt+CycleMan{i,3}(n,:);
        tt2=tt2+CycleMan{i,4}(n,:);
    end
    plot(tpsb,smooth(tt/length(CycleMan),smo),'Color',colori(n,:),'Linewidth',2)
    plot(tpsb,smooth(tt2/length(CycleMan),smo),'k','Linewidth',2)
    title(Stages{n}); ylim([0 1])
    xlabel('Normed cycle')
end
legend({'First','Last'})

    
%% Distrib cycles
figure('color',[1 1 1]), 
subplot(211), hist(AllCycles/3600,0:1/6:5); xlim([-0.1 5])
xlabel('Time (h), 10min bins')
subplot(212), hist(AllCycles/3600,0:1/12:5); xlim([-0.1 5])
xlabel('Time (h), 5min bins')

%% ParcoursSleepCycle mice
% see ParcoursSleepCycle.m
colori=[1 0 0; 1 0.2 0.8;0.5 0 1;0 0 0 ;0.5 0.5 0.5];
%colori=[0.6 0 0.6 ;1 0.8 1;1 0 1 ;0.1 0.7 0 ;0.5 0.2 0.1; 0 0 0];
doNew=2;
analyname='DataParcoursSleepCycleML';
if doNew, analyname=[analyname,'New'];end
if doNew==2, analyname=[analyname,'FirstLast'];end

try
    load(['/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/',analyname,'.mat']);
    ReNormT2;
    disp('DataParcoursSleepCycleML.mat loaded')
        %load /home/mobsyoda/Dropbox/Kteam/DataParcoursSleepCycle
catch
    Stages={'N3','N2','N1','REM','Wake'};
    if doNew
        Dir=PathForExperimentsMLnew('BASALlongSleep');
    else
        Dir1=PathForExperimentsDeltaSleepNew('BASAL');
        Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
        Dir2=PathForExperimentsML('BASAL');
        Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
        Dir=MergePathForExperiment(Dir1,Dir2);
    end
    ReNormT={};ReNormT2={};TotMan={};
    ReNormTlast={}; ReNormTfirst={};
    Trec=[9 19]*3600;% 9h-20h in sec 
    a=1;
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        disp(' ');disp(' ');disp(Dir.path{man})
        try
            clear N1 N2 N3
            if 1%ComputeSleepCycle
                
                [WakeC,REMEpochC,N1,N2,N3,~,SleepStagesC]=RunSubstages(0);close
                RG=Range(SleepStagesC);
                Dt=Data(SleepStagesC);
                NewSpleepStage=Dt+1;
                NewSpleepStage(find(Dt==1))=1;
                NewSpleepStage(find(Dt==1.5))=2;
                NewSpleepStage(find(Dt==4.5))=5;
                
            else % AnalysisSleepCycle
                [SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=CleanSleepStages(15);close;
                load('NREMsubstages','N1','N2','N3')
                NewSpleepStage=Data(SleepStagesC);
                RG=Range(SleepStagesC);
                id1=ismember(RG,Range(Restrict(SleepStagesC,N3)));
                id2=ismember(RG,Range(Restrict(SleepStagesC,N2)));
                id3=ismember(RG,Range(Restrict(SleepStagesC,N1)));
                
                NewSpleepStage(id1)=0;
                NewSpleepStage(id2)=1;
                NewSpleepStage(id3)=2;
            end
            SleepN=tsd(RG,NewSpleepStage);
            EnRem=End(REMEpochC);
            SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));
            
            % get time of the day
            NewtsdZT=GetZT_ML(Dir.path{man});
            SleepNzt=tsd(Data(Restrict(NewtsdZT,ts(RG))),NewSpleepStage);
            delay=min(Range(SleepNzt,'s'))-Trec(1);
            
            % get evol across night
            tempT=zeros(length(Stages),ceil(diff(Trec)/0.05));
            for n=1:length(Stages)
                if delay>0
                    tempT(n,floor(delay/0.05)+[1:length(Data(SleepN))])=(Data(SleepN)==n);
                else
                    rNsleep=Restrict(SleepN,intervalSet(-delay*1E4,max(Range(SleepN))));
                    tempT(n,1:length(Data(rNsleep)))=(Data(rNsleep)==n);
                end
            end
            TotMan{man}=tempT;
            
            % get sleep cycle
            tpsb=0:0.0001:1;
            for fac=1:5
                idx=find((End(SleepCycle,'s')-Start(SleepCycle,'s'))>25*(fac-1));
                for do=1:3
                    ReNormTnew=zeros(5,length(tpsb));
                    ReNormTnew2=ReNormTnew;
                    if do==1, todo=1:length(idx); 
                    elseif do==2, todo=1:floor(length(idx)/3); 
                    else, todo=floor(2*length(idx)/3):length(idx);
                    end
                    for i=todo
                        clear Mat rg MatTemp IW Mat2 MatTemp2
                        Mat=Restrict(SleepN,subset(SleepCycle,idx(i)));
                        rg=Range(Mat);
                        MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
                        for n=1:length(Stages)
                            ReNormTnew(n,:)=ReNormTnew(n,:)+(Data(Restrict(MatTemp,tpsb))==n)';
                        end
                        % remove long wakefulness >30s
                        tempWakeC=dropShortIntervals(WakeC,30*1E4);
                        Wend=max(Stop(and(tempWakeC,subset(SleepCycle,idx(i)))));
                        if isempty(Wend), Wend=Start(subset(SleepCycle,idx(i)));end
                        IW=intervalSet(Wend,End(subset(SleepCycle,idx(i))));
                        Mat2=Restrict(SleepN,IW);
                        rg=Range(Mat2);
                        MatTemp2=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat2));
                        for n=1:length(Stages)
                            ReNormTnew2(n,:)=ReNormTnew2(n,:)+(Data(Restrict(MatTemp2,tpsb))==n)';
                        end
                    end
                    ReNormTnew=ReNormTnew/length(todo);
                    ReNormTnew2=ReNormTnew2/length(todo);
                    if do==1
                        ReNormT{a,fac}=ReNormTnew;
                        ReNormT2{a,fac}=ReNormTnew2;
                    elseif do==2
                        ReNormTfirst{a,fac}=ReNormTnew;
                        ReNormTfirst2{a,fac}=ReNormTnew2;
                    else
                        ReNormTlast{a,fac}=ReNormTnew;
                        ReNormTlast2{a,fac}=ReNormTnew2;
                    end
                end
            end
            
            if 0
                figure('color',[1 1 1]), hold on
                for n=1:length(Stages), plot(ReNormTnew(n,:),'Color',colori(n,:));end
                legend(Stages), title(Dir.path{man})
            end
            
            nameMouse{a}=Dir.name{man};
            pathMouse{a}=Dir.path{man};
            a=a+1;
        catch
            disp('Problem... skip');keyboard
        end
    end
    
    %cd /media/mobssenior/Data2/Dropbox/Kteam
    save(['/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/',analyname,'.mat'],...
        'Dir','Stages','nameMouse','pathMouse','ReNormT','fac','ReNormT2','tpsb',...
        'ReNormTfirst','ReNormTfirst2','ReNormTlast','ReNormTlast2')
end

%----------------------------------------------------------------- 
%% Display
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.6 0.4]), numF=gcf;
fac=2;
for n=1:length(Stages)
    tt=zeros(1,size(ReNormT{1,fac},2));
    tt2=zeros(1,size(ReNormT2{1,fac},2));
    for i=1:length(ReNormT)
        tt=tt+ReNormT{i,fac}(n,:);
        tt2=tt2+ReNormT2{i,fac}(n,:);
    end
    subplot(1,2,1),hold on, plot(tpsb,tt/length(ReNormT),'Color',colori(n,:));title('All')
    %subplot(1,2,2),hold on, plot(tpsb,tt2/length(ReNormT2),'Color',colori(n,:));title('Wake Removed')
end
legend(Stages)
% Display indiv
if 0
    for f=1:fac
        figure('color',[1 1 1])
        for a=1:length(ReNormT)
            L=length(ReNormT);
            subplot(ceil(sqrt(L)),ceil(L/ceil(sqrt(L))),a), hold on
            for n=1:length(Stages), plot(tpsb,ReNormT{a,f}(n,:),'Color',colori(n,:));end
            title(nameMouse{a})
        end
        legend(Stages)
    end
end

if savFig, saveFigure(numF.Number,'MiceSleepCycle',FolderToSave);end

%% first and last sleep cycles
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.6 0.5]), numF=gcf;
smo=3;
tpsbH=0:0.001:1;
for n=1:length(Stages)
    subplot(3,length(Stages),n),hold on
    tt=zeros(1,size(ReNormTfirst{1,fac},2)); 
    for i=1:length(ReNormTfirst)
        tt=tt+ReNormTfirst{1,fac}(n,:);
    end
    tt2=zeros(1,size(ReNormTlast{1,fac},2)); 
    for i=1:length(ReNormTlast)
        tt2=tt2+ReNormTlast{1,fac}(n,:);
    end
    plot(tpsb(1:40:end),smooth(tt(1:40:end)/length(ReNormTfirst),smo),'Color',colori(n,:),'Linewidth',2)
    plot(tpsb(1:40:end),smooth(tt2(1:40:end)/length(ReNormTlast),smo),'Color',[0.3 0.3 0.3],'Linewidth',2)
    title(['MICE ',Stages{n}]); ylim([0 1])
    legend({'First','Last'})
    xlabel('Normed cycle')

    subplot(3,length(Stages),length(Stages)+n),hold on
    tt=zeros(1,size(ReNormTfirst2{1,fac},2)); 
    for i=1:length(ReNormTfirst2)
        tt=tt+ReNormTfirst2{1,fac}(n,:);
    end
    tt2=zeros(1,size(ReNormTlast{1,fac},2)); 
    for i=1:length(ReNormTlast)
        tt2=tt2+ReNormTlast{1,fac}(n,:);
    end
    plot(tpsb(1:40:end),smooth(tt(1:40:end)/length(ReNormTfirst2),smo),'Color',colori(n,:),'Linewidth',2)
    plot(tpsb(1:40:end),smooth(tt2(1:40:end)/length(ReNormTlast2),smo),'Color',[0.3 0.3 0.3],'Linewidth',2)
    title(['MICE ',Stages{n}]); ylim([0 1])
    legend({'First','Last'})
    xlabel('Normed cycle'); ylabel('Wake removed')
    
    subplot(3,length(Stages),2*length(Stages)+n),hold on
    tt=zeros(1,size(CycleMan{1,3},2)); tt2=tt;
    for i=1:length(CycleMan)
        tt=tt+CycleMan{i,3}(n,:);
        tt2=tt2+CycleMan{i,4}(n,:);
    end
    plot(tpsbH,smooth(tt/length(CycleMan),smo),'Color',colori(n,:),'Linewidth',2)
    plot(tpsbH,smooth(tt2/length(CycleMan),smo),'k','Linewidth',2)
    title(['HUMAN ',Stages{n}]); ylim([0 1])
    xlabel('Normed cycle')
end
legend({'First','Last'})

if savFig, saveFigure(numF.Number,'MiceSleepCycleFirstLast',FolderToSave);end
% '/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs'