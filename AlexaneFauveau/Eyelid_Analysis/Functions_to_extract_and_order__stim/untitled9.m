
% For Accelero 
    %For 1 Volt
        % For Wake
nb_column = size(megaM_1V_accelero_wake_mean)
for l = 1:length(megaM_1V_accelero_wake_mean)
    megaM_1V_accelero_wake_mean(l,nb_column(2)+1) = mean(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_1V_accelero_wake_mean_std(l,1) = std(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_1V_accelero_wake_median(l,1) = median(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_accelero_wake_temps(:,1),megaM_1V_accelero_wake_mean(:,nb_column(2)+1),megaM_1V_accelero_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_1V_accelero_sleep_mean)
for l = 1:length(megaM_1V_accelero_sleep_mean)
    megaM_1V_accelero_sleep_mean(l,nb_column(2)+1) = mean(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_1V_accelero_sleep_mean_std(l,1) = std(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_1V_accelero_sleep_median(l,1) = median(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_accelero_sleep_temps(:,1),megaM_1V_accelero_sleep_mean(:,nb_column(2)+1),megaM_1V_accelero_sleep_mean_std(:,1));

%For 1.5 Volt
        % For Wake
nb_column = size(megaM_15V_accelero_wake_mean)
for l = 1:length(megaM_15V_accelero_wake_mean)
    megaM_15V_accelero_wake_mean(l,nb_column(2)+1) = mean(megaM_15V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_15V_accelero_wake_mean_std(l,1) = std(megaM_15V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_15V_accelero_wake_median(l,1) = median(megaM_15V_accelero_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_15V_accelero_wake_temps(:,1),megaM_15V_accelero_wake_mean(:,nb_column(2)+1),megaM_15V_accelero_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_15V_accelero_sleep_mean)
for l = 1:length(megaM_15V_accelero_sleep_mean)
    megaM_15V_accelero_sleep_mean(l,nb_column(2)+1) = mean(megaM_15V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_15V_accelero_sleep_mean_std(l,1) = std(megaM_15V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_15V_accelero_sleep_median(l,1) = median(megaM_15V_accelero_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_15V_accelero_sleep_temps(:,1),megaM_15V_accelero_sleep_mean(:,nb_column(2)+1),megaM_15V_accelero_sleep_mean_std(:,1));



%For 2 Volt
        % For Wake
nb_column = size(megaM_2V_accelero_wake_mean)
for l = 1:length(megaM_2V_accelero_wake_mean)
    megaM_2V_accelero_wake_mean(l,nb_column(2)+1) = mean(megaM_2V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_2V_accelero_wake_mean_std(l,1) = std(megaM_2V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_2V_accelero_wake_median(l,1) = median(megaM_2V_accelero_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_2V_accelero_wake_temps(:,1),megaM_2V_accelero_wake_mean(:,nb_column(2)+1),megaM_2V_accelero_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_2V_accelero_sleep_mean)
for l = 1:length(megaM_2V_accelero_sleep_mean)
    megaM_2V_accelero_sleep_mean(l,nb_column(2)+1) = mean(megaM_2V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_2V_accelero_sleep_mean_std(l,1) = std(megaM_2V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_2V_accelero_sleep_median(l,1) = median(megaM_2V_accelero_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_2V_accelero_sleep_temps(:,1),megaM_2V_accelero_sleep_mean(:,nb_column(2)+1),megaM_2V_accelero_sleep_mean_std(:,1));