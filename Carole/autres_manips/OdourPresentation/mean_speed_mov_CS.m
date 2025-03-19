
Mice=[777, 779, 796, 829, 849, 850, 851];

%% que la premiere fois
% Mice_diff_speed_hab=[];
% Mice_diff_speed_od=[];
% Mice_diff_mov_hab=[];
% Mice_diff_mov_od=[];


%% que la premiere fois encore
% Mat_mov_first_trial=zeros(length(Mice),2);
% Mat_speed_first_trial=zeros(length(Mice),2);
% 
% Mat_all_trial=zeros(length(Mice),2);

%% load en fonction de la contition
% loads the LFP
mouse_num=851;
if ismember(mouse_num, [777, 849, 850, 851])
    day_hab=20190221;
    day_od=20190222;
else
    day_hab=20190306;
    day_od=20190307;
end
trials=[1 2 3 4 5 6];

supertit = strcat('mouse',num2str(mouse_num));
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
%% mov/speed hab
%load
path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));
cd(path_hab);
% find odor onset
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
ONEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
ONTTL = Start(ONEpoch);
% find odor offset
OdorOffChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorOFF')));
load(['LFPData/DigInfo',num2str(OdorOffChannel),'.mat']);
OFFEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
OFFTTL = Start(OFFEpoch);
load('behavResources.mat');

%% 30 sec before and after
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);
subplot(1,2,1);
% movement;
diff=[];
for k=1:length(ONTTL);
    diff=[diff mean(Data(Restrict(MovAcctsd,subset(OdorEpoch,k))))-mean(Data(Restrict(MovAcctsd,subset(NoOdorEpoch,k))))];

end
Mice_diff_mov_hab=[Mice_diff_mov_hab ; diff];
rank_mouse=find(Mice==mouse_num);
Mat_mov_first_trial(rank_mouse,1)=diff(1);
Mat_mov_all_trial(rank_mouse,1)=mean(diff);
scatter(trials, diff);
hold on
subplot(1,2,2);
%speed
diff=[];
for k=1:length(ONTTL);
    diff=[diff mean(Data(Restrict(Vtsd,subset(OdorEpoch,k))))-mean(Data(Restrict(Vtsd,subset(NoOdorEpoch,k))))];

end
Mice_diff_speed_hab=[Mice_diff_speed_hab ; diff];
rank_mouse=find(Mice==mouse_num);
Mat_speed_first_trial(rank_mouse,1)=diff(1);
Mat_speed_all_trial(rank_mouse,1)=mean(diff);
scatter(trials, diff);
hold on

%% mov speed odor
cd(path_od);
% find odor onset
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
ONEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
ONTTL = Start(ONEpoch);
% find odor offset
OdorOffChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorOFF')));
load(['LFPData/DigInfo',num2str(OdorOffChannel),'.mat']);
OFFEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
OFFTTL = Start(OFFEpoch);
load('behavResources.mat');

%% 30 sec before and after
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);
subplot(1,2,1);
% movement
diff=[];
for k=1:length(ONTTL);
    diff=[diff mean(Data(Restrict(MovAcctsd,subset(OdorEpoch,k))))-mean(Data(Restrict(MovAcctsd,subset(NoOdorEpoch,k))))];

end
Mice_diff_mov_od=[Mice_diff_mov_od ; diff];
rank_mouse=find(Mice==mouse_num);
Mat_mov_first_trial(rank_mouse,2)=diff(1);
Mat_mov_all_trial(rank_mouse,2)=mean(diff);
scatter(trials, diff);
hold on
title('movement, 30sec after - before opening');
legend({'control', 'odor'});
subplot(1,2,2);
%speed
diff=[];
for k=1:length(ONTTL);
    diff=[diff mean(Data(Restrict(Vtsd,subset(OdorEpoch,k))))-mean(Data(Restrict(Vtsd,subset(NoOdorEpoch,k))))];

end
Mice_diff_speed_od=[Mice_diff_speed_od ; diff];
rank_mouse=find(Mice==mouse_num);
Mat_speed_first_trial(rank_mouse,2)=diff(1);
Mat_speed_all_trial(rank_mouse,2)=mean(diff);
scatter(trials, diff);
hold on
title('speed, 30sec after - before opening');
legend({'control', 'odor'});

  % Supertitle
    mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

    % script name at bottom
    AddScriptName
    
%% only last time
Mice=[1 2 3 4 5 6 7]
figure
%movement
subplot(1,2,1)
for k=1:length(trials)
    if k==1
        size=30
    else
        size=10
    end
    scatter(Mice,Mice_diff_mov_hab(:, k),size,'b')
    hold on
    scatter(Mice,Mice_diff_mov_od(:, k),size,'r')
    hold on
end
legend({'control', 'odor'})
xlabel('Mice')
ylabel('Diff')
title('difference of movement before and after opening')
%speed
subplot(1,2,2)
for k=1:length(trials)
    if k==1
        size=30
    else
        size=10
    end
    scatter(Mice,Mice_diff_speed_hab(:, k),size,'b')
    hold on
    scatter(Mice,Mice_diff_speed_od(:, k),size,'r')
    hold on
end
legend({'control', 'odor'})
xlabel('Mice')
ylabel('Diff')
title('difference of movement before and after opening')

%% error bar

PlotErrorBarN_KJ(Mat_mov_first_trial)
set(gca,'xticklabel',{'','','control','','odor','',''})
title('difference of movement during the 1st trial')

PlotErrorBarN_KJ(Mat_speed_first_trial)
set(gca,'xticklabel',{'','','control','','odor','',''})
title('difference of speed during the 1st trial')

PlotErrorBarN_KJ(Mat_mov_all_trial)
set(gca,'xticklabel',{'','','control','','odor','',''})
title('difference of movement during all the trials')

PlotErrorBarN_KJ(Mat_speed_all_trial)
set(gca,'xticklabel',{'','','control','','odor','',''})
title('difference of speed during all the trials')