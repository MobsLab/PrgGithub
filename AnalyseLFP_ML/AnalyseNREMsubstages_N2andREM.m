% AnalyseNREMsubstages_N2andREM.m
%
% list of related scripts in NREMstages_scripts.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GET DIRECTORIES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0 0 0];
i_merge=30; % in sec, 10s default
i_drop=10; % in sec, 10s default
savFig=0;
Stages={'WAKE','NREM','N1','N2','N3','REM'};

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< CorrelationN2-REM <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
temp1=load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD24h_2hStep_Wnz',...
    'Stages','Epochs','h_deb','nameMouse','Dir');
nameSes1={'BSL','SD24h','24+1d'};
temp2=load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD6h_2hStep_Wnz',...
    'Stages','Epochs','h_deb','nameMouse','Dir');
nameSes2={'BSL','SD6h','6h+1d'};

%Stages={'WAKE','REM','N1','N2','N3',...};
Do='N3';
%Do='N2';
if strcmp(Do,'N2'), Ndo=4; elseif strcmp(Do,'N3'), Ndo=5;end


figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.7 0.6]),numF=gcf;
colo=[0 0 0; 0 0 1; 0.5 0.5 0.5];
for i=1:2
    eval(sprintf('temp=temp%d; nameSes=nameSes%d; Stages=temp%d.Stages;',i,i,i))
    for pp=1:2,
        if pp==1, Np=8;else Np=7;end
        MATrbnN=nan(size(temp.Epochs,1),size(temp.Epochs,2),length(temp.Stages));
        MATrbnR=MATrbnN;
        for man=1:size(temp.Epochs,1)
            for ses=1:size(temp.Epochs,2)
                % rebound epochs
                if i==1, RebndN3=intervalSet(0,2*3600*1E4);end % first 2h of day
                if i==2, RebndN3=intervalSet(6*3600*1E4,(6+2)*3600*1E4);end % post SD6h
                debNight=(9-temp.h_deb(man,ses)+12)*3600;
                if i==1, RebndREM=intervalSet(debNight*1E4,(debNight+2*3600)*1E4);end % first 2h of night
                if i==2, RebndREM=intervalSet((debNight+2*3600)*1E4,(debNight+4*3600)*1E4);end
                Ep=temp.Epochs{man,ses};
                TotN=and(RebndN3,Ep{Np});
                DurRebndN=sum(Stop(TotN,'s')-Start(TotN,'s'));
                TotR=and(RebndREM,Ep{Np});
                DurRebndR=sum(Stop(TotR,'s')-Start(TotR,'s'));
                
                for n=1:5
                    IN=and(Ep{n},RebndN3);
                    MATrbnN(man,ses,n)=100*sum(Stop(IN,'s')-Start(IN,'s'))/DurRebndN;
                    IR=and(Ep{n},RebndREM);
                    MATrbnR(man,ses,n)=100*sum(Stop(IR,'s')-Start(IR,'s'))/DurRebndR;
                end
            end
        end
        
        subplot(2,3,3*(pp-1)+1), hold on,
        for ses=1:size(temp.Epochs,2)
            MATN=squeeze(MATrbnN(:,ses,Ndo));
            MATR=squeeze(MATrbnR(:,ses,2));
            if i==1, plot(MATN,MATR,'.','Color',colo(ses,:),'MarkerSize',14);end
            if i==2, plot(MATN,MATR,'o','Color',colo(ses,:),'MarkerSize',5);end
            xlabel({['Duration ',Do,' in dayRebound'],['(%',Stages{Np},')']})
            ylabel({'Duration REM in nightRebound',['(%',Stages{Np},')']})
        end
        if i==2 && pp==1,legend([nameSes1,nameSes2],'Location','Best');end
        
        for ses=1:2
            subplot(2,3,3*(pp-1)+2), hold on,
            MATN=log(squeeze(MATrbnN(:,ses+1,Ndo))./squeeze(MATrbnN(:,1,Ndo)));
            MATR=log(squeeze(MATrbnR(:,ses+1,2))./squeeze(MATrbnR(:,1,2)));
            if i==1, plot(MATN,MATR,'.','Color',colo(ses+1,:),'MarkerSize',14);end
            if i==2, plot(MATN,MATR,'o','Color',colo(ses+1,:),'MarkerSize',5);end
            
            id=find(abs(MATN)~=Inf & abs(MATR)~=Inf & ~isnan(MATN) & ~isnan(MATR));
            x=MATN(id); y=MATR(id);
            p= polyfit(x,y,1); [r,pval]=corrcoef(x,y);
            if i==1, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colo(ses+1,:));end
            if i==2, line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'LineStyle','--','Color',colo(ses+1,:));end
            subplot(2,3,3*(pp-1)+3), hold on,
            text(0.1,(ses+2*i)*0.1,sprintf([nameSes{ses+1},' : r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colo(ses+1,:));
        end
        axis off
        subplot(2,3,3*(pp-1)+2), xlabel({['Duration ',Do,' in dayRebound'],'(log norm BSL)'})
        ylabel({'Duration REM in nightRebound','(log norm BSL)'})
        line(xlim,[0 0],'Color','k'); line([0 0],ylim,'Color','k')
    end
end
if savFig, saveFigure(numF.Number,['CorrelationRebounds',Do,'vsREM_SD'],FolderTOsave);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< CorrelationN2-REM <<<<<<<<<<<<<<<<<<<<<<<<<<
edit NREMstages_N2CorREM;
edit NREMstages_N2CrossCorREM;
edit NREMstages_DeltaCorREM;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< Cumulative curves <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% SleepStages = tsd (WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=4.5)
for mi=1:4
    figure('Color',[1 1 1],'unit','normalized','Position',[0.1 0.1 0.8 0.8]); numF(mi)=gcf;
    for man=1:3
        
        cd(Dir{mi,man}); disp(Dir{mi,man})
        nameMice{mi}=Dir{mi,man}(strfind(Dir{mi,man},'Mouse')+[0:7]);
        [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
        
        val=[4,3,2,1.5,1,20];
        dt=Data(SleepStages);
        rg=Range(SleepStages,'s');
        
        id1=min(find(dt==3));
        id2=max(find(dt==3));
        rgM=rg(id1:id2);
        dtM=dt(id1:id2);
        
        for n=1:length(NamesStages)%+1
            dtn=zeros(length(dt),1);
            dtn(dt==val(n))=1;
            dtMn=zeros(length(dtM),1);
            dtMn(dtM==val(n))=1;
            if n==1, dtn(dt==4.5)=1;dtMn(dtM==4.5)=1;end % add noise
            %if n==length(NamesStages)+1,dtn(ismember(dt,[2,1.5,1]))=1;dtMn(ismember(dtM,[2,1.5,1]))=1;end
            CumStage{mi,man,n}=tsd(rg*1E4,cumsum(dtn));
            
            subplot(3,3,1+3*(man-1)), hold on,
            plot(rg/3600,cumsum(dtn),'Linewidth',2,'Color',colori(n,:));
            ylabel({'Cumulative duration','(s)'});
            if man>2, xlabel('Time (h)');end
            title(tit{man})
            
%             subplot(3,3,1+3*(man-1)), hold on,
%             plot(rg/3600,cumsum(dtn)/sum(dtn),'Linewidth',2,'Color',colori(n,:))
%             ylabel({'Cumulative duration','(norm)'});
%             if man>2, xlabel('Time (h)');end
            
            subplot(3,3,2+3*(man-1)), hold on,
            plot(rgM/3600,cumsum(dtMn)/sum(dtMn),'Linewidth',2,'Color',colori(n,:))
            ylabel({'Cumulative duration','(norm, first REM to last REM)'});
            if man>2, xlabel('Time (h)');end
            title(Dir{mi,man})
            
            dtR=Data(Restrict(CumStage{mi,man,n},REM));
            rgR=Range(Restrict(CumStage{mi,man,n},REM),'s');
%             subplot(3,3,3+3*(man-1)), hold on,
%             plot([1:length(rgR)]*mean(diff(rg))/3600,cumsum(dtR),'Linewidth',2,'Color',colori(n,:))
%             ylabel({'Cumulative duration','(s, restrict to REM period)'});
%             if man>2, xlabel('Time (h)');end
            
            subplot(3,3,3+3*(man-1)), hold on,
            plot([1:length(rgR)]*mean(diff(rg))/3600,cumsum(dtR)/sum(dtR),'Linewidth',2,'Color',colori(n,:))
            ylabel({'Cumulative duration','(norm, restrict to REM period)'});
            if man>2, xlabel('Time (h)');end
            
        end
    end
    %legend({NamesStages{:},'NREM'})
    legend(NamesStages)
    saveFigure(numF(mi).Number,['cumSum_N2-REM_',nameMice{mi}],FolderTOsave)
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< MUAtransition <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir=PathForExperimentsDeltaSleepNew('BASAL');
Dir=RestrictPathForExperiment(Dir,'nMice',[244 251 243]);
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
Isleepstg=[4 3 2 1.5 1];

for man=1:length(Dir.path)
   %man=1;
    cd(Dir.path{man}); disp(' '); disp(Dir.path{man});
    clear WAKE REM N1 N2 N3 S ST QS dQS
    [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages(0);close
    % SleepStages = tsd (WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=4.5)
    
    % SleepStg
    SleepStg=[];
    for n=1:length(NamesStages)
        eval(['epoch=',NamesStages{n},';'])
        SleepStg=[SleepStg;[Start(epoch,'s'),Stop(epoch,'s'),Isleepstg(n)*ones(length(Start(epoch)),1)]];
    end
    [B,id]=sort(SleepStg(:,1));
    SleepStg=SleepStg(id,:);
    A=[SleepStg,[0;SleepStg(1:end-1,3)]];
    
    % get neurons
    [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
    nN=numNeurons;
    for s=1:length(numNeurons)
        if TT{numNeurons(s)}(2)==1, nN(nN==numNeurons(s))=[]; end
    end
    QS = MakeQfromS(S,150*10); dQS=full(Data(QS));
    T=PoolNeurons(S,nN);
    ST{1}=T;ST=tsdArray(ST);
    Q = MakeQfromS(ST,150*10);
    Q=tsd(Range(Q),full(Data(Q)));
    
    % display
    tbins=12;nbbins=300;
    dozscore=1;
    ind=find(A(:,3)==3 & A(:,4)==1.5); % N2->REM
    [ma1,sa1,tpsa1]=mETAverage(Range(ts(A(ind,1)*1E4)), Range(Q),Data(Q),tbins,nbbins);
    %ma=mETAverage(Range(ts(A(ind,1)*1E4)), Range(QS),zscore(dQS(:,nN(ss))),tbins,nbbins);
    
    colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.4 0 0.8 ;1 0.6 0.8; 0.9 0.3 0.9 ; 0 0 0];
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.8]),
    subplot(3,5,1:5),plot(tpsa1,ma1,'linewidth',2),
    hold on, plot(tpsa1,smooth(ma1,20),'linewidth',4, 'Color','r'),
    line([0 0],ylim,'Color','k','linewidth',2)
    xlabel('Time (ms)'); title('MUA at N2-REM transition')
    
    for n=1:length(NamesStages)
        eval(['epoch=',NamesStages{n},';'])
        Atemp=A(find(A(:,3)==3 & A(:,4)==Isleepstg(n)),:); % n-> REM
        MAT=nan(length(nN),nbbins+1);MAT2=MAT;
        for ss=1:length(nN)
            if dozscore
                ma=mETAverage(Range(ts(Start(epoch))), Range(QS),zscore(dQS(:,nN(ss))),tbins,nbbins);
                ma2=mETAverage(Range(ts(Atemp(:,1)*1E4)), Range(QS),zscore(dQS(:,nN(ss))),tbins,nbbins);
            else
                ma=mETAverage(Range(ts(Start(epoch))), Range(QS),dQS(:,nN(ss)),tbins,nbbins);
                ma2=mETAverage(Range(ts(Atemp(:,1)*1E4)), Range(QS),dQS(:,nN(ss)),tbins,nbbins);
            end
            MAT(ss,:)=ma';
            MAT2(ss,:)=ma2';
        end
        MAT3=[nanmean(MAT(:,1:nbbins/2),2),nanmean(MAT(:,nbbins/2+1:end),2)];
        [B,id]=sort(MAT3(:,2)-MAT3(:,1));
        subplot(3,5,5+n), imagesc(tpsa1,1:length(nN),MAT(id,:)); caxis([-0.5 1])
        title(sprintf(['all -> ',NamesStages{n},' (%d)'],length(Start(epoch))),'Color',colori(n,:))
        line([0 0],ylim,'Color','k')
        if n==1, if dozscore, ylabel({'#neuron - zscore FR','sorted by FR change'});else ylabel({'#neuron - FR','sorted by FR change'}); end; end
        
        MAT3=[nanmean(MAT2(:,1:nbbins/2),2),nanmean(MAT2(:,nbbins/2+1:end),2)];
        [B,id]=sort(MAT3(:,2)-MAT3(:,1));
        subplot(3,5,10+n), imagesc(tpsa1,1:length(nN),MAT2(id,:)); caxis([-0.5 1])
        title([NamesStages{n},' -> REM'],'Color',colori(n,:))
        title(sprintf([NamesStages{n},' -> REM (%d)'],length(Atemp(:,1))),'Color',colori(n,:))
        line([0 0],ylim,'Color','k')
        if n==1, if dozscore, ylabel({'#neuron - zscore FR','sorted by FR change'});else ylabel({'#neuron - FR','sorted by FR change'}); end; end
%         MAT2=[nanmean(MAT(:,1:nbbins/2),2),nanmean(MAT(:,nbbins/2+1:end),2)];
%         [B,id]=sort(MAT2(:,2)-MAT2(:,1));
%         subplot(3,5,10+n), imagesc(tpsa1,1:length(nN),MAT(id,:)); 
%         title(['all -> ',NamesStages{n}],'Color',colori(n,:))
%         line([0 0],ylim,'Color','k')
%         if n==1, if dozscore, ylabel({'#neuron - zscore FR','sorted by FR change'});else ylabel({'#neuron - FR','sorted by FR change'}); end; end
    end
    xlabel('Time (ms)')
    numF(man)=gcf;
    saveFigure(numF(man).Number,sprintf(['MUAtransition%d_',Dir.name{man}],man),FolderTOsave)
end

%% 
Dir=PathForExperimentsDeltaSleepNew('BASAL');
Dir=RestrictPathForExperiment(Dir,'nMice',[244 251 243]);
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';
try
    load([FolderTOsave,'/AnalyseNREMsubstages_N2andREM.mat'])
    Mat;
catch
    Dur=nan(length(Dir.path),1000);
    for man=1:length(Dir.path)
        %man=1;
        cd(Dir.path{man}); disp(' '); disp(Dir.path{man});
        clear WAKE REM N1 N2 N3 S ST QS dQS TT
        [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
        NREM=or(or(N1,N2),N3); mergeCloseIntervals(NREM,10);
        total=or(WAKE,NREM); mergeCloseIntervals(total,10);
        
        [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
        nN=numNeurons;
        for s=1:length(numNeurons)
            if TT{numNeurons(s)}(2)==1, nN(nN==numNeurons(s))=[]; end
        end
        QS = MakeQfromS(S,150*10); dQS=tsd(Range(QS),full(Data(QS)));
        
        sta=Start(REM);
        sto=Stop(REM);
        for a=1:length(sta)-1
            I=intervalSet(sto(a),sta(a+1));
            Irem=subset(REM,a);
            
            for n=1:length(NamesStages)
                eval(['epoch=',NamesStages{n},';'])
                ep=and(epoch,I);
                
                D1=nan(size(Data(dQS),2),100);
                dt1=Restrict(dQS,ep);rg1=Range(dt1);
                try D1=Data(Restrict(dt1,ts(min(rg1)+ [1:100]*(max(rg1)-min(rg1))/100)))';end
                
                D2=nan(size(Data(dQS),2),100);
                dt2=Restrict(dQS,Irem);rg2=Range(dt2);
                try D2=Data(Restrict(dt2,ts(min(rg2)+ [1:100]*(max(rg2)-min(rg2))/100)))';end
                
                Mat{man,a,n}=[D1(nN,:),D2(nN,:)];
            end
        end
        Dur(man,1:length(sta))=(sto-sta)/1E4;
    end
    save([FolderTOsave,'/AnalyseNREMsubstages_N2andREM.mat'],'Mat','Dir','NamesStages','Dur')
end

%man=1;
for man=1:length(Dir.path)
    [L1,L2]=size(Mat{man,1,1});
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.3]),numF1=gcf;
    for n=1:length(NamesStages)
        a=1;
        MatSum=nan(L1,L2);
        while a<=size(Mat,2) & size(Mat{man,a,n})==[L1,L2]
            id = find(~isnan(Mat{man,a,n}));
            tempMatSum=MatSum; tempMatSum(isnan(tempMatSum))=0;
            MatSum(id)=tempMatSum(id)+Mat{man,a,n}(id);
            a=a+1;
        end
        subplot(1,5,n), imagesc(zscore(MatSum')')
        title([NamesStages{n},' - REM'])
        set(gca,'Xtick',[0.5 100 200]); set(gca,'XtickLabel',[-1 0 1])
        if n==1, xlabel('normalized time       '); ylabel('#neuron');end
        if n==3, xlabel({'  ',Dir.path{man}});end
    end
    saveFigure(numF1.Number,sprintf(['SpikNormStages%d_',Dir.name{man}],man),FolderTOsave)
    
    for n=1:length(NamesStages)
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.8]), numF2=gcf;
        a=1;
        clear MatNeuron
        for ss=1:L1, MatNeuron{ss}=Mat{man,a,n}(ss,:);end
        while a<=size(Mat,2) & size(Mat{man,a,n})==[L1,L2]
            for ss=1:L1
                MatNeuron{ss}=[MatNeuron{ss};Mat{man,a,n}(ss,:)];
            end
            a=a+1;
        end
        
        drm=Dur(man,~isnan(Dur(man,:)))';
        [B,id]=sort(drm);
        for ss=1:L1
            subplot(ceil(sqrt(L1)),ceil((L1+1)/ceil(sqrt(L1))),ss),
            imagesc(MatNeuron{ss}(id,:));
            set(gca,'Xtick',[0.5 100 200]); set(gca,'XtickLabel',[-1 0 1])
            if ss==1, title([NamesStages{n},' - REM']), ylabel({'# REM episod','sorted by duration'})
            elseif ss==L1, xlabel('normalized time'), text(0,-4,sprintf('Neuron #%d',ss))
            else,text(0,-4,sprintf('#%d',ss))
            end
            if ss==2, text(0,-length(drm)/3,Dir.path{man});end
        end
        subplot(ceil(sqrt(L1)),ceil((L1+1)/ceil(sqrt(L1))),ss+1),
        imagesc(drm(id)); colorbar
        title('Duration REM (s)');  set(gca,'Xtick',[0.5 100 200]); set(gca,'XtickLabel',[-1 0 1])
        saveFigure(numF2.Number,sprintf(['SpikNormStages%d_',Dir.name{man},'_',NamesStages{n}],man),FolderTOsave)
    end
    
    close all;
end
%%

Dir=PathForExperimentsDeltaSleepNew('BASAL');
Dir=RestrictPathForExperiment(Dir,'nMice',[244 251 243]);
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';

 Stages={'WAKE','NREM','N1','N2','N3','REM'};
 colori=[0.5 0.2 0.1 ;0 0 0.7; 0.4 0 0.8 ;1 0.6 0.8; 0.9 0.3 0.9;0 0 0];
i_merge=30; % in sec, default 10 ?
Dur={};
for man=1:length(Dir.path)
    %man=1;
    cd(Dir.path{man}); disp(' '); disp(Dir.path{man});
    clear WAKE REM N1 N2 N3 S ST QS dQS TT
    [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
    REM=mergeCloseIntervals(REM,i_merge*1E4); % close REM
    N1=N1-REM; N2=N2-REM; N3=N3-REM;
    NREM=or(or(N1,N2),N3); mergeCloseIntervals(NREM,10);
    total=or(WAKE,NREM); mergeCloseIntervals(total,10);
    
    sto=Stop(WAKE);
    sta=[max(sto(find(sto<min(Start(REM)))));Stop(REM)];
    tempDur=nan(length(sta)-1,length(Stages));
    for a=1:length(sta)-1
        I=intervalSet(sta(a),sta(a+1));
        for n=1:length(Stages)
            eval(['epoch=',Stages{n},';'])
            ep=and(epoch,I);
            tempDur(a,n)=sum(Stop(ep,'s')-Start(ep,'s'));
        end
    end
    Dur{man}=tempDur;
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.8]), numF2=gcf;
    for n=1:length(Stages)
        subplot(3,length(Stages),n),
        A=tempDur;
        if n<length(Stages), A(:,[1:n-1,n+1:end-1])=nan; else, A(:,2)=nan; end
        barh(A,'Stacked');axis ij; 
        if n==1; ylabel({'#cycle','sorted by ZT'});colormap(colori); xlabel('Duration (s)'); end
        if n==length(Stages), legend(Stages); title('All') ;end
        
        subplot(3,length(Stages),length(Stages)+n),
        [B,iB]=sort(A(:,end));
        barh(A(iB,:),'Stacked');axis ij; 
        if n==1; ylabel({'#cycle','sorted by REM duration'}); xlabel('Duration (s)');end
        
        B=tempDur; B(:,[1:n-1,n+1:end])=nan;
        subplot(3,length(Stages),2*length(Stages)+n),
        barh(B(iB,:),'Stacked');axis ij; 
        if n==1; ylabel({'#cycle','sorted by REM duration'}); xlabel('Duration (s)');end
        title(Stages{n},'Color',colori(n,:))
        if n==3, xlabel({sprintf('REM merged if closer than %ds',i_merge),Dir.path{man}});end
    end
    saveFigure(numF2.Number,sprintf(['REMdurStages%d_',Dir.name{man},'merge%ds'],man,i_merge),FolderTOsave)
end

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<< Correlation dur REM and spikes <<<<<<<<<<<<<<<<<<<<<<
Dir=PathForExperimentsDeltaSleepNew('BASAL');
Dir=RestrictPathForExperiment(Dir,'nMice',[244 251 243]);
FolderTOsave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_N2andREM';

for man=1%:length(Dir.path)
    
    cd(Dir.path{man}); disp(' '); disp(Dir.path{man});
    clear WAKE REM N1 N2 N3 S ST QS dQS TT
    [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
    NREM=or(or(N1,N2),N3); mergeCloseIntervals(NREM,10);
    total=or(WAKE,NREM); mergeCloseIntervals(total,10);
    
    [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
    nN=numNeurons;
    for s=1:length(numNeurons)
        if TT{numNeurons(s)}(2)==1, nN(nN==numNeurons(s))=[]; end
    end
    
    sta=Start(REM);
    sto=Stop(REM);
    for ss=1:length(nN);
        spik=S{nN(ss)};
        Mat=nan(length(sta),1);
        for a=1:length(sta)-1
            I=intervalSet(sto(a),sta(a+1));
            Irem=subset(REM,a);
            for n=1:length(NamesStages)
                eval(['epoch'])
            end
        end
    end
end






















