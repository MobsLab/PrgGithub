%%% Check whether maze2 poses trouble

%% Parameters
old = 0;

% Numbers of mice to run analysis on
% Mice_to_analyze = [797 798 828 861 905 906];
% SideMaze = [0 1 0 1 1 1];
Mice_to_analyze = [882 994];
SideMaze = [0 1];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
Occupancy_Axes = axes('position', [0.07 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.55 0.55 0.41 0.41]);
First_Axes = axes('position', [0.07 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.55 0.05 0.41 0.41]);

%% Get data

for i = 1:length(Dir.path)
    % PreTests
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end

%% Find indices of PreTests and PostTest session in the structure
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    id_Pre{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
            id_Pre{i}(k) = 1;
        end
    end
    id_Pre{i}=find(id_Pre{i});
end

%% Calculate average occupancy
% Calculate occupancy de novo
for i=1:length(a)
    for k=1:length(id_Pre{i})
        for t=1:2 % Shock and Safe zone
            Pre_Occup(i,k,t)=size(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Pre{i}(k)).CleanXtsd),1);
        end
    end
end

temp = Pre_Occup;
for i = 1:length(SideMaze)
    if SideMaze(i)
        PreOccup(i,:,1) = temp(i,:,2);
        PreOccup(i,:,2) = temp(i,:,1);
    end
end

Pre_OccupShock = squeeze(Pre_Occup(:,:,1));
Pre_OccupSafe = squeeze(Pre_Occup(:,:,2));

Pre_OccupShock_mean = mean(Pre_OccupShock,2);
Pre_OccupShock_std = std(Pre_OccupShock,0,2);
Pre_OccupSafe_mean = mean(Pre_OccupSafe,2);
Pre_OccupSafe_std = std(Pre_OccupSafe,0,2);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(Pre_OccupShock_mean, Pre_OccupSafe_mean);

%% Prepare the 'first enter to shock zone' array
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_FirstTimeShock(i,k) = 240;
        else
            Pre_FirstZoneIndicesShock{i}{k} = a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1}(1);
            Pre_FirstTimeShock(i,k) = a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(Pre_FirstZoneIndicesShock{i}{k}(1),1)-...
                a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(1,1);
        end
        
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})
            Pre_FirstTimeSafe(i,k) = 240;
        else
            Pre_FirstZoneIndicesSafe{i}{k} = a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2}(1);
            Pre_FirstTimeSafe(i,k) = a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(Pre_FirstZoneIndicesSafe{i}{k}(1),1)-...
                a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(1,1);
        end
    end
    
end

temp = Pre_FirstTimeShock;
temp2 = Pre_FirstTimeSafe;
for i = 1:length(SideMaze)
    if SideMaze(i)
        Pre_FirstTimeShock(i,:) = temp2(i,:);
        Pre_FirstTimeSafe(i,:) = temp(i,:);
    end
end
clear temp temp2
    
Pre_FirstTimeShock_mean = mean(Pre_FirstTimeShock,2);
Pre_FirstTimeShock_std = std(Pre_FirstTimeShock,0,2);
Pre_FirstTimeSafe_mean = mean(Pre_FirstTimeSafe,2);
Pre_FirstTimeSafe_std = std(Pre_FirstTimeSafe,0,2);
% Wilcoxon test
p_FirstTime_pre_post = signrank(Pre_FirstTimeShock_mean,Pre_FirstTimeSafe_mean);

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_entnumShock(i,k) = 0;
        else
            Pre_entnumShock(i,k)=length(find(diff(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})>1))+1;
        end
        
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})
            Pre_entnumSafe(i,k) = 0;
        else
            Pre_entnumSafe(i,k)=length(find(diff(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})>1))+1;
        end
        
    end
    
end

temp = Pre_entnumShock;
temp2 = Pre_entnumSafe;
for i = 1:length(SideMaze)
    if SideMaze(i)
        Pre_entnumShock(i,:) = temp2(i,:);
        Pre_entnumSafe(i,:) = temp(i,:);
    end
