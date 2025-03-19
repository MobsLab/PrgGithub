%%% SpeedDistributions

%% Parameters

Mouse_to_analyze = 753;
% Before Vtsd correction == 1
old = 1;

% Get directories
Dir_Hab = PathForExperimentsERC_Dima('Hab');
Dir_Hab = RestrictPathForExperiment(Dir_Hab,'nMice', Mouse_to_analyze);
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mouse_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mouse_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'SpeedDistribution';

Smooth_camera = 15;
th_v = 2; % 3?
ov_dur = 360;

fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%% Habituation
hab = load ([Dir_Hab.path{1}{1} 'behavResources.mat'], 'Vtsd', 'Xtsd', 'ImmobEpoch', 'LocomotionEpoch', 'AllAwakeEpochDB');
if old
    HabNewVtsd = tsd(Range(hab.Vtsd),(Data(hab.Vtsd)./(diff(Range(hab.Xtsd))/1E4)));
else
    HabNewVtsd = tsd(Range(hab.Vtsd),(Data(hab.Vtsd)));
end
HabNewVtsd = tsd(Range(HabNewVtsd),runmean(Data(HabNewVtsd),Smooth_camera));

subplot(2,2,1:2)
hist(Data(HabNewVtsd), 100);
line([th_v th_v], ylim, 'color', 'r', 'LineWidth', 3);

perimmob = sum(End(hab.ImmobEpoch)-Start(hab.ImmobEpoch))/sum(End(hab.AllAwakeEpochDB)-Start(hab.AllAwakeEpochDB))*100;
perlocom = sum(End(hab.LocomotionEpoch)-Start(hab.LocomotionEpoch))/sum(End(hab.AllAwakeEpochDB)-Start(hab.AllAwakeEpochDB))*100;

title(['Habituation' newline 'Immobility = ~', sprintf('%2.2f', perimmob), '% or ', sprintf('%2.2f', ov_dur*perimmob/100) 's',...
    ' , Locomotion = ~', sprintf('%3.3f',perlocom), '% or ', sprintf('%3.3f',ov_dur*perlocom/100) 's']);
xlabel('Speed (cm/s)');
ylabel('Counts');

clear hab

%% PreTest
pre = load ([Dir_Pre.path{1}{1} 'behavResources.mat'], 'Vtsd', 'Xtsd', 'ImmobEpoch', 'LocomotionEpoch', 'AllAwakeEpochDB');
if old
    PreNewVtsd = tsd(Range(pre.Vtsd),(Data(pre.Vtsd)./(diff(Range(pre.Xtsd))/1E4)));
else
    PreNewVtsd = tsd(Range(pre.Vtsd),(Data(pre.Vtsd)));
end
PreNewVtsd = tsd(Range(PreNewVtsd),runmean(Data(PreNewVtsd),Smooth_camera));

subplot(2,2,3)
hist(Data(PreNewVtsd), 100);
line([th_v th_v], ylim, 'color', 'r', 'LineWidth', 3);

perimmob = sum(End(pre.ImmobEpoch)-Start(pre.ImmobEpoch))/sum(End(pre.AllAwakeEpochDB)-Start(pre.AllAwakeEpochDB))*100;
perlocom = sum(End(pre.LocomotionEpoch)-Start(pre.LocomotionEpoch))/sum(End(pre.AllAwakeEpochDB)-Start(pre.AllAwakeEpochDB))*100;

title(['PreTests' newline 'Immobility = ~', sprintf('%2.2f', perimmob), '% or ', sprintf('%2.2f', ov_dur*perimmob/100) 's',...
    ' , Locomotion = ~', sprintf('%3.3f',perlocom), '% or ', sprintf('%3.3f',ov_dur*perlocom/100) 's']);
xlabel('Speed (cm/s)');
ylabel('Counts');

clear pre

%% PostTest
post = load ([Dir_Post.path{1}{1} 'behavResources.mat'], 'Vtsd', 'Xtsd', 'ImmobEpoch', 'LocomotionEpoch', 'AllAwakeEpochDB');
if old
    PostNewVtsd = tsd(Range(post.Vtsd),(Data(post.Vtsd)./(diff(Range(post.Xtsd))/1E4))); 
else
    PostNewVtsd = tsd(Range(post.Vtsd),(Data(post.Vtsd))); 
end
PostNewVtsd = tsd(Range(PostNewVtsd),runmean(Data(PostNewVtsd),Smooth_camera));

subplot(2,2,4)
hist(Data(PostNewVtsd), 100);
line([th_v th_v], ylim, 'color', 'r', 'LineWidth', 3);

perimmob = sum(End(post.ImmobEpoch)-Start(post.ImmobEpoch))/sum(End(post.AllAwakeEpochDB)-Start(post.AllAwakeEpochDB))*100;
perlocom = sum(End(post.LocomotionEpoch)-Start(post.LocomotionEpoch))/sum(End(post.AllAwakeEpochDB)-Start(post.AllAwakeEpochDB))*100;

title(['PostTests' newline 'Immobility = ~', sprintf('%2.2f', perimmob), '% or ', sprintf('%2.2f', ov_dur*perimmob/100) 's',...
    ' , Locomotion = ~', sprintf('%3.3f',perlocom), '% or ', sprintf('%3.3f',ov_dur*perlocom/100) 's']);
xlabel('Speed (cm/s)');
ylabel('Counts');

%% Supertitle
mtit(fbilan, ['Mouse ' num2str(Mouse_to_analyze) ' SpeedDistribution'],'xoff', 0, 'yoff', 0.05, 'fontsize',16);

% Save Figure
saveas(fbilan, [dir_out fig_out '.fig']);
saveFigure(fbilan,fig_out,dir_out);

%% Clear all
clear