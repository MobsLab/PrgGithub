%BehaviorZones - Plot occupancy and freezing in each zone of the UMaze in PreTests vs PostTests
%
% First plot is occupancy
% Second plot is freezing
% Highlighted zone is a shock zone
% 
%  OUTPUT
%
%    Figures
% 
%       2018 by Dmitri Bryzgalov

%% Parameters

% 1 - ZebraSide is closer to the door (example:/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPre/behavResources)
% 0 - StripeSide is closer to the door (example:/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/31052018/Hab/behavResources)
orientation = 0;

BarPosStripe = [.35 .3 .1 .1];
BarPosZebra = [.65 .3 .1 .1];
BarPosZebraCenter = [.65 .63 .1 .1];
BarPosStripeCenter = [.35 .63 .1 .1];
BarPosCenter = [.5 .63 .1 .1];

average = 0; % Show one mouse (0) ot the average (1)

% Numbers of mice to run analysis on
Mice_to_analyze = 797;
% Get directories
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out_occup = 'OccupancyByZones';
fig_out_freeze = 'FreezingByZones';

%% Get beautiful images
A = load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Habituation/behavResources.mat',...
    'ref', 'Zone');

bonref = A.ref;
StripeSide = A.Zone{1};
ZebraSide = A.Zone{2};
StripeSide(StripeSide==1)=255; % Create contrast
ZebraSide(ZebraSide==1)=255;

clear A

%% Determine which side is shock side
if average == 1
    Shock = ZebraSide;
elseif average == 0
    load([Dir_Post.path{1}{1} 'behavResources.mat']); %%% CHANGE!!!!!!!!!!!!!!!!!!!!!!!

    [idxZone_row, idxZone_col] = find(Zone{1});
    if orientation == 1 && max(idxZone_row) > 115
        Shock = ZebraSide;
    elseif orientation == 1 && max(idxZone_row) < 115
        Shock = StripeSide;
    elseif orientation == 0 && max(idxZone_row) > 115
        Shock = StripeSide;
    elseif orientation == 0 && max(idxZone_row) < 115
        Shock = ZebraSide;
    end
end

%% Calculate mean occupancy for each zone (within and across mice - parameter?)
 % CHANGE!!!!!
for i = 1:length(Dir_Pre.path)
    Pre{i} = load([Dir_Pre.path{i}{1} 'behavResources.mat'], 'Occup', 'Occupstd', 'FreezeTime');
    Post{i} = load([Dir_Post.path{i}{1} 'behavResources.mat'], 'Occup', 'Occupstd', 'FreezeTime');
	if average == 0
        Pre_Post_Occup = [Pre{i}.Occup; Post{i}.Occup];
        Pre_Post_Occupstd = [Pre{i}.Occupstd; Post{i}.Occupstd];
        Pre_Post_Freeze = [Pre{i}.FreezeTime; Post{i}.FreezeTime];
    elseif average == 1
        Pre_OccupALL(i,1:length(Pre{i}.Occup)) = Pre{i}.Occup;
        Post_OccupALL(i,1:length(Post{i}.Occup)) = Post{i}.Occup;
        Pre_FreezeALL(i,1:length(Pre{i}.FreezeTime)) = Pre{i}.FreezeTime;
        Post_FreezeALL(i,1:length(Post{i}.FreezeTime)) = Post{i}.FreezeTime;
    end
end

if average == 1
    Pre_Occup_mean = mean(Pre_OccupALL,1);
    Pre_Occupstd = std(Pre_OccupALL,1);
    Post_Occup_mean = mean(Post_OccupALL,1);
    Post_Occupstd = std(Post_OccupALL,1);
    Pre_Post_Occup = [Pre_Occup_mean; Post_Occup_mean];
    Pre_Post_Occupstd = [Pre_Occupstd; Post_Occupstd];
    
    Pre_Freeze_mean = mean(Pre_FreezeALL,1);
    Pre_Freezestd = std(Pre_FreezeALL,1);
    Post_Freeze_mean = mean(Post_FreezeALL,1);
    Post_Freezestd = std(Post_FreezeALL,1);
    Pre_Post_Freeze = [Pre_Freeze_mean; Post_Freeze_mean];
    Pre_Post_Freezestd = [Pre_Freezestd; Post_Freezestd];
    
    Pre_Post_OccupALL = cat (3, Pre_OccupALL, Post_OccupALL);
    Pre_Post_FreezeALL = cat (3, Pre_FreezeALL, Post_FreezeALL);
end

    % Occup
    fop = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    imagesc(bonref);
    colormap(gray)
    hold on
    imagesc(Shock, 'AlphaData', 0.3);

    if min(min(Shock == ZebraSide)) == 1
        h = axes('Position', BarPosZebra, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 1));
