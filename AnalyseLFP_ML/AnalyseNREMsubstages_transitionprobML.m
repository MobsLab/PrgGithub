%AnalyseNREMsubstages_transitionprobML.m

% need output from AnalyseNREMsubstagesML.m
% list of related scripts in NREMstages_scripts.m 

%% INITIATION AND OPTIONS
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/FIguresPosterSFN2015';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNovembre2015/';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages';
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
    [temp,nameEpochs]=DefineSubStages(MATepochs(man,1:end-1),MATepochs{man,end});
    MATEP(man,1:length(temp))=temp;
end
disp('Done');
%MATepochs={OsciSup,OsciDeep,N3,REM,WAKE,SWS,SlowPF,SlowOB};
%nameEpochs={'N1','N2','N3','REM','WAKE','SWS','swaPF','swaOB','TOTSleep'};
%MATEP(man,:)={N1,N2,N3,REM,WAKE,SWS,PFswa,OBswa,TOTSleep};

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Define substages <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

L=6;
ntrans=nan(length(Dir.path),L,L);
nretro=nan(length(Dir.path),L,L);
N=nan(length(Dir.path),L);
D=nan(length(Dir.path),L);

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
            Sta=[Sta ; [Start(op{ep},'s'),zeros(length(Start(op{ep})),1)+ep,Stop(op{ep},'s')] ];
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
            D(man,i)=sum(Sta(Sta(:,2)==i,3)-Sta(Sta(:,2)==i,1))/60;
            for j=1:L
                % from i to j
                ntrans(man,i,j)=length(find([0;Sta(:,2)]==i & [Sta(:,2);0]==j));
                % to i from j
                nretro(man,i,j)=length(find([0;Sta(:,2)]==j & [Sta(:,2);0]==i));
            end
        end
        
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<< pool mice <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


