% QuantifStimImpactSlowWaveDetection
% 16.05.2018 KJ
%
% quantify the detections of slow wave - STIM IMPACT
% -> Collect and save data 
%
%   see 
%       
%

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    detect_res.filename{p} = Dir.filename{p};
    detect_res.filereference{p} = Dir.filereference{p};
    detect_res.condition{p} = Dir.condition{p};
    detect_res.subject{p} = Dir.subject{p};
    detect_res.date{p} = Dir.date{p};
    detect_res.age{p} = Dir.age{p};
    
    
    %% load signals    
%     [~, ~, ~, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});
    
    %slow waves
    sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    load(sw_file);
    
    sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves2', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    load(sw_file);

    
    %% data
    detect_res.multi.start{p}  = Start(SlowWaveMulti);
    detect_res.multi.center{p} = (Start(SlowWaveMulti) + End(SlowWaveMulti)) /2;
    detect_res.multi.end{p}    = End(SlowWaveMulti);
    
    detect_res.adhoc.start{p}  = Start(SlowWaveEpochs{1});
    detect_res.adhoc.center{p} = (Start(SlowWaveEpochs{1}) + End(SlowWaveEpochs{1})) /2;
    detect_res.adhoc.end{p}    = End(SlowWaveEpochs{1});
    
end

%saving data
cd(FolderStimImpactData)
save QuantifStimImpactSlowWaveDetection.mat detect_res sleepstage_ind



