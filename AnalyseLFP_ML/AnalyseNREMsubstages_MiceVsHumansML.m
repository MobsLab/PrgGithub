%AnalyseNREMsubstages_MiceVsHumansML.m
%
% list of related scripts in NREMstages_scripts.m 



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS MICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman';
res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
analyname='AnalySubstages';
NameEpochs={'WAKE','REM','N1','N2','N3','totSLEEP','NREM','totRec'};
%FolderFigure='/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/NewFigs';
FolderFigure='/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs';
%FolderFigure='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_HumansVSMice';
savFig=0;
%doNew=1; % BASALlongSleep
doNew=2; % BASALlongSleep + old mice
%doNew=0; %old mice

colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0 0 1;0.5 0.5 0.8;0 1 0];
%colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0 0 0];
%colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
if doNew==1
    analyname=[analyname,'New'];
    Dir=PathForExperimentsMLnew('BASALlongSleep');
    
elseif doNew==2
    analyname=[analyname,'All'];
    Dir1=PathForExperimentsMLnew('BASALlongSleep');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
else
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
end


if 0 % new computation
    res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
    FolderToSave=res;
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir3=PathForExperimentsMLnew('BASAL');
    Dir=MergePathForExperiment(Dir1,Dir2);
    Dir=MergePathForExperiment(Dir,Dir3);
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE MICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
valSlSt=[4,3,2,1.5,1];
bstep=10; %(min) default =10
try 
    %load([res,'/',analyname,'TrioTransition']); 
    load([res,'/',analyname,'MiceVsHumans']); 
    DuoL;MiceEpochs;h_deb;
    disp([analyname,'MiceVsHumans.mat already exists, laoded!'])
