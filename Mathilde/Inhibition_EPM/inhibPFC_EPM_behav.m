%% input dir
dir_EPM_saline = PathForExperiments_EPM_MC('EPM_behav_wiCable_saline');
% dir_EPM_saline=RestrictPathForExperiment(dir_EPM_saline,'nMice',[1237 1238]);
dir_EPM_cno = PathForExperiments_EPM_MC('EPM_behav_wiCable_inhibitionPFC');
% dir_EPM_cno=RestrictPathForExperiment(dir_EPM_cno,'nMice',[1237 1238]);

% dir_EPM_saline = PathForExperiments_EPM_MC('EPM_behav_woCable_saline');
% dir_EPM_cno = PathForExperiments_EPM_MC('EPM_behav_woCable_inhibitionPFC');


% dir_EPM_saline = PathForExperiments_EPM_MC('EPM_behav_retro_cre_saline');
% dir_EPM_cno = PathForExperiments_EPM_MC('EPM_behav_retro_cre_cno');

% dir_EPM_saline = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_saline');
% dir_EPM_cno = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_cno');


% dir_EPM_saline = PathForExperiments_EPM_MC('EPM_ctrl');
% % dir_EPM_saline=RestrictPathForExperiment(dir_EPM_saline,'nMice',[1449 1450 1451 1452]);
% 
% dir_EPM_cno = PathForExperiments_EPM_MC('EPM_Post_SD');


%% parameters
time=300;
TotEpoch=intervalSet(0,time*1e4);

same_len=4300;

%for some mice zones (open & close arms) were inverted during the GetZoneBehav
%during the experiment
MouseNumber_sal = [1449 1450 1451 1452 1453];
IsInverted_sal = [0,0,0,0,0];


for imouse=1:length(MouseNumber_sal)
    if  IsInverted_sal(imouse)==0
        idx_open_sal(imouse) = 1;
        idx_close_sal(imouse) = 2;
    else
        idx_open_sal(imouse) = 2;
        idx_close_sal(imouse) = 1;
    end
    idx_center_sal(imouse) = 3;
end

%% get data for saline
for k=1:length(dir_EPM_saline.path)
    cd(dir_EPM_saline.path{k}{1});
    %%load behav
    behav_sal{k} = load('behavResources.mat','Xtsd','Ytsd','Vtsd','Occup','ZoneEpoch','ZoneIndices','PosMat','MouseTemp_tsd');
    
    %%get trajectories in each zone
    %%zone1 (open) & zone2 (close) inversées pdt GetZoneBehav !!
    x_open_sal{k}=Data(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_open_sal(k)}));
    y_open_sal{k}=Data(Restrict(behav_sal{k}.Ytsd,behav_sal{k}.ZoneEpoch{idx_open_sal(k)}));
    x_close_sal{k}=Data(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_close_sal(k)}));
    y_close_sal{k}=Data(Restrict(behav_sal{k}.Ytsd,behav_sal{k}.ZoneEpoch{idx_close_sal(k)}));
    x_center_sal{k}=Data(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_center_sal(k)}));
    y_center_sal{k}=Data(Restrict(behav_sal{k}.Ytsd,behav_sal{k}.ZoneEpoch{idx_center_sal(k)}));
    
    %%occupancy
    occup_open_sal(k)=behav_sal{k}.Occup(idx_open_sal(k)).*100;
    occup_close_sal(k)=behav_sal{k}.Occup(idx_close_sal(k)).*100;
    occup_center_sal(k)=behav_sal{k}.Occup(idx_center_sal(k)).*100;
    %%occupancy overtime
    [Y_open_sal,X_open_sal] = hist(Range(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_open_sal(k)}),'s'),[0:5:300]);
    TimeOccupancyOpenArms_sal(:,k) = Y_open_sal;
    [Y_close_sal,X_close_sal] = hist(Range(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_close_sal(k)}),'s'),[0:5:300]);
    TimeOccupancyClosedArms_sal(:,k) = Y_close_sal;
    [Y_center_sal,X_center_sal] = hist(Range(Restrict(behav_sal{k}.Xtsd,behav_sal{k}.ZoneEpoch{idx_center_sal(k)}),'s'),[0:5:300]);
    TimeOccupancyCenter_sal(:,k) = Y_center_sal;

    %%mean duration in each zone
