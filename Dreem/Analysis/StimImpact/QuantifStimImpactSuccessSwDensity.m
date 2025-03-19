% QuantifStimImpactSuccessSwDensity
% 14.05.2018 KJ
%
% tones success rate and slow waves density
%   -> collect and save
%
%   see 
%       QuantifStimImpactSuccessSwDensityPlot
%

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
intv_size = 15e4;
success_size = 1e4;

for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    density_res.filename{p} = Dir.filename{p};
    density_res.filereference{p} = Dir.filereference{p};
    density_res.condition{p} = Dir.condition{p};
    density_res.subject{p} = Dir.subject{p};
    density_res.date{p} = Dir.date{p};
    density_res.age{p} = Dir.age{p};
    
    
    %% load signals
    [~, ~, stimulations, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});
    
    %slow waves
    sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    load(sw_file);
    start_slowwave = Start(SlowWaveEpochs);
    
    
    %stimulations
    [tones_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    
    
    %% Delay    
    %tones
    for i=1:length(tones_tmp)
        intv = intervalSet(tones_tmp(i)-intv_size, tones_tmp(i)+intv_size); 
        intv_bef = intervalSet(tones_tmp(i)-intv_size, tones_tmp(i)); 
        success_intv = intervalSet(tones_tmp(i), tones_tmp(i)+success_size);
        intv = intv - success_intv;
        
        tones.around(i) = length(Restrict(ts(start_slowwave), intv));
        tones.before(i) = length(Restrict(ts(start_slowwave), intv_bef));
        tones.success(i) = length(Restrict(ts(start_slowwave), success_intv));
    end
    
    %sham
    for i=1:length(sham_tmp)
        intv = intervalSet(sham_tmp(i)-intv_size, sham_tmp(i)+intv_size); 
        intv_bef = intervalSet(sham_tmp(i)-intv_size, sham_tmp(i)); 
        success_intv = intervalSet(sham_tmp(i), sham_tmp(i)+success_size);
        intv = intv - success_intv;
        
        sham.around(i) = length(Restrict(ts(start_slowwave), intv));
        sham.before(i) = length(Restrict(ts(start_slowwave), intv_bef));
        sham.success(i) = length(Restrict(ts(start_slowwave), success_intv));
    end
    
    density_res.tones.around{p} = tones.around;
    density_res.tones.success{p} = tones.success;
    density_res.tones.before{p} = tones.before;
    density_res.sham.around{p} = sham.around;
    density_res.sham.success{p} = sham.success;
    density_res.sham.before{p} = sham.before;
    
end

%saving data
cd(FolderStimImpactData)
save QuantifStimImpactSuccessSwDensity.mat density_res intv_size success_size