end
clear temp temp2


Pre_entnumShock_mean = mean(Pre_entnumShock,2);
Pre_entnumShock_std = std(Pre_entnumShock,0,2);
Pre_entnumSafe_mean = mean(Pre_entnumSafe,2);
Pre_entnumSafe_std = std(Pre_entnumSafe,0,2);
% Wilcoxon test
p_entnum_pre_post = signrank(Pre_entnumShock_mean, Pre_entnumSafe_mean);

%% Calculate speed in the safe zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        
        % PreTest ShockZone speed
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            VZmean_preShock(i,k) = 0;
        else
            if old
                Vtemp_preShock{i}{k} = tsd(Range(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_preShock{i}{k}=Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd);
            end
            VZone_preShock{i}{k}=Vtemp_preShock{i}{k}(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1}(1:end-1),1);
            VZmean_preShock(i,k)=nanmean(VZone_preShock{i}{k},1);
        end
        
        % PreTest SafeZone speed
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})
            VZmean_preSafe(i,k) = 0;
        else
            if old
                Vtemp_preSafe{i}{k} = tsd(Range(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_preSafe{i}{k}=Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd);
            end
            VZone_preSafe{i}{k}=Vtemp_preSafe{i}{k}(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2}(1:end-1),1);
            VZmean_preSafe(i,k)=nanmean(VZone_preSafe{i}{k},1);
        end
    end
    
    
end

temp = VZmean_preShock;
temp2 = VZmean_preSafe;
for i = 1:length(SideMaze)
    if SideMaze(i)
        VZmean_preShock(i,:) = temp2(i,:);
        VZmean_preSafe(i,:) = temp(i,:);
    end
end
clear temp temp2

VZmean_preShock_mean = mean(VZmean_preShock,2);
VZmean_preShock_std = std(VZmean_preShock,0,2);
VZmean_preSafe_mean = mean(VZmean_preSafe,2);
VZmean_preSafe_std = std(VZmean_preSafe,0,2);
% Wilcoxon test
p_VZmean_pre_post = signrank(VZmean_preShock_mean, VZmean_preSafe_mean);

%% Plot

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_OccupShock_mean*100 Pre_OccupSafe_mean*100],...
    'barcolors', [0.466 .674 .188], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [.635 .078 .184];
set(gca,'Xtick',[1:2],'XtickLabel',{'Left', 'Right'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
title('Occupancy percentage', 'FontSize', 14);
ylim([0 60])

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB([Pre_entnumShock_mean Pre_entnumSafe_mean],...
    'barcolors', [0.466 .674 .188], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_nent.FaceColor = 'flat';
h_nent.CData(2,:) = [.635 .078 .184];
set(gca,'Xtick',[1:2],'XtickLabel',{'Left', 'Right'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the Zone', 'FontSize', 14);
% ylim([0 6])

axes(First_Axes);
[p_first,h_first, her_first] = PlotErrorBarN_DB([Pre_FirstTimeShock_mean Pre_FirstTimeSafe_mean],...
    'barcolors', [0.466 .674 .188], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_first.FaceColor = 'flat';
h_first.CData(2,:) = [.635 .078 .184];
set(gca,'Xtick',[1:2],'XtickLabel',{'Left', 'Right'});
set(gca, 'FontSize', 18, 'FontWeight', 'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the zone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB([VZmean_preShock_mean, VZmean_preSafe_mean],...
    'barcolors', [0.466 .674 .188], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_speed.FaceColor = 'flat';
h_speed.CData(2,:) = [.635 .078 .184];
set(gca,'Xtick',[1:2],'XtickLabel',{'Left', 'Right'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_speed, 'LineWidth', 3);
set(her_speed, 'LineWidth', 3);
ylabel('Speed (cm/s)');
title('Average speed in the zone', 'FontSize', 14);
% ylim([0 8])
