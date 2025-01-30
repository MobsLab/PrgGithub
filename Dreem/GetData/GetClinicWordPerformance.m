function [performance_word, delta] = GetClinicWordPerformance(Dir)
    
    % INFO
    %   return performance at the memory test for each night of the list of
    %   experiment in input
    %
    
    if ~exist('Dir','var')
        Dir=ListOfClinicalTrialDreemAnalyse('study');
    end
    
    %% load data
    load([FolderPrecomputeDreem 'MemoryData.mat']) 


    %% Loop over record
    for p=1:length(Dir.filename)
        for i=1:2
            performance_word(p,i) = word{strcmpi(Dir.condition{p},conditions_names),i}(Dir.subject{p}==subjects); 
        end
    end
    
    performance_word = cell2mat(performance_word);
    
    %change between morning and evening
    delta = (performance_word(:,2)-performance_word(:,1)) ./ performance_word(:,1); 

    
end