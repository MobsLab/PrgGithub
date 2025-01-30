%%% LatencyTest_PAGTest

clear all
%% Parameters

% General
sav=1; % Do you want to save a figure?
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/'; % Where?

% input folders
DirPre = PathForExperimentsPAGTest_Dima('TestPre');
DirPre785 = RestrictPathForExperiment(DirPre, 'Group', 'Posterior');
DirPre785 = RestrictPathForExperiment(DirPre785, 'nMice', 785 );
DirPre786 = RestrictPathForExperiment(DirPre, 'nMice', 786);
DirPre787 = RestrictPathForExperiment(DirPre, 'Group', 'Anterior');
DirPre787 = RestrictPathForExperiment(DirPre787, 'nMice', 787);
DirPre788 = RestrictPathForExperiment(DirPre, 'nMice', 788);
DirPre = MergePathForExperiment(DirPre785, DirPre786);
DirPre = MergePathForExperiment(DirPre, DirPre787);
DirPre = MergePathForExperiment(DirPre, DirPre788);
clear DirPre785 DirPre786 DirPre787 DirPre788

% DirCond = PathForExperimentsPAGTest_Dima('Cond');
% DirCond = RestrictPathForExperiment(DirCond, 'Group', 'Anterior');

DirPost = PathForExperimentsPAGTest_Dima('TestPost');
DirPost785 = RestrictPathForExperiment(DirPost, 'Group', 'Posterior');
DirPost785 = RestrictPathForExperiment(DirPost785, 'nMice', 785 );
DirPost786 = RestrictPathForExperiment(DirPost, 'nMice', 786);
DirPost787 = RestrictPathForExperiment(DirPost, 'Group', 'Anterior');
DirPost787 = RestrictPathForExperiment(DirPost787, 'nMice', 787);
DirPost788 = RestrictPathForExperiment(DirPost, 'nMice', 788);
DirPost = MergePathForExperiment(DirPost785, DirPost786);
DirPost = MergePathForExperiment(DirPost, DirPost787);
DirPost = MergePathForExperiment(DirPost, DirPost788);
clear DirPost785 DirPost786 DirPost787 DirPost788

DirImmediat = PathForExperimentsPAGTest_Dima('TestImmediat');
DirPost785 = RestrictPathForExperiment(DirImmediat, 'Group', 'Posterior'); % Get rid of misses
DirPost785 = RestrictPathForExperiment(DirPost785, 'nMice', 785 ); % Get rid of misses
DirImmediat = RestrictPathForExperiment(DirImmediat, 'nMice', [786 787 788]); % Get rid of misses
DirImmediat = MergePathForExperiment(DirPost785, DirImmediat);
clear DirPost785

%% Get the data Avodance
for j = 1:length(DirPre.path)
    for i = 1:length(DirPre.path{j})
        % PreTests
        a{j} = load([DirPre.path{j}{i} 'behavResources.mat'], 'PosMat', 'ZoneIndices');
        PreTest_PosMat{j}{i} = a{j}.PosMat;
        PreTest_ZoneIndices{j}{i} = a{j}.ZoneIndices;
%         % Cond
%         b{j} = load([DirPre.path{j}{i} 'behavResources.mat'], 'PosMat', 'ZoneIndices');
%         Cond_PosMat{j}{i} = b{j}.PosMat;
%         Cond_ZoneIndices{j}{i} = b{j}.ZoneIndices;
        % PostTests
        c{j} = load([DirPost.path{j}{i} 'behavResources.mat'], 'PosMat', 'ZoneIndices');
        PostTest_PosMat{j}{i} = c{j}.PosMat;
        PostTest_ZoneIndices{j}{i} = c{j}.ZoneIndices;
    
    end
end
for j = 1:length(DirImmediat.path)
    % Test0
    d{j} = load([DirImmediat.path{j}{1} 'behavResources.mat'], 'PosMat', 'ZoneIndices');
    Post0_PosMat{j}{1} = d{j}.PosMat;
    Post0_ZoneIndices{j}{1} = d{j}.ZoneIndices;
