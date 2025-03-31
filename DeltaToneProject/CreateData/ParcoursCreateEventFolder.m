%%ParcoursCreateEventFolder
% 22.03.2018 KJ
%
%
% see
%    
%


clear
Dir = PathForExperimentsBasalSleepSpike;

name_folder = 'Events';

%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p name_folder
    
    
    mkdir(name_folder)
    d=dir('*.evt.*');
    filenames = {d(:).name}';
    
    for f=1:length(filenames)
        movefile(filenames{f}, name_folder);
    end
    
end




