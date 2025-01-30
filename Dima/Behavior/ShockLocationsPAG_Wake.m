%ShockLocationsPAG_Wake - Plot PAG shock locations for all mice individually.
% 
% 
%  OUTPUT
%
%    Figure
%
%       See
%   
%       QuickCheckBehaviorERC, Behavior_ERC, PathForExperimentERC_Dima
% 
%       2019 by Dmitri Bryzgalov

%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
fig_post = 'PAGShock_Locations';
sav = 1;

% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 906 911 912];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

clrs = {'ko', 'bo', 'ro','go'; 'k','b', 'r', 'g'; 'kp', 'bp', 'rp', 'gp'};

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

%% Get data

for i = 1:length(Dir.path)
    % PreTests
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end

%% Find indices of Cond sessions in the structure
id_Cond = cell(1,length(a));

for i=1:length(a)
    id_Cond{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'Cond'))
            id_Cond{i}(k) = 1;
        end
    end
    id_Cond{i}=find(id_Cond{i});
end

% Get stimulation idxs for conditioning sessions
for i=1:length(a)
    for k=1:length(id_Cond{i})
        StimT_beh{i}{k} = find(a{i}.behavResources(id_Cond{i}(k)).PosMat(:,4)==1);
    end
end

%% Calculate average occupancy
% Calculate occupancy de novo
for i=1:length(a)
    for k=1:length(id_Cond{i})
        for t=1:length(a{i}.behavResources(id_Cond{i}(k)).Zone)
            Cond_Occup(i,k,t)=size(a{i}.behavResources(id_Cond{i}(k)).ZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Cond{i}(k)).Xtsd),1);
        end
    end
end
Cond_Occup = squeeze(Cond_Occup(:,:,1));

Cond_Occup_mean = mean(Cond_Occup,2);

%% Plot
numtrials = zeros(1,length(Dir.path));
numstim = zeros(1,length(Dir.path));

% Occupancy
for i = 1:length(Dir.path)
    
    subplot(3,3,i)

    imagesc(a{i}.behavResources(id_Cond{i}(1)).mask);
    colormap(gray)
    hold on
    imagesc(a{i}.behavResources(id_Cond{i}(1)).Zone{1}, 'AlphaData', 0.3);
    hold on
    for p=1:1:length(id_Cond{i})
        plot(a{i}.behavResources(id_Cond{i}(p)).PosMat(:,2)*...
            a{i}.behavResources(id_Cond{i}(p)).Ratio_IMAonREAL,...
            a{i}.behavResources(id_Cond{i}(p)).PosMat(:,3)*...
            a{i}.behavResources(id_Cond{i}(1)).Ratio_IMAonREAL,...
            clrs{2,p},'linewidth',1.5)
        hold on
        set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    end
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    for p=1:1:length(id_Cond{i})
        z(p) = length(StimT_beh{i}{p});
        if z(p) > 0
            numtrials(i) = numtrials(i)+1;
        end
        for j = 1:length(StimT_beh{i}{p})
            if p < 4
                h1 = plot(a{i}.behavResources(id_Cond{i}(p)).PosMat(StimT_beh{i}{p}(j),2)*...
                    a{i}.behavResources(id_Cond{i}(p)).Ratio_IMAonREAL,...
                    a{i}.behavResources(id_Cond{i}(p)).PosMat(StimT_beh{i}{p}(j),3)*...
                    a{i}.behavResources(id_Cond{i}(p)).Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerSize', 14, 'MarkerFaceColor', clrs{2,p});
                uistack(h1,'top');
            else
                h1 = plot(a{i}.behavResources(id_Cond{i}(p)).PosMat(StimT_beh{i}{p}(j),2)*...
                    a{i}.behavResources(id_Cond{i}(p)).Ratio_IMAonREAL,...
                    a{i}.behavResources(id_Cond{i}(p)).PosMat(StimT_beh{i}{p}(j),3)*...
                    a{i}.behavResources(id_Cond{i}(p)).Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerEdgeColor', [0.1 0.4 0.3], 'MarkerSize', 14, 'MarkerFaceColor', [0.1 0.4 0.3]);
            end
        end
    end
    title ([Dir.name{i} ': ' num2str(sum(z)) ' stims']);
    numstim(i) = sum(z);
    clear z
    
end

%% Save it
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end


%% Make a table
% numtrials = numtrials';
% numstim = numstim';
% 
% T = table(numstim, numtrials, Cond_Occup_mean);
% 
% filenme = [dir_out 'finalxls1.xlsx'];
% writetable(T, filenme, 'Sheet',1,'Range','A1');

%% Clear variables
% clear