catch
    TrioL=[]; DuoL=[]; h_deb=nan(length(Dir.path),1);
    DURmice=nan(length(Dir.path),length(NameEpochs));
    totDURmice=nan(length(Dir.path),length(NameEpochs));
    Evolmice=nan(length(NameEpochs),length(Dir.path),10*60/bstep);
    MiceEpochs={}; 
    for man=1:length(Dir.path)
        disp(' ');disp(Dir.path{man})
        try
            cd(Dir.path{man})
            
            % -----------------------
            % load movements
            clear WAKE REM N1 N2 N3 NREM totSLEEP SleepStages Sleep
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
            %WAKE=WAKEnoise;
            NREM=or(or(N1,N2),N3); NREM=mergeCloseIntervals(NREM,100);
            totSLEEP=or(REM,NREM); totSLEEP=mergeCloseIntervals(totSLEEP,100);
            totRec=or(WAKE,NREM); totRec=mergeCloseIntervals(totRec,100);
            
            % -----------------------
             % get time of the day
            NewtsdZT=GetZT_ML(Dir.path{man});
            manDate(man)=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
            if manDate(man)>20160701, hlightON=9; else, hlightON=8;end
            h_deb(man)=mod(min(Data(NewtsdZT)/1E4)/3600,24);
            firstInd=max(0,round((h_deb(man)-hlightON)*60/bstep));
            delay=min(hlightON-h_deb(man),0)*3600;
            % ------------------------
            disp('Calculating Sleeps...')
            Sleep=[];
            for n=1:length(NameEpochs)
                eval(['epoch=',NameEpochs{n},';'])
                MiceEpochs{man,n}=epoch;
                Sleep=[Sleep; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
                
                %evol across night
                for ji=1:10*60/bstep-firstInd
                    I=and(epoch,intervalSet((delay+ji*bstep*60)*1E4,(delay+(ji+1)*bstep*60)*1E4));% bstep min steps
                    Evolmice(n,man,ji+firstInd)=sum(Stop(I,'s')-Start(I,'s'));
                end
                
                DURmice(man,n)=mean(Stop(epoch,'s')-Start(epoch,'s'));
                totDURmice(man,n)=sum(Stop(epoch,'s')-Start(epoch,'s'));
            end
            Sleep=sortrows(Sleep,1);
            
            ind=find(diff(Sleep(:,3))==0);% if noise between..
            while ~isempty(ind)
                Sleep(ind+1,1)=Sleep(ind,1);
                Sleep(ind,:)=[];
                ind=find(diff(Sleep(:,3))==0);
            end
            
            Sleep(:,4)=Sleep(:,2)-Sleep(:,1); % duration
            MatS=[0;0;Sleep(:,3)];
            MatS(:,2)=[0;Sleep(:,3);0];
            MatS(:,3)=[Sleep(:,3);0;0];
            MatS(:,4)=[0;0;Sleep(:,4)];
            MatS(:,5)=[0;Sleep(:,4);0];
            MatS(:,6)=[Sleep(:,4);0;0];
            
            disp('Counting all transitions')
            for ii=1:5
                for ij=1:5
                    if ij~=ii
                        id=find(MatS(:,1)==ii & MatS(:,2)==ij);
                        ijL3=find(MatS(id,4)>3 & MatS(id,5)>3);
                        ijL5=find(MatS(id,4)>5 & MatS(id,5)>5);
                        DuoL=[DuoL;[ii,ij,length(id),length(ijL3),length(ijL5),man]];
                        for ik=1:5
                            if ij~=ik
                                ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                                ijkL3=find(MatS(ijk,4)>3 & MatS(ijk,5)>3 & MatS(ijk,6)>3);
                                ijkL5=find(MatS(ijk,4)>5 & MatS(ijk,5)>5 & MatS(ijk,6)>5);
                                TrioL=[TrioL;[ii,ij,ik,length(ijk),length(ijkL3),length(ijkL5),man]];
                                %disp([NamesStages{ii},'-',NamesStages{ij},'-',NamesStages{ik}])
                            end
                        end
                    end
                end
                
            end
           
            disp('Done.')
        catch
            disp('Problem.. skip'); keyboard
        end
    end
    save([res,'/',analyname,'MiceVsHumans'],'NamesStages','Dir','bstep','Evolmice','TrioL',...
        'DuoL','DURmice','totDURmice','NameEpochs','MiceEpochs','h_deb');
end


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE HUMANS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoYD=0; % 1 for YD, 2 for narco
DoCleanDREAMS=0;
OnsetSleep=0;
TMerge=0; % in second default=5s, else =35, =120
%edit TrioHumanSleepCycle.m
tii='AASM';
bstep=10; %(min) default =10
%tii='RK';
minPeriod(1)=200;  %???
minPeriod(2)=300;  % ???
analynameH='AnalySubstagesHumans'; 
if DoYD==1
    analynameH=[analynameH,'YD']; 
elseif DoYD==2
    analynameH=[analynameH,'YDnarco']; 
else
    if DoCleanDREAMS
        analynameH=[analynameH,'c',tii];
    else
        analynameH=[analynameH,tii];
    end
end
analynameH=[analynameH,sprintf('_%dmrg%ds_step%dmin',OnsetSleep,TMerge,bstep)];

try
    load([res,'/',analynameH]);
    DuoLH; MatStage;Epochs;SleepStage;
    disp([analynameH,'.mat already exists, laoded!'])
    
catch
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if DoYD>0
        cd /media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHumanYD
        load YDdataHumans.mat DataYD DataYDnarco Subjects NarcoSubjects 
        if DoYD>1; DataYD=DataYDnarco; Subjects=NarcoSubjects;end
        a=1; SleepCylcesHuman={}; AgeAndSex={};
        for i=1:length(DataYD)
            if isempty(DataYD{i})==0
                SleepCylcesHuman{a}=DataYD{i}; 
                AgeAndSex{a}=sprintf([Subjects{i,3}{:},' - %dyo'],Subjects{i,2});
                a=a+1; 
            end
        end
        step=30; %
    else
        cd /media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman
        load DatabaseSubjects.mat
        step=5; %
        if ~exist('SleepCylcesHumanRK','var') || ~exist('SleepCylcesHumanAASM','var')
            disp('Getting data for all subjects...')
            for j=1:20
                eval(['A = importdata(''HypnogramR&K_subject',num2str(j),'.txt'');'])
                SleepCylcesHumanRK{j}=A.data;
                eval(['A = importdata(''HypnogramAASM_subject',num2str(j),'.txt'');'])
                SleepCylcesHumanAASM{j}=A.data;
            end
        end
        if strcmp(tii,'AASM')
            SleepCylcesHuman=SleepCylcesHumanAASM;
        else
            SleepCylcesHuman=SleepCylcesHumanRK;  %SleepCylcesHumanRK epoch = 30s
        end
        if DoCleanDREAMS % remove subjects #7 and #12
            SleepCylcesHuman=SleepCylcesHuman([1:6,8:11,13:20]);
            AgeAndSex=AgeAndSex([1:6,8:11,13:20]);
        end 
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AllInfo={};
    TrioLH=[]; DuoLH=[]; 
    DUR=nan(length(SleepCylcesHuman),length(NameEpochs)+1);
    totDUR=nan(length(SleepCylcesHuman),length(NameEpochs)+2);
    DurCylcle={}; MatStage={}; Epochs={};
    MatEvol=nan(length(SleepCylcesHuman),500);
    EvolSleep=nan(length(NameEpochs),length(SleepCylcesHuman),10*60/bstep);
    EvolSleep2=nan(length(NameEpochs),length(SleepCylcesHuman),10*60/bstep);
    for man=1:length(SleepCylcesHuman)
        
        disp(' ');disp(sprintf('Subject #%d',man))
        clear WAKE REM N1 N2 N3 SleepStages Sleep
        Sleep=SleepCylcesHuman{man};
        if OnsetSleep, Sleep(1:min(find(Sleep<5)))=[];end
        SleepStages=tsd([1:length(Sleep)]*step*1E4,Sleep);
        
        % wake 5, rem 4, N1 3, N2 2, N3 1.
        % 20s epoch
        WakeEpoch1=thresholdIntervals(SleepStages,4.5,'Direction','Above');
        WakeEpoch2=thresholdIntervals(SleepStages,5.5,'Direction','Below');
        WAKE=and(WakeEpoch1,WakeEpoch2);
        
        REMEpoch1=thresholdIntervals(SleepStages,3.5,'Direction','Above');
        REMEpoch2=thresholdIntervals(SleepStages,4.5,'Direction','Below');
        REM=and(REMEpoch1,REMEpoch2);
        REM=mergeCloseIntervals(REM,max(0.1,TMerge)*1E4); 
        
        stoREM=Stop(REM,'s');
        DurCylcle{man}=[stoREM(1)-min(Stop(WAKE,'s'));diff(stoREM)];
        
        N1Epoch1=thresholdIntervals(SleepStages,2.5,'Direction','Above');
        N1Epoch2=thresholdIntervals(SleepStages,3.5,'Direction','Below');
        N1=and(N1Epoch1,N1Epoch2);
        N1=mergeCloseIntervals(N1,max(0.1,TMerge)*1E4); 
        
        N2Epoch1=thresholdIntervals(SleepStages,1.5,'Direction','Above');
        N2Epoch2=thresholdIntervals(SleepStages,2.5,'Direction','Below');
        N2=and(N2Epoch1,N2Epoch2);
        N2=mergeCloseIntervals(N2,max(0.1,TMerge)*1E4);
        
        N3Epoch1=thresholdIntervals(SleepStages,-0.5,'Direction','Above');
        N3Epoch2=thresholdIntervals(SleepStages,1.5,'Direction','Below');
        N3=and(N3Epoch1,N3Epoch2);
        N3=mergeCloseIntervals(N3,max(0.1,TMerge)*1E4); 
        
        % repartition in cycle
        DurSleep=[min(Stop(WAKE)),max(Start(WAKE))];
        if OnsetSleep,  DurSleep(1)=0; end % total sleep time
        Nbin=500;
        MatEvol(man,:)=Data(Restrict(SleepStages,ts(DurSleep(1):diff(DurSleep)/(Nbin-1):DurSleep(2))));
        
        WAKE=WAKE-N1-N2-N3;
        NREM=or(N1,or(N2,N3)); NREM=mergeCloseIntervals(NREM,10);
        totSLEEP=or(NREM,REM); totSLEEP=mergeCloseIntervals(totSLEEP,10);
        totRec=intervalSet(0,max([Stop(WAKE);Stop(totSLEEP)]));
            
        % Calculating SleepStages
        disp('Calculating SleepStages...')
        SleepStage=[];
        for n=1:length(NameEpochs)
            eval(['epoch=',NameEpochs{n},';'])
            Epochs{man,n}=epoch;
            if n<6,SleepStage=[SleepStage; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];end
            DUR(man,n)=mean(Stop(epoch,'s')-Start(epoch,'s'));
            totDUR(man,n)=sum(Stop(epoch,'s')-Start(epoch,'s'));
            %         disp(sprintf([NameEpochs{n},' : average %1.1f min'],mean(Stop(epoch,'s')-Start(epoch,'s'))/60))
            %         if mean(Stop(epoch,'s')-Start(epoch,'s'))/60 >60, keyboard;end
            for ji=1:10*60/bstep
                I=and(epoch,intervalSet((ji-1)*bstep*60*1E4,ji*bstep*60*1E4));% 2min steps
                EvolSleep2(n,man,ji)=sum(Stop(I,'s')-Start(I,'s'));
            end
            A=Sleep;
            %A=A(min(find(A==5 & [A(2:end);0]~=5)):max(find(A~=5 & [A(2:end);0]==5)));
            %x=0:length(A)/100:length(A); y=hist(find(A==6-n),x);% wake 5, rem 4, N1 3, N2 2, N3 1.
            x=1:bstep*60/step:length(A); % 10min steps
            y=hist(find(A==6-n),x);% wake 5, rem 4, N1 3, N2 2, N3 1.
            EvolSleep(n,man,1:length(x))=y;
        end
        %keyboard
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
        MatStage{man}=SleepStage;
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
                if ij~=ii
                    id=find(MatS(:,1)==ii & MatS(:,2)==ij);
                    ijL3=find(MatS(id,4)>minPeriod(1) & MatS(id,5)>minPeriod(1));
                    ijL5=find(MatS(id,4)>minPeriod(2) & MatS(id,5)>minPeriod(2));
                    DuoLH=[DuoLH;[ii,ij,length(id),length(ijL3),length(ijL5),man]];
                    for ik=1:length(NamesStages)
                        if ij~=ik
                            ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                            ijkL3=find(MatS(ijk,4)>minPeriod(1) & MatS(ijk,5)>minPeriod(1) & MatS(ijk,6)>minPeriod(1));
                            ijkL5=find(MatS(ijk,4)>minPeriod(2) & MatS(ijk,5)>minPeriod(2) & MatS(ijk,6)>minPeriod(2));
                            TrioLH=[TrioLH;[ii,ij,ik,length(ijk),length(ijkL3),length(ijkL5),man]];
                            %disp([NamesStages{ii},'-',NamesStages{ij},'-',NamesStages{ik}])
                        end
                    end
                end
            end
            
        end
        disp('Done.')
        
    end
    %saving
    save([res,'/',analynameH],'TrioLH','DuoLH','DUR','totDUR','DurCylcle','MatEvol','SleepStage',...
        'EvolSleep','EvolSleep2','NamesStages','NameEpochs','pbind','MatStage','Epochs','TMerge','AgeAndSex');
end

        
%% Display All Info
SleepEff=[]; for man=1:size(totDUR,1), SleepEff(man)=100*totDUR(man,6)/totDUR(man,8);end
SleepEfficiency=SleepEff';
for n=1:length(NameEpochs), eval([NameEpochs{n},'=totDUR(:,n)/3600;']);end
SexeAndAge=AgeAndSex'; Subject=[1:length(SexeAndAge)]';
T = table(Subject,SexeAndAge,SleepEfficiency,totRec,totSLEEP,WAKE,REM,N1,N2,N3,NREM);
%writetable(T,'/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs/InfoDataDreams.xls')

%% plot indiv polysomno
clear sleepEff
if 1
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.8 0.8]); numF=gcf;
    % plot indiv PlotPolysomnoML
    for man=1:size(Epochs,1)
        clear N1 N2 N3 NREM REM WAKE 
        for n=1:length(NameEpochs)
            eval([NameEpochs{n},'=Epochs{man,n};']);
        end
        figure(numF),subplot(7,3,man),
        %figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 1 0.2]); numF=gcf;
        PlotPolysomno(N1,N2,N3,NREM,REM,WAKE,1,'h'); legend('Location','BestOutside')
        sleep=or(or(N1,N2),or(N3,REM)); sleep=mergeCloseIntervals(sleep,10);
        tot=or(sleep,WAKE);tot=mergeCloseIntervals(tot,10);
        sleepEff(man)=100*sum(Stop(sleep,'s')-Start(sleep,'s'))/sum(Stop(tot,'s')-Start(tot,'s'));
        title({sprintf('Subject #%d',man),[AgeAndSex{man},sprintf(', Eff = %d perc',round(sleepEff(man)))]}); legend off; if man<19,xlabel('');end
        %if savFig, saveFigure(numF.Number,sprintf('PolySomnoSubjects%d_mrg%ds',man,TMerge),[FolderFigure,'/IndivPolysomno']); end
    end
    
    if DoYD
        if savFig, saveFigure(numF.Number,sprintf('PolySomnoHumansYD_mrg%ds',TMerge),FolderFigure);end
    else
        if savFig, saveFigure(numF.Number,sprintf('PolySomnoHumans_mrg%ds',TMerge),FolderFigure);end
    end
    
