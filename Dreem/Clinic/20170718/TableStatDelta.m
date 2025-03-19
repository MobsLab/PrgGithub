%TableStatDelta
% 10.07.2017 KJ
%
% Table quantifying delta statistics
%
%
%   see ClinicStatSlowWaves
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
subjects = unique(cell2mat(quantity_res.subject));
Stat = {'Number','AUC','Amplitude','Slope'};


%% format data
for p=1:length(quantity_res.filename)
        %data.filereference(p) = quantity_res.filename{p}(end-4:end);
        %data.subbject(p) = ['sujet' num2str(quantity_res.subject{p})];
    
    
        data.auc(p) = nanmean(quantity_res.slowwaves.auc{p});
        data.amplitude(p) = nanmean(quantity_res.slowwaves.amplitude{p});
        data.slope(p) = nanmean(quantity_res.slowwaves.slope{p});
        data.density(p) = quantity_res.slowwaves.total{p}/quantity_res.night_duration{p};
        data.density_n3(p) = quantity_res.slowwaves.total{p}/quantity_res.sleepstages.total{p}(3);
end

%% data
SlowWaveData.mean = cell(0);
SlowWaveData.sem = cell(0);


for cond=1:length(conditions)
    %selected record 
    path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));

    %data
    slowwaves_cond = cell2mat(quantity_res.slowwaves.total(path_cond));
    auc_cond = data.auc(path_cond);
    amplitude_cond = data.amplitude(path_cond);
    slope_cond = data.slope(path_cond) ./ 1E4;
    density_cond = data.density(path_cond) * 60E4;
    densityN3_cond = data.density_n3(path_cond) * 60E4;
    
    
    %Number
    [R,~,E] = MeanDifNan(slowwaves_cond);
    SlowWaveData.mean{1,cond} = R;
    SlowWaveData.sem{1,cond} = E;
    %AUC
    [R,~,E] = MeanDifNan(auc_cond);
    SlowWaveData.mean{2,cond} = R;
    SlowWaveData.sem{2,cond} = E;
    %Amplitude
    [R,~,E] = MeanDifNan(amplitude_cond);
    SlowWaveData.mean{3,cond} = R;
    SlowWaveData.sem{3,cond} = E;
    %Slope
    [R,~,E] = MeanDifNan(slope_cond);
    SlowWaveData.mean{4,cond} = R;
    SlowWaveData.sem{4,cond} = E;
    %Density
    [R,~,E] = MeanDifNan(density_cond);
    SlowWaveData.mean{5,cond} = R;
    SlowWaveData.sem{5,cond} = E;
end




% %% format data
% for p=1:length(quantity_res.filename)
%         data{p,1} = quantity_res.filename{p}(end-7:end-3);
%         data{p,2} = ['sujet' num2str(quantity_res.subject{p})];
%         data{p,3} = quantity_res.condition{p};
%         data{p,4} = quantity_res.slowwaves.total{p}/(quantity_res.sleepstages.total{p}(3)/60E4);
% end
















