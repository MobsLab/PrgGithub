%%% FigureAverage_PAGTest

clear all
%% Parameters

% General
sav=1; % Do you want to save a figure?
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/'; % Where?
fig_post = 'AverageAllMice_Final'; % Name of the output file

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

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
Occupancy_Axes = axes('position', [0.07 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.55 0.55 0.41 0.41]);
First_Axes = axes('position', [0.07 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.55 0.05 0.41 0.41]);

%%
for j = 1:length(DirPre.path)
    
    %% Get the data Avodance
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
    
    Pre_Occup_mean(j,1:7) = mean(PreTest_occup{j},1);
    Pre_Occup_std(j,1:7) = std(PreTest_occup{j},1);
    Post_Occup_mean(j,1:7) = mean(PostTest_occup{j},1);
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
    
    
    Pre_Post_FirstTime_mean(j,1:2) = mean(Pre_Post_FirstTime{j},1);
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
    Pre_Post_entnum_mean(j,1:2) = mean(Pre_Post_entnum{j},1);
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
    Pre_Post_VZmean_mean(j,1:2) = nanmean(Pre_Post_VZmean{j},1);
    Pre_Post_VZmean_std(j,1:2) = nanstd(Pre_Post_VZmean{j},1);
    
    
    
end

%% Plot a figure

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_Occup_mean(:,1) Post_Occup_mean(:,1)], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
ylabel('% time');
title('Percentage of the ShockZone occupancy', 'FontSize', 14);

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB(Pre_Post_entnum_mean, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the ShockZone', 'FontSize', 14);

axes(First_Axes);
[p_first,h_first, her_first] =PlotErrorBarN_DB(Pre_Post_FirstTime_mean, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the ShockZone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB(Pre_Post_VZmean_mean, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_speed, 'LineWidth', 3);
set(her_speed, 'LineWidth', 3);
ylabel('Speed (cm/s)');
title('Average speed in the SafeZone', 'FontSize', 14);

% %% Supertitle
% mtit(fh,supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

%% Save
if sav
    saveas(fh, [dir_out fig_post '.fig']);
    saveFigure(fh,fig_post,dir_out);
end