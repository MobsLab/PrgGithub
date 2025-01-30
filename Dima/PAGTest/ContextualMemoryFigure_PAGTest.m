%%% ContextualMemoryFigure_PAGTest
% 02.10.18 by Dima

%% Parameters


%% Load data
% Mouse 783
Day1A{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1C{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2C{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/11092018/ContextCTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Mouse 785
Day1A{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1C{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2C{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/11092018/ContextCTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Mouse 786
Day1A{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1C{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2C{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/10092018/ContextCTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Mouse 787
Day1A{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1C{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2C{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/11092018/ContextCTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Mouse 788
Day1A{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/ContextANeutral/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2A{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextATest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1B{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2B{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextBTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

Day1C{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
Day2C{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/10092018/ContextCTest/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

%% Calculate overall freezing

% Mouse 783
%Day1A
Epoch = intervalSet(Day1A{1}.TTLInfo.StopSession-180*1E4,Day1A{1}.TTLInfo.StopSession);
FreezeEpoch = and(Day1A{1}.FreezeAccEpoch,Epoch);
Freezing{1}(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{1}(1,1) = Freezing{1}(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day2A
Epoch = intervalSet(Day2A{1}.TTLInfo.StartSession,Day2A{1}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A{1}.FreezeAccEpoch,Epoch);
Freezing{1}(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{1}(1,2) = Freezing{1}(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B{1}.FreezeAccEpoch,Day1B{1}.TTLInfo.StimEpoch);
Freezing{1}(2,1) = sum(End(Day1B{1}.FreezeAccEpoch)-Start(Day1B{1}.FreezeAccEpoch))/1e4;
Freezingperc{1}(2,1) = Freezing{1}(2,1)/((Day1B{1}.TTLInfo.StopSession-Day1B{1}.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B{1}.TTLInfo.StartSession,Day2B{1}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B{1}.FreezeAccEpoch,Epoch);
Freezing{1}(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{1}(2,2) = Freezing{1}(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1C
FreezeEpoch = minus(Day1C{1}.FreezeAccEpoch,Day1C{1}.TTLInfo.StimEpoch);
Freezing{1}(3,1) = sum(End(Day1C{1}.FreezeAccEpoch)-Start(Day1C{1}.FreezeAccEpoch))/1e4;
Freezingperc{1}(3,1) = Freezing{1}(2,1)/((Day1C{1}.TTLInfo.StopSession-Day1C{1}.TTLInfo.StartSession)/1e4)*100;
%Day2C
Epoch = intervalSet(Day2C{1}.TTLInfo.StartSession,Day2C{1}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2C{1}.FreezeAccEpoch,Epoch);
Freezing{1}(3,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{1}(3,2) = Freezing{1}(3,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

% Mouse 785
%Day1A
Epoch = intervalSet(Day1A{2}.TTLInfo.StopSession-180*1E4,Day1A{2}.TTLInfo.StopSession);
FreezeEpoch = and(Day1A{2}.FreezeAccEpoch,Epoch);
Freezing{2}(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{2}(1,1) = Freezing{2}(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day2A
Epoch = intervalSet(Day2A{2}.TTLInfo.StartSession,Day2A{2}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A{2}.FreezeAccEpoch,Epoch);
Freezing{2}(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{2}(1,2) = Freezing{2}(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B{2}.FreezeAccEpoch,Day1B{2}.TTLInfo.StimEpoch);
Freezing{2}(2,1) = sum(End(Day1B{2}.FreezeAccEpoch)-Start(Day1B{2}.FreezeAccEpoch))/1e4;
Freezingperc{2}(2,1) = Freezing{2}(2,1)/((Day1B{2}.TTLInfo.StopSession-Day1B{2}.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B{2}.TTLInfo.StartSession,Day2B{2}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B{2}.FreezeAccEpoch,Epoch);
Freezing{2}(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{2}(2,2) = Freezing{2}(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1C
FreezeEpoch = minus(Day1C{2}.FreezeAccEpoch,Day1C{2}.TTLInfo.StimEpoch);
Freezing{2}(3,1) = sum(End(Day1C{2}.FreezeAccEpoch)-Start(Day1C{2}.FreezeAccEpoch))/1e4;
Freezingperc{2}(3,1) = Freezing{2}(3,1)/((Day1C{2}.TTLInfo.StopSession-Day1C{2}.TTLInfo.StartSession)/1e4)*100;
%Day2C
Epoch = intervalSet(Day2C{2}.TTLInfo.StartSession,Day2C{2}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2C{2}.FreezeAccEpoch,Epoch);
Freezing{2}(3,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{2}(3,2) = Freezing{2}(3,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

% Mouse 786
%Day1A
Epoch = intervalSet(Day1A{3}.TTLInfo.StopSession-180*1E4,Day1A{3}.TTLInfo.StopSession);
FreezeEpoch = and(Day1A{3}.FreezeAccEpoch,Epoch);
Freezing{3}(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{3}(1,1) = Freezing{3}(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day2A
Epoch = intervalSet(Day2A{3}.TTLInfo.StartSession,Day2A{3}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A{3}.FreezeAccEpoch,Epoch);
Freezing{3}(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{3}(1,2) = Freezing{3}(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B{3}.FreezeAccEpoch,Day1B{3}.TTLInfo.StimEpoch);
Freezing{3}(2,1) = sum(End(Day1B{3}.FreezeAccEpoch)-Start(Day1B{3}.FreezeAccEpoch))/1e4;
Freezingperc{3}(2,1) = Freezing{3}(2,1)/((Day1B{3}.TTLInfo.StopSession-Day1B{3}.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B{3}.TTLInfo.StartSession,Day2B{3}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B{3}.FreezeAccEpoch,Epoch);
Freezing{3}(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{3}(2,2) = Freezing{3}(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1C
FreezeEpoch = minus(Day1C{3}.FreezeAccEpoch,Day1C{3}.TTLInfo.StimEpoch);
Freezing{3}(3,1) = sum(End(Day1C{3}.FreezeAccEpoch)-Start(Day1C{3}.FreezeAccEpoch))/1e4;
Freezingperc{3}(3,1) = Freezing{3}(3,1)/((Day1C{3}.TTLInfo.StopSession-Day1C{3}.TTLInfo.StartSession)/1e4)*100;
%Day2C
Epoch = intervalSet(Day2C{3}.TTLInfo.StartSession,Day2C{3}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2C{3}.FreezeAccEpoch,Epoch);
Freezing{3}(3,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{3}(3,2) = Freezing{3}(3,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

% Mouse 787
%Day1A
Epoch = intervalSet(Day1A{4}.TTLInfo.StopSession-180*1E4,Day1A{4}.TTLInfo.StopSession);
FreezeEpoch = and(Day1A{4}.FreezeAccEpoch,Epoch);
Freezing{4}(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{4}(1,1) = Freezing{4}(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day2A
Epoch = intervalSet(Day2A{4}.TTLInfo.StartSession,Day2A{4}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A{4}.FreezeAccEpoch,Epoch);
Freezing{4}(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{4}(1,2) = Freezing{4}(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B{4}.FreezeAccEpoch,Day1B{4}.TTLInfo.StimEpoch);
Freezing{4}(2,1) = sum(End(Day1B{4}.FreezeAccEpoch)-Start(Day1B{4}.FreezeAccEpoch))/1e4;
Freezingperc{4}(2,1) = Freezing{4}(2,1)/((Day1B{4}.TTLInfo.StopSession-Day1B{4}.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B{4}.TTLInfo.StartSession,Day2B{4}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B{4}.FreezeAccEpoch,Epoch);
Freezing{4}(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{4}(2,2) = Freezing{4}(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1C
FreezeEpoch = minus(Day1C{4}.FreezeAccEpoch,Day1C{4}.TTLInfo.StimEpoch);
Freezing{4}(3,1) = sum(End(Day1C{4}.FreezeAccEpoch)-Start(Day1C{4}.FreezeAccEpoch))/1e4;
Freezingperc{4}(3,1) = Freezing{4}(3,1)/((Day1C{4}.TTLInfo.StopSession-Day1C{4}.TTLInfo.StartSession)/1e4)*100;
%Day2C
Epoch = intervalSet(Day2C{4}.TTLInfo.StartSession,Day2C{4}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2C{4}.FreezeAccEpoch,Epoch);
Freezing{4}(3,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{4}(3,2) = Freezing{4}(3,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

% Mouse 788
%Day1A
Freezing{5}(1,1) = NaN;
Freezingperc{5}(1,1) = NaN;
%Day2A
Epoch = intervalSet(Day2A{5}.TTLInfo.StartSession,Day2A{5}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2A{5}.FreezeAccEpoch,Epoch);
Freezing{5}(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{5}(1,2) = Freezing{5}(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1B
FreezeEpoch = minus(Day1B{5}.FreezeAccEpoch,Day1B{5}.TTLInfo.StimEpoch);
Freezing{5}(2,1) = sum(End(Day1B{5}.FreezeAccEpoch)-Start(Day1B{5}.FreezeAccEpoch))/1e4;
Freezingperc{5}(2,1) = Freezing{5}(2,1)/((Day1B{5}.TTLInfo.StopSession-Day1B{5}.TTLInfo.StartSession)/1e4)*100;
%Day2B
Epoch = intervalSet(Day2B{5}.TTLInfo.StartSession,Day2B{5}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2B{5}.FreezeAccEpoch,Epoch);
Freezing{5}(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{5}(2,2) = Freezing{5}(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
%Day1C
FreezeEpoch = minus(Day1C{5}.FreezeAccEpoch,Day1C{5}.TTLInfo.StimEpoch);
Freezing{5}(3,1) = sum(End(Day1C{5}.FreezeAccEpoch)-Start(Day1C{5}.FreezeAccEpoch))/1e4;
Freezingperc{5}(3,1) = Freezing{5}(3,1)/((Day1C{5}.TTLInfo.StopSession-Day1C{5}.TTLInfo.StartSession)/1e4)*100;
%Day2C
Epoch = intervalSet(Day2C{5}.TTLInfo.StartSession,Day2C{5}.TTLInfo.StartSession+180*1E4);
FreezeEpoch = and(Day2C{5}.FreezeAccEpoch,Epoch);
Freezing{5}(3,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
Freezingperc{5}(3,2) = Freezing{5}(3,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;

%% Calculate the average

for i=1:length(Freezingperc)
    FreezingBigMat(1:3, 1:2, i) = Freezingperc{i};
end

FreezingMean = nanmean(FreezingBigMat, 3);
FreezingStd = nanstd(FreezingBigMat,0, 3);

%% Plot
fratio = figure('units','normalized','outerposition',[0 0 0.5 1]);

subplot(511)
bar(Freezingperc{1});
set(gca,'Xtick',[1:3],'XtickLabel',{'ContextA (Neutral)', 'ContextB', 'ContextC'});
title('Mouse783');
ylabel('%Freezing');
ylim([0 100]);

lg = legend('Day1', 'Day2');

subplot(512)
bar(Freezingperc{2});
set(gca,'Xtick',[1:3],'XtickLabel',{'ContextA (Neutral)', 'ContextB', 'ContextC'});
title('Mouse785');
ylabel('%Freezing');
ylim([0 100]);

subplot(513)
bar(Freezingperc{3});
set(gca,'Xtick',[1:3],'XtickLabel',{'ContextA (Neutral)', 'ContextB', 'ContextC'});
title('Mouse786');
ylabel('%Freezing');
ylim([0 100]);

subplot(514)
bar(Freezingperc{4});
set(gca,'Xtick',[1:3],'XtickLabel',{'ContextA (Neutral)', 'ContextB', 'ContextC'});
title('Mouse787');
ylabel('%Freezing');
ylim([0 100]);

subplot(515)
bar(Freezingperc{5});
set(gca,'Xtick',[1:3],'XtickLabel',{'ContextA (Neutral)', 'ContextB', 'ContextC'});
title('Mouse788');
ylabel('%Freezing');
ylim([0 100]);

% Save figure
saveas(fratio, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/ContextualMemory_PAGTest.fig');
saveFigure(fratio,'ContextualMemory_PAGTest','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/');

%Supertitle
mtit(fratio, 'Contextual freezing: Day1 - shock or neutral; Day 2 - Test','xoff', 0, 'yoff', 0.03,'fontsize',16);

%% Plot average figure
fmean = figure('units', 'normalized', 'outerposition', [0 0 0.6 0.6]);

b = barwitherr(FreezingStd, FreezingMean);
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
for k = 1:3
	for s = 1:length(Day1A)
        plot(x(:,k),squeeze(FreezingBigMat(k, :, :)), '-ko', 'MarkerFaceColor','white');
	end
end
hold on
set(gca,'Xtick',[1:3],'XtickLabel',{'Context A (Neutral)', 'Context B (Aversive)', 'Context C (Aversive)'}, 'FontSize', 16);
ylabel('% Freezing', 'FontSize', 16)
hold off
box off
title('Percentage of freezing', 'FontSize', 16);
legend({'Day1', 'Day2'},'FontSize', 16);

%% Save figure
saveas(fmean, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/ContextualMemoryAverage_PAGTest.fig');
saveFigure(fmean,'ContextualMemoryAverage_PAGTest','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/');

saveas(fmean, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/ContextualMemoryAverage_PAGTest.fig');
saveFigure(fmean,'ContextualMemoryAverage_PAGTest','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/');
