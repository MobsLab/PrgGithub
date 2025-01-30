%%% CondFreezingCurve
% TODO: accelerometer
Freezingperc = cell(1,10);
Intensities = cell(1,10);
FreezingBeforeratio = cell(1,10);
FreezingAfterratio = cell(1,10);
FreezingRatio = cell(1,10);
StartleIdxs = cell(1,10);

%% Figure
figure('units','normalized','outerposition',[0 0 1 1]);

%% Mouse 783 (tentelively, anterior dlPAG)

% Load data
Intensities{1} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{1}));
Freezingperc{1} = zeros(1,length(Intensities{1}));
FreezingBeforeratio{1} = zeros(1,length(Intensities{1}));
FreezingAfterratio{1} = zeros(1,length(Intensities{1}));
FreezingRatio{1} = zeros(1,length(Intensities{1}));
FreezingBeforeRatioSingleShot{1} = zeros(1,length(Intensities{1}));
FreezingAfterRatioSingleShot{1} = zeros(1,length(Intensities{1}));
StartleIdxs{1} = zeros(1,length(Intensities{1}));

% Calculate
for i=1:length(Intensities{1})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{1}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{1}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{1}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{1}(i) = FreezingAfterratio{1}(i)/FreezingBeforeratio{1}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{1}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{1}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{1}(i) = F{i}.StartleIndex;
end

% Plot
subplot(521)
plot(Intensities{1}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGant ContextB');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 783 (tentelively, posterior dlPAG)

% Load data
Intensities{2} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{2}));
Freezingperc{2} = zeros(1,length(Intensities{2}));
FreezingBeforeratio{2} = zeros(1,length(Intensities{2}));
FreezingAfterratio{2} = zeros(1,length(Intensities{2}));
FreezingRatio{2} = zeros(1,length(Intensities{2}));
FreezingBeforeRatioSingleShot{2} = zeros(1,length(Intensities{2}));
FreezingAfterRatioSingleShot{2} = zeros(1,length(Intensities{2}));
StartleIdxs{2} = zeros(1,length(Intensities{2}));

% Calculate
for i=1:length(Intensities{2})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{2}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{2}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{2}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{2}(i) = FreezingAfterratio{2}(i)/FreezingBeforeratio{2}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{2}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{2}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{2}(i) = F{i}.StartleIndex;
end

% Plot
subplot(522)
plot(Intensities{2}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGpost ContextC');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 785 (tentelively, anterior dlPAG)

% Load data
Intensities{3} = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{12} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{3}));
Freezingperc{3} = zeros(1,length(Intensities{3}));
FreezingBeforeratio{3} = zeros(1,length(Intensities{3}));
FreezingAfterratio{3} = zeros(1,length(Intensities{3}));
FreezingRatio{3} = zeros(1,length(Intensities{3}));
FreezingBeforeRatioSingleShot{3} = zeros(1,length(Intensities{3}));
FreezingAfterRatioSingleShot{3} = zeros(1,length(Intensities{3}));
StartleIdxs{3} = zeros(1,length(Intensities{3}));

% Calculate
for i=1:length(Intensities{3})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{3}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{3}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{3}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{3}(i) = FreezingAfterratio{3}(i)/FreezingBeforeratio{3}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{3}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{3}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{3}(i) = F{i}.StartleIndex;
end

% Plot
subplot(523)
plot(Intensities{3}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGant ContextC');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 785 (tentelively, posterior dlPAG)

% Load data
Intensities{4} = [0 0.5 1 1.5 2 2.5 3];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{4}));
Freezingperc{4} = zeros(1,length(Intensities{4}));
FreezingBeforeratio{4} = zeros(1,length(Intensities{4}));
FreezingAfterratio{4} = zeros(1,length(Intensities{4}));
FreezingRatio{4} = zeros(1,length(Intensities{4}));
FreezingBeforeRatioSingleShot{4} = zeros(1,length(Intensities{4}));
FreezingAfterRatioSingleShot{4} = zeros(1,length(Intensities{4}));
StartleIdxs{4} = zeros(1,length(Intensities{4}));

% Calculate
for i=1:length(Intensities{4})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{4}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{4}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{4}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{4}(i) = FreezingAfterratio{4}(i)/FreezingBeforeratio{4}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{4}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{4}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{4}(i) = F{i}.StartleIndex;
end