end
%%
if 1 % plot zoom
    FolderSaveFig='/media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHumanYD/Hypnograms';
    % plot indiv PlotPolysomnoML
    a=0;
    for man=1:size(Epochs,1)
        clear N1 N2 N3 NREM REM WAKE
        for n=1:length(NameEpochs)
            eval([NameEpochs{n},'=Epochs{man,n};']);
        end
        a=a+1; if rem(a,5)==1, figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.5 0.9]); numF((a-1)/5+1)=gcf;end
        subplot(5,1,mod(a-1,5)+1),
        %figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 1 0.2]); numF=gcf;
        PlotPolysomno(N1,N2,N3,NREM,REM,WAKE,1,'h'); legend('Location','BestOutside')
        title({sprintf('Subject #%d',man),AgeAndSex{man}}); legend off; if man<19,xlabel('');end
        %if savFig, saveFigure(numF.Number,sprintf('PolySomnoSubjects%d_mrg%ds',man,TMerge),[FolderFigure,'/IndivPolysomno']); end
    end
    if savFig
        if DoYD==1
            for i=1:length(numF), saveFigure(numF(i).Number,sprintf('HypnogramYD_S%d',i),FolderSaveFig);end
        elseif DoYD==2
            for i=1:length(numF), saveFigure(numF(i).Number,sprintf('HypnogramYDnarco_S%d',i),FolderSaveFig);end
        else
            for i=1:length(numF), savFig, saveFigure(numF(i).Number,sprintf('Hypnogram_S%d',i),FolderSaveFig); end
        end
    end
end


%% duration substages %sleep
iStages=[3:5,2];
A=totDUR(:,iStages);
B1=totDUR(:,strcmp(NameEpochs,'totSLEEP')); Y1=100*A./(B1*ones(1,length(iStages)));
B2=totDUR(:,strcmp(NameEpochs,'NREM')); Y2=100*A./(B2*ones(1,length(iStages)));
B3=totDUR(:,strcmp(NameEpochs,'totRec')); Y3=100*A./(B3*ones(1,length(iStages)));

M=totDURmice(:,iStages);
M1=totDURmice(:,strcmp(NameEpochs,'totSLEEP')); Z1=100*M./(M1*ones(1,length(iStages)));
M2=totDURmice(:,strcmp(NameEpochs,'NREM')); Z2=100*M./(M2*ones(1,length(iStages)));
M3=totDURmice(:,strcmp(NameEpochs,'totRec')); Z3=100*M./(M3*ones(1,length(iStages)));

mice=unique(Dir.name);
X1=nan(length(mice), length(iStages)); X2=X1; X3=X1;
for mi=1:length(mice)
    X1(mi,:)=nanmean(Z1(find(strcmp(Dir.name,mice{mi})),:),1);
    X2(mi,:)=nanmean(Z2(find(strcmp(Dir.name,mice{mi})),:),1);
    X3(mi,:)=nanmean(Z3(find(strcmp(Dir.name,mice{mi})),:),1);
end

