% DreemUnzipRawFiles
% 28.03.2018 KJ
%
%

clear
Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)  
    
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filereference{p})
    
    clearvars -except Dir p
    
    filereference = num2str(Dir.filereference{p});
    
    %make folder and move tar.gz file
    cd(fullfile(FolderStimImpactRecords,'raw'))
    
    if exist(filereference,'dir')~=7
        mkdir(filereference)
        movefile([filereference '.tar.gz'], filereference);

        %go in raw folder and unzip
        cd(fullfile(FolderStimImpactRecords,'raw',filereference));
        cmd_tar = ['tar zxvf ' filereference '.tar.gz'];
        system(cmd_tar);

        %delete tar.gz file
        delete([filereference '.tar.gz']);
    end
    
end