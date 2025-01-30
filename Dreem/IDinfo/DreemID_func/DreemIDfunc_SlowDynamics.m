% DreemIDfunc_SlowDynamics
% 27.03.2018 KJ
%
%   [density_curves, isi_curves, stat] = DreemIDfunc_SlowDynamics('slowwaves',SlowWaves,'stimulations',stimulations,'hypnogram',StageEpochs)
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact DreemIDfunc_Stimcurves
%
%


function [density_curves, isi_curves, stat] = DreemIDfunc_SlowDynamics(varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'filereference'
            filereference = varargin{i+1};
        case 'slowwaves'
            SlowWaves = varargin{i+1};
        case 'stimulations'
            stimulations = varargin{i+1};
        case 'hypnogram'
            StageEpochs = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check inputs
if exist('filereference','var')
    load(fullfile(FolderStimImpactPreprocess, filereference));

elseif ~exist('SlowWaves','var')
    error('A filereference or variable SlowWaves is required.');
end

if ~exist('StageEpochs','var')
    StageEpochs = [];
else
    N1 = StageEpochs{1}; N2 = StageEpochs{2}; N3 = StageEpochs{3};
end


%params
effect_period = 8000;
%params density
windowsize = 60e4; %60s
%params isi
step=100;
edges=0:step:10000;


%% night duration and intervals
for st=1:length(StageEpochs)
    try
        endst(st) = max(End(StageEpochs{st})); 
    catch
        endst(st) = nan;
    end
end
night_duration = max(endst);

%intervals
intervals_start = 0:windowsize:night_duration;    
x_intervals = (intervals_start + windowsize/2)/(3600E4);


%% slow-waves
for ch=1:length(SlowWaves)
    center_slowwaves{ch} = (Start(SlowWaves{ch}) + End(SlowWaves{ch})) / 2;
    start_slowwaves{ch} = Start(SlowWaves{ch});
    if ~isempty(StageEpochs)
        center_slowwaves{ch} = Range(Restrict(ts(center_slowwaves{ch}),or(N2,N3)));
        start_slowwaves{ch}  = Range(Restrict(ts(start_slowwaves{ch}),or(N2,N3)));
    end
end


%% stim
stim_tmp = Range(stimulations);
int_stim = Data(stimulations);

sham_tmp = stim_tmp(Data(stimulations)==0); %sham
stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham


%% Stat on slow-waves and tones

%number of Slow Wave per channel
for ch=1:length(SlowWaves)
    stat.nb_SlowWaves{ch} = length(center_slowwaves{ch});
end

%tones
stat.nb_tones = length(stim_tmp);
tone_intv_post = intervalSet(stim_tmp, stim_tmp + effect_period);  % Tone and its window where an effect could be observed

% tones ratio success per channel
if ~isempty(Start(tone_intv_post))
    for ch=1:length(SlowWaves)
        induce_slow_wave = zeros(stat.nb_tones, 1);
        [~,interval,~] = InIntervals(start_slowwaves{ch}, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        tone_success(tone_success==0)=[];
        stat.nb_tone_success{ch} = length(tone_success);
        stat.ratio_success{ch} = length(tone_success) / stat.nb_tones;
    end
    
else
    for ch=1:length(SlowWaves)
        stat.nb_tone_success{ch} = 0;
        stat.ratio_success{ch} = 0;
    end
end


%% Density of events: Slow waves, tones and sham

%Slow Wave density
for ch=1:length(SlowWaves)
    slowwaves_density = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        slowwaves_density(t) = length(Restrict(ts(center_slowwaves{ch}),intv)); %per min
    end
    density_curves.slowwaves.x{ch} = x_intervals;
    density_curves.slowwaves.y{ch} = slowwaves_density;
end


%Tones & sham density
tones_density = zeros(length(intervals_start),1);
sham_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    tones_density(t) = length(Restrict(ts(stim_tmp),intv)); %per min
    sham_density(t) = length(Restrict(ts(sham_tmp),intv)); %per min
end

density_curves.tones.x = x_intervals;
density_curves.tones.y = tones_density;
density_curves.sham.x = x_intervals;
density_curves.sham.y = sham_density;


%% Inter SlowWaves Intervals

for ch=1:length(SlowWaves)
    tSlowwave = center_slowwaves{ch};

    %all SW   
    [isi_curves.all.y{ch}, isi_curves.all.x{ch}] = histcounts(diff(tSlowwave/10), edges);
    isi_curves.all.x{ch} = isi_curves.all.x{ch}(1:end-1) + diff(isi_curves.all.x{ch});
    
    %N2
    [isi_curves.n2.y{ch}, isi_curves.n2.x{ch}] = histcounts(Data(Restrict(tsd(tSlowwave(1:end-1),diff(tSlowwave/10)),N2)), edges);
    isi_curves.n2.x{ch} = isi_curves.n2.x{ch}(1:end-1) + diff(isi_curves.n2.x{ch});
    
    %N3
    [isi_curves.n3.y{ch}, isi_curves.n3.x{ch}] = histcounts(Data(Restrict(tsd(tSlowwave(1:end-1),diff(tSlowwave/10)),N3)), edges);
    isi_curves.n3.x{ch} = isi_curves.n3.x{ch}(1:end-1) + diff(isi_curves.n3.x{ch});

end


end












