% TODO: accelerometer
StartleIdxs = cell(1,10);

%% Figure
figure('units','normalized','outerposition',[0 0 1 1]);

%% Mouse 783 (tentelively, anterior dlPAG)

% Load data
Intensities{1} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-4V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-5V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{1} = zeros(1,length(Intensities{1}));

% Upload
for i=1:length(Intensities{1})
    StartleIdxs{1}(i) = F{i}.StartleIndex;
end

% Plot
subplot(521)
plot(Intensities{1}, StartleIdxs{1}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGant ContextB');

clear F

%% Mouse 783 (tentelively, posterior dlPAG)

% Load data
Intensities{2} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-4V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-5V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-6V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{2} = zeros(1,length(Intensities{2}));

% Upload
for i=1:length(Intensities{2})
    StartleIdxs{2}(i) = F{i}.StartleIndex;
end

% Plot
subplot(522)
plot(Intensities{2}, StartleIdxs{2}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGpost ContextC');

clear F

%% Mouse 785 (tentelively, anterior dlPAG)

% Load data
Intensities{3} = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3.5V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4.5V/behavResources.mat','StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-5V/behavResources.mat','StartleIndex');
F{12} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-6V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{3} = zeros(1,length(Intensities{3}));

% Upload
for i=1:length(Intensities{3})
    StartleIdxs{3}(i) = F{i}.StartleIndex;
end

% Plot
subplot(523)
plot(Intensities{3}, StartleIdxs{3}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGant ContextC');

clear F

%% Mouse 785 (tentelively, posterior dlPAG)

% Load data
Intensities{4} = [0 0.5 1 1.5 2 2.5 3];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-3V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{4} = zeros(1,length(Intensities{4}));

% Upload
for i=1:length(Intensities{4})
    StartleIdxs{4}(i) = F{i}.StartleIndex;
end

% Plot
subplot(524)
plot(Intensities{4}, StartleIdxs{4}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGpost ContextB');

clear F

%% Mouse 786 (tentelively, anterior vlPAG)

% Load data
Intensities{5} = [0 0.5 1 1.5 2 2.5 3 3.5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3.5V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{5} = zeros(1,length(Intensities{5}));

% Upload
for i=1:length(Intensities{5})
    StartleIdxs{5}(i) = F{i}.StartleIndex;
end

% Plot
subplot(525)
plot(Intensities{5}, StartleIdxs{5}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGant ContextB');

clear F

%% Mouse 786 (tentelively, posterior vlPAG)

% Load data
Intensities{6} = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3.5V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4.5V/behavResources.mat','StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-5V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{6} = zeros(1,length(Intensities{6}));

% Upload
for i=1:length(Intensities{6})
    StartleIdxs{6}(i) = F{i}.StartleIndex;
end

% Plot
subplot(526)
plot(Intensities{6}, StartleIdxs{6}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGpost ContextC');

clear F

%% Mouse 787 (tentelively, anterior vlPAG)

% Load data
Intensities{7} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-4V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-5V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{7} = zeros(1,length(Intensities{7}));

% Upload
for i=1:length(Intensities{7})
    StartleIdxs{7}(i) = F{i}.StartleIndex;
end

% Plot
subplot(527)
plot(Intensities{7}, StartleIdxs{7}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGant ContextC');

clear F

%% Mouse 787 (tentelively, posterior vlPAG)

% Load data
Intensities{8} = [0 0.5 1 1.5 2];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{8} = zeros(1,length(Intensities{8}));

% Upload
for i=1:length(Intensities{8})
    StartleIdxs{8}(i) = F{i}.StartleIndex;
end

% Plot
subplot(528)
plot(Intensities{8}, StartleIdxs{8}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGpost ContextB');

clear F

%% Mouse 788 (tentelively, anterior dmPAG)

% Load data
Intensities{9} = [0 0.5 1 1.5 2 2.5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{9} = zeros(1,length(Intensities{9}));

% Upload
for i=1:length(Intensities{9})
    StartleIdxs{9}(i) = F{i}.StartleIndex;
end

% Plot
subplot(529)
plot(Intensities{9}, StartleIdxs{9}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 788 - ??dmPAGant ContextB');

clear F

%% Mouse 788 (tentelively, posterior dmPAG)

% Load data
Intensities{10} = [0 0.5 1 1.5 2 2.5 3 4 5 6 8];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0V/behavResources.mat','StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0.5V/behavResources.mat','StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1V/behavResources.mat','StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1.5V/behavResources.mat','StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2V/behavResources.mat','StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2.5V/behavResources.mat','StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-3V/behavResources.mat','StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-4V/behavResources.mat','StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-5V/behavResources.mat','StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-6V/behavResources.mat','StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/behavResources.mat','StartleIndex');

% Allocate space
StartleIdxs{10} = zeros(1,length(Intensities{10}));

% Upload
for i=1:length(Intensities{10})
    StartleIdxs{10}(i) = F{i}.StartleIndex;
end

% Plot
subplot(5,2,10)
plot(Intensities{10}, StartleIdxs{10}, '-ko');
ylabel('Startle index');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
title('Mouse 788 - ??dmPAGant ContextC');

clear F

%% Supertitle
mtit('Startle Index','xoff', 0, 'yoff', 0.03,'fontsize',16);