mice=unique(Dir.name);
nT=nan(length(mice),L,L); nRT=nT;
nN=nan(length(mice),L);nD=nN;
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    for ep=1:L
        try
            nT(mi,ep,:)=nanmean(squeeze(ntrans(ind,ep,:))./[N(ind,ep)*ones(1,L)],1);
            nRT(mi,ep,:)=nanmean(squeeze(nretro(ind,ep,:))./[N(ind,ep)*ones(1,L)],1);
        catch
            nT(mi,ep,:)=nanmean(squeeze(ntrans(ind,ep,:))'./[N(ind,ep)*ones(1,L)],1);
            nRT(mi,ep,:)=nanmean(squeeze(nretro(ind,ep,:))'./[N(ind,ep)*ones(1,L)],1);
        end
        nN(mi,ep)=nanmean(N(ind,ep),1);
        nD(mi,ep)=nanmean(D(ind,ep),1);
    end
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<< PlotErrorBarN and errorbar, all expe and pooled mice <<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

tit={'All','Pooled','AllAbs'};
for f=1:3
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.5 0.5 0.8]);
    for ep=1:L
        if f==1,
            n1=100*squeeze(ntrans(:,ep,:))./[N(:,ep)*ones(1,L)];
            n2=100*squeeze(nretro(:,ep,:))./[N(:,ep)*ones(1,L)];
        elseif f==2
            n1=100*squeeze(nT(:,ep,:));
            n2=100*squeeze(nRT(:,ep,:));
        else
            n1=squeeze(ntrans(:,ep,:));
            n2=squeeze(nretro(:,ep,:));
        end
        MAT1(ep,:)=nanmean(n1,1);
        MAT2(ep,:)=nanmean(n2,1);
        
        % transition from ep to ...
        subplot(4,L+2,ep)
        PlotErrorBarN(n1,0,0);
        title(['transition from ',nameEpochs{ep},' to...'])
        
        subplot(4,L+2,L+2+ep), hold on,
        bar(1:L,MAT1(ep,:));yl=diff(ylim);
        errorbar(1:L,MAT1(ep,:),nanstd(n1)/sqrt(sum(~isnan((nanmean(n1,2))))),'+');
        for i=1:L
            text(i-0.1,MAT1(ep,i)+yl/15,sprintf('%1.1f',MAT1(ep,i)));
        end
        title(['transition from ',nameEpochs{ep},' to...'])
        
        
        % transition from ... to ep
        subplot(4,L+2,2*(L+2)+ep)
        PlotErrorBarN(n2,0,0);
        title(['transition from ... to ',nameEpochs{ep}])
        
        subplot(4,L+2,3*(L+2)+ep), hold on,
        bar(1:L,MAT2(ep,:));yl=diff(ylim);
        errorbar(1:L,MAT2(ep,:),nanstd(n2)/sqrt(sum(~isnan((nanmean(n2,2))))),'+');
        for i=1:L
            text(i-0.1,MAT2(ep,i)+yl/15,sprintf('%1.1f',MAT2(ep,i)));
        end
        title(['transition from ... to ',nameEpochs{ep}])
        
        for i=1:4
            subplot(4,L+2,(i-1)*(L+2)+ep)
            xlim([0.5 5.5])
            set(gca,'Xtick',1:L);
            set(gca,'XtickLabel',nameEpochs(1:L))
            if f==3, ylabel('#');else, ylabel('%');end
        end
    end
    
    % stacked representation
    subplot(4,L+2,[L+1:L+2,2*L+3:2*L+4]), hold on,
    colormap pink
    bar(1:L,MAT1,'stacked'); title(['Proportion of the next stage ',tit{f}])
    subplot(4,L+2,2*(L+2)+[L+1:L+2,2*L+3:2*L+4]), hold on,
    bar(1:L,MAT2,'stacked'); title(['Proportion of the previous stage ',tit{f}])
    
    for i=1:2
        subplot(4,L+2,(i-1)*2*(L+2)+[L+1:L+2,2*L+3:2*L+4])
        xlim([0.5 5.5]);legend(nameEpochs(1:L),'Location','EastOutside')
        set(gca,'Xtick',1:L); if f<3, ylim([0 105]);end
        set(gca,'XtickLabel',nameEpochs(1:L))
        xlabel('Current stage'); 
    end
    
    % save Figures
    if optionSave
        saveFigure(gcf,['SleepStages_transition_',tit{f},'_',date],FolderToSave);
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<< epoch number and duration, all expe and pooled mice <<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ; 0.7 0.2 0.8; ]; %1 0.5 1;

for f=1:2
    figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.6]);
    
    if f==1
        tempN=nN; tempD=nD; tit=sprintf('Pooled mice (N=%d)',sum(~isnan(nanmean(nN,2))));
    else
        tempN=N; tempD=D; tit=sprintf('All expe (n=%d, N=%d)',sum(~isnan(nanmean(N,2))),sum(~isnan(nanmean(nN,2))));
    end
    
    % plot epochs number
    subplot(2,5,1), hold on,
    PlotErrorBarN(tempN,0,1);
    ylabel('epochs number');
    title(tit)
    
    subplot(2,5,6), hold on,
    A=nanmean(tempN,1);
    bar(1:L,A);yl=diff(ylim);
    errorbar(1:L,A,nanstd(tempN)/sqrt(sum(~isnan((nanmean(tempN,2))))),'+');
    for i=1:L
        text(i-0.1,A(i)+yl/10,sprintf('%1.0f',A(i)));
    end
    ylabel('epochs number');
    
    % plot epochs duration
    leg={'min','% total','% sleep','% NREM'};
    for s=1:4
        if s==1
            temp=tempD;
        else
            temp=100*tempD./(sum(tempD(:,1:(L-s+2)),2)*ones(1,L));
        end
        
        subplot(2,5,s+1), hold on,
        PlotErrorBarN(temp,0,1);
        ylabel(['total epoch duration (',leg{s},')']);
        
        subplot(2,5,s+6), hold on,
        A=nanmean(temp,1);
        bar(1:L,A);yl=diff(ylim);
        errorbar(1:L,A,nanstd(temp)/sqrt(sum(~isnan((nanmean(temp,2))))),'+');
        for i=1:L
            text(i-0.1,A(i)+yl/10,sprintf('%1.0f',A(i)));
        end
        ylabel(['total epoch duration (',leg{s},')']);
    end
    % add xaxis legend
    for i=1:10
        subplot(2,5,i),
        xlim([0.5 5.5])
        set(gca,'Xtick',1:L);
        set(gca,'XtickLabel',nameEpochs(1:L))
    end
    
    if optionSave, saveFigure(gcf,['SleepStages_numberANDdurations',num2str(f),'_',date],FolderToSave);end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<< epoch repartition, choose ordering, all expe and pooled mice <<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

