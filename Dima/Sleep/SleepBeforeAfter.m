%% Parameters
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = [797 798 828 861 882 905 912 977];
average = 1;   % Show one mouse (0) ot the average (1)
sav=0;

dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', Mice_to_analyze);

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

%% Prepare arrays
PreWake = zeros(1,length(Dir.path));
PreSWS = zeros(1,length(Dir.path));
PreREM = zeros(1,length(Dir.path));
PreSleep = zeros(1,length(Dir.path));

PostWake = zeros(1,length(Dir.path));
PostSWS = zeros(1,length(Dir.path));
PostREM = zeros(1,length(Dir.path));
PostSleep = zeros(1,length(Dir.path));

PreSWSperc = zeros(1,length(Dir.path));
PreREMperc = zeros(1,length(Dir.path));
PostSWSperc = zeros(1,length(Dir.path));
PostREMperc = zeros(1,length(Dir.path));

%% Load data
for i=1:length(Dir.path)
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources', 'SessionEpoch');
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    else
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    end
end

%% Find indices of PreSleep and PostSleep session in the structure
id_Pre = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    id_Pre{i} = zeros(1,length(a{i}.behavResources));
    id_Post{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'PreSleep'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'PostSleep'))
            id_Post{i}(k) = 1;
        end
    end
    id_Pre{i}=find(id_Pre{i});
    id_Post{i}=find(id_Post{i});
end

%% Calculate
% Individually
for i=1:length(a)
    PreWake(i) = sum(End(and(sleepscored{i}.Wake,a{i}.SessionEpoch.PreSleep))-...
        Start(and(sleepscored{i}.Wake,a{i}.SessionEpoch.PreSleep)))/1e4;
    PreSWS(i) = sum(End(and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PreSleep))-...
        Start(and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PreSleep)))/1e4;
    PreREM(i) = sum(End(and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PreSleep))-...
        Start(and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PreSleep)))/1e4;
    PreSleep(i) = sum(End(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PreSleep))-...
        Start(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PreSleep)))/1e4;
    
    % PreWakeBouts(i) = End(Pre{i}.Wake)-Start(Pre{i}.Wake)/1e4;
    % PreSWSBouts(i) = End(Pre{i}.SWSEpoch)-Start(Pre{i}.SWSEpoch)/1e4;
    % PreREMBouts(i) = End(Pre{i}.REMEpoch)-Start(Pre{i}.REMEpoch)/1e4;
    % PreSleepBouts(i) = End(Pre{i}.Sleep)-Start(Pre{i}.Sleep)/1e4;
    
    PostWake(i) = sum(End(and(sleepscored{i}.Wake,a{i}.SessionEpoch.PostSleep))-...
        Start(and(sleepscored{i}.Wake,a{i}.SessionEpoch.PostSleep)))/1e4;
    PostSWS(i) = sum(End(and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PostSleep))-...
        Start(and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PostSleep)))/1e4;
    PostREM(i) = sum(End(and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PostSleep))-...
        Start(and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PostSleep)))/1e4;
    PostSleep(i) = sum(End(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PostSleep))-...
        Start(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PostSleep)))/1e4;
    
    % PostWakeBouts(i) = End(Post{i}.Wake)-Start(Post{i}.Wake)/1e4;
    % PostSWSBouts(i) = End(Post{i}.SWSEpoch)-Start(Post{i}.SWSEpoch)/1e4;
    % PostREMBouts(i) = End(Post{i}.REMEpoch)-Start(Post{i}.REMEpoch)/1e4;
    % PostSleepBouts(i) = End(Post{i}.Sleep)-Start(Post{i}.Sleep)/1e4;
    
    PreSWSperc(i) = PreSWS(i)/PreSleep(i)*100;
    PreREMperc(i) = PreREM(i)/PreSleep(i)*100;
    PreWakeperc(i) = PreWake(i)/PreSleep(i)*100;
    lPre_Session = sum(End(a{i}.SessionEpoch.PreSleep)-Start(a{i}.SessionEpoch.PreSleep))/1e4;
    PreSWSperc_Session(i) = PreSWS(i)/lPre_Session*100;
    PreREMperc_Session(i) = PreREM(i)/lPre_Session*100;
    PreWakeperc_Session(i) = PreWake(i)/lPre_Session*100;
   
    
    PostSWSperc(i) = PostSWS(i)/PostSleep(i)*100;
    PostREMperc(i) = PostREM(i)/PostSleep(i)*100;
    PostWakeperc(i) = PostWake(i)/PostSleep(i)*100;
    lPost_Session = sum(End(a{i}.SessionEpoch.PostSleep)-Start(a{i}.SessionEpoch.PostSleep))/1e4;
    PostSWSperc_Session(i) = PostSWS(i)/lPost_Session*100;
    PostREMperc_Session(i) = PostREM(i)/lPost_Session*100;
    PostWakeperc_Session(i) = PostWake(i)/lPost_Session*100;
    
    
    PrePostSWSperc(i,1:2) = [PreSWSperc(i) PostSWSperc(i)];
    PrePostREMperc(i,1:2) = [PreREMperc(i) PostREMperc(i)];
    
    lPreSleep(i) = sum(End(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PreSleep))-...
        Start(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PreSleep)))/1e4;
    lPostSleep(i) = sum(End(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PostSleep))-...
        Start(and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PostSleep)))/1e4;