% Plot
subplot(524)
plot(Intensities{4}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGpost ContextB');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 786 (tentelively, anterior vlPAG)

% Load data
Intensities{5} = [0 0.5 1 1.5 2 2.5 3 3.5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{5}));
Freezingperc{5} = zeros(1,length(Intensities{5}));
FreezingBeforeratio{5} = zeros(1,length(Intensities{5}));
FreezingAfterratio{5} = zeros(1,length(Intensities{5}));
FreezingRatio{5} = zeros(1,length(Intensities{5}));
FreezingBeforeRatioSingleShot{5} = zeros(1,length(Intensities{5}));
FreezingAfterRatioSingleShot{5} = zeros(1,length(Intensities{5}));
StartleIdxs{5} = zeros(1,length(Intensities{5}));

% Calculate
for i=1:length(Intensities{5})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{5}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{5}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{5}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{5}(i) = FreezingAfterratio{5}(i)/FreezingBeforeratio{5}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{5}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{5}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{5}(i) = F{i}.StartleIndex;
end

% Plot
subplot(525)
plot(Intensities{5}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGant ContextB');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 786 (tentelively, posterior vlPAG)

% Load data
Intensities{6} = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{6}));
Freezingperc{6} = zeros(1,length(Intensities{6}));
FreezingBeforeratio{6} = zeros(1,length(Intensities{6}));
FreezingAfterratio{6} = zeros(1,length(Intensities{6}));
FreezingRatio{6} = zeros(1,length(Intensities{6}));
FreezingBeforeRatioSingleShot{6} = zeros(1,length(Intensities{6}));
FreezingAfterRatioSingleShot{6} = zeros(1,length(Intensities{6}));
StartleIdxs{6} = zeros(1,length(Intensities{6}));

% Calculate
for i=1:length(Intensities{6})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{6}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{6}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{6}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{6}(i) = FreezingAfterratio{6}(i)/FreezingBeforeratio{6}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{6}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{6}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{6}(i) = F{i}.StartleIndex;
end

% Plot
subplot(526)
plot(Intensities{6}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGpost ContextC');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 787 (tentelively, anterior vlPAG)

% Load data
Intensities{7} = [0 0.5 1 1.5 2 2.5 3 4 5 6];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{7}));
Freezingperc{7} = zeros(1,length(Intensities{7}));
FreezingBeforeratio{7} = zeros(1,length(Intensities{7}));
FreezingAfterratio{7} = zeros(1,length(Intensities{7}));
FreezingRatio{7} = zeros(1,length(Intensities{7}));
FreezingBeforeRatioSingleShot{7} = zeros(1,length(Intensities{7}));
FreezingAfterRatioSingleShot{7} = zeros(1,length(Intensities{7}));
StartleIdxs{7} = zeros(1,length(Intensities{7}));

% Calculate
for i=1:length(Intensities{7})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{7}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{7}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{7}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{7}(i) = FreezingAfterratio{7}(i)/FreezingBeforeratio{7}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{7}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{7}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{7}(i) = F{i}.StartleIndex;
end

% Plot
subplot(527)
plot(Intensities{7}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGant ContextC');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 787 (tentelively, posterior vlPAG)

% Load data
Intensities{8} = [0 0.5 1 1.5 2];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{8}));
Freezingperc{8} = zeros(1,length(Intensities{8}));
FreezingBeforeratio{8} = zeros(1,length(Intensities{8}));
FreezingAfterratio{8} = zeros(1,length(Intensities{8}));
FreezingRatio{8} = zeros(1,length(Intensities{8}));
FreezingBeforeRatioSingleShot{8} = zeros(1,length(Intensities{8}));
FreezingAfterRatioSingleShot{8} = zeros(1,length(Intensities{8}));
StartleIdxs{8} = zeros(1,length(Intensities{8}));

% Calculate
for i=1:length(Intensities{8})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{8}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{8}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{8}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{8}(i) = FreezingAfterratio{8}(i)/FreezingBeforeratio{8}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{8}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{8}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{8}(i) = F{i}.StartleIndex;
end