%     MeanDurOpen_sal(k)=sum(Stop(TotEpoch-behav_sal{k}.ZoneEpoch{idx_open_sal(k)},'s')-Start(TotEpoch-behav_sal{k}.ZoneEpoch{idx_open_sal(k)},'s'));
%     MeanDurClosed_sal(k)=sum(Stop(TotEpoch-behav_sal{k}.ZoneEpoch{idx_close_sal(k)},'s')-Start(TotEpoch-behav_sal{k}.ZoneEpoch{idx_close_sal(k)},'s'));
%     MeanDurCenter_sal(k)=sum(Stop(TotEpoch-behav_sal{k}.ZoneEpoch{idx_center_sal(k)},'s')-Start(TotEpoch-behav_sal{k}.ZoneEpoch{idx_center_sal(k)},'s'));
    
    MeanDurOpen_sal(k)=sum(Stop(behav_sal{k}.ZoneEpoch{idx_open_sal(k)},'s')-Start(behav_sal{k}.ZoneEpoch{idx_open_sal(k)},'s'));
    MeanDurClosed_sal(k)=sum(Stop(behav_sal{k}.ZoneEpoch{idx_close_sal(k)},'s')-Start(behav_sal{k}.ZoneEpoch{idx_close_sal(k)},'s'));
    MeanDurCenter_sal(k)=sum(Stop(behav_sal{k}.ZoneEpoch{idx_center_sal(k)},'s')-Start(behav_sal{k}.ZoneEpoch{idx_center_sal(k)},'s'));
    
    
    %%number of entries
    for izone = 1:length(behav_sal{k}.ZoneIndices)
        if isempty(behav_sal{k}.ZoneIndices{izone})
            num_entries_sal{k}(izone) = 0;
        else
            num_entries_sal{k}(izone)=length(find(diff(behav_sal{k}.ZoneIndices{izone})>1))+1;
        end
    end
    num_entries_open_sal(k) = num_entries_sal{k}(idx_open_sal(k));
    num_entries_close_sal(k) = num_entries_sal{k}(idx_close_sal(k));
    num_entries_center_sal(k) = num_entries_sal{k}(idx_center_sal(k));
    
    %%first entry
    for izone = 1:length(behav_sal{k}.ZoneIndices)
        if isempty(behav_sal{k}.ZoneIndices{izone})
            first_entry_sal{k}(izone) = 120;
        else
            first_entry_zoneIndices_sal{k}(izone) = behav_sal{k}.ZoneIndices{izone}(1);
            first_entry_sal{k}(izone) =  behav_sal{k}.PosMat(first_entry_zoneIndices_sal{k}(izone),1);
        end
        
    end
    first_entry_open_sal(k) = first_entry_sal{k}(idx_open_sal(k));
    first_entry_close_sal(k) = first_entry_sal{k}(idx_close_sal(k));
    first_entry_center_sal(k) = first_entry_sal{k}(idx_center_sal(k));
    
    %%speed
    for izone = 1:length(behav_sal{k}.ZoneIndices)
        if isempty(behav_sal{k}.ZoneIndices{izone})
            speedZone_mean_sal{k}(izone) = 0;
        else
            speedtemp_sal{k}{izone}=Data(behav_sal{k}.Vtsd);
            speedZone_sal{k}{izone}=speedtemp_sal{k}{izone}(behav_sal{k}.ZoneIndices{izone}(1:end-1),1);
            speedZone_mean_sal{k}(izone)=nanmean(speedZone_sal{k}{izone},1);
        end
    end
    speed_open_sal(k) = speedZone_mean_sal{k}(idx_open_sal(k));
    speed_close_sal(k) = speedZone_mean_sal{k}(idx_close_sal(k));
    speed_center_sal(k) = speedZone_mean_sal{k}(idx_center_sal(k));
    
    %%
