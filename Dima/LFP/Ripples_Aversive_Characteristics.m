%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';
fig_post = 'RipplesPrePostCharacteristics';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912 977]);

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
    Session{i}.SessionEpoch.PreSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
    Session{i}.SessionEpoch.PostSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
end



% Extract ripples for presleep and postsleep (during detected sleep only)
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    PreRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));

    ripplesBeg{i}=tsd(Rip{i}.ripples(:,2)*1e4,Rip{i}.ripples(:,1)*1e4);
    PreRipplesBeg{i}=Restrict(ripplesBeg{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipplesBeg{i}=Restrict(ripplesBeg{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));
    
    ripplesEnd{i}=tsd(Rip{i}.ripples(:,2)*1e4,Rip{i}.ripples(:,3)*1e4);
    PreRipplesEnd{i}=Restrict(ripplesEnd{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipplesEnd{i}=Restrict(ripplesEnd{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));
    
    ripplesAmp{i}=tsd(Rip{i}.ripples(:,2)*1e4,Rip{i}.ripples(:,4));
    PreRipplesAmp{i}=Restrict(ripplesAmp{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipplesAmp{i}=Restrict(ripplesAmp{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));
    
    PreRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PreSleep1_30);
    PostRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PostSleep1_30);
end


for i=1:length(Dir.path)
    % Number during sleep
    Pre_N(i)=length(Range(PreRipples{i}));
    Post_N(i)=length(Range(PostRipples{i}));
    % Normalize to the duration of sleep
    TimePre{i} = and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch);
    Pre_N_norm_all(i) = Pre_N(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch);
    Post_N_norm_all(i) = Post_N(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    
    % First 30min
    % Number during sleep
    % First 30min
    % Number during sleep
    Pre_N1_30(i)=length(Range(PreRipples1_30{i}));
    Post_N1_30(i)=length(Range(PostRipples1_30{i}));
    % Normalize to the duration of sleep
    TimePre1_30{i} = Session{i}.SessionEpoch.PreSleep1_30;
    Pre_N1_30_norm_all(i) = Pre_N1_30(i)/((sum(End(TimePre1_30{i})- Start(TimePre1_30{i})))/1e4); 
    TimePost1_30{i} = Session{i}.SessionEpoch.PostSleep1_30;
    Post_N1_30_norm_all(i) = Post_N1_30(i)/((sum(End(TimePost1_30{i})- Start(TimePost1_30{i})))/1e4);
    
    % Duration
    for k = 1:length(Range(PreRipplesBeg{i}))
        Pre_dur{i} = (Data(PreRipplesEnd{i})/1e4) - (Data(PreRipplesBeg{i})/1e4);
    end
    Pre_dur_mean(i) = mean(Pre_dur{i});
    for k = 1:length(Range(PostRipplesBeg{i}))
        Post_dur{i} = (Data(PostRipplesEnd{i})/1e4) - (Data(PostRipplesBeg{i})/1e4);
    end
    Post_dur_mean(i) = mean(Post_dur{i});
    % Amplitude
    Pre_Amp_mean(i) = mean(Data(PreRipplesAmp{i}));
    Post_Amp_mean(i) = mean(Data(PostRipplesAmp{i}));
end


%% Plot

figure('units', 'normalized', 'outerposition', [0 0 1 0.6])

% Absolute number
subplot(141)
[p,h, her] = PlotErrorBarN_DB([Pre_N_norm_all' Post_N_norm_all'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
ylim([0 0.8]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Ripples/s');
title('Ripples occurence', 'FontSize', 14);

subplot(142)
[p,h, her] = PlotErrorBarN_DB([(Pre_dur_mean*1e3)' (Post_dur_mean*1e3)'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
ylim([0 55]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Duration (ms)');
title('Mean ripples duration', 'FontSize', 14);

subplot(143)
[p,h, her] = PlotErrorBarN_DB([Pre_Amp_mean' Post_Amp_mean'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
ylim([0 20]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Amplitude');
title('Mean ripples amplitude', 'FontSize', 14);

subplot(144)
[p,h, her] = PlotErrorBarN_DB([Pre_N1_30_norm_all' Post_N1_30_norm_all'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
ylim([0 1.2]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Ripples/s');
title('Ripples occurence in first 30 min of sleep', 'FontSize', 14);

%% Save figure
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end

%% Plot

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

Effect = (Post_N_norm_all)' - (Pre_N_norm_all');
AmpEffect = [mean([Pre_Amp_mean' Post_Amp_mean'],2) Effect];
AmpEffectCorr = corrcoef([mean([Pre_Amp_mean' Post_Amp_mean'],2) Effect]);
DurEffect = [mean([(Pre_dur_mean*1e3)' (Post_dur_mean*1e3)'],2) Effect];
DurEffectCorr = corrcoef([mean([(Pre_dur_mean*1e3)' (Post_dur_mean*1e3)'],2) Effect]);

subplot(121)
scatter(DurEffect(:,1),DurEffect(:,2), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('Difference between before and after');
xlabel('Duration of ripples');
title('Ripples density effect correlation with ripples duration', 'FontSize', 14);

subplot(122)
scatter(AmpEffect(:,1),AmpEffect(:,2), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('Difference between before and after');
xlabel('Amplitude of ripples');
title('Ripples density effect correlation with ripples amplitude', 'FontSize', 14);

if sav
    saveas(gcf, [dir_out 'Correlation.fig']);
    saveFigure(gcf,'Correlation',dir_out);
end

%% Excel
% Pre_N_norm_all = Pre_N_norm_all';
% Post_N_norm_all = Post_N_norm_all';
% Pre_Amp_mean = Pre_Amp_mean';
% Post_Amp_mean = Post_Amp_mean';
% Pre_dur_mean = (Pre_dur_mean*1e3)';
% Post_dur_mean = (Post_dur_mean*1e3)';
% 
% 
% T = table(Pre_N_norm_all, Post_N_norm_all, Pre_Amp_mean, Post_Amp_mean, Pre_dur_mean,Post_dur_mean);
% 
% filenme = [dir_out 'finalxls1.xlsx'];
% writetable(T, filenme, 'Sheet',1,'Range','A1');