clrmap=[0.7 0.3 0.8; 1 0.5 1 ;0.8 0.3 0.7 ; 0.1 0.7 0 ;  0.5 0.2 0.1; 0.5 0.5 1];
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.6]);
    leg={'min','% total','% sleep','% NREM'};
typeOrder=2; % 0=not ordered, 1= ordered by N1 duration, 2=N2, 3=N3, 4=REM, 5=WAKE, 6=TOT
orderlegend=[1 3 2 4 5];% default 1:L
clrmap=clrmap(orderlegend,:);
for f=1:2
    
    if f==1
        tempD=nD; tit=sprintf('Num Mice (N=%d)',sum(~isnan(nanmean(nN,2))));
    else
        tempD=D; tit=sprintf('Num expe (n=%d, N=%d)',sum(~isnan(nanmean(N,2))),sum(~isnan(nanmean(nN,2))));
    end
    
    
    for s=1:4
        if s==1
            temp=tempD;
        else
            temp=100*tempD./(sum(tempD(:,1:(L-s+1)),2)*ones(1,L));
        end
        temp=temp(~isnan(sum(temp,2)),:);
        % order by
        if typeOrder==6 %order by Recording Duration
            tem=sortrows([sum(temp(:,1:L),2),temp],1);
            temp=tem(:,2:6);
        elseif typeOrder>0 && typeOrder<6
            temp=sortrows(temp,typeOrder);
        end
        temp=temp(:,orderlegend);
        subplot(2,4,4*(f-1)+s), hold on,
        bar(temp,'stacked'); xlim([0 size(temp,1)+1])
        title(['total epoch duration (',leg{s},')']);
        xlabel(tit)
    end
end
legend(nameEpochs{orderlegend}); colormap(clrmap)
if optionSave, saveFigure(gcf,['SleepStages_StackedDurations_',nameEpochs{typeOrder}],FolderToSave);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<< SleepStages Proportion, Intra-Individual Variability <<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.1 0.5 0.6]);
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
     for s=1:4
        if s==1
            temp=D;
        else
            temp=100*D./(sum(D(:,1:(L-s+2)),2)*ones(1,L));
        end
        subplot(4,1,s), hold on,
        for ep=1:L
            plot(2*mi-0.5+0.2*ep,temp(ind,ep),'ok','MarkerFaceColor',clrmap(ep,:))
        end
        title(['total epoch duration (',leg{s},')']);
     end
     legmi{mi}=mice{mi}(end-2:end);
     end
