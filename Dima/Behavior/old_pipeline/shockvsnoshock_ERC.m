%%% shockvsnoshock_ERC
% master script for all the behavior you can imagine



%% Parameters
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'shock_vs_shock';

indir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/';
ntest = 4;
Day3 = '17072018';
Day4 = '18072018';

suf = {'TestPre'; 'TestPost'; 'TestPost'};

%% Get the data
for i = 1:1:ntest
    % PreTests
    a = load([indir Day3 '/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'], 'Occup');
    PreTest_occup(i,1:7) = a.Occup;
    % PostTests
    b = load([indir Day3 '/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'], 'Occup');
    PostTest_occup(i,1:7) = b.Occup;
    % PostTests24h
    c = load([indir Day4 '/' suf{3} '/' suf{3} num2str(i) '/behavResources.mat'], 'Occup');
    Post24_occup(i,1:7) = c.Occup;
end

%% Calculate
Occup_mean_pre = mean(PreTest_occup,1);
Occup_std_pre = std(PreTest_occup,1);

Occup_mean_post = mean(PostTest_occup,1);
Occup_std_post = std(PostTest_occup,1);

Occup_mean_post24 = mean(Post24_occup,1);
Occup_std_post24 = std(Post24_occup,1);

%% Plot
figure('units', 'normalized', 'outerposition', [[0.05078125 0.474609375 0.94765625 0.4208984375]],  'Color',[1 1 1])

subplot(1,3,1)
bar(Occup_mean_pre(1:2))
hold on
errorbar(Occup_mean_pre(1:2), Occup_std_pre(1:2),'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],PreTest_occup(k,1:2), '-ro', 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Shock', 'NoShock'})
ylabel('% time spent')
xlim([0.5 2.5])
box off
title ('PreTests');

subplot(1,3,2)
bar(Occup_mean_post(1:2))
hold on
errorbar(Occup_mean_post(1:2), Occup_std_post(1:2),'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],PostTest_occup(k,1:2), '-ro', 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Shock', 'NoShock'})
ylabel('% time spent')
xlim([0.5 2.5])
box off
title ('PostTests');

subplot(1,3,3)
bar(Occup_mean_post24(1:2))
hold on
errorbar(Occup_mean_post24(1:2), Occup_std_post24(1:2),'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],Post24_occup(k,1:2), '-ro', 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Shock', 'NoShock'})
ylabel('% time spent')
xlim([0.5 2.5])
box off
title ('PostTests 24h later');

%Save it
saveas(gcf, [dir_out fig_out '.fig']);
saveFigure(gcf,fig_out,dir_out);