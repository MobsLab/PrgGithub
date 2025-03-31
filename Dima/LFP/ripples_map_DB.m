%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'ripples_map';
% Before Vtsd correction == 1
old = 0;
sav = 0;
% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 906 911 912 977 994 1117 1124 1161 1162 1168 1182 1186 1199];
% Mice_to_analyze = [1117 1161 1162 1168 1199 1223]; % MFB

% Get directories
Dir = PathForExperimentsERC('UMazePAG');
% Dir = PathForExperimentsERC('StimMFBWake');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

%% Get data
cnt=1;
for i = 1:length(Dir.path)
    for j=1:length(Dir.path{i})
        beh{cnt} = load([Dir.path{i}{j} '/behavResources.mat'], 'SessionEpoch','AlignedXtsd','AlignedYtsd',...
            'FreezeAccEpoch');
        try
            rip{cnt} = load([Dir.path{i}{j} 'SWR.mat'],'ripples');
        catch
            rip{cnt} = load([Dir.path{i}{j} 'Ripples.mat'],'ripples');
        end
        try
            sleepscored{cnt} = load([Dir.path{i}{j} 'SleepScoring_OBGamma.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
        catch
            sleepscored{cnt} = load([Dir.path{i}{j} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
        end
        cnt=cnt+1;
    end
end

%% Calculate


for i=1:length(beh)
    
    %%% CondEpoch
    CondEpoch{i} = or(beh{i}.SessionEpoch.Cond1,beh{i}.SessionEpoch.Cond2);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond3);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond4);
    % Ripples
    ripts{i} = ts(rip{i}.ripples(:,2)*1e4);
    
%     %%% Create epochs
%     SWSPre{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PreSleep);
%     REMPre{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PreSleep);
%     RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
%     RipISCond{i} = and(RipIS{i},CondEpoch{i});
%     SWSPost{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PostSleep);
%     REMPost{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PostSleep);
%     RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
%     RipISPost{i} = and(RipIS{i},beh{i}.SessionEpoch.PostSleep);
    
    [maprip{i},mapS,stats{i}]=PlaceField_DB(Restrict(ripts{i},CondEpoch{i}),...
        Restrict(beh{i}.AlignedXtsd,CondEpoch{i}),Restrict(beh{i}.AlignedYtsd,CondEpoch{i}),'threshold',0.5,...
        'plotresults',0);
end
close all

%% Plot
mazeMap = [4 6; 4 59; 59 59; 59 6; 38 6; 38 42; 23 42; 23 6; 4 6];
ShockZoneMap = [4 6; 4 30; 23 30; 23 6; 4 6];


Resmaprip = zeros(62,62);

% Prepare array
for i=1:length(Dir.path)
    Resmaprip = Resmaprip + maprip{i}.rate;
end

figure
imagesc(Resmaprip)
colormap jet
axis xy
hold on
plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',3)
plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',3)
set(gca,'XTickLabel',{},'YTickLabel',{});
% set(gca,'XTickLabel',{},'YTickLabel',{}, 'XDir', 'reverse');
colorbar
makepretty_DB

% saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/LFP/Ripplesmap_MFB.fig']);
% saveFigure(gcf,'Ripplesmap_MFB','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/LFP/');
saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/LFP/Ripplesmap.fig']);
saveFigure(gcf,'Ripplesmap','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/LFP/');


%% Ripples correlation

% Extract ripples
for i = 1:length(Dir.path)
    PreRipples{i}=Restrict(ripts{i},and(beh{i}.SessionEpoch.PreSleep, sleepscored{i}.SWSEpoch));
    PostRipples{i}=Restrict(ripts{i},and(beh{i}.SessionEpoch.PostSleep, sleepscored{i}.SWSEpoch));
    CondRipples{i}=Restrict(ripts{i},and(CondEpoch{i},beh{i}.FreezeAccEpoch));
%     CondRipples{i}=Restrict(ripts{i},CondEpoch{i});
    
    Pre_N(i)=length(Range(PreRipples{i}));
    Post_N(i)=length(Range(PostRipples{i}));
    Cond_N(i)=length(Range(CondRipples{i}));
    
    TimePre{i} = and(beh{i}.SessionEpoch.PreSleep, sleepscored{i}.SWSEpoch);
    Pre_N_norm_all(i) = Pre_N(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = and(beh{i}.SessionEpoch.PostSleep, sleepscored{i}.SWSEpoch);
    Post_N_norm_all(i) = Post_N(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    TimeCond{i} = and(CondEpoch{i},beh{i}.FreezeAccEpoch);
%     TimeCond{i} = CondEpoch{i};
    Cond_N_norm_all(i) = Cond_N(i)/((sum(End(TimeCond{i})- Start(TimeCond{i})))/1e4);
    
end


%%% Plot
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(Cond_N_norm_all,Pre_N_norm_all, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if max(xlim) >=1 || max(ylim)>=1
    if xlim>=ylim
        plot([0:max(xlim)],[0:max(xlim)],'Color','k','LineWidth',3)
    else
        plot([0:max(ylim)],[0:max(ylim)],'Color','k','LineWidth',3)
    end
else
    plot([0:1],[0:1],'Color','k','LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Cond')
ylabel('Pre')
subplot(122)
scatter(Cond_N_norm_all,Post_N_norm_all, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if max(xlim) >=1 || max(ylim)>=1
    if xlim>=ylim
        plot([0:max(xlim)],[0:max(xlim)],'Color','k','LineWidth',3)
    else
        plot([0:max(ylim)],[0:max(ylim)],'Color','k','LineWidth',3)
    end
else
    plot([0:1],[0:1],'Color','k','LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Cond')
ylabel('Post')


fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.4 0.5]);
scatter(Pre_N_norm_all./Cond_N_norm_all,Post_N_norm_all./Cond_N_norm_all, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if max(xlim) >=1 || max(ylim)>=1
    if xlim>=ylim
        plot([0:max(xlim)],[0:max(xlim)],'Color','k','LineWidth',3)
    else
        plot([0:max(ylim)],[0:max(ylim)],'Color','k','LineWidth',3)
    end
else
    plot([0:1],[0:1],'Color','k','LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre/Cond')
ylabel('Post/Cond')