figure('Color',[1 1 1]); numF=gcf;
subplot(3,3,1), PlotErrorBarN(Y1,0,1); ylabel('%Sleep'); title(sprintf('HUMANS, N=%d',size(totDUR,1)))
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Y1,'ttest');
subplot(3,3,2), PlotErrorBarN(Y2,0,1); ylabel('%NREM')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Y2,'ttest');
subplot(3,3,3), PlotErrorBarN(Y3,0,1); ylabel('%totREC')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages));
addSigStarML(Y3,'ttest');

subplot(3,3,4), PlotErrorBarN(Z1,0,1); ylabel('%Sleep'); 
title(sprintf('MICE, n=%d, N=%d',size(Z1,1),length(mice)))
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Z1,'ttest');
subplot(3,3,5), PlotErrorBarN(Z2,0,1); ylabel('%NREM')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Z2,'ttest');
subplot(3,3,6), PlotErrorBarN(Z3,0,1); ylabel('%totREC')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages));
addSigStarML(Z3,'ttest'); title('paired ttest')

subplot(3,3,7), PlotErrorBarN(X1,0,1); ylabel('%Sleep'); 
title(sprintf('MICE, N=%d',length(mice)))
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Z1,'ttest');
subplot(3,3,8), PlotErrorBarN(X2,0,1); ylabel('%NREM')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages)); 
addSigStarML(Z2,'ttest');
subplot(3,3,9), PlotErrorBarN(X3,0,1); ylabel('%totREC')
set(gca,'Xtick',1:length(iStages)); set(gca,'XtickLabel',NameEpochs(iStages));
addSigStarML(Z3,'ttest'); title('paired ttest')

if DoYD
    if savFig, saveFigure(numF.Number,'SubstagesDur_MiceVsHumansYDBars',FolderFigure);end
else
    if savFig, saveFigure(numF.Number,'SubstagesDur_MiceVsHumansBars',FolderToSave);end
