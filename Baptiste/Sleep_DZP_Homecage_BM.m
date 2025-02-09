
%% initialization

clear all
SleepInfo = GetSleepSessions_Drugs_BM;
Drug_Group= {'Saline','DZP'};
FreqLim=4.5;
smootime = 1;

%% get data
for drug = 1:2
    for mouse = 1:length(SleepInfo.path{drug})
        try
            clear Epoch_Drugs Wake SWSEpoch REMEpoch Sleep
                        load([SleepInfo.path{drug}{mouse} 'SleepScoring_OBGamma.mat'], 'Epoch_Drugs', 'Wake', 'SWSEpoch', 'REMEpoch', 'Sleep')
%             load([SleepInfo.path{drug}{mouse} 'SleepScoring_Accelero.mat'], 'Wake', 'SWSEpoch', 'REMEpoch', 'Sleep')
%             load([SleepInfo.path{drug}{mouse} 'SleepScoring_OBGamma.mat'], 'Epoch_Drugs')
            load([SleepInfo.path{drug}{mouse} 'behavResources.mat'], 'MovAcctsd','Vtsd')
            load([SleepInfo.path{drug}{mouse} 'SWR.mat'],'tRipples')
            load([SleepInfo.path{drug}{mouse} 'HeartBeatInfo.mat'])
            
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
            
            FreezeAccEpoch = GetFreezeAccEpoch_BM(MovAcctsd);
            Fz_PostInj = and(Wake , and(FreezeAccEpoch , Epoch_Drugs{2}));
            Fz_PostInj_Dur{drug}(mouse) = sum(DurationEpoch(Fz_PostInj))./1e4;
            
            load([SleepInfo.path{drug}{mouse} 'B_Low_Spectrum.mat'])
            B_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
            OB_Sp_Fz = Restrict(B_Sptsd , Fz_PostInj);
            OB_Fz{drug}(mouse,:) = nanmean(Data(OB_Sp_Fz));
            
            
            clear D, D = Data(ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OB_Sp_Fz) , Data(OB_Sp_Fz)));
            Length_shock{drug}(mouse) = sum(D>FreqLim)*.2;
            Length_safe{drug}(mouse) = sum(D<FreqLim)*.2;
            
            SWR_occ_NREM{drug}(mouse) = length(Restrict(tRipples , Epoch_Drugs{2}))./sum(DurationEpoch(and(SWSEpoch , Epoch_Drugs{2}))/1e4);
            SWR_occ_Fz{drug}(mouse) = length(Restrict(tRipples , Fz_PostInj))./sum(DurationEpoch(Fz_PostInj)/1e4);
            
            
            HR_WakeAfterInj{drug}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Wake , Epoch_Drugs{2}))));
            HR_WakeBefInj{drug}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0 , 60*60e4)))));
            HR_FzAftInj{drug}(mouse) = nanmean(Data(Restrict(EKG.HBRate , Fz_PostInj)));

            
            Speed_smooth = tsd(Range(Vtsd) , runmean(Data(Vtsd) , ceil(smootime/median(diff(Range(Vtsd,'s'))))));
            Acc_smooth = tsd(Range(MovAcctsd) , runmean(Data(MovAcctsd) , ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
            Speed_WakeAfterInj{drug}(mouse) = nanmean(Data(Restrict(Speed_smooth , and(Wake , Epoch_Drugs{2}))));
            Acc_WakeAfterInj{drug}(mouse) = nanmean(Data(Restrict(Acc_smooth , and(Wake , Epoch_Drugs{2}))));

            
            %             OB_NREM{drug}(mouse,:) = nanmean(Data(Restrict(B_Sptsd , SWSEpoch)));
            %             OB_REM{drug}(mouse,:) = nanmean(Data(Restrict(B_Sptsd , REMEpoch)));
            
            %             try load([SleepInfo.path{drug}{mouse} 'ChannelsToAnalyse/dHPC_rip.mat'])
            %                 load([SleepInfo.path{drug}{mouse} 'H_VHigh_Spectrum.mat'])
            %                 H_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
            %                 for i=1:2
            %                     HPC_Wake{drug}{i}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , and(Wake , Epoch_Drugs{i}))));
            %                     HPC_NREM{drug}{i}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , and(SWSEpoch , Epoch_Drugs{i}))));
            %                     HPC_REM{drug}{i}(mouse,:) = nanmean(Data(Restrict(H_Sptsd , and(REMEpoch , Epoch_Drugs{i}))));
            %                 end
            %             catch
            %                 for i=1:2
            %                     HPC_Wake{drug}{i}(mouse,:) = NaN(1,94);
            %                     HPC_NREM{drug}{i}(mouse,:) = NaN(1,94);
            %                     HPC_REM{drug}{i}(mouse,:) = NaN(1,94);
            %                 end
            %             end
            %
            %             load('PFCx_Low_Spectrum.mat')
            %             P_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
            %             PFC_Wake{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , Wake)));
            %             PFC_NREM{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , SWSEpoch)));
            %             PFC_REM{drug}(mouse,:) = nanmean(Data(Restrict(P_Sptsd , REMEpoch)));
        end
        disp(mouse)
    end
    Wake_prop{drug}(Wake_prop{drug}==0)=NaN;
    REM_prop{drug}(REM_prop{drug}==0)=NaN;
    REM_prop2{drug} = REM_prop{drug}; REM_prop2{drug}(Wake_prop{drug}>.75)=NaN;
    HR_WakeAfterInj{drug}(HR_WakeAfterInj{drug}==0) = NaN;
    HR_WakeBefInj{drug}(HR_WakeBefInj{drug}==0) = NaN;
    HR_FzAftInj{drug}(HR_FzAftInj{drug}==0) = NaN;
    Speed_WakeAfterInj{drug}(Speed_WakeAfterInj{drug}==0) = NaN;
    Acc_WakeAfterInj{drug}(Acc_WakeAfterInj{drug}==0) = NaN;
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



%% figures
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
f=get(gca,'Children'); l=legend([f([4 3])],'Saline','DZP');

subplot(512)
errorbar([10:20:290] , nanmean(NREM_prop_bin{1}) , nanstd(NREM_prop_bin{1})./sqrt(size(NREM_prop_bin{1},1)) , 'b' , 'LineWidth' , 2)
hold on
errorbar([10:20:290] , nanmean(NREM_prop_bin{2}) , nanstd(NREM_prop_bin{2})./sqrt(size(NREM_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
ylabel('NREM/total'), box off
try, plot(find(h2)*20-10,1,'*k'), end
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

errorbar([10:20:290] , nanmean(NREM_prop_bin{2}) , nanstd(NREM_prop_bin{2})./sqrt(size(NREM_prop_bin{2},1)) , 'r' , 'LineWidth' , 2)
ylabel('NREM/total'), box off
try, plot(find(h2)*20-10,1,'*k'), end
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




figure
MakeSpreadAndBoxPlot3_SB({Fz_PostInj_Dur{1}./4800 Fz_PostInj_Dur{2}./4800},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Freezing proportion')


[~,MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{1}{1} , 'color' , 'k' , 'threshold' , 30);
[~,MaxPowerValues2] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{2}{1} , 'color' , 'k' , 'threshold' , 30);


figure
Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{1}{2}(10:end,:) , 'color' , 'k' , 'threshold' , 30 , 'power_norm_value' , MaxPowerValues1(10:end))
hold on
Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{2}{2}(3:end,:) , 'color' , 'r' , 'threshold' , 30 , 'power_norm_value' , MaxPowerValues2(3:end))
xlim([50 250]), ylim([0 2])
makepretty
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Diazepam');
title('HPC, NREM after injection')



figure
Plot_MeanSpectrumForMice_BM(OB_Fz{1} , 'color' , 'k')
hold on
Plot_MeanSpectrumForMice_BM(OB_Fz{2} , 'color' , 'r')
xlim([0 10])
makepretty
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Diazepam');
title('OB, immobility after injection')





%% trash ?
figure
Data_to_use = Spectro{3}.*(HPC_NREM{1}{2}(10:end,:)./max(HPC_NREM{1}{1}(10:end,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(Spectro{3} , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
Data_to_use = Spectro{3}.*HPC_NREM{2}{2}(3:end,:);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(Spectro{3} , nanmean(Data_to_use) , Conf_Inter ,'-r',1); hold on;
xlim([50 250])
set(gca,'YScale','log')


figure
plot((Spectro{3}.*HPC_NREM{1})')



figure
Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{1}{2}(10:end,:) , 'color' , 'k' , 'threshold' , 30)
hold on
Plot_MeanSpectrumForMice_BM(Spectro{3}.*HPC_NREM{2}{2}(3:end,:) , 'color' , 'r' , 'threshold' , 30)
xlim([50 250]), ylim([0 2])
set(gca,'YScale','log')


Plot_MeanSpectrumForMice_BM(HPC_REM{1} , 'color' , 'g')

Plot_MeanSpectrumForMice_BM(HPC_Wake{1} , 'color' , 'b')



figure
plot((Spectro{3}.*HPC_NREM{2}{1})' , 'k')



