% AnalyseNREMsubstagesdKOML.m
%
% see also
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% CaracteristicsSubstagesML.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstagesDKO';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages';
savFig=0; clear MATEP Dir
%

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir=PathForExperimentsML('BASAL');
Dir=RestrictPathForExperiment(Dir,'Group',{'WT','dKO'});
%Dir=RestrictPathForExperiment(Dir,'Group','dKO');




%% AnalyseNREMsubstages_SpectrumML
res2='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
d_ko=load([res2,'/Analyse_meanSpectrumNREMStages_dKO.mat'],'Fsamp','MATOB','MATPF','MATHP','Dir','NamesStages');
d_wt=load([res2,'/Analyse_meanSpectrumNREMStages.mat'],'Fsamp','MATOB','MATPF','MATHP','Dir','NamesStages');

FigFolder='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FiguresDKO/';
do_indiv=1;
savFig=1;

namestruct={'OB','PF','HP'};
Fsamp=d_wt.Fsamp;
Stages=d_wt.NamesStages;
%miceWT=unique(d_wt.Dir.name(~strcmp(d_wt.Dir.group,'WT'))); nameFig='KOvsCTRL';
miceWT=unique(d_wt.Dir.name(strcmp(d_wt.Dir.group,'WT'))); nameFig='KOvsWT';
miceKO=unique(d_ko.Dir.name);
colori=[0.5 0.2 0.1; 0.1 0.7 0 ;0.7 0.2 1;1 0.6 1 ;0.8 0 0.7 ;0.5 0.5 0.5; 1 0 0];
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.8]), numF=gcf;
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.8]), indivF=gcf;
for n=1:5
    for i=1:3
        clear MATko MATwt nwt nko
        eval(['MATko=d_ko.MAT',namestruct{i},';']);
        eval(['MATwt=d_wt.MAT',namestruct{i},';']);
    
        MiWT=nan(length(miceWT),length(Fsamp));
        for mi=1:length(miceWT)
            ind=find(strcmp(miceWT{mi},d_wt.Dir.name));
            if ind==1
                MiWT(mi,:)=nanmean(squeeze(MATwt(ind,n,:))',1);
            else
                MiWT(mi,:)=nanmean(squeeze(MATwt(ind,n,:)),1);
            end
            if do_indiv, 
                figure(indivF), subplot(3,5,5*(i-1)+n), hold on,
                plot(Fsamp,MiWT(mi,:),'Color','k');
            end
        end
        
        MiKO=nan(length(miceKO),length(Fsamp));
        for mi=1:length(miceKO)
            ind=find(strcmp(miceKO(mi),d_ko.Dir.name));
            if ind==1
                MiKO(mi,:)=nanmean(squeeze(MATko(ind,n,:))',1);
            else
                MiKO(mi,:)=nanmean(squeeze(MATko(ind,n,:)),1);
            end
            if do_indiv, 
                plot(Fsamp,MiKO(mi,:),'Color',colori(n,:));
            end
        end
        
        nwt=sum(isnan(nanmean(MiWT(:,1:end-1),2))==0);
        nko=sum(isnan(nanmean(MiKO(:,1:end-1),2))==0);
        
        if do_indiv,
            title([namestruct{i},' ',Stages{n}],'Color',colori(n,:));
            xlim([0 19]); ylim([0 3E5]); if i==1,ylim([0 12E5]); end
            if i==3, xlabel('Frequency (Hz)');end
            if n==1, ylabel([namestruct{i},' power']);end
            if n==1, legend({sprintf('WT n=%d',nwt),sprintf('dKO n=%d',nko)});end
        end
        
        figure(numF), subplot(3,5,5*(i-1)+n), hold on,
        plot(Fsamp,nanmean(MiWT,1),'Color','k','Linewidth',2)
        plot(Fsamp,nanmean(MiKO,1),'Color',colori(n,:),'Linewidth',2)
        plot(Fsamp,nanmean(MiWT,1)+nanstd(MiWT)/sqrt(sum(~isnan(nanmean(MiWT,2)))),'Color','k')
        plot(Fsamp,nanmean(MiWT,1)-nanstd(MiWT)/sqrt(sum(~isnan(nanmean(MiWT,2)))),'Color','k')
        plot(Fsamp,nanmean(MiKO,1)+nanstd(MiKO)/sqrt(sum(~isnan(nanmean(MiKO,2)))),'Color',colori(n,:))
        plot(Fsamp,nanmean(MiKO,1)-nanstd(MiKO)/sqrt(sum(~isnan(nanmean(MiKO,2)))),'Color',colori(n,:))
        
        title([namestruct{i},' ',Stages{n}],'Color',colori(n,:)); 
        xlim([0 19]); ylim([0 3E5]); if i==1,ylim([0 12E5]); end
        if i==3, xlabel('Frequency (Hz)');end
        if n==1, ylabel([namestruct{i},' power']);end
        if n==1, legend({sprintf('WT n=%d',nwt),sprintf('dKO n=%d',nko)});end
        
    end
end
if savFig
    saveFigure(numF,['NREMmeanSpectrum',nameFig],FigFolder), 
    saveFigure(numF,['NREMmeanSpectrum',nameFig,'-indiv'],FigFolder), 
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<

res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%nameStructure='PFCx_deep';yl=[0 1.6E5];
nameStructure='Bulb_deep';yl=[0 1.5E6];

D_ko=load([res,'/',['AnalySubstagesEvolSlow_dKO_',nameStructure,'.mat']]);
D_wt=load([res,'/',['AnalySubstagesEvolSlow_',nameStructure,'.mat']]);

if 0 %zscore
    MATwt=D_wt.MATz;
    MATko=D_ko.MATz;
    yl=[-1 1.2];
else
    MATwt=D_wt.MAT;
    MATko=D_ko.MAT;
end

ZTA=D_wt.ZTh(1:end-1);
NamesEp=D_wt.NamesEp;
ZTanaly=D_wt.ZTanaly;
%miwt=unique(D_wt.Dir.name);
miwt=unique(D_wt.Dir.name(strcmp(D_wt.Dir.group,'WT')));
miko=unique(D_ko.Dir.name);
id1=find(ZTA>=ZTanaly(1)*3600 & ZTA<ZTanaly(2)*3600);
id2=find(ZTA>=ZTanaly(3)*3600 & ZTA<ZTanaly(4)*3600);
colori=[0.5 0.2 0.1;0.5 0.5 0.5; 1 0 0; 0.1 0.7 0 ;0.7 0.2 1;1 0.6 1 ;0.8 0 0.7 ];

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.8])
clear Matbar MatbarP MatbarSD
for n=1:length(NamesEp)
    
    
    if 1 % pool mice
        tempwt=nan(length(miwt),size(MATwt,3));
        for mi=1:length(miwt)
            temp=squeeze(MATwt(:,n,:));
            tempwt(mi,:)=nanmean(MATwt(strcmp(D_wt.Dir.name,miwt{mi}),n,:),1);
        end
        tempko=nan(length(miwt),size(MATko,3));
        for mi=1:length(miko)
            temp=squeeze(MATko(:,n,:));
            tempko(mi,:)=nanmean(MATko(strcmp(D_ko.Dir.name,miko{mi}),n,:),1);
        end
    else
        tempwt=squeeze(MATwt(:,n,:));
        tempko=squeeze(MATko(:,n,:));
    end
    
    nwt=sum(isnan(nanmean(tempwt(:,1:end-1),2))==0);
    nko=sum(isnan(nanmean(tempko(:,1:end-1),2))==0);
    
    subplot(4,length(NamesEp),n), hold on,
    plot(ZTA/3600,smooth(nanmean(tempwt,1),3),'Color','k','Linewidth',2)
    plot(ZTA/3600,smooth(nanmean(tempwt,1)+stdError(tempwt),3),'Color','k')
    plot(ZTA/3600,smooth(nanmean(tempwt,1)-stdError(tempwt),3),'Color','k')
    
    plot(ZTA/3600,smooth(nanmean(tempko,1),3),'Color',colori(n,:),'Linewidth',2)
    plot(ZTA/3600,smooth(nanmean(tempko,1)+stdError(tempko),3),'Color',colori(n,:))
    plot(ZTA/3600,smooth(nanmean(tempko,1)-stdError(tempko),3),'Color',colori(n,:))
    
    title(NamesEp{n},'Color',colori(n,:)); xlim([11 18]); ylim(yl)
    if n==1, ylabel(['2-4Hz ',nameStructure]);end
    
    A=[nanmean(tempwt(:,id1),2),nanmean(tempwt(:,id2),2)];
    B=[nanmean(tempko(:,id1),2),nanmean(tempko(:,id2),2)];
    Matbar(n,:)=[nanmean(A(:,1)),nanmean(A(:,2)),nanmean(B(:,1)),nanmean(B(:,2))];
    MatbarSD(n,:)=[stdError(A(:,1)),stdError(A(:,2)),stdError(B(:,1)),stdError(B(:,2))];
    a=find(~isnan(A(:,1)) & ~isnan(A(:,2)));
    b=find(~isnan(B(:,1)) & ~isnan(B(:,2)));
    
    %[h,Matbar(n,5)]= ttest2(A(a,1),A(a,2));
    [MatbarP(n,1),h]= signrank(A(a,1),A(a,2));
    [MatbarP(n,2),h]= signrank(B(b,1),B(b,2));
    [MatbarP(n,3),h]= ranksum(A(:,1),B(:,1));
    [MatbarP(n,4),h]= ranksum(A(:,2),B(:,2));
    
    subplot(4,length(NamesEp),length(NamesEp)+n), hold on,
    PlotErrorBarN(A,0,1); title({'WT',sprintf('p=%1.3f',MatbarP(n,1))});ylim(yl)
    set(gca,'Xtick',1:2);set(gca,'XtickLabel',{'ZT1','ZT2'})
    
    subplot(4,length(NamesEp),2*length(NamesEp)+n), hold on,
    PlotErrorBarN(B,0,1); title({'dKO',sprintf('p=%1.3f',MatbarP(n,2))});ylim(yl)
    set(gca,'Xtick',1:2);set(gca,'XtickLabel',{'ZT1','ZT2'})
    
    C=[nanmean(A,1);nanmean(B,1)];
    subplot(4,length(NamesEp),3*length(NamesEp)+n), hold on,
    hold on, bar(C);ylim(yl); xlim([0.5 2.5]);colormap('pink')
    errorbar([0.85,1.15,1.85,2.15],[C(1,:),C(2,:)],[stdError(A),stdError(B)],'k+');
    set(gca,'Xtick',1:2);set(gca,'XtickLabel',{sprintf('WT,n=%d',nwt),sprintf('dKO,n=%d',nko)})
    if n==length(NamesEp),legend({'ZT1','ZT2'});end
    if n==4, xlabel(sprintf('ZT1 = %1.1fh-%1.1fh, ZT2 = %1.1fh-%1.1fh',ZTanaly(1),ZTanaly(2),ZTanaly(3),ZTanaly(4)));end
    
    text(1.85,1.1*C(2,1),sprintf('p=%1.3f',MatbarP(n,3)),'Color',[MatbarP(n,3)<0.05 0 0])
    text(2.15,1.1*C(2,2),sprintf('p=%1.3f',MatbarP(n,4)),'Color',[MatbarP(n,4)<0.05 0 0])

