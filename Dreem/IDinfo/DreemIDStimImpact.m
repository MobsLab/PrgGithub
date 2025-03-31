% DreemIDStimImpact
% 23.03.2018 KJ
%
%
% infos = DreemIDStimImpact(filereference)
%
% infos = DreemIDStimImpact(p, Dir)
%
%
% OPTIONAL ARGUMENT:
% - recompute           (optional) 1 to recompute eventually, 0 otherwise
%                       default 0

%
% OUTPUT:
% - infos               struct - infos about the record
%
%
% INFOS
%   Compute and eventually save data for description figures of a record of Dreem
% 
%
% SEE 
%   PlotIDDreemStimImpact
%
%


function infos = DreemIDStimImpact(filereference,Dir,varargin)

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
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~exist('Dir','var') || isempty(Dir)
    Dir = ListOfDreemRecordsStimImpact('all');
    p = find(cell2mat(Dir.filereference)==filereference);
else
    p = filereference;
end
if ~exist('recompute','var')
    recompute = 0;
end


%recompute ?
savefile = fullfile(FolderStimImpactID,['IdFigureData_' num2str(Dir.filereference{p}) '.mat']);
infos=cell(0);
if recompute
    save(savefile,'infos') 
elseif exist(savefile,'file')~=2
    save(savefile,'infos') 
end



%% init

%infos record
infos.subject = Dir.subject{p};
infos.date = Dir.date{p};
infos.condition = Dir.condition{p};
try
    infos.channel_specg = Dir.channel_specg{p};
catch
    infos.channel_specg = 1;
end

%load signals
[signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
infos.name_channel = labels_eeg;
infos.night_duration = max(Range(signals{1})); %in 1E-4 s

%load slow waves
sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
if exist(sw_file,'file')==2
    load(sw_file);
else
   [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderStimImpactPreprocess, 'SlowWaves'));
end


%% Mean Curves sync on Tones
disp('Mean curves analysis')
load(savefile,'meancurves_stim');
if recompute || ~exist('meancurves_stim','var')    
    [meancurves_stim, nb_events, intensities] = DreemIDfunc_Stimcurves('signals',signals,'stimulations',stimulations);
    save(savefile,'-append', 'meancurves_stim', 'nb_events', 'intensities', 'infos')
else
    disp('already done')
end


%% Phase of stim
disp('Stim Phase analysis')
load(savefile,'phase_event');
if recompute || ~exist('phase_event','var')    
    phase_event = DreemIDfunc_Phasetones('signals',signals,'stimulations',stimulations);
    save(savefile,'-append', 'phase_event', 'infos')
else
    disp('already done')
end


%% Dynamics of Slow waves and tones
disp('SW & Tones dynamics analysis')
load(savefile,'stat_sw');
if recompute || ~exist('stat_sw','var')    
    [density_curves, isi_curves, stat_sw] = DreemIDfunc_SlowDynamics('slowwaves',SlowWaveEpochs,'stimulations',stimulations,'hypnogram',StageEpochs);
    save(savefile,'-append', 'density_curves', 'isi_curves', 'stat_sw', 'infos')
else
    disp('already done')
end


%% Sleep Stages
disp('Sleep stages analysis')
load(savefile,'time_in_substages');
if recompute || ~exist('time_stages','var')
    [SleepStages, Epochs, time_stages, percentvalues_NREM, meanDuration_sleepstages] = DreemIDfunc_Sleepstage('hypnogram', StageEpochs);
    save(savefile,'-append', 'SleepStages', 'Epochs', 'time_stages', 'percentvalues_NREM', 'meanDuration_sleepstages', 'infos')
else
    disp('already done')
end


%% Spectral analysis
disp('Spectral analysis')
load(savefile,'t_spg');
if recompute || ~exist('t_spg','var')
    filespectro = fullfile(FolderStimImpactPreprocess, 'Spectrograms',num2str(Dir.filereference{p}), ['Spectro_' num2str(Dir.filereference{p}) '_ch_' num2str(infos.channel_specg) '.mat']);
    [Specg, t_spg, f_spg, swa_power] = DreemIDfunc_Spectro(filespectro);
    save(savefile,'-append','Specg','t_spg','f_spg','swa_power', 'infos')
else
    disp('already done')
end



end