%     [Y_speed_open_sal,X_speed_open_sal] = hist(speedZone_sal{k}{idx_open_sal(k)},[0:5:300]);
%     SpeedOpen_sal(:,k) = Y_speed_open_sal;
%     
%     [Y_speed_close_sal,X_speed_close_sal] = hist(speedZone_sal{k}{idx_close_sal(k)},[0:5:300]);
%     SpeedClose_sal(:,k) = Y_speed_close_sal;
%     
%     [Y_speed_center_sal,X_speed_center_sal] = hist(speedZone_sal{k}{idx_center_sal(k)},[0:5:300]);
%     SpeedCenter_sal(:,k) = Y_speed_center_sal;
%     
%     
            %%speed
        Speed_sal{k} = Data(behav_sal{k}.Vtsd);
        speed_sal(:,k) = Speed_sal{k}(1:same_len);
%         
        
%     %%speed overtime
%     [Y_speed_open_sal,X_speed_open_sal] = hist(Range(Restrict(behav_sal{k}.Vtsd,behav_sal{k}.ZoneEpoch{idx_open_sal(k)}),'s'),[0:5:300]);
%     SpeedOpen_sal(:,k) = Y_speed_open_sal;
%     [Y_speed_close_sal,X_speed_close_sal] = hist(Range(Restrict(behav_sal{k}.Vtsd,behav_sal{k}.ZoneEpoch{idx_close_sal(k)}),'s'),[0:5:300]);
%     SpeedClose_sal(:,k) = Y_speed_close_sal;
%     [Y_speed_center_sal,X_speed_center_sal] = hist(Range(Restrict(behav_sal{k}.Vtsd,behav_sal{k}.ZoneEpoch{idx_center_sal(k)}),'s'),[0:5:300]);
%     SpeedCenter_sal(:,k) = Y_speed_center_sal;
    
    
%         %%temperature
%         temperature_sal{k} = Data(behav_sal{k}.MouseTemp_tsd);
%         temp_sal(:,k) = temperature_sal{k}(1:same_len);
% temperature_open_sal(k) = nanmean(Data(Restrict(behav_sal{k}.MouseTemp_tsd,behav_sal{k}.ZoneEpoch{idx_open_sal(k)})));
% temperature_close_sal(k) = nanmean(Data(Restrict(behav_sal{k}.MouseTemp_tsd,behav_sal{k}.ZoneEpoch{idx_close_sal(k)})));
% temperature_center_sal(k) = nanmean(Data(Restrict(behav_sal{k}.MouseTemp_tsd,behav_sal{k}.ZoneEpoch{idx_center_sal(k)})));


end


%% get data for PFC inhibition (cno)
%%parameters
time=300;
TotEpoch=intervalSet(0,time*1e4);

%%for some mice zones (open & close arms) were inverted during the GetZoneBehav
%%during the experiment
MouseNumber_cno = [1429 1430 1431 1432];
IsInverted_cno = [0,0,0,0];

for imouse=1:length(MouseNumber_cno)
    if  IsInverted_cno(imouse)==0
        idx_open_cno(imouse) = 1;
        idx_close_cno(imouse) = 2;
    else
        idx_open_cno(imouse) = 2;
        idx_close_cno(imouse) = 1;
    end
    idx_center_cno(imouse) = 3;
end

%%get data
for i=1:length(dir_EPM_cno.path)
    cd(dir_EPM_cno.path{i}{1});
    %%load behav
    behav_cno{i} = load('behavResources.mat','Xtsd','Ytsd','Vtsd','Occup','ZoneEpoch','ZoneIndices','PosMat','MouseTemp_tsd');
    
    %%get trajectories in each zone
    %%zone1 (open) & zone2 (close) inversées pdt GetZoneBehav !!
    x_open_cno{i}=Data(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_open_cno(i)}));
    y_open_cno{i}=Data(Restrict(behav_cno{i}.Ytsd,behav_cno{i}.ZoneEpoch{idx_open_cno(i)}));
    x_close_cno{i}=Data(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_close_cno(i)}));
    y_close_cno{i}=Data(Restrict(behav_cno{i}.Ytsd,behav_cno{i}.ZoneEpoch{idx_close_cno(i)}));
    x_center_cno{i}=Data(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_center_cno(i)}));
    y_center_cno{i}=Data(Restrict(behav_cno{i}.Ytsd,behav_cno{i}.ZoneEpoch{idx_center_cno(i)}));
    
    %%occupancy
    occup_open_cno(i)=behav_cno{i}.Occup(idx_open_cno(i)).*100;
    occup_close_cno(i)=behav_cno{i}.Occup(idx_close_cno(i)).*100;
    occup_center_cno(i)=behav_cno{i}.Occup(idx_center_cno(i)).*100;
    %%occupancy overtime
    [Y_open_cno,X_open_cno] = hist(Range(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_open_cno(i)}),'s'),[0:5:300]);
    TimeOccupancyOpenArms_cno(:,i) = Y_open_cno;
    [Y_close_cno,X_close_cno] = hist(Range(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_close_cno(i)}),'s'),[0:5:300]);
    TimeOccupancyClosedArms_cno(:,i) = Y_close_cno;
    [Y_center_cno,X_center_cno] = hist(Range(Restrict(behav_cno{i}.Xtsd,behav_cno{i}.ZoneEpoch{idx_center_cno(i)}),'s'),[0:5:300]);
    TimeOccupancyCenter_cno(:,i) = Y_center_cno;
    
    %%mean duration in each zone
