
%% Bus
% 30 min
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
AllMice = 0:37;
Mice.Sal_Bus30 = [37,1,3,4,5,9,10,15];% 11 has problem
Mice.Bus30 = [0,2,6,7,8,12,13,14,16,17];

time=300; % total time on which you want to analyse behaviour
Group={'Sal_Bus30','Bus30'};
EPM_Analysis_BM

%4h
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
Mice.Sal_Bus4 = [18,19,22,23,24,28,29,30,34];
Mice.Bus4 = [20,21,25,26,27,31,32,33,35,36];

time=300; % total time on which you want to analyse behaviour
Group={'Sal_Bus4','Bus4'};
EPM_Analysis_BM


%% Dzp only
Base = '/media/mobsmorty/DataMOBs119/EPM/27102020_Dzp/FEAR-Mouse-1087-27102020-EPM';
AllMice = 0:14;
Mice.Sal_Dzp = [13,4,5,6,7,8,9];
Mice.Dzp = [14,0,1,2,3,10,11,12];
%Sal = [7,8,9];
%Drug = [10,11,12];  % not old

time=300; % total time on which you want to analyse behaviour
Group={'Sal_Dzp','Dzp'};
EPM_Analysis_BM


%% Dzp DMSO
Base = '/media/nas4/ProjetEmbReact/EPM/20201118_DzpDMSO/FEAR-Mouse-7-18112020-EPM';
AllMice = 0:9;
Mice.Sal_DzpDMSO = [0,1,2,3,4];
Mice.DzpDMSO = [5,6,7,8,9];

time=300; % total time on which you want to analyse behaviour
Group={'Sal_DzpDMSO','DzpDMSO'};
EPM_Analysis_BM


%% Figure

Cols = {[0.25, 0.25, 0.25],[0.8500, 0.3250, 0.0980]};
X = [1,2];
Legends = {'Saline','DZP'};


