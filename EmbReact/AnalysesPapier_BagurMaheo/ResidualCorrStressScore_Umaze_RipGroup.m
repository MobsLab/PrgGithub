clear all
load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions_BM.mat')
Group=[7 8];
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Path{group}{mouse} = CondSess.(Mouse_names{mouse});
    end
end

clear Respi LinPos FreezeEpoch Spec_Clean Spec
for group = 1:2
    for mouse = 1:length(Path{group})
        
        Spec_Clean{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_vHC_Clean_Low');
        Spec{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_Low');
        FreezeEpoch{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'epoch','epochname','freezeepoch');
        LinPos{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'linpos_sampetps');
        Respi{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'respi_freq_bm_clean');
       end
end



%%
LimResp =4.5;
for group = 1:2
    Mouse=Drugs_Groups_UMaze_BM(Group(group));

    for mouse = 1:length(Path{group})
        
        SafeFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.6,'Direction','Above'));
        ShockFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.4,'Direction','Below'));
        
        CleanSpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},SafeFreeze))));
        CleanSpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},ShockFreeze))));
        
        DirtySpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,SafeFreeze)))));
        DirtySpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,ShockFreeze)))));
        
       
        X = Data(Restrict(Respi{group}{mouse},FreezeEpoch{group}{mouse}));
        X(X<2) = NaN;
%         X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)),'linear');

        dt = median(diff(Range(Respi{group}{mouse},'s')));
        
        DurHighBreathFz{group}(mouse) = dt*sum(X>LimResp)*length(X)/sum(isnan(X));
        DurLowBreathFz{group}(mouse) = dt*sum(X<LimResp)*length(X)/sum(isnan(X));
        PropNan(group,mouse) = sum(isnan(X))/length(X);

    end
end
    LimPerc = 100;
GoodMice{1} = find(PropNan(1,:)<LimPerc);
GoodMice{2} = find(PropNan(2,:)<LimPerc);
Cols = {[0.6 0.6 0.6],[1 0.6 0.6]}

clf
subplot(241)
% for grp = 1:2
% DurHighBreathFz{grp} = DurHighBreathFz{grp}(GoodMice{grp});
% DurLowBreathFz{grp} = DurLowBreathFz{grp}(GoodMice{grp});
% end

[R,P] = PlotCorrelations_BM(log(DurHighBreathFz{1}),log(DurLowBreathFz{1}), 'conf_bound',1);
% plot(DurHighBreathFz{1},DurLowBreathFz{1},'.')
hold on
plot(log(DurHighBreathFz{2}), log(DurLowBreathFz{2}),'r.')
makepretty
StressScore = GetStressScore_Sal_DZP_Rip;
axis square
xlabel('Dur fast breath immobility')
ylabel('Dur slow breath immobility')
legend off
[R,p] = corr(log(DurHighBreathFz{1})', log(DurLowBreathFz{1})','type','Spearman');
title(['R= ' num2str(R) '  P= ' num2str(p)])


% rediduals on ripple controls
clear residual_ctrl residual_rip
mdl = fit(log(DurHighBreathFz{1})',log(DurLowBreathFz{1})','poly1');
for mouse=1:length(log(DurHighBreathFz{1}))
    y = log(DurLowBreathFz{1}(mouse));
    x = log(DurHighBreathFz{1}(mouse));
    residual_ctrl(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);
    y = log(DurLowBreathFz{2}(mouse));
    x = log(DurHighBreathFz{2}(mouse));
    residual_rip(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);
    
%     residual_ctrl(mouse) = log(DurLowBreathFz{1}(mouse))-(log(DurHighBreathFz{1}(mouse))* mdl.p1 + mdl.p2);
%     residual_rip(mouse) = log(DurLowBreathFz{2}(mouse))-(log(DurHighBreathFz{2}(mouse))* mdl.p1 + mdl.p2);
%     

end

% residuals on eyelid
% residual_ctrl = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{1},DurLowBreathFz{1});
% residual_rip = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{2},DurLowBreathFz{2});

