%% QuantifSlowWaveProportions
%
% 29/05/2020
%
% -> Script to quantify the proportions of all slow wave types, for all
% stages / NREM only / Wake only.
% -> on 1 session


% --------------- Load Data --------------- :

clear

% LOAD EPOCHS :
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;

% LOAD SW :
load('SlowWaves2Channels_LP.mat')
all_slowwaves_ts = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 



% --------------- Get proportions --------------- :

all_nb_slowwaves = [] ; 
NREM_nb_slowwaves = [] ; 
Wake_nb_slowwaves = [] ;

for type = 1:length(all_slowwaves_ts)
    all_nb_slowwaves(type) = length(Range(all_slowwaves_ts{type})) ; 
    NREM_nb_slowwaves(type) = length(Range(Restrict(all_slowwaves_ts{type},SWS))) ; 
    Wake_nb_slowwaves(type) = length(Range(Restrict(all_slowwaves_ts{type},WAKE))) ;
end

NREMprop = sum(NREM_nb_slowwaves)/(sum(all_nb_slowwaves)) ; % proportion of all slow waves occurring during NREM sleep




% --------------- Plot Pie Charts --------------- :


% All slow waves
figure,
h = pie(all_nb_slowwaves,[0 0 1 0 0 0 0 0]) ;
colormap(cat(1,all_colors{:})); set(h,'EdgeColor', [1 1 1]);
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside')
title('Proportions of Slow Wave Types (all stages)','FontSize',12) 

% Slow Waves during NREM
figure,
h = pie(NREM_nb_slowwaves,[0 0 1 0 0 0 0 0]) ;
colormap(cat(1,all_colors{:})); set(h,'EdgeColor', [1 1 1]);
title(['Proportions of Slow Wave Types in NREM sleep ' sprintf('(~%.2g',NREMprop*100) '% of all)'],'FontSize',12)
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside')
% Slow Waves during Wake 
figure,
h = pie(Wake_nb_slowwaves,[0 0 1 0 0 0 0 0]) ;
colormap(cat(1,all_colors{:})); set(h,'EdgeColor', [1 1 1]);
title(['Proportions of Slow Wave Types in Wake ' sprintf('(~%.2g',100-NREMprop*100) '% of all)'],'FontSize',12)
legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeastoutside')