%     MeanDurOpen_cno(i)=sum(Stop(TotEpoch-behav_cno{i}.ZoneEpoch{idx_open_cno(i)},'s')-Start(TotEpoch-behav_cno{i}.ZoneEpoch{idx_open_cno(i)},'s'));
%     MeanDurClosed_cno(i)=sum(Stop(TotEpoch-behav_cno{i}.ZoneEpoch{idx_close_cno(i)},'s')-Start(TotEpoch-behav_cno{i}.ZoneEpoch{idx_close_cno(i)},'s'));
%     MeanDurCenter_cno(i)=sum(Stop(TotEpoch-behav_cno{i}.ZoneEpoch{idx_center_cno(i)},'s')-Start(TotEpoch-behav_cno{i}.ZoneEpoch{idx_center_cno(i)},'s'));
        MeanDurOpen_cno(i)=sum(Stop(behav_cno{i}.ZoneEpoch{idx_open_cno(i)},'s')-Start(behav_cno{i}.ZoneEpoch{idx_open_cno(i)},'s'));
    MeanDurClosed_cno(i)=sum(Stop(behav_cno{i}.ZoneEpoch{idx_close_cno(i)},'s')-Start(behav_cno{i}.ZoneEpoch{idx_close_cno(i)},'s'));
    MeanDurCenter_cno(i)=sum(Stop(behav_cno{i}.ZoneEpoch{idx_center_cno(i)},'s')-Start(behav_cno{i}.ZoneEpoch{idx_center_cno(i)},'s'));
    
    
    %%number of entries
    for izone = 1:length(behav_cno{i}.ZoneIndices)
        if isempty(behav_cno{i}.ZoneIndices{izone})
            num_entries_cno{i}(izone) = 0;
        else
            num_entries_cno{i}(izone)=length(find(diff(behav_cno{i}.ZoneIndices{izone})>1))+1;
        end
    end
    num_entries_open_cno(i) = num_entries_cno{i}(idx_open_cno(i));
    num_entries_close_cno(i) = num_entries_cno{i}(idx_close_cno(i));
    num_entries_center_cno(i) = num_entries_cno{i}(idx_center_cno(i));
    
    %%first entry
    for izone = 1:length(behav_cno{i}.ZoneIndices)
        if isempty(behav_cno{i}.ZoneIndices{izone})
            first_entry_cno{i}(izone) = 120;
        else
            first_entry_zoneIndices_cno{i}(izone) = behav_cno{i}.ZoneIndices{izone}(1);
            first_entry_cno{i}(izone) =  behav_cno{i}.PosMat(first_entry_zoneIndices_cno{i}(izone),1);
        end
        
    end
    first_entry_open_cno(i) = first_entry_cno{i}(idx_open_cno(i));
    first_entry_close_cno(i) = first_entry_cno{i}(idx_close_cno(i));
    first_entry_center_cno(i) = first_entry_cno{i}(idx_center_cno(i));
    
    %%speed
    for izone = 1:length(behav_cno{i}.ZoneIndices)
        if isempty(behav_cno{i}.ZoneIndices{izone})
            speedZone_mean_cno{i}(izone) = 0;
        else
            speedtemp_cno{i}{izone}=Data(behav_cno{i}.Vtsd);
            speedZone_cno{i}{izone}=speedtemp_cno{i}{izone}(behav_cno{i}.ZoneIndices{izone}(1:end-1),1);
            speedZone_mean_cno{i}(izone)=nanmean(speedZone_cno{i}{izone},1);
        end
    end
    speed_open_cno(i) = speedZone_mean_cno{i}(idx_open_cno(i));
    speed_close_cno(i) = speedZone_mean_cno{i}(idx_close_cno(i));
    speed_center_cno(i) = speedZone_mean_cno{i}(idx_center_cno(i));
    
    
          %%speed
        Speed_cno{i} = Data(behav_cno{i}.Vtsd);
        speed_cno(:,i) = Speed_cno{i}(1:same_len);
        
        