subplot(245)
[R,P] = PlotCorrelations_BM([residual_ctrl,residual_rip],...
    [StressScore.Rip{1}(GoodMice{1}),StressScore.Rip{2}(GoodMice{2})], 'conf_bound',1);
plot(residual_ctrl,StressScore.Rip{1}(GoodMice{1}),'k.')
hold on
plot(residual_rip,StressScore.Rip{2}(GoodMice{2}),'r.')
makepretty
legend off
[R,p] = corr([residual_ctrl,residual_rip]',...
[StressScore.Rip{1}(GoodMice{1}),StressScore.Rip{2}(GoodMice{2})]','type','Spearman','rows','complete');
title(['R= ' num2str(R) '  P= ' num2str(p)])
xlabel('Recovery deviation')
ylabel('Stress score')


[R,p] = corr([residual_ctrl,residual_rip]',...
[StressScore.Rip{1}(GoodMice{1}),StressScore.Rip{2}(GoodMice{2})]','type','Pearson','rows','complete');


%% Separate correaltions
Legends = {'Sham','Inhib'};
[R,p] = corr([residual_ctrl]',...
[StressScore.Rip{1}(GoodMice{1})]','type','Spearman');


subplot(142)
MakeSpreadAndBoxPlot3_SB({log(DurLowBreathFz{1}),log(DurLowBreathFz{2})},...
    Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Log duration slow breath immobility')
makepretty
axis square

subplot(143)
MakeSpreadAndBoxPlot3_SB({residual_ctrl,residual_rip},Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Recovery deviation')
makepretty
axis square

subplot(144)
MakeSpreadAndBoxPlot3_SB(StressScore.Rip,Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Stress score')
makepretty
axis square

% 
% 
% for group = 1:2
%     for mouse = 1:length(Path{group})
%         clf
%         for folder = 1:length(Path{group}{mouse})
%             cd(Path{group}{mouse}{folder})
%             subplot(3,3,folder)
%             load('B_vHC_Clean_Low_Speclear all
load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions_BM.mat')
Group=[7 8];
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Path{group}{mouse} = CondSess.(Mouse_names{mouse});
    end
end

clear Respi LinPos FreezeEpoch Spec_Clean Spec
for group = 1:2
    for mouse = 1:length(Path{group})
        
        Spec_Clean{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_vHC_Clean_Low');
        Spec{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'spectrum','prefix','B_Low');
        FreezeEpoch{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'epoch','epochname','freezeepoch');
        LinPos{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'linpos_sampetps');
        Respi{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'respi_freq_bm_clean');
       end
end



%%
LimResp =4.5;
for group = 1:2
    Mouse=Drugs_Groups_UMaze_BM(Group(group));

    for mouse = 1:length(Path{group})
        
        SafeFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.6,'Direction','Above'));
        ShockFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.4,'Direction','Below'));
        
        CleanSpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},SafeFreeze))));
        CleanSpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec_Clean{group}{mouse},ShockFreeze))));
        
        DirtySpec_Sf{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,SafeFreeze)))));
        DirtySpec_Sk{group}(mouse,:) = nanmean((Data(Restrict(Spec{group}{mouse},and(FreezeEpoch{group}{mouse} ,ShockFreeze)))));
        
       
        X = Data(Restrict(Respi{group}{mouse},FreezeEpoch{group}{mouse}));
        X(X<2) = NaN;
%         X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)),'linear');

        dt = median(diff(Range(Respi{group}{mouse},'s')));
        
        DurHighBreathFz{group}(mouse) = dt*sum(X>LimResp)*length(X)/sum(isnan(X));
        DurLowBreathFz{group}(mouse) = dt*sum(X<LimResp)*length(X)/sum(isnan(X));
        PropNan(group,mouse) = sum(isnan(X))/length(X);

    end
end
    
GoodMice{1} = find(PropNan(1,:)<0.5);
GoodMice{2} = find(PropNan(2,:)<0.5);
Cols = {[0.6 0.6 0.6],[1 0.6 0.6]}

