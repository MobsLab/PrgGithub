

clear all
SleepInfo = GetSleepSessions_Drugs_BM;
Drug_Group= {'Saline','DZP'};

for drug = 1:2
    for mouse = 1:length(SleepInfo.path{drug})
        cd(SleepInfo.path{drug}{mouse})
        try
            clear Epoch_Drugs Wake SWSEpoch REMEpoch Sleep
            load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'Wake', 'SWSEpoch', 'REMEpoch', 'Sleep')
            Sleep = mergeCloseIntervals(Sleep , 2e4);
            Sleep = dropShortIntervals(Sleep , 20e4);
            Wake = mergeCloseIntervals(Wake , 2e4);
            Wake = dropShortIntervals(Wake , 5e4);
            Epoch_Drugs{2} = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+80*60e4);
            Wake_prop{drug}(mouse) = sum(DurationEpoch(and(Wake , Epoch_Drugs{2})))./sum(DurationEpoch(Epoch_Drugs{2}));
            REM_prop{drug}(mouse) = sum(DurationEpoch(and(REMEpoch , Epoch_Drugs{2})))./sum(DurationEpoch(and(Sleep , Epoch_Drugs{2})));
            
            LateEpoch = intervalSet(Start(Epoch_Drugs{2})+80*60e4 , Start(Epoch_Drugs{2})+180*60e4);
            Wake_prop_late{drug}(mouse) = sum(DurationEpoch(and(Wake , LateEpoch)))./sum(DurationEpoch(LateEpoch));
            REM_prop_late{drug}(mouse) = sum(DurationEpoch(and(REMEpoch , LateEpoch)))./sum(DurationEpoch(and(Sleep , LateEpoch)));
            
            for bin=1:15
                SmallEp = intervalSet(Start(Epoch_Drugs{2})+(bin-1)*20*60e4 , Start(Epoch_Drugs{2})+bin*20*60e4);
                Wake_prop_bin{drug}(mouse,bin) = sum(DurationEpoch(and(Wake , SmallEp)))./sum(DurationEpoch(SmallEp));
                REM_prop_bin{drug}(mouse,bin) = sum(DurationEpoch(and(REMEpoch , SmallEp)))./sum(DurationEpoch(SmallEp));
                NREM_prop_bin{drug}(mouse,bin) = sum(DurationEpoch(and(SWSEpoch , SmallEp)))./sum(DurationEpoch(SmallEp));
                REMr_prop_bin{drug}(mouse,bin) = sum(DurationEpoch(and(REMEpoch , SmallEp)))./sum(DurationEpoch(and(Sleep , SmallEp)));
            end
            
%             load('B_Low_Spectrum.mat')
%             B_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%             OB_Wake{drug}(mouse,:) = nanmean(Data(Restrict(B_Sptsd , Wake)));
%             OB_NREM{drug}(mouse,:) = nanmean(Data(Restrict(B_Sptsd , SWSEpoch)));
%             OB_REM{drug}(mouse,:) = nanmean(Data(Restrict(B_Sptsd , REMEpoch)));
%             
%             load('H_Low_Spectrum.mat')
%             H_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%             HPC_Wake{drug}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , Wake)));
%             HPC_NREM{drug}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , SWSEpoch)));
%             HPC_REM{drug}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , REMEpoch)));
%             
%             load('PFCx_Low_Spectrum.mat')
%             P_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%             PFC_Wake{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , Wake)));
%             PFC_NREM{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , SWSEpoch)));
%             PFC_REM{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , REMEpoch)));
        end
    end
    Wake_prop{drug}(Wake_prop{drug}==0)=NaN;
    REM_prop{drug}(REM_prop{drug}==0)=NaN;
    REM_prop2{drug} = REM_prop{drug}; REM_prop2{drug}(Wake_prop{drug}>.75)=NaN;
end
for bin=1:15
   [h1(bin),p1(bin)] = ttest2(Wake_prop_bin{1}(:,bin) , Wake_prop_bin{2}(:,bin)); 
   [h2(bin),p2(bin)] = ttest2(NREM_prop_bin{1}(:,bin) , NREM_prop_bin{2}(:,bin)); 
   [h3(bin),p3(bin)] = ttest2(REM_prop_bin{1}(:,bin) , REM_prop_bin{2}(:,bin)); 
   [h4(bin),p4(bin)] = ttest2(REMr_prop_bin{1}(:,bin) , REMr_prop_bin{2}(:,bin)); 
