Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise', 'SmoothGamma', 'SmoothTheta', 'Epoch','Info');
    REMEp{i}  = mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEp{i} = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    WakeEp{i} =  mergeCloseIntervals(WakeWiNoise,1E4);
    
    [Stim, StimREM{i}, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    
    % gamma and theta power : restrict to non-noisy epoch
    SmoothGammaNew{i} = Restrict(SmoothGamma,Epoch);
    SmoothThetaNew{i} = Restrict(SmoothTheta,Epoch);
    
    % gamma and theta power : subsample to same bins
    t{i} = Range(SmoothThetaNew{i});
    ti{i} = t{i}(5:1200:end);
    SmoothGammaNew{i} = (Restrict(SmoothGammaNew{i},ts(ti{i})));
    SmoothThetaNew{i} = (Restrict(SmoothThetaNew{i},ts(ti{i})));
    
    % REM
    SmoothThetaREM{i}  =  (Restrict(SmoothThetaNew{i},REMEp{i}));
    SmoothGammaREM{i}  =  Restrict(SmoothGammaNew{i},ts(Range(SmoothThetaREM{i})));
    % SWS
    SmoothThetaSWS{i}  =  (Restrict(SmoothThetaNew{i},SWSEp{i}));
    SmoothGammaSWS{i} = Restrict(SmoothGammaNew{i},ts(Range(SmoothThetaSWS{i})));
    % Wake
    SmoothThetaWake{i} = (Restrict(SmoothThetaNew{i},WakeEp{i}));
    SmoothGammaWake{i} = Restrict(SmoothGammaNew{i},ts(Range(SmoothThetaWake{i})));
    
    % calculate mean
    SmoothThetaSWS_mean(i,:) = nanmean(nanmean(Data(SmoothThetaSWS{i})));
    SmoothGammaSWS_mean(i,:) = nanmean(nanmean(Data(SmoothGammaSWS{i})));
    SmoothThetaREM_mean(i,:) = nanmean(nanmean(Data(SmoothThetaREM{i})));
    SmoothGammaREM_mean(i,:) = nanmean(nanmean(Data(SmoothGammaREM{i})));
    SmoothThetaWake_mean(i,:) = nanmean(nanmean(Data(SmoothThetaWake{i})));
    SmoothGammaWake_mean(i,:) = nanmean(nanmean(Data(SmoothGammaWake{i})));
    SmoothThetaNew_mean(i,:) = nanmean(nanmean(Data(SmoothThetaNew{i})));
    SmoothGammaNew_mean(i,:) = nanmean(nanmean(Data(SmoothGammaNew{i})));
end

%% figure

timePostStim = 10e4;

figure, hold on,
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    % plot pĥase space of brain state for every mice (normalized to re
    % align each phase space
    plot(log(Data(SmoothGammaSWS{i}))/log(SmoothGammaSWS_mean(i)),log(Data(SmoothThetaSWS{i}))/log(SmoothGammaSWS_mean(i)),'r.','MarkerSize',1);
    plot(log(Data(SmoothGammaREM{i}))/log(SmoothGammaSWS_mean(i)),log(Data(SmoothThetaREM{i}))/log(SmoothGammaSWS_mean(i)),'g.','MarkerSize',1);
    plot(log(Data(SmoothGammaWake{i}))/log(SmoothGammaSWS_mean(i)),log(Data(SmoothThetaWake{i}))/log(SmoothGammaSWS_mean(i)),'b.','MarkerSize',1);
    
    xlabel('SmoothGamma')
    ylabel('SmoothTheta')
    ylim([-0.2 0.6])
    xlim([0.9 1.5])
end

for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    % plot dots for each stim
    plot(log(Data(Restrict(SmoothGammaREM{1},StimREM{1}(1))))/log(SmoothGammaSWS_mean(1)),...
        log(Data(Restrict(SmoothThetaREM{1},StimREM{1}(1))))/log(SmoothGammaSWS_mean(1)),'ko','linewidth',1,'markerfacecolor',[0 0 0])
    % add dots corresponding to the brain state x sec after the stim (cf param timePostStim)
    plot(log(Data(Restrict(SmoothGammaNew{i},StimREM{i}+timePostStim)))/log(SmoothGammaSWS_mean(i)),...
        log(Data(Restrict(SmoothThetaNew{i},StimREM{i}+timePostStim)))/log(SmoothGammaSWS_mean(i)),'ko','linewidth',2,'markerfacecolor',[1 1 1])

%   % starting point coordinates
    x1{i} = 1;
    y1{i} = 0.3;
    % ending points coordinates (state after x sec after the stim)
    x2{i} = log(Data(Restrict(SmoothGammaNew{i},StimREM{i}+timePostStim)))/log(SmoothGammaSWS_mean(i));
    y2{i} = log(Data(Restrict(SmoothThetaNew{i},StimREM{i}+timePostStim)))/log(SmoothGammaSWS_mean(i));
    
    for a=1:length(StimREM{i}) % add lines between the starting point and ending points
        plot([x1{i} x2{i}(a)], [y1{i} y2{i}(a)],'k-', 'color', [0.7 0.7 0.7],'linewidth',0.02)
        
    end
end


%% figure (draft version non normalisée)
% timePostStim = 15e4;
% % timePostStim = [5e4, 10e4, 15e4,20e4];
% 
% figure, hold on,
% for i=1:length(Dir{1}.path)
%     cd(Dir{1}.path{i}{1});
% 
% % plot(log(Data(SmoothGammaREM{i})),log(Data(SmoothThetaREM{i})),'g.','MarkerSize',1);
% % plot(log(Data(SmoothGammaSWS{i})),log(Data(SmoothThetaSWS{i})),'r.','MarkerSize',1);
% % plot(log(Data(SmoothGammaWake{i})),log(Data(SmoothThetaWake{i})),'b.','MarkerSize',1);
% xlabel('SmoothGamma')
% ylabel('SmoothTheta')
% 
% plot(log(Data(Restrict(SmoothGammaNew{1},StimREM{1}(1)))),log(Data(Restrict(SmoothThetaNew{1},StimREM{1}(1)))),'ko','linewidth',1,'markerfacecolor',[0 0 0])
% % for i = 1:length(timePostStim)
% plot(log(Data(Restrict(SmoothGammaNew{i},StimREM{i}+timePostStim))),log(Data(Restrict(SmoothThetaNew{i},StimREM{i}+timePostStim))),'ko','linewidth',2,'markerfacecolor',[1 1 1])
% %     pause(0)
% % end
% 
% x1{i} = log(Data(Restrict(SmoothGammaNew{1},StimREM{1}(1))));
% y1{i} = log(Data(Restrict(SmoothThetaNew{1},StimREM{1}(1))));
% 
% x2{i} = log(Data(Restrict(SmoothGammaNew{i},StimREM{i}+timePostStim)));
% y2{i} = log(Data(Restrict(SmoothThetaNew{i},StimREM{i}+timePostStim)));
% 
% 
% for a=1:length(StimREM{i})
%     plot([x1{i} x2{i}(a)], [y1{i} y2{i}(a)],'k-', 'color', [0.7 0.7 0.7])
%     
% end
% end
