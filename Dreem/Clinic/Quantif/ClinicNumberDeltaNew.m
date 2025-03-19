% ClinicNumberDeltaNew
% 30.06.2017 KJ
%
% Number of delta
% 
% 
%   see ClinicQuantitySleep ClinicNumberDelta
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicQuantitySleepNew.mat']) 
conditions = {'sham','upphase','random'};
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'b','k','g'};
device=1; %1 for dreem VC, 2 for actiwave VC
scorer=1; %

%% data
for cond=1:length(conditions)
    %selected record 
    path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
    
    %data
    tones{cond} = cell2mat(quantity_res.tones.total(path_cond,device));
    success{cond} = cell2mat(quantity_res.success.total(path_cond,device));
    slowwaves{cond} = cell2mat(quantity_res.slowwaves.total(path_cond,device));
    if cond==1
        percentage_success{cond} = zeros(1,length(slowwaves{cond}));
    else
        percentage_success{cond} = 100 * success{cond} ./ tones{cond};
    end
    
    n3_duration{cond} = [];
    for p=1:length(path_cond)
        n3_duration{cond} = [n3_duration{cond} quantity_res.sleepstages.total{path_cond(p),scorer}(3)/1E4]; 
    end
    
end

%concatenate stim records
stim.percentage_success = [percentage_success{2};percentage_success{3}]; 
stim.slowwaves = [slowwaves{2};slowwaves{3}];
stim.n3_duration = [n3_duration{2} n3_duration{3}]'; 

polyn_slowwave = polyfit(stim.percentage_success, stim.slowwaves, 1);
polyn_n3 = polyfit(stim.percentage_success, stim.n3_duration, 1);
[r_slowwave,p_slowwave] = corrcoef(stim.percentage_success, stim.slowwaves);
[r_n3,p_n3] = corrcoef(stim.percentage_success, stim.n3_duration);


%% PLOT

%scatter plot by conditions
figure, hold on
scattersize = 25;
x = 0:0.1:60;

%slow waves and percentage success
subplot(2,2,1), hold on
for cond=1:length(conditions)
    scatter(percentage_success{cond},slowwaves{cond},scattersize,colori{cond},'filled'), hold on
end
legend(conditions), hold on
plot(x, polyn_slowwave(2) + x*polyn_slowwave(1),'k'), hold on 
xlabel('% success'),ylabel('Number of slow waves'),
title('Number of Slow waves vs Tones Success %'),
text(0.1,0.95,['r = ' num2str(round(r_slowwave(1,2),2))],'Units','normalized');
text(0.1,0.9,['p = ' num2str(round(p_slowwave(1,2),4))],'Units','normalized');

subplot(2,2,2), hold on
[~,eb] = PlotErrorBarN_KJ(slowwaves,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
set(eb,'Linewidth',2); %bold error bar
title('Slow waves'),
ylabel('Number of slow waves'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,

%n3 duration and percentage success
subplot(2,2,3), hold on
for cond=1:length(conditions)
    scatter(percentage_success{cond},n3_duration{cond},scattersize,colori{cond},'filled'), hold on
end
legend(conditions)
plot(x, polyn_n3(2) + x*polyn_n3(1),'k'), hold on 
xlabel('% success'),ylabel('N3 total duration'),
title('N3 duration vs Tones Success %'),
text(0.1,0.95,['r = ' num2str(round(r_n3(1,2),2))],'Units','normalized');
text(0.1,0.9,['p = ' num2str(round(p_n3(1,2),4))],'Units','normalized');

subplot(2,2,4), hold on
[~,eb] = PlotErrorBarN_KJ(n3_duration,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
set(eb,'Linewidth',2); %bold error bar
title('N3'),
ylabel('N3 total duration'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,





