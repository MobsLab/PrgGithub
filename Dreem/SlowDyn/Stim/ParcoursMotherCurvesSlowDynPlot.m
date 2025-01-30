% ParcoursMotherCurvesSlowDynPlot
% 03.10.2018 KJ
%
% Infos
%   Mother curves with ages
%       
%
% SEE 
%   ParcoursMotherCurvesSlowDyn
%

clear
load(fullfile(FolderSlowDynData,'ParcoursMotherCurvesSlowDyn.mat'))

%% init

%params
step = 10;
age_range = [20:step:50 90];
show_sig = 'sig';
showPoints = 1;

%colors
colori = [distinguishable_colors(length(age_range)-1)];
for i=1:length(age_range)-1
    colori_age{i} = colori(i,:);
end

%labels
for i=1:length(age_range)-2
    labels{i} = [num2str(age_range(i)) '-' num2str(age_range(i+1))]; 
end
labels{length(age_range)-1} = ['>' num2str(age_range(end-1))];


%%  pool

%age
all_ages = cell2mat(mother_res.age);

for ch=1:4
    for i=1:length(age_range)-1
        all_curves = [];
        for p=1:length(mother_res.filename)
            if mother_res.age{p}>=age_range(i) && mother_res.age{p}<age_range(i+1) && mother_res.nb_stim{p}>100
                all_curves = [all_curves ; mother_res.met_tones{p,ch}(:,2)'];
            end
        end

        %x, y & std
        mean_curves{i,ch} = median(all_curves,1);
        std_curves{i,ch} = std(all_curves,1) / sqrt(size(all_curves,1));
        x_curves{i,ch} = mother_res.met_tones{p,ch}(:,1);
    end
end




%% Plot
figure, hold on

for ch=1:4
    subplot(2,2,ch), hold on
    for i=1:length(age_range)-1
        h(i) = plot(x_curves{i,ch}, mean_curves{i,ch}, 'color', colori_age{i}); hold on
    end
    line([0 0], ylim,'color','k','linewidth',1), hold on
    legend(h, labels),
    title(['channel ' num2str(ch)])
end




