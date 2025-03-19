%%ToneDuringDownStateTimingPlot
% 12.04.2018 KJ
%
% 
%
%   see 
%       ToneDuringDownStateEffect
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneDuringDownStateEffect.mat'))

%{'inside', 'before', 'after'}
select_tone = 'inside'; 


%% data
figure, hold on

for p=1:length(tones_res.path)
    
    ibefore   = tones_res.(select_tone).ibefore{p}/10;
    iafter    = tones_res.(select_tone).iafter{p}/10;
    ipostdown = tones_res.(select_tone).ipostdown{p}/10;
    
    %plot
    subplot(2,3,p), hold on
    scatter(ibefore, iafter, 25,'filled')
    

end

    