end
for drug = 1:2
    Wake_prop_early{drug} = nanmean(Wake_prop_bin{drug}(:,1:4)');
    Wake_prop_late2{drug} = nanmean(Wake_prop_bin{drug}(:,5:9)');
    REM_prop_early{drug} = nanmean(REMr_prop_bin{drug}(:,1:4)');
    REM_prop_late2{drug} = nanmean(REMr_prop_bin{drug}(:,5:9)');
end
    
Cols = {[.2 .2 .8],[.8 .2 .2]};
X = [1 2];
Legends = {'Saline','DZP'};


figure
subplot(511)
errorbar([10:20:290] , nanmean(Wake_prop_bin{1}) , nanstd(Wake_prop_bin{1})./sqrt(size(Wake_prop_bin{1},1)) , 'b' , 'LineWidth' , 2)
hold on
errorbar([10:20:290] , nanmean(Wake_prop_bin{2}) , nanstd(Wake_prop_bin{2})./sqrt(size(Wake_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
ylabel('Wake/total'), box off
plot(find(h1)*20-10,1,'*k')
vline(90,'--r'), vline(150,'--r')
f=get(gca,'Children'); l=legend([f([5 4])],'Saline','DZP');

subplot(512)
errorbar([10:20:290] , nanmean(NREM_prop_bin{1}) , nanstd(NREM_prop_bin{1})./sqrt(size(NREM_prop_bin{1},1)) , 'b' , 'LineWidth' , 2)
hold on
errorbar([10:20:290] , nanmean(NREM_prop_bin{2}) , nanstd(NREM_prop_bin{2})./sqrt(size(NREM_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
ylabel('NREM/total'), box off
plot(find(h2)*20-10,1,'*k')
vline(90,'--r'), vline(150,'--r')

subplot(513)
errorbar([10:20:290] , nanmean(REM_prop_bin{1}) , nanstd(REM_prop_bin{1})./sqrt(size(REM_prop_bin{1},1)) , 'b' , 'LineWidth' , 2)
hold on
errorbar([10:20:290] , nanmean(REM_prop_bin{2}) , nanstd(REM_prop_bin{2})./sqrt(size(REM_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
ylabel('REM/total'), box off
try, plot(find(h3)*20-10,1,'*k'), end
vline(90,'--r'), vline(150,'--r')

subplot(514)
errorbar([10:20:290] , nanmean(REMr_prop_bin{1}) , nanstd(REMr_prop_bin{1})./sqrt(size(REMr_prop_bin{1},1)) , 'b' , 'LineWidth' , 2)
hold on
errorbar([10:20:290] , nanmean(REMr_prop_bin{2}) , nanstd(REMr_prop_bin{2})./sqrt(size(REMr_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
xlabel('time post injection (min)'), ylabel('REM/sleep'), box off
try, plot(find(h4)*20-10,1,'*k'), end
vline(90,'--r'), vline(150,'--r')

subplot(529)
MakeSpreadAndBoxPlot3_SB(Wake_prop_late,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake/Total')
subplot(5,2,10)
MakeSpreadAndBoxPlot3_SB(REM_prop_late,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM/sleep')



figure
subplot(231)
Plot_MeanSpectrumForMice_BM(OB_Wake{1} , 'color' , 'b')
Plot_MeanSpectrumForMice_BM(OB_NREM{1} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(OB_REM{1} , 'color' , 'g')
f=get(gca,'Children'); l=legend([f([1 3 2])],'NREM1','NREM2','REM');

subplot(234)
Plot_MeanSpectrumForMice_BM(OB_Wake{2} , 'color' , 'b')
Plot_MeanSpectrumForMice_BM(OB_NREM{2} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(OB_REM{2} , 'color' , 'g')

subplot(232)
Plot_MeanSpectrumForMice_BM(HPC_Wake{1} , 'color' , 'b' , 'threshold' , 23*5)
Plot_MeanSpectrumForMice_BM(HPC_NREM{1} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(HPC_REM{1} , 'color' , 'g')
ylim([0 2])

subplot(235)
Plot_MeanSpectrumForMice_BM(HPC_Wake{2} , 'color' , 'b' , 'threshold' , 23*5)
Plot_MeanSpectrumForMice_BM(HPC_NREM{2} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(HPC_REM{2} , 'color' , 'g')
ylim([0 2])

subplot(233)
Plot_MeanSpectrumForMice_BM(PFC_Wake{1} , 'color' , 'b')
Plot_MeanSpectrumForMice_BM(PFC_NREM{1} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(PFC_REM{1} , 'color' , 'g')

subplot(236)
Plot_MeanSpectrumForMice_BM(PFC_Wake{2} , 'color' , 'b')
Plot_MeanSpectrumForMice_BM(PFC_NREM{2} , 'color' , 'r')
Plot_MeanSpectrumForMice_BM(PFC_REM{2} , 'color' , 'g')













