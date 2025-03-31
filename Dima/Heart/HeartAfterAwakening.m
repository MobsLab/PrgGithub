%% HeartAfterWakening
% Get path - Sophie
Dir = PathForExperimentsEmbReact('BaselineSleep');
Dir = RemoveElementsFromDir(Dir,'nmouse', [404 425 430 431 436 437 438 439 444 445 469 470 471 483 484 485 490 507 508 ...
    509 510 512 514 561 566 568 689]); % Left - 567 569 688 739 740 750

% Allocate memory
HR = cell(1,sum(cellfun(@(x) numel(x),Dir.path)));
HRsm = cell(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHR = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRWake = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRSWS = zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
OverallHRREM= zeros(1,sum(cellfun(@(x) numel(x),Dir.path)));
a=1;

% Load or calculate the data
for i=1:length(Dir.path)
    for j=1:length(Dir.path{i})
        cd(Dir.path{i}{j});   
        % Heart
        HR{a} = load([Dir.path{i}{j} 'HeartBeatInfo.mat'], 'EKG');
        % StateEpoch
        StateEpoch{a} = load([Dir.path{i}{j} 'StateEpochSB.mat'], 'Wake', 'SWSEpoch', 'REMEpoch');
        a=a+1;
    end
end

% Smooth the data a bit
for i=1:length(HR)
    HRsm{i} = tsd(Range(HR{i}.EKG.HBRate), runmean(Data(HR{i}.EKG.HBRate), 3));
end


% Calculate the heart beat
for i=1:length(HR)
    % Overall
    OverallHR(i) = mean(Data(HR{i}.EKG.HBRate));
    %         OverallHRstd{i}{j} = std(Data(HR{i}{j}.HBRate));
    
    % OverallWake
    OverallHRWake(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,StateEpoch{i}.Wake)));
    %         OverallHRWakestd{i}{j} = std(Data(Restrict(HR{i}{j}.HBRate,StateEpoch{i}{j}.Wake)));
    
    %OverallSWS
    OverallHRSWS(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,StateEpoch{i}.SWSEpoch)));
    
    %OverallNREM
    OverallHRREM(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,StateEpoch{i}.REMEpoch)));
    
    % AfterSleepEpoch
    SleepEpoch{i} = or(StateEpoch{i}.SWSEpoch, StateEpoch{i}.REMEpoch);
    [After{i}, Before] = transEpoch(StateEpoch{i}.Wake, SleepEpoch{i});
    WakeAfterSleepEpoch{i} = After{i}{1,2};
    WakeAfterSleepEpoch{i} = dropShortIntervals(WakeAfterSleepEpoch{i}, 100*1E4);
    clear After Before
    
    % Create first ten minutes of wake
    WakeFirst{i} = subset(StateEpoch{i}.Wake,1);
    WakeFirst10{i} = intervalSet(Start(WakeFirst{i}),Start(WakeFirst{i})+600*1E4);
    
%     % Create last 10 min of sleep
%     SleepEpochLengths{i} = End(StateEpoch{i}.Wake)-Start(StateEpoch{i}.Wake);
%     a=(SleepEpochLengths{i}(end));
%     b = length(SleepEpochLengths{i});
%     while a < 600*1e4
%         a=a+SleepEpochLengths{i}(b-1);
%         b=b-1;
%     end
%     WakeLast10{i} = subset(StateEpoch{i}.Wake, [b+1:SleepEpochLengths{i}]);
%     d = sum(End(WakeLast10{i})-Start(WakeLast10{i}));
    
    
    % WakeAfterSleepStages
    [After{i}, Before{i}] = transEpoch(StateEpoch{i}.Wake, StateEpoch{i}.SWSEpoch);
    WakeAfterSWS{i} = After{i}{1,2};
    clear After Before
    [After{i}, Before{i}] = transEpoch(StateEpoch{i}.Wake, StateEpoch{i}.REMEpoch);
    WakeAfterREM{i} = After{i}{1,2};
    clear After Before
    
    % Restrict to awake after sleep
    HRWakeAfterSleepAll(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,WakeAfterSleepEpoch{i})));
    
    % Restrict to last 3 Awakening sessions
    for j=1:length(Start(WakeAfterSleepEpoch{i}))
        HRWakeAfterSleepEpochs{i}(j) = mean(Data(Restrict(HR{i}.EKG.HBRate,subset(WakeAfterSleepEpoch{i},j))));
        HRWakeAfterSleepEpochsStd{i}(j) = std(Data(Restrict(HR{i}.EKG.HBRate,subset(WakeAfterSleepEpoch{i},j))));
    end
    
    % Restrict to WakeAfTerSleepStages
    HBWakeAfterSWS(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,WakeAfterSWS{i})));
    HBWakeAfterREM(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,WakeAfterREM{i})));
    
    % Restrict to Wake first
    HRWakeFirst10(i) = mean(Data(Restrict(HR{i}.EKG.HBRate,WakeFirst10{i})));
    
    % Restrict to HR last
    HRWake{i} = Restrict(HR{i}.EKG.HBRate,StateEpoch{i}.Wake);
    
    
