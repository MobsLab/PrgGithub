%%% FindAllPlaceCells




%% Parameters
% Mice in the analysis
nmouse = [797 798 828 861 882 905 906 911 912 977 994];
% nmouse = [906 912]; % Had PreMazes
% nmouse = [905 911]; % Did not have PreMazes

% Paths retrieved
% Dir = PathForExperimentsERC_Dima('UMazePAG'); 
Dir = PathForExperimentsERC_DimaMAC('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

% SizeMap
sizemap = 50; % ---- corresponds to around ~0.8 cm per pixel

% Smoothing
smoothing = 2;

% Threshold on speed (im cm/s, epoch with lower are not considered)
speed_thresh = 3;

% Do you want to save a figure?
sav = false;

% Paths and names to save
pathfig = '/MOBS_workingON/Dima/Ongoing_results/PlaceField_Final/Stability/'; % without dropbox path


%% PreAllocation



%% Load Data
for i=1:length(Dir.path)
    Spikes{i} = load([Dir.path{i}{1} '/SpikeData.mat']);
    beh{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'SessionEpoch','CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
    
    UMazeEpoch{i} = or(beh{i}.SessionEpoch.Hab,beh{i}.SessionEpoch.TestPre1);
    UMazeEpoch{i} = or(UMazeEpoch{i},beh{i}.SessionEpoch.TestPre2);
    UMazeEpoch{i} = or(UMazeEpoch{i},beh{i}.SessionEpoch.TestPre3);
    UMazeEpoch{i} = or(UMazeEpoch{i},beh{i}.SessionEpoch.TestPre4);
end

%% Calculate number of cells
totalCells = 0;
for i=1:length(Dir.path)
        totalCells = totalCells + length(Spikes{i}.S);
end

%% Calculate rate maps
a = 0;
b = 0;
for i=1:length(Dir.path)
    c=0;
    LocomotionEpoch = thresholdIntervals(tsd(Range(beh{i}.CleanVtsd),movmedian(Data(beh{i}.CleanVtsd),5)),...
        2,'Direction','Above');
    for j=1:length(Spikes{i}.S)
        b=b+1;
        try
            
            [map{b}, ~, stat{b}, ~, ~, FR{b}]=PlaceField_DB(Restrict(Spikes{i}.S{j},UMazeEpoch{i}),...
                Restrict(beh{i}.CleanAlignedXtsd,UMazeEpoch{i}),...
                Restrict(beh{i}.CleanAlignedYtsd,UMazeEpoch{i}),'threshold',0.5, 'plotresults',0,'plotpoisson',0);
            
        catch
            stat{b}=[];
        end
        if ~isempty(stat{b})
            if ~isempty(stat{b}.spatialInfo)
                if stat{b}.spatialInfo > 0.8 && FR{b} > 0.25
                    a = a+1;
                    c=c+1;
                    stats{a} = stat{b};
                    mapout{a} = map{b};
                    idx{a}=[i j];
                    PlaceCell{i}.idx(c) = j;
                end
            end
        end
    end
    close all
end


perc_PC = length(idx)/totalCells*100;
mazeMap = [6 7; 6 59; 59 59; 59 7; 39 7; 39 42; 24 42; 24 7; 6 7];
ShockZoneMap = [6 7; 6 30; 24 30; 24 7; 6 7];

%% Find SZ-overlapping spikes
FakeSZ = zeros (62,62);
FakeSZ (7:25,8:30) = 1;

% FakeSZ = zeros (93,93);
% FakeSZ (12:45,9:38) = 1;

d=0;
for i=1:length(stats)
    if iscell(stats{i}.field)
        for k=1:2
            OverlappedFields = FakeSZ & stats{i}.field{k};
            numOverlap(i,j) = nnz(OverlappedFields);
            if numOverlap(i,j) > 0
                d=d+1;
                overlapCells(d) = i;
            end
        end
    else
        OverlappedFields = FakeSZ & stats{i}.field;
        numOverlap(i,j) = nnz(OverlappedFields);
        if numOverlap(i,j) > 0
            d=d+1;
            overlapCells(d) = i;
        end
    end
end

for i=1:length(Dir.path)
    PlaceCell{i}.SZ= 0;
end

for i=1:length(overlapCells)
    PlaceCell{idx{overlapCells(i)}(1)}.SZ(end+1)= idx{overlapCells(i)}(2);
end
for i=1:length(Dir.path)
    PlaceCell{i}.SZ= nonzeros(PlaceCell{i}.SZ);
end

%% Save the place cell information in the apppropriate folders
% for i=1:length(Dir.path)
%     PlaceCells = PlaceCell{i};
%     save([Dir.path{i}{1} 'SpikeData.mat'],'PlaceCells','-append');
% end

%% Figure

%Prepare an array
result=zeros(62,62);
% mazeMap2 = [24 15; 24 77; 85 77; 85 15; 63 15;  63 58; 46 58; 46 15; 24 15];
% ShockZoneMap2 = [24 15; 24 48; 46 48; 46 15; 24 15];

for i=1:length(stats)
    if iscell(stats{i}.field)
        for k=1:2
            result = result+stats{i}.field{k};
        end
    else
        result = result+stats{i}.field;
    end
end

fh = figure('units', 'normalized', 'outerposition', [0 1 1 1]);

imagesc(result);
axis xy
% caxis([0 2])
colormap jet
hold on
plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',4)
plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',4)
set(gca,'XTickLabel',{},'YTickLabel',{});

title([num2str(length(Dir.path)) ' mice, ' num2str(length(stats)) ' PCs, ', num2str(perc_PC) '% of all units found, ' ...
    num2str(length(overlapCells)) ' PCs overlapping with SZ'], 'FontWeight','bold','FontSize',18);


saveas(fh,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/AllPlaceFields_Cur.fig']);
saveFigure(fh,'AllPlaceFields_Cur','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/');

% Fields separately
fi = figure('units', 'normalized', 'outerposition', [0 1 1 1]);
for i=1:length(idx)
    subplot(9,10,i)
    if iscell(stats{i}.field)
        imagesc(stats{i}.field{1}+stats{i}.field{2})
        axis xy
        hold on
        plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',3)
        plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',3)
        title([Dir.name{idx{i}(1)} ' Cl' num2str(idx{i}(2))])
    else
        imagesc(stats{i}.field)
        axis xy
        hold on
        plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',3)
        plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',3)
        title([Dir.name{idx{i}(1)} ' Cl' num2str(idx{i}(2))])
    end
    hold off
end



%% Plot all the place cells
fa = figure('units', 'normalized', 'outerposition', [0 1 1 1]);
for i=1:length(stats)
    subplot(9,10,i)
    imagesc(mapout{i}.rate)
    axis xy
    hold on
    plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',3)
    plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',3)
    hold off
end


