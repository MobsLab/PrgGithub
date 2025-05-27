clear all
load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions_BM.mat')
Group=[13 15];
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
        
        FreezeEpoch{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'epoch','epochname','freezeepoch');
        LinPos{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'linpos_sampetps');
        Respi{group}{mouse} = ConcatenateDataFromFolders_SB(Path{group}{mouse},'respi_freq_bm');
       end
end



%%
clear  PropNan
LimResp =4.5;
for group = 1:2
    Mouse=Drugs_Groups_UMaze_BM(Group(group));

    for mouse = 1:length(Path{group})
        
        SafeFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.6,'Direction','Above'));
        ShockFreeze = and(FreezeEpoch{group}{mouse} ,thresholdIntervals(LinPos{group}{mouse},0.4,'Direction','Below'));
        
        
       
        X = Data(Restrict(Respi{group}{mouse},FreezeEpoch{group}{mouse}));
        X(X<2) = NaN;

        dt = median(diff(Range(Respi{group}{mouse},'s')));
        
        DurHighBreathFz{group}(mouse) = dt*sum(X>LimResp);
        DurLowBreathFz{group}(mouse) = dt*sum(X<LimResp);
        PropNan{group}(mouse) = sum(isnan(X))/length(X);

    end
end
    
GoodMice{1} = find( PropNan{1}<100);
GoodMice{2} = find( PropNan{2}<100);
Cols = {[0.6 0.6 0.6],[1 0.6 0.6]};

clf
subplot(241)
LimPerc = 0;
for grp = 1:2
DurHighBreathFz{grp} = DurHighBreathFz{grp}(GoodMice{grp});
DurLowBreathFz{grp} = DurLowBreathFz{grp}(GoodMice{grp});
end

[R,P] = PlotCorrelations_BM(log(DurHighBreathFz{1}+1e-5),log(DurLowBreathFz{1}+1e-5), 'conf_bound',1);
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


% rediduals on dzp controls
mdl = fit(log(DurHighBreathFz{1})',log(DurLowBreathFz{1})','poly1');

for mouse=1:length(log(DurHighBreathFz{1}))
%     residual_ctrl(mouse) = log(DurLowBreathFz{1}(mouse))-(log(DurHighBreathFz{1}(mouse))* mdl.p1 + mdl.p2);
    
    y = log(DurLowBreathFz{1}(mouse));
    x = log(DurHighBreathFz{1}(mouse));
    residual_ctrl(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);
end
for mouse=1:length(log(DurHighBreathFz{2}))
%     residual_dzp(mouse) = log(DurLowBreathFz{2}(mouse))-(log(DurHighBreathFz{2}(mouse))* mdl.p1 + mdl.p2);
    y = log(DurLowBreathFz{2}(mouse));
    x = log(DurHighBreathFz{2}(mouse));
    residual_dzp(mouse) =      -(mdl.p1*x - y + mdl.p2)./sqrt(mdl.p1^2 + 1);


end
% residuals on eyelid
% residual_ctrl = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{1},DurLowBreathFz{1});
% residual_rip = CalculateDistanceToShockSafeHomeoStasisLine(DurHighBreathFz{2},DurLowBreathFz{2});

subplot(245)
[R,P] = PlotCorrelations_BM([residual_ctrl,residual_dzp],...
    [StressScore.DZP{1}(GoodMice{1}),StressScore.DZP{2}(GoodMice{2})], 'conf_bound',1);
plot(residual_ctrl,StressScore.DZP{1}(GoodMice{1}),'k.')
hold on
plot(residual_dzp,StressScore.DZP{2}(GoodMice{2}),'r.')
makepretty
legend off
[R,p] = corr([residual_ctrl,residual_dzp]',...
[StressScore.DZP{1}(GoodMice{1}),StressScore.DZP{2}(GoodMice{2})]','type','Spearman');
title(['R= ' num2str(R) '  P= ' num2str(p)])
xlabel('Recovery deviation')
ylabel('Stress score')
Legends = {'Sal','DZP'};

subplot(142)
MakeSpreadAndBoxPlot3_SB({log(DurLowBreathFz{1}),log(DurLowBreathFz{2})},...
    Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Log duration slow breath immobility')
makepretty
axis square

subplot(143)
MakeSpreadAndBoxPlot3_SB({residual_ctrl,residual_dzp},Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Recovery deviation')
makepretty
axis square

subplot(144)
MakeSpreadAndBoxPlot3_SB(StressScore.DZP,Cols,1:2,Legends,'showpoints',1,'paired',0)
ylabel('Stress score')
makepretty
axis square


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




%% To get the plot with log sclae
figure
plot((DurHighBreathFz{2}), (DurLowBreathFz{2}),'r.')
hold on
plot((DurHighBreathFz{1}), (DurLowBreathFz{1}),'k.')
makepretty
set(gca,'YScale','log')
set(gca,'XScale','log')
yl = ylim;
xl = xlim;
xlabel('Dur fast breath immobility')
ylabel('Dur slow breath immobility')
legend off
[R,p] = corr(log(DurHighBreathFz{1})', log(DurLowBreathFz{1})','type','Spearman');
title(['R= ' num2str(R) '  P= ' num2str(p)])




figure
[R,P] = PlotCorrelations_BM(log(DurHighBreathFz{1}+1e-5),log(DurLowBreathFz{1}+1e-5), 'conf_bound',1);
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
ylim(log(yl))
xlim(log(xl))

