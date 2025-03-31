% GenerateIDClinicalRecordVC
% 27.06.2017 KJ
%
%
% infos = GenerateIDClinicalRecordVC(filereference)
%
% infos = GenerateIDClinicalRecordVC(p, Dir)
%
%
% OPTIONAL ARGUMENT:
% - toSave              (optional) 1 to save the data, 0 otherwise
%                       default 1
% - toPlot              (optional) 1 to plot the figure, 0 otherwise
%                       default 0
%
% OUTPUT:
% - infos               struct - infos about the record
%
%
% INFOS
%   Compute and eventually save data for description figures of a record of clinical trial
% 
%
% SEE 
%   PlotIDClinicalRecordVC ParcoursGenerateIDClinicalRecordVC
%
%


function infos = GenerateIDClinicalRecordVC(filereference,Dir,varargin)

%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'tosave'
            toSave = varargin{i+1};
            if toSave~=0 && toSave~=1
                error('Incorrect value for property ''toSave''.');
            end
        case 'toplot'
            toPlot = varargin{i+1};
            if toPlot~=0 && toPlot~=1
                error('Incorrect value for property ''toPlot''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~exist('Dir','var') || isempty(Dir)
    Dir = ListOfClinicalTrialDreemAnalyse('all');
    p = find(cell2mat(Dir.filereference)==filereference);
else
    p = filereference;
end
if ~exist('toSave','var')
    toSave = 1;
end
if ~exist('toPlot','var')
    toPlot = 1;
end

%% params
params.effect_period = 8000; %800ms
params.met_window = 3000; %in ms
params.bandpass_phase = [0.5 4]; %filter bandpass before hilbert computing of phase

%density
params.binsize_density = 60E4; %60s

%params SWA
params.swa_interval = 60E4; %10min
params.freqSwa = [0.4 4];
params_swa.tapers = [3 5];
params_swa.Fs = 250;
params_swa.fpass = params.freqSwa;

%spectrogram params
params.movingwin_specg = [3 0.2];
params_specg.fpass = [0.4 30];
params_specg.tapers = [3 5];
params_specg.Fs = 250;

%params isi
step=100;
edges=0:step:10000;


%% load data
[signals, stimulations, StageEpochs, infos.name_channel, domain, ~] = GetRecordClinic(Dir.filename{p});
% infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
% domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
% Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake

%Epochs from the dreem headband
N2N3_dreem = or(StageEpochs{2},StageEpochs{3});
NREM_dreem = or(N2N3_dreem,StageEpochs{1});

%Hypnograms
[Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
nb_hypnogram = length(Hypnograms);
infos.hypno_pascal=1;
if ~isempty(Hypnograms)
    hyp_pascal = Hypnograms{4};
    sleep_pascal = or(or(hyp_pascal{1},hyp_pascal{2}),or(hyp_pascal{1},hyp_pascal{2}));
    if tot_length(sleep_pascal)>1000E4 %more than 1000sec of sleep
        StageEpochs = Hypnograms{4};
    end
end


%VIRTUAL CHANNEL SIGNAL
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
[signals_dreem_vc, signals_psg_vc, badEpochsDreem, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, infos.name_channel);
rg = Range(signals_dreem_vc);
All_night = intervalSet(rg(1),rg(end));
goodEpochs = All_night - badEpochsDreem;


%channel vc used afterwards
params.channels_frontal = length(signals)+1; %virtual channel dreem
params.channel_specg = params.channels_frontal;
params.channel_swa = params.channels_frontal;
params.channel_density = params.channels_frontal;
params.channel_isi = params.channels_frontal;


%update signals with VC
signals{end+1} = signals_dreem_vc; signals{end+1} = signals_psg_vc;
domain{end+1} = 'EEG'; domain{end+1} = 'EEG';
infos.name_channel{end+1} = 'VC Dreem'; infos.name_channel{end+1} = 'VC PSG';


%stimulation
stimulations = Restrict(stimulations, goodEpochs);
time_stim = Range(stimulations);
int_stim = Data(stimulations);
if strcmpi(Dir.condition{p},'sham')
    time_stim = time_stim(Data(stimulations)==0); %sham
    int_stim = int_stim(Data(stimulations)==0);
else
    time_stim = time_stim(Data(stimulations)>0); %true tones, not sham
    int_stim = int_stim(Data(stimulations)>0);
end
stimulations = tsd(time_stim, int_stim);


%
N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3}; REM=StageEpochs{4}; WAKE=StageEpochs{5};
infos.night_duration = max(Range(signals{1})); %in 1E-4 s
%epochs for SWA
params.swa_time = 0:params.swa_interval:infos.night_duration;
for t=1:length(params.swa_time)-1
    swa_epoch{t} = intervalSet(params.swa_time(t), params.swa_time(t+1)-1);
end
params.swa_time = params.swa_time(1:end-1);

%find Slow Wave
for ch=1:length(infos.name_channel)
    if strcmpi(domain{ch},'EEG')
        SlowWaveEpochs{ch} = FindSlowWaves(signals{ch});
        start_slowwaves{ch} = Range(Restrict(ts(Start(SlowWaveEpochs{ch})),N2N3_dreem));
        center_slowwaves{ch} = (Start(SlowWaveEpochs{ch}) + End(SlowWaveEpochs{ch})) / 2;
        center_slowwaves{ch} = Range(Restrict(ts(center_slowwaves{ch}),N2N3_dreem));
    end
end


%% Textbox and infos table

%night info
infos.subject = Dir.subject{p};
infos.night = Dir.night{p};
infos.date = Dir.date{p};
infos.condition = Dir.condition{p};

%number of Slow Wave per channel
for ch=1:length(SlowWaveEpochs)
    nb_SlowWaves{ch} = length(start_slowwaves{ch});
end

%tones
nb_tones = length(stimulations);
infos.nb_tones = nb_tones;
tone_intv_post = intervalSet(Range(stimulations), Range(stimulations) + params.effect_period);  % Tone and its window where an effect could be observed

% tones ratio success per channel
for ch=1:length(SlowWaveEpochs)
    if strcmpi(domain{ch},'EEG')
        induce_slow_wave = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_slowwaves{ch}, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        tone_success(tone_success==0)=[];
        nb_tone_success{ch} = length(tone_success);
        ratio_success{ch} = length(tone_success) / nb_tones;
    end
end

%table data
infos.column_table = {'Channel','Slow Waves','Tones success','Ratio success'};
infos.data_table = cell(0);
a=0;
for ch=1:length(SlowWaveEpochs)
    if strcmpi(domain{ch},'EEG')
        a=a+1;
        infos.data_table{a,1} = infos.name_channel{ch};
        infos.data_table{a,2} = nb_SlowWaves{ch};
        infos.data_table{a,3} = nb_tone_success{ch};
        infos.data_table{a,4} = round(ratio_success{ch} * 100,2);
    end
end

%% Mean Curves sync on Tones
for i=1:length(params.channels_frontal)
    ch = params.channels_frontal(i);
    Ms_tone{i} = PlotRipRaw(signals{ch},Range(stimulations)/1E4, params.met_window); close
    
    %phase phase_vc
    [phase_vc, ~] = ComputeHilbertData(signals{ch},'bandpass',params.bandpass_phase);
    stim_tmp = Range(stimulations);
    phase_value = Data(phase_vc);
    phase_tmp = Range(phase_vc);
    phase_tone = zeros(length(stim_tmp), 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(phase_tmp-stim_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end    
end


%% Density of events: Slow waves-tones  &  SWA 

%Slow Wave density
ST1{1}=ts(start_slowwaves{params.channel_density});
try
    ST1=tsdArray(ST1);
end
QSlowWave = MakeQfromS(ST1,params.binsize_density);
QSlowWave = tsd(Range(QSlowWave),full(Data(QSlowWave)));
clear ST

%Tones density
ST1{1}=ts(Range(stimulations));
try
    ST1=tsdArray(ST1);
end
QTones = MakeQfromS(ST1,params.binsize_density);
QTones = tsd(Range(QTones),full(Data(QTones)));
clear ST

%SWA: 2-4Hz Oscillation power
nrem_signals = Restrict(signals{params.channel_swa}, NREM_dreem);
for t=1:length(swa_epoch)
    try
        [Spectral_power, ~] = mtspectrumc(Data(Restrict(nrem_signals, swa_epoch{t})),params_swa);
        swa_power(t) = sum(Spectral_power);
    catch
        swa_power(t) = 0;
    end
end
%swa_power = swa_power / max(swa_power);
swa_power = smooth(swa_power,1);


%% ISI & Correlogram

tSlowwave = center_slowwaves{params.channel_isi};

h1_slowwave = histogram(diff(tSlowwave/10), edges);
histo.x = h1_slowwave.BinEdges(1:end-1);
histo.y = h1_slowwave.Values; close
h2_slowwave = histogram(Data(Restrict(tsd(tSlowwave(1:end-1),diff(tSlowwave/10)),N2)), edges);
histo_n2.x = h2_slowwave.BinEdges(1:end-1);
histo_n2.y = h2_slowwave.Values; close
h3_slowwave = histogram(Data(Restrict(tsd(tSlowwave(1:end-1),diff(tSlowwave/10)),N3)), edges);
histo_n3.x = h3_slowwave.BinEdges(1:end-1);
histo_n3.y = h3_slowwave.Values; close


%% Spectrogram
signal_specg = ResampleTSD(signals{params.channel_specg}, params_specg.Fs);
[Specg,t_spg,f_spg] = mtspecgramc(Data(signal_specg), params.movingwin_specg, params_specg);
infos.name_channel_specg = infos.name_channel{params.channel_specg};


%% Sleep Stages
Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
Epochs={N1,N2,N3,REM,WAKE};
num_substage=[2 1.5 1 3 4]; %ordinate in graph
indtime=min(Start(Rec)):1E4:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);
sample_size = median(diff(rg))/10; %in ms
time_stages = zeros(1,5);
meanDuration_sleepstages = zeros(1,5);
for ep=1:length(Epochs)
    idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(idx)=num_substage(ep);
    time_stages(ep) = length(idx) * sample_size;
    meanDuration_sleepstages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
end
SleepStages=tsd(rg,SleepStages');
percentvalues_NREM = zeros(1,3);
for ep=1:3
    percentvalues_NREM(ep) = time_stages(ep)/sum(time_stages(1:3));
end
percentvalues_NREM = round(percentvalues_NREM*100,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toSave
    cd(FolderProcessDreem)
    savefile = ['IDfigures_' num2str(Dir.filereference{p})];

    save(savefile,'params','params_specg','params_swa','infos')
    save(savefile,'-append','Ms_tone','phase_tone','edges','histo','histo_n2','histo_n3','QSlowWave','QTones')
    save(savefile,'-append','Specg','t_spg','f_spg','swa_power')
    save(savefile,'-append','SleepStages','Epochs','time_stages','percentvalues_NREM','meanDuration_sleepstages','nb_hypnogram')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toPlot
    PlotIDClinicalRecordVC(Dir.filereference{p});
end

end










