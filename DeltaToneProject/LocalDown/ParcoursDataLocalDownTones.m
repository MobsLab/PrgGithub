%ParcoursDataLocalDownTones
% 01.12.2019 KJ
%
% processing for dataset
%
% see PathForExperimentsBasalSleepSpike
%


Dir=PathForExperimentsShamLocalDown;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    CreateSpikeNumberTetrodePFC_KJ;
    
    CreateLocalDownStatesSleep;

    
end