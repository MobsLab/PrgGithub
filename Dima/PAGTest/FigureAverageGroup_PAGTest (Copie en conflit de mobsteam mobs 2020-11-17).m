%%% FigureAverage_PAGTest

clear all
%% Parameters

% General
sav=0; % Do you want to save a figure?
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/'; % Where?
fig_post = 'GroupsComparison'; % Name of the output file

% input folders
DirPre = PathForExperimentsPAGTest_Dima('TestPre');
DirPre785 = RestrictPathForExperiment(DirPre, 'Group', 'Posterior'); % Get rid of misses
DirPre785 = RestrictPathForExperiment(DirPre785, 'nMice', 785 ); % Get rid of misses
DirPre = RestrictPathForExperiment(DirPre, 'nMice', [786 787 788]); % Get rid of misses
DirPre = MergePathForExperiment(DirPre785, DirPre);
clear DirPre785

% DirCond = PathForExperimentsPAGTest_Dima('Cond');
% DirCond = RestrictPathForExperiment(DirCond, 'Group', 'Anterior');

DirPost = PathForExperimentsPAGTest_Dima('TestPost');
DirPost785 = RestrictPathForExperiment(DirPost, 'Group', 'Posterior'); % Get rid of misses
DirPost785 = RestrictPathForExperiment(DirPost785, 'nMice', 785 ); % Get rid of misses
DirPost = RestrictPathForExperiment(DirPost, 'nMice', [786 787 788]); % Get rid of misses
DirPost = MergePathForExperiment(DirPost785, DirPost);
clear DirPost785

% Groups
ContextB = [1 2 5 6]; % 785post, 786post, 787post, 788ant
ContextC = [3 4]; % 786ant, 787ant

Anterior = [2 4 6]; % 786ant, 787ant, 788ant
Posterior = [1 3 5]; % 785post, 786post, 787post

First = [3 4 6]; % 786post, 787post, 788ant
Second = [1 2 4]; % 785post, 786ant, 787ant

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 1 0.65]);
% ContextB&C
annotation(fh,'textbox',[0.07 0.9 0.2 0.05],'String','ContextB vs ContextC','LineWidth',1,'HorizontalAlignment','center',...
    'FontSize', 16,'FontWeight','bold','FitBoxToText','off');
OccupancyBC_Axes = axes('position', [0.03 0.48 0.13 0.35]);
NumEntrBC_Axes = axes('position', [0.19 0.48 0.13 0.35]);
First_AxesBC = axes('position', [0.03 0.05 0.13 0.35]);
Speed_AxesBC = axes('position', [0.19 0.05 0.13 0.35]);
% Anterior&Posterior
annotation(fh,'textbox',[0.395 0.89 0.2 0.08],'String','Anterior electrodes vs Posterior electrodes',...
    'LineWidth',1,'HorizontalAlignment','center',...
    'FontSize', 16,'FontWeight','bold','FitBoxToText','off');
OccupancyAP_Axes = axes('position', [0.365 0.48 0.13 0.35]);
NumEntrAP_Axes = axes('position', [0.525 0.48 0.13 0.35]);
First_AxesAP = axes('position', [0.365 0.05 0.13 0.35]);
Speed_AxesAP = axes('position', [0.525 0.05 0.13 0.35]);
% First&Second
annotation(fh,'textbox',[0.735 0.89 0.2 0.08],'String','First time in the UMaze vs Second time in the UMaze',...
    'LineWidth',1,'HorizontalAlignment','center',...
    'FontSize', 16,'FontWeight','bold','FitBoxToText','off');
OccupancyFS_Axes = axes('position', [0.705 0.48 0.13 0.35]);
NumEntrFS_Axes = axes('position', [0.865 0.48 0.13 0.35]);
First_AxesFS = axes('position', [0.705 0.05 0.13 0.35]);
Speed_AxesFS = axes('position', [0.865 0.05 0.13 0.35]);

