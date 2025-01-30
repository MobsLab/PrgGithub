%AnalyseNREMsubstages_TrioTransitionML.m
%
% list of related scripts in NREMstages_scripts.m 



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman';
res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
analyname='AnalySubstagesTrioTransition.mat';

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0 0 0];
%colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];

Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE MICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try 
    load([res,'/',analyname]);
    disp([analyname,' already exists, laoded!'])
    
catch
    TrioL=[];
    for man=1:length(Dir.path)
        disp(' ');disp(Dir.path{man})
        cd(Dir.path{man})
        
        % -----------------------
        % load movements
        clear WAKE REM N1 N2 N3 SleepStage
        try
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close;
            SleepStage=[];
            disp('Calculating SleepStages...')
            for n=1:length(NamesStages)
                eval(['epoch=',NamesStages{n},';'])
                SleepStage=[SleepStage; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStage=sortrows(SleepStage,1);
            
            ind=find(diff(SleepStage(:,3))==0);% if noise between..
            while ~isempty(ind)
                SleepStage(ind+1,1)=SleepStage(ind,1);
                SleepStage(ind,:)=[];
                ind=find(diff(SleepStage(:,3))==0);
            end
            
            SleepStage(:,4)=SleepStage(:,2)-SleepStage(:,1); % duration
            MatS=[0;0;SleepStage(:,3)];
            MatS(:,2)=[0;SleepStage(:,3);0];
            MatS(:,3)=[SleepStage(:,3);0;0];
            MatS(:,4)=[0;0;SleepStage(:,4)];
            MatS(:,5)=[0;SleepStage(:,4);0];
            MatS(:,6)=[SleepStage(:,4);0;0];
            
            disp('Counting all transitions')
            for ii=1:length(NamesStages)
                for ij=1:length(NamesStages)
                    for ik=1:length(NamesStages)
                        if ij~=ii && ij~=ik
                            ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                            ijkL3=find(MatS(ijk,4)>3 & MatS(ijk,5)>3 & MatS(ijk,6)>3);
                            ijkL5=find(MatS(ijk,4)>5 & MatS(ijk,5)>5 & MatS(ijk,6)>5);
                            TrioL=[TrioL;[ii,ij,ik,length(ijk),length(ijkL3),length(ijkL5),man]];
                            %disp([NamesStages{ii},'-',NamesStages{ij},'-',NamesStages{ik}])
                        end
                    end
                end
                
            end
            disp('Done.')
        catch
            disp('Problem.. skip')
        end
    end
    save([res,'/',analyname],'TrioL','NamesStages','Dir');
end


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE HUMANS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%edit TrioHumanSleepCycle.m
minPeriod(1)=200;
minPeriod(2)=300;
cd /media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman
load DatabaseSubjects.mat

if ~exist('SleepCylcesHumanRK','var') || ~exist('SleepCylcesHumanAASM','var')
    disp('Getting data for all subjects...')
    for j=1:20
        eval(['A = importdata(''HypnogramR&K_subject',num2str(j),'.txt'');'])
        SleepCylcesHumanRK{j}=A.data;
        eval(['A = importdata(''HypnogramAASM_subject',num2str(j),'.txt'');'])
        SleepCylcesHumanAASM{j}=A.data;
    end
end

if 1
    SleepCylcesHuman=SleepCylcesHumanAASM;
    tii='AASM';
    step=5; % epoch = 5s
else
    SleepCylcesHuman=SleepCylcesHumanRK;  %SleepCylcesHumanRK epoch = 30s
    tii='RK';
    step=30; % attention! needs to be checked !
end

indivHypno=1;
if indivHypno,figure('Color',[1 1 1]); numF=gcf;end

TrioLH=[];
DUR=nan(length(SleepCylcesHuman),length(NamesStages)+1);
totDUR=nan(length(SleepCylcesHuman),length(NamesStages)+2);
DurCylcle={};
MatEvol=nan(length(SleepCylcesHuman),500);
EvolSleep=nan(length(NamesStages),length(SleepCylcesHuman),60);

for man=1:length(SleepCylcesHuman)
    
    disp(' ');disp(sprintf('Subject #%d',man))
    clear WAKE REM N1 N2 N3 SleepStage
    SleepStages=tsd([1:length(SleepCylcesHuman{man})]*step*1E4,SleepCylcesHuman{man});
    
    % wake 5, rem 4, N1 3, N2 2, N3 1.
    % 20s epoch
    WakeEpoch1=thresholdIntervals(SleepStages,4.5,'Direction','Above');
    WakeEpoch2=thresholdIntervals(SleepStages,5.5,'Direction','Below');
    WAKE=and(WakeEpoch1,WakeEpoch2);
    
    REMEpoch1=thresholdIntervals(SleepStages,3.5,'Direction','Above');
    REMEpoch2=thresholdIntervals(SleepStages,4.5,'Direction','Below');
    REM=and(REMEpoch1,REMEpoch2);
    
    stoREM=Stop(REM,'s');
    DurCylcle{man}=[stoREM(1)-min(Stop(WAKE,'s'));diff(stoREM)];
    
    N1Epoch1=thresholdIntervals(SleepStages,2.5,'Direction','Above');
    N1Epoch2=thresholdIntervals(SleepStages,3.5,'Direction','Below');
    N1=and(N1Epoch1,N1Epoch2);
    
    N2Epoch1=thresholdIntervals(SleepStages,1.5,'Direction','Above');
    N2Epoch2=thresholdIntervals(SleepStages,2.5,'Direction','Below');
    N2=and(N2Epoch1,N2Epoch2);
    
    N3Epoch1=thresholdIntervals(SleepStages,-0.5,'Direction','Above');
    N3Epoch2=thresholdIntervals(SleepStages,1.5,'Direction','Below');
    N3=and(N3Epoch1,N3Epoch2);
    
    % repartition in cycle
    DurSleep=max(Start(WAKE))-min(Stop(WAKE)); % total sleep time
    MatEvol(man,:)=Data(Restrict(SleepStages,ts(min(Stop(WAKE)):DurSleep/499:max(Start(WAKE)))));
    
    
    NREM=or(N1,or(N2,N3)); NREM=mergeCloseIntervals(NREM,1);
    % plot indiv PlotPolysomnoML
    if indivHypno
        subplot(7,3,man)
        PlotPolysomnoML(N1,N2,N3,NREM,REM,WAKE,numF);
        title(sprintf('Subject #%d',man)); legend off
        set(gca,'Ytick',[11,11.5,12:14]); set(gca,'YtickLabel',NamesStages(5:-1:1)); ylim([10.5 14.5])
    end
    
    % Calculating SleepStages
    disp('Calculating SleepStages...')
    SleepStage=[];
    for n=1:length(NamesStages)
        eval(['epoch=',NamesStages{n},';'])
        SleepStage=[SleepStage; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
        DUR(man,n)=mean(Stop(epoch,'s')-Start(epoch,'s'));
        totDUR(man,n)=sum(Stop(epoch,'s')-Start(epoch,'s'));
        %         disp(sprintf([NamesStages{n},' : average %1.1f min'],mean(Stop(epoch,'s')-Start(epoch,'s'))/60))
        %         if mean(Stop(epoch,'s')-Start(epoch,'s'))/60 >60, keyboard;end
       
        A=SleepCylcesHuman{man};
        %A=A(min(find(A==5 & [A(2:end);0]~=5)):max(find(A~=5 & [A(2:end);0]==5)));
        %x=0:length(A)/100:length(A); y=hist(find(A==6-n),x);% wake 5, rem 4, N1 3, N2 2, N3 1.
        x=1:120:length(A); y=hist(find(A==6-n),x);% wake 5, rem 4, N1 3, N2 2, N3 1.
        
        EvolSleep(n,man,1:length(x))=y;
    end
    DUR(man,n+1)=mean(Stop(NREM,'s')-Start(NREM,'s'));
    totDUR(man,n+1)=sum(Stop(NREM,'s')-Start(NREM,'s'));
    totDUR(man,n+2)=sum(Stop(WAKE,'s')-Start(WAKE,'s'));
    %totDUR(man,:)=100*totDUR(man,:)/(max(Range(SleepStages,'s'))-min(Range(SleepStages,'s')));
    
    SleepStage=sortrows(SleepStage,1);
    
    ind=find(diff(SleepStage(:,3))==0);% if noise between..
    pbind(man,1)=length(ind);
    while ~isempty(ind)
        SleepStage(ind+1,1)=SleepStage(ind,1);
        SleepStage(ind,:)=[];
        ind=find(diff(SleepStage(:,3))==0);
    end
    pbind(man,2)=length(ind);
    
    SleepStage(:,4)=SleepStage(:,2)-SleepStage(:,1); % duration
    MatS=[0;0;SleepStage(:,3)];
    MatS(:,2)=[0;SleepStage(:,3);0];
    MatS(:,3)=[SleepStage(:,3);0;0];
    MatS(:,4)=[0;0;SleepStage(:,4)];
    MatS(:,5)=[0;SleepStage(:,4);0];
    MatS(:,6)=[SleepStage(:,4);0;0];
    
    %Counting all transitions
    disp('Counting all transitions')
    for ii=1:length(NamesStages)
        for ij=1:length(NamesStages)
            for ik=1:length(NamesStages)
                if ij~=ii && ij~=ik
                    ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                    ijkL3=find(MatS(ijk,4)>minPeriod(1) & MatS(ijk,5)>minPeriod(1) & MatS(ijk,6)>minPeriod(1));
                    ijkL5=find(MatS(ijk,4)>minPeriod(2) & MatS(ijk,5)>minPeriod(2) & MatS(ijk,6)>minPeriod(2));
                    TrioLH=[TrioLH;[ii,ij,ik,length(ijk),length(ijkL3),length(ijkL5),man]];
                    %disp([NamesStages{ii},'-',NamesStages{ij},'-',NamesStages{ik}])
                end
            end
        end
        
    end
    disp('Done.')
    
end
%%
MAT=[];
for man=1:length(SleepCylcesHuman)
    MAT=[MAT;DurCylcle{man}];
end
figure('Color',[1 1 1]),
subplot(1,2,1),hist(MAT/3600,20); colormap gray
title(sprintf('Cycle duration distribution (mean=%1.1fh +/-%1.1f)',mean(MAT)/3600,stdError(MAT/3600)))
hold on, line(mean(MAT/3600)+[0 0],ylim,'Color','r');

subplot(1,2,2),hist(MAT(MAT>15*60)/3600,20);
line(mean(MAT(MAT>15*60)/3600)+[0 0],ylim,'Color','r')
title(sprintf('Cycle duration distribution (mean episod >15min =%1.1fh +/-%1.1f)',mean(MAT(MAT>15*60)/3600),stdError(MAT(MAT>15*60)/3600)))
ylabel('nb of cycles, n=20 subjects'); xlabel('Time (hr)')
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

doall=0;
trioOnly=0;% no back and forth
lim=15; % in %of transition

DoRestrict=0; % 0 for raw, 1 or 2

if trioOnly,
    savT(find(savT(:,1)-savT(:,3)==0),:)=[];
end
for i=1:2
    if i==1% humans
        savT=TrioLH;
        legn=sprintf('trio of transition, n=%d subjects',length(SleepCylcesHuman));
    else% mice
        savT=TrioL;
        legn=sprintf('trio of transition, n=%d expe, N=%d animals',length(Dir.path),length(unique(Dir.name)));
    end
    indiv=unique(savT(:,7));
    U=unique(savT(:,1:3),'rows');
    
    matbar=nan(length(indiv),size(U,1));
    for man=1:length(indiv)
        nbTransMan=[sum(savT(savT(:,7)==man,4)),sum(savT(savT(:,7)==man,5)),sum(savT(savT(:,7)==man,6))];
        
        for u=1:size(U,1)
            ijk=U(u,:);
            ind=find(savT(:,7)==man & savT(:,1)==ijk(1) & savT(:,2)==ijk(2) & savT(:,3)==ijk(3));
            if ~isempty(ind)
                matbar(man,u)=100*savT(ind,4+DoRestrict)/nbTransMan(1+DoRestrict);
                if doall
                    matbar(man,u)=savT(ind,4);
                end
                name{u}=[NamesStages{U(u,1)},'-',NamesStages{U(u,2)},'-',NamesStages{U(u,3)}];
            end
        end
    end
    if i==1
        matbarH=matbar;
    else
        matbarM=matbar;
    end
end

figure('Color',[1 1 1])
nameorder={'humans','mice'};
for i=1:2
    MnM=nanmean(matbarM,1);
    StM=stdError(matbarM);
    MnH=nanmean(matbarH,1);
    StH=stdError(matbarH);
    if i==1% order by human
        [BE,ind]=sort(MnH);
        ind(MnH(ind)<0.3)=[];
        d=min(find(cumsum(MnH(ind))>lim));
    else% order by mice
        [BE,ind]=sort(MnM);
        ind(MnM(ind)<0.3)=[];
        d=min(find(cumsum(MnM(ind))>lim));
    end
    
    subplot(1,2,i), barh([MnH(ind)',MnM(ind)'],1.5);
    %hold on, herrorbar(MnH(ind),1:length(ind),StH(ind),'+k')
    title(['order by ',nameorder{i}]);
    xlabel('% of total transition'); ylim([0,length(ind)+1])
    set(gca,'Ytick',1:length(ind)); set(gca,'YtickLabel',name(ind))
    line(xlim,d+[-0.5 -0.5],'Color','k'); text(max(xlim)/2,d-1,['< ',num2str(lim),'% transitions']);
end
legend(nameorder);colormap copper
% saveFigure(gcf,'CountTrioTransitionNoBF',FolderToSave);
% saveFigure(gcf,'CountTrioTransition',FolderToSave);


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< CORRELATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

iTrioBF=find(U(:,1)-U(:,3)==0);
iTrio=find(U(:,1)-U(:,3)~=0);

x=log10(MnM);
y=log10(MnH);

figure('Color',[1 1 1]), hold on,
plot(x(iTrio),y(iTrio),'.k','Markersize',15)
plot(x(iTrioBF),y(iTrioBF),'.r','Markersize',15)

ylim([log10(0.01) log10(100)]); set(gca,'Ytick',log10([0.01,0.1 1 10 100]))
set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
xlim([log10(0.01) log10(100)]); set(gca,'Xtick',log10([0.01,0.1 1 10 100]))
set(gca,'XtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
xlabel('Mice');  ylabel('Human')
line(xlim,xlim,'Color',[0.5 0.5 0.5]);


y(abs(x)==Inf)=[];x(abs(x)==Inf)=[];
x(abs(y)==Inf)=[];y(abs(y)==Inf)=[];
p= polyfit(x,y,1);
line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
[r,p]=corrcoef(x,y);
text(max(xlim)*0.1+min(xlim),max(ylim), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)))

legend('Trio no BF','Trio BF','Corr')
%saveFigure(gcf,'CountTrioTransition-corrHumanMice',FolderToSave);



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< DURATION HUMAN EPISODS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ind=[1,2,6,3,4,5];
DUR2=DUR;
DUR2(17,:)=[];
tempName=[NamesStages,'NREM'];
figure('Color',[1 1 1]),
bar(nanmean(DUR2(:,ind)/60)); colormap gray
hold on, errorbar(1:length(tempName),nanmean(DUR2(:,ind)/60),stdError(DUR2(:,ind)/60),'+k')
set(gca,'Xtick',1:length(tempName));set(gca,'XtickLabel',tempName(ind))
title('mean episod duration (min)'); ylim([0 20])

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< DURATION HUMAN TOTAL STAGES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.4 0.4 0.2]),
DUR2=totDUR/3600;
DUR2(17,:)=[];
y=DUR2(:,2);
ind=[3:6,1];
for n=1:length(ind)
    x=DUR2(:,ind(n));
    subplot(1,5,n),plot(x,y,'.k','MarkerSize',14)
    xlabel([tempName{ind(n)},' total duration (h)']); ylabel('REM total duration (h)')
    p= polyfit(x,y,1);
    [r,pval]=corrcoef(x,y);
    hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
    title(sprintf([tempName{ind(n)},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colori(ind(n),:));
    xlim([0.9*min(x),max(x)*1.1]); ylim([0.9*min(y),max(y)*1.1]); 
end
%saveFigure(gcf,'CorrelationSubstagesDurationHumans','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FiguresON/');


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< SLEEP CYCLES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%ComputeSleepCycle.m
figure('Color',[1 1 1])
for n=1:length(NamesStages)
    subplot(2,3,n), hold on,
    y=squeeze(EvolSleep(n,:,1:50));
    x=[1:size(y,2)]/6;
    plot(x,100*smooth(nanmean(y)/120,10),'Color',colori(n,:),'Linewidth',2)
    plot(x,100*smooth(nanmean(y/120)+stdError(y/120),10),'Color',colori(n,:))
    plot(x,100*smooth(nanmean(y/120)-stdError(y/120),10),'Color',colori(n,:))
    
    p= polyfit(x,100*nanmean(y)/120,1);[r,pval]=corrcoef(x,100*nanmean(y));
    hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k')
     title(sprintf([NamesStages{n},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colori(n,:));
    ylim([0 80]); xlim([0 8])
end
xlabel('Time (h)')