end

% Average
OverallHRMean = mean(OverallHR);
OverallHRSTD = std(OverallHR);

OverallHRWakeMean = mean(OverallHRWake);
OverallHRWakeSTD = std(OverallHRWake);

OverallHRSWSMean = mean(OverallHRSWS);
OverallHRSWSSTD = std(OverallHRSWS);

OverallHRREMMean = mean(OverallHRREM);
OverallHRREMSTD = std(OverallHRREM);

HRWakeAfterSleepAllMean = mean(HRWakeAfterSleepAll);
HRWakeAfterSleepAllSTD = std(HRWakeAfterSleepAll);

HRWakeFirst10Mean = mean(HRWakeFirst10);
HRWakeFirst10STD = std(HRWakeFirst10);

HBWakeAfterSWSMean = nanmean(HBWakeAfterSWS);
HBWakeAfterSWSSTD = nanstd(HBWakeAfterSWS);

HBWakeAfterREMMean = nanmean(HBWakeAfterREM);
HBWakeAfterREMSTD = nanstd(HBWakeAfterREM);

for i=1:length(HRWakeAfterSleepEpochs)
    HRWakeAfterSleepEpochsMean{i} = mean(HRWakeAfterSleepEpochs{i});
    HRWakeAfterSleepEpochsSTD{i} = std(HRWakeAfterSleepEpochs{i});
end

% Plot
figure('units', 'normalized','outerposition', [0 0 1 0.5]);
% bar([OverallHRMean OverallHRWakeMean HRWakeFirst10Mean OverallHRSWSMean OverallHRREMMean HRWakeAfterSleepAllMean],...
%     'FaceColor',  [0 0 0], 'LineWidth',3);
 [p,h,her] = PlotErrorBarN_DB([OverallHR; OverallHRWake; HRWakeFirst10; OverallHRSWS; OverallHRREM; HRWakeAfterSleepAll]',...
     'barcolors', [0 0 0],'newfig', 0, 'ShowSigstar', 'none');
% hold on
% errorbar([OverallHRMean OverallHRWakeMean HRWakeFirst10Mean OverallHRSWSMean OverallHRREMMean HRWakeAfterSleepAllMean],...
%     [OverallHRSTD OverallHRWakeSTD HRWakeFirst10STD OverallHRSWSSTD OverallHRREMSTD HRWakeAfterSleepAllSTD], '.', 'Color', 'k');
% hold on
set(gca,'Xtick',[1:6],'XtickLabel',{'TotalMean', 'Wake', 'First 10min of Wake' 'Non-REM', 'REM', 'WakeAfterSleep'},...
    'FontWeight', 'bold', 'FontSize', 16);
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Heart rate (Hz)', 'FontSize', 16);
title('Heart rate during sleep', 'FontSize', 16)

for i=1:length(HRWakeAfterSleepEpochsMean)
    figure('units', 'normalized','outerposition', [0 0 1 0.4]);
    bar([HRWakeFirst10Mean 0 0 HRWakeAfterSleepEpochs{i}], 'FaceColor', [0 0.4 0.4]);
    hold on
    errorbar([HRWakeFirst10Mean 0 0 HRWakeAfterSleepEpochs{i}],[HRWakeFirst10STD 0 0 HRWakeAfterSleepEpochsStd{i}],...
        '.', 'Color', 'r');
    set(gca,'Xtick', [1:3],'XtickLabel',{'First10min', '', ''}, 'FontSize', 16);
%     set(gca,'Xtick',[4:length(HRWakeAfterSleepEpochs{i})+3],'XtickLabel',{sprintfc('%d',[1:length(HRWakeAfterSleepEpochs{i})])},...
%         'FontSize', 16);
    xlabel('Number of WakeAfterSleep Epoch', 'FontSize', 16);
    ylabel('HeartRate (Hz)', 'FontSize', 16);
%     title(Dir.path{i}{1});
end
    
    
    