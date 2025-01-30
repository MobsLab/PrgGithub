% ParcoursGenerateSpindlesSlowDyn
% 20.11.2018 KJ
%
% Infos
%   Loop over all record: generateSlowWaves
%
% SEE 
%   PlotIDDreemSlowDyn GenerateIDDreemSlowDyn
%   ParcoursGenerateSlowWavesSlowDyn 
%

load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

for p=526:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    if exist(Dir.filename{p},'file')==2
        %load slow waves
        spi_file = fullfile(FolderSlowDyn, 'Spindles', ['Spindles_' num2str(Dir.filereference{p}) '.mat']);
        if exist(spi_file,'file')~=2
            [SpindlesEpoch, ~] = MakeSpindlesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDyn, 'Spindles'));
        end
    end

    
end

