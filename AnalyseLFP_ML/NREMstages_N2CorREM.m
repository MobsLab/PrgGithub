%NREMstages_N2CorREM
%
% list of related scripts in NREMstages_scripts.m


%% NEW COMPUTATION

% -------------------------------------------------------------------------
% manual input
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
analyName='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstages_N2CorREM';
if ~exist([analyName,'.mat'],'file'), save(analyName,'FolderTOsave');end
%DataSet='miceSD24h';
%DataSet='miceSD6h';
%DataSet='miceBSL';
DataSet='Humans';
savFig=1;
% -------------------------------------------------------------------------
% load path
if strcmp(DataSet,'miceSD24h'),
    load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD24h_2hStep_Wnz',...
        'Stages','Epochs','h_deb','nameMouse','Dir');
    nameSes={'BSL','SD24h','24+1d'};
    NameEpochs=Stages;
    
elseif strcmp(DataSet,'miceSD6h'),
    load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD6h_2hStep_Wnz',...
        'Stages','Epochs','h_deb','nameMouse','Dir');
    NameEpochs=Stages;
    nameSes={'BSL','SD6h','6h+1d'};

elseif strcmp(DataSet,'miceBSL'),
    load('/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages/AnalySubstagesTrioTransition',...
        'NameEpochs','Epochs');
    nameSes={'BSL'};
    temp=Epochs; Epochs={};
    for man=1:size(temp,1), Epochs{man,1}=temp(man,:); end
    
elseif strcmp(DataSet,'Humans'),
    load('/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages/AnalySubstagesHumansAASM_mrg5s',...
        'NameEpochs','Epochs');
    nameSes={'BSL'};
    temp=Epochs; Epochs={};
    for man=1:size(temp,1), Epochs{man,1}=temp(man,:); end
end

% -------------------------------------------------------------------------
%% load analysis
try
    load(analyName);
    eval(['nameSes=nameSes_',DataSet,'; DurCo=DurCo_',DataSet,'; '])
catch
    % -------------------------------------------------------------------------
    % get REM and NREM episodes
    Stages={'WAKE','NREM','N1','N2','N3','REM'};
    DurCo={};iRbn={};iRbnRv={};
    for man=1:size(Epochs,1)
        for ses=1:length(nameSes)
            
            clear DurPost Ep REM
            Ep=Epochs{man,ses};
            REM=Ep{find(strcmp(NameEpochs,'REM'))};
            
            sta=Start(REM); sto=Stop(REM);
            DurPost=nan(length(sta),length(Stages)+1);
            
            DurPost(:,1)=(sto-sta)/1E4; % duration REM (s)
            for n=1:length(Stages)
                epoch=Ep{find(strcmp(NameEpochs,Stages{n}))};
                for ss=1:length(sta)
                    try
                        Ipost=intervalSet(sto(ss),sta(ss+1)); % after REM
                        Epost=and(Ipost,epoch);
                        DurPost(ss,n+1)=sum(Stop(Epost,'s')-Start(Epost,'s')); % duration
                    end
                end
            end
            DurCo{man,ses}=DurPost;
            if strcmp(DataSet,'miceSD24h'),
                I=9-h_deb(man,ses)+2;
                iRbn{man,ses}=find(sta<I*3600*1E4);%0-2h
                iRbnRv{man,ses}=find(sta>(I+12)*3600*1E4 & sta<(I+14)*3600*1E4);
            end
        end
    end
    
    % save
    eval(['nameSes_',DataSet,'=nameSes; DurCo_',DataSet,'=DurCo;'])
    eval(['save(analyName,''-append'',''nameSes_',DataSet,''',''DurCo_',DataSet,''');'])
    if strcmp(DataSet,'miceSD24h')
        eval(['save(analyName,''-append'',''nameSes_',DataSet,''',''DurCo_',DataSet,''',''iRbn'',''iRbnRv'');'])
    end
end
% -------------------------------------------------------------------------
%% display indiv data
figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.2 0.5 0.5]),numF2=gcf;
 col=[0.5 0.2 0.1;0 0 1;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0.1 0.7 0 ;0 0 0];
 yl=[]; 
option='';
%if strcmp(DataSet,'miceSD24h'),option='Rbn';end
%if strcmp(DataSet,'miceSD24h'),option='RbnRv';end
PVAL=nan(size(Epochs,1),length(nameSes),5);RVAL=PVAL;SVAL=PVAL;
for do=1:2
    if do==1, nameleg='afterREM';else, nameleg='beforeREM';end
    for man=1:size(Epochs,1)
        for n=1:5
            for ses=1:length(nameSes)
                if ses==1, colo=[0 0 0]; elseif ses==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
                M=DurCo{man,ses};
                if strcmp(option,'Rbn'),M= M(iRbn{man,ses},:);end
                if strcmp(option,'RbnRv'),M= M(iRbnRv{man,ses},:);end
                
                M1=M(1:end-1,n+1);
                if do==1,  M2=M(1:end-1,1);else, M2=M(2:end,1); end
                
                id=find(M1~=-Inf & M2~=-Inf & ~isnan(M1) & ~isnan(M2));
                M1p=M1(id); M2p=M2(id);
                if length(id)>2
                p= polyfit(M1p,M2p,1);
                [r,pval]=corrcoef(M1p,M2p);
                PVAL(man,ses,n)=pval(1,2);
                RVAL(man,ses,n)=r(1,2);
                SVAL(man,ses,n)=p(1);
                end
            end
        end
    end
    
    for n=1:5
        pval=squeeze(PVAL(:,:,n));
        if 1 % do r value
            val=squeeze(RVAL(:,:,n));
            subplot(2,5,5*(do-1)+n), PlotErrorBarN(val,0); hold on,
            for i=1:size(val,2), temp=val(pval(:,i)<0.05,i);  plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','b');end
            title({[Stages{n},' ',option],nameleg},'Color',col(n,:));
            set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
            if n==1, ylabel({'Corr REM duration','r value'});end
            ylim([-0.6 0.7]);
        else % do slope
            val=squeeze(SVAL(:,:,n));
            subplot(2,5,5+n), PlotErrorBarN(squeeze(val),0);hold on,
            title({[Stages{n},' ',option],nameleg},'Color',col(n,:));
            for i=1:size(val,2), temp=val(pval(:,i)<0.05,i);  plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','b');end
            set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
            if n==1, ylabel({'Corr REM duration','slope'});end
            ylim([-0.5 1.2]);
        end
        yl=[yl,min(val(:)),max(val(:))];
    end
    
end
for do=1:10, subplot(2,5,do), ylim([min(yl), max(yl)]);end
if savFig, saveFigure(numF2.Number,sprintf(['CorrelationN2vsREM_',DataSet,'_BarIndiv',option]),FolderTOsave);end

% -------------------------------------------------------------------------
%% display pool data
 PVAL=nan(2,length(nameSes),5); RVAL=PVAL; SVAL=PVAL;
 figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.8 0.8]),numF=gcf;
 for ses=1:length(nameSes)
     M=[]; 
     for man=1:size(Epochs,1)
         tempM=DurCo{man,ses};
         if strcmp(option,'Rbn'),tempM=tempM(iRbn{man,ses},:);end
         if strcmp(option,'RbnRv'),tempM=tempM(iRbnRv{man,ses},:);end
         M=[M;tempM];
     end
     
     for n=1:5
         if ses==1, colo=[0 0 0]; elseif ses==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
         for do=1:2
             M1=M(1:end-1,n+1);
             if do==1,M2=M(1:end-1,1);nameleg='afterREM ';else, M2=M(2:end,1);nameleg='beforeREM '; end
             
             subplot(4,5,(do-1)*10+n), hold on,
             plot(M1,M2,'.','Color',colo,'MarkerSize',10)
             xlabel([Stages{n},' dur ',nameleg,' (s)'],'Color',col(n,:));
             if n==1, ylabel(['REM dur (s)'],'Color',col(6,:)); title([nameleg,' ',option]); end
             
             id=find(M1~=-Inf & M2~=-Inf & ~isnan(M1) & ~isnan(M2));
             M1p=M1(id); M2p=M2(id);
             p= polyfit(M1p,M2p,1);
             [r,pval]=corrcoef(M1p,M2p);
             PVAL(do,ses,n)=pval(1,2);
             RVAL(do,ses,n)=r(1,2);
             SVAL(do,ses,n)=p(1);
             hold on, line([min(M1p),max(M1p)],p(2)+[min(M1p),max(M1p)]*p(1),'Color',colo,'Linewidth',2)
             
             subplot(4,5,(do-1)*10+5+n),
             text(0,1-0.2*ses,sprintf([nameSes{ses},': r=%1.1f, p=%1.3f'],r(1,2),pval(1,2)),'Color',colo);
             axis off
         end
     end
 end
 subplot(4,5,3), title({DataSet,' ',' '})
 if savFig, saveFigure(numF.Number,['CorrelationN2vsREM_',DataSet,'_',option],FolderTOsave);end

