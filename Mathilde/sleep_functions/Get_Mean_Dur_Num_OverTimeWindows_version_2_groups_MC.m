function [dur_moyenne_ep, num_moyen_ep, perc_moyen, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(Wake,SWSEpoch,REMEpoch,stage,tempbin,same_st,same_en)

tempbin=tempbin*1E4;
rg = [(same_st:tempbin:same_en)];

epoch1 = intervalSet(same_st, same_en);

[dur_epoch_1, durT_epoch_1] = DurationEpoch(epoch1,'s');

if strcmp(lower(stage),'wake')
    [dur_wake_1, durT_wake_1] = DurationEpoch(and(Wake,epoch1),'s');
    perc_wake_1 = durT_wake_1 / durT_epoch_1 * 100;
    dur_moyenne_ep = [mean(dur_wake_1)];
    num_moyen_ep = [length(dur_wake_1)];
    perc_moyen = [perc_wake_1];
    
elseif strcmp(lower(stage),'sws')
    [dur_sws_1, durT_sws_1] = DurationEpoch(and(SWSEpoch,epoch1),'s');
    perc_sws_1 = durT_sws_1 / durT_epoch_1 * 100;
    dur_moyenne_ep = [mean(dur_sws_1)];
    num_moyen_ep = [length(dur_sws_1)];
    perc_moyen = [perc_sws_1];
    
elseif strcmp(lower(stage),'rem')
    [dur_rem_1, durT_rem_1] = DurationEpoch(and(REMEpoch,epoch1),'s');
    perc_rem_1 = durT_rem_1 / durT_epoch_1 * 100;
    dur_moyenne_ep = [mean(dur_rem_1)];
    num_moyen_ep = [length(dur_rem_1)];
    perc_moyen = [perc_rem_1];
    
elseif strcmp(lower(stage),'sleep')
    [dur_sleep_1, durT_sleep_1] = DurationEpoch(and(or(REMEpoch,SWSEpoch),epoch1),'s');
    perc_sleep_1 = durT_sleep_1 / durT_epoch_1 * 100;
    dur_moyenne_ep = [mean(dur_sleep_1)];
    num_moyen_ep = [length(dur_sleep_1)];
    perc_moyen = [perc_sleep_1];
    
    
end





