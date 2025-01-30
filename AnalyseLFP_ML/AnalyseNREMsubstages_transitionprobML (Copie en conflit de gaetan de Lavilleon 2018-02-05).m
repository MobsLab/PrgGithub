%AnalyseNREMsubstages_transitionprobML.m



% need output from AnalyseNREMsubstagesML.m
% see also:
% CaracteristicsSubstagesML.m
% FindSleepStageML.m

%% INITIATION AND OPTIONS
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/FIguresPosterSFN2015';
FolderToSave='/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/FigureNovembre2015/';

optionPlotIndiv=0;
optionSave=0;


% <<<<<<<<<<<<<<<<<<< SUBSTAGES FOR ONE MOUSE <<<<<<<<<<<<<<<<<<<<<<<<<<<<
% RunSubstages

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< LOAD AnalySubStagesML.mat <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/AnalySubStagesML.mat'])
    Dir;
    disp('AnalySubStagesML.mat already exists... loading...')
    
catch
    disp('AnalySubStagesML.mat does not exist... Running AnalyseNREMsubstagesML.m !')
    AnalyseNREMsubstagesML;
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Define substages <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp('running DefineSubStages.m'); MATEP={};
for man=1:length(Dir.path)
    [temp,nameEpochs]=DefineSubStages(MATepochs(man,:));
    MATEP(man,1:length(temp))=temp;
end
disp('Done');
%MATepochs={OsciSup,OsciDeep,N3,REM,WAKE,SWS,SlowPF,SlowOB};
%nameEpochs={'N1','N2','N3','REM','WAKE','SWS','swaPF','swaOB','TOTSleep'};
%MATEP(man,:)={N1,N2,N3,REM,WAKE,SWS,PFswa,OBswa,TOTSleep};

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Define substages <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

L=5;
ntrans=nan(length(Dir.path),L,L);
nretro=nan(length(Dir.path),L,L);
N=nan(length(Dir.path),L);

for man=1:length(Dir.path)
    % epochs
    op=MATEP(man,:);
    disp(' '); disp(Dir.path{man})
    % -------------------------------
    if optionPlotIndiv
        cd(Dir.path{man})
        RunSubstages;
        clear op NamesOp Dpfc Epoch EP NamesEP N1 N3 SWS REM WAKE SleepStages Epochs NamesStages a Sta ep ind
        title(Dir.path{man})
    end
    % -------------------------------
    
    Sta=[];
    for ep=1:L
        if ~isempty(op{ep})
            Sta=[Sta ; [Start(op{ep},'s'),zeros(length(Start(op{ep})),1)+ep] ];
        end
    end
    if ~isempty(Sta)
        Sta=sortrows(Sta,1);
        ind=find(diff(Sta(:,2))==0);
        Sta(ind+1,:)=[];
        
        % check REM -> WAKE transition
        a=find([Sta(:,2);0]==4 & [0;Sta(:,2)]==5 );
        ep='';if ~isempty(a),ep=[ep,' Warning! t=[',sprintf(' %g',floor(Sta(a,1))),' ]s'];end
        disp([sprintf('%d transitions WAKE -> REM ',length(a)),ep]);
        
        for i=1:L
            % total number in i
            N(man,i)=length(find(Sta(:,2)==i));
            for j=1:L
                % from i to j
                ntrans(man,i,j)=length(find([0;Sta(:,2)]==i & [Sta(:,2);0]==j));
                % to i from j
                nretro(man,i,j)=length(find([0;Sta(:,2)]==j & [Sta(:,2);0]==i));
            end
        end
        
    end
end

%% PlotErrorBarN
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.5 0.5 0.4]);
for ep=1:L
    subplot(2,L,ep)
    PlotErrorBarN(squeeze(ntrans(:,ep,:))./[N(:,ep)*ones(1,L)],0,0);
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ',nameEpochs{ep},' to...'])
    ylabel('fraction');
    
    subplot(2,L,L+ep)
    PlotErrorBarN(squeeze(nretro(:,ep,:))./[N(:,ep)*ones(1,L)],0,0);
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ... to ',nameEpochs{ep}])
    ylabel('fraction');
