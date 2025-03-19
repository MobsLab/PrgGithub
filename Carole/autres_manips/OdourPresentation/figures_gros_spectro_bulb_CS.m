%%ouvre la figure
clear all;
mouse_num=829;
supertit = strcat('Mouse ',num2str(mouse_num));
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
%% load habituation

day_hab=20190306;
day_od=20190307;
% loads the LFP for habituation
path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/',num2str(day_hab));
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/',num2str(day_od));

cd(path_hab);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);

%% spectrogramme de toute la session
subplot(4,2,[1 2]);

% crée le spectre
[Sp,t,f]=LoadSpectrumML(channel,pwd,'low');

%affiche le spectre
imagesc(t, f, log(Sp'));
axis xy;
hold on;
%plot par dessus le digital odeur on
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
plot(Range(DigTSD,'s'),Data(DigTSD)*200, 'color','red');
title('control');
xlabel('time in s') ;
ylabel('frequence in Hz') ;
legend({'opening of the valve'});

%% power=f(frequence) pour les differentes conditions (moyenne sur toute la session, moyenne juste après ouverture, moyenne juste avant ouverture)
subplot(4,2,[5 7]);
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
%plot(f,mean(Spectsd), 'color', 'green')
%hold on
plot(f,mean(Data(Restrict(Spectsd,OdorEpoch))), 'color', 'green');
hold on;
plot(f,mean(Data(Restrict(Spectsd,NoOdorEpoch))), 'color', 'black');
%legend({'clean ON', 'clean OFF', 'odor ON', 'odor OFF'})
%title('10sec before and 30sec after opening')

%% average spectrogram
subplot(4,2,6);
is = intervalSet(ONTTL([1,2])-10*1e4, ONTTL([1,2])+30*1e4);
sweeps = intervalSplit(tsd(t*1e4,log(Sp)), is, 'OffsetStart', Start(is)*0);
ToAv = Data(sweeps{1});
for st = 2:length(ONTTL([1, 2]))-1
    ToAv = ToAv+Data(sweeps{st});
end
%AllSpec{((dd-1)/3)+1} = ToAv/length(StimTimes);

imagesc(-10:2:30,f,ToAv');
axis xy;
hold on;
vline(0);
title('control');

%% load odor
cd(path_od);
load('ChannelsToAnalyse/Bulb_deep.mat');
load(['LFPData/LFP',num2str(channel),'.mat']);

%% spectrogramme de toute la session
subplot(4,2,[3 4]);

[Sp,t,f]=LoadSpectrumML(channel,pwd,'low');
%affiche le spectre
imagesc(t,f,log(Sp'));
axis xy;
hold on;
%plot par dessus le digital odeur on

load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
plot(Range(DigTSD,'s'),Data(DigTSD)*200, 'color','red');
title('odor');
xlabel('time in s') ;
ylabel('frequence in Hz') ;
legend({'opening of the valve'});

%% power=f(frequence) pour les differentes conditions (moyenne sur toute la session, moyenne juste après ouverture, moyenne juste avant ouverture)
subplot(4,2,[5 7]);
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
%plot(f,mean(Spectsd), 'color', 'green')
%hold on
plot(f,mean(Data(Restrict(Spectsd,OdorEpoch))), 'color', 'red');
hold on
plot(f,mean(Data(Restrict(Spectsd,NoOdorEpoch))), 'color', 'blue');
legend({'clean ON', 'clean OFF', 'odor ON', 'odor OFF'});
title('10s before, 30s after opening');

%% average spectrogram
subplot(4,2,8);
is = intervalSet(ONTTL([1,2])-10*1e4, ONTTL([1,2])+30*1e4);
sweeps = intervalSplit(tsd(t*1e4,log(Sp)), is, 'OffsetStart', Start(is)*0);
ToAv = Data(sweeps{1});
for st = 2:length(ONTTL([1, 2]))-1
    ToAv = ToAv+Data(sweeps{st});
end
%AllSpec{((dd-1)/3)+1} = ToAv/length(StimTimes);

imagesc(-10:2:30,f,ToAv');
axis xy;
hold on;
vline(0);
title('odor');

%% sauver la figure
    mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

    % script name at bottom
    AddScriptName

