%%ScriptTonesEffectPhaseLFP
% 14.05.2019 KJ
%
%
%   see 
%       FiguresTonesInDownPerRecord Fig1TonesInDownEffect


% clear
p=1;
Dir = PathForExperimentsRandomTonesSpikes;
effect_periods = GetEffectPeriodDownTone(Dir);
cd(Dir.path{p});

%% params
binsize_mua = 2;
maxDuration = 30e4;

bandpass_phase = [0.5 4]; %filter bandpass before hilbert computing of phase
range_up = effect_periods(p,:);
range_phases = 0:45:360;


%% load
%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS

%Down
load('DownState.mat', 'down_PFCx')
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);

%tones
load('behavResources.mat', 'ToneEvent')

%LFP
load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
load(['LFPData/LFP' num2str(channel) '.mat']);
PFC = LFP;


%% Tones

%in up
ToneIn = Restrict(ToneEvent, up_PFCx);
tones_tmp = Range(ToneIn);
nb_tones = length(tones_tmp);

%success
induce_down = zeros(nb_tones, 1);
[~,intervals,~] = InIntervals(st_down, [tones_tmp+range_up(1), tones_tmp+range_up(2)]);
tone_success = unique(intervals);
induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element


%% hilbert and tones phases

%Filtering
tic
PFCfilt = FilterLFP(PFC, bandpass_phase, 1024);
h = hilbert(Data(PFCfilt));

phase_value = angle(h);
phase_tmp = Range(PFCfilt);
tPhase = tsd(phase_tmp, phase_value);
toc

%tones
phase_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    [~,min_idx] = min(abs(phase_tmp-tones_tmp(i)));
    phase_tone(i) = phase_value(min_idx);
end
phase_plot = phase_tone *(180/pi)+180;


%histo
for i=1:length(range_phases)-1
    tones.induce(i) = sum(induce_down(phase_plot>=range_phases(i) & phase_plot<range_phases(i+1)));
    tones.number(i) = sum(phase_plot>=range_phases(i) & phase_plot<range_phases(i+1));
end

% Data for PlotLineError 
tones.percentage = (tones.induce ./ tones.number)*100;





%% Plot
figure, hold on
% plot(range_phases(1:end-1), tones.percentage)
plot(range_phases(1:end-1), tones.number)