end



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< correlation inter/intra <<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.6 0.3]); numF=gcf;
mice=unique(Dir.name);
clear VARws
colo=[0.4 0 1; 1 0 1; 1 0 0;0 0 0];
for i=1:3
    subplot(1,3,i),
    if i==1, M=Z1; tit='Duration (%sleep)';end
    if i==2, M=Z2; tit='Duration (%NREM)';end
    if i==3, M=Z3; tit='Duration (%tot)';end
    MATvarInt=nan(length(mice)+3,length(iStages));
    Moy=nan(length(mice),length(iStages));
    for n=1:length(iStages)
        for mi=1:length(mice)
            id=find(strcmp(mice{mi},Dir.name));
            intra=M(id,n); intra(isnan(intra))=[];
            Moy(mi,n)=nanmean(intra); % 22 08 2018
            if length(intra)>2
                %MATvarInt(2+mi,n)=std(intra); % std intra mice
                MATvarInt(3+mi,n)=std(intra)/mean(intra); % variability, 22 08 2018
                %hold on,plot(inter,std(intra),'ko','MarkerFaceColor',colo(n,:))
            end
            if i==1, VARws(n,mi)=var(intra);end
        end
       hold on,plot(10,10,'ko','MarkerFaceColor',colo(n,:))
        %inter=std(M(isnan(M(:,n))==0,n)); % std all mice
        %inter=std(Moy(:,n)); % std all mice, 22 08 2018
        inter=std(Moy(:,n))/mean(Moy(:,n)); % variability, 22 08 2018
        MATvarInt(1,n)=inter;
        MATvarInt(2,n)=nanmean(MATvarInt(2+[1:length(mice)],n));
        MATvarInt(3,n)=nanstd(MATvarInt(2+[1:length(mice)],n));
        %text(inter,10+0.3*n,nameEpochs{n},'Color',colo(n,:))
    end
     for n=1:length(iStages)
        for mi=1:length(mice)
            hold on,plot(MATvarInt(1,n),MATvarInt(3+mi,n),'ko','MarkerFaceColor',colo(n,:))
        end
     end
        
   % line([0 12],[0,12],'Color',[0.5 0.5 0.5]);xlim([0 13]); ylim([0 13]);
    line([0 1],[0,1],'Color',[0.5 0.5 0.5]);xlim([0 1]); ylim([0 1]);
    title({tit,sprintf(['n=%d,N=%d'],length(M),length(mice))})
    xlabel('intervar');ylabel('intravar')
    if 1 % save in table
        for n=1:length(iStages)
            eval([NameEpochs{iStages(n)},'_duration=MATvarInt(:,n);'])
        end
        MATvarIntNames={};MATvarIntNames{1,1}=['intervar ',tit]; 
        MATvarIntNames{2,1}='intravar (averaged)';MATvarIntNames{3,1}='intravar (std)';
        MATvarIntNames=[MATvarIntNames;mice'];
        T = table(MATvarIntNames,REM_duration,N1_duration,N2_duration,N3_duration);
        writetable(T,'/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs/IntraInterVar.xls','Sheet',i)
    end
    
end
    legend(NameEpochs(iStages))

%if savFig, saveFigure(numF.Number,'NREMStagesInterIntraVar',FolderToSave);end




%% Intraclass correlation coefficients (ICCs) 
%ICC=(VARbs)/ (VARbs + VARws) bs/ws=between/within subjects, Gander et al

disp(['Stages order : ',NameEpochs(iStages)])
% Humans
disp('Humans mean %NREM :')
disp(nanmean(Y2))
% mice 
disp('mice (all sessions) mean %NREM :')
disp(nanmean(Z2))
% mice (pooled sessions)
disp('mice (pooled sessions) mean %NREM :')
disp(nanmean(X2))
% ICC
disp(' '); disp('Intraclass correlation coefficients (%sleep)')
for n=1:4,
    VARbs=var(X1(:,n));
    ICC=VARbs/(VARbs+nanmean(VARws(n,:)));
    disp(sprintf([NameEpochs{iStages(n)},' ICC : %1.2f'],ICC))
end

%% intra var, all data
figure('Color',[1 1 1])
for i=1:3
    if i==1, M=Z1; tit='Duration (%sleep)';end
    if i==2, M=Z2; tit='Duration (%NREM)';end
    if i==3, M=Z3; tit='Duration (%tot)';end
    for n=1:4
        Mmm=nan(length(mice),10);
        Mxtrm=nan(length(mice),2);
        subplot(3,4,4*(i-1)+n), hold on,
        for mi=1:length(mice)
            id=find(strcmp(mice{mi},Dir.name));
            Mmm(mi,1:length(id))=M(id,n);
            Mxtrm(mi,1:2)=[min(M(id,n)),max(M(id,n))];
        end
        [y,ord]=sort(nanmean(Mmm,2));
        plot(1:length(mice),Mmm(ord,:),'ko','MarkerFaceColor',colo(n,:))
        ylim([0 90]); xlim([0 26])
        for mi=1:length(mice)
            line([mi,mi],Mxtrm(ord(mi),:),'Color',[0.5,0.5,0.5]);
        end
        if n==1, ylabel(tit);end
        if i==1 & n==3, title(sprintf(['n=%d,N=%d'],length(M),length(mice)));end
        xlabel('#mouse');
    end    
end

%if savFig, saveFigure(numF.Number,'NREMStagesIntraVarCrescendo',FolderToSave);end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< Cycle duration <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
MAT=[];
for man=1:size(DurCylcle,2)
    MAT=[MAT;DurCylcle{man}];
end
figure('Color',[1 1 1],'Unit','normalized','Position',[0.3 0.5 0.5 0.35]), numF=gcf;
subplot(2,2,1),hist(MAT/3600,30); colormap gray
title({'HUMANS Cycle duration distribution',sprintf('(mean =%1.1fh +/-%1.1f)',mean(MAT)/3600,stdError(MAT/3600)),...
   sprintf('(median =%1.1fh)',median(MAT)/3600) })
hold on, line(mean(MAT/3600)+[0 0],ylim,'Color','r');
hold on, line(median(MAT/3600)+[0 0],ylim,'Color','m');
ylabel('nb of cycles, n=20 subjects'); xlabel('Time (hr)')

subplot(2,2,2),hist(MAT(MAT>15*60)/3600,30);
line(mean(MAT(MAT>15*60)/3600)+[0 0],ylim,'Color','r')
hold on, line(median(MAT(MAT>15*60)/3600)+[0 0],ylim,'Color','m');
title({'HUMANS Cycle duration distribution',sprintf('(mean episod >15min =%1.1fh +/-%1.1f)',mean(MAT(MAT>15*60)/3600),stdError(MAT(MAT>15*60)/3600)),...
   sprintf('(median episod >15min =%1.1fh)',median(MAT)/3600) })
ylabel('nb of cycles, n=20 subjects'); xlabel('Time (hr)')

%mice
DiffCycle=[];
MiceCycle=[];
for man=1:length(Dir.path)
    REM=MiceEpochs{man,find(strcmp(NameEpochs,'REM'))};
    EndREM=[Start(REM),Stop(REM)];
    DiffCycle=[DiffCycle;EndREM(2:end,1)-EndREM(1:end-1,1)];
    REM=mergeCloseIntervals(REM,60*1E4);
    REM=dropShortIntervals(REM,10*1E4); % before = 10s
    EndREM=Stop(REM);
    %CycleI=EndREM;
    CycleI=[EndREM(1:end-1),EndREM(2:end)];
    
    WAKE=MiceEpochs{man,find(strcmp(NameEpochs,'WAKE'))};
    % remove long WAKE periods
    for r=1:length(Stop(REM))-1
        cycle=intervalSet(EndREM(r),EndREM(r+1));
        W=and(WAKE,cycle);
        Le=[Stop(W,'s')-Start(W,'s'),Stop(W)];
        ind=find(Le(:,1)>10*60); % longer than 10min
        if ~isempty(ind)
            %CycleI(r)=Le(max(ind),2);
            CycleI(r,2)=Le(max(ind),2);
        end
    end
    %DurCycleMice=CycleI(2:end)-CycleI(1:end-1);
    DurCycleMice=diff(CycleI')';
    MiceCycle=[MiceCycle;DurCycleMice/1E4];
end

subplot(2,2,3),hist(MiceCycle/60,1:0.75:50); colormap gray
title({'MICE Cycle duration distribution',...
    sprintf('(mean =%1.1fmin +/-%1.1f)',mean(MiceCycle/60),stdError(MiceCycle/60)),...
   sprintf('(median =%1.1fmin)',median(MiceCycle/60)) })
hold on, line(mean(MiceCycle/60)+[0 0],ylim,'Color','r');
hold on, line(median(MiceCycle/60)+[0 0],ylim,'Color','m');
ylabel(sprintf('nb of cycles, n=%d expe',length(Dir.path))); 
xlabel('Time (min)'); xlim([0 48])

M=MiceCycle(MiceCycle>3*60);
subplot(2,2,4),hist(M/60,1:0.5:50);
line(nanmean(M/60)+[0 0],ylim,'Color','r')
hold on, line(median(M/60)+[0 0],ylim,'Color','m');
title({'MICE Cycle duration distribution',...
    sprintf('(mean episod >3min =%1.1fmin +/-%1.1f)',mean(M/60),stdError(M/60)),...
   sprintf('(median episod >3min =%1.1fmin)',median(M)/60) })
ylabel(sprintf('nb of cycles, n=%d expe',length(Dir.path))); 
xlabel('Time (min)'); xlim([0 48])

if DoYD
    if savFig, saveFigure(numF.Number,sprintf('CycleDurationYD_mrg%ds',TMerge),FolderFigure);end
else
    if savFig, saveFigure(numF.Number,sprintf('CycleDuration_mrg%ds',TMerge),FolderFigure);end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< DISPLAY compared transitions frequency <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

doall=0;
trioOnly=0;% no back and forth
lim=15; % in %of transition

DoRestrict=0; % 0 for raw, 1 or 2

for i=1:2
    if i==1% humans
        savT=TrioLH;
        legn=sprintf('trio of transition, n=%d subjects',size(DurCylcle,2));
    else% mice
        savT=TrioL;
        legn=sprintf('trio of transition, n=%d expe, N=%d animals',length(Dir.path),length(unique(Dir.name)));
    end
    if trioOnly,
        savT(find(savT(:,1)-savT(:,3)==0),:)=[];
        tit='noBF';
    else
        tit='';
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
%
figure('Color',[1 1 1],'Unit','normalized','Position',[0.3 0.5 0.4 0.8]), numF=gcf;
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
legend(nameorder,'Location','Best');colormap copper
% save FIgure
if DoYD
    if savFig, saveFigure(numF.Number,sprintf(['CountTrioTransitionYD',tit,'_mrg%ds'],TMerge),FolderFigure);end
else
    if savFig, saveFigure(numF.Number,sprintf(['CountTrioTransition',tit,'_mrg%ds'],TMerge),FolderFigure);end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< CORRELATION TRANSITION PROBA <<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

iTrioBF=find(U(:,1)-U(:,3)==0);
iTrio=find(U(:,1)-U(:,3)~=0);

x=log10(MnM);
y=log10(MnH);

figure('Color',[1 1 1]), numF=gcf; hold on,
plot(x(iTrio),y(iTrio),'.k','Markersize',15)
plot(x(iTrioBF),y(iTrioBF),'.k','Markersize',15)

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
if DoYD
    if savFig, saveFigure(numF.Number,sprintf('CountTrio-corrHumanYDMice_mrg%ds',TMerge),FolderFigure);end
else
    if savFig, saveFigure(numF.Number,sprintf('CountTrio-corrHumanMice_mrg%ds',TMerge),FolderFigure);end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< DURATION HUMAN and MICE EPISODS <<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ind=[1,2,6,3,4,5];
DUR2=DUR(:,[1:5,7]);
DUR2(17,:)=[];
tempName=[NamesStages,'NREM'];

figure('Color',[1 1 1],'Unit','normalized','Position',[0.3 0.3 0.6 0.7]), numF=gcf;
subplot(2,4,1:2), hold on,
plotSpread(DUR2(:,ind)/60,'distributionColors','k'); 
for i=1:length(ind), line(i+[-0.2 0.2],nanmean(DUR2(:,ind(i))/60)+[0 0],'Color','k','Linewidth',2);end
set(gca,'Xtick',1:length(tempName));set(gca,'XtickLabel',tempName(ind))
title('HUMANS');ylabel('mean episod duration (min)');  xlim([0 7]);%ylim([0 20])

subplot(2,4,5:6), bar(nanmean(DUR2(:,ind)/60)); colormap gray
hold on, errorbar(1:length(tempName),nanmean(DUR2(:,ind)/60),stdError(DUR2(:,ind)/60),'+k')
set(gca,'Xtick',1:length(tempName));set(gca,'XtickLabel',tempName(ind))
title('HUMANS');ylabel('mean episod duration (min)');  xlim([0 7]);%ylim([0 20])

DUR3=DURmice(:,[1:5,7]);
subplot(2,4,3), plotSpread(DUR3(:,ind(1:3))/60,'distributionColors','k');
for i=1:3, line(i+[-0.2 0.2],nanmean(DUR3(:,ind(i))/60)+[0 0],'Color','k','Linewidth',2);end
set(gca,'Xtick',1:3);set(gca,'XtickLabel',tempName(ind(1:3)))
title('MICE'); ylabel('mean episod duration (min)'); xlim([0.5 3.5]); %ylim([0 20])

subplot(2,4,7), bar(nanmean(DUR3(:,ind(1:3))/60)); colormap gray
hold on, errorbar(1:3,nanmean(DUR3(:,ind(1:3))/60),stdError(DUR3(:,ind(1:3))/60),'+k')
set(gca,'Xtick',1:3);set(gca,'XtickLabel',tempName(ind(1:3)))
title('MICE'); ylabel('mean episod duration (min)'); xlim([0.5 3.5]); %ylim([0 20])

subplot(2,4,4), plotSpread(DUR3(:,ind(4:6)),'distributionColors','k');
for i=1:3, line(i+[-0.2 0.2],nanmean(DUR3(:,ind(3+i)))+[0 0],'Color','k','Linewidth',2);end
set(gca,'Xtick',1:3);set(gca,'XtickLabel',tempName(ind(4:6)))
title('MICE'); ylabel('mean episod duration (sec)'); xlim([0.5 3.5]); %ylim([0 20])

subplot(2,4,8), bar(nanmean(DUR3(:,ind(4:6)))); colormap gray
hold on, errorbar(1:3,nanmean(DUR3(:,ind(4:6))),stdError(DUR3(:,ind(4:6))),'+k')
set(gca,'Xtick',1:3);set(gca,'XtickLabel',tempName(ind(4:6)))
title('MICE'); ylabel('mean episod duration (min)'); xlim([0.5 3.5]); %ylim([0 20])

% save Figure
if DoYD
    if savFig, saveFigure(numF.Number,sprintf('DurStagesEpisodes-HumanYDMice_Hmrg%ds',TMerge),FolderFigure);end
else
    if savFig, saveFigure(numF.Number,sprintf('DurStagesEpisodes-HumanMice_Hmrg%ds',TMerge),FolderFigure);end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< CORRELATION DURATION TOTAL STAGES <<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
colo=[0.3 0 0.8 ;1 0.6 0.8;0.8 0 0.8; 0 0 0;0.5 0.2 0.1];
DUR2=totDUR/3600;
DUR2(17,:)=[];
y=DUR2(:,2);

ind=[3:5,7,1];
% pool mice 
mice=unique(Dir.name);

for n=1:length(ind)
    Xm(:,n)=100*totDURmice(:,ind(n))./totDURmice(:,8);
    Ym(:,n)=100*totDURmice(:,2)./totDURmice(:,8);
end
for n=1:length(ind)
    for mi=1:length(mice)
        Xmi(mi,n)=nanmean(Xm(find(strcmp(Dir.name,mice{mi})),n));
        Ymi(mi,n)=nanmean(Ym(find(strcmp(Dir.name,mice{mi})),n));
    end
end

for do=1:2
    if do==1
        Axm=Xm; Aym=Ym;
    else
        Axm=Xmi; Aym=Ymi;
    end
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.4 0.8 0.6]), numF=gcf;    
    for n=1:length(ind)
        x=DUR2(:,ind(n));
        subplot(2,5,n),plot(x,y,'.k','MarkerSize',14)
        xlabel([NameEpochs{ind(n)},' total duration (h)']);
        if n==1, ylabel({'HUMANS','REM total duration (h)'});end
        p= polyfit(x,y,1);
        [r,pval]=corrcoef(x,y);
        hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
        title(sprintf([NameEpochs{ind(n)},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colo(n,:));
        xlim([0.9*min(x),max(x)*1.1]); ylim([0.9*min(y),max(y)*1.1]);
        
        xm=Axm(:,n);
        ym=Aym(:,n);
        id=find(~isnan(xm) & ~isnan(ym));
        xm=xm(id); ym=ym(id);
        subplot(2,5,5+n),plot(xm,ym,'.k','MarkerSize',14)
        xlabel([NameEpochs{ind(n)},' total duration (%tot)']);
        if n==1, ylabel({'MICE','REM total duration (%tot)'});end
        p= polyfit(xm,ym,1);
        [r,pval]=corrcoef(xm,ym);
        hold on, line([min(xm),max(xm)],p(2)+[min(xm),max(xm)]*p(1),'Color','k','Linewidth',2)
        title({[NameEpochs{ind(n)},sprintf(' n=%d',length(xm))],sprintf(' r=%0.1f, p=%0.3f',r(1,2),pval(1,2))},'Color',colo(n,:));
        xlim([0.9*min(xm),max(xm)*1.1]); ylim([0.9*min(ym),max(ym)*1.1]);
        
    end
    if savFig, saveFigure(numF.Number,sprintf('CorrelationSubstagesDurationHumans%d_mrg%ds',do,TMerge),FolderFigure);end
end

% prediction model mice
Xw=100*totDURmice(:,1)./totDURmice(:,8);
Yrem=100*totDURmice(:,2)./totDURmice(:,8);
Xn1=100*totDURmice(:,3)./totDURmice(:,8);
Xn2=100*totDURmice(:,4)./totDURmice(:,8);
Xn3=100*totDURmice(:,5)./totDURmice(:,8);
Xnrem=100*totDURmice(:,7)./totDURmice(:,8);

mdl = stepwiselm([Xn1,Xn2,Xn3],Yrem,'linear');% mice
mdl = stepwiselm([Xnrem,Xn2],Yrem,'linear');% mice

%% prediction model humans
yREM=DUR2(:,2);
xN1=DUR2(:,3);
xN2=DUR2(:,4);
xN3=DUR2(:,5);
xNREM=DUR2(:,7);

mdl = stepwiselm([xN1,xN2,xN3],yREM,'linear');% 
mdl = stepwiselm([xNREM,xN2],yREM,'linear');% 
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< first vs other, REM and NREM CORRELATION <<<<<<<<<<<<<<<<
DurFirst=nan(20,5);
DurOthPre=[];
DurOthPost=[];
for man=1:20
    St=MatStage{man};
    indR=find(St(:,3)==2);
    
    %merge REM if only one stage in between
    while ~isempty(find(diff(indR)==2))
        PB=min(find(diff(indR)==2));
        St(indR(PB),2)=St(indR(PB+1),2);
        St(indR(PB),4)=St(indR(PB),4)+St(indR(PB+1),4);
        St(indR(PB)+[1:2],:)=[];
        indR=find(St(:,3)==2);
    end
    
    % first cycle
    indNfirst=find(ismember(St(:,3),3:5) & St(:,1)<St(indR(1),1));
    DurFirst(man,1)=St(indR(1),4);% first REM
    DurFirst(man,2)=sum(St(indNfirst,4));% first NREM
    for j=3:5
        indNfirst=find(St(:,3)==j & St(:,1)<St(indR(1),1));
        DurFirst(man,j)=sum(St(indNfirst,4));
    end
    
    % other cycles
    indR=[1;indR;size(St,1)];
    for i=2:length(indR)-1
        indNpre=find(ismember(St(:,3),3:5) & St(:,1)>St(indR(i-1),1) & St(:,1)<St(indR(i),1) );
        indNpost=find(ismember(St(:,3),3:5) & St(:,1)>St(indR(i),1) & St(:,1)<St(indR(i+1),1) );
        tempPre=[man,St(indR(i),4),sum(St(indNpre,4))]; 
        tempPost=[man,St(indR(i),4),sum(St(indNpost,4))];
        for j=3:5
            iNpre=find(St(:,3)==j & St(:,1)>St(indR(i-1),1) & St(:,1)<St(indR(i),1) );
            iNpost=find(St(:,3)==j & St(:,1)>St(indR(i),1) & St(:,1)<St(indR(i+1),1) );
            
           tempPre=[tempPre,sum(St(iNpre,4))]; 
           tempPost=[tempPost,sum(St(iNpost,4))]; 
            
        end
        DurOthPre=[DurOthPre;tempPre];
        DurOthPost=[DurOthPost;tempPost];
    end
end

colo=[0 0 0; 0.3 0 0.8 ;1 0.6 0.8;0.8 0 0.8];
leg={'NREM','N1','N2','N3'};
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.4 0.8 0.8]); numF=gcf;
for j=2:5
    y=DurFirst(:,1)/60; x=DurFirst(:,j)/60;
    subplot(3,4,j-1), plot(x,y,'.k','MarkerSize',14);
    p= polyfit(x,y,1); [r,pval]=corrcoef(x,y);
    hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
    title({'First cycle ',sprintf([leg{j-1},' pre : r=%0.1f, p=%0.3f'],r(1,2),pval(1,2))},'Color',colo(j-1,:));
    if j==2, ylabel({'First cycle','Duration REM (min)'});end 
    
    y=DurOthPre(:,2)/60;x=DurOthPre(:,j+1)/60;
    subplot(3,4,j+3), plot(x,y,'.k','MarkerSize',14);
    p= polyfit(x,y,1); [r,pval]=corrcoef(x,y);
    hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
    title({'From 2nd cycle ',sprintf([leg{j-1},' pre : r=%0.1f, p=%0.3f'],r(1,2),pval(1,2))},'Color',colo(j-1,:));
    if j==2, ylabel({'From 2nd cycle ','Duration REM (min)'});end 
    
    y=DurOthPost(:,2)/60;x=DurOthPost(:,j+1)/60;
    subplot(3,4,j+7), plot(x,y,'.k','MarkerSize',14);
    p= polyfit(x,y,1); [r,pval]=corrcoef(x,y);
    hold on, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
    title({'From 2nd cycle ',sprintf([leg{j-1},' post : r=%0.1f, p=%0.3f'],r(1,2),pval(1,2))},'Color',colo(j-1,:));
    if j==2, ylabel({'From 2nd cycle ','Duration REM (min)'});end 
    xlabel('Duration (min)');
