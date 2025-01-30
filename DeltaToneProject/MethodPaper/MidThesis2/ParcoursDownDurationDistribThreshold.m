%%ParcoursDownDurationDistribThreshold
% 20.09.2018 KJ
%
%   Distribution of down state duration -> to determine minimum down duration   
%
% see
%   DownstatesPermutations MakeIDSleepData PlotIDSleepData
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p down_res
    
    down_res.path{p}   = Dir.path{p};
    down_res.manipe{p} = Dir.manipe{p};
    down_res.name{p}   = Dir.name{p};
    down_res.date{p}   = Dir.date{p};
    
    
    %% load from ID data
    load IdFigureData nb_neuron firingrates nbDown duration_bins
    
    
    %save
    down_res.nb_neuron{p} = nb_neuron;
    down_res.firingrates{p} = firingrates;
    
    down_res.nbDown.sws{p} = nbDown.sws;
    down_res.nbDown.wake{p} = nbDown.wake;
    down_res.duration_bins{p} = duration_bins;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursDownDurationDistribThreshold.mat down_res




