%ParcoursProcessingBasalSleepSpike
% 29.11.2017 KJ
%
% processing for dataset
%
% see PathForExperimentsBasalSleepSpike
%


Dir=PathForExperimentsSleepRipplesSpikes('all');

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    % params
    
    x = '*.xml';
    filelist = dir(x);
    for i=1:length(filelist)
        if contains(filelist(i).name, 'SpikeRef')
           xml_spike = filelist(i).name;
        elseif ~contains(filelist(i).name, 'SpikeRef') && ~contains(filelist(i).name, 'SubRef')
           xml_file = filelist(i).name; 
        end
    end
    if ~exist('xml_spike','var')
        xml_spike = xml_file;
    end
    %set current session
    clearvars -global DATA
    SetCurrentSession(xml_file)
    
    
    %% make LFP
    MakeData_LFP;
    
    %% make Accelero
    MakeData_Accelero(pwd,'recompute',0);
        
    %% make Spike Data
    MakeData_Spikes(xml_spike,'recompute',1);

    %% make Spike Classification
    load MeanWaveform W
    DropBoxLocation = fullfile(FolderDropBox,'Dropbox','Kteam');
    rmpath([FolderDropBox 'Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/']) %conflict with kmeans of Fra
    MakeData_ClassifySpikeWaveforms(W,DropBoxLocation,0);
    
    %% SpikeToAnalyse
    mkdir('SpikesToAnalyse');
    CreateSpikeToAnalyse_KJ;
    
    %% Sleep scoring
    SleepScoring_Accelero_OBgamma('PlotFigure',1)  
    
    
    %% Sleep event
    CreateSleepSignals('recompute',0,'scoring','ob');
    
    
    %% Substages
    [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
    save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
    [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
    save('SleepSubstages', 'Epoch', 'NameEpoch')
    
    
    %% Id figure 1
    MakeIDSleepData
    PlotIDSleepData
    %title
    title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
    filename_fig = ['IDfigures_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    % suptitle
    suplabel(title_fig,'t');
    %save figure
    savefig(filename_fig)
    filename_png = fullfile(FolderFigureDelta, 'IDfigures','BasalDataSet','IDFigures1',filename_png);
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
    
    %% Id figure 2
    MakeIDSleepData2
    PlotIDSleepData2
    %title
    title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
    filename_fig = ['IDfigures2_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    % suptitle
    suplabel(title_fig,'t');
    %save figure
    savefig(filename_fig)
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    filename_png = fullfile(FolderFigureDelta, 'IDfigures','BasalDataSet','IDFigures2',filename_png);
    saveas(gcf,filename_png,'png')
    close all
    
    
end