end
if savFig, saveFigure(numF.Number,sprintf('CorrelationToREMdurationHumans_mrg%ds',TMerge),FolderFigure);end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< DURATION OVER NIGHT <<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

colori=[1 1 1;0 0 0 ;0.6 0 0.8 ;0.8 0 0.6 ;1 0 0];
%ComputeSleepCycle.m
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.4 0.8 0.6]), numF=gcf;
% figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.4 0.5 0.6]), numG=gcf;

%leg='%sleep';
leg='%tot';

dozscore=0; % 1 to zscore, 0 otherwise
titzsc='';if dozscore, titzsc='zscore';end

for i=1:2
    %y=squeeze(EvolSleep(n,:,1:50))/120;
    if i==1
        Evol=EvolSleep2;tit=sprintf('HUMANS(n=%d)',size(Evol,2));
        %Evol=EvolSleep;
    else
        Evol=Evolmice;tit=sprintf('MICE (n=%d)',size(Evol,2));
    end
    for n=1:length(NamesStages)
        figure(numF),subplot(2,5,(i-1)*5+n), hold on,
        yn=squeeze(Evol(n,:,:));
        if strcmp(leg,'%sleep')
            ys=squeeze(Evol(6,:,:));
        else
            ys=squeeze(Evol(8,:,:));
        end
        y=nan(size(yn));
        id=find(~isnan(ys)& ys~=0);
        y(id)=100*yn(id)./ys(id);
        if dozscore
           for mi=1:size(y,1)
               idmi=find(~isnan(y(mi,:))); 
               y(mi,idmi)=zscore(y(mi,idmi));
           end
        end
        
        x=[1:size(y,2)]*bstep/60;
        for cc=1:size(y,2), stdy(cc)=stdError(y(~isnan(y(:,cc)),cc));end
        if 0
            plot(x,nanmean(y),'Color',colori(n,:),'Linewidth',2)
            plot(x,nanmean(y)+stdy,'Color',colori(n,:))
            plot(x,nanmean(y)-stdy,'Color',colori(n,:))
        else
            errorbar(x,nanmean(y),stdy,'o-k','MarkerFaceColor',colori(n,:),'MarkerSize',5)
        end
        
        % linear regression
        ymean=nanmean(y);
        id=find(~isnan(x) & ~isnan(ymean));
        plin= polyfit(x(id),ymean(id),1);[r,pvalin]=corrcoef(x(id),ymean(id));
        hold on, line([min(x),max(x)],plin(2)+[min(x),max(x)]*plin(1),'Color','k')
        % one-way anova
        [pval,tb] = anova1(y,x,'off');
        % friedman
        % [pval,tb] = friedman(y);
        title({sprintf([NamesStages{n},' r=%0.1f, p=%0.3f'],r(1,2),pvalin(1,2)),...
            sprintf('Anova: F=%0.1f, p=%0.3f',tb{2,5},pval)});
        
        xlim([0 8]); set(gca,'Xtick',1:8);if i==2, xlim([0 10]);set(gca,'Xtick',1:10);end
        ylim([0 100]); if dozscore, ylim([-2 2]);end
        if n==1, ylabel({tit,'Substages duration'}); else, ylabel([titzsc,' duration (',leg,')']);end
        xlabel('Time (h)'); if OnsetSleep, xlabel('Time from sleep onset (h)');end
        
