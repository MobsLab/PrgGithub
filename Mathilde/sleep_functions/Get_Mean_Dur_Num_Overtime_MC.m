function [dur_moyenne_ep, num_moyen_ep, perc_moyen, dur_tot, rg]=Get_Mean_Dur_Num_Overtime_MC(Wake,SWSEpoch,REMEpoch,stage,tempbin,time_st,time_end)

load('SleepScoring_Accelero.mat', 'Epoch')

tempbin=tempbin*1E4;
SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

rg = [(time_st:tempbin:time_end)];

for i=2:length(rg)
    EPOCH(i) = intervalSet(rg(i-1), rg(i));
end
EPOCH = EPOCH(2:end);


for i=1:length(rg)-1
    [dur_epoch_1{i}, durT_epoch_1(i)] = DurationEpoch(and(Epoch, EPOCH(i)),'s');
    [dur_wake_1{i}, durT_wake(i)] = DurationEpoch(and(Wake, EPOCH(i)),'s');
    [dur_sws_1{i}, durT_sws(i)] = DurationEpoch(and(SWSEpoch, EPOCH(i)),'s');
    [dur_rem_1{i}, durT_rem(i)] = DurationEpoch(and(REMEpoch, EPOCH(i)),'s');
end


if strcmp(lower(stage),'wake')
    for i=1:length(rg)-1
        [dur_wake_1{i}, durT_wake(i)] = DurationEpoch(and(Wake,EPOCH(i)),'s');
        %         perc_moyen(i) = durT_wake(i) ./ durT_epoch_1(i) * 100;
        perc_moyen(i) = durT_wake(i) ./ (durT_wake(i)+durT_sws(i)+durT_rem(i)) * 100;
        num_moyen_ep(i) = length(dur_wake_1{i});
        dur_moyenne_ep(i) = nanmean(dur_wake_1{i});
        dur_tot(i) = durT_wake(i);
    end
end

if strcmp(lower(stage),'sleep')
    for i=1:length(rg)-1
        [dur_sleep_1{i}, durT_sleep(i)] = DurationEpoch(and(or(REMEpoch,SWSEpoch),EPOCH(i)),'s');
        perc_moyen(i) = durT_sleep(i) ./ durT_epoch_1(i) * 100;
        num_moyen_ep(i) = length(dur_sleep_1{i});
        dur_moyenne_ep(i) = nanmean(dur_sleep_1{i});
        dur_tot(i) = durT_sleep(i);
        
    end
end


if strcmp(lower(stage),'sws')
    for i=1:length(rg)-1
        [dur_sws_1{i}, durT_sws(i)] = DurationEpoch(and(SWSEpoch,EPOCH(i)),'s');
        %         perc_moyen(i) = durT_sws(i) ./ durT_epoch_1(i) * 100;
        perc_moyen(i) = durT_sws(i) ./ (durT_wake(i)+durT_sws(i)+durT_rem(i)) * 100;
        
        num_moyen_ep(i) = length(dur_sws_1{i});
        dur_moyenne_ep(i) = nanmean(dur_sws_1{i});
        dur_tot(i) = durT_sws(i);
        
    end
end



if strcmp(lower(stage),'rem')
    for i=1:length(rg)-1
        [dur_rem_1{i}, durT_rem(i)] = DurationEpoch(and(REMEpoch,EPOCH(i)),'s');
        %         perc_moyen(i) = durT_rem(i) ./ durT_epoch_1(i) * 100;
        perc_moyen(i) = durT_rem(i) ./ (durT_wake(i)+durT_sws(i)+durT_rem(i)) * 100;
        
        num_moyen_ep(i) = length(dur_rem_1{i});
        dur_moyenne_ep(i) = nanmean(dur_rem_1{i});
        dur_tot(i) = durT_rem(i);
    end
end



