%%ParcoursIsolationDistanceTonesEffect
% 02.08.2018 KJ
%
%
% see
%    
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    samplingrate = 2e4;
    
    %tetrodes
    load('SpikeData.mat', 'TT')
    tetrodes = [];
    for i=1:length(TT)
        tetrodes = [tetrodes TT{i}(1)];
    end
    tetrodes = unique(tetrodes);
    
    %filename
    filelist = dir('*.clu.1');
    filename = filelist(1).name;
    filename = fullfile(Dir.path{p}, filename(1:end-6));
    
    for i=1:length(tetrodes)
        features{i} = LoadSpikeFeatures([filename '.clu.' num2str(i)],samplingrate);
    end
    
    
end