% -------------------------------------------------------------------------
%% Quantify bar plot
 figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.2 0.6 0.7]),numF2=gcf;
 colormap([0 0 0 ; 0 0 1;0.5 0.5 0.5])
 I=[];for n=1:5, if length(nameSes)>1, I=[I,[0.75 1 1.25]+n-1]; else, I=[I,n];end; end
 yl=[];
 for do=1:2
     if do==1, nameleg=['afterREM ',option]; else, nameleg=['beforeREM ',option]; end
     val=squeeze(RVAL(do,:,:));
     pval=squeeze(PVAL(do,:,:));
     if length(nameSes)==1, val=val'; pval=pval';end
     subplot(2,2,2*(do-1)+1), bar(val'); hold on,
     set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
     ylabel({'Corr REM duration','r value'}); title({DataSet,nameleg});
     yl=[yl,min(val(:)),max(val(:))];
     if ~isempty(find(pval<0.05)), plot(I(find(pval<0.05)),0.9*min(yl),'*r');end
      
     val=squeeze(SVAL(do,:,:));
     subplot(2,2,2*(do-1)+2), bar(val');hold on,
     set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
     ylabel({'Corr REM duration','slope'});title({DataSet,nameleg});
     if ~isempty(find(pval<0.05)), plot(I(find(pval<0.05)),0.9*min(yl),'*r');end
     yl=[yl,min(val(:)),max(val(:))];
     for n=1:5
         legtxt=[];
         for ses=1:length(nameSes), legtxt=[legtxt,{sprintf('p=%1.3f',pval(ses,n))}];end
         text(n-0.5,0.8*max(yl),legtxt);
     end
 end
for do=1:4, subplot(2,2,do), ylim([min(0,1.1*min(yl)), 1.1*max(yl)]);end
subplot(2,2,3), legend(nameSes,'Location','Best')

 if savFig, saveFigure(numF2.Number,['CorrelationN2vsREM_',DataSet,'_bar',option],FolderTOsave);end
 




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%% OLD VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
    savFig=0;
    
    % ------------ 394 ------------
    Dir{1,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
    Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908';
    Dir{1,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909';
    
    % ------------ 403 ------------
    Dir{2,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915';
    Dir{2,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916';
    
    % ------------ 450 ------------
    Dir{3,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
    Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
    Dir{3,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
    
    % ------------ 451 ------------
    Dir{4,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
    Dir{4,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
    
    col=[0.5 0.2 0.1;0 0 1;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0.1 0.7 0 ;0 0 0];
    %option='log';
    option='';
    %DoRebnd='Rbd';% rebound 0-2h after light on
    %DoRebnd='RbdRv';% reversed rebound 6h-8h after light on
    DoRebnd='';
    
    clear DurCo DurCoPost DurCoPost2h DurCoPost8h
    try
        load([FolderTOsave,'/AnalyseNREMsubstages_CorrN2REM.mat'])
        DurCo; DurCoPost2h;DurCoPost8h;
        disp('AnalyseNREMsubstages_CorrN2REM.mat exists.. loaded.')
    catch
        DurCo={}; DurCoPost={}; DurCoPost2h={}; DurCoPost8h={};
        for mi=1:4
            for man=1:3
                cd(Dir{mi,man}); disp(Dir{mi,man})
                nameMice{mi}=Dir{mi,man}(strfind(Dir{mi,man},'Mouse')+[0:7]);
                [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
                REM=mergeCloseIntervals(REM,i_merge*1E4); % close REM
                REM=dropShortIntervals(REM,i_drop*1E4);
                N1=N1-REM; N2=N2-REM; N3=N3-REM;
                NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,10);
                WAKE=WAKEnoise; WAKE=WAKE-N1-N2-N3-REM;
                
                clear DurPost Durcum
                sta=Start(REM); sto=Stop(REM);
                DurPost=(sto-sta)/1E4; % duration REM (s)
                for n=1:length(Stages)
                    eval(['epoch=',Stages{n},';'])
                    for ss=1:length(sta)
                        Ipre=intervalSet(0,sto(ss));% all before REM
                        Epre=and(Ipre,epoch);
                        Durcum(ss,n)=sum(Stop(Epre,'s')-Start(Epre,'s')); % duration
                        try
                            Ipost=intervalSet(sto(ss),sta(ss+1)); % after REM
                            Epost=and(Ipost,epoch);
                            DurPost(ss,n+1)=sum(Stop(Epost,'s')-Start(Epost,'s')); % duration
                        end
                    end
                end
                DurCo{mi,man}=Durcum;
                DurCoPost{mi,man}=DurPost;
                DurCoPost2h{mi,man}=DurPost(find(sta/1E4<2*3600),:);
                DurCoPost8h{mi,man}=DurPost(find(sta/1E4<8*3600 & sta/1E4>6*3600),:);
                
            end
        end
        save([FolderTOsave,'/AnalyseNREMsubstages_CorrN2REM.mat'],'Stages','i_merge','i_drop',...
            'DurCo','DurCoPost','DurCoPost2h','DurCoPost8h','Dir','nameMice')
    end
    
    % display
    
    for do=2:3%1:3;
        figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.8 0.8]),numF=gcf;
        for mi=1:4
            for n=1:5
                subplot(4,5,5*(mi-1)+n), hold on,
                leg={};
                for man=1:3
                    if man==1, colo=[0 0 0]; elseif man==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
                    
                    if do==1
                        M=DurCo{mi,man};
                        plot(M(:,n),M(:,6),'.','Color',colo,'MarkerSize',10)
                        if n==1, ylabel('REM dur (s)','Color',col(6,:)); title(nameMice{mi});end
                        xlabel([Stages{n},' dur (s)'],'Color',col(n,:))
                        
                    elseif do>1
                        if strcmp(DoRebnd,'Rbd'), M=DurCoPost2h{mi,man}; leg ='Rbnd 0-2h';
                        elseif strcmp(DoRebnd,'RbdRv'), M=DurCoPost8h{mi,man}; leg ='Rbnd 6-8h';
                        else,M=DurCoPost{mi,man};end
                        
                        if do==2
                            M1=M(1:end-1,n+1);
                            M2=M(1:end-1,1);
                            nameleg='afterREM';
                        else
                            M1=M(1:end-1,n+1);
                            M2=M(2:end,1);
                            nameleg='beforeREM';
                        end
                        
                        if strcmp(option,'log'), M1=log(M1); M2=log(M2); end
                        plot(M1,M2,'.','Color',colo,'MarkerSize',10)
                        xlabel([Stages{n},' dur ',nameleg,' (',option,'s)'],'Color',col(n,:))
                        if n==1, ylabel(['REM dur (',option,'s)'],'Color',col(6,:)); title([nameMice{mi},' ',leg]);end
                        
                        id=find(M1~=-Inf & M2~=-Inf);
                        M1p=M1(id); M2p=M2(id);
                        p= polyfit(M1p,M2p,1);
                        [r,pval]=corrcoef(M1p,M2p);
                        PVAL(mi,man,n)=pval(1,2);
                        RVAL(mi,man,n)=r(1,2);
                        SVAL(mi,man,n)=p(1);
                        
                        hold on, line([min(M1p),max(M1p)],p(2)+[min(M1p),max(M1p)]*p(1),'Color',colo,'Linewidth',2)
                        %leg=[leg, {sprintf('r2=%1.1f',r(1,2))},{sprintf('p=%1.3f',pval(1,2))}];
                    end
                end
                %legend(leg,'Location','EastOutside')
            end
        end
        %legend(tit)
        if savFig
            if do==1, saveFigure(numF.Number,sprintf('CorrelationN2vsREM_cum_merge%ds',i_merge),FolderTOsave);
            else, saveFigure(numF.Number,sprintf(['CorrelationN2vsREM_',nameleg,option,DoRebnd,'_merge%ds',i_merge]),FolderTOsave);
            end
        end
        
        if do>1
            
            figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.2 0.5 0.5]),numF2=gcf;
            for n=1:5
                pval=squeeze(PVAL(:,:,n));
                val=squeeze(RVAL(:,:,n));
                subplot(2,5,n), PlotErrorBarN(val,0); hold on,
                for i=1:size(val,2), temp=val(pval(:,i)<0.05,i);  plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','b');end
                title(Stages{n},'Color',col(n,:));
                set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
                if n==1, ylabel({'Corr REM duration','r value'});end
                ylim([-0.6 0.7]);
                
                val=squeeze(SVAL(:,:,n));
                subplot(2,5,5+n), PlotErrorBarN(squeeze(val),0);hold on,
                title([nameleg,option,' ',leg]);
                for i=1:size(val,2), temp=val(pval(:,i)<0.05,i);  plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','b');end
                set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
                if n==1, ylabel({'Corr REM duration','slope'});end
                ylim([-0.5 1.2]);
            end
            
            if savFig, saveFigure(numF2.Number,sprintf(['CorrelationN2vsREM_',nameleg,option,DoRebnd,'Bar_merge%ds',i_merge]),FolderTOsave);end
        end
    end
    
    % pool mice
    clear PVAL RVAL SVAL
    figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.8 0.8]),numF=gcf;
    for man=1:3
        if strcmp(DoRebnd,'Rbd'), Dt=DurCoPost2h; leg ='Rbnd 0-2h';
        elseif strcmp(DoRebnd,'RbdRv'), Dt=DurCoPost8h;leg ='Rbnd 6-8h';
        else, Dt=DurCoPost; leg='';end
        M=[]; for mi=1:4, M=[M;Dt{mi,man}];end
        for n=1:5
            if man==1, colo=[0 0 0]; elseif man==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
            for do=1:4
                if do<3
                    M1=M(1:end-1,n+1);
                    M2=M(1:end-1,1);
                    nameleg='afterREM';
                else
                    M1=M(1:end-1,n+1);
                    M2=M(2:end,1);
                    nameleg='beforeREM';
                end
                if do/2==floor(do/2), option='log'; M1=log(M1); M2=log(M2); else, option='';end
                
                subplot(4,5,(do-1)*5+n), hold on,
                plot(M1,M2,'.','Color',colo,'MarkerSize',10)
                xlabel([Stages{n},' dur ',nameleg,' (',option,'s)'],'Color',col(n,:))
                if n==1, ylabel(['REM dur (',option,'s)'],'Color',col(6,:)); title([nameleg,option,' ',leg]); end
                
                id=find(M1~=-Inf & M2~=-Inf);
                M1p=M1(id); M2p=M2(id);
                p= polyfit(M1p,M2p,1);
                [r,pval]=corrcoef(M1p,M2p);
                PVAL(do,man,n)=pval(1,2);
                RVAL(do,man,n)=r(1,2);
                SVAL(do,man,n)=p(1);
                hold on, line([min(M1p),max(M1p)],p(2)+[min(M1p),max(M1p)]*p(1),'Color',colo,'Linewidth',2)
            end
        end
    end
    if savFig, saveFigure(numF.Number,sprintf(['CorrelationN2vsREM_Bilan',DoRebnd,'_merge%ds',i_merge]),FolderTOsave);end
    %
    figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.2 0.5 0.7]),numF2=gcf;
    colormap([0 0 0 ; 0 0 1;0.5 0.5 0.5])
    I=[];for n=1:5, I=[I,[0.75 1 1.25]+n-1];end
    for do=1:4
        if do<3, nameleg='afterREM'; else, nameleg='beforeREM'; end
        if do/2==floor(do/2), option='log'; else, option='';end
        val=squeeze(RVAL(do,:,:));
        pval=squeeze(PVAL(do,:,:));
        subplot(4,2,2*(do-1)+1), bar(val'); hold on,
        %title([nameleg,option,' ',leg]);
        set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
        ylabel({'Corr REM duration','r value'});
        ylim([-0.3 0.5])
        if ~isempty(find(pval<0.05)), plot(I(find(pval<0.05)),0.9*min(ylim),'*r');end
        for n=1:5, text(n-0.5,max(ylim),{sprintf('p=%1.3f',pval(1,n)),sprintf('p=%1.3f',pval(2,n)),sprintf('p=%1.3f',pval(3,n))});end
        
        val=squeeze(SVAL(do,:,:));
        subplot(4,2,2*(do-1)+2), bar(val');hold on,
        title([nameleg,option,' ',leg]);
        set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
        ylabel({'Corr REM duration','slope'});
        ylim([-0.15 0.5])
        if ~isempty(find(pval<0.05)), plot(I(find(pval<0.05)),0.9*min(ylim),'*r');end
    end
    if savFig, saveFigure(numF2.Number,sprintf(['CorrelationN2vsREM_Bilan',DoRebnd,'Bar_merge%ds',i_merge]),FolderTOsave);end
    
end