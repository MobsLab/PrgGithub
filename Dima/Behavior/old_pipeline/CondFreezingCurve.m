%%% CondFreezingCurve
% TODO: accelerometer
Freezingperc = cell(1,5);
Intensities = cell(1,5);

%% Figure
figure('units','normalized','outerposition',[0 0 1 1]);

%% Mouse 711

% Load data
Intensities{1} = [0 0.5 1 1.5 2 2.5];
F{1} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{2} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-0,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{3} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{4} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-1,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{5} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{6} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-2,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Allocate space
Freezing = zeros(1,length(Intensities{1}));
Freezingperc{1} = zeros(1,length(Intensities{1}));

% Calculate
for i=1:length(Intensities{1})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{1}(i) = Freezing(i)/180*100;
end

% Plot
subplot(321)
plot(Intensities{1}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
title('Mouse 711');

%% Mouse 712

% Load data
Intensities{2} = [0 0.5 1 1.5 2 2.5 3];
F{1} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{2} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-0,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{3} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{4} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-1,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{5} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{6} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-2,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{7} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/11042018/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Allocate space
Freezing = zeros(1,length(Intensities{2}));
Freezingperc{2} = zeros(1,length(Intensities{2}));

% Calculate
for i=1:length(Intensities{2})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{2}(i) = Freezing(i)/180*100;
end

% Plot
subplot(322)
plot(Intensities{2}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3.5]);
title('Mouse 712');

%% Mouse 714

% Load data
Intensities{3} = [0 0.5 1 1.5 2 2.5 3];
F{1} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{2} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_0,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{3} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{4} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_1,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{5} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{6} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_2,5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{7} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/26022018/Calibration/Calibration_3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Allocate space
Freezing = zeros(1,length(Intensities{3}));
Freezingperc{3} = zeros(1,length(Intensities{3}));

% Calculate
for i=1:length(Intensities{3})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{3}(i) = Freezing(i)/180*100;
end

% Plot
subplot(323)
plot(Intensities{3}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3.5]);
title('Mouse 714');

%% Mouse 742 - doesn't have digital channels

% Load data
Intensities{4} = [0 0.5 1 1.5 2 2.5 3];
F{1} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-0V/behavResources.mat','FreezeAccEpoch');
F{2} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-0,5V/behavResources.mat','FreezeAccEpoch');
F{3} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-1V/behavResources.mat','FreezeAccEpoch');
F{4} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-1,5V/behavResources.mat','FreezeAccEpoch');
F{5} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-2V/behavResources.mat','FreezeAccEpoch');
F{6} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-2,5V/behavResources.mat','FreezeAccEpoch');
F{7} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/30052018/Calib/Calib-3V/behavResources.mat','FreezeAccEpoch');

% Allocate space
Freezing = zeros(1,length(Intensities{4}));
Freezingperc{4} = zeros(1,length(Intensities{4}));

% Calculate
for i=1:length(Intensities{4})
%     FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch); 
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{4}(i) = Freezing(i)/180*100;
end

% Plot
subplot(324)
plot(Intensities{4}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3.5]);
title('Mouse 742');

%% Mouse 753

% Load data
Intensities{5} = [0 0.5 1 1.5 2 2.5];
F{1} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{2} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-05V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{3} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{4} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-15V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{5} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');
F{6} = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-25V/behavResources.mat','FreezeAccEpoch', 'TTLInfo');

% Allocate space
Freezing = zeros(1,length(Intensities{5}));
Freezingperc{5} = zeros(1,length(Intensities{5}));

% Calculate
for i=1:length(Intensities{5})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{5}(i) = Freezing(i)/180*100;
end

% Plot
subplot(325)
plot(Intensities{5}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
title('Mouse 753');

%% Supertitle
mtit('Freezing during calibration','xoff', 0, 'yoff', 0.03,'fontsize',16);

%% Figure percentage
fbilan = figure('units','normalized','outerposition',[0 0 1 1]);

% Mouse 711
subplot(321)
plot(Intensities{1}, Freezingperc{1}, '-ko');
ylabel('Percentage of freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
ylim([0 95]);
title('Mouse 711');

% Mouse 712
subplot(322)  
plot(Intensities{2}, Freezingperc{2}, '-ko');
ylabel('Percentage of freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
ylim([0 95]);
title('Mouse 712');

% Mouse 714
subplot(323)
plot(Intensities{3}, Freezingperc{3}, '-ko');
ylabel('Percentage of freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
ylim([0 95]);
title('Mouse 714');

% Mouse 742
subplot(324)
plot(Intensities{4}, Freezingperc{4}, '-ko');
ylabel('Percentage of freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
ylim([0 95]);
title('Mouse 742');

% Mouse 753
subplot(325)
plot(Intensities{5}, Freezingperc{5}, '-ko');
ylabel('Percentage of freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 3]);
ylim([0 95]);
title('Mouse 753');

%% Save figure
saveas(fbilan, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/CondFreezingCurve.fig');
saveFigure(fbilan,'CondFreezingCurve','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/');

%% Clear
clear