% Plot
subplot(528)
plot(Intensities{8}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGpost ContextB');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 788 (tentelively, anterior dmPAG)

% Load data
Intensities{9} = [0 0.5 1 1.5 2 2.5];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{9}));
Freezingperc{9} = zeros(1,length(Intensities{9}));
FreezingBeforeratio{9} = zeros(1,length(Intensities{9}));
FreezingAfterratio{9} = zeros(1,length(Intensities{9}));
FreezingRatio{9} = zeros(1,length(Intensities{9}));
FreezingBeforeRatioSingleShot{9} = zeros(1,length(Intensities{9}));
FreezingAfterRatioSingleShot{9} = zeros(1,length(Intensities{9}));
StartleIdxs{9} = zeros(1,length(Intensities{9}));

% Calculate
for i=1:length(Intensities{9})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{9}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{9}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{9}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{9}(i) = FreezingAfterratio{9}(i)/FreezingBeforeratio{9}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{9}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{9}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{9}(i) = F{i}.StartleIndex;
end

% Plot
subplot(529)
plot(Intensities{9}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 788 - ??dmPAGant ContextB');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Mouse 788 (tentelively, posterior dmPAG)

% Load data
Intensities{10} = [0 0.5 1 1.5 2 2.5 3 4 5 6 8];
F{1} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{2} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{3} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{4} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-1.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{5} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{6} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2.5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{7} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-3V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{8} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-4V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{9} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-5V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{10} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-6V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
F{11} = load('/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/behavResources.mat','FreezeAccEpoch', 'TTLInfo', 'StartleIndex');

% Allocate space
Freezing = zeros(1,length(Intensities{10}));
Freezingperc{10} = zeros(1,length(Intensities{10}));
FreezingBeforeratio{10} = zeros(1,length(Intensities{10}));
FreezingAfterratio{10} = zeros(1,length(Intensities{10}));
FreezingRatio{10} = zeros(1,length(Intensities{10}));
FreezingBeforeRatioSingleShot{10} = zeros(1,length(Intensities{10}));
FreezingAfterRatioSingleShot{10} = zeros(1,length(Intensities{10}));
StartleIdxs{10} = zeros(1,length(Intensities{10}));

% Calculate
for i=1:length(Intensities{10})
    FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
    Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
    Freezingperc{10}(i) = Freezing(i)/180*100;
    
    A = Start(F{i}.TTLInfo.StimEpoch);
    BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
    lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
    AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
    lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
    AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
    BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
    AfterSingleShot = intervalSet(A(1),A(1)+10e4);
    len=10;
    
    
    FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
    FreezingBeforeratio{10}(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
    FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
    FreezingAfterratio{10}(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
    FreezingRatio{10}(i) = FreezingAfterratio{10}(i)/FreezingBeforeratio{10}(i);
    
    FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
    FreezingBeforeRatioSingleShot{10}(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
    FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
    FreezingAfterRatioSingleShot{10}(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
    
    StartleIdxs{10}(i) = F{i}.StartleIndex;
end

% Plot
subplot(5,2,10)
plot(Intensities{10}, Freezing, '-ko');
ylabel('Freezing in sec');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
title('Mouse 788 - ??dmPAGant ContextC');

clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter

%% Supertitle
mtit('Freezing during calibration','xoff', 0, 'yoff', 0.03,'fontsize',16);

%% Figure percentage
fperc = figure('units','normalized','outerposition',[0 0 1 1]);

% Mouse 783 - antPAG
subplot(521)
plot(Intensities{1}, Freezingperc{1}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 783 - ??dlPAGant ContextB');

% Mouse 783 - postPAG
subplot(522)
plot(Intensities{2}, Freezingperc{2}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 783 - ??dlPAGpost ContextC');

% Mouse 785 - antPAG
subplot(523)
plot(Intensities{3}, Freezingperc{3}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 785 - ??dlPAGant ContextC');

% Mouse 785 - postPAG
subplot(524)
plot(Intensities{4}, Freezingperc{4}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 785 - ??dlPAGpost ContextB');

% Mouse 786 - antPAG
subplot(525)
plot(Intensities{5}, Freezingperc{5}, '-ko');
ylabel('%Freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 786 - ??vlPAGant ContextB');

% Mouse 786 - postPAG
subplot(526)
plot(Intensities{6}, Freezingperc{6}, '-ko');
ylabel('%Freezing');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 786 - ??dlPAGpost ContextC');

% Mouse 787 - antPAG
subplot(527)
plot(Intensities{7}, Freezingperc{7}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 787 - ??dlPAGant ContextC');

% Mouse 787 - postPAG
subplot(528)
plot(Intensities{8}, Freezingperc{8}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 787 - ??dlPAGpost ContextB');

% Mouse 788 - antPAG
subplot(529)
plot(Intensities{9}, Freezingperc{9}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 95]);
title('Mouse 788 - ??dlPAGant ContextB');

% Mouse 788 - postPAG
subplot(5,2,10)
plot(Intensities{10}, Freezingperc{10}, '-ko');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
ylim([0 95]);
title('Mouse 788 - ??dlPAGpost ContextC');

%% Figure ratio
fratio = figure('units','normalized','outerposition',[0 0 1 1]);

% Mouse 783 - antPAG
subplot(521)
plot(Intensities{1}, FreezingBeforeratio{1}, '-ko');
hold on
plot(Intensities{1}, FreezingAfterratio{1}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 783 - ??dlPAGant ContextB');

% Mouse 783 - postPAG
subplot(522)
plot(Intensities{2}, FreezingBeforeratio{2}, '-ko');
hold on
plot(Intensities{2}, FreezingAfterratio{2}, '-ro');
legend('BeforeStim','AfterStim');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 783 - ??dlPAGpost ContextC');

% Mouse 785 - antPAG
subplot(523)
plot(Intensities{3}, FreezingBeforeratio{3}, '-ko');
hold on
plot(Intensities{3}, FreezingAfterratio{3}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 785 - ??dlPAGant ContextC');

% Mouse 785 - postPAG
subplot(524)
plot(Intensities{4}, FreezingBeforeratio{4}, '-ko');
hold on
plot(Intensities{4}, FreezingAfterratio{4}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 785 - ??dlPAGpost ContextB');

% Mouse 786 - antPAG
subplot(525)
plot(Intensities{5}, FreezingBeforeratio{5}, '-ko');
hold on
plot(Intensities{5}, FreezingAfterratio{5}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 786 - ??vlPAGant ContextB');

% Mouse 786 - postPAG
subplot(526)
plot(Intensities{6}, FreezingBeforeratio{6}, '-ko');
hold on
plot(Intensities{6}, FreezingAfterratio{6}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 786 - ??vlPAGpost ContextC');

% Mouse 787 - antPAG
subplot(527)
plot(Intensities{7}, FreezingBeforeratio{7}, '-ko');
hold on
plot(Intensities{7}, FreezingAfterratio{7}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 787 - ??vlPAGant ContextC');

% Mouse 787 - postPAG
subplot(528)
plot(Intensities{8}, FreezingBeforeratio{8}, '-ko');
hold on
plot(Intensities{8}, FreezingAfterratio{8}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 787 - ??vlPAGpost ContextB');

% Mouse 788 - antPAG
subplot(529)
plot(Intensities{9}, FreezingBeforeratio{9}, '-ko');
hold on
plot(Intensities{9}, FreezingAfterratio{9}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 788 - ??dmPAGant ContextB');

% Mouse 788 - postPAG
subplot(5,2,10)
plot(Intensities{10}, FreezingBeforeratio{10}, '-ko');
hold on
plot(Intensities{10}, FreezingAfterratio{10}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
ylim([0 1.1]);
title('Mouse 788 - ??dmPAGpost ContextC');

%% Supertitle
mtit('Freezing during calibration','xoff', 0, 'yoff', 0.03,'fontsize',16);


%% Save figure
% saveas(fratio, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/CondFreezingCurve.fig');
% saveFigure(fratio,'CalibFreezingCurve','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/');

%% Figure ratio
frationew = figure('units','normalized','outerposition',[0 0 1 1]);

% Mouse 783 - antPAG
subplot(521)
plot(Intensities{1}, FreezingBeforeRatioSingleShot{1}, '-ko');
hold on
plot(Intensities{1}, FreezingAfterRatioSingleShot{1}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 783 - ??dlPAGant ContextB');

% Mouse 783 - postPAG
subplot(522)
plot(Intensities{2}, FreezingBeforeRatioSingleShot{2}, '-ko');
hold on
plot(Intensities{2}, FreezingAfterRatioSingleShot{2}, '-ro');
legend('BeforeStim','AfterStim');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 783 - ??dlPAGpost ContextC');

% Mouse 785 - antPAG
subplot(523)
plot(Intensities{3}, FreezingBeforeRatioSingleShot{3}, '-ko');
hold on
plot(Intensities{3}, FreezingAfterRatioSingleShot{3}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 785 - ??dlPAGant ContextC');

% Mouse 785 - postPAG
subplot(524)
plot(Intensities{4}, FreezingBeforeRatioSingleShot{4}, '-ko');
hold on
plot(Intensities{4}, FreezingAfterRatioSingleShot{4}, '-ro');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 785 - ??dlPAGpost ContextB');

% Mouse 786 - antPAG
subplot(525)
plot(Intensities{5}, FreezingBeforeRatioSingleShot{5}, '-ko');
hold on
plot(Intensities{5}, FreezingAfterRatioSingleShot{5}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 786 - ??vlPAGant ContextB');

% Mouse 786 - postPAG
subplot(526)
plot(Intensities{6}, FreezingBeforeRatioSingleShot{6}, '-ko');
hold on
plot(Intensities{6}, FreezingAfterRatioSingleShot{6}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 786 - ??vlPAGpost ContextC');

% Mouse 787 - antPAG
subplot(527)
plot(Intensities{7}, FreezingBeforeRatioSingleShot{7}, '-ko');
hold on
plot(Intensities{7}, FreezingAfterRatioSingleShot{7}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 787 - ??vlPAGant ContextC');

% Mouse 787 - postPAG
subplot(528)
plot(Intensities{8}, FreezingBeforeRatioSingleShot{8}, '-ko');
hold on
plot(Intensities{8}, FreezingAfterRatioSingleShot{8}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 787 - ??vlPAGpost ContextB');

% Mouse 788 - antPAG
subplot(529)
plot(Intensities{9}, FreezingBeforeRatioSingleShot{9}, '-ko');
hold on
plot(Intensities{9}, FreezingAfterRatioSingleShot{9}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
ylim([0 1.1]);
title('Mouse 788 - ??dmPAGant ContextB');

% Mouse 788 - postPAG
subplot(5,2,10)
plot(Intensities{10}, FreezingBeforeRatioSingleShot{10}, '-ko');
hold on
plot(Intensities{10}, FreezingAfterRatioSingleShot{10}, '-ro');
ylabel('FreezingRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
ylim([0 1.1]);
title('Mouse 788 - ??dmPAGpost ContextC');

%% Supertitle
mtit('Freezing during calibration - Single Shot','xoff', 0, 'yoff', 0.03,'fontsize',16);

%% Save figure
% saveas(frationew, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/CondFreezingCurve_Stim1.fig');
% saveFigure(frationew,'CalibFreezingCurve_Stim1','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/');

%% Final figure with everything
fsuper = figure('units','normalized','outerposition',[0 0 1 1]);

% Mouse 783 - antPAG
subplot(521)
yyaxis left
plot(Intensities{1}, Freezingperc{1}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{1}, FreezingBeforeRatioSingleShot{1}*100, 'b--o');
hold on
plot(Intensities{1}, FreezingAfterRatioSingleShot{1}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{1}, StartleIdxs{1}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGant ContextB');

% Mouse 783 - postPAG
subplot(522)
yyaxis left
plot(Intensities{2}, Freezingperc{2}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{2}, FreezingBeforeRatioSingleShot{2}*100, 'b--o');
hold on
plot(Intensities{2}, FreezingAfterRatioSingleShot{2}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{2}, StartleIdxs{2}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 783 - ??dlPAGpost ContextC');

% Mouse 785 - antPAG
subplot(523)
yyaxis left
plot(Intensities{3}, Freezingperc{3}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{3}, FreezingBeforeRatioSingleShot{3}*100, 'b--o');
hold on
plot(Intensities{3}, FreezingAfterRatioSingleShot{3}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{3}, StartleIdxs{3}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGant ContextC');

% Mouse 785 - postPAG
subplot(524)
yyaxis left
plot(Intensities{4}, Freezingperc{4}, '-ko', 'LineWidth', 2);
hold on
h1 = plot(Intensities{4}, FreezingBeforeRatioSingleShot{4}*100, 'b--o');
hold on
h2 = plot(Intensities{4}, FreezingAfterRatioSingleShot{4}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
h3 = plot(Intensities{4}, StartleIdxs{4}, '-mo');
set(gca, 'YColor', 'm');
legend([h1 h2 h3], 'BeforeStim','AfterStim', 'StartleRatio');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 785 - ??dlPAGpost ContextB');

% Mouse 786 - antPAG
subplot(525)
yyaxis left
plot(Intensities{5}, Freezingperc{5}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{5}, FreezingBeforeRatioSingleShot{5}*100, 'b--o');
hold on
plot(Intensities{5}, FreezingAfterRatioSingleShot{5}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
ylabel('%Freezing');
yyaxis right
plot(Intensities{5}, StartleIdxs{5}, '-mo');
set(gca, 'YColor', 'm');
ylabel('StartleIndex');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGant ContextB');

% Mouse 786 - postPAG
subplot(526)
yyaxis left
plot(Intensities{6}, Freezingperc{6}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{6}, FreezingBeforeRatioSingleShot{6}*100, 'b--o');
hold on
plot(Intensities{6}, FreezingAfterRatioSingleShot{6}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
ylabel('%Freezing');
yyaxis right
plot(Intensities{6}, StartleIdxs{6}, '-mo');
set(gca, 'YColor', 'm');
ylabel('StartleIndex');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 786 - ??vlPAGpost ContextC');

% Mouse 787 - antPAG
subplot(527)
yyaxis left
plot(Intensities{7}, Freezingperc{7}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{7}, FreezingBeforeRatioSingleShot{7}*100, 'b--o');
hold on
plot(Intensities{7}, FreezingAfterRatioSingleShot{7}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{7}, StartleIdxs{7}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGant ContextC');

% Mouse 787 - postPAG
subplot(528)
yyaxis left
plot(Intensities{8}, Freezingperc{8}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{8}, FreezingBeforeRatioSingleShot{8}*100, 'b--o');
hold on
plot(Intensities{8}, FreezingAfterRatioSingleShot{8}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{8}, StartleIdxs{8}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 787 - ??vlPAGpost ContextB');

% Mouse 788 - antPAG
subplot(529)
yyaxis left
plot(Intensities{9}, Freezingperc{9}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{9}, FreezingBeforeRatioSingleShot{9}*100, 'b--o');
hold on
plot(Intensities{9}, FreezingAfterRatioSingleShot{9}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{9}, StartleIdxs{9}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 6.5]);
title('Mouse 788 - ??dmPAGant ContextB');

% Mouse 788 - postPAG
subplot(5,2,10)
yyaxis left
plot(Intensities{10}, Freezingperc{10}, '-ko', 'LineWidth', 2);
hold on
plot(Intensities{10}, FreezingBeforeRatioSingleShot{10}*100, 'b--o');
hold on
plot(Intensities{10}, FreezingAfterRatioSingleShot{10}*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities{10}, StartleIdxs{10}, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
title('Mouse 788 - ??dmPAGpost ContextC');

%% Supertitle
mtit('Freezing during calibration + Startle Index ','xoff', 0, 'yoff', 0.03,'fontsize',16);

%% Save figure
% saveas(fsuper, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/CalibratonFreezingStartle.fig');
% saveFigure(fsuper,'CalibratonFreezingStartle','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/');


figure('units', 'normalized', 'outerposition', [0 1 0.7 0.5]);
yyaxis left
h1 = plot(Intensities{8}, Freezingperc{8}, '-ko', 'LineWidth', 3);
hold on
h2 = plot(Intensities{8}, FreezingBeforeRatioSingleShot{8}*100, 'b--o', 'LineWidth', 2);
hold on
h3 = plot(Intensities{8}, FreezingAfterRatioSingleShot{8}*100, 'r--o', 'LineWidth', 2);
ylim([0 100]);
set(gca, 'YColor', 'k', 'FontWeight', 'bold', 'FontSize', 13);
ylabel('%Freezing');
yyaxis right
h4 = plot(Intensities{8}, StartleIdxs{8}/1.67, 'Marker', 'o', 'Color', [0 0.5 0], 'LineWidth', 3);
ylabel('ActivityIndex');
ylim([0 60]);
set(gca, 'YColor', [0 0.5 0]);
xlabel('Intensities in V');
set(gca, 'FontSize',13, 'FontWeight', 'bold');
xlim([0 8.5]);
legend([h1 h2 h3 h4], 'OverallFreezing', 'BeforeStim', 'AfterStim', 'ActivityIndex');
title('Type2 Calibration response');

saveas(gcf, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/Examples/AccTriggStim_noresponse.fig');
saveFigure(gcf,'AccTriggStim_noresponse','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/Examples/');

%% Clear
clear