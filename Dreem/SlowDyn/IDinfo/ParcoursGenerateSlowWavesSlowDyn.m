% ParcoursGenerateSlowWavesSlowDyn
% 13.06.2018 KJ
%
% Infos
%   Loop over all record: generateSlowWaves
%
% SEE 
%   PlotIDDreemSlowDyn GenerateIDDreemSlowDyn
%

load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

for p=1:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    if exist(Dir.filename{p},'file')==2
        %load slow waves
        sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
        if exist(sw_file,'file')~=2
           [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves'));
        end
    end

    
end