subplot(331)
MakeSpreadAndBoxPlot2_SB({TimeOA.Sal_DzpDMSO/time,TimeOA.DzpDMSO/time} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Prop. time in open arms')
ylabel('%'); ylim([-0.02 0.75])

subplot(332)
MakeSpreadAndBoxPlot2_SB({TimeCenter.Sal_DzpDMSO/time,TimeCenter.DzpDMSO/time} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Prop. time in center')
ylim([-0.02 0.75])

subplot(333)
MakeSpreadAndBoxPlot2_SB({(time-TimeCenter.Sal_DzpDMSO-TimeOA.Sal_DzpDMSO)./(time),(time-TimeCenter.DzpDMSO-TimeOA.DzpDMSO)./(time)} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Prop. time in closed arms')
ylim([-0.02 0.75])

subplot(346)
MakeSpreadAndBoxPlot2_SB({MeanSpeed.Sal_DzpDMSO,MeanSpeed.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Mean Speed')
ylabel('cm/s'); ylim([2 8])

subplot(347)
MakeSpreadAndBoxPlot2_SB({MeanTemp.Sal_DzpDMSO,MeanTemp.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Mean Temp')
ylabel('(°C)'); ylim([26 31])

subplot(349)
MakeSpreadAndBoxPlot2_SB({NumEntry.Sal_DzpDMSO,NumEntry.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Open arms entries')
ylabel('#')

subplot(3,4,10)
MakeSpreadAndBoxPlot2_SB({Tot_Arm_Entries.Sal_DzpDMSO,Tot_Arm_Entries.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('All arm entries')
ylabel('#')

subplot(3,4,11)
MakeSpreadAndBoxPlot2_SB({MeanDurOpen.Sal_DzpDMSO,MeanDurOpen.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Mean duration in open arm')
ylabel('time (s)')

subplot(3,4,12)
MakeSpreadAndBoxPlot2_SB({MeanDurClosed.Sal_DzpDMSO,MeanDurClosed.DzpDMSO} , Cols , X , Legends,'showpoints',1,'paired',0);
title('Mean duration in closed arm')
ylabel('time (s)')

a=suptitle('EPM, Diazepam, 30 min, n=15'); a.FontSize=25;




% Occupancy
figure
RegionOccup = {'OpenArms','Center','ClosedArms'};
TotOccup = TimeOccupancy.OpenArms.(Group{group})(mice,:)+TimeOccupancy.Center.(Group{group})(mice,:)+TimeOccupancy.ClosedArms.(Group{group})(mice,:);
cols = [0.25, 0.25, 0.25 ; 0.8500, 0.3250, 0.0980];
for z = 1:3
    subplot(3,1,z)
    for group=1:length(Group)
        errorbar(nanmean(TimeOccupancy.(RegionOccup{z}).(Group{group}))./TotOccup,stdError(TimeOccupancy.(RegionOccup{z}).(Group{group})./TotOccup),'color',cols(group,:),'linewidth',4)
        hold on
    end
    ylim([0 1])
    set(gca,'Linewidth',2)
    set(gca,'FontSize', 16);
    ylabel('Prop time')
    xticks([3 6 9 12 15]); xticklabels({'1','2','3','4','5'});
    if z==1
        title('Open arms'); legend('Saline' , 'DZP')
    elseif  z==2
        title('Center')
    else
        title('Closed arms'); xlabel('time (min)')
    end
    box off
    
end

a=suptitle('EPM, Diazepam, 30 min, n=15'); a.FontSize=25;

%% Bad ZoneEpoch
figure
subplot(331)
PlotErrorBarN_BM({TimeinOA.Sal/time,TimeinOA.Drug/time},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in open arms')
ylabel('%')
subplot(332)
PlotErrorBarN_BM({TimeinCenter.Sal/time,TimeinCenter.Drug/time},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in center')
ylabel('%')
subplot(333)
PlotErrorBarN_BM({(time-TimeinCenter.Sal-TimeinOA.Sal)./(time),(time-TimeinCenter.Drug-TimeinOA.Drug)./(time)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in closed arms')
ylabel('%')

% Occupancy
cols = viridis(2);
RegionOccup = {'OpenArms','Center','ClosedArms'};

for occup=1:3
    subplot(3,1,occup)
    for group=1:length(Group)
        TimeinOccupancy.ClosedArms.(Group{group})=(1-TimeinOccupancy.OpenArms.(Group{group})-TimeinOccupancy.Center.(Group{group}));
        errorbar([20:20:300],nanmean(TimeinOccupancy.(RegionOccup{occup}).(Group{group})),stdError(TimeinOccupancy.(RegionOccup{occup}).(Group{group})),'color',cols(group,:),'linewidth',4)
        hold on
    end
    
    xlabel('time (s)')
    ylabel('Prop time')
    ylim([0 1])
    title(RegionOccup{occup})
    if occup ==1
        legend(Group{1},Group{2})
    end
    box off
end


a=suptitle('[DZP]=1.5 mg/kg'); a.FontSize=20;
a=suptitle('[BUS]=3.0 mg/kg'); a.FontSize=20;


%% All the grops on the same figure

figure
subplot(331)
PlotErrorBarN_BM({TimeOA.Sal_Bus30/time,TimeOA.Bus30/time,TimeOA.Sal_Bus4/time,TimeOA.Bus4/time,TimeOA.Sal_Dzp/time,TimeOA.Dzp/time,TimeinOA.Sal_DzpDMSO/time,TimeinOA.DzpDMSO/time},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Proportionnal time in open arms')
ylabel('%')
subplot(332)
PlotErrorBarN_BM({TimeCenter.Sal_Bus30/time,TimeCenter.Bus30/time,TimeCenter.Sal_Bus4/time,TimeCenter.Bus4/time,TimeCenter.Sal_Dzp/time,TimeCenter.Dzp/time,TimeinCenter.Sal_DzpDMSO/time,TimeinCenter.DzpDMSO/time},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Proportionnal time in center')
ylabel('%')
subplot(333)
PlotErrorBarN_BM({(time-TimeCenter.Sal_Bus30-TimeOA.Sal_Bus30)./(time),(time-TimeCenter.Bus30-TimeOA.Bus30)./(time),(time-TimeCenter.Sal_Bus4-TimeOA.Sal_Bus4)./(time),(time-TimeCenter.Bus4-TimeOA.Bus4)./(time),(time-TimeCenter.Sal_Dzp-TimeOA.Sal_Dzp)./(time),(time-TimeCenter.Dzp-TimeOA.Dzp)./(time),(time-TimeCenter.DzpDMSO-TimeOA.Sal_DzpDMSO)./(time),(time-TimeCenter.DzpDMSO-TimeOA.DzpDMSO)./(time)},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Proportionnal time in closed arms')
ylabel('%')

subplot(346)
PlotErrorBarN_BM({MeanSpeed.Sal_Bus30,MeanSpeed.Bus30,MeanSpeed.Sal_Bus4,MeanSpeed.Bus4,MeanSpeed.Sal_Dzp,MeanSpeed.Dzp,MeanSpeed.Sal_DzpDMSO,MeanSpeed.DzpDMSO},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Mean Speed')
ylabel('cm/s')
subplot(347)
PlotErrorBarN_BM({MeanTemp.Sal_Bus30-nanmean(MeanTemp.Sal_Bus30),MeanTemp.Bus30-nanmean(MeanTemp.Sal_Bus30),MeanTemp.Sal_Bus4-nanmean(MeanTemp.Sal_Bus4),MeanTemp.Bus4-nanmean(MeanTemp.Sal_Bus4),MeanTemp.Sal_Dzp-nanmean(MeanTemp.Sal_Dzp),MeanTemp.Dzp-nanmean(MeanTemp.Sal_Dzp),MeanTemp.Sal_DzpDMSO-nanmean(MeanTemp.Sal_DzpDMSO),MeanTemp.DzpDMSO-nanmean(MeanTemp.Sal_DzpDMSO)},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Mean Temp')
ylabel('(°C)')

subplot(349)
PlotErrorBarN_BM({NumEntry.Sal_Bus30,NumEntry.Bus30,NumEntry.Sal_Bus4,NumEntry.Bus4,NumEntry.Sal_Dzp,NumEntry.Dzp,NumEntry.Sal_DzpDMSO,NumEntry.DzpDMSO},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Open arms entries')
ylabel('#')
subplot(3,4,10)
PlotErrorBarN_BM({Tot_Arm_Entries.Sal_Bus30,Tot_Arm_Entries.Bus30,Tot_Arm_Entries.Sal_Bus4,Tot_Arm_Entries.Bus4,Tot_Arm_Entries.Sal_Dzp,Tot_Arm_Entries.Dzp,Tot_Arm_Entries.Sal_DzpDMSO,Tot_Arm_Entries.DzpDMSO},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('All arm entries')
ylabel('#')
subplot(3,4,11)
PlotErrorBarN_BM({MeanDurOpen.Sal_Bus30,MeanDurOpen.Bus30,MeanDurOpen.Sal_Bus4,MeanDurOpen.Bus4,MeanDurOpen.Sal_Dzp,MeanDurOpen.Dzp,MeanDurOpen.Sal_DzpDMSO,MeanDurOpen.DzpDMSO},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Mean duration in open arm')
ylabel('time (s)')
subplot(3,4,12)
PlotErrorBarN_BM({MeanDurClosed.Sal_Bus30,MeanDurClosed.Bus30,MeanDurClosed.Sal_Bus4,MeanDurClosed.Bus4,MeanDurClosed.Sal_Dzp,MeanDurClosed.Dzp,MeanDurClosed.Sal_DzpDMSO,MeanDurClosed.DzpDMSO},'paired',0,'newfig',0)
makepretty
xticks([1 2 3 4 5 6 7 8]); xticklabels({'Saline Bus30','Bus 30 min','Saline Bus4','Bus 4 hours','Saline Dzp','Dzp','Saline DzpDMSO','Dzp + DMSO'}); xtickangle(45)
title('Mean duration in closed arm')
ylabel('time (s)')


a=suptitle('EPM and drugs'); a.FontSize=40;




