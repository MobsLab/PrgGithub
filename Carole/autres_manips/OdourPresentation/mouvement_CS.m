figure
%% load en fonction de la contition
% loads the LFP
clear all
mice_nums=[779, 796, 829];

day_hab=20190306;
day_od=20190307;
mice_cols=['rkbg'];

%% mov hab
subplot(2,2,1);
for k=1:length(mice_nums)
%load
mouse_num=mice_nums(k);
mouse_col=mice_cols(k);
path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
cd(path_hab);

% find odor onset
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
ONEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
ONTTL = Start(ONEpoch);

% find odor offset
OdorOffChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorOFF')));
load(['LFPData/DigInfo',num2str(OdorOffChannel),'.mat'])
OFFEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
OFFTTL = Start(OFFEpoch);

load('behavResources.mat');
% movement
SmooAcctsd = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),4));
[M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,30000,0,0);

%imagesc(T)
%imagesc(zscore(T))
%plot(T)
%plot(T')
%size(M)
% M :   time, mean, std, stdError
% T :   matrix
%plot(M(:,1),T')
%hold on
plot(M(:,1),M(:,2)', 'color', mouse_col);
hold on

%hold on
%plot(M(:,1),M(:,3)', 'color', 'red', 'linewidth',2)
%hold on
%plot(M(:,1),M(:,4)', 'color', 'black', 'linewidth',2)

% speed
% [M,T]=PlotRipRaw(Vtsd,ONTTL/1e4,10000,0,0)
% plot(M(:,1),M(:,2)', 'color', mouse_col, 'linestyle',':')
% hold on
% leg=[leg strcat('Speed ', num2str(mouse_num))]
end
legend({'779', '796', '829'});
vline(0);
title('Movement, Control');

%% speed hab
subplot(2,2,3);
for k=1:length(mice_nums)
%load
mouse_num=mice_nums(k);
mouse_col=mice_cols(k);
path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
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
% movement
% SmooAcctsd = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),4));
% [M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,10000,0,0);

%imagesc(T)
%imagesc(zscore(T))
%plot(T)
%plot(T')
%size(M)
% M :   time, mean, std, stdError
% T :   matrix
%plot(M(:,1),T')
%hold on
% plot(M(:,1),M(:,2)', 'color', mouse_col)
% hold on
%hold on
%plot(M(:,1),M(:,3)', 'color', 'red', 'linewidth',2)
%hold on
%plot(M(:,1),M(:,4)', 'color', 'black', 'linewidth',2)

% speed
SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),4));
%[M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,30000,0,0);
[M,T]=PlotRipRaw(SmooVtsd,ONTTL/1e4,30000,0,0);
plot(M(:,1),M(:,2)', 'color', mouse_col);
hold on

end
legend({'779', '796', '829'});
vline(0);
title('Speed, Control');

%% movement odor
subplot(2,2,2);
for k=1:length(mice_nums)
%load
mouse_num=mice_nums(k);
mouse_col=mice_cols(k);
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));
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
% movement
SmooAcctsd = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),4));
[M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,30000,0,0);

%imagesc(T)
%imagesc(zscore(T))
%plot(T)
%plot(T')legend({'777', '849', '850', '851'})
%size(M)
% M :   time, mean, std, stdError
% T :   matrix
%plot(M(:,1),T')
%hold on
plot(M(:,1),M(:,2)', 'color', mouse_col);
hold on
%hold on
%plot(M(:,1),M(:,3)', 'color', 'red', 'linewidth',2)
%hold on
%plot(M(:,1),M(:,4)', 'color', 'black', 'linewidth',2)

% speed
% [M,T]=PlotRipRaw(Vtsd,ONTTL/1e4,10000,0,0)
% plot(M(:,1),M(:,2)', 'color', mouse_col, 'linestyle', ':')
% hold on
end
title('Movement, Odor');
vline(0);
legend({'779', '796', '829'});
%% speed odor
subplot(2,2,4);
for k=1:length(mice_nums)
%load
mouse_num=mice_nums(k);
mouse_col=mice_cols(k);
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));
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
% movement
% SmooAcctsd = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),4));
% [M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,10000,0,0);
% 
% %imagesc(T)
%imagesc(zscore(T))
%plot(T)
%plot(T')
%size(M)
% M :   time, mean, std, stdError
% T :   matrix
%plot(M(:,1),T')
%hold on
% plot(M(:,1),M(:,2)', 'color', mouse_col)
% hold on
% 

%hold on
%plot(M(:,1),M(:,3)', 'color', 'red', 'linewidth',2)
%hold on
%plot(M(:,1),M(:,4)', 'color', 'black', 'linewidth',2)

% speed
SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),4));
%[M,T]=PlotRipRaw(SmooAcctsd,ONTTL/1e4,30000,0,0);
[M,T]=PlotRipRaw(SmooVtsd,ONTTL/1e4,30000,0,0);
plot(M(:,1),M(:,2)', 'color', mouse_col);
hold on;

end
title('Speed, Odor');
vline(0);
legend({'779', '796', '829'})