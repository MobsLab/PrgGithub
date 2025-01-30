% QuantifStimImpactTrainSuccessSwDensity
% 14.05.2018 KJ
%
% tones success rate and slow waves density
%   -> collect and save
%
%   see 
%       QuantifStimImpactTrainSuccessSwDensityPlot
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
    dens_res.filename{p} = Dir.filename{p};
    dens_res.filereference{p} = Dir.filereference{p};
    dens_res.condition{p} = Dir.condition{p};
    dens_res.subject{p} = Dir.subject{p};
    dens_res.date{p} = Dir.date{p};
    dens_res.age{p} = Dir.age{p};
    
    
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
    for i=1:length(Start(StimEpoch))
        stim_intv = subset(StimEpoch,i);
        success_intv = intervalSet(Start(stim_intv), End(stim_intv)+success_size);        
        intv_bef = intervalSet(Start(stim_intv)-intv_size, Start(stim_intv)); 
        
        tones.before(i) = length(Restrict(ts(start_slowwave), intv_bef));
        tones.success(i) = length(Restrict(ts(start_slowwave), success_intv));
        tones.nb(i) = sum(~isnan(stim_train(i,:)));
    end
    
    %sham
    for i=1:length(Start(ShamEpoch))
        sham_intv = subset(ShamEpoch,i);
        success_intv = intervalSet(Start(sham_intv), End(sham_intv)+success_size);        
        intv_bef = intervalSet(Start(sham_intv)-intv_size, Start(sham_intv)); 
        
        sham.before(i) = length(Restrict(ts(start_slowwave), intv_bef));
        sham.success(i) = length(Restrict(ts(start_slowwave), success_intv));
        sham.nb(i) = sum(~isnan(sham_train(i,:)));
    end
    
    dens_res.tones.success{p} = tones.success;
    dens_res.tones.before{p}  = tones.before;
    dens_res.tones.nb{p}      = tones.nb;
    dens_res.sham.success{p} = sham.success;
    dens_res.sham.before{p}  = sham.before;
    dens_res.sham.nb{p}      = sham.nb;
    
end

%saving data
cd(FolderStimImpactData)
save QuantifStimImpactTrainSuccessSwDensity.mat dens_res intv_size success_size



