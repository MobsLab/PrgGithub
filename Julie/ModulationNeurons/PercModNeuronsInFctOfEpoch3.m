% PercModNeuronsInFctOfEpoch3
% 03.02.2016
% question : Est-ce que les neurones modulés par le bulbe sont aussi modulés par le PFC ?

LFPregionlist={'PFCx_deep','Bulb_deep','dHPC_rip'};
EpochNameList={'Freez';'NoFreez'};%;'TotEp';'NoFreez'
strongperonly=0;
FreqRange =[2 6];
lim2 =[0.5 1];
lim3 =[8 10];
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];


if strongperonly==0
    suffix='AllPer';
elseif strongperonly==1
    suffix=['StrO-' BandFq];
end

BandFqList={'2-6', '6-12'};
percfigbymouse=figure('Position', [  1928 264  411   688]);
suffix='AllPer';
colori={'r';'b';'c'};%[0.5 0.5 0.5]};
colorP={[1 0 0];[0.8 0.7 0]; [0 0.8 1]}; % rouge, orange bleu clair
sig=0.05;
if 1

for bf=1:2
    BandFq=BandFqList{bf};
    
    
        figure('Position', [1973  196  973  743])
        %%%%%%%%%%%%% Freezing%%%%%%%%%%%%%
        e=1;
        EpochName=EpochNameList{e};
        
        for r=1:length(LFPregionlist)
            LFPregion=LFPregionlist{r};

            load(['SpkModul_'  BandFq '_' LFPregion(1:4)  '_' EpochName '_' suffix '.mat'])
            
            K1=KappaAll_allmice;
            K1=K1(~isnan(K1));
            PV1=pvalAll_allmice;
            PV1=PV1(~isnan(PV1));
            for r2=r:length(LFPregionlist)
                
                if~(r==r2)
                    subplot(3,3,3*(r2-1)+r)
                    LFPregion2=LFPregionlist{r2};
                    load(['SpkModul_'  BandFq '_' LFPregion2(1:4)  '_' EpochName '_' suffix '.mat'])
                    K2=KappaAll_allmice;
                    K2=K2(~isnan(K2));
                    PV2=pvalAll_allmice;
                    PV2=PV2(~isnan(PV2));
                    
                    %plot(K1,K2,'.', 'Color',colori{r2}), hold on
                    
                    plot(K1(PV1<sig ),K2(PV1<sig),'o', 'Color',colorP{2},'MarkerFaceColor',colorP{2}), hold on
                    plot(K1(PV2<sig ),K2(PV2<sig),'o', 'Color',colorP{3},'MarkerFaceColor',colorP{3}), hold on
                    plot(K1(PV1<sig & PV2<sig ),K2(PV1<sig &PV2<sig ),'o', 'Color',colorP{1},'MarkerFaceColor',colorP{1}), hold on
                    
                    xlabel(LFPregionlist{r}(1:4))
                    ylabel(LFPregionlist{r2}(1:4))
                    xlim([0 0.25]), ylim([0 0.25]), 
                    line([0 0.25],[0 0.25],'LineStyle','--','Color',[0.8 0.8 0.8])%[0.9 0.9 0.9]
                    set(gca,'XTick',[0 0.25],'YTick',[])

                    [r1,p1]=corrcoef(K1(PV1<sig & PV2<sig),K2(PV1<sig & PV2<sig));
                    title([ 'p ' sprintf('%.3f',(p1(1,2))) '  R ' sprintf('%.3f',(r1(1,2)))]);
                    pf1= polyfit(K1(~isnan(K1)),K2(~isnan(K2)),1);
                    %line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color',colori{r2},'Linewidth',1)
                    line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color','k','Linewidth',1)
                    
                    
                    if r==1&&r2==2
                       text(-0.1,1.2,[EpochNameList{e} ' - ' BandFq], 'units','normalized')
                    end
                end
            end

        end
        %%%%%%%%%%%%% NO Freezing  %%%%%%%%%%%%%
        e=2;
        EpochName=EpochNameList{e};
        
        for r=1:length(LFPregionlist)
            LFPregion=LFPregionlist{r};

            load(['SpkModul_'  BandFq '_' LFPregion(1:4)  '_' EpochName '_' suffix '.mat'])
            
            K1=KappaAll_allmice;
            K1=K1(~isnan(K1));
            PV1=pvalAll_allmice;
            PV1=PV1(~isnan(PV1));
            
            for r2=r:length(LFPregionlist)
                
                if~(r==r2)
                    subplot(3,3,3*(r-1)+r2)
                    LFPregion2=LFPregionlist{r2};
                    load(['SpkModul_'  BandFq '_' LFPregion2(1:4)  '_' EpochName '_' suffix '.mat'])
                    K2=KappaAll_allmice;
                    K2=K2(~isnan(K2));
                    PV2=pvalAll_allmice;
                    PV2=PV2(~isnan(PV2));
                    
                    %plot(K1,K2,'.', 'Color',colori{r2}), hold on
                    
                    plot(K1(PV1<sig ),K2(PV1<sig),'o', 'Color',colorP{2},'MarkerFaceColor',colorP{2}), hold on
                    plot(K1(PV2<sig ),K2(PV2<sig),'o', 'Color',colorP{3},'MarkerFaceColor',colorP{3}), hold on
                    plot(K1(PV1<sig & PV2<sig ),K2(PV1<sig &PV2<sig ),'o', 'Color',colorP{1},'MarkerFaceColor',colorP{1}), hold on
                    
                    xlabel(LFPregionlist{r}(1:4))
                    ylabel(LFPregionlist{r2}(1:4))
                    xlim([0 0.25]), ylim([0 0.25]), 
                    line([0 0.25],[0 0.25],'LineStyle','--','Color',[0.8 0.8 0.8])%[0.9 0.9 0.9]
                    set(gca,'XTick',[0 0.25],'YTick',[])

                    [r1,p1]=corrcoef(K1(PV1<sig & PV2<sig),K2(PV1<sig & PV2<sig));
                    title([ 'p ' sprintf('%.3f',(p1(1,2))) '  R ' sprintf('%.3f',(r1(1,2)))]);
                    pf1= polyfit(K1(~isnan(K1)),K2(~isnan(K2)),1);
                    %line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color',colori{r2},'Linewidth',1)
                    line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color','k','Linewidth',1)
                    
                    
                    if r==1&&r2==2
                       text(-0.1,1.2,[EpochNameList{e} ' - ' BandFq], 'units','normalized')
                    end
                end
            end

        end
        
    saveas(gcf,['Mod_Corr_BtwStt_'  BandFq '.fig'])
    saveFigure(gcf,['Mod_Corr_BtwStt_'  BandFq ],pwd)
    end
