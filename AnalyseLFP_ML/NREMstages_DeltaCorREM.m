% NREMstages_DeltaCorREM
%
% list of related scripts in NREMstages_scripts.m

% -------------------------------------------------------------------------
%% manual input
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
analyName='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstages_DeltaCorREM';
savFig=1;

% -------------------------------------------------------------------------
%% load path
if 0
    load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD24h_2hStep_Wnz',...
        'Stages','Epochs','h_deb','nameMouse','Dir','Delt','Rips','Spin');
    nameSes={'BSL','SD24h','24+1d'};DataSet='SD24h';
else
    load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD6h_2hStep_Wnz',...
        'Stages','Epochs','h_deb','nameMouse','Dir','Delt','Rips','Spin');
    nameSes={'BSL','SD6h','6h+1d'};DataSet='SD6h';
end
NameEpochs=Stages;
Stages={'WAKE','NREM','N1','N2','N3','REM'};
analyName=[analyName,DataSet];
try
    load(analyName);
    DeltCo;SpinCo;
catch
    % -------------------------------------------------------------------------
    % get REM and NREM episodes
   DeltCo={}; SpinCo={}; RippCo={}; 
   DurCo={};iRbn={};iRbnRv={};
    for man=1:size(Epochs,1)
        for ses=1:length(nameSes)
            
            clear DurPost Ep REM
            Ep=Epochs{man,ses};
            Dt=Delt{man,ses};
            Spi=Spin{man,ses};
            Ri=Rips{man,ses};
            REM=Ep{find(strcmp(NameEpochs,'REM'))};
            REM=mergeCloseIntervals(REM,10*1E4);
            
            sta=Start(REM); sto=Stop(REM);
            DurPost=nan(length(sta),length(Stages)+1);
            DurPost(:,1)=(sto-sta)/1E4; % duration REM (s)
            DeltPost=DurPost;
            SpinPost=DurPost;
            RippPost=DurPost;
            for n=1:length(Stages)
                epoch=Ep{find(strcmp(NameEpochs,Stages{n}))};
                for ss=1:length(sta)
                    try
                        Ipost=intervalSet(sto(ss),sta(ss+1)); % after REM
                        Epost=and(Ipost,epoch);
                        DurPost(ss,n+1)=sum(Stop(Epost,'s')-Start(Epost,'s')); % duration
                        DeltPost(ss,n+1)=length(Range(Restrict(Dt,Epost)));
                        SpinPost(ss,n+1)=length(Range(Restrict(Spi,Epost)));
                        RippPost(ss,n+1)=length(Range(Restrict(Ri,Epost)));
                    end
                end
            end
            DurCo{man,ses}=DurPost;
            DeltCo{man,ses}=DeltPost;
            SpinCo{man,ses}=SpinPost;
            RippCo{man,ses}=RippPost;
            
            I=9-h_deb(man,ses)+2;
            iRbn{man,ses}=find(sta<I*3600*1E4);%0-2h
            iRbnRv{man,ses}=find(sta>(I+12)*3600*1E4 & sta<(I+14)*3600*1E4);
        end
    end
    % save
    save(analyName,'Dir','nameSes','Stages','DurCo','DeltCo','SpinCo','RippCo','iRbn','iRbnRv')   
end


% -------------------------------------------------------------------------
%% display indiv data
col=[0.5 0.2 0.1;0 0 1;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0.1 0.7 0 ;0 0 0];
option='';
%option='Rbn';
%option='RbnRv';
yl=[];
Rythm={'Delt','Spin','Ripp'};
for ry=1:length(Rythm)
    figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.2 0.5 0.5]),numF2(i)=gcf;
    PVAL=nan(size(Epochs,1),length(nameSes),5);RVAL=PVAL;SVAL=PVAL;
    for do=1:2
        if do==1, nameleg='afterREM';else, nameleg='beforeREM';end
        for man=1:size(Epochs,1)
            for n=1:5
                for ses=1:length(nameSes)
                    if ses==1, colo=[0 0 0]; elseif ses==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
                    eval(['M=',Rythm{ry},'Co{man,ses};'])
                    
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
                title({[Rythm{ry},' ',Stages{n},' ',option],nameleg},'Color',col(n,:));
                set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
                if n==1, ylabel({'Corr REM duration','r value'});end
                ylim([-0.6 0.7]);
            else % do slope
                val=squeeze(SVAL(:,:,n));
                subplot(2,5,5+n), PlotErrorBarN(squeeze(val),0);hold on,
                title({[Rythm{i},' ',Stages{n},' ',option],nameleg},'Color',col(n,:));
                for i=1:size(val,2), temp=val(pval(:,i)<0.05,i);  plot(i*ones(length(temp),1)+0.1,temp,'ko','markerfacecolor','b');end
                set(gca, 'Xtick',1:3); set(gca,'XtickLabel',{'BSL','SD','+24h'})
                if n==1, ylabel({'Corr REM duration','slope'});end
                ylim([-0.5 1.2]);
            end
            yl=[yl,min(val(:)),max(val(:))];
        end
        
    end
    for do=1:10, subplot(2,5,do), ylim([min(yl), max(yl)]);end
    if savFig, saveFigure(numF2(ry).Number,sprintf(['Correlation',Rythm{ry},'vsREM_BarIndiv',DataSet,option]),FolderTOsave);end
