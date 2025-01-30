% TrioHumanSleepCycle


cd /Users/Bench/Documents/Data/DataBaseSleep/DatabaseSubjects

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

AASM=1;
doall=0;
trioOnly=0;% no back and forth
lim=15; % in %of transition

minPeriod(1)=200;
minPeriod(2)=300;

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



    load DatabaseSubjects
    
    for j=1:20
            eval(['A = importdata(''HypnogramR&K_subject',num2str(j),'.txt'');'])
            SleepCylcesHumanRK{j}=A.data;
            eval(['A = importdata(''HypnogramAASM_subject',num2str(j),'.txt'');'])
            SleepCylcesHumanAASM{j}=A.data;
    end
    
    if AASM
    SleepCylcesHuman=SleepCylcesHumanAASM;
    tii='AASM';
    else
    SleepCylcesHuman=SleepCylcesHumanRK;  %SleepCylcesHumanRK
     tii='RK';
    end
    
    if trioOnly
        tii2='no back and forth';
    else
        tii2='with back and forth';
    end
    
    TrioL=[];

    NamesStages{1}='WAKE';
    NamesStages{2}='REM';
    NamesStages{3}='N1';
    NamesStages{4}='N2';
    NamesStages{5}='N3';
    
    
    
        
%     R1{j}=[R1{j};(Data(Restrict(MatTemp,tpsb))==3)'];
%     R2{j}=[R2{j};(Data(Restrict(MatTemp,tpsb))==2)'];
%     R3{j}=[R3{j};(Data(Restrict(MatTemp,tpsb))<1.5)'];
%     R4{j}=[R4{j};(Data(Restrict(MatTemp,tpsb))==4)'];
%     R5{j}=[R5{j};(Data(Restrict(MatTemp,tpsb))==5)'];
        
        
for man=1:length(SleepCylcesHuman)

    clear WAKE REM N1 N2 N3 SleepStage
    SleepStages=tsd([1:length(SleepCylcesHuman{man})]*20*1E4,SleepCylcesHuman{man});
    

    idWake=find(SleepCylcesHuman{man}==5);
    WakeEpoch1=thresholdIntervals(SleepStages,4.5,'Direction','Above');
    WakeEpoch2=thresholdIntervals(SleepStages,5.5,'Direction','Below');
    WAKE=and(WakeEpoch1,WakeEpoch2);
    
    idREM=find(SleepCylcesHuman{man}==4);
    REMEpoch1=thresholdIntervals(SleepStages,3.5,'Direction','Above');
    REMEpoch2=thresholdIntervals(SleepStages,4.5,'Direction','Below');
    REM=and(REMEpoch1,REMEpoch2);
    
    idN1=find(SleepCylcesHuman{man}==3);
    N1Epoch1=thresholdIntervals(SleepStages,2.5,'Direction','Above');
    N1Epoch2=thresholdIntervals(SleepStages,3.5,'Direction','Below');
    N1=and(N1Epoch1,N1Epoch2);
       
    idN2=find(SleepCylcesHuman{man}==2);
    N2Epoch1=thresholdIntervals(SleepStages,1.5,'Direction','Above');
    N2Epoch2=thresholdIntervals(SleepStages,2.5,'Direction','Below');
    N2=and(N2Epoch1,N2Epoch2);
       
    idN3=find(SleepCylcesHuman{man}<1.5);
    N3Epoch1=thresholdIntervals(SleepStages,-0.5,'Direction','Above');
    N3Epoch2=thresholdIntervals(SleepStages,1.5,'Direction','Below');
    N3=and(N3Epoch1,N3Epoch2);
           
    

    
    % -----------------------
    % load movements
    
%     try
    %    disp('Loading Substages...')
        %[WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close;
        SleepStage=[];
   %     disp('Calculating SleepStages...')
        for n=1:length(NamesStages)
            eval(['epoch=',NamesStages{n},';'])
            SleepStage=[SleepStage; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
        end
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
        
  %      disp('Counting all transitions')
        for ii=1:length(NamesStages)
            for ij=1:length(NamesStages)
                for ik=1:length(NamesStages)
                    if ij~=ii && ij~=ik
                        ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                        ijkL3=find(MatS(ijk,4)>minPeriod(1) & MatS(ijk,5)>minPeriod(1) & MatS(ijk,6)>minPeriod(1));
                        ijkL5=find(MatS(ijk,4)>minPeriod(2) & MatS(ijk,5)>minPeriod(2) & MatS(ijk,6)>minPeriod(2));
                        TrioL=[TrioL;[ii,ij,ik,length(ijk),length(ijkL3),length(ijkL5),man]];
                        %disp([NamesStages{ii},'-',NamesStages{ij},'-',NamesStages{ik}])
                    end
                end
            end
            
        end
 %       disp('Done.')
%     catch
%         disp('Problem.. skip')
%     end
end


%%

savT=TrioL; 
if trioOnly,
    savT(find(savT(:,1)-savT(:,3)==0),:)=[]; 
end
U=unique(savT(:,1:3),'rows');

matbar=nan(length(SleepCylcesHuman),size(U,1));
matbar1=matbar; matbar2=matbar;
for man=1:length(SleepCylcesHuman)
    nbTransMan=[sum(savT(savT(:,7)==man,4)),sum(savT(savT(:,7)==man,5)),sum(savT(savT(:,7)==man,6))];
    
    for u=1:size(U,1)
        ijk=U(u,:);
        ind=find(savT(:,7)==man & savT(:,1)==ijk(1) & savT(:,2)==ijk(2) & savT(:,3)==ijk(3));
        if ~isempty(ind)
            matbar(man,u)=100*savT(ind,4)/nbTransMan(1);
            matbar1(man,u)=100*savT(ind,5)/nbTransMan(2);
            matbar2(man,u)=100*savT(ind,6)/nbTransMan(3);
            if doall
                matbar(man,u)=savT(ind,4);
                matbar1(man,u)=savT(ind,5);
                matbar2(man,u)=savT(ind,6);
            end
            name{u}=[NamesStages{U(u,1)},'-',NamesStages{U(u,2)},'-',NamesStages{U(u,3)}];
        end
    end
end

figure('Color',[1 1 1]),
subplot(1,3,1),
Mn=nanmean(matbar,1);
if doall,Mn=nansum(matbar,1);end
[BE,ind]=sort(Mn);
ind(Mn(ind)<0.3)=[];
barh(Mn(ind)); ylim([0,length(ind)+1])
%title(sprintf('trio of transition, n=%d expe, N=%d animals',length(Dir.path),length(unique(Dir.name))))
set(gca,'Ytick',1:length(ind)); set(gca,'YtickLabel',name(ind))
hold on, d=min(find(cumsum(Mn(ind))>lim)); line(xlim,d+[-0.5 -0.5],'Color','k'); text(max(xlim)/2,d-1,['< ',num2str(lim),'% transitions'])
title([tii,', ',tii2])

subplot(1,3,2),
Mn=nanmean(matbar1,1);
if doall,Mn=nansum(matbar1,1);end
[BE,ind]=sort(Mn);
ind(Mn(ind)<0.3)=[];
barh(Mn(ind)); ylim([0,length(ind)+1])
%title(sprintf('trio of transition if episod>3s, n=%d expe, N=%d animals',length(Dir.path),length(unique(Dir.name))))
xlabel('% of total transition')
set(gca,'Ytick',1:length(ind)); set(gca,'YtickLabel',name(ind))
hold on, d=min(find(cumsum(Mn(ind))>lim)); line(xlim,d+[-0.5 -0.5],'Color','k'); text(max(xlim)/2,d-1,['< ',num2str(lim),'% transitions'])

subplot(1,3,3),
Mn=nanmean(matbar2,1);
if doall,Mn=nansum(matbar2,1);end
[BE,ind]=sort(Mn);
ind(Mn(ind)<0.3)=[];
barh(Mn(ind)); ylim([0,length(ind)+1])
%title(sprintf('trio of transition if episod>5s, n=%d expe, N=%d animals',length(Dir.path),length(unique(Dir.name))))
set(gca,'Ytick',1:length(ind)); set(gca,'YtickLabel',name(ind))
hold on, d=min(find(cumsum(Mn(ind))>lim)); line(xlim,d+[-0.5 -0.5],'Color','k'); text(max(xlim)/2,d-1,['< ',num2str(lim),'% transitions'])

% if trioOnly
%     saveFigure(gcf,'CountTrioTransitionNoBF',FolderToSave);
% else
%     saveFigure(gcf,'CountTrioTransition',FolderToSave);
% end

