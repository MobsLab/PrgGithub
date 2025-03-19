% StimImpactSlowWavesThresholdAnalysis
% 28.03.2018 KJ
%
% Infos
%    
%   
% SEE 
%    StimImpactSlowWavesThresholdAnalysis2  StimImpactSlowWavesThresholdAnalysis3
%
%

clear
Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)
    
    clearvars -except Dir p thres_res
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    thres_res.filename{p} = Dir.filename{p};
    thres_res.filereference{p} = Dir.filereference{p};
    thres_res.condition{p} = Dir.condition{p};
    thres_res.subject{p} = Dir.subject{p};
    thres_res.date{p} = Dir.date{p};

    %params
    NameStages = {'N1','N2','N3','REM','Wake'};
    name_channels = {'Fpz-O1', 'Fpz-O2', 'Fpz-F7', 'F8-F7', 'F7-O1', 'F8-O2'};
    thD_list = 0.4:0.2:4;

    
    %% load data    
    [signals, ~, ~, StageEpochs, labels] = GetRecordDreem(Dir.filename{p});
    [channel_quality, NoiseEpoch, TotalNoise] = GetDreemQuality(Dir.filereference{p});
    
    
    %% find Slow Wave
    for ch=1:2
        GoodEpochs = intervalSet(0, max(Range(signals{ch})));
        GoodEpochs = GoodEpochs - NoiseEpoch{ch};
        
        [SlowWaveEpochs, std_eeg{ch}, distrib_eeg{ch}] = DetectSlowWavesThresholds_KJ(signals{ch}, thD_list);
        for t=1:length(thD_list)
            SlowWaveChannel{ch,t} = and(SlowWaveEpochs{t}, GoodEpochs);
        end
    end
    %in both channels
    for t=1:length(thD_list)
        SlowWavesEpoch{t} = and(SlowWaveChannel{1,t},SlowWaveChannel{2,t});
        NewHypnogram{t}  = ReclassifyDreemRecordsN3(StageEpochs, SlowWavesEpoch{t});
    end
    
    %save
    thres_res.std_eeg{p}     = std_eeg;
    thres_res.distrib_eeg{p} = distrib_eeg;
    
    thres_res.slowwaves{p}   = SlowWavesEpoch;
    thres_res.newhypno{p}    = NewHypnogram;
    thres_res.dreemnogram{p} = StageEpochs;
    

end

save(fullfile(FolderStimImpactData,'StimImpactSlowWavesThresholdAnalysis.mat'), 'thres_res', 'thD_list','name_channels', 'NameStages');