%         figure(numG),subplot(2,1,i), hold on,
%         plot(x,nanmean(y)/nansum(nanmean(y)),'Color',colori(n,:),'Linewidth',2)
%         if n==1, xlabel('Time (h)');title('Evolution across night');end
        
    end
end
if DoYD
    if savFig, saveFigure(numF.Number,sprintf(['EvolDurSubstages',leg(2:end),'_HumansYDAndMice_Onset%d_mrg%ds_zsc%d'],OnsetSleep,TMerge,dozscore),FolderFigure);end
else
    if savFig, saveFigure(numF.Number,sprintf(['EvolDurSubstages',leg(2:end),'_HumansAndMice_Onset%d_mrg%ds_zsc%d'],OnsetSleep,TMerge,dozscore),FolderFigure);end
end
% see AnalyseNREMsubstagesML.m for mice

%% <<<<<<<<<<<<<<<<<<<<<<<< Transition diagram <<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
totDUR;
tit={'Mouse','humans'};
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.4 0.4 0.3]); numF=gcf;
colorci=[0.5 0.5 0.5; 0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0];
    clear ValTrans    
for i=1:2
    subplot(1,2,i),
    clear A B C
    if i==1
        Duo=DuoL;fac=30;
        for n=1:5
            A(n)=100*nanmean(totDURmice(:,n)./totDURmice(:,8));
        end
    else
        Duo=DuoLH;fac=3;
        A=nanmean(totDUR(:,1:5))/1000;
    end
    % ---------------- average by subjects
    Nsubject=length(unique(Duo(:,6))); % added 2018.09.03
    C=zeros(5,5);clear totTrans
    totTrans=nan(Nsubject,1);
    for man=1:Nsubject
        if i==2, totTrans(man) = sum(Duo(find(Duo(:,6)==man),3));
        else,totTrans(man) = sum(Duo(find(Duo(:,6)==man),4));
        end
    end
    for ni=1:5
        for nj=1:5
            id=find(Duo(:,1)==ni & Duo(:,2)==nj);
            if i==2
                try C(ni,nj)=C(ni,nj)+100*nanmean(Duo(id,3)./totTrans); end
            else
                try C(ni,nj)=C(ni,nj)+100*nanmean(Duo(id,4)./totTrans); end % remove short epidoes
            end
        end
    end
    
    % ----------------
    for ni=1:5
        for nj=1:5
            id=find(Duo(:,1)==ni & Duo(:,2)==nj);
            if i==2
                try B(ni,nj)=nanmean(Duo(id,3)); end
            else
                try B(ni,nj)=nanmean(Duo(id,4)); end % remove short epidoes
            end
        end
    end

    %DuoL=[DuoL;[ii,ij,length(id),length(ijL3),length(ijL5),man]];
    
    %Val=B;
    Val=C;% use from 2018.09.03
    
    %Pos=[0 max(A)+A(1);-(max(A)+A(2)) 0 ; -2*max(A) 2*max(A); 0 -(max(A)+A(4)); max(A)+A(5) 0];
    Pos=[-(max(A)+A(2)) 0 ;0 -(max(A)+A(4));0 max(A)+A(1);  max(A)+A(5) 0; 2*max(A) 2*max(A)];
    ValTrans{1,7*(i-1)+1}=tit{i};
    ValTrans(1,7*(i-1)+[2:6])=NameEpochs(1:5);
    ValTrans([2:6],7*(i-1)+1)=NameEpochs(1:5)';
    for ni=1:5
        circli = rsmak('circle',A(ni),Pos(ni,:));
        hold on, plot(Pos(ni,1),Pos(ni,2),'+','Color',colorci(ni,:))
        hold on, fnplt(circli,'Color','k');%colorci(ni,:))
        text(Pos(ni,1)+A(ni)/3,Pos(ni,2),NameEpochs(ni),'Color',colorci(ni,:))
        for nj=[1:ni-1,ni+1:5]
            try line(Pos([ni,nj],1),Pos([ni,nj],2)+(ni-3),'linewidth',Val(ni,nj)/fac,'Color',colorci(ni,:));end
            %arrow(Pos(ni,1:2)+[0 ni-3],Pos(nj,1:2)+[0 ni-3],B(ni,nj)/fac);%,'Color',colorci(ni,:));
            %Arrow2d(Pos(ni,1:2)+[0 ni-3],Pos(nj,1:2)+[0 ni-3],'Width',B(ni,nj)/fac)
            ValTrans{1+ni,7*(i-1)+1+nj}=Val(ni,nj);
        end
    end
    title(tit{i}); xl=xlim; yl=ylim; axis off
    xlim([min([xl yl]) max([xl yl])]);ylim([min([xl yl]) max([xl yl])]);
