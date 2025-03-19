% QuantifStimImpactTrainSuccessSWA
% 23.05.2018 KJ
%
% tones success rate and slow waves activity
%   -> collect and save
%
%   see 
%       QuantifStimImpactTrainSuccessSwDensity QuantifStimImpactTrainSuccessSWAPlot
%
% 

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
intv_size = 15e4;
success_size = 1e4;
channelNum = 1;
smoothing = 400;
freqSWA = [0.6 4];


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    swa_res.filename{p} = Dir.filename{p};
    swa_res.filereference{p} = Dir.filereference{p};
    swa_res.condition{p} = Dir.condition{p};
    swa_res.subject{p} = Dir.subject{p};
    swa_res.date{p} = Dir.date{p};
    swa_res.age{p} = Dir.age{p};
    
    
    %% load signals
    [~, ~, stimulations, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});
    NREM = or(StageEpochs{1}, or(StageEpochs{2},StageEpochs{3}));
    
    %slow waves
    sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    load(sw_file);
    start_slowwave = Start(SlowWaveEpochs);
    
    
    %stimulations
    [~, ~, ~, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    
    
    %SWA
    filespectro = fullfile(FolderStimImpactPreprocess, 'Spectrograms',num2str(Dir.filereference{p}), ['Spectro_' num2str(Dir.filereference{p}) '_ch_' num2str(channelNum) '.mat']);
    % load spectrogram
    load(filespectro,'Spectro');
    Specg = Spectro{1};
    t_spg = Spectro{2};
    f_spg = Spectro{3};
    
    Sp = Specg(:, f_spg>=freqSWA(1) & f_spg<=freqSWA(2));
    swa_power = smooth(mean(Sp,2),smoothing);
    tSWA = tsd(t_spg*1e4, swa_power);
    
    
    %% SWA characteristic
    swa_res.average.night{p} = median(Data(tSWA));
    swa_res.average.nrem{p}  = median(Data(Restrict(tSWA,NREM)));
    
    
    %% Delay    
    %tones
    for i=1:length(Start(StimEpoch))
        stim_intv = subset(StimEpoch,i);
        success_intv = intervalSet(Start(stim_intv), End(stim_intv)+success_size);        
        intv_bef = intervalSet(Start(stim_intv)-intv_size, Start(stim_intv)); 
        
        tones.swabefore(i) = mean(Data(Restrict(tSWA, intv_bef)));
        tones.success(i) = length(Restrict(ts(start_slowwave), success_intv));
        tones.nb(i) = sum(~isnan(stim_train(i,:)));
    end
    
    %sham
    for i=1:length(Start(ShamEpoch))
        sham_intv = subset(ShamEpoch,i);
        success_intv = intervalSet(Start(sham_intv), End(sham_intv)+success_size);        
        intv_bef = intervalSet(Start(sham_intv)-intv_size, Start(sham_intv)); 
        
        sham.swabefore(i) = mean(Data(Restrict(tSWA, intv_bef)));
        sham.success(i) = length(Restrict(ts(start_slowwave), success_intv));
        sham.nb(i) = sum(~isnan(sham_train(i,:)));
    end
    
    swa_res.tones.success{p}    = tones.success;
    swa_res.tones.swabefore{p}  = tones.swabefore;
    swa_res.tones.nb{p}         = tones.nb;
    swa_res.sham.success{p}     = sham.success;
    swa_res.sham.swabefore{p}   = sham.swabefore;
    swa_res.sham.nb{p}          = sham.nb;
    
end


%saving data
cd(FolderStimImpactData)
save QuantifStimImpactTrainSuccessSWA.mat swa_res intv_size success_size channelNum smoothing freqSWA