end

LFPregionlist={'Bulb_deep','PFCx_deep','dHPC_rip'};
% X1=[0.8:1:3-0.2];
% X2=[1.2:1:3+0.2];
X1=[0.85:1:3-0.15];
X2=[1.15:1:3+0.15];
%Fcolor={[0 0 0];[0 0.8 0.4]};

Fcolor={[0 0 0.5 ];[0.5 0 0]};
hbar=figure('Position', [1973         114         535         825]);
for bf=1:2
    BandFq=BandFqList{bf};
    
    KappaTable=nan(length(EpochNameList),length(LFPregionlist));
    
        hscatter=figure('Position', [  1973         629        1129         310]);
        
        %%%%%%%%%%%%% Freezing%%%%%%%%%%%%%
        
        
        for r=1:length(LFPregionlist)
            LFPregion=LFPregionlist{r};
            
            
            e=1;
            EpochName=EpochNameList{e};
            load(['SpkModul_'  BandFq '_' LFPregion(1:4)  '_' EpochName '_' suffix '.mat'])
            K1=KappaAll_allmice;
            PV1=pvalAll_allmice;
            
            e=2;
            EpochName=EpochNameList{e};
            load(['SpkModul_'  BandFq '_' LFPregion(1:4)  '_' EpochName '_' suffix '.mat'])
            K2=KappaAll_allmice;
            PV2=pvalAll_allmice;
            
            K1(PV1>sig&PV2>sig)=NaN;% non-modulated neurons (in both F -noF) are removed
            K2(PV1>sig&PV2>sig)=NaN;
            
            K1_nonan=K1((~isnan(K1))&(~isnan(K2)));
            K2_nonan=K2((~isnan(K1))&(~isnan(K2)));
            K1=K1_nonan;
            K2=K2_nonan;
            
            KappaTable(1,r)=nanmean(K1);
            KappaTable(2,r)=nanmean(K2);
            KappaTable_sem(1,r)=nanstd(K1)/sqrt(size(K1,1));
            KappaTable_sem(2,r)=nanstd(K2)/sqrt(size(K2,1));
            p_mw{r,bf}=ranksum(K1,K2);
            
            figure(hscatter)
            subplot(1,length(LFPregionlist),r)
            plot(K1,K2,'o', 'Color',colori{r},'MarkerFaceColor',colori{r}), hold on
