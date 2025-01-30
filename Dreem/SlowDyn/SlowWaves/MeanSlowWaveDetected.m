% MeanSlowWaveDetected
% 03.10.2018 KJ
%
% Infos
%   for each night :
%       - mean slow wave detected
%       
%
% SEE 
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'),'quantif_res')


for p=1:length(Dir.filereference)
% p=100;
    clearvars -except Dir p quantif_res curve_res

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    curve_res.filename{p} = Dir.filename{p};
    curve_res.filereference{p} = Dir.filereference{p};
    curve_res.subject{p} = Dir.subject{p};
    curve_res.date{p} = Dir.date(p);
    curve_res.age{p} = Dir.age{p};
    curve_res.gender{p} = Dir.gender{p};
    
    %params
    binsize_met = 10;
    nbBins_met  = 300;
    channels_frontal = [1 2 5 6];
    
    %load signals and data
    [signals, ~, ~, ~, labels_eeg] = GetRecordDreem(Dir.filename{p});
    signals = signals(channels_frontal);
    
    curve_res.channel_sw{p} = quantif_res.channel_sw{p};
        
    %load slow waves
    sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    if exist(sw_file,'file')==2
        load(sw_file);
    else
       [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves'));
    end
    
    
    %% mean curves
    for ch=1:length(signals)
        start_slowwaves = Start(SlowWaveEpochs{channels_frontal(ch)});

        [m,s,tps] = mETAverage(start_slowwaves, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
        curve_res.met_slowwave{p,ch}(:,1) = tps; curve_res.met_slowwave{p,ch}(:,2) = m; curve_res.met_slowwave{p,ch}(:,3) = s;
        
        curve_res.nb_slowwaves(p,ch) = length(start_slowwaves);
    end
    
    
end

%saving data
cd(FolderSlowDynData)
save MeanSlowWaveDetected2.mat curve_res binsize_met nbBins_met channels_frontal labels_eeg
