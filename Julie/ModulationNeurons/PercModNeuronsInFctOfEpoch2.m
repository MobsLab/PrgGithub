% PercModNeuronsInFctOfEpoch2

%consider all manip (EXT 24 and 48) for all mice : 
cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/SpkModulAllPer_AllManipOfMice_244-241-258-259-299')


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
for bf=1:2
    BandFq=BandFqList{bf};
    
    for e=1:length(EpochNameList)
        figure('Position', [1973  196  973  743])
        EpochName=EpochNameList{e};
        
        for r=1:length(LFPregionlist)
            LFPregion=LFPregionlist{r};

            load(['SpkModul_'  BandFq '_' LFPregion(1:4)  '_' EpochName '_' suffix '.mat'])
            
            K1=KappaAll_allmice;
            K1=K1(~isnan(K1));
            PV1=pvalAll_allmice;
            PV1=PV1(~isnan(PV1));
            for r2=1:length(LFPregionlist)
                
                if~(r==r2)
                    subplot(3,3,3*(r2-1)+r)
                    LFPregion2=LFPregionlist{r2};
                    load(['SpkModul_'  BandFq '_' LFPregion2(1:4)  '_' EpochName '_' suffix '.mat'])
                    K2=KappaAll_allmice;
                    K2=K2(~isnan(K2));
                    PV2=pvalAll_allmice;
                    PV2=PV2(~isnan(PV2));
                    
                    %plot(K1,K2,'.', 'Color',colori{r2}), hold on
                    
                    plot(K1(PV1<sig ),K2(PV1<sig),'.', 'Color',colorP{2}), hold on
                    plot(K1(PV2<sig ),K2(PV2<sig),'.', 'Color',colorP{3}), hold on
                    plot(K1(PV1<sig & PV2<sig ),K2(PV1<sig &PV2<sig ),'.', 'Color',colorP{1}), hold on
                    
                    xlabel(LFPregionlist{r})
                    ylabel(LFPregionlist{r2})
                    xlim([0 0.25]), ylim([0 0.25]), 
                    line([0 0.25],[0 0.25],'LineStyle','--','Color',[0.8 0.8 0.8])%[0.9 0.9 0.9]
                    set(gca,'XTick',[0 0.25],'YTick',[])

                    [r1,p1]=corrcoef(K1(PV1<sig & PV2<sig),K2(PV1<sig & PV2<sig));
                    title([ 'p ' sprintf('%.3f',(p1(1,2))) '  R ' sprintf('%.3f',(r1(1,2)))]);
                    pf1= polyfit(K1(~isnan(K1)),K2(~isnan(K2)),1);
                    %line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color',colori{r2},'Linewidth',1)
                    line([min(K1),max(K1)],pf1(2)+[min(K1),max(K1)]*pf1(1),'Color','k','Linewidth',1)
                    
                    
                    if r==1&&r2==2
                       text(0,2.2,[EpochNameList{e} ' - ' BandFq], 'units','normalized')
                    end
                end


            end

        end
    saveas(gcf,['Mod_Corr_'  BandFq '_' EpochName '.fig'])
    saveFigure(gcf,['Mod_Corr_'  BandFq '_' EpochName],pwd)
    end
    

end