%     shortPostSleep{i} = RestrictToTime(Post{i}.Sleep, lPreSleep(i));
%     
%     PostREMShortIS{i} = and(Post{i}.REMEpoch,shortPostSleep{i});
%     PostREMRestIS{i} = and(Post{i}.REMEpoch,shortPostSleep{i});
%     PostREMShort(i) = sum(End(PostREMShortIS{i})-Start(PostREMShortIS{i}))/1e4;
%     PostREMShortperc(i) = PostREMShort(i)/(lPreSleep(i)/1e4)*100;
    
end

% Average
if average == 1
    PreSWSperc_aver = mean(PreSWSperc);
    PreSWSperc_std = std(PreSWSperc);
    PreREMperc_aver = mean(PreREMperc);
    PreREMperc_std = std(PreREMperc);
    PRESWSREM_aver = [PreSWSperc_aver PreREMperc_aver];
    PRESWSREM_std = [PreSWSperc_std PreREMperc_std];
    
%     PreSWSperc_aver = mean(PreSWSperc);
%     PreSWSperc_std = std(PreSWSperc);
%     PreREMperc_aver = mean(PreREMperc);
%     PreREMperc_std = std(PreREMperc);
%     PRESWSREM_aver = [PreSWSperc_aver PreREMperc_aver];
%     PRESWSREM_std = [PreSWSperc_std PreREMperc_std];
    
    PostSWSperc_aver = mean(PostSWSperc);
    PostSWSperc_std = std(PostSWSperc);
    PostREMperc_aver = mean(PostREMperc);
    PostREMperc_std = std(PostREMperc);
    POSTSWSREM_aver = [PostSWSperc_aver PostREMperc_aver];
    POSTSWSREM_std = [PostSWSperc_std PostREMperc_std];
end
%% Figure
if average == 0
    figure
    bar([PreWake PostWake; PreSWS PostSWS; PreREM PostREM]);
    set(gca,'Xtick',[1:3],'XtickLabel',{'Wake', 'SWS', 'REM'});
    ylabel('Duration (s)');
    title('Overall length');
    legend('Pre', 'Post');

    figure
    bar([PreWake PostWake; PreSleep PostSleep]);
    set(gca,'Xtick',[1:2],'XtickLabel',{'Wake', 'Sleep'});
    ylabel('Duration (s)');
    title('Overall length');
    legend('Pre', 'Post');

    figure
    bar([PreSWSperc PostSWSperc; PreREMperc PostREMperc]);
    set(gca,'Xtick',[1:2],'XtickLabel',{'SWS', 'REM'});
    ylabel('Percentage of sleep');
    title('Percentage of sleep');
    legend('Pre', 'Post');
    