end

% -------------------------------------------------------------------------
%% display pool data
for ry=1:length(Rythm)
    PVAL=nan(2,length(nameSes),5); RVAL=PVAL; SVAL=PVAL;
    figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.8 0.8]),numF(ry)=gcf;
    for ses=1:length(nameSes)
        M=[];
        for man=1:size(Epochs,1)
            eval(['tempM=',Rythm{ry},'Co{man,ses};'])
            if strcmp(option,'Rbn'),tempM=tempM(iRbn{man,ses},:);end
            if strcmp(option,'RbnRv'),tempM=tempM(iRbnRv{man,ses},:);end
            M=[M;tempM];
        end
        
        for n=1:5
            if ses==1, colo=[0 0 0]; elseif ses==2, colo=col(n,:);else, colo=[0.5 0.5 0.5];end
            for do=1:2
                M1=M(1:end-1,n+1);
                if do==1,M2=M(1:end-1,1);nameleg=[Rythm{ry},' afterREM'];else, M2=M(2:end,1);nameleg=[Rythm{ry},' beforeREM']; end
                
                subplot(4,7,(do-1)*14+n), hold on,
                plot(M1,M2,'.','Color',colo,'MarkerSize',10)
                xlabel({[Stages{n},' #',Rythm{ry}],nameleg},'Color',col(n,:));
                if n==1, ylabel(['REM dur (s)'],'Color',col(6,:)); title([nameleg,' ',option]); end
                
                id=find(M1~=-Inf & M2~=-Inf & ~isnan(M1) & ~isnan(M2));
                M1p=M1(id); M2p=M2(id);
                p= polyfit(M1p,M2p,1);
                [r,pval]=corrcoef(M1p,M2p);
                PVAL(do,ses,n)=pval(1,2);
                RVAL(do,ses,n)=r(1,2);
                SVAL(do,ses,n)=p(1);
                hold on, line([min(M1p),max(M1p)],p(2)+[min(M1p),max(M1p)]*p(1),'Color',colo,'Linewidth',2)
                
                subplot(4,7,(do-1)*14+7+n),
                text(-0.3,1-0.2*ses,sprintf([nameSes{ses},': r=%1.1f, p=%1.3f'],r(1,2),pval(1,2)),'Color',colo);
                axis off
            end
        end
    end
    % Quantify bar plot
    colormap([0 0 0 ; 0 0 1;0.5 0.5 0.5])
    I=[];for n=1:5, if length(nameSes)>1, I=[I,[0.75 1 1.25]+n-1]; else, I=[I,n];end; end
    yl=[];
    for do=1:2
        if do==1, nameleg=[Rythm{ry},' afterREM ',option]; else, nameleg=[Rythm{ry},' beforeREM ',option]; end
        val=squeeze(RVAL(do,:,:));
        pval=squeeze(PVAL(do,:,:));
        if length(nameSes)==1, val=val'; pval=pval';end
        subplot(4,7,(do-1)*14+[6,7,13,14]), bar(val'); hold on,
        set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
        ylabel('r value'); title(nameleg);
        yl=[yl,min(val(abs(val)~=Inf)),max(val(abs(val)~=Inf))];
        if ~isempty(find(pval<0.01)), plot(I(find(pval<0.01)),0.9*min(yl),'*r');end
        legend([nameSes,'P<0.01'],'Location','NorthOutside')
        %      val=squeeze(SVAL(do,:,:));
        %      subplot(2,2,2*(do-1)+2), bar(val');hold on,
        %      set(gca, 'Xtick',1:5); set(gca,'XtickLabel',Stages)
        %      ylabel({'Corr REM duration','slope'});title(nameleg);
        %      if ~isempty(find(pval<0.05)), plot(I(find(pval<0.05)),0.9*min(yl),'*r');end
        %      %yl=[yl,min(val(abs(val)~=Inf)),max(val(abs(val)~=Inf))];
        %      for n=1:5
        %          legtxt=[];
        %          for ses=1:length(nameSes), legtxt=[legtxt,{sprintf('p=%1.3f',pval(ses,n))}];end
        %          text(n-0.5,0.8*max(yl),legtxt);
        %      end
    end
    for do=1:2, subplot(4,7,(do-1)*14+[6,7,13,14]), ylim([min(0,1.1*min(yl)), 1.1*max(yl)]);end
    %subplot(2,2,3),
    
    if savFig, saveFigure(numF(ry).Number,['Correlation',Rythm{ry},'vsREM_',DataSet,option],FolderTOsave);end
end

