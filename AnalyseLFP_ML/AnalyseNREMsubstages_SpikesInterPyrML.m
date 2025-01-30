%AnalyseNREMsubstages_SpikesInterPyrML.m

% list of related scripts in NREMstages_scripts.m


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< LOAD ANALY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
doNew=1;
if doNew
    nameAnaly='Analyse_SpikesNREMStagesNew_3s.mat';
    FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';
else
    nameAnaly='Analyse_SpikesNREMStages_3s.mat';
    FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NeuronFiringRate';
end
%res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
savFig=0;
%colori=[0.5 0.5 0.5;0 0 0 ;0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 0.8 ; 1 0.5 0.8 ;1 0 1  ];
colori=[0 0 1;0.5 0.5 0.8;0.5 0.5 0.5;0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0];

clear AllZTz NeurTyp
try
    load([res,'/',nameAnaly]);
    AllZTz;
    disp([nameAnaly,' has been loaded.'])
catch
    disp('ERROR ! Run AnalyseNREMsubstages_SpikesML.m');
    error('ERROR ! Run AnalyseNREMsubstages_SpikesML.m');
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< Get interneuron / pyramidal <<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ForceRedo=0;

if ~exist('NeurTyp','var') || ForceRedo
    % order mice
    [mice,a,b]=unique(Dir.name);
    orderind=sortrows([1:length(Dir.path);b']',2);
    orderind=orderind(:,1)';
    
    NeurTyp=nan(size(AllN,1),1);
    LNZT=0;
    for man=1:length(Dir.path)
        fol=Dir.path{orderind(man)};
        try cd(fol); catch, fol(strfind(fol,'/Electrophy')+[0:10])=[];end
        disp(' '); disp(fol); cd(fol)
        
        % %%%%%%%%%%%%%%%%%%%%%% GET SPIKES %%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear S nN
        % Get PFCx Spikes
        load('SpikeData.mat','S');
        [S,nN,numtt,TT]=GetSpikesFromStructure('PFCx',S,pwd,1);
        % remove MUA from the analysis
        
        % %%%%%%%%%%%%%%%%%%%%%% GET Inter/Pyr %%%%%%%%%%%%%%%%%%%%%%%%
        if ~exist('MeanWaveform.mat','file')
            [FilenameXml,PathName]=uigetfile('*.xml','Select FilenameXml');
            GetWFInfo(pwd,[PathName,FilenameXml])
        end
        DropBoxLocation=which('AnalyseNREMsubstages_SpikesInterPyrML.m');
        DropBoxLocation=DropBoxLocation(1:strfind(DropBoxLocation,'Kteam')+5);
        clear W BestElec WFMat
        load('MeanWaveform.mat','W','BestElec');
        for s=1:length(nN)
            WFMat(1:32,s)=W{nN(s)}(BestElec{nN(s)},:);
        end
        WfId=SortMyWaveforms(WFMat,DropBoxLocation,0);
        WfId(abs(WfId)==0.5)=NaN;
        
        NeurTyp(LNZT+[1:length(nN)])=WfId;
        LNZT=LNZT+length(nN);
    end
    save([res,'/',nameAnaly],'-append','NeurTyp');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< ZT evol, REM or Wake neurons <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%valZT=[11,12.5;16.5,18];
valZT=[1,2.5;8.5,10];
idZT=find(ismember(timeZT,valZT));
indEp=3:7;
tempName=NamesEp(indEp);
%yl=[-0.25 0.55];
yl=[-0.18 0.28];
for i=1:3
    if i==1,
        indNeu=1:length(NeurTyp); nameNeur='ALL NEURONS';
    elseif i==2
        indNeu=find(NeurTyp==1); nameNeur='PYRAMIDAL NEURONS';
    else
        indNeu=find(NeurTyp==-1); nameNeur='INTERNEURONS';
    end
    
    if 1
        MAT=AllNz(:,indEp);
        %MAT=zscore(10*ppAllN(:,indEp)')';
        [BE,idx]=max(MAT');
        
        B=MAT; for b=1:size(B,1),B(b,idx(b))=nan;end
        [BE,idx2]=max(B'); clear Didx
        for b=1:size(MAT,1),Didx(b)=100*MAT(b,idx2(b))/MAT(b,idx(b));end
        
        nEp=[tempName,{'All'}];
        for n=1:5
            temp=find(idx==n & Didx<75);
            lis{i,n}=temp(ismember(temp,indNeu));
        end
        lis{i,n+1}=indNeu;
    else
        [BE,idx]=max(AllNz(:,indEp)');
        nEp=[tempName,{'All'}];
        for n=1:5
            temp=find(idx==n);
            lis{i,n}=temp(ismember(temp,indNeu));
        end
        lis{i,n+1}=indNeu;
    end
    if 0
        figure('Color',[1 1 1])
        for Nn=1:size(lis,2)
            idN=lis{i,Nn};
            if ~isempty(idN)
                AA=squeeze(AllZTz(idN,indEp(n),:));
                MatHz=10*ppAllN(:,indEp);
            end
        end
    end
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0 0 0.95 1.2]), numF(i)=gcf;
    clear matbar matbarSD
    for Nn=1:size(lis,2)
        idN=lis{i,Nn};
        if ~isempty(idN)
            clear matbar matbarSD
            if length(idN)>15, leg={'Ttest2: '};else, leg={'RankSum: '};end
            for n=1:length(tempName)
                
                AA=squeeze(AllZTz(idN,indEp(n),:));
                tempZT1=nanmean(AA(:,idZT(1):idZT(2)-1),2);
                tempZT2=nanmean(AA(:,idZT(3):idZT(4)-1),2);
                matbar(1,n)=nanmean(tempZT1);
                matbarSD(1,n)=stdError(tempZT1);
                matbar(2,n)=nanmean(tempZT2);
                matbarSD(2,n)=stdError(tempZT2);
                
                %tempChg(n,:)=tempZT2-tempZT1;
                
                subplot(5,length(nEp),Nn),hold on,
                errorbar(timeZT(3:end-3),nanmean(AA(:,3:end-2)),stdError(AA(:,3:end-2)),'Color',colori(indEp(n),:),'Linewidth',3)
                ylabel('zscore FR'); xlabel('ZT Time (h)'); xlim([min(timeZT),max(timeZT)])
                ylim(yl); set(gca,'Xtick',1:2:11);                
                
                % stats
                [H,p]=ttest2(tempZT1,tempZT2);
                if length(idN)<=15, p=ranksum(tempZT1,tempZT2);end
                if p<0.05, tempLeg=sprintf(['* ',tempName{n},' : p=%1.3f, '],p); else, tempLeg=sprintf([tempName{n},' : p=%1.3f, '],p);end
                
                % Spierman 
                aa=ones(size(AA,1),1)*timeZT;
                x=aa(~isnan(AA));y=AA(~isnan(AA));
                [r,p]=corr(x,y,'type','Spearman');
                if p<0.05, tempLeg2=sprintf(['     * spearman r=%1.2f, p=%1.3f, '],r,p); else, tempLeg2=sprintf(['     spearman r=%1.2f, p=%1.3f, '],r,p); end
                 leg=[leg,tempLeg,tempLeg2];
                
            end
            %Chg{i,Nn}=
            
            if Nn==1, title(nameNeur); if i==1, legend(tempName);end; end
            subplot(5,length(nEp),length(nEp)+Nn), hold on,
            bar(matbar');ylabel('zscore FR');
            errorbar([[1:length(tempName)]-0.15;[1:length(tempName)]+0.15]',matbar',matbarSD','+k')
            ylim(yl*0.8); xlim([0 length(tempName)+1]);
            set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
            if Nn==1 && i==1, legend({sprintf('%1.1f-%1.1fh',timeZT(idZT(1)),timeZT(idZT(2))),...
                    sprintf('%1.1f-%1.1fh',timeZT(idZT(3)),timeZT(idZT(4)))}); end
            subplot(5,length(nEp),2*length(nEp)+Nn),text(0,0.5,leg,'FontSize',6); axis off
        end
        subplot(5,length(nEp),length(nEp)+Nn),title(sprintf([nEp{Nn},' (n=%d)'],length(idN)))
        
        subplot(5,length(nEp),3*length(nEp)+Nn), PlotErrorBar(MAT(idN,:),0);
        title({['max in ',nEp{Nn}], ['(n=',num2str(length(idN))]}); 
        set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
        xlim([0 length(tempName)+1]);ylim([-0.16 0.28])
        if i==1,ylabel('FR zscore');end
        % stats
        legt={'ttest'};legr={'ranksum'};
        for n1=1:length(tempName)
            for n2=n1+1:length(tempName)
                [H,p]=ttest2(MAT(idN,n1),MAT(idN,n2));
                legt=[legt,sprintf([tempName{n1},' vs ',tempName{n2},': p=%1.3f, '],p)];
                p=ranksum(MAT(idN,n1),MAT(idN,n2));
                legr=[legr,sprintf([tempName{n1},' vs ',tempName{n2},': p=%1.3f, '],p)];
            end
        end
        %subplot(2,length(nEp),length(nEp)+i), text(0,0.5,[legt,' ',legr]); axis off
        subplot(5,length(nEp),4*length(nEp)+Nn), text(0,0.5,legt,'FontSize',6); axis off
    end
    colormap gray
    if savFig, saveFigure( numF(i).Number,['AnalyseNREM-ZTEvolFRzPerGroups-',nameNeur(1:3)],FolderToSave);end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< ZT evol, pyr high or low <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
fract=1/4;

valZT=[10,11;17,18];
idZT=find(ismember(timeZT,valZT));
indEp=3:7;
tempName=NamesEp(:,indEp);

pp=1; %% pp=1 normal, 2 poisson, 3 decreasing poisson, 4 increasing poisson
if 0
    ppAllN=PAllN{pp,1};
    ppZTz=PAllZT{pp,2};
else
    ppAllN=AllN;
    ppZTz=AllZT;
end

MAT=zscore(10*ppAllN(:,indEp)')';
clear lis

indNeu=find(NeurTyp==1);
[BE,idx]=sort(nanmean(10*ppAllN(:,indEp),2));
idx=idx(find(ismember(idx,[indNeu]))); 
% weak FR
lis{1}=idx(1:ceil(fract*length(idx)));

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< ZT evol, pyr high or low <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

fract=1/4;

%valZT=[10,11;17,18];
valZT=[1,2.5;8.5,10];
idZT=find(ismember(timeZT,valZT));
indEp=3:7; %substages
%indEp=[3 4 2]; %WAKE REM NREM only
tempName=NamesEp(:,indEp);

pp=1; %% pp=1 normal, 2 poisson, 3 decreasing poisson, 4 increasing poisson
dozscore=1;
if dozscore
    ppAllN=PAllN{pp,1};
    ppZTz=PAllZT{pp,2};
    ytit='zscore FR';
    yl=[-0.13 0.22];
else
    ppAllN=AllN;
    ppZTz=AllZT;
    ytit='FR (Hz)';
    yl=[-0.2 1];    
end
MAT=zscore(10*ppAllN(:,indEp)')';
clear lis

indNeu=find(NeurTyp==1);
[BE,idx]=sort(nanmean(10*ppAllN(:,indEp),2));
idx=idx(find(ismember(idx,[indNeu]))); 
% weak FR
lis{1}=idx(1:ceil(fract*length(idx)));
fr1=nanmean(10*ppAllN(lis{1},find(strcmp(NamesEp,'WAKE')))); 
% High FR
lis{2}=idx(length(idx)-ceil(fract*length(idx))+1:length(idx));
fr2=nanmean(10*ppAllN(lis{2},find(strcmp(NamesEp,'WAKE'))));
% all
lis{3}=idx;
fr3=nanmean(10*ppAllN(lis{3},find(strcmp(NamesEp,'WAKE'))));

indNeu=find(NeurTyp==-1); 
[BE,idx]=sort(nanmean(10*ppAllN(:,indEp),2));
idx=idx(find(ismember(idx,[indNeu]))); 
% weak FR
lis{4}=idx(1:ceil(fract*length(idx)));
fr4=nanmean(10*ppAllN(lis{4},find(strcmp(NamesEp,'WAKE'))));
% High FR
lis{5}=idx(length(idx)-ceil(fract*length(idx))+1:length(idx)); 
fr5=nanmean(10*ppAllN(lis{5},find(strcmp(NamesEp,'WAKE'))));
%all
lis{6}=idx;
fr6=nanmean(10*ppAllN(lis{6},find(strcmp(NamesEp,'WAKE'))));

nEp={sprintf('PYR weak FR av=%1.1fHz',fr1),sprintf('PYR High FR av=%1.1fHz',fr2),sprintf('PYR All FR av=%1.1fHz',fr3),...
   sprintf('INT weak FR av=%1.1fHz',fr4),sprintf('INT High FR av=%1.1fHz',fr5),sprintf('INT All FR av=%1.1fHz',fr6) };
    
    
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.9 0.8]), numF=gcf;
clear matbar matbarSD
for Nn=1:length(lis)
    idN=lis{Nn};
    clear matbar matbarSD 
    leg={'Ttest2: '};
    for n=1:length(tempName)
        AA=squeeze(ppZTz(idN,indEp(n),:));
        
        tempZT1=nanmean(AA(:,idZT(1):idZT(2)-1),2);
        tempZT2=nanmean(AA(:,idZT(3):idZT(4)-1),2);
        matbar(1,n)=nanmean(tempZT1);
        matbarSD(1,n)=stdError(tempZT1);
        matbar(2,n)=nanmean(tempZT2);
        matbarSD(2,n)=stdError(tempZT2);
        
        subplot(3,length(nEp),Nn),hold on,
        errorbar(timeZT(3:end-3),nanmean(AA(:,3:end-2)),stdError(AA(:,3:end-2)),'Color',colori(indEp(n),:),'Linewidth',2)
        ylabel(ytit); xlabel('ZT Time (h)'); xlim([min(timeZT),max(timeZT)])
        ylim(yl); 
        set(gca,'Xtick',1:2:11);
        % stats
        %[H,p]=ttest(tempZT1,tempZT2);
        p=ranksum(tempZT1,tempZT2);
        if p<0.05, leg=[leg,sprintf(['* ',tempName{n},' : p=%1.3f, '],p)]; else, leg=[leg,sprintf([tempName{n},' : p=%1.3f, '],p)];end
        
        % Spierman
        aa=ones(size(AA,1),1)*timeZT(1:end-1);
        x=aa(~isnan(AA));y=AA(~isnan(AA));
        [r,p]=corr(x,y,'type','Spearman');
        if p<0.05, leg=[leg,sprintf(['     * spearman r=%1.2f, p=%1.3f, '],r,p)]; else, leg=[leg,sprintf(['     spearman r=%1.2f, p=%1.3f, '],r,p)]; end
    
        if n==1 title({nEp{Nn}(1:11),sprintf([nEp{Nn}(12:end),' (n=%d)'],length(idN))});end
    end
    if Nn==length(lis), legend(tempName); end
    subplot(3,length(nEp),length(nEp)+Nn), hold on, 
    bar(matbar');ylabel('zscore FR');
    errorbar([[1:length(tempName)]-0.15;[1:length(tempName)]+0.15]',matbar',matbarSD','+k')
    xlim([0.5 0.5+length(tempName)]); ylim(yl); 
    set(gca,'Xtick',1:length(indEp)),set(gca,'XtickLabel',tempName);set(gca,'XtickLabelRotation',45); 
    if Nn==1, legend({sprintf('%1.1f-%1.1fh',timeZT(idZT(1)),timeZT(idZT(2))),...
        sprintf('%1.1f-%1.1fh',timeZT(idZT(3)),timeZT(idZT(4)))}); end
    subplot(3,length(nEp),2*length(nEp)+Nn),text(0,0.4,leg,'FontSize',6); axis off
end
colormap gray
if savFig, saveFigure(numF.Number,'AnalyseNREM-ZTEvolFRzHighLow',FolderToSave);end
    


%% quantify repartition of neuron types

clear matbar matbar2
for Nn=1:5
    matbar(Nn,1:2)=100*[length(lis{2,Nn}),length(lis{3,Nn})]/length(lis{1,Nn});
    matbar(Nn,3)=100-sum(matbar(Nn,1:2));
    matbar2(1,Nn)=length(lis{2,Nn}); % pyr
    matbar2(2,Nn)=length(lis{3,Nn}); % interneurons
end
figure('Color',[1 1 1])
subplot(1,2,1)
bar(matbar,'stacked'); colormap gray
set(gca,'Xtick',1:5); set(gca,'XtickLabel',tempName)
legend({'Pyr','Int','?'})
subplot(1,2,2); 
bar(100*matbar2./(sum(matbar2,2)*ones(1,5)),'stacked'); colormap gray
set(gca,'Xtick',1:2); set(gca,'XtickLabel',{'PyrN','IntN'})
legend(tempName,'Location','BestOutside'); title('% neurons')


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< FR, FRzscore, ZT evol, neurons type <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
valZT=[1,2.5;8.5,10]; 
idZT=find(ismember(timeZT,valZT));
indEp=2:4; % pour julier
%indEp=3:7;
tempName=NamesEp(indEp);
%yl=[-0.25 0.55];
yl=[-0.18 0.28];
clear lis
lis{1}=1:length(NeurTyp);
lis{2}=find(NeurTyp==1);
lis{3}=find(NeurTyp==-1);
nameN={'ALL','PYRAMIDAL','INTERNEURONS'};
figure('Color',[1 1 1],'Unit','Normalized','Position',[0 0 0.95 1.2]), numF(i)=gcf;

for Nn=1:size(lis,2)
    idN=lis{Nn};
    clear matFR matFRz
    for n=1:length(tempName)
        matFR(1:length(idN),n)=10*AllN(idN,indEp(n));
        matFRz(1:length(idN),n)=AllNz(idN,indEp(n));
    end
    
    subplot(3,length(lis),Nn),boxplot(log10(matFR));ylim(log10([0.001 120]))
    set(gca,'Ytick',log10([0.01,0.1 1 10 100])),set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    title(sprintf(['neuron ',nameN{Nn},' (n=%d)'],length(idN)))
    
    subplot(3,length(lis),length(lis)+Nn),bar(nanmean(matFR));%
    hold on, errorbar(1:length(indEp),nanmean(matFR),stdError(matFR),'+k')
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    if Nn==1, ylabel('FR (Hz)');end
    %PlotErrorBarN_KJ
    pval=nan(4,4); stats = []; groups = cell(0);
    for c1=1:length(indEp), for c2=c1+1:length(indEp)
            try,idx=find(~isnan(matFR(:,c1)) & ~isnan(matFR(:,c2)));
                [h,p]= ttest(matFR(idx,c1),matFR(idx,c2)); pval(c1,c2)=p; pval(c2,c1)=p;
                if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
            end; end;end
    stats(stats>0.05)=nan; sigstar(groups,stats)
    
    subplot(3,length(lis),2*length(lis)+Nn),bar(nanmean(matFRz,1));%
    hold on, errorbar(1:length(indEp),nanmean(matFRz),stdError(matFRz),'+k')
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    if Nn==1, ylabel('FR (zscore)');end
    %PlotErrorBarN_KJ
    pval=nan(4,4); stats = []; groups = cell(0);
    for c1=1:length(indEp), for c2=c1+1:length(indEp)
            try,idx=find(~isnan(matFRz(:,c1)) & ~isnan(matFRz(:,c2)));
                [h,p]= ttest(matFRz(idx,c1),matFRz(idx,c2)); pval(c1,c2)=p; pval(c2,c1)=p;
                if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
            end; end;end
    stats(stats>0.05)=nan; sigstar(groups,stats)
end

if savFig, saveFigure(numF.Number,'AnalyseNREM-FRPyrInt',FolderToSave);end
