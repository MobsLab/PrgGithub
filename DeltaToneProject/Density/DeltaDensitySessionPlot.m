% DeltaDensitySessionPlot
% 12.12.2016 KJ
%
% plot the figures from the Figure7.pdf (f), corrected, of Gaetan PhD 
% 
%
%   see DeltaDensitySession
%


clear
load([FolderProjetDelta 'Data/DeltaDensitySession.mat']) 

conditions = unique(deltadens_res.manipe);
ConditionColors = {'k','b'};

thresh_high_s1 = 0.85; %  threshold for considering high delta frequency S1

%% Data

%basal
delta_density_basal_s1s2 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'Basal')
        delta_density_basal_s1s2 = [delta_density_basal_s1s2 ; squeeze(deltadens_res.delta.density(p,1:2))];
    end
end
delta_density_basal_s1s2(any(delta_density_basal_s1s2 == 0, 2),:)=[];
delta_density_basal_s1s2(any(isnan(delta_density_basal_s1s2), 2),:)=[];
delta_density_basal_s1s2(any(delta_density_basal_s1s2>1.5, 2),:)=[];

delta_density_basal_s3s4 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'Basal')
        delta_density_basal_s3s4 = [delta_density_basal_s3s4 ; squeeze(deltadens_res.delta.density(p,3:4))];
    end
end
delta_density_basal_s3s4(any(delta_density_basal_s3s4 == 0, 2),:)=[];
delta_density_basal_s3s4(any(isnan(delta_density_basal_s3s4), 2),:)=[];
delta_density_basal_s3s4(any(delta_density_basal_s3s4>1.5, 2),:)=[];

%delta tone
delta_density_tone_s1s2 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'DeltaToneAll')
        delta_density_tone_s1s2 = [delta_density_tone_s1s2 ; squeeze(deltadens_res.delta.density(p,1:2))];
    end
end
delta_density_tone_s1s2(any(delta_density_tone_s1s2 == 0, 2),:)=[];
delta_density_tone_s1s2(any(isnan(delta_density_tone_s1s2), 2),:)=[];
delta_density_tone_s1s2(any(delta_density_tone_s1s2>1.5, 2),:)=[];

delta_density_tone_s3s4 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'DeltaToneAll')
        delta_density_tone_s3s4 = [delta_density_tone_s3s4 ; squeeze(deltadens_res.delta.density(p,3:4))];
    end
end
delta_density_tone_s3s4(any(delta_density_tone_s3s4 == 0, 2),:)=[];
delta_density_tone_s3s4(any(isnan(delta_density_tone_s3s4), 2),:)=[];
delta_density_tone_s3s4(any(delta_density_tone_s3s4>1.5, 2),:)=[];

%delta random
delta_density_random_s1s2 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'RdmTone')
        delta_density_random_s1s2 = [delta_density_random_s1s2 ; squeeze(deltadens_res.delta.density(p,1:2))];
    end
end
delta_density_random_s1s2(any(delta_density_random_s1s2 == 0, 2),:)=[];
delta_density_random_s1s2(any(isnan(delta_density_random_s1s2), 2),:)=[];
delta_density_random_s1s2(any(delta_density_random_s1s2>1.5, 2),:)=[];

delta_density_random_s3s4 = [];
for p=1:length(deltadens_res.path)
    if strcmpi(deltadens_res.manipe{p}, 'RdmTone')
        delta_density_random_s3s4 = [delta_density_random_s3s4 ; squeeze(deltadens_res.delta.density(p,3:4))];
    end
end
delta_density_random_s3s4(any(delta_density_random_s3s4 == 0, 2),:)=[];
delta_density_random_s3s4(any(isnan(delta_density_random_s3s4), 2),:)=[];
delta_density_random_s3s4(any(delta_density_random_s3s4>1.5, 2),:)=[];


% Corrcoef
all_s1s2 = [[delta_density_basal_s1s2(:,1);delta_density_tone_s1s2(:,1);delta_density_random_s1s2(:,1)] [delta_density_basal_s1s2(:,2);delta_density_tone_s1s2(:,2);delta_density_random_s1s2(:,2)]];
[r12,p12] = corrcoef(all_s1s2);
r12 = r12(1,2); p12 = p12(1,2);
all_s3s4 = [[delta_density_basal_s3s4(:,1);delta_density_tone_s3s4(:,1);delta_density_random_s3s4(:,1)] [delta_density_basal_s3s4(:,2);delta_density_tone_s3s4(:,2);delta_density_random_s3s4(:,2)]];
[r34,p34] = corrcoef(all_s3s4);
r34 = r34(1,2); p34 = p34(1,2);