end
%%

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.6])
for n=1:length(NamesEp)
    
    for i=1:2 % ZT1 et ZT2
        wt1=squeeze(D_wt.MATsp(:,n,i,:));
        ko1=squeeze(D_ko.MATsp(:,n,i,:));
        nwt=sum(isnan(nanmean(wt1,2))==0);
        nko=sum(isnan(nanmean(ko1,2))==0);
        
        subplot(2,length(NamesEp),length(NamesEp)*(i-1)+n),
        %WT
        plot(Fsamp,nanmean(wt1,1),'Color','k','Linewidth',2)
        plot(Fsamp,nanmean(wt1,1)+stdError(wt1),'Color','k')
        plot(Fsamp,nanmean(wt1,1)-stdError(wt1),'Color','k')
        %dKO
        plot(Fsamp,nanmean(ko1,1),'Color',colori(n,:),'Linewidth',2)
        plot(Fsamp,nanmean(ko1,1)+stdError(ko1),'Color',colori(n,:))
        plot(Fsamp,nanmean(ko1,1)-stdError(ko1),'Color',colori(n,:))
        
        title(sprintf([NamesEp{n},' (%dWT/%dKO)'],nwt,nko),'Color',colori(n,:))
        xlim([0 10]); if n==4, xlabel('Frequency (Hz)');end
    end
    
end




