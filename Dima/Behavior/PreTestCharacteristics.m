function fh = PreTestCharacteristics(nMice, experiment, varargin)
%
% This function plots 4 behavioral metrics of the Shock Zone in the UMaze
% for PreTests
%  - Occupancy of the zone
%  - Number of entries into the zone
%  - Time to enter the zone for the first time
%  - Average speed in the zone
%
% INPUT
%
%     nMice      numbers of mice to include in the analysis
%     IsSave     (optional) true or 1 if to save the figure (default=false)
%     SownPoints (optional) 1 if you want to show individual points (default=0)
% 
%  OUTPUT
%
%     nothing
%
% Coded by Dima Bryzgalov, MOBS team, Paris, France
% 05/11/2020 based on the script I wrote in 2018
% github.com/bryzgalovdm

%% Parameters
FigName = 'BehPreTests';
IsSave = false;
SP = 1;
% nMice = [797 798 828 861 882 905 906 911 912 977 994 1117 1124 1161 1162 1168];

%% Optional Parameters
for i=1:2:length(varargin)    
    switch(lower(varargin{i})) 
        case 'issave'
            IsSave = varargin{i+1};
            if IsSave ~= 1 && IsSave ~= 0
                error('Incorrect value for property ''IsSave'' (type ''help PreTestCharacteristics'' for details).');
            end
        case 'showpoints'
            SP = varargin{i+1};
            if SP ~= 1 && SP ~= 0
                error('Incorrect value for property ''ShowPoints'' (type ''help PreTestCharacteristics'' for details).');
            end
    end
end

%% Manage experiment
if strcmp(experiment, 'PAG')
    fetchpaths = 'UMazePAG';
elseif strcmp(experiment, 'MFB')
    fetchpaths = 'StimMFBWake';
end

%% Get data
Dir = PathForExperimentsERC(fetchpaths);
Dir = RestrictPathForExperiment(Dir,'nMice', nMice);
numsessions = CountNumSesionsERC(Dir);

a = cell(numsessions,1);
cnt=1;
for imouse=1:length(Dir.path)
    for isession = 1:length(Dir.path{imouse})
        a{cnt} = load([Dir.path{imouse}{isession} '/behavResources.mat'], 'behavResources');
        cnt=cnt+1;
    end
end


%% Find indices of PreTests and PostTest session in the structure
id_Pre = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
end

%% Calculate average occupancy
% Calculate occupancy de novo
occup = nan(length(Dir.path), 4, 2); % 4 tests, Shock and Safe

for i=1:length(a)
    for k=1:length(id_Pre{i})
        temp = CalculateZoneOccupancy(a{i}.behavResources(id_Pre{i}(k)));
        occup(i,k,1) = temp(1); % Shock
        occup(i,k,2) = temp(2); % Safe
    end
end

occup_mean = nan(length(a), 2);
occup_std = nan(length(a), 2);

for izone = 1:2 % 1 codes for Shock, 2 for Safe
    occup_mean(:,izone) = mean(squeeze(occup(:,:,izone)),2);
    occup_std(:,izone) = std(squeeze(occup(:,:,izone)),0,2);
end

%% Prepare the 'first enter to shock zone' array

EntryTime = nan(length(Dir.path), 4, 2); % 4 tests, Shock and Safe

for i = 1:length(a)
    for k=1:length(id_Pre{i})
        temp = CalculateFirstEntryZoneTime(a{i}.behavResources(id_Pre{i}(k)), 240);
        EntryTime(i,k,1) = temp(1);
        EntryTime(i,k,2) = temp(2);
    end  
end
    
EntryTime_mean = nan(length(a), 2);
EntryTime_std = nan(length(a), 2);
for izone = 1:2 % 1 codes for Shock, 2 for Safe
    EntryTime_mean(:,izone) = mean(squeeze(EntryTime(:,:,izone)),2);
    EntryTime_std(:,izone) = std(squeeze(EntryTime(:,:,izone)),0,2);
end

%% Calculate number of entries into the shock zone

NumEntries = nan(length(Dir.path), 4, 2); %  4 tests, Shock and Safe