end
if optionSave, saveFigure(gcf,['SleepStages_transition_All1_',date],FolderToSave);end

%% errorbar
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.4]);
for ep=1:L
    subplot(2,L,ep), hold on,
    temp=squeeze(ntrans(:,ep,:))./[N(:,ep)*ones(1,L)];
    A=nanmean(temp,1);
    bar(1:L,A);
    errorbar(1:L,A,nanstd(temp)/sqrt(sum(~isnan((nanmean(temp,2))))),'+');
    for i=1:L
        text(i-0.1,A(i)+0.03,sprintf('%0.2f',A(i)));
    end
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ',nameEpochs{ep},' to...'])
    ylabel('fraction');
    
    subplot(2,L,L+ep), hold on,
    temp=squeeze(nretro(:,ep,:))./[N(:,ep)*ones(1,L)];
    A=nanmean(temp,1);
    bar(1:L,A);
    errorbar(1:L,A,nanstd(temp)/sqrt(sum(~isnan((nanmean(temp,2))))),'+');
    for i=1:L
        text(i-0.1,A(i)+0.03,sprintf('%0.2f',A(i)));
    end
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ... to ',nameEpochs{ep}])
    ylabel('fraction');
    
end

if optionSave, saveFigure(gcf,['SleepStages_transition_All2_',date],FolderToSave);end


%% pool mice

mice=unique(Dir.name);
nT=nan(length(mice),L,L);
nRT=nan(length(mice),L,L);
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    for ep=1:L
        subplot(2,L,ep), hold on,
        try
            nT(mi,ep,:)=mean(squeeze(ntrans(ind,ep,:))./[N(ind,ep)*ones(1,L)],1);
            nRT(mi,ep,:)=mean(squeeze(nretro(ind,ep,:))./[N(ind,ep)*ones(1,L)],1);
        catch
            nT(mi,ep,:)=mean(squeeze(ntrans(ind,ep,:))'./[N(ind,ep)*ones(1,L)],1);
            nRT(mi,ep,:)=mean(squeeze(nretro(ind,ep,:))'./[N(ind,ep)*ones(1,L)],1);
        end
    end
end


%% PlotErrorBarN, mice pooled
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.5 0.5 0.4]);
for ep=1:L
    subplot(2,L,ep)
    PlotErrorBarN(squeeze(nT(:,ep,:)),0,0);
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ',nameEpochs{ep},' to...'])
    ylabel('fraction');
    
    subplot(2,L,L+ep)
    PlotErrorBarN(squeeze(nRT(:,ep,:)),0,0);
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ... to ',nameEpochs{ep}])
    ylabel('fraction');
end
if optionSave, saveFigure(gcf,['SleepStages_transition_Pool1_',date],FolderToSave);end


%% errorbar, mice pooled
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.4]);
for ep=1:L
    subplot(2,L,ep), hold on,
    temp=squeeze(ntrans(:,ep,:))./[N(:,ep)*ones(1,L)];
    A=nanmean(temp,1);
    bar(1:L,A);
    errorbar(1:L,A,nanstd(temp)/sqrt(sum(~isnan((nanmean(temp,2))))),'+');
    for i=1:L
        text(i-0.1,A(i)+0.03,sprintf('%0.2f',A(i)));
    end
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ',nameEpochs{ep},' to...'])
    ylabel('fraction');
    
    subplot(2,L,L+ep), hold on,
    temp=squeeze(nretro(:,ep,:))./[N(:,ep)*ones(1,L)];
    A=nanmean(temp,1);
    bar(1:L,A);
    errorbar(1:L,A,nanstd(temp)/sqrt(sum(~isnan((nanmean(temp,2))))),'+');
    for i=1:L
        text(i-0.1,A(i)+0.03,sprintf('%0.2f',A(i)));
    end
    xlim([0.5 5.5])
    set(gca,'Xtick',1:L); 
    set(gca,'XtickLabel',nameEpochs(1:L))
    title(['transition from ... to ',nameEpochs{ep}])
    ylabel('fraction');
    
end
if optionSave, saveFigure(gcf,['SleepStages_transition_Pool2_',date],FolderToSave);end

