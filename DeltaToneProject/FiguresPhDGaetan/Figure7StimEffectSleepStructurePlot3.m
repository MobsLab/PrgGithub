% Figure7StimEffectSleepStructurePlot3
% 05.12.2016 KJ
%
% Collect data to plot the figures from the Figure7.pdf (f-g) of Gaetan PhD
% 
% 
%   see Figure7StimEffectSleepStructure
%


clear
load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 

conditions = figure7_res.manipe;
conditions = unique(conditions(~cellfun('isempty',conditions)));
conditions = conditions(1:2);
ConditionColors = {'k','b'};

thresh_high_s1 = [0.6 1.4]; %  threshold for considering high delta frequency S1

%% Data

%basal
delta_density_basal_s1s2 = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        delta_density_basal_s1s2 = [delta_density_basal_s1s2 ; squeeze(figure7_res.delta.density(p,1:2))];
    end
end
delta_density_basal_s1s2(any(delta_density_basal_s1s2 == 0, 2),:)=[];
delta_density_basal_s1s2(any(isnan(delta_density_basal_s1s2), 2),:)=[];
delta_density_basal_s1s2(any(delta_density_basal_s1s2>1.5, 2),:)=[];

delta_density_basal_s3s4 = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        delta_density_basal_s3s4 = [delta_density_basal_s3s4 ; squeeze(figure7_res.delta.density(p,3:4))];
    end
end
delta_density_basal_s3s4(any(delta_density_basal_s3s4 == 0, 2),:)=[];
delta_density_basal_s3s4(any(isnan(delta_density_basal_s3s4), 2),:)=[];
delta_density_basal_s3s4(any(delta_density_basal_s3s4>1.5, 2),:)=[];

%delta tone
delta_density_tone_s1s2 = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        delta_density_tone_s1s2 = [delta_density_tone_s1s2 ; squeeze(figure7_res.delta.density(p,1:2))];
    end
end
delta_density_tone_s1s2(any(delta_density_tone_s1s2 == 0, 2),:)=[];
delta_density_tone_s1s2(any(isnan(delta_density_tone_s1s2), 2),:)=[];
delta_density_tone_s1s2(any(delta_density_tone_s1s2>1.5, 2),:)=[];

delta_density_tone_s3s4 = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        delta_density_tone_s3s4 = [delta_density_tone_s3s4 ; squeeze(figure7_res.delta.density(p,3:4))];
    end
end
delta_density_tone_s3s4(any(delta_density_tone_s3s4 == 0, 2),:)=[];
delta_density_tone_s3s4(any(isnan(delta_density_tone_s3s4), 2),:)=[];
delta_density_tone_s3s4(any(delta_density_tone_s3s4>1.5, 2),:)=[];

% Corrcoef
all_s1s2 = [[delta_density_basal_s1s2(:,1);delta_density_tone_s1s2(:,1)] [delta_density_basal_s1s2(:,2);delta_density_tone_s1s2(:,2)]];
[r12,p12] = corrcoef(all_s1s2);
r12 = r12(1,2); p12 = p12(1,2);
all_s3s4 = [[delta_density_basal_s3s4(:,1);delta_density_tone_s3s4(:,1)] [delta_density_basal_s3s4(:,2);delta_density_tone_s3s4(:,2)]];
[r34,p34] = corrcoef(all_s3s4);
r34 = r34(1,2); p34 = p34(1,2);

%bar

data_S2 = {delta_density_basal_s1s2(:,2),delta_density_tone_s1s2(:,2)};

high_basal_s2 = delta_density_basal_s1s2(:,2);
high_basal_s2 = high_basal_s2(delta_density_basal_s1s2(:,1)>thresh_high_s1(1) & delta_density_basal_s1s2(:,1)<thresh_high_s1(2));
high_tone_s2 = delta_density_tone_s1s2(:,2);
high_tone_s2 = high_tone_s2(delta_density_tone_s1s2(:,1)>thresh_high_s1(1) & delta_density_tone_s1s2(:,1)<thresh_high_s1(2));
data_S2_bis = {high_basal_s2, high_tone_s2};

data_S4 = {delta_density_basal_s3s4(:,2),delta_density_tone_s3s4(:,2)};



%% Plot
figure, hold on

test = 'ranksum';

%S1 vs S2
subplot(2,4,1:2)
scattersize = 25;
scatter(delta_density_basal_s1s2(:,1),delta_density_basal_s1s2(:,2),scattersize,'k','filled'), hold on
scatter(delta_density_tone_s1s2(:,1),delta_density_tone_s1s2(:,2),scattersize,'b','filled'), hold on
legend('Basal','DeltaToneAll')
plot(linspace(0,1.6,1000),linspace(0,1.6,1000),'color',[0.75 0.75 0.75]), hold on
y_lim = get(gca,'YLim'); x_lim = get(gca,'XLim');
line([thresh_high_s1(1) thresh_high_s1(1)], y_lim,'LineStyle',':'), hold on
line([thresh_high_s1(2) thresh_high_s1(2)], y_lim,'LineStyle',':'), hold on
patch([thresh_high_s1(1) thresh_high_s1(2) thresh_high_s1(2) thresh_high_s1(1)], [y_lim(1) y_lim(1) y_lim(2) y_lim(2)], [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.1), hold on
xlabel('Delta Frequency (S1)'); ylabel('Delta Frequency (S2)');
t = title(['r=' num2str(r12) ', p=' num2str(p12)]);
set(t, 'FontSize', 8);

%bar S2
subplot(2,4,3)
PlotErrorBarN_KJ(data_S2, 'newfig',0,'paired',0, 'barcolors', {'k','b'},'ShowSigstar','all','optiontest',test);
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel',{'S2 no tone','S2 tone'},'XTick',1:2), hold on,
title('all days')

subplot(2,4,4)
PlotErrorBarN_KJ(data_S2_bis, 'newfig',0,'paired',0, 'barcolors', {'k','b'},'ShowSigstar','all','optiontest',test);
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel',{'S2 no tone','S2 tone'},'XTick',1:2), hold on,
title('high S1 FqDelta')

%S3 vs S4
subplot(2,4,5:6)
scattersize = 25;
scatter(delta_density_basal_s3s4(:,1),delta_density_basal_s3s4(:,2),scattersize,'k','filled'), hold on
scatter(delta_density_tone_s3s4(:,1),delta_density_tone_s3s4(:,2),scattersize,'b','filled'), hold on
legend('Basal','DeltaToneAll')
plot(linspace(0,1.6,1000),linspace(0,1.6,1000),'color',[0.75 0.75 0.75]), hold on
xlabel('Delta Frequency (S3)'); ylabel('Delta Frequency (S4)');
title('Delta Frequency - S3 vs S4')
t = title(['r=' num2str(r34) ', p=' num2str(p34)]);
set(t, 'FontSize', 8);

%bar S4
subplot(2,4,7)
PlotErrorBarN_KJ(data_S4, 'newfig',0,'paired',0, 'barcolors', {'k','b'},'ShowSigstar','all','optiontest',test);
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel',{'S4 no tone','S4 tone'},'XTick',1:2), hold on,
title('all days')