end
writetable(table(ValTrans),'/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs/TransitionRepartition.xls');
if savFig, saveFigure(numF.Number,'DiagramTransitionHumansMice',FolderFigure);end

  %%
    % to help construction of the transition diagram
    B=MAT1.*[A'*ones(1,5)];
    subplot(2,2,2+f),bar(B/((f-1)*2E3+500)), 
    colormap pink; ylabel('Goes into...')
    if f==1, title('Transition proportion depending on stage duration');else,title('Transition repartition depending on episod number'), end
    set(gca,'Xtick',1:L); set(gca,'XtickLabel',nameEpochs(1:L))
    legend(nameEpochs(1:L));xlabel('Current stage')
    
    
%% check samples human data
cd /media/DataMOBsRAIDN/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman
load DatabaseSubjects.mat

SleepCylcesHuman=SleepCylcesHumanAASM;
ind=[];
for man=1:length(SleepCylcesHuman)
    Sleep=SleepCylcesHuman{man};
    SleepDif=diff(Sleep);
    ind=[ind;diff([1;find(SleepDif~=0)])*5];
end
figure,subplot(211),hist(diff([1;find(SleepDif~=0)])*5,5:5:210); xlim([0 200])
title('SleepCylcesHumanAASM')

SleepCylcesHuman=SleepCylcesHumanRK;
ind=[];
for man=1:length(SleepCylcesHuman)
    Sleep=SleepCylcesHuman{man};
    SleepDif=diff(Sleep);
    ind=[ind;diff([1;find(SleepDif~=0)])*5];
end
figure,subplot(211),hist(diff([1;find(SleepDif~=0)])*5,5:5:210); xlim([0 200])
title('SleepCylcesHumanRK')