for s=1:4, subplot(4,1,s), set(gca,'Xtick',2*[1:length(mice)]),set(gca,'XtickLabel',legmi);end
legend(nameEpochs(1:L))
if optionSave, saveFigure(gcf,['SleepStagesProportion_IntraIndivVariability'],FolderToSave);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< Transition diagram <<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.4 0.35 0.6]); 
colorci={'k','b','r','g','k'};
for f=1:2
    if f==1
        A=nanmean(nD,1); tit='Averaged State Duration (mice pooled)';
    else
        A=nanmean(nN,1);tit='Averaged State Number (mice pooled)';
    end
    subplot(2,2,f), 
    %N1
    circli = rsmak('circle',A(1),[0 max(A)+A(1)]);
    hold on, plot(0,max(A)+A(1),['+',colorci{1}])
    hold on, fnplt(circli,'Color',colorci{1})
    text(A(1)/3,max(A)+A(1),'N1','Color',colorci{1})
    % N2
    circli = rsmak('circle',A(2),[-(max(A)+A(2)) 0]);
    hold on, plot(-(max(A)+A(2)),0,['+',colorci{2}])
    hold on, fnplt(circli,'Color',colorci{2})
    text(-(max(A)+A(2)),A(2)/3,'N2','Color',colorci{2})
    % N3
    circli = rsmak('circle',A(3),[-2*max(A) 2*max(A)]);
    hold on, plot(-2*max(A),2*max(A),['+',colorci{3}])
    hold on, fnplt(circli,'Color',colorci{3})
    text(-2*max(A)+A(3)/3,2*max(A),'N3','Color',colorci{3})
    %REM
    circli = rsmak('circle',A(4),[0 -(max(A)+A(4))]);
    hold on, plot(0, -(max(A)+A(4)),['+',colorci{4}])
    hold on, fnplt(circli,'Color',colorci{4})
    text(A(4)/3, -(max(A)+A(4)),'REM','Color',colorci{4})
    %WAKE
    circli = rsmak('circle',A(5),[max(A)+A(5) 0]);
    hold on, plot(max(A)+A(5),0,['+',colorci{5}])
    hold on, fnplt(circli,'Color',colorci{5})
    text(max(A)+A(5),A(5)/3,'WAKE','Color',colorci{5})
    title(tit); xl=xlim; yl=ylim; axis off
    xlim([min([xl yl]) max([xl yl])]);ylim([min([xl yl]) max([xl yl])]);
    
    % to help construction of the transition diagram
    B=MAT1.*[A'*ones(1,5)];
    subplot(2,2,2+f),bar(B/((f-1)*2E3+500)), 
    colormap pink; ylabel('Goes into...')
    if f==1, title('Transition proportion depending on stage duration');else,title('Transition repartition depending on episod number'), end
    set(gca,'Xtick',1:L); set(gca,'XtickLabel',nameEpochs(1:L))
    legend(nameEpochs(1:L));xlabel('Current stage')
    
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<< correlations between epoch number of substages <<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
L=6;optionSave=1;
colori=[ 0.7 0.2 1; 1 0.5 1; 0.8 0 0.7;  0.1 0.7 0 ; 0.5 0.2 0.1; 1 0 1 ;];
tit={'%durTOT','%durSLEEP',' dur'};
for f=1:3
    figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.2 0.4 0.75]);
    subplot(L,L,1)
    if f==1
        temp1=100*D./[sum(D,2)*ones(1,L)]; temp2=100*nD./[sum(nD,2)*ones(1,L)]; 
    elseif f==2
        temp1=100*D./[sum(D(:,1:4),2)*ones(1,L)]; temp2=100*nD./[sum(nD(:,1:4),2)*ones(1,L)]; 
    else
        temp1=D; temp2=nD;
    end
    title({sprintf('UP: All expe (n=%d, N=%d)',sum(~isnan(nanmean(N,2))),sum(~isnan(nanmean(nN,2)))),...
        sprintf('DOWN: Pooled mice (N=%d)',sum(~isnan(nanmean(nN,2))))})
        
    for i=1:L
        for j=1:L
            subplot(L,L,(j-1)*L+i), hold on,
            
            if i<j
                x=temp1(~isnan(temp1(:,i)),i);
                y=temp1(~isnan(temp1(:,j)),j);
                plot(x,y,'.','Color',colori(j,:))
            elseif i>j
                x=temp2(~isnan(temp2(:,i)),i);
                y=temp2(~isnan(temp2(:,j)),j);
                plot(x,y,'.','Color',colori(j,:))
            end
            
            if i==j
                axis off
            else
                ylabel([nameEpochs{j},' ',tit{f}], 'Color',colori(j,:));
                title([nameEpochs{i},' ',tit{f}], 'Color',colori(i,:));
                p= polyfit(x,y,1);
                line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colori(j,:),'Linewidth',2)
                [r,p]=corrcoef(x,y);
                li=[max(xlim),max(ylim),min(xlim)];
                text(li(1)*0.1+li(3), li(2), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)),'Color',colori(i,:))
            end
            
            
        end
    end