%     %%speed overtime
%     [Y_speed_open_cno,X_speed_open_cno] = hist(Range(Restrict(behav_cno{i}.Vtsd,behav_cno{i}.ZoneEpoch{idx_open_cno(i)}),'s'),[0:5:300]);
%     SpeedOpen_cno(:,i) = Y_speed_open_cno;
%     [Y_speed_close_cno,X_speed_close_cno] = hist(Range(Restrict(behav_cno{i}.Vtsd,behav_cno{i}.ZoneEpoch{idx_close_cno(i)}),'s'),[0:5:300]);
%     SpeedClose_cno(:,i) = Y_speed_close_cno;
%     [Y_speed_center_cno,X_speed_center_cno] = hist(Range(Restrict(behav_cno{i}.Vtsd,behav_cno{i}.ZoneEpoch{idx_center_cno(i)}),'s'),[0:5:300]);
%     SpeedCenter_cno(:,i) = Y_speed_center_cno;
    
    
    
%     %%temperature
%     temperature_cno{i} = Data(behav_cno{i}.MouseTemp_tsd);
%     temp_cno(:,i) = temperature_cno{i}(1:same_len);
% temperature_open_cno(i) = nanmean(Data(Restrict(behav_cno{i}.MouseTemp_tsd,behav_cno{i}.ZoneEpoch{idx_open_cno(i)})));
% temperature_close_cno(i) = nanmean(Data(Restrict(behav_cno{i}.MouseTemp_tsd,behav_cno{i}.ZoneEpoch{idx_close_cno(i)})));
% temperature_center_cno(i) = nanmean(Data(Restrict(behav_cno{i}.MouseTemp_tsd,behav_cno{i}.ZoneEpoch{idx_center_cno(i)})));


end




%% figure
% figure,
% 
% subplot(4,4,[1,2])


% subplot(241),plot(x_open,y_open,'color',[0.5 0.5 0.5]),hold on
% plot(x_center,y_center,'color',[0.5 0.5 0.5])
% plot(x_close,y_close,'color',[0.5 0.5 0.5])

figure, hold on
shadedErrorBar([0:5:300], TimeOccupancyOpenArms_sal'./100, {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(TimeOccupancyOpenArms_sal'./100),'-ko','MarkerSize',10,'MarkerFaceColor',[1 1 1])

shadedErrorBar([0:5:300], TimeOccupancyClosedArms_sal'./100, {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(TimeOccupancyClosedArms_sal'./100),'-ko','MarkerSize',10,'MarkerFaceColor',[0.3 0.3 0.3])

shadedErrorBar([0:5:300], TimeOccupancyCenter_sal'./100, {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(TimeOccupancyCenter_sal'./100),':k+','MarkerSize',10,'MarkerFaceColor',[0 0 0])

makepretty
ylim([0 1])
ylabel('Time proportion')
xlabel('Time (s)')


figure, hold on
shadedErrorBar([0:5:300], TimeOccupancyOpenArms_cno'./100, {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(TimeOccupancyOpenArms_cno'./100),'-ro','MarkerSize',10,'MarkerFaceColor',[1 1 1])

shadedErrorBar([0:5:300], TimeOccupancyClosedArms_cno'./100, {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(TimeOccupancyClosedArms_cno'./100),'-ro','MarkerSize',10,'MarkerFaceColor',[1 0 0])

