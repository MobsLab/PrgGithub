%%ParcoursCreateDeltaWavesChannels
% 22.03.2018 KJ
%
%
% see
%   MakeDeltaOnChannelsEvent
%


clear
Dir = PathForExperimentsBasalSleepSpike;


%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    %info for each channel
    load(fullfile(Dir.path{p}, 'IdFigureData2.mat'), 'channel_curves','structures_curves', 'peak_value')
    
    %type of sleep scoring to use to restrict on NREM
    scoring = 'ob';
    
    
    %
    for ch=1:length(channel_curves)
        if strcmpi(structures_curves{ch}, 'PFCx')
            if peak_value(ch)>0
                isdeep=1;
            else
                isdeep=0;
            end
            MakeDeltaOnChannelsEvent(channel_curves(ch), 'scoring',scoring, 'positive', isdeep,'recompute',0);
        end
    end
    
    
end




