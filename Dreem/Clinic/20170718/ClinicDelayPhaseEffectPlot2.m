% ClinicDelayPhaseEffectPlot2
% 17.07.2017 KJ
%
% Delta Stat - only delta after tones or sham
% Analyse delay and phase
% 
%   see ClinicStatSlowWaves ClinicStatSlowWavesPlot1 ClinicStatSlowWavesPlot2 ClinicDelayPhaseEffectPlot
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
conditionsWithTones = {'Random'};
subjects = unique(cell2mat(quantity_res.subject));

scattersize = 25;

%% init

%tones
tone_nights = ismember(quantity_res.condition,conditionsWithTones);  % nights selected, i.e not Sham
all_delay = cell2mat(quantity_res.tones.delay(tone_nights)')/10;  % delays between tones and preceding slow wave
all_phases = cell2mat(quantity_res.tones.phase(tone_nights)');  % phases of stim
all_induce = cell2mat(quantity_res.tones.induce(tone_nights)');  % induce a slow wave ?

success_delay = all_delay(all_induce==1);
success_phases = all_phases(all_induce==1);


%% PLOT

%map
Xedges = 0:50:3000;
Yedges = -pi:pi/36:pi;
[occ_all, ~,~] = histcounts2(all_delay, all_phases, Xedges,Yedges );
[occ_success, ~,~] = histcounts2(success_delay, success_phases, Xedges,Yedges );
res = occ_success ./ occ_all; 


%plot
figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
Map_Axes = axes('position', [0.1 0.1 0.8 0.8]);
axes(Map_Axes);
imagesc(Xedges,Yedges,occ_all), axis xy, title('Success map'),colorbar



% 
% 
% 
% 
% figure, hold on
% 
% scatter(all_delay, all_phases, scattersize, all_induce,'filled'), hold on
% xlabel('delay'), ylabel('phase'),
% set(gca, 'xlim', [0 4000]);










