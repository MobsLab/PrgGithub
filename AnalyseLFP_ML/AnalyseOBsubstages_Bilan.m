% AnalyseOBsubstages_Bilan.m
%
% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m

%% PATHs
Dir1=PathForExperimentsBULB('SLEEPBasal');
Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
Dir2=PathForExperimentsML('BASAL');%'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB';
Dir2=RestrictPathForExperiment(Dir2,'Group',{'WT','C57'});
Dir=MergePathForExperiment(Dir1,Dir2);

strains=unique(Dir.group);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%% FiguresDataClub8juin2015.m %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot & quantif spectrum high (gamma) and low


FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
FileToSave='/media/DataMOBsRAID/ProjetAstro/GammaBulbSleepML/AnalyseCompareGamma';
savFig=0;
colori=[0.7 0.2 0.1; 1 0 1;0.1 0.7 0];
nameEp={'Wake','SWS','REM'};
% load previsou data
load(FileToSave);

% ------------------ pool same mice -----------
mice=unique(MatInfo(:,2));
mice([find(mice==147),find(mice==148),find(mice==161)])=[];

% ------------------ plot mean high spectrum -----------
MATH=nan(3,length(mice),length(FH)); 
MATL=MATH; MatBarH=[]; MatBarL=[];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.7]), 
for nn=1:length(nameEp)
    for mi=1:length(mice)
        index=find(MatInfo(:,2)==mice(mi));
        eval(['MATH(nn,mi,:)=nanmean(MatSpH',nameEp{nn}(1),'(index,:));']);
        eval(['MATL(nn,mi,:)=nanmean(MatSpL',nameEp{nn}(1),'(index,:));']);
        tempH=squeeze(MATH(nn,mi,:));
        tempL=squeeze(MATL(nn,mi,:));
        MatBarH(mi,nn)=nanmean(tempH(find(FH>30 & FH<90)));
        MatBarL(mi,nn)=nanmean(tempL(find(FL>2 & FL<4)));
    end
    subplot(2,4,1:2), hold on, 
    tempL=squeeze(MATL(nn,:,:));
    plot(FL,(FL.*nanmean(tempL)),'Color',colori(nn,:),'Linewidth',2)
    subplot(2,4,3:4), hold on, 
    tempH=squeeze(MATH(nn,:,:));
    plot(FH,(FH.*nanmean(tempH)),'Color',colori(nn,:),'Linewidth',2)
end
legend(nameEp)
for nn=1:length(nameEp)
    subplot(2,4,1:2), hold on, 
    tempL=squeeze(MATL(nn,:,:));
    plot(FL,(FL.*nanmean(tempL)+FL.*stdError(tempL)),'Color',colori(nn,:))
    plot(FL,(FL.*nanmean(tempL)-FL.*stdError(tempL)),'Color',colori(nn,:))
    subplot(2,4,3:4), hold on, 
    tempH=squeeze(MATH(nn,:,:));
    plot(FH,(FH.*nanmean(tempH)+FH.*stdError(tempH)),'Color',colori(nn,:))
    plot(FH,(FH.*nanmean(tempH)-FH.*stdError(tempH)),'Color',colori(nn,:))
end
xlabel('Frequency(Hz)'); ylabel('FT Amplitude (normed by 1/f)')
title(['n = ',num2str(length(mice)),', High spectrum of Bulb deep'])
xlim([min(FH),max(FH)])
subplot(2,4,1:2),title('Low spectrum of Bulb deep')
xlabel('Frequency(Hz)'); ylabel('FT Amplitude (normed by 1/f)')
xlim([min(FL),max(FL)])

% --------------- PlotErrorBarN & ttest ------------------
for f=1:2
    if f==1
        MatBar=MatBarL; tit='OB averaged spectum gamma (60-90Hz)';
    else
        MatBar=MatBarH;tit='OB averaged spectum delta (2-4Hz)';
    end
    subplot(2,4,4+2*f-1), hold on,
    PlotErrorBarN(MatBar,0,1);
    set(gca,'Xtick',1:3), set(gca,'XtickLabel',nameEp)
    leg={'  ','ttest'};
    for nn=1:length(nameEp)
        for n2=nn+1:length(nameEp)
            a=find(~isnan(MatBar(:,nn)) & ~isnan(MatBar(:,n2)));
            [h,p]= ttest2(MatBar(a,nn),MatBar(a,n2));
            %[p,h]= signrank(MatBar(a,nn),MatBar(a,n2));
            nexpe=length(a);
            leg=[leg,sprintf([nameEp{nn},' vs ',nameEp{n2},': n=%d, p=%1.4f'],nexpe,p)];
        end
    end
    title(leg); ylabel(tit)
end
% ------------------ bar plot & ranksum ------------------
for f=1:2
    if f==1
        MatBar=MatBarL; tit='OB averaged spectum gamma (60-90Hz)';
    else
        MatBar=MatBarH;tit='OB averaged spectum delta (2-4Hz)';
    end
    subplot(2,4,4+2*f), hold on,
    bar(nanmean(MatBar)); errorbar(nanmean(MatBar),stdError(MatBar),'+k')
    set(gca,'Xtick',1:3), set(gca,'XtickLabel',nameEp)
    leg={'  ','ranksum'};
    for nn=1:length(nameEp)
        for n2=nn+1:length(nameEp)
            a=find(~isnan(MatBar(:,nn)) & ~isnan(MatBar(:,n2)));
            %[h,p]= ttest2(MatBar(a,nn),MatBar(a,n2));
            [p,h]= signrank(MatBar(a,nn),MatBar(a,n2));
            nexpe=length(a);
            leg=[leg,sprintf([nameEp{nn},' vs ',nameEp{n2},': n=%d, p=%1.4f'],nexpe,p)];
        end
    end
    title(leg); ylabel(tit)
end


% ------------------ save figure -------------
if savFig
    saveFigure(gcf,'AnalyseOB-DeltaGammaQuantifSpectr',FolderToSave)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Araki et al 1980

cd /home/mobsyoda/Dropbox/MOBs_ProjetBulbe/ProjetASTRO
load('Araki1980.mat')

figure('Color',[1 1 1])
for n=1:length(NamesVar)
    subplot(2,4,n),hold on,  
    bar([MAT(n,[1 3 5]);MAT(n,[7 9 11])]');
    errorbar([[1:3]-0.15;[1:3]+0.15]',[MAT(n,[1 3 5]);MAT(n,[7 9 11])]',[MAT(n,[2 4 6]);MAT(n,[8 10 12])]','+k')
    ylabel(NamesVar{n}) 
    set(gca,'Xtick',1:3), set(gca,'XtickLabel',NamesCond)
end
legend('Sham','OB')
edit AnalyseOBsubstages_Bilan.m

figure('Color',[1 1 1])
for i=1:3
    subplot(1,3,i), hold on,
    bar(MAT(1:3,[2*i-1,2*i+5])','stacked')
    set(gca,'Xtick',1:2), 
    set(gca,'XtickLabel',{'Sham','OB'})
    title(NamesCond{i}); ylabel('duration in 24h rec (min)')
end
legend({'Wake','SWS','REM'})











