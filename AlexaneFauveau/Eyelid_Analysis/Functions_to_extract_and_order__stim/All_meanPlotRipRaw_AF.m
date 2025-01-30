%% Load the FolderPath 
FolderPath_2Eyelid_Audiodream_AF

%%
BoutDurationBeforeStim = 5; % Give in sec
system = 'piezo';
ValueStim = 1;
state = 'wake';
[megaM_1V_piezo_wake_temps,megaM_1V_piezo_wake_mean,megaM_1V_piezo_wake_std,T_1V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);

ValueStim = 1;
state = 'sleep';
[megaM_1V_piezo_sleep_temps,megaM_1V_piezo_sleep_mean,megaM_1V_piezo_sleep_std,T_1V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);

ValueStim = 1.5;
state = 'wake';
[megaM_15V_piezo_wake_temps,megaM_15V_piezo_wake_mean,megaM_15V_piezo_wake_std,T_15V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);

ValueStim = 1.5;
state = 'sleep';
[megaM_15V_piezo_sleep_temps,megaM_15V_piezo_sleep_mean,megaM_15V_piezo_sleep_std,T_15V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);

ValueStim = 2;
state = 'wake';
[megaM_2V_piezo_wake_temps,megaM_2V_piezo_wake_mean,megaM_2V_piezo_wake_std,T_2V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);

ValueStim = 2;
state = 'sleep';
[megaM_2V_piezo_sleep_temps,megaM_2V_piezo_sleep_mean,megaM_2V_piezo_sleep_std,T_2V_Piezo] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state);


% For Piezo 
    %For 1 Volt
        % For Wake
nb_column = size(megaM_1V_piezo_wake_mean)
for l = 1:length(megaM_1V_piezo_wake_mean)
    megaM_1V_piezo_wake_mean(l,nb_column(2)+1) = mean(megaM_1V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_1V_piezo_wake_mean_std(l,1) = std(megaM_1V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_1V_piezo_wake_median(l,1) = median(megaM_1V_piezo_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_piezo_wake_temps(:,1),megaM_1V_piezo_wake_mean(:,nb_column(2)+1),megaM_1V_piezo_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_1V_piezo_sleep_mean)
for l = 1:length(megaM_1V_piezo_sleep_mean)
    megaM_1V_piezo_sleep_mean(l,nb_column(2)+1) = mean(megaM_1V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_1V_piezo_sleep_mean_std(l,1) = std(megaM_1V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_1V_piezo_sleep_median(l,1) = median(megaM_1V_piezo_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_piezo_sleep_temps(:,1),megaM_1V_piezo_sleep_mean(:,nb_column(2)+1),megaM_1V_piezo_sleep_mean_std(:,1));

%For 1.5 Volt
        % For Wake
nb_column = size(megaM_15V_piezo_wake_mean)
for l = 1:length(megaM_15V_piezo_wake_mean)
    megaM_15V_piezo_wake_mean(l,nb_column(2)+1) = mean(megaM_15V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_15V_piezo_wake_mean_std(l,1) = std(megaM_15V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_15V_piezo_wake_median(l,1) = median(megaM_15V_piezo_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_15V_piezo_wake_temps(:,1),megaM_15V_piezo_wake_mean(:,nb_column(2)+1),megaM_15V_piezo_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_15V_piezo_sleep_mean)
for l = 1:length(megaM_15V_piezo_sleep_mean)
    megaM_15V_piezo_sleep_mean(l,nb_column(2)+1) = mean(megaM_15V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_15V_piezo_sleep_mean_std(l,1) = std(megaM_15V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_15V_piezo_sleep_median(l,1) = median(megaM_15V_piezo_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_15V_piezo_sleep_temps(:,1),megaM_15V_piezo_sleep_mean(:,nb_column(2)+1),megaM_15V_piezo_sleep_mean_std(:,1));



%For 2 Volt
        % For Wake
nb_column = size(megaM_2V_piezo_wake_mean);
for l = 1:length(megaM_2V_piezo_wake_mean)
    megaM_2V_piezo_wake_mean(l,nb_column(2)+1) = mean(megaM_2V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_2V_piezo_wake_mean_std(l,1) = std(megaM_2V_piezo_wake_mean(l,1:nb_column(2)));
    megaM_2V_piezo_wake_median(l,1) = median(megaM_2V_piezo_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_2V_piezo_wake_temps(:,1),megaM_2V_piezo_wake_mean(:,nb_column(2)+1),megaM_2V_piezo_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_2V_piezo_sleep_mean);
for l = 1:length(megaM_2V_piezo_sleep_mean)
    megaM_2V_piezo_sleep_mean(l,nb_column(2)+1) = mean(megaM_2V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_2V_piezo_sleep_mean_std(l,1) = std(megaM_2V_piezo_sleep_mean(l,1:nb_column(2)));
    megaM_2V_piezo_sleep_median(l,1) = median(megaM_2V_piezo_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_2V_piezo_sleep_temps(:,1),megaM_2V_piezo_sleep_mean(:,nb_column(2)+1),megaM_2V_piezo_sleep_mean_std(:,1));
