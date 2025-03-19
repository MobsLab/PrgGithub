% ToneEvokedPotential
% 14.02.2017 KJ
%
% analysis of the evoked potential in the PFCx
%
% see  
%    TestTimingToneLFP FigureEvokedPotential
%  



%% Dir
Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);

% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

Dir = RestrictPathForExperiment(Dir,'nMice',[243 244 251 252]);

Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = ['Random (' num2str(Dir.delay{p}*1000) 'ms)'];
    end
end

%params
tbefore = -1000;
tafter = 1000;
ColorAnimals = {'k','b','r',[0.5 0.5 0.5]};
animals = unique(Dir.name);

fig_all = figure; hold on

%% loop
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)

    
    clearvars -except Dir p tbefore tafter ColorAnimals animals fig_all
    
    %animal
    m = find(strcmpi(Dir.name{p},animals));

    %LFP
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP

    %Tones
    delay = Dir.delay{p}*1E4; %in 1E-4s
    load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
    TonesEvent = TONEtime2_SWS + delay;
    Md = PlotRipRaw(LFPdeep,TonesEvent/1E4, 1000,0,0);
    met_tone_x = Md(:,1);
    met_tone_y = Md(:,2);
    
    
    %% PLOT AND SAVE FIG
    set(0, 'currentfigure', fig_all);  %# for figures
    plot(met_tone_x,met_tone_y,'color',ColorAnimals{m}), hold on

    [corr_matrix, event_triggered_matrix] = PlotEventTriggeredCorrelogram(LFPdeep, ts(TonesEvent), [tbefore tafter], 'pmax',0.05);
    suplabel(['CorrelogramToneLFP ' Dir.name{p}  ' - ' Dir.condition{p} ' - ' Dir.date{p} ' (channel ' num2str(channel) ')'],'t');


end

set(0, 'currentfigure', fig_all);  %# for figures
ylim([-1700 1700]), hold on
line([0 0],get(gca,'YLim')), hold on
title('Mean LFP averaged on tones');
for m=1:length(animals)
    h(m) = plot([nan nan],[nan nan], 'color', ColorAnimals{m});
end
legend(h, animals);