for i = 1:length(a)
    for k=1:length(id_Pre{i})
        temp = CalculateNumEntriesZone(a{i}.behavResources(id_Pre{i}(k)));
        NumEntries(i,k,1) = temp(1);
        NumEntries(i,k,2) = temp(2);
    end  
end

NumEntries_mean = nan(length(a), 2);
NumEntries_std = nan(length(a), 2);
for izone = 1:2 % 1 codes for Shock, 2 for Safe
    NumEntries_mean(:,izone) = mean(squeeze(NumEntries(:,:,izone)),2);
    NumEntries_std(:,izone) = std(squeeze(NumEntries(:,:,izone)),0,2);
end

%% Calculate speed in the safe zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
Speed = nan(length(Dir.path), 4, 2); %  4 tests, Shock and Safe

for i = 1:length(a)
    for k=1:length(id_Pre{i})
        temp = CalculateSpeedZone(a{i}.behavResources(id_Pre{i}(k)));
        Speed(i,k,1) = temp(1);
        Speed(i,k,2) = temp(2);
    end 
end

Speed_mean = nan(length(a), 2);
Speed_std = nan(length(a), 2);
for izone = 1:2 % 1 codes for Shock, 2 for Safe
    Speed_mean(:,izone) = mean(squeeze(Speed(:,:,izone)),2);
    Speed_std(:,izone) = std(squeeze(Speed(:,:,izone)),0,2);
end

%% Plot
% Axes
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.5 0.85]);
Occupancy_Axes = axes('position', [0.09 0.55 0.41 0.41]);
First_Axes = axes('position', [0.57 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.09 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.57 0.05 0.41 0.41]);

if strcmp(experiment, 'PAG')
    colors = {[1 0 0], [0 0 1]};
    xlabels = {'Shock', 'Neutral'};
elseif strcmp(experiment, 'MFB')
    colors = {[0 1 0], [1 1 1]};
    xlabels = {'Reward', 'Neutral'};
end


% Occupancy
axes(Occupancy_Axes);
[~,h_occ] = PlotErrorBarN_DB([occup_mean(:,1)*100 occup_mean(:,2)*100],...
    'barcolors', colors{1}, 'barwidth', 0.4, 'newfig', 0, 'showpoints', SP);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = colors{2};
set(gca,'Xtick',[1:2],'XtickLabel', xlabels);
makepretty
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
if strcmp(experiment, 'MFB')
    ylim([0 63]);
end
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
title('Zone occupancy')
makepretty

axes(NumEntr_Axes);
[~,h_nent] = PlotErrorBarN_DB([NumEntries_mean(:,1) NumEntries_mean(:,2)],...
    'barcolors', colors{1}, 'barwidth', 0.4, 'newfig', 0, 'showpoints',SP);
h_nent.FaceColor = 'flat';
h_nent.CData(2,:) = colors{2};
set(gca,'Xtick',[1:2],'XtickLabel', xlabels);
title('Entries to the zone');
ylabel('Number of entries')
makepretty

axes(First_Axes);
[~,h_first] = PlotErrorBarN_DB([EntryTime_mean(:,1) EntryTime_mean(:,2)],...
    'barcolors', colors{1}, 'barwidth', 0.4, 'newfig', 0, 'showpoints',SP);
h_first.FaceColor = 'flat';
h_first.CData(2,:) = colors{2};
set(gca,'Xtick',[1:2],'XtickLabel', xlabels);
if strcmp(experiment, 'MFB')
    ylim([0 200]);
end
ylabel('Time (s)');
title('Latency to enter the zone')
makepretty

axes(Speed_Axes);
[~,h_speed] = PlotErrorBarN_DB([Speed_mean(:,1) Speed_mean(:,2)],...
    'barcolors', colors{1}, 'barwidth', 0.4, 'newfig', 0, 'showpoints',SP);
h_speed.FaceColor = 'flat';
h_speed.CData(2,:) = colors{2};
set(gca,'Xtick',[1:2],'XtickLabel', xlabels);
ylabel('Speed (cm/s)');
title('Speed in the zone')
makepretty

%% Save
if IsSave
    foldertosave = ChooseFolderForFigures_DB('Behavior');
    saveas(fh,[foldertosave '/' FigName '_' experiment '.fig']);
    saveFigure(fh, [FigName '_' experiment], foldertosave);
end