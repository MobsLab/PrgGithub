
%% load en fonction de la contition
% loads the LFP
clear all;
mouse_num=829;
day_hab=20190306;
day_od=20190307;
supertit = strcat('Mouse', num2str(mouse_num));
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
    si = 0;


path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));


%% spectrogramme des 6 essais, habituation
cd(path_hab);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);
subplot(2,2,1);

[Sp,t,f]=LoadSpectrumML(channel,pwd,'low');
% crée le spectre

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

cols = jet(length(Start(OdorEpoch)));


for k = 1:length(Start(OdorEpoch))
plot(f,mean(Data(Restrict(Spectsd,subset(OdorEpoch,k)))),'color',cols(7-k,:),'linewidth',2);
hold on;
end


%colormap jet
hold on;
% plot(Spectro{3},mean(Data(Restrict(Spectsd,NoOdorEpoch))), 'color', 'black')
plot(f,mean(Data(Restrict(Spectsd,baselineEpoch))), 'color', 'black','linewidth',2);
legend('trial 1','trial 2','trial 3','trial 4','trial 5','trial 6','baseline');
xlabel('freq');
ylabel('power');
title('control, spectro for each trial');


%% spectro 6 essais odor
cd(path_od);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);

subplot(2,2,2);

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
NoOdorEpoch = intervalSet(ONTTL-10*1e4,ONTTL);
baselineEpoch = intervalSet(ONTTL(1)-30*1e4,ONTTL(1));

% spectro tsd pour chaque essai

cols = jet(length(Start(OdorEpoch)));


for k = 1:length(Start(OdorEpoch))
plot(f,mean(Data(Restrict(Spectsd,subset(OdorEpoch,k)))),'color',cols(7-k,:),'linewidth',2);
hold on;
end
%colormap jet
hold on;
% plot(Spectro{3},mean(Data(Restrict(Spectsd,NoOdorEpoch))), 'color', 'black')
plot(f,mean(Data(Restrict(Spectsd,baselineEpoch))), 'color', 'black','linewidth',2);
xlabel('freq');
ylabel('power');
legend('trial 1','trial 2','trial 3','trial 4','trial 5','trial 6','baseline');
title('odor, spectro for each trial')

%% comparaison du power autour de 10HZ (8 et 12) hab
subplot(2,2,[3 4]);

% habituation

cd(path_hab)
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


%mean entre 8 et 12

trials_num=[1 2 3 4 5 6];
mean_power_on=[];
for k = 1:length(Start(OdorEpoch))
    power_complet=mean(Data(Restrict(Spectsd,subset(OdorEpoch,k))));
    power=[];
    for i=1:length(f)
        if f(i)> 8 & f(i)<12
            power=[power power_complet(i)];
        end
    end
    mean_power_on=[mean_power_on mean(power)];
end


power_complet=mean(Data(Restrict(Spectsd,subset(baselineEpoch,1))));
power=[];
for i=1:length(f)
    if f(i)> 8 & f(i)<12
        power=[power power_complet(i)];
    end
end
mean_power_baseline=mean(power);

scatter(trials_num, mean_power_on);
hold on;
hline(mean_power_baseline, 'k', 'baseline control');
hold on;

% odor

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


%mean entre 8 et 12

trials_num=[1 2 3 4 5 6];
mean_power_on=[];
for k = 1:length(Start(OdorEpoch))
    power_complet=mean(Data(Restrict(Spectsd,subset(OdorEpoch,k))));
    power=[];
    for i=1:length(f)
        if f(i)> 8 & f(i)<12
            power=[power power_complet(i)];
        end
    end
    mean_power_on=[mean_power_on mean(power)];
end


power_complet=mean(Data(Restrict(Spectsd,subset(baselineEpoch,1))));
power=[];
for i=1:length(f)
    if f(i)> 8 & f(i)<12
        power=[power power_complet(i)];
    end
end
mean_power_baseline=mean(power);

scatter(trials_num, mean_power_on);
hold on;
hline(mean_power_baseline, 'k', 'baseline odor');

legend({'clean on', 'odor on'});
title('mean power between 8 and 12Hz');
xlabel('trials');
ylabel('mean power');

%% finir figure
    mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

    % script name at bottom
    AddScriptName
