%%% FinalFigure_PAGTest

clear all

%% Parameters
% Load data
Intensities = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Contextual Memory
Day1A = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A = load('/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B = load('/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

xticky = {'ContextA (Neutral)', 'ContextB (Aversive)'};
M788 = 0; % No Data for Day1A in this mouse. Tick if you process Mouse 788

% Path to AnatomyFigures
figpath = '/media/mobsrick/DataMOBS87/Mouse-783/M783ant.png';

% General
sav=1; % Do you want to save a figure?
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/FinalFigures/'; % Where?
fig_post = 'PAGTest'; % Name of the output file

Avoidance = 0; % do you have data for avoidance UMaze protocol?
h24 = 0; % Do you have data for h24 later

indir = '/media/mobsrick/DataMOBS87/Mouse-783/'; % input folder
ntest = 4;
Day3 = '11092018';
Day4 = '12092018';
nmouse = '783ant'; 

supertit = 'Mouse 783 - PAGant ContextB';

suf = {'TestPre'; 'Cond'; 'TestPost'};

clrs = {'ko', 'bo', 'ro','go'; 'k','b', 'r', 'g'; 'kp', 'bp', 'rp', 'gp'};

% Highlight selected intensity
% chosen = [0 0 0 0]; % Nothing
% chosen = [0.12 0.78 0.02 0.04]; % 1.5V
% chosen = [0.143 0.78 0.02 0.05]; % 2V
% chosen = [0.165 0.78 0.02 0.05]; % 2.5V
% chosen = [0.182 0.78 0.02 0.05]; % 3V
% chosen = [0.205 0.78 0.02 0.05]; % 3.5V
% chosen = [0.224 0.78 0.02 0.05]; % 4V
% chosen = [0.246 0.78 0.02 0.05]; % 4.5V
chosen = [0.267 0.78 0.02 0.05]; % 5V
% chosen = [0.308 0.78 0.02 0.05]; % 6V

%% Axes
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1],  'Color',[1 1 1]);
if Avoidance
    TrajPreTest_Axes = axes('position', [0.03 0.4 0.3 0.3]);
    TrajCond_Axes = axes('position', [0.35 0.4 0.3 0.3]);
    TrajTestPost_Axes = axes('position', [0.67 0.4 0.3 0.3]);
else
    annotation(fbilan,'textbox',[0.35 0.45 0.3 0.15],'String','No Experiment Performed','LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 46, 'FontWeight','bold',...
        'FitBoxToText','on');
end

Calib_Axes = axes('position',[0.07 0.8 0.35 0.15]);
ContextMemory_Axes = axes('position',[0.50 0.75 0.2 0.2]);
Anatomy_Axes = axes('position', [0.63 0.725 0.45 0.25]);

if h24
    TrajTestPost24_Axes = axes('position', [0.38 0.05 0.27 0.27]);
else
    annotation(fbilan,'textbox',[0.65 0.15 0.2 0.1],'String','No tests 24 h later Performed','LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 36, 'FontWeight','bold',...
        'FitBoxToText','on');
end

if Avoidance
    OccupPost_Axes = axes('position', [0.05 0.22 0.12 0.12]);
    TimePost_Axes = axes('position', [0.23 0.22 0.12 0.12]);
    FirstPost_Axes = axes('position', [0.05 0.05 0.12 0.12]);
    SpeedPost_Axes = axes('position', [0.23 0.05 0.12 0.12]);
end

if h24
    OccupPost24_Axes = axes('position', [0.7 0.22 0.12 0.12]);
    TimePost24_Axes = axes('position', [0.87 0.22 0.12 0.12]);
    FirstPost24_Axes = axes('position', [0.7 0.05 0.12 0.12]);
    SpeedPost24_Axes = axes('position', [0.87 0.05 0.12 0.12]);
end