clf
subplot(241)
LimPerc = 0;
for grp = 1:2
DurHighBreathFz{grp} = DurHighBreathFz{grp}(GoodMice{grp});
DurLowBreathFz{grp} = DurLowBreathFz{grp}(GoodMice{grp});
end

[R,P] = PlotCorrelations_BM(log(DurHighBreathFz{1}),log(DurLowBreathFz{1}), 'conf_bound',1);
% plot(DurHighBreathFz{1},DurLowBreathFz{1},'.')
hold on
plot(log(DurHighBreathFz{2}), log(DurLowBreathFz{2}),'r.')
makepretty
StressScore = GetStressScore_Sal_DZP_Rip;
axis square
xlabel('Dur fast breath immobility')
ylabel('Dur slow breath immobility')
legend off
[R,p] = corr(log(DurHighBreathFz{2})', log(DurLowBreathFz{2})','type','Spearman');
title(['R= ' num2str(R) '  P= ' num2str(p)])


% rediduals on ripple controls
clear residual_ctrl residual_rip
mdl = fit(log(DurHighBreathFz{1})',log(DurLowBreathFz{1})','poly1');
for mouse=1:length(log(DurHighBreathFz{1}))
    y = log(DurLowBreathFz{1}(mouse));
    x = log(DurHighBreathFz{1}(mouse));
    residual_ctrl(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);
    y = log(DurLowBreathFz{2}(mouse));
    x = log(DurHighBreathFz{2}(mouse));
    residual_rip(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);
    
%     residual_ctrl(mouse) = log(DurLowBreathFz{1}(mouse))-(log(DurHighBreathFz{1}(mouse))* mdl.p1 + mdl.p2);
%     residual_rip(mouse) = log(DurLowBreathFz{2}(mouse))-(log(DurHighBreathFz{2}(mouse))* mdl.p1 + mdl.p2);
%     

end

% residuals on eyelid
% residual_ctrl = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{1},DurLowBreathFz{1});
% residual_rip = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{2},DurLowBreathFz{2});

subplot(245)
[R,P] = PlotCorrelations_BM([residual_ctrl,residual_rip],...
    [StressScore.Rip{1}(GoodMice{1}),StressScore.Rip{2}(GoodMice{2})], 'conf_bound',1);
plot(residual_ctrl,StressScore.Rip{1}(GoodMice{1}),'k.')
hold on
plot(residual_rip,StressScore.Rip{2}(GoodMice{2}),'r.')
makepretty
legend off
[R,p] = corr([residual_ctrl,residual_rip]',...
[StressScore.Rip{1}(GoodMice{1}),StressScore.Rip{2}(GoodMice{2})]','type','Spearman','rows','complete');
title(['R= ' num2str(R) '  P= ' num2str(p)])
xlabel('Recovery deviation')
ylabel('Stress score')

%% Separate correaltions
Legends = {'Sham','Inhib'};
[R,p] = corr([residual_ctrl]',...
[StressScore.Rip{1}(GoodMice{1})]','type','Spearman');


subplot(142)
MakeSpreadAndBoxPlot3_SB({log(DurLowBreathFz{1}),log(DurLowBreathFz{2})},...
    Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Log duration slow breath immobility')
makepretty
axis square

subplot(143)
MakeSpreadAndBoxPlot3_SB({residual_ctrl,residual_rip},Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Recovery deviation')
makepretty
axis square

subplot(144)
MakeSpreadAndBoxPlot3_SB(StressScore.Rip,Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Stress score')
makepretty
axis square

% 
% 
% for group = 1:2
%     for mouse = 1:length(Path{group})
%         clf
%         for folder = 1:length(Path{group}{mouse})
%             cd(Path{group}{mouse}{folder})
%             subplot(3,3,folder)
%             load('B_vHC_Clean_Low_Spectrum.mat')
%             imagesc(Spectro{2},Spectro{3},log((Spectro{1})'))
%             axis xy
%         end
%         keyboard
%     end
% end


ctrum.mat')
%             imagesc(Spectro{2},Spectro{3},log((Spectro{1})'))
%             axis xy
%         end
%         keyboard
%     end
% end