%bar

data_S2 = {delta_density_basal_s1s2(:,2), delta_density_tone_s1s2(:,2), delta_density_random_s1s2(:,2)};

high_basal_s2 = delta_density_basal_s1s2(:,2);
high_basal_s2 = high_basal_s2(delta_density_basal_s1s2(:,1)>thresh_high_s1);
high_tone_s2 = delta_density_tone_s1s2(:,2);
high_tone_s2 = high_tone_s2(delta_density_tone_s1s2(:,1)>thresh_high_s1);
high_random_s2 = delta_density_random_s1s2(:,2);
high_random_s2 = high_random_s2(delta_density_random_s1s2(:,1)>thresh_high_s1);
data_S2_bis = {high_basal_s2, high_tone_s2, high_random_s2};

data_S4 = {delta_density_basal_s3s4(:,2), delta_density_tone_s3s4(:,2), delta_density_random_s3s4(:,2)};



%% Plot
figure, hold on
label_bars = {'S2 basal','S2 DeltaTone','S2 RandomTone'};

%S1 vs S2
subplot(2,4,1:2)
scattersize = 25;
scatter(delta_density_basal_s1s2(:,1),delta_density_basal_s1s2(:,2),scattersize,'k','filled'), hold on
scatter(delta_density_tone_s1s2(:,1),delta_density_tone_s1s2(:,2),scattersize,'b','filled'), hold on
scatter(delta_density_random_s1s2(:,1),delta_density_random_s1s2(:,2),scattersize,'g','filled'), hold on

legend('Basal','DeltaToneAll','RandomTone')
plot(linspace(0,1.6,1000),linspace(0,1.6,1000),'color',[0.75 0.75 0.75]), hold on
y_lim = get(gca,'YLim'); x_lim = get(gca,'XLim');
line([thresh_high_s1 thresh_high_s1], y_lim,'LineStyle',':'), hold on
patch([thresh_high_s1 x_lim(2) x_lim(2) thresh_high_s1], [y_lim(1) y_lim(1) y_lim(2) y_lim(2)], [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.1), hold on
xlabel('Delta Frequency (S1)'); ylabel('Delta Frequency (S2)');
t = title(['r=' num2str(r12) ', p=' num2str(p12)]);
set(t, 'FontSize', 8);

%bar S2
subplot(2,4,3)
PlotErrorBarN_KJ(data_S2, 'newfig',0,'paired',0, 'barcolors', {'k','b','g'},'ShowSigstar','all');
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel', label_bars,'XTick',1:numel(label_bars), 'XTickLabelRotation', 30), hold on,
title('all days')

subplot(2,4,4)
PlotErrorBarN_KJ(data_S2_bis, 'newfig',0,'paired',0, 'barcolors', {'k','b','g'},'ShowSigstar','all');
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel', label_bars,'XTick',1:numel(label_bars), 'XTickLabelRotation', 30), hold on,
title('high S1 FqDelta')

%S3 vs S4
subplot(2,4,5:6)
scattersize = 25;
scatter(delta_density_basal_s3s4(:,1),delta_density_basal_s3s4(:,2),scattersize,'k','filled'), hold on
scatter(delta_density_tone_s3s4(:,1),delta_density_tone_s3s4(:,2),scattersize,'b','filled'), hold on
scatter(delta_density_random_s3s4(:,1), delta_density_random_s3s4(:,2),scattersize,'g','filled'), hold on

legend('Basal','DeltaToneAll','RandomTone')
plot(linspace(0,1.6,1000),linspace(0,1.6,1000),'color',[0.75 0.75 0.75]), hold on
xlabel('Delta Frequency (S3)'); ylabel('Delta Frequency (S4)');
title('Delta Frequency - S3 vs S4')
t = title(['r=' num2str(r34) ', p=' num2str(p34)]);
set(t, 'FontSize', 8);

%bar S4
subplot(2,4,7)
PlotErrorBarN_KJ(data_S4, 'newfig',0,'paired',0, 'barcolors', {'k','b','g'},'ShowSigstar','all');
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel', label_bars,'XTick',1:numel(label_bars), 'XTickLabelRotation', 30), hold on,
title('all days')