shadedErrorBar([0:5:300], TimeOccupancyCenter_cno'./100, {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(TimeOccupancyCenter_cno'./100),':r+','MarkerSize',10,'MarkerFaceColor',[0 0 0])

makepretty
ylim([0 1])
ylabel('Time proportion')
xlabel('Time (s)')

%%
col_sal = [.8 .8 .8];
col_cno = [1 0 0];

ispaired = 0;

figure
subplot(321),
MakeBoxPlot_MC({occup_open_sal, occup_open_cno, occup_close_sal, occup_close_cno, occup_center_sal, occup_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},0,ispaired);
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Percentage of time (%)')
makepretty

subplot(322),
MakeBoxPlot_MC({MeanDurOpen_sal, MeanDurOpen_cno, MeanDurClosed_sal, MeanDurClosed_cno, MeanDurCenter_sal, MeanDurCenter_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},0,ispaired);
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Mean duration (s)')
makepretty

subplot(323),
MakeBoxPlot_MC({num_entries_open_sal, num_entries_open_cno, num_entries_close_sal, num_entries_close_cno, num_entries_center_sal, num_entries_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},0,ispaired);
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Number of entries')
makepretty

subplot(324), 
MakeBoxPlot_MC({first_entry_open_sal, first_entry_open_cno, first_entry_close_sal, first_entry_close_cno, first_entry_center_sal, first_entry_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},0,ispaired);
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Latency to enter the zone (sec)')
makepretty

subplot(325),
MakeBoxPlot_MC({speed_open_sal, speed_open_cno, speed_close_sal, speed_close_cno, speed_center_sal, speed_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},0,ispaired);
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Speed (cm/s)')
makepretty

% subplot(326),
% MakeBoxPlot_MC({temperature_open_sal, temperature_open_cno, temperature_close_sal, temperature_close_cno, temperature_center_sal, temperature_center_cno},...
%     {col_sal col_cno col_sal col_cno col_sal col_cno},[1:2,4:5,7:8],{},1,ispaired);
% xticks([1.5 4.5 7.5]); xticklabels({'Open arm','Closed arm', 'Center'})
% ylabel('Temperature (°C)')
% makepretty

%%
t = Range(behav_cno{3}.Vtsd)/1e4;


figure,hold on
shadedErrorBar(t(1:same_len), nanmean(runmean(temp_sal',20)), stdError(temp_sal'), 'k', 1)
shadedErrorBar(t(1:same_len), nanmean(runmean(temp_cno',20)), stdError(temp_cno'), 'r', 1)
xlim([0 300])
ylim([27 35])
xlabel('Time (s)')
ylabel('Temperature (°C)')
makepretty



%%


figure, hold on
shadedErrorBar([0:5:300], SpeedOpen_sal', {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(SpeedOpen_sal'),'-ko','MarkerSize',10,'MarkerFaceColor',[1 1 1])

shadedErrorBar([0:5:300], SpeedClose_sal', {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(SpeedClose_sal'),'-ko','MarkerSize',10,'MarkerFaceColor',[0.3 0.3 0.3])

