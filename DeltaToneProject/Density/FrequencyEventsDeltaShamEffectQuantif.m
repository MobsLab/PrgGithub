% FrequencyEventsDeltaShamEffectQuantif
% 13.12.2016 KJ
%
% Quantification of the slope of delta density in the different session
% 
% 
%   see FrequencyEventsDeltaShamEffect
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect.mat'])

for p=1:length(frequency_res.path) 
    if  strcmpi(frequency_res.manipe{p},'Basal')
        frequency_res.condition{p} = 'Basal';
    elseif strcmpi(frequency_res.manipe{p},'RdmTone')
        frequency_res.condition{p} = 'RdmTone';
    else
        frequency_res.condition{p} = ['DeltaTone-' num2str(frequency_res.delay{p}*1E3)];
    end
end

animals = unique(frequency_res.name); %Mice
conditions = unique(frequency_res.condition); %Conditions
%params
thresh_regression_density = 0.4;
smoothing = 0;

%loop over conditions
for cond=1:length(conditions)
    coeff_dir{cond} = [];
    start_value{cond} = [];
    %loop over records
    for p=1:length(frequency_res.path) 
        if strcmpi(frequency_res.condition{p},conditions{cond})
            %density
            deltas_density= Smooth(frequency_res.deltas.density{p}, smoothing) * 1E4;
            x = linspace(1,6,length(deltas_density)+1);
            x = x(1:end-1)';

            %regression
            regression_delta = [];
            night_coeff_dir = nan(1,5);
            night_start_value = nan(1,5);
            for s=1:5
                x_session = x>=s & x<s+1;
                x_regression = x_session & deltas_density>thresh_regression_density; %restrict to session, where density is high enough
                [p,~] = polyfit(x(x_regression),deltas_density(x_regression),1);
                night_coeff_dir(s) = p(1); night_start_value(s) = p(2);
            end
    
            if isempty(coeff_dir{cond})
                coeff_dir{cond} = night_coeff_dir;
                start_value{cond} = night_start_value;
            else
                coeff_dir{cond} = [coeff_dir{cond};night_coeff_dir];
                start_value{cond} = [start_value{cond};night_start_value];
            end
            
            
        end
    end
end

%% plot

figure, hold on
for s=1:4
    subplot(2,2,s),hold on
    for cond=1:length(conditions)
       data{cond} = coeff_dir{cond}(:,s);
    end
    PlotErrorBarN_KJ(data,'newfig',0,'paired',0);
    title(['Session ' num2str(s)]),
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions), 'XTickLabelRotation', 30), hold on,
end










