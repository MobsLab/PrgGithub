function plotPredictionVSReal(freal,fpred,pos,sigGT)
%PLOTPREDICTIONVSREAL Summary of this function goes here
%   Detailed explanation goes here
x = 1:length(freal);
figure;
plot(x, freal, 'x'), hold on 
plot(x, fpred, 'o'), hold on
ylabel('Frequency (Hz)', 'FontSize', 20)

yyaxis right
plot(x, pos, '-')
plot(x, sigGT)
ylabel('Linearized Position', 'FontSize', 20)
makepretty

xlabel('Observation', 'FontSize', 20)

leg=legend({'Train data', 'Fitted value', 'Posiiton'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
leg.ItemTokenSize = [20,10];
legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);

end