shadedErrorBar([0:5:300], SpeedCenter_sal', {@nanmean,@stdError}, 'k', 1)
plot([0:5:300],mean(SpeedCenter_sal'),':k+','MarkerSize',10,'MarkerFaceColor',[0 0 0])

makepretty
ylim([0 90])
ylabel('Speed (cm/s)')
xlabel('Time (s)')

figure, hold on
shadedErrorBar([0:5:300], SpeedOpen_cno', {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(SpeedOpen_cno'),'-ro','MarkerSize',10,'MarkerFaceColor',[1 1 1])

shadedErrorBar([0:5:300], SpeedClose_cno', {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(SpeedClose_cno'),'-ro','MarkerSize',10,'MarkerFaceColor',[1 0 0])

shadedErrorBar([0:5:300], SpeedCenter_cno', {@nanmean,@stdError}, 'r', 1)
plot([0:5:300],mean(SpeedCenter_cno'),':r+','MarkerSize',10,'MarkerFaceColor',[0 0 0])

makepretty
ylim([0 90])
ylabel('Speed (cm/s)')
xlabel('Time (s)')

%%

figure,hold on
shadedErrorBar(t(1:same_len), nanmean(runmean(speed_sal',20000)), stdError(speed_sal'), 'k', 1)
shadedErrorBar(t(1:same_len), nanmean(runmean(speed_cno',20000)), stdError(speed_cno'), 'r', 1)
xlim([0 300])
ylim([0 90])
xlabel('Time (s)')
ylabel('Speed (cm/s)')
makepretty



%%


col_sal = [.8 .8 .8];
col_cno = [1 0 0];


figure
subplot(321),
MakeSpreadAndBoxPlot2_SB({occup_open_sal, occup_open_cno, occup_close_sal, occup_close_cno, occup_center_sal, occup_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Percentage of time (%)')
makepretty

subplot(322),
MakeSpreadAndBoxPlot2_SB({MeanDurOpen_sal, MeanDurOpen_cno, MeanDurClosed_sal, MeanDurClosed_cno, MeanDurCenter_sal, MeanDurCenter_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Mean duration (s)')
makepretty

subplot(323),
MakeSpreadAndBoxPlot2_SB({num_entries_open_sal, num_entries_open_cno, num_entries_close_sal, num_entries_close_cno, num_entries_center_sal, num_entries_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Number of entries')
makepretty

subplot(324), 
MakeSpreadAndBoxPlot2_SB({first_entry_open_sal, first_entry_open_cno, first_entry_close_sal, first_entry_close_cno, first_entry_center_sal, first_entry_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Latency to enter the zone (sec)')
makepretty

subplot(325),
MakeSpreadAndBoxPlot2_SB({speed_open_sal, speed_open_cno, speed_close_sal, speed_close_cno, speed_center_sal, speed_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Speed (cm/s)')
makepretty

subplot(326),
MakeSpreadAndBoxPlot2_SB({temperature_open_sal, temperature_open_cno, temperature_close_sal, temperature_close_cno, temperature_center_sal, temperature_center_cno},...
    {col_sal col_cno col_sal col_cno col_sal col_cno},[1:6],{},'ShowPoints',0,'paired',ispaired,'optiontest','ttest');
xticks([1.5 3.5 5.5]); xticklabels({'Open arm','Closed arm', 'Center'})
ylabel('Temperature (°C)')
makepretty


%%

figure

for imouse=1:length(dir_EPM_saline.path)
subplot(2,4,imouse), hold on
plot(x_open_sal{imouse},y_open_sal{imouse},'color',[0.5 0.5 0.5]),hold on
plot(x_center_sal{imouse},y_center_sal{imouse},'color',[0.5 0.5 0.5])
plot(x_close_sal{imouse},y_close_sal{imouse},'color',[0.5 0.5 0.5])
makepretty
end



for imouse=1:length(dir_EPM_cno.path)
subplot(2,4,imouse+4), hold on
plot(x_open_cno{imouse},y_open_cno{imouse},'color',[1 0 0]),hold on
plot(x_center_cno{imouse},y_center_cno{imouse},'color',[1 0 0])
plot(x_close_cno{imouse},y_close_cno{imouse},'color',[1 0 0])
makepretty
end





%%
col_basal = [.8 .8 .8];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];

ispaired=0;



figure,


subplot(131)
plot(x_open_sal{1},y_open_sal{1},'color',[0.5 0.5 0.5]),hold on
plot(x_center_sal{1},y_center_sal{1},'color',[0.5 0.5 0.5])
plot(x_close_sal{1},y_close_sal{1},'color',[0.5 0.5 0.5])
makepretty


subplot(132)
plot(x_open_cno{imouse},y_open_cno{imouse},'color',[1 0 0]),hold on
plot(x_center_cno{imouse},y_center_cno{imouse},'color',[1 0 0])
plot(x_close_cno{imouse},y_close_cno{imouse},'color',[1 0 0])
makepretty


subplot(133)
PlotErrorBarN_KJ({occup_open_sal, occup_open_cno},'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1,2],'barcolors',{col_basal,col_SD});
xticks([1 2]); xticklabels({'CTRL','SDS'}); xtickangle(0)
ylabel('Time in open arm (s)')
makepretty
[h,p_basal_SD]=ttest2(occup_open_sal, occup_open_cno);
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
