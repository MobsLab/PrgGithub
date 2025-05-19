function MakeSleepScoringFigure_VeroniqueData_CorrectREM(SleepScoringFigure,Epoch,sptsdH,EMGData,SmoothThetaNew,...
    REMEpoch,SWSEpoch,Wake,fH,Info,EEG)

% colors for plotting
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'c';
Colors.Noise = [0 0 0];
% get caxis lims
CMax.HPC = max(max(Data(Restrict(sptsdH,Epoch))))*1.05;
CMin.HPC = min(min(Data(Restrict(sptsdH,Epoch))))*0.95;


figure(SleepScoringFigure), clf
begin = Start(Epoch,'h');
endin = Stop(Epoch,'h');

sptsdH_ep = Restrict(sptsdH,Epoch);
SmoothThetaNew_ep = Restrict(SmoothThetaNew,Epoch);
EMGData_ep = Restrict(EMGData,Epoch);
REMEpoch_ep = and(REMEpoch,Epoch);
SWSEpoch_ep = and(SWSEpoch,Epoch);
Wake_ep = and(Wake,Epoch);
EEG_ep = Restrict(EEG,Epoch);

% HPC spectrum
subplot(5,1,1)
imagesc(Range(sptsdH_ep)/3600e4,fH,10*log10(Data(sptsdH_ep))'), axis xy, caxis(10*log10([CMin.HPC CMax.HPC]))
hold on
xlim([begin endin])
set(gca,'XTick',[])
title('HPC')


% Theta/delta ratio
subplot(5,1,2), hold on
plot(Range(SmoothThetaNew_ep)/3600e4, Data(SmoothThetaNew_ep), 'linewidth',1, 'color','k')

line([begin endin], [Info.theta_thresh Info.theta_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])

xlim([begin endin]),
title('Theta/Delta ratio')
set(gca,'XTick',[])

% Movement
subplot(5,1,3), hold off
plot(Range(EMGData_ep)/3600e4, Data(EMGData_ep), 'linewidth',1, 'color','k')
line([begin endin], [Info.EMG_thresh Info.EMG_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
xlim([begin endin]),
title('Movement - log')
set(gca,'YScale','log')

subplot(5,1,4), hold off
plot(Range(EMGData_ep)/3600e4, Data(EMGData_ep), 'linewidth',1, 'color','k')
line([begin endin], [Info.EMG_thresh Info.EMG_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
xlim([begin endin]),
title('Movement - linear')

subplot(5,1,5), hold off
plot(Range(EEG_ep)/3600e4, Data(EEG_ep), 'linewidth',1, 'color','k')
xlim([begin endin]),
title('EEG raw')
samexaxis


% Lines to indicate epochs
for i=2:5
    subplot(5,1,i), hold on
    
    if i == 2
        plot(Range(SmoothThetaNew_ep)/3600e4, Data(SmoothThetaNew_ep), 'linewidth',1, 'color','k')
        try
            line([begin endin], [Info.theta_thresh Info.theta_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
        catch
            load('StateEpochSB','Info')
            line([begin endin], [Info.theta_thresh Info.theta_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
        end
        xlim([begin endin]),
        title('Theta/Delta ratio')
        set(gca,'XTick',[])
        
    elseif i == 3
        plot(Range(EMGData_ep)/3600e4, Data(EMGData_ep), 'linewidth',1, 'color','k')
        line([begin endin], [Info.EMG_thresh Info.EMG_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
        xlim([begin endin]),
        title('Movement')
    end
    yl=ylim;
    LineHeight = yl(2);
    line([begin endin], [LineHeight LineHeight], 'linewidth',10, 'color','w')
    
    
    PlotPerAsLine(REMEpoch_ep, LineHeight, Colors.REM, 'timescaling', 3600e4, 'linewidth',10);
    PlotPerAsLine(SWSEpoch_ep, LineHeight, Colors.SWS, 'timescaling', 3600e4, 'linewidth',10);
    PlotPerAsLine(Wake_ep, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
    
end