if Avoidance
    boxpost = [0.1 0.365 0.18 0.02];
    annotation(fbilan,'textbox',boxpost,'String','After 2-3h of Sleep','LineWidth',1,'HorizontalAlignment','center','FontWeight','bold',...
        'FitBoxToText','off');
    
    boxpost24 = [0.75 0.365 0.18 0.02];
    annotation(fbilan,'textbox',boxpost24,'String','After 24h','LineWidth',1,'HorizontalAlignment','center','FontWeight','bold',...
        'FitBoxToText','off');
end

annotation(fbilan,'ellipse', chosen, 'LineWidth',2);

% Supertitle
mtit(fbilan,supertit, 'fontsize',16, 'xoff', -0.1);

%% Calculate Data Calibration

% Allocate space
Freezing = zeros(1,length(Intensities));
Freezingperc = zeros(1,length(Intensities));
FreezingBeforeratio = zeros(1,length(Intensities));
FreezingAfterratio = zeros(1,length(Intensities));
FreezingRatio = zeros(1,length(Intensities));
FreezingBeforeRatioSingleShot = zeros(1,length(Intensities));
FreezingAfterRatioSingleShot = zeros(1,length(Intensities));
StartleIdxs = zeros(1,length(Intensities));

% Calculate
for i=1:length(Intensities)
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio(i) = FreezingAfterratio(i)/FreezingBeforeratio(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs(i) = F{i}.StartleIndex;
end

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Contextual Memory Data
%Day1A
if M788
    Freezing(1,1) = NaN;
    Freezingperc(1,1) = NaN;
else
    Epoch = intervalSet(Day1A.TTLInfo.StopSession-180*1E4,Day1A.TTLInfo.StopSession);
    FreezeEpoch = and(Day1A.FreezeAccEpoch,Epoch);
    Freezing(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
    Freezingperc(1,1) = Freezing(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
end
    
%Day2A
Epoch = intervalSet(Day2A.TTLInfo.StartSession,Day2A.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A.FreezeAccEpoch,Epoch);
FreezingMemo(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
FreezingpercMemo(1,2) = FreezingMemo(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B.FreezeAccEpoch,Day1B.TTLInfo.StimEpoch);
FreezingMemo(2,1) = sum(End(Day1B.FreezeAccEpoch)-Start(Day1B.FreezeAccEpoch))/1e4;
FreezingpercMemo(2,1) = FreezingMemo(2,1)/((Day1B.TTLInfo.StopSession-Day1B.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B.TTLInfo.StartSession,Day2B.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B.FreezeAccEpoch,Epoch);
FreezingMemo(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
FreezingpercMemo(2,2) = FreezingMemo(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

%% Get the data Avodance
for i = 1:1:ntest
    if Avoidance
        % PreTests
        a = load([indir Day3 '/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'],...
            'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
        Pre_Xtsd{i} = a.Xtsd;
        Pre_Ytsd{i} = a.Ytsd;
        Pre_Vtsd{i} = a.Vtsd;
        PreTest_PosMat{i} = a.PosMat;
        PreTest_occup(i,1:7) = a.Occup;
        PreTest_ZoneIndices{i} = a.ZoneIndices;
        Pre_mask = a.mask;
        Pre_Zone = a.Zone;
        Pre_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
        % Cond
        b = load([indir Day3 '/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
            'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
        Cond_Xtsd{i} = b.Xtsd;
        Cond_Ytsd{i} = b.Ytsd;
        Cond_Vtsd{i} = b.Vtsd;
        Cond_PosMat{i} = b.PosMat;
        Cond_occup(i,1:7) = b.Occup;
        Cond_ZoneIndices{i} = b.ZoneIndices;
        Cond_mask = b.mask;
        Cond_Zone = b.Zone;
        Cond_Ratio_IMAonREAL = b.Ratio_IMAonREAL;
        % PostTests
        c = load([indir Day3 '/' suf{3} '/' suf{3} num2str(i) '/behavResources.mat'],...
            'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
        Post_Xtsd{i} = c.Xtsd;
        Post_Ytsd{i} = c.Ytsd;
        Post_Vtsd{i} = c.Vtsd;
        PostTest_PosMat{i} = c.PosMat;
        PostTest_occup(i,1:7) = c.Occup;
        PostTest_ZoneIndices{i} = c.ZoneIndices;
        Post_mask = c.mask;
        Post_Zone = c.Zone;
        Post_Ratio_IMAonREAL = c.Ratio_IMAonREAL;
    end
    
    % PostTests h24 later
    if h24
        d = load([indir Day4 '/' suf{3} '/' suf{3} num2str(i) '/behavResources.mat'],...
        'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
        Post24_Xtsd{i} = d.Xtsd;
        Post24_Ytsd{i} = d.Ytsd;
        Post24_Vtsd{i} = d.Vtsd;
        Post24_PosMat{i} = d.PosMat;
        Post24_occup(i,1:7) = d.Occup;
        Post24_ZoneIndices{i} = d.ZoneIndices;
        Post24_mask = d.mask;
        Post24_Zone = d.Zone;
        Post24_Ratio_IMAonREAL = d.Ratio_IMAonREAL;
    end
end

%% Get stimulation idxs for conditioning sessions
if Avoidance
    for i=1:ntest
        StimT_beh{i} = find(Cond_PosMat{i}(:,4)==1);
    end
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
if Avoidance
    PreTest_occup = PreTest_occup*100;
    PostTest_occup = PostTest_occup*100;
end
if h24
    Post24_occup = Post24_occup*100;
end

if Avoidance
    Pre_Occup_mean = mean(PreTest_occup,1);
    Pre_Occup_std = std(PreTest_occup,1);
    Post_Occup_mean = mean(PostTest_occup,1);
    Post_Occup_std = std(PostTest_occup,1);
end
if h24
    Post24_Occup_mean = mean(Post24_occup,1);
    Post24_Occup_std = std(Post24_occup,1);
end
% Wilcoxon signed rank task between Pre and PostTest
if Avoidance
    p_pre_post = signrank(PreTest_occup(:,1),PostTest_occup(:,1));
end
% Wilcoxon signed rank task between Pre and PostTesth24
if h24
    p_pre_post24 = signrank(PreTest_occup(:,1),Post24_occup(:,1));
end
% Prepare arrays for plotting
if Avoidance
    point_pre_post = [PreTest_occup(:,1) PostTest_occup(:,1)];
end
if h24
    point_pre_post24 = [PreTest_occup(:,1) Post24_occup(:,1)];
end

%% Prepare the 'first enter to shock zone' array
for u = 1:ntest
    if Avoidance
        if isempty(PreTest_ZoneIndices{u}{1})
            Pre_FirstTime(u) = 240;
        else
            Pre_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
            Pre_FirstTime(u) = PreTest_PosMat{u}(Pre_FirstZoneIndices(u),1);
        end
    
        if isempty(PostTest_ZoneIndices{u}{1})
            Post_FirstTime(u) = 240;
        else
            Post_FirstZoneIndices(u) = PostTest_ZoneIndices{u}{1}(1);
            Post_FirstTime(u) = PostTest_PosMat{u}(Post_FirstZoneIndices(u),1);
        end
    end
    
    if h24
        if isempty(Post24_ZoneIndices{u}{1})
            Post24_FirstTime(u) = 240;
        else
            Post24_FirstZoneIndices(u) = Post24_ZoneIndices{u}{1}(1);
            Post24_FirstTime(u) = Post24_PosMat{u}(Post24_FirstZoneIndices(u),1);
        end
    end
    
    if Avoidance
        Pre_Post_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post_FirstTime(u)];
    end
    if h24
        Pre_Post24_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post24_FirstTime(u)];
    end
    
end

if Avoidance
    Pre_Post_FirstTime_mean = mean(Pre_Post_FirstTime,1);
    Pre_Post_FirstTime_std = std(Pre_Post_FirstTime,1);
    p_FirstTime_pre_post = signrank(Pre_Post_FirstTime(:,1),Pre_Post_FirstTime(:,2));
end
if h24
    Pre_Post24_FirstTime_mean = mean(Pre_Post24_FirstTime,1);
    Pre_Post24_FirstTime_std = std(Pre_Post24_FirstTime,1);
    p_FirstTime_pre_post24 = signrank(Pre_Post_FirstTime(:,1),Pre_Post24_FirstTime(:,2));
end

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for m = 1:ntest
    if Avoidance
        if isempty(PreTest_ZoneIndices{m}{1})
            Pre_entnum(m) = 0;
        else
            Pre_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{1})>1))+1;
        end
    
        if isempty(PostTest_ZoneIndices{m}{1})
            Post_entnum(m)=0;
        else
            Post_entnum(m)=length(find(diff(PostTest_ZoneIndices{m}{1})>1))+1;
        end
    end
    
    if h24
        if isempty(Post24_ZoneIndices{m}{1})
            Post24_entnum(m)=0;
        else
            Post24_entnum(m)=length(find(diff(Post24_ZoneIndices{m}{1})>1))+1;
        end
    end
    
end

if Avoidance
    Pre_Post_entnum = [Pre_entnum; Post_entnum]';
    Pre_Post_entnum_mean = mean(Pre_Post_entnum,1);
    Pre_Post_entnum_std = std(Pre_Post_entnum,1);
    p_entnum_pre_post = signrank(Pre_entnum, Post_entnum);
end

if h24
    Pre_Post24_entnum = [Pre_entnum; Post24_entnum]';
    Pre_Post24_entnum_mean = mean(Pre_Post24_entnum,1);
    Pre_Post24_entnum_std = std(Pre_Post24_entnum,1);
    p_entnum_pre_post24 = signrank(Pre_entnum, Post24_entnum);
end

%% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
for r=1:ntest
    if Avoidance
        % PreTest ShockZone speed
            if isempty(PreTest_ZoneIndices{r}{1})
                VZmean_pre(r) = 0;
            else
                Vtemp_pre{r}=Data(Pre_Vtsd{r});
                VZone_pre{r}=Vtemp_pre{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
                VZmean_pre(r)=mean(VZone_pre{r},1);
            end
        
            % PostTest ShockZone speed
            if isempty(PostTest_ZoneIndices{r}{1})
                VZmean_post(r) = 0;
            else
                Vtemp_post{r}=Data(Post_Vtsd{r});
                VZone_post{r}=Vtemp_post{r}(PostTest_ZoneIndices{r}{1}(1:end-1),1);
                VZmean_post(r)=mean(VZone_post{r},1);
            end
    end
    
    if h24
        % PostTesth24 ShockZone speed
        if isempty(Post24_ZoneIndices{r}{1})
            VZmean_post24(r) = 0;
        else
            Vtemp_post24{r}=Data(Post24_Vtsd{r});
            VZone_post24{r}=Vtemp_post24{r}(Post24_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_post24(r)=mean(VZone_post24{r},1);
        end
    end

end

if Avoidance
    Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
    Pre_Post_VZmean_mean = mean(Pre_Post_VZmean,1);
    Pre_Post_VZmean_std = std(Pre_Post_VZmean,1);
    p_VZmean_pre_post = signrank(VZmean_pre, VZmean_post);
end

if h24
    Pre_Post24_VZmean = [VZmean_pre; VZmean_post24]';
    Pre_Post24_VZmean_mean = mean(Pre_Post24_VZmean,1);
    Pre_Post24_VZmean_std = std(Pre_Post24_VZmean,1);
    p_VZmean_pre_post24 = signrank(VZmean_pre, VZmean_post24);
end

%% Plot the figure

% Plot Calibration
axes(Calib_Axes);
yyaxis left
h1 = plot(Intensities, Freezingperc, '-ko', 'LineWidth', 2);
hold on
h2 = plot(Intensities, FreezingBeforeRatioSingleShot*100, 'b--o');
hold on
h3 = plot(Intensities, FreezingAfterRatioSingleShot*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
ylabel('%Freezing');
yyaxis right
h4 = plot(Intensities, StartleIdxs, '-mo');
ylabel('Startle Index');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
xlim([0 8.5]);
title('Calibration');
legend([h1 h2 h3 h4], 'Overall freezing', 'Freezing before the first stim', 'Freezing after the first stim', 'Startle Index',...
    'Location', 'SouthEast');

% Plot Contextual Memory
axes(ContextMemory_Axes);
bar(FreezingpercMemo);
set(gca,'Xtick',[1:2],'XtickLabel',xticky);
title('Contextual Memory');
ylabel('%Freezing');
ylim([0 100]);
lg = legend('Day1', 'Day2');

% Anatomy figure
axes(Anatomy_Axes);
imshow(figpath, 'InitialMagnification', 'fit');
title('Electrode position');

% Trajectories in PreTests
if Avoidance
    axes(TrajPreTest_Axes);
    imagesc(Pre_mask);
    colormap(gray)
    hold on
    imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
    hold on
    for p=1:1:ntest
        plot(PreTest_PosMat{p}(:,2)*Pre_Ratio_IMAonREAL,PreTest_PosMat{p}(:,3)*Pre_Ratio_IMAonREAL,...
            clrs{2,p},'linewidth',1.5)
        hold on
    end
    legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    title ('Trajectories during PreTests');
end

% Trajectories in Cond
if Avoidance
    axes(TrajCond_Axes);
    imagesc(Cond_mask);
    colormap(gray)
    hold on
    imagesc(Cond_Zone{1}, 'AlphaData', 0.3);
    hold on
    for p=1:1:ntest
        plot(Cond_PosMat{p}(:,2)*Cond_Ratio_IMAonREAL,Cond_PosMat{p}(:,3)*Cond_Ratio_IMAonREAL,...
            clrs{2,p},'linewidth',1.5)
        hold on
    end
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    for p=1:1:ntest
        for j = 1:length(StimT_beh{p})
            if p < 4
                h1 = plot(Cond_PosMat{p}(StimT_beh{p}(j),2)*Cond_Ratio_IMAonREAL, Cond_PosMat{p}(StimT_beh{p}(j),3)*Cond_Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerSize', 14, 'MarkerFaceColor', clrs{2,p});
                uistack(h1,'top');
            else
                h1 = plot(Cond_PosMat{p}(StimT_beh{p}(j),2)*Cond_Ratio_IMAonREAL, Cond_PosMat{p}(StimT_beh{p}(j),3)*Cond_Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerEdgeColor', [0.1 0.4 0.3], 'MarkerSize', 14, 'MarkerFaceColor', [0.1 0.4 0.3]);
            end
            z(p) = length(StimT_beh{p});
        end
    end
    title (['Trajectories during conditioning: ' num2str(sum(z)) ' stims']);
    clear z
end

% Trajectories in PostTests
if Avoidance
    axes(TrajTestPost_Axes);
    imagesc(Post_mask);
    colormap(gray)
    hold on
    imagesc(Post_Zone{1}, 'AlphaData', 0.3);
    hold on
    for l=1:1:ntest
        plot(PostTest_PosMat{l}(:,2)*Post_Ratio_IMAonREAL,PostTest_PosMat{l}(:,3)*Post_Ratio_IMAonREAL,...
            clrs{2,l},'linewidth',1.5)
        hold on
    end
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    title ('Trajectories during PostTests (after 2-3h of sleep)');
end


% Occupancy BarPlot
if Avoidance
    axes(OccupPost_Axes);
    bar([Pre_Occup_mean(1) Post_Occup_mean(1)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_Occup_mean(1) Post_Occup_mean(1)], [Pre_Occup_std(1) Post_Occup_std(1)],'.', 'Color', 'r');
    hold on
    for k = 1:ntest
        plot([1 2],point_pre_post(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('% time spent')
    xlim([0.5 2.5])
    if p_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_pre_post);
    end
    hold off
    box off
    title ('Percentage of occupancy', 'FontSize', 10);

    %Number of entries into the shock zone BarPlot
    axes(TimePost_Axes);
    bar([Pre_Post_entnum_mean(1) Pre_Post_entnum_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post_entnum_mean, Pre_Post_entnum_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Number of entries')
    xlim([0.5 2.5])
    if p_entnum_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_entnum_pre_post);
    end
    box off
    hold off
    title ('# of entries to the shockzone', 'FontSize', 10);

    % First time to enter the shock zone BarPlot
    axes(FirstPost_Axes);
    bar([Pre_Post_FirstTime_mean(1) Pre_Post_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post_FirstTime_mean, Pre_Post_FirstTime_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Time (s)')
    xlim([0.5 2.5])
    if p_FirstTime_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_FirstTime_pre_post);
    end
    box off
    hold off
    title ('First time to enter the shockzone', 'FontSize', 10);

    % Average speed into the shock zone BarPlot
    axes(SpeedPost_Axes);
    bar([Pre_Post_VZmean_mean(1) Pre_Post_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post_VZmean_mean, Pre_Post_VZmean_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Average speed (cm/s)')
    xlim([0.5 2.5])
    if p_VZmean_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_VZmean_pre_post);
    end
    box off
    hold off
    title ('Average speed', 'FontSize', 10);
end

if h24
    % Trajectories in PostTests  h24 later
    axes(TrajTestPost24_Axes);
    imagesc(Post24_mask);
    colormap(gray)
    hold on
    imagesc(Post24_Zone{1}, 'AlphaData', 0.3);
    hold on
    for l=1:1:ntest
        plot(Post24_PosMat{l}(:,2)*Post24_Ratio_IMAonREAL,Post24_PosMat{l}(:,3)*Post24_Ratio_IMAonREAL,...
            clrs{2,l},'linewidth',1.5)
        hold on
    end
    title ('Trajectories h24 later');
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);

    % Occupancy BarPlot h24 later
    axes(OccupPost24_Axes);
    bar([Pre_Occup_mean(1) Post24_Occup_mean(1)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_Occup_mean(1) Post24_Occup_mean(1)], [Pre_Occup_std(1) Post24_Occup_std(1)],'.', 'Color', 'r');
    hold on
    for k = 1:ntest
        plot([1 2],point_pre_post24(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('% time spent')
    xlim([0.5 2.5])
    if p_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_pre_post24);
    end
    hold off
    box off
    title ('Percentage of occupancy', 'FontSize', 10);

    %Number of entries into the shock zone BarPlot
    axes(TimePost24_Axes);
    bar([Pre_Post24_entnum_mean(1) Pre_Post24_entnum_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_entnum_mean, Pre_Post24_entnum_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post24_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Number of entries')
    xlim([0.5 2.5])
    if p_entnum_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_entnum_pre_post24);
    end
    box off
    hold off
    title ('# of entries to the shockzone', 'FontSize', 10);

    % First time to enter the shock zone BarPlot
    axes(FirstPost24_Axes);
    bar([Pre_Post24_FirstTime_mean(1) Pre_Post24_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_FirstTime_mean, Pre_Post24_FirstTime_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post24_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Time (s)')
    xlim([0.5 2.5])
    if p_FirstTime_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_FirstTime_pre_post24);
    end
    box off
    hold off
    title ('First time to enter the shockzone', 'FontSize', 10);

    % Average speed into the shock zone BarPlot
    axes(SpeedPost24_Axes);
    bar([Pre_Post24_VZmean_mean(1) Pre_Post24_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_VZmean_mean, Pre_Post24_VZmean_std,'.', 'Color', 'r');
    hold on
    for g = 1:ntest
        plot([1 2],Pre_Post24_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Average speed (cm/s)')
    xlim([0.5 2.5])
    if p_VZmean_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_VZmean_pre_post24);
    end
    box off
    hold off
    title ('Average speed', 'FontSize', 10);
end


%% Save
if sav
    saveas(gcf, [dir_out 'M' nmouse '_' fig_post '.fig']);
    saveFigure(gcf,['M' nmouse '_' fig_post],dir_out);
end

%% Clear
clear