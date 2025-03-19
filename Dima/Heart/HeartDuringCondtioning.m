%%% HeartRateDuringConditioning

%% Parameters

% Numbers of mice to run analysis on
Mice_to_analyze = [797 798];
% Get directories
Dir = PathForExperimentsERC_Dima('CondPooled');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
% Output
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'ConditioningEffect';

% % 0 - show heart rate before and after stimulations of more than HBTresh seconds apart; 1 - show all
% HBAll = 0;
% % Distance between stimulations to show the heart rate (in seconds)
% HBTresh = 60;
%% Load data
for i = 1:length(Dir.path)
    HR{i} = load([Dir.path{i}{1} '/HeartBeatInfo.mat']);
    beh{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'TTLInfo');

%% Calculate and plot mean heart rate 10 sec before the first and the last stimulation
%  Commented - HR around the stimulations separated by a minute (or only
%  the first one, if you don't have any) OR ALL

Stims{i} = Start(beh{i}.TTLInfo.StimEpoch);
if isempty(Stims)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else
%     EpochBefore{i} = intervalSet(Stims{i}(1)-10E4, Stims{i}(1));
%     EpochAfter{i} = intervalSet(Stims{i}(end)-10E4, Stims{i}(end));
    
    EpochBefore{i} = intervalSet(Stims{i}(1)-10E4, Stims{i}(1));
    EpochAfter{i} = intervalSet(Stims{i}(1), Stims{i}(1)+10e4);
    
%     if HBAll
%         EpochBefore = intervalSet(Stims-10E4, Stims);
%         EpochAfter = intervalSet(Stims, Stims+10.2E4);
%     else
%         ch = diff(Stims);
%         idx = find(ch>HBTresh*1E4);
%         if isempty(idx)
%             EpochBefore = intervalSet(Stims(1)-10E4, Stims(1));
%             EpochAfter = intervalSet(Stims(1), Stims(1)+10.2E4);
%         else
%             EpochBefore = intervalSet(Stims(idx)-10E4, Stims(idx));
%             EpochAfter = intervalSet(Stims(idx), Stims(idx)+10.2E4);
%         end
%     end
   
    RateBefore{i} = Restrict(HR{i}.EKG.HBRate, EpochBefore{i});
    RateAfter{i} = Restrict(HR{i}.EKG.HBRate, EpochAfter{i});
   
    avRateBefore(i) = mean(Data(RateBefore{i}));
    avRateAfter(i) = mean(Data(RateAfter{i}));

end

end



%% Figure
    figure
    bar([mean(avRateBefore) mean(avRateAfter)], 'FaceColor', 'k')
    hold on
    errorbar([mean(avRateBefore) mean(avRateAfter)], [std(avRateBefore) std(avRateAfter)],'.', 'Color', 'r');
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'First Shock', 'Last Shock'})
    ylabel('Heart Rate (Hz)')
    xlim([0.5 2.5]);
    ylim([5 15]);
    title ('Heart Rate 10 sec before shock');