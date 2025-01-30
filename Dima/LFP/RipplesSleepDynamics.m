%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/LFP/';
fig_post = 'RipplesSleepDynamics';

Dir = PathForExperimentsERC_Dima('UMazePAG');
% Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912]);
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 912 977]);

%% Get Data
for i = 1:length(Dir.path)
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'Sleep', 'SWSEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'SessionEpoch');
    else
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'SWSEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'SessionEpoch');
    end
end

%% Calculate number, duration, amplitude

% Restrict sleeps to first 30 min
for i = 1:length(Dir.path)
    PreSleep10{i} = SplitIntervals(and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch),...
        10*60*1e4);
    PostSleep10{i} = SplitIntervals(and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch),...
        10*60*1e4);
end

%% Ripples

for i = 1:length(Dir.path)
    RipplesTS{i} = ts(Rip{i}.ripples(:,2)*1e4);
end

%%  Find minimum number of intervals across all mice
for i=1:length(PreSleep10)
    LPre(i) = length(PreSleep10{i});
end
LPreMin = min(LPre);
Min(1) = LPreMin;

for i=1:length(PostSleep10)
    LPost(i) = length(PostSleep10{i});
end
LPostMin = min(LPost);
Min(2) = LPostMin;

FinalMin = min(Min);

%% Find number of ripples in each intervals

for i=1:length(Dir.path)
    for j=1:FinalMin
        ripplesInPreSleep{j}(i) = length(Data(Restrict(RipplesTS{i},PreSleep10{i}{j})))/600;
        ripplesInPostSleep{j}(i) = length(Data(Restrict(RipplesTS{i},PostSleep10{i}{j})))/600;
    end
end

% Prepare for plotting
for i = 1:length(ripplesInPreSleep)
    ripplesPreSleepInd(1:8,i) = ripplesInPreSleep{i}(:)';
    ripplesPostSleepInd(1:8,i) = ripplesInPostSleep{i}(:)';
end

% Mean 
for i=1:length(ripplesInPreSleep)
    ripplesPreSleepMean(1,i) = mean(ripplesInPreSleep{i});
    ripplesPreSleepMean(2,i) = mean(ripplesInPostSleep{i});
    
    ripplesPreSleepSTD(1,i) = std(ripplesInPreSleep{i});
    ripplesPreSleepSTD(2,i) = std(ripplesInPostSleep{i});
end

% Do the statistics
for i=1:length(ripplesInPreSleep)
    p(i)= signrank(ripplesInPreSleep{i},ripplesInPostSleep{i});
end


%% Plot

% fh = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);
% 
% [p,h, her] = PlotErrorBarN_DB(ripplesPreSleepInd, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0,...
%     'ShowSigStar', 'none', 'showpoints',1);
% 
% fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);
% 
% [p,h, her] = PlotErrorBarN_DB(ripplesPostSleepInd, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0,...
%     'ShowSigStar', 'none', 'showpoints',1);


fh2 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])
b = barwitherr((ripplesPreSleepSTD(:,1:end-1))', (ripplesPreSleepMean(:,1:end-1))');
set(gca, 'FontSize', 18, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
b(1).BarWidth = 0.8;
b(1).FaceColor = 'w';
b(2).FaceColor = 'k';
b(1).LineWidth = 3;
b(2).LineWidth = 3;
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
set(gca,'Xtick',[1:7],'XtickLabel',{'0-10 min', '10-20 min', '20-30 min', '30-40 min', '40-50 min', '50-60 min'})
ylabel('Ripples/s')
hold off
box off
ax = gca;
labels = string(ax.YAxis.TickLabels); % extract
labels(2:2:end) = nan; % remove every other one
ax.YAxis.TickLabels = labels; % set
set(gca, 'FontSize', 18, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
title('Dynamics of ripples occurence throughout sleep') 
lg = legend('PreSleep', 'PostSleep');
lg.FontSize = 18;
for i=1:length(ripplesInPreSleep)
    if p(i)<0.05
        sigstar_DB({x(:,i)},p(i),0,'LineWigth',16,'StarSize',24);
    end
end

if sav
    saveas(fh2,[dir_out fig_post '_SFN.fig']);
    saveFigure(fh2, [fig_post '_SFN'], dir_out);
end