% tempbin=tempbin*1E4;
% SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close
%
% tps=Range(SleepStage);
% rg = [(0:tempbin:time_end)];
%
% epoch1 = intervalSet(0, rg(2));
% epoch2 = intervalSet(rg(2), rg(3));
% epoch3 = intervalSet(rg(3), rg(4));
% epoch4 = intervalSet(rg(4), rg(5));
% epoch5 = intervalSet(rg(5), rg(6));
% epoch6 = intervalSet(rg(6), rg(7));
% epoch7 = intervalSet(rg(7), rg(8));
% epoch8 = intervalSet(rg(8), rg(end));
%
% [dur_epoch_1, durT_epoch_1] = DurationEpoch(epoch1,'s');
% [dur_epoch_2, durT_epoch_2] = DurationEpoch(epoch2,'s');
% [dur_epoch_3, durT_epoch_3] = DurationEpoch(epoch3,'s');
% [dur_epoch_4, durT_epoch_4] = DurationEpoch(epoch4,'s');
% [dur_epoch_5, durT_epoch_5] = DurationEpoch(epoch5,'s');
% [dur_epoch_6, durT_epoch_6] = DurationEpoch(epoch6,'s');
% [dur_epoch_7, durT_epoch_7] = DurationEpoch(epoch7,'s');
% [dur_epoch_8, durT_epoch_8] = DurationEpoch(epoch8,'s');
%
%
% if strcmp(lower(stage),'wake')
%     [dur_wake_1, durT_wake_1] = DurationEpoch(and(Wake,epoch1),'s');
%     [dur_wake_2, durT_wake_2] = DurationEpoch(and(Wake,epoch2),'s');
%     [dur_wake_3, durT_wake_3] = DurationEpoch(and(Wake,epoch3),'s');
%     [dur_wake_4, durT_wake_4] = DurationEpoch(and(Wake,epoch4),'s');
%     [dur_wake_5, durT_wake_5] = DurationEpoch(and(Wake,epoch5),'s');
%     [dur_wake_6, durT_wake_6] = DurationEpoch(and(Wake,epoch6),'s');
%     [dur_wake_7, durT_wake_7] = DurationEpoch(and(Wake,epoch7),'s');
%     [dur_wake_8, durT_wake_8] = DurationEpoch(and(Wake,epoch8),'s');
%
%     perc_wake_1 = durT_wake_1 / durT_epoch_1 * 100;
%     perc_wake_2 = durT_wake_2 / durT_epoch_2 * 100;
%     perc_wake_3 = durT_wake_3 / durT_epoch_3 * 100;
%     perc_wake_4 = durT_wake_4 / durT_epoch_4 * 100;
%     perc_wake_5 = durT_wake_5 / durT_epoch_5 * 100;
%     perc_wake_6 = durT_wake_6 / durT_epoch_6 * 100;
%     perc_wake_7 = durT_wake_7 / durT_epoch_7 * 100;
%     perc_wake_8 = durT_wake_8 / durT_epoch_8 * 100;
%
%     dur_moyenne_ep = [nanmean(dur_wake_1), nanmean(dur_wake_2), nanmean(dur_wake_3), nanmean(dur_wake_4), nanmean(dur_wake_5), nanmean(dur_wake_6), nanmean(dur_wake_7), nanmean(dur_wake_8)];
%     num_moyen_ep = [length(dur_wake_1), length(dur_wake_2), length(dur_wake_3), length(dur_wake_4), length(dur_wake_5), length(dur_wake_6), length(dur_wake_7), length(dur_wake_8)];
%     perc_moyen = [perc_wake_1, perc_wake_2, perc_wake_3, perc_wake_4, perc_wake_5, perc_wake_6, perc_wake_7, perc_wake_8];
%
%
% elseif strcmp(lower(stage),'sws')
%     [dur_sws_1, durT_sws_1] = DurationEpoch(and(SWSEpoch,epoch1),'s');
%     [dur_sws_2, durT_sws_2] = DurationEpoch(and(SWSEpoch,epoch2),'s');
%     [dur_sws_3, durT_sws_3] = DurationEpoch(and(SWSEpoch,epoch3),'s');
%     [dur_sws_4, durT_sws_4] = DurationEpoch(and(SWSEpoch,epoch4),'s');
%     [dur_sws_5, durT_sws_5] = DurationEpoch(and(SWSEpoch,epoch5),'s');
%     [dur_sws_6, durT_sws_6] = DurationEpoch(and(SWSEpoch,epoch6),'s');
%     [dur_sws_7, durT_sws_7] = DurationEpoch(and(SWSEpoch,epoch7),'s');
%     [dur_sws_8, durT_sws_8] = DurationEpoch(and(SWSEpoch,epoch8),'s');
%
%
%     perc_sws_1 = durT_sws_1 / durT_epoch_1 * 100;
%     perc_sws_2 = durT_sws_2 / durT_epoch_2 * 100;
%     perc_sws_3 = durT_sws_3 / durT_epoch_3 * 100;
%     perc_sws_4 = durT_sws_4 / durT_epoch_4 * 100;
%     perc_sws_5 = durT_sws_5 / durT_epoch_5 * 100;
%     perc_sws_6 = durT_sws_6 / durT_epoch_6 * 100;
%     perc_sws_7 = durT_sws_7 / durT_epoch_7 * 100;
%     perc_sws_8 = durT_sws_8 / durT_epoch_8 * 100;
%
%
%
%     dur_moyenne_ep = [nanmean(dur_sws_1), nanmean(dur_sws_2), nanmean(dur_sws_3), nanmean(dur_sws_4), nanmean(dur_sws_5), nanmean(dur_sws_6), nanmean(dur_sws_7), nanmean(dur_sws_8)];
%     num_moyen_ep = [length(dur_sws_1), length(dur_sws_2), length(dur_sws_3), length(dur_sws_4), length(dur_sws_5), length(dur_sws_6), length(dur_sws_7), length(dur_sws_8)];
%     perc_moyen = [perc_sws_1, perc_sws_2, perc_sws_3, perc_sws_4, perc_sws_5, perc_sws_6, perc_sws_7, perc_sws_8];
%
% elseif strcmp(lower(stage),'rem')
%
%     [dur_rem_1, durT_rem_1] = DurationEpoch(and(REMEpoch,epoch1),'s');
%     [dur_rem_2, durT_rem_2] = DurationEpoch(and(REMEpoch,epoch2),'s');
%     [dur_rem_3, durT_rem_3] = DurationEpoch(and(REMEpoch,epoch3),'s');
%     [dur_rem_4, durT_rem_4] = DurationEpoch(and(REMEpoch,epoch4),'s');
%     [dur_rem_5, durT_rem_5] = DurationEpoch(and(REMEpoch,epoch5),'s');
%     [dur_rem_6, durT_rem_6] = DurationEpoch(and(REMEpoch,epoch6),'s');
%     [dur_rem_7, durT_rem_7] = DurationEpoch(and(REMEpoch,epoch7),'s');
%     [dur_rem_8, durT_rem_8] = DurationEpoch(and(REMEpoch,epoch8),'s');
%
%
%
%     perc_rem_1 = durT_rem_1 / durT_epoch_1 * 100;
%     perc_rem_2 = durT_rem_2 / durT_epoch_2 * 100;
%     perc_rem_3 = durT_rem_3 / durT_epoch_3 * 100;
%     perc_rem_4 = durT_rem_4 / durT_epoch_4 * 100;
%     perc_rem_5 = durT_rem_5 / durT_epoch_5 * 100;
%     perc_rem_6 = durT_rem_6 / durT_epoch_6 * 100;
%     perc_rem_7 = durT_rem_7 / durT_epoch_7 * 100;
%     perc_rem_8 = durT_rem_8 / durT_epoch_8 * 100;
%
%
%
%     dur_moyenne_ep = [nanmean(dur_rem_1), nanmean(dur_rem_2), nanmean(dur_rem_3), nanmean(dur_rem_4), nanmean(dur_rem_5), nanmean(dur_rem_6), nanmean(dur_rem_7), nanmean(dur_rem_8)];
%     num_moyen_ep = [length(dur_rem_1), length(dur_rem_2), length(dur_rem_3), length(dur_rem_4), length(dur_rem_5), length(dur_rem_6), length(dur_rem_7), length(dur_rem_8)];
%     perc_moyen = [perc_rem_1, perc_rem_2, perc_rem_3, perc_rem_4, perc_rem_5, perc_rem_6, perc_rem_7, perc_rem_8];
% end
%
%
%
%
%