%% 
for j = 1:length(DirPre.path)
    
    %% Get the data Avoidance
    for i = 1:length(DirPre.path{j})
        % PreTests
        a{j} = load([DirPre.path{j}{i} 'behavResources.mat'],'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
        Pre_Xtsd{j}{i} = a{j}.Xtsd;
        Pre_Ytsd{j}{i} = a{j}.Ytsd;
        Pre_Vtsd{j}{i} = a{j}.Vtsd;
        PreTest_PosMat{j}{i} = a{j}.PosMat;
        PreTest_occup{j}(i,1:7) = a{j}.Occup;
        PreTest_ZoneIndices{j}{i} = a{j}.ZoneIndices;
%         % Cond
%         b{j} = load([DirPre.path{j}{i} 'behavResources.mat'], 'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
%         Cond_Xtsd{j}{i} = b{j}.Xtsd;
%         Cond_Ytsd{j}{i} = b{j}.Ytsd;
%         Cond_Vtsd{j}{i} = b{j}.Vtsd;
%         Cond_PosMat{j}{i} = b{j}.PosMat;
%         Cond_occup{j}(i,1:7) = b{j}.Occup;
%         Cond_ZoneIndices{j}{i} = b{j}.ZoneIndices;
        % PostTests
        c{j} = load([DirPost.path{j}{i} '/behavResources.mat'],'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
        Post_Xtsd{j}{i} = c{j}.Xtsd;
        Post_Ytsd{j}{i} = c{j}.Ytsd;
        Post_Vtsd{j}{i} = c{j}.Vtsd;
        PostTest_PosMat{j}{i} = c{j}.PosMat;
        PostTest_occup{j}(i,1:7) = c{j}.Occup;
        PostTest_ZoneIndices{j}{i} = c{j}.ZoneIndices;
    end
    
    %% Calculate average occupancy
    % Mean and STD across 4 Pre- and PostTests
    PreTest_occup{j} = PreTest_occup{j}*100;
    PostTest_occup{j} = PostTest_occup{j}*100;
    
    Pre_Occup_mean(j,1:7) = mean(PreTest_occup{j},1); % Main
    Pre_Occup_std(j,1:7) = std(PreTest_occup{j},1);
    Post_Occup_mean(j,1:7) = mean(PostTest_occup{j},1); % Main
    Post_Occup_std(j,1:7) = std(PostTest_occup{j},1);
    
    %% Prepare the 'first enter to shock zone' array
    for u = 1:length(DirPre.path{j})
        
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
        
        
        
        Pre_Post_FirstTime{j}(u, 1:2) = [Pre_FirstTime{j}(u) Post_FirstTime{j}(u)];
        
    end
    
    
    Pre_Post_FirstTime_mean(j,1:2) = mean(Pre_Post_FirstTime{j},1);  % Main
    Pre_Post_FirstTime_std(j,1:2) = std(Pre_Post_FirstTime{j},1);
    
    
    %% Calculate number of entries into the shock zone
    % Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
    for m = 1:length(DirPre.path{j})
        if isempty(PreTest_ZoneIndices{j}{m}{1})
            Pre_entnum{j}(m) = 0;
        else
            Pre_entnum{j}(m)=length(find(diff(PreTest_ZoneIndices{j}{m}{1})>1))+1;
        end
        
        if isempty(PostTest_ZoneIndices{j}{m}{1})
            Post_entnum{j}(m)=0;
        else
            Post_entnum{j}(m)=length(find(diff(PostTest_ZoneIndices{j}{m}{1})>1))+1;
        end
        
        
    end
    
    
    Pre_Post_entnum{j} = [Pre_entnum{j}; Post_entnum{j}]';
    Pre_Post_entnum_mean(j,1:2) = mean(Pre_Post_entnum{j},1);  % Main
    Pre_Post_entnum_std(j,1:2) = std(Pre_Post_entnum{j},1);
    
    
    %% Calculate speed in the shock zone and in the noshock + shock vs everything else
    % I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
    for r=1:length(DirPre.path{j})
        
        % PreTest ShockZone speed
        if isempty(PreTest_ZoneIndices{j}{r}{2})
            VZmean_pre{j}(r) = NaN;
        else
            Vtemp_pre{j}{r}=Data(Pre_Vtsd{j}{r});
            VZone_pre{j}{r}=Vtemp_pre{j}{r}(PreTest_ZoneIndices{j}{r}{2}(1:end-1),1);
            VZmean_pre{j}(r)=nanmean(VZone_pre{j}{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PostTest_ZoneIndices{j}{r}{2})
            VZmean_post{j}(r) = NaN;
        else
            Vtemp_post{j}{r}=Data(Post_Vtsd{j}{r});
            VZone_post{j}{r}=Vtemp_post{j}{r}(PostTest_ZoneIndices{j}{r}{2}(1:end-1),1);
            VZmean_post{j}(r)=nanmean(VZone_post{j}{r},1);
        end
    end
    
    
    Pre_Post_VZmean{j} = [VZmean_pre{j}; VZmean_post{j}]';
    Pre_Post_VZmean_mean(j,1:2) = nanmean(Pre_Post_VZmean{j},1);  % Main
    Pre_Post_VZmean_std(j,1:2) = nanstd(Pre_Post_VZmean{j},1);
    
    
    
end

%% Make groups
% ContextB&C
Pre_Post_Occup_mean = ((Post_Occup_mean(:,1)./Pre_Occup_mean(:,1))-1)*100;
Pre_Post_Occup_meanContextB = Pre_Post_Occup_mean(ContextB);
Pre_Post_Occup_meanContextBMean = mean(Pre_Post_Occup_meanContextB);
Pre_Post_Occup_meanContextBSTD = std(Pre_Post_Occup_meanContextB);
Pre_Post_Occup_meanContextC = Pre_Post_Occup_mean(ContextC);
Pre_Post_Occup_meanContextCMean = mean(Pre_Post_Occup_meanContextC);
Pre_Post_Occup_meanContextCSTD = std(Pre_Post_Occup_meanContextC);

PrePostRat_FirstTime = ((Pre_Post_FirstTime_mean(:,2)./Pre_Post_FirstTime_mean(:,1))-1)*100;
PrePostRat_FirstTimeContextBMean = mean(PrePostRat_FirstTime(ContextB));
PrePostRat_FirstTimeContextBSTD = std(PrePostRat_FirstTime(ContextB));
PrePostRat_FirstTimeContextCMean = mean(PrePostRat_FirstTime(ContextC));
PrePostRat_FirstTimeContextCSTD = std(PrePostRat_FirstTime(ContextC));

PrePostRat_EntNum = ((Pre_Post_entnum_mean(:,2)./Pre_Post_entnum_mean(:,1))-1)*100;
PrePostRat_EntNum_ContextBMean = mean(PrePostRat_EntNum(ContextB));
PrePostRat_EntNum_ContextBSTD = std(PrePostRat_EntNum(ContextB));
PrePostRat_EntNum_ContextCMean = mean(PrePostRat_EntNum(ContextC));
PrePostRat_EntNum_ContextCSTD = std(PrePostRat_EntNum(ContextC));

PrePostRat_V = ((Pre_Post_VZmean_mean(:,2)./Pre_Post_VZmean_mean(:,1))-1)*100;
PrePostRat_V_ContextBMean = mean(PrePostRat_V(ContextB));
PrePostRat_V_ContextBSTD = std(PrePostRat_V(ContextB));
PrePostRat_V_ContextCMean = mean(PrePostRat_V(ContextC));
PrePostRat_V_ContextCSTD = std(PrePostRat_V(ContextC));

% Anterior&Posterior
Pre_Post_Occup_mean = ((Post_Occup_mean(:,1)./Pre_Occup_mean(:,1))-1)*100;
Pre_Post_Occup_meanAnterior = Pre_Post_Occup_mean(Anterior);
Pre_Post_Occup_meanAnteriorMean = mean(Pre_Post_Occup_meanAnterior);
Pre_Post_Occup_meanAnteriorSTD = std(Pre_Post_Occup_meanAnterior);
Pre_Post_Occup_meanPosterior = Pre_Post_Occup_mean(Posterior);
Pre_Post_Occup_meanPosteriorMean = mean(Pre_Post_Occup_meanPosterior);
Pre_Post_Occup_meanPosteriorSTD = std(Pre_Post_Occup_meanPosterior);

PrePostRat_FirstTime = ((Pre_Post_FirstTime_mean(:,2)./Pre_Post_FirstTime_mean(:,1))-1)*100;
PrePostRat_FirstTimeAnteriorMean = mean(PrePostRat_FirstTime(Anterior));
PrePostRat_FirstTimeAnteriorSTD = std(PrePostRat_FirstTime(Anterior));
PrePostRat_FirstTimePosteriorMean = mean(PrePostRat_FirstTime(Posterior));
PrePostRat_FirstTimePosteriorSTD = std(PrePostRat_FirstTime(Posterior));

PrePostRat_EntNum = ((Pre_Post_entnum_mean(:,2)./Pre_Post_entnum_mean(:,1))-1)*100;
PrePostRat_EntNum_AnteriorMean = mean(PrePostRat_EntNum(Anterior));
PrePostRat_EntNum_AnteriorSTD = std(PrePostRat_EntNum(Anterior));
PrePostRat_EntNum_PosteriorMean = mean(PrePostRat_EntNum(Posterior));
PrePostRat_EntNum_PosteriorSTD = std(PrePostRat_EntNum(Posterior));

PrePostRat_V = ((Pre_Post_VZmean_mean(:,2)./Pre_Post_VZmean_mean(:,1))-1)*100;
PrePostRat_V_AnteriorMean = mean(PrePostRat_V(Anterior));
PrePostRat_V_AnteriorSTD = std(PrePostRat_V(Anterior));
PrePostRat_V_PosteriorMean = mean(PrePostRat_V(Posterior));
PrePostRat_V_PosteriorSTD = std(PrePostRat_V(Posterior));

% First&Second
Pre_Post_Occup_mean = ((Post_Occup_mean(:,1)./Pre_Occup_mean(:,1))-1)*100;
Pre_Post_Occup_meanFirst = Pre_Post_Occup_mean(First);
Pre_Post_Occup_meanFirstMean = mean(Pre_Post_Occup_meanFirst);
Pre_Post_Occup_meanFirstSTD = std(Pre_Post_Occup_meanFirst);
Pre_Post_Occup_meanSecond = Pre_Post_Occup_mean(Second);
Pre_Post_Occup_meanSecondMean = mean(Pre_Post_Occup_meanSecond);
Pre_Post_Occup_meanSecondSTD = std(Pre_Post_Occup_meanSecond);

PrePostRat_FirstTime = ((Pre_Post_FirstTime_mean(:,2)./Pre_Post_FirstTime_mean(:,1))-1)*100;
PrePostRat_FirstTimeFirstMean = mean(PrePostRat_FirstTime(First));
PrePostRat_FirstTimeFirstSTD = std(PrePostRat_FirstTime(First));
PrePostRat_FirstTimeSecondMean = mean(PrePostRat_FirstTime(Second));
PrePostRat_FirstTimeSecondSTD = std(PrePostRat_FirstTime(Second));

PrePostRat_EntNum = ((Pre_Post_entnum_mean(:,2)./Pre_Post_entnum_mean(:,1))-1)*100;
PrePostRat_EntNum_FirstMean = mean(PrePostRat_EntNum(First));
PrePostRat_EntNum_FirstSTD = std(PrePostRat_EntNum(First));
PrePostRat_EntNum_SecondMean = mean(PrePostRat_EntNum(Second));
PrePostRat_EntNum_SecondSTD = std(PrePostRat_EntNum(Second));

PrePostRat_V = ((Pre_Post_VZmean_mean(:,2)./Pre_Post_VZmean_mean(:,1))-1)*100;
PrePostRat_V_FirstMean = mean(PrePostRat_V(First));
PrePostRat_V_FirstSTD = std(PrePostRat_V(First));
PrePostRat_V_SecondMean = mean(PrePostRat_V(Second));
PrePostRat_V_SecondSTD = std(PrePostRat_V(Second));

% FirstPre & SecondPre




%% Plot a figure
 
% ContextB&C
axes(OccupancyBC_Axes);
bar([Pre_Post_Occup_meanContextBMean Pre_Post_Occup_meanContextCMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[Pre_Post_Occup_meanContextBMean Pre_Post_Occup_meanContextCMean],...
    [Pre_Post_Occup_meanContextBSTD Pre_Post_Occup_meanContextCSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'ContextB', 'ContextC'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('The ShockZone occupancy');

axes(NumEntrBC_Axes);
bar([PrePostRat_EntNum_ContextBMean PrePostRat_EntNum_ContextCMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_EntNum_ContextBMean PrePostRat_EntNum_ContextCMean],...
    [PrePostRat_EntNum_ContextBSTD PrePostRat_EntNum_ContextCSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'ContextB', 'ContextC'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('# of entries to the ShockZone', 'FontWeight',  'bold');

axes(First_AxesBC);
bar([PrePostRat_FirstTimeContextBMean PrePostRat_FirstTimeContextCMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_FirstTimeContextBMean PrePostRat_FirstTimeContextCMean],...
    [0 0],[PrePostRat_FirstTimeContextBSTD PrePostRat_FirstTimeContextCSTD], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'ContextB', 'ContextC'});
set(gca, 'FontWeight',  'bold');
ylim([0 1500]);
% ylabel('(Post/PreRatio-1)*100');
title('First time to enter the ShockZone', 'FontWeight',  'bold');

axes(Speed_AxesBC);
bar([PrePostRat_V_ContextBMean PrePostRat_V_ContextCMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_V_ContextBMean PrePostRat_V_ContextCMean],...
    [PrePostRat_V_ContextBSTD PrePostRat_V_ContextCSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'ContextB', 'ContextC'});
set(gca, 'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('Average speed in the SafeZone', 'FontWeight',  'bold');


% Anterior&Posterior
axes(OccupancyAP_Axes);
bar([Pre_Post_Occup_meanAnteriorMean Pre_Post_Occup_meanPosteriorMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[Pre_Post_Occup_meanAnteriorMean Pre_Post_Occup_meanPosteriorMean],...
    [Pre_Post_Occup_meanAnteriorSTD Pre_Post_Occup_meanPosteriorSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'Anterior', 'Posterior'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
ylabel('(Post/PreRatio-1)*100');
title('The ShockZone occupancy');

axes(NumEntrAP_Axes);
bar([PrePostRat_EntNum_AnteriorMean PrePostRat_EntNum_PosteriorMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_EntNum_AnteriorMean PrePostRat_EntNum_PosteriorMean],...
    [PrePostRat_EntNum_AnteriorSTD PrePostRat_EntNum_PosteriorSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'Anterior', 'Posterior'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('# of entries to the ShockZone', 'FontWeight',  'bold');

axes(First_AxesAP);
bar([PrePostRat_FirstTimeAnteriorMean PrePostRat_FirstTimePosteriorMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_FirstTimeAnteriorMean PrePostRat_FirstTimePosteriorMean],...
    [0 0],[PrePostRat_FirstTimeAnteriorSTD PrePostRat_FirstTimePosteriorSTD], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'Anterior', 'Posterior'});
set(gca, 'FontWeight',  'bold');
ylim([0 1500]);
ylabel('(Post/PreRatio-1)*100');
title('First time to enter the ShockZone', 'FontWeight',  'bold');

axes(Speed_AxesAP);
bar([PrePostRat_V_AnteriorMean PrePostRat_V_PosteriorMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_V_AnteriorMean PrePostRat_V_PosteriorMean],...
    [PrePostRat_V_AnteriorSTD PrePostRat_V_PosteriorSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'Anterior', 'Posterior'});
set(gca, 'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('Average speed in the SafeZone', 'FontWeight',  'bold');

FigureAverageGroup_PAGTest.m
% First&Second
axes(OccupancyFS_Axes);
bar([Pre_Post_Occup_meanFirstMean Pre_Post_Occup_meanSecondMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[Pre_Post_Occup_meanFirstMean Pre_Post_Occup_meanSecondMean],...
    [Pre_Post_Occup_meanFirstSTD Pre_Post_Occup_meanSecondSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'First', 'Second'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('The ShockZone occupancy');

axes(NumEntrFS_Axes);
bar([PrePostRat_EntNum_FirstMean PrePostRat_EntNum_SecondMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_EntNum_FirstMean PrePostRat_EntNum_SecondMean],...
    [PrePostRat_EntNum_FirstSTD PrePostRat_EntNum_SecondSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'First', 'Second'});
set(gca,'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('# of entries to the ShockZone', 'FontWeight',  'bold');

axes(First_AxesFS);
bar([PrePostRat_FirstTimeFirstMean PrePostRat_FirstTimeSecondMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_FirstTimeFirstMean PrePostRat_FirstTimeSecondMean],...
    [0 0],[PrePostRat_FirstTimeFirstSTD PrePostRat_FirstTimeSecondSTD], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'First', 'Second'});
set(gca, 'FontWeight',  'bold');
ylim([0 1500]);
% ylabel('(Post/PreRatio-1)*100');
title('First time to enter the ShockZone', 'FontWeight',  'bold');

axes(Speed_AxesFS);
bar([PrePostRat_V_FirstMean PrePostRat_V_SecondMean], 0.6, 'FaceColor', [0 0 0], 'LineWidth', 2);
hold on
errorbar([1:2],[PrePostRat_V_FirstMean PrePostRat_V_SecondMean],...
    [PrePostRat_V_FirstSTD PrePostRat_V_SecondSTD],[0 0], '.k', 'LineWidth',2);
set(gca,'Xtick',[1:2],'XtickLabel',{'First', 'Second'});
set(gca, 'FontWeight',  'bold');
ylim([-200 200]);
% ylabel('(Post/PreRatio-1)*100');
title('Average speed in the SafeZone', 'FontWeight',  'bold');

% %% Supertitle
% mtit(fh,supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

%% Save
if sav
    saveas(fh, [dir_out fig_post '.fig']);
    saveFigure(fh,fig_post,dir_out);
end