end

%% Prepare the 'first enter to shock zone' array
for j=1:length(DirPre.path)
    for u=1:length(DirPre.path{j})
        if isempty(PreTest_ZoneIndices{j}{u}{1})
            Pre_FirstTime{j}(u) = 240;
        else
            Pre_FirstZoneIndices{j}(u) = PreTest_ZoneIndices{j}{u}{1}(1);
            Pre_FirstTime{j}(u) = PreTest_PosMat{j}{u}(Pre_FirstZoneIndices{j}(u),1);
        end
    
        if isempty(PostTest_ZoneIndices{j}{u}{1})
            Post_FirstTime{j}(u) = 240;
        else
            Post_FirstZoneIndices{j}(u) = PostTest_ZoneIndices{j}{u}{1}(1);
            Post_FirstTime{j}(u) = PostTest_PosMat{j}{u}(Post_FirstZoneIndices{j}(u),1);
        end
    
    end
end
for j=1:length(DirImmediat.path)
    % Test0
    if isempty(Post0_ZoneIndices{j}{1}{1})
        Post0_FirstTime(j) = 240;
    else
        Post0_FirstZoneIndices{j} = Post0_ZoneIndices{j}{1}{1}(1);
        Post0_FirstTime(j) = Post0_PosMat{j}{1}(Post0_FirstZoneIndices{j},1);
    end

end

%% Prepare arrays for plotting

for j=1:length(DirPre.path)
    % Pre
    if Pre_FirstTime{j}(1)==240
        FirstPre(j) = Pre_FirstTime{j}(1)+Pre_FirstTime{j}(2);
        if FirstPre(j)==480
            FirstPre(j) = FirstPre{j}+Pre_FirstTime{j}(3);
            if FirstPre(j)==720
                FirstPre(j) = FirstPre{j}+Pre_FirstTime{j}(4);
            end
        end
    else
        FirstPre(j) = Pre_FirstTime{j}(1);
    end
    % Post
    if Post_FirstTime{j}(1)==240
        FirstPost(j) = Post_FirstTime{j}(1)+Post_FirstTime{j}(2);
        if FirstPost(j)==480
            FirstPost(j) = FirstPost{j}+Post_FirstTime{j}(3);
            if FirstPost(j)==720
                FirstPost(j) = FirstPost{j}+Post_FirstTime{j}(4);
            end
        end
    else
        FirstPost(j) = Post_FirstTime{j}(1);
    end
end
for j=1:length(DirImmediat.path)
    % Post0
    FirstPost0(j) = Post0_FirstTime(j);
end
            
   
LatencyArray = [FirstPre; FirstPost0; FirstPost]';
LatencyArrayMean = mean(LatencyArray, 1);

%% Plot
% All mice
fh1 = figure('units', 'normalized', 'outerposition', [0 0 1 0.4]);
bar(LatencyArray);
set(gca,'Xtick',[1:7],'XtickLabel',{'M783post', 'M785ant', 'M785post', 'M786post', 'M786post', 'M787post', 'M788ant'});
legend('PreTest', 'PostTestBeforeSleep', 'PostTestAfterSleep');
ylabel('Time (s)');
title ('First time to enter the shockzone');

if sav
    saveas(fh1, [dir_out 'BeforeAfterSleep.fig']);
    saveFigure(fh1,'BeforeAfterSleep',dir_out);
end

% Averaged
fh2 = figure('units', 'normalized', 'outerposition', [0.1 0.1 0.7 0.7]);
[p,h, her] = PlotErrorBarN_DB(LatencyArray, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:3],'XtickLabel',{'PreTest', 'PostTestBeforeSleep', 'PostTestAfterSleep'}, 'FontSize', 16);
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Time (s)', 'FontSize', 16);
title ('First time to enter the ShockZone', 'FontSize', 16);

if sav
    saveas(fh2, [dir_out 'BeforeAfterSleepAllMice_Final.fig']);
    saveFigure(fh2,'BeforeAfterSleepAllMice_Final',dir_out);
end
    