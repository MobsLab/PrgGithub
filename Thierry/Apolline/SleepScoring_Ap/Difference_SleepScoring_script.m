clear all
clc


%% Creation of the new cell
allNoise_Stim = {};
groundNoise_Stim = {};
noNoise_Stim = {};

allNoise_Base = {};
groundNoise_Base = {};
noNoise_Base = {};

%% Loading of the files States for each SleepScoring
allNoise_Stim{1} = load('M675_Stim_21032018_States.mat');
groundNoise_Stim{1} = load('M675_Stim_21032018_States_groundNoise.mat');
noNoise_Stim{1} = load('M675_Stim_21032018_States_noNoise.mat');

allNoise_Base{1} = load('M675_Baseline_22032018_States.mat');
groundNoise_Base{1} = load('M675_Baseline_22032018_States_groundNoise.mat');
noNoise_Base{1} = load('M675_Baseline_22032018_States_noNoise.mat');

%% Plotting the graphs to compare the SleepScoring

%tracer Wake, SWS, REM et Noise sur le me graph
% c = categorical({'Wake','SWS','REM', 'Noise'});

% figure
% 
% subplot(3,2,1)
% bar(c,allNoise_Stim{1}.States(:,2))
% title('allNoise Stim' )
% 
% subplot(3,2,3)
% bar(c,groundNoise_Stim{1}.States(:,2))
% title('groundNoise Stim' )
% 
% subplot(3,2,5)
% bar(c,noNoise_Stim{1}.States(:,2))
% title('noNoise Stim' )
% 
% subplot(3,2,2)
% bar(c,allNoise_Base{1}.States(:,2))
% title('allNoise Base' )
% 
% subplot(3,2,4)
% bar(c,groundNoise_Base{1}.States(:,2))
% title('groundNoise Base' )
% 
% subplot(3,2,6)
% bar(c,noNoise_Base{1}.States(:,2))
% title('noNoise Base' )

%tracer Stim et baseline sur le me graph
c = categorical({'Stim','Baseline'});

figure

subplot(3,3,1)
bar(c,[allNoise_Stim{1}.States(1,2) allNoise_Base{1}.States(1,2)])
title('Wake allNoise' )
ylim([0 6])

subplot(3,3,4)
bar(c,[groundNoise_Stim{1}.States(1,2) groundNoise_Base{1}.States(1,2)])
title('Wake groundNoise' )
ylim([0 6])

subplot(3,3,7)
bar(c,[noNoise_Stim{1}.States(1,2) noNoise_Base{1}.States(1,2)])
title('Wake noNoise' )
ylim([0 6])

subplot(3,3,2)
bar(c,[allNoise_Stim{1}.States(2,2) allNoise_Base{1}.States(2,2)])
title('SWS allNoise' )
ylim([0 6])

subplot(3,3,5)
bar(c,[groundNoise_Stim{1}.States(2,2) groundNoise_Base{1}.States(2,2)])
title('SWS groundNoise' )
ylim([0 6])

subplot(3,3,8)
bar(c,[noNoise_Stim{1}.States(2,2) noNoise_Base{1}.States(2,2)])
title('SWS noNoise' )
ylim([0 6])

subplot(3,3,3)
bar(c,[allNoise_Stim{1}.States(3,2) allNoise_Base{1}.States(3,2)])
title('REM allNoise' )
%ylim([0 6])

subplot(3,3,6)
bar(c,[groundNoise_Stim{1}.States(3,2) groundNoise_Base{1}.States(3,2)])
title('REM groundNoise' )
%ylim([0 6])

subplot(3,3,9)
bar(c,[noNoise_Stim{1}.States(3,2) noNoise_Base{1}.States(3,2)])
title('REM noNoise' )
%ylim([0 6])

[ax,h1]=suplabel('Total time in the night (h)','y'); 
[ax,h3]=suplabel('M675 - Stim 21032018 - Baseline 22032018' ,'t'); 