%             plot(K1(PV1<sig ),K2(PV1<sig),'.', 'Color',colori{r}), hold on
%             plot(K1(PV2<sig ),K2(PV2<sig),'.', 'Color',colori{r}), hold on
%             plot(K1(PV1<sig & PV2<sig ),K2(PV1<sig &PV2<sig ),'.', 'Color',colori{r}), hold on

            xlabel(EpochNameList{1})
            ylabel(EpochNameList{2})
            xlim([0 0.25]), ylim([0 0.25]), 
            line([0 0.25],[0 0.25],'LineStyle','--','Color',[0.8 0.8 0.8],'LineWidth',2)%[0.9 0.9 0.9]
            set(gca,'XTick',[0 0.25],'YTick',[0 0.25])
            title(LFPregion);

            [r1,p1]=corrcoef(K1,K2);
            %[r1,p1]=corrcoef(K1(PV1<sig & PV2<sig),K2(PV1<sig & PV2<sig));
            if ~isnan(p1(1,2))
                title([ 'p ' sprintf('%.3f',(p1(1,2))) '  R ' sprintf('%.3f',(r1(1,2)))]);
            end
            %pf1= polyfit(K1(~isnan(K1)),K2(~isnan(K2)),1);
            pf1= polyfit(K1,K2,1);
            %line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color',colori{r2},'Linewidth',1)
            %line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color',colori{r},'Linewidth',1)
            
            if r==1
                text(-0.2,1.05,[BandFq 'Hz'], 'units','normalized')
            end
            
        end
    saveas(hscatter,['Mod_Corr_F-noF_'  BandFq '.fig'])
    saveFigure(hscatter,['Mod_Corr_F-noF_'  BandFq ],pwd)
    figure(hbar)
    subplot(2,1,bf)
    %bar([X1;X2]',KappaTable'), hold on
    hh=bar(KappaTable'); hold on

    set(hh(1),'FaceColor',Fcolor{1})
    set(hh(2),'FaceColor',Fcolor{2})
    
    errorbar(X1',KappaTable(1,:)',KappaTable_sem(1,:)','k','LineStyle', 'none');
    errorbar(X2',KappaTable(2,:)',KappaTable_sem(2,:)','k','LineStyle', 'none');
    
    set(gca,'XTickLabel',LFPregionlist)
    ylabel(['Kappa  (n = ' num2str(size(K2,1)) ')' ])
    title([BandFqList{bf} 'Hz'])
    if bf==1,legend(EpochNameList),end
end

 saveas(hbar,'Kappa_F_no-F.fig')
 saveFigure(hbar,'Kappa_F_no-F',pwd)
 save Kappa_F_no-F_stats p_mw
 

