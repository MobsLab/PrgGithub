function [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_Basal_MC(Wake,SWSEpoch,REMEpoch,stage,tempbin)

tempbin=tempbin*1E4;
SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

tps=Range(SleepStage);
rg = [(0:tempbin:tps(end))];

epoch1 = intervalSet(rg(1), rg(2));
epoch2 = intervalSet(rg(2), rg(3));
epoch3 = intervalSet(rg(3), rg(4));
epoch4 = intervalSet(rg(4), rg(5));
epoch5 = intervalSet(rg(5), rg(6));
epoch6 = intervalSet(rg(6), rg(7));
epoch7 = intervalSet(rg(7), rg(8));
epoch8 = intervalSet(rg(8), rg(9));
epoch9 = intervalSet(rg(9), tps(end));

if strcmp(lower(stage),'wake')
    [dur_wake_1, durT_wake_1] = DurationEpoch(and(Wake,epoch1),'s');
    [dur_wake_2, durT_wake_2] = DurationEpoch(and(Wake,epoch2),'s');
    [dur_wake_3, durT_wake_3] = DurationEpoch(and(Wake,epoch3),'s');
    [dur_wake_4, durT_wake_4] = DurationEpoch(and(Wake,epoch4),'s');
    [dur_wake_5, durT_wake_5] = DurationEpoch(and(Wake,epoch5),'s');
    [dur_wake_6, durT_wake_6] = DurationEpoch(and(Wake,epoch6),'s');
    [dur_wake_7, durT_wake_7] = DurationEpoch(and(Wake,epoch7),'s');
    [dur_wake_8, durT_wake_8] = DurationEpoch(and(Wake,epoch8),'s');
    [dur_wake_9, durT_wake_9] = DurationEpoch(and(Wake,epoch9),'s');
    
    dur_TOT_moyenne_ep = [nanmean(durT_wake_1), nanmean(durT_wake_2), nanmean(durT_wake_3), nanmean(durT_wake_4), nanmean(durT_wake_5), nanmean(durT_wake_6), nanmean(durT_wake_7), nanmean(durT_wake_8), nanmean(durT_wake_9)];

elseif strcmp(lower(stage),'sws')
    [dur_sws_1, durT_sws_1] = DurationEpoch(and(SWSEpoch,epoch1),'s');
    [dur_sws_2, durT_sws_2] = DurationEpoch(and(SWSEpoch,epoch2),'s');
    [dur_sws_3, durT_sws_3] = DurationEpoch(and(SWSEpoch,epoch3),'s');
    [dur_sws_4, durT_sws_4] = DurationEpoch(and(SWSEpoch,epoch4),'s');
    [dur_sws_5, durT_sws_5] = DurationEpoch(and(SWSEpoch,epoch5),'s');
    [dur_sws_6, durT_sws_6] = DurationEpoch(and(SWSEpoch,epoch6),'s');
    [dur_sws_7, durT_sws_7] = DurationEpoch(and(SWSEpoch,epoch7),'s');
    [dur_sws_8, durT_sws_8] = DurationEpoch(and(SWSEpoch,epoch8),'s');
    [dur_sws_9, durT_sws_9] = DurationEpoch(and(SWSEpoch,epoch9),'s');
    
    dur_TOT_moyenne_ep = [nanmean(durT_sws_1), nanmean(durT_sws_2), nanmean(durT_sws_3), nanmean(durT_sws_4), nanmean(durT_sws_5), nanmean(durT_sws_6), nanmean(durT_sws_7), nanmean(durT_sws_8), nanmean(durT_sws_9)];  

        
elseif strcmp(lower(stage),'rem')
    
    [dur_rem_1, durT_rem_1] = DurationEpoch(and(REMEpoch,epoch1),'s');
    [dur_rem_2, durT_rem_2] = DurationEpoch(and(REMEpoch,epoch2),'s');
    [dur_rem_3, durT_rem_3] = DurationEpoch(and(REMEpoch,epoch3),'s');
    [dur_rem_4, durT_rem_4] = DurationEpoch(and(REMEpoch,epoch4),'s');
    [dur_rem_5, durT_rem_5] = DurationEpoch(and(REMEpoch,epoch5),'s');
    [dur_rem_6, durT_rem_6] = DurationEpoch(and(REMEpoch,epoch6),'s');
    [dur_rem_7, durT_rem_7] = DurationEpoch(and(REMEpoch,epoch7),'s');
    [dur_rem_8, durT_rem_8] = DurationEpoch(and(REMEpoch,epoch8),'s');
    [dur_rem_9, durT_rem_9] = DurationEpoch(and(REMEpoch,epoch9),'s');
    
    dur_TOT_moyenne_ep = [nanmean(durT_rem_1), nanmean(durT_rem_2), nanmean(durT_rem_3), nanmean(durT_rem_4), nanmean(durT_rem_5), nanmean(durT_rem_6), nanmean(durT_rem_7), nanmean(durT_rem_8), nanmean(durT_rem_9)];
end