if optionSave, saveFigure(gcf,['SleepStages_transition_Correlation',tit{f}(2:end),'_',date],FolderToSave);end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<< figure these Marie - correlations substages duration <<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% inputs
colori=[ 0.7 0.2 1; 1 0.5 1; 0.8 0 0.7;  0.1 0.7 0 ; 0.5 0.2 0.1; 1 0 1 ;];
%MATEP:{N1,N2,N3,REM,WAKE,SWS,SI,PFswa,OBswa,TOTSleep,WAKEnoise};
nameEp={'N1','N2','N3','REM','WAKEnoise','SWS'};

% recalculate duration of each state
Dur=nan(length(Dir.path),length(nameEpochs));
ratioDur=nan(length(Dir.path),length(nameEpochs));% in % of total duration
for man=1:length(Dir.path)
    op=MATEP(man,:);
    TotDur=or(op{10},op{11});% TOTSleep + WAKEnoise
    for n=1:length(nameEpochs)
        try Dur(man,n)=sum(Stop(op{n},'s')-Start(op{n},'s'));end
        try ratioDur(man,n)=100*Dur(man,n)/sum(Stop(TotDur,'s')-Start(TotDur,'s'));end
    end
end
% pool mice
mice=unique(Dir.name);
rpoolDur=nan(length(mice),length(nameEpochs));
for mi=1:length(mice)
    id=find(strcmp(mice{mi},Dir.name));
    rpoolDur(mi,:)=nanmean(ratioDur(id,:),1);
end
% display
L=length(nameEp);
figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.2 0.45 0.35]); numF=gcf;
for f=1:2
    figure('Color',[1 1 1],'Units','normalized','Position',[0.06 0.2 0.45 0.75]);numG=gcf;
    if f==1
        temp=ratioDur;
        tit=sprintf('All expe (n=%d, N=%d)',sum(~isnan(nanmean(ratioDur,2))),sum(~isnan(nanmean(rpoolDur,2))));
    else
        temp=rpoolDur;
        tit=sprintf('Pooled mice (N=%d)',sum(~isnan(nanmean(rpoolDur,2))));
    end
    for i=1:L
        idi=find(strcmp(nameEp{i},nameEpochs));
        for j=1:L
            idj=find(strcmp(nameEp{j},nameEpochs));
            if i~=j
                x=temp(~isnan(temp(:,idi)),idi);
                y=temp(~isnan(temp(:,idj)),idj);
                figure(numG),subplot(L,L,(i-1)*L+j), hold on,plot(x,y,'.k')
                xlabel([nameEp{i},' %durTOT'], 'Color',colori(i,:));
                ylabel([nameEp{j},' %durTOT'], 'Color',colori(j,:));
                if j==1, title(tit);end
                xlim([min(x)*0.92,max(x)*1.08]); ylim([min(y)*0.92,max(y)*1.08])
                p= polyfit(x,y,1);
                line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
                [r,pval]=corrcoef(x,y);
                li=[max(xlim),max(ylim),min(xlim)];
                text(li(1)*0.1+li(3), li(2), sprintf('r=%0.1f, p=%0.3f',r(1,2),pval(1,2)),'Color','k')
                
                if j==4,
                    figure(numF), subplot(2,L,(f-1)*L+i)
                    plot(x,y,'.k','MarkerSize',12)
                    line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
                    xlabel([nameEp{i},' %durTOT'], 'Color',colori(i,:)); xlim([min(x)-1,max(x)+1])
                    ylabel([nameEp{j},' %durTOT'], 'Color',colori(j,:)); ylim([min(y)-1,max(y)+1])
                    li=[max(xlim),max(ylim),min(xlim)];
                    text(li(1)*0.1+li(3), li(2), sprintf('r=%0.1f, p=%0.3f',r(1,2),pval(1,2)),'Color','k')
                    if i==1, title(tit);end
                end
            else
                figure(numG),subplot(L,L,(i-1)*L+j),axis off
            end
        end
    end
