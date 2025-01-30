[num,str] = xlsread('/media/nas4/ProjetMTZL/MethimazoleMiceWeight.xlsx');

Sal_Weight = num(2:end-1,2:6)';
Mtzl_Weight = num(2:end-1,7:end)';
Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.6 0.6]};
figure
errorbar([1:4],nanmean(Sal_Weight),stdError(Sal_Weight),'color',Cols{1},'linewidth',3)
hold on
errorbar([1:4],nanmean(Mtzl_Weight),stdError(Mtzl_Weight),'color',Cols{2},'linewidth',3)
ylabel('weight (g)')
xlabel('days ')
xlim([-1 5])
ylim([22 34])
line([0 0]+0.5,ylim,'linewidth',3,'color','k')
legend('saline (n=5)','mtzl(n=5)')
set(gca,'XTick',[0,1,2,3,4])
text(0.55,32,'injection')
annotation('textbox',[.15 0.95 .2 .06], ...
    'String','Figure created with WeightChangeMTZL_Nov2018_SB.m', ...
    'FitBoxToText','on', 'EdgeColor', 'none', 'FontAngle','italic')

A = Sal_Weight;
B= Mtzl_Weight;
for day = 1:4
    [p(day),h(day),stats(day)] = ranksum(A(:,(day)),B(:,(day)));
end