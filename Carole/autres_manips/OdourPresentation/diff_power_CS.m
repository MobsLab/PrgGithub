figure
%% load en fonction de la contition
% loads the LFP
clear all;
mouse_num=829;
day_hab=20190306;
day_od=20190307;
path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));


%% diff power habituation
cd(path_hab);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);
[Sp,t,f]=LoadSpectrumML(channel,pwd,'low');


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

% make spectro tsd avant ouverture vs apres ouverture + mean
Spectsd = tsd(t*1e4,log(Sp));
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);
baselineEpoch = intervalSet(ONTTL(1)-30*1e4,ONTTL(1));
% spectro tsd pour chaque essai
trials=[1 2 3 4 5 6];
mean_diff=[];
%sd_diff=[]
for k = 1:length(Start(OdorEpoch))
    diff_complet=mean(Data(Restrict(Spectsd,subset(OdorEpoch,k))))-mean(Data(Restrict(Spectsd,subset(NoOdorEpoch,k))));
    diff=[];
    for i=1:length(f)
        if f(i)> 8 & f(i)<12
            diff=[diff diff_complet(i)];
        end
    end
    
    mean_diff=[mean_diff mean(diff)];
    %sd_diff=[sd_diff sd(diff)]
end


scatter(trials,mean_diff);
hold on;


%% diff power odor
cd(path_od);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);
[Sp,t,f]=LoadSpectrumML(channel,pwd,'low');

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

% make spectro tsd avant ouverture vs apres ouverture + mean
Spectsd = tsd(t*1e4,log(Sp));
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);
baselineEpoch = intervalSet(ONTTL(1)-30*1e4,ONTTL(1));
% spectro tsd pour chaque essai
trials=[1 2 3 4 5 6];
mean_diff=[];
%sd_diff=[]
for k = 1:length(Start(OdorEpoch))
    diff_complet=mean(Data(Restrict(Spectsd,subset(OdorEpoch,k))))-mean(Data(Restrict(Spectsd,subset(NoOdorEpoch,k))));
    diff=[];
    for i=1:length(f)
        if f(i)> 8 & f(i)<12
            diff=[diff diff_complet(i)];
        end
    end
    
    mean_diff=[mean_diff mean(diff)];
    %sd_diff=[sd_diff sd(diff)]
end


scatter(trials,mean_diff);
hold on;
legend('control','odor');
title(strcat('mouse ', num2str(mouse_num), ', increase of power between 8 and 12Hz after valve opening'))
xlabel('trials')
ylabel('diff of power before and after opening')