end
%saveFigure(gcf,'CorrelationDurationSubstages','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages')


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<< figure these Marie - inter/intraindiv varaibility <<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.3 0.5 0.4]);
mice=unique(Dir.name);
legmi={};
BarVarIntra=nan(length(mice),5);
Meanm=nan(length(mice),5);
for n=1:5
    temp=[ratioDur(:,n),[1:size(ratioDur,1)]'];
    for man=1:length(Dir.path)
        temp(man,3)=find(strcmp(Dir.name{man},mice));
    end
    tempMi=[rpoolDur(:,n),[1:length(mice)]'];
    tempMi=sortrows(tempMi,1);
    
    for mi=1:length(tempMi)
        id=tempMi(mi,2);
        y=temp(temp(:,3)==id,1);
        subplot(2,7,n), hold on,
        plot(mi*ones(length(y),1),y,'.','Color',colori(n,:),'MarkerSize',20)
        line([mi mi],[min(y) max(y)],'Color',[0.5 0.5 0.5])
        ylim([0 65]); title(nameEp{n}, 'Color',colori(n,:))
        
        y=temp(temp(:,3)==mi,1);
        subplot(2,7,8:12), hold on,
        plot((9*mi-2+n)*ones(length(y),1),y,'.','Color',colori(n,:),'MarkerSize',20)
        line(9*mi-2+[n n],[min(y) max(y)],'Color',[0.5 0.5 0.5]); ylim([0 65]);
        if n==1, legmi=[legmi,mice{mi}(6:end)];end
        if length(y)>2, BarVarIntra(mi,n)=nanstd(y);end
        Meanm(mi,n)=nanmean(y);
    end
    
end
set(gca,'Xtick',9*[1:length(mice)]),set(gca,'XtickLabel',legmi);
title('Separate each mouse');

% BarVarInter=nanstd(ratioDur(:,1:5));
% BarMean=nanmean(ratioDur(:,1:5));
BarVarInter=nanstd(Meanm);
BarMean=nanmean(Meanm);
subplot(2,7,[6,7]), 
PlotErrorBarN(BarVarIntra,0,0);
hold on, plot(BarVarInter,'.b','MarkerSize',20)
hold on, plot(BarMean,'.k','MarkerSize',20)
legend({'std','mean std',nameEp{1:5},'InterVar','Mean'},'Location','BestOutside');
title('Intraindividual variability');
set(gca,'Xtick',1:5),set(gca,'XtickLabel',nameEp(1:5));

subplot(2,7,[13,14]), hold on, 
% PlotErrorBarN(100*BarVarIntra./(ones(size(BarVarIntra,1),1)*BarMean),0,0);
% hold on, plot(100*BarVarInter./BarMean,'.b','MarkerSize',20)
% legend({'std','mean std',nameEp{1:5},'InterVar','Mean'},'Location','BestOutside');
% title('Intraindividual variability (in % of mean duration)');
%set(gca,'Xtick',1:5),set(gca,'XtickLabel',nameEp(1:5));
for n=1:5; plot(BarVarInter(:,n),BarVarIntra(:,n),'.','Color',colori(n,:),'MarkerSize',20);end
xlabel('InterVar'); ylabel('IntraVar'); xlim([0 25]);ylim([0 25])
line([0 25],[0 25],'Color',[0.5 0.5 0.5]); 
legend(sprintf('n=%d mice',sum(~isnan(nanmean(BarVarIntra,2)))),'Location','BestOutside')

%saveFigure(gcf,'SubstageDurationInterIntraVar','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages')