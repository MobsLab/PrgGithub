% DreemCreateQualityH5
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
    new_name = [filereference '_quality.h5'];
    
    %make folder and move tar.gz file
    cd(fullfile(FolderStimImpactRecords,'quality'))
    
    if exist(new_name,'file')~=2
        quality_signals = double(h5read([filereference '.h5'],'/quality/'));
        
        if size(quality_signals,1)<size(quality_signals,2)
            quality_signals = quality_signals'; %vertical vector
        end
        
        for ch=1:size(quality_signals,2)
            qualitysig = quality_signals(:,ch);
            h5create(new_name, ['/channel' num2str(ch)], size(qualitysig))
            h5write(new_name, ['/channel' num2str(ch)], qualitysig)
            
        end

        %delete tar.gz file
        delete([filereference '.h5']);
    end
    
end