%       ylim([0 max(max(Pre_Post_Occup(:,1:5)))+0.2])
        hold on
        errorbar(Pre_Post_Occup(1:2, 1), Pre_Post_Occupstd(1:2, 1) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,1,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        
        h = axes('Position', BarPosStripe, 'Layer','top','Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
        bar(Pre_Post_Occup(1:2, 2));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 2), Pre_Post_Occupstd(1:2, 2) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,2,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosCenter, 'Layer','top','Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
        bar(Pre_Post_Occup(1:2, 3));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 3), Pre_Post_Occupstd(1:2, 3) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,3,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebraCenter, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 4));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 4), Pre_Post_Occupstd(1:2, 4) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,4,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosStripeCenter, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 5));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 5), Pre_Post_Occupstd(1:2, 5) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,5,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
    elseif min(min(Shock == StripeSide)) == 1
        h = axes('Position', BarPosStripe, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 1));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 1), Pre_Post_Occupstd(1:2, 1) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,1,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebra, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 2));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 2), Pre_Post_Occupstd(1:2, 2) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,2,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosCenter, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 3));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 3), Pre_Post_Occupstd(1:2, 3) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,3,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosStripeCenter, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 4));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 4), Pre_Post_Occupstd(1:2, 4) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,4,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebraCenter, 'Layer','top');
        bar(Pre_Post_Occup(1:2, 5));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        hold on
        errorbar(Pre_Post_Occup(1:2, 5), Pre_Post_Occupstd(1:2, 5) ,'.', 'Color', 'r');
        if average == 1
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_OccupALL(:,5,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
    end

    if average == 0
        mtit(fop, ['Mouse ' num2str(Mice_to_analyze) '- Occupancy by Zones (ShockZone is highlighted)'], 'fontsize',16);
    elseif average == 1
        mtit(fop, 'Occupancy by zones across mice (ShockZone is highlighted)', 'fontsize',16);
    end

    % Save occupancy figure
%     saveas(fop, [dir_out fig_out_occup '.fig']);
%     saveFigure(fop,fig_out_occup,dir_out);


    % Freeze
    ff = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    imagesc(bonref);
    colormap(gray)
    hold on
    imagesc(Shock, 'AlphaData', 0.3);

    if min(min(Shock == ZebraSide)) == 1
        h = axes('Position', BarPosZebra, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 1));
%         ylim([0 max(max(Pre_Post_Freeze(:,1:5)))+0.2])
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 1), Pre_Post_Freezestd(1:2, 1) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,1,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        
        h = axes('Position', BarPosStripe, 'Layer','top','Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
        bar(Pre_Post_Freeze(1:2, 2));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 2), Pre_Post_Freezestd(1:2, 2) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,2,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosCenter, 'Layer','top','Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
        bar(Pre_Post_Freeze(1:2, 3));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 3), Pre_Post_Freezestd(1:2, 3) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,3,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebraCenter, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 4));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 4), Pre_Post_Freezestd(1:2, 4) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,4,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosStripeCenter, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 5));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 5), Pre_Post_Freezestd(1:2, 5) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,5,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
    elseif min(min(Shock == StripeSide)) == 1
        h = axes('Position', BarPosStripe, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 1));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 1), Pre_Post_Freezestd(1:2, 1) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,1,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebra, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 2));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 2), Pre_Post_Freezestd(1:2, 2) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,2,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosCenter, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 3));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'});
         if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 3), Pre_Post_Freezestd(1:2, 3) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,3,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosStripeCenter, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 4));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 4), Pre_Post_Freezestd(1:2, 4) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,4,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
        h = axes('Position', BarPosZebraCenter, 'Layer','top');
        bar(Pre_Post_Freeze(1:2, 5));
        set(h,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
        if average == 1
            hold on
            errorbar(Pre_Post_Freeze(1:2, 5), Pre_Post_Freezestd(1:2, 5) ,'.', 'Color', 'r');
            for g = 1:length(Dir_Pre.path)
                temp = squeeze(Pre_Post_FreezeALL(:,5,:));
                plot([1 2],temp, '-ko', 'MarkerFaceColor','white');
            end
        end
        
    end

    if average == 0
        mtit(ff, ['Mouse ' num2str(Mice_to_analyze) '- Freezing by Zones (ShockZone is highlighted)'], 'fontsize',16);
    elseif average == 1
        mtit(ff, 'Freezing by zones across mice (ShockZone is highlighted)', 'fontsize',16);
    end

    % Save occupancy figure
%     saveas(ff, [dir_out fig_out_occup '.fig']);
%     saveFigure(ff,fig_out_freeze,dir_out);

    %% Clear all
    clear