elseif average == 1 %%%%% MAKE IT PERCENTAGE!
    figure('units','normalized', 'outerposition', [0 1 1 1])
    subplot(221)
    [p,h,her] = PlotErrorBarN_DB([lPreSleep'/60 lPostSleep'/60], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(h, 'LineWidth', 3);
    set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
    set(her, 'LineWidth', 3);
    ylabel('Time (min)');
    title('Overall length of sleep');
    
    subplot(222)
    [p,h,her] = PlotErrorBarN_DB([PreSWSperc' PostSWSperc'], 'barcolors', [0 0 0], 'barwidth', 0., 'newfig', 0);
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(h, 'LineWidth', 3);
    set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
    set(her, 'LineWidth', 3);
    ylabel('% of sleep')
    ylim([60 100])
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    title('Overall percentage of SWS');
    
    subplot(223)
    [p,h,her] = PlotErrorBarN_DB([PreREMperc' PostREMperc'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(h, 'LineWidth', 3);
    set(her, 'LineWidth', 3);
    set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
    ylabel('Percentage of sleep');
    title('Overall percentage of REM');
    
end

%% F
f1 = figure('units','normalized', 'outerposition', [0 1 0.9 0.5]);
subplot(131)
[psws,h,her] = PlotErrorBarN_DB([PreWakeperc_Session' PostWakeperc_Session'], 'barcolors', [0 0 0], 'barwidth', 0.8, 'newfig', 0, 'showpoints',0);
set(gca, 'FontSize', 18, 'FontWeight',  'bold','LineWidth',5);
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 5);
set(gca,'Xtick',[1:2],'XtickLabel',{});
set(her, 'LineWidth', 3);
ylabel('%')
ylim([0 80])
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% title('Overall percentage of SWS');

subplot(132)
[psws,h,her] = PlotErrorBarN_DB([PreSWSperc_Session' PostSWSperc_Session'], 'barcolors', [0 0 0], 'barwidth', 0.8, 'newfig', 0, 'showpoints',0);
set(gca, 'FontSize', 18, 'FontWeight',  'bold','LineWidth',5);
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(gca,'Xtick',[1:2],'XtickLabel',{});
set(her, 'LineWidth', 3);
ylabel('%')
ylim([0 80])
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% title('Overall percentage of SWS');

subplot(133)
[prem,h,her] = PlotErrorBarN_DB([PreREMperc_Session' PostREMperc_Session'], 'barcolors', [0 0 0], 'barwidth', 0.8, 'newfig', 0, 'showpoints',0);
    set(gca, 'FontSize', 18, 'FontWeight',  'bold','LineWidth',5);
    h.FaceColor = 'flat';
   h.CData(1,:) = [0 0 0];
    h.CData(2,:) = [1 1 1];
    set(h, 'LineWidth', 3);
    set(her, 'LineWidth', 3);
    ylim([0 12])
    set(gca,'Xtick',[1:2],'XtickLabel',{});
    ylabel('%')
%     title('Overall percentage of REM');
    
    if sav
        saveas(f1, [dir_out 'SWS_REM.fig']);
        saveFigure(f1,'SWS_REM',dir_out);
    end
    
    
%%
f2 = figure('units','normalized', 'outerposition', [0 1 0.5 0.7]);
    subplot(121)
    [psws,h,her] = PlotErrorBarN_DB([PreSWSperc_Session' PostSWSperc_Session'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    h.FaceColor = 'flat';
    h.CData(1,:) = [0 0 0];
    h.CData(2,:) = [1 1 1];
    set(h, 'LineWidth', 3);
    set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
    set(her, 'LineWidth', 3);
    ylabel('% of sleep')
%     ylim([75 100])
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    title('Overall percentage of SWS');
    
    subplot(122)
    [prem,h,her] = PlotErrorBarN_DB([PreREMperc_Session' PostREMperc_Session'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    h.FaceColor = 'flat';
   h.CData(1,:) = [0 0 0];
    h.CData(2,:) = [1 1 1];
    set(h, 'LineWidth', 3);
    set(her, 'LineWidth', 3);
    ylim([0 12])
    set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
    ylabel('% of sleep')
    title('Overall percentage of REM');
    
    if sav
        saveas(f2, [dir_out 'SWS_REM_Session.fig']);
        saveFigure(f2,'SWS_REM_Session',dir_out);
    end