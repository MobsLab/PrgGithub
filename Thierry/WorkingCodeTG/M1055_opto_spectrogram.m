clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))

load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')
load('dHPC_deep_Low_Spectrum')
SpectroH=Spectro;
load('Bulb_deep_Low_Spectrum')
SpectroB=Spectro;
load('Bulb_deep_High_Spectrum')
SpectroBh=Spectro;
load('VLPO_Low_Spectrum')
SpectroV=Spectro;
load('PFCx_deep_Low_Spectrum')
SpectroP=Spectro;

switch ExpeInfo.OptoStimulation
    
    case 'yes'
        disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        load('LFPData/DigInfo4.mat')
        TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
        % TTL = colonne de temps au dessus de 0.99 pour avoir les 1 = stim ON
        
        TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
        % merge tous les temps des stim plus proche de 1 sec pour éviter les créneaux et le remplacer par un step entier d'une min
        
        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
        
    case 'no'
        disp('no stims - simulating')
        if exist('SimulatedStims.mat')==0
        StimulateStimsWithTheta_VLPO
        end
        load('SimulatedStims.mat')
        events = sort([Range(RemStim,'s');Range(WakeStim,'s')]);
        Freq_Stim = ones(1,length(events))*20;
        TTLEpoch_merged = intervalSet(events*1e4,events*1e4+30*1e4);
end

%see the start event on graph
line([events(1) events(1)], ylim)
for i = 1:length(events) line(gca,[events(i) events(i)], ylim, 'color', 'm'); end

% plot mouvement pendant wake / NREM / REM 
load SleepScoring_Accelero SmoothTheta tsdMovement
figure, hold on
plot(Range(Restrict(tsdMovement,Wake),'s'),Data(Restrict(tsdMovement,Wake)),'b')
plot(Range(Restrict(tsdMovement,SWSEpoch),'s'),Data(Restrict(tsdMovement,SWSEpoch)),'r')
plot(Range(Restrict(tsdMovement,REMEpoch),'s'),Data(Restrict(tsdMovement,REMEpoch)),'g')
title({'Movement during stages'})
ylabel('Movement')
xlabel('Time')
savefig(fullfile(pathname2,'Movement during stages'))

%see the start event on graph
line([events(1) events(1)], ylim)
for i = 1:length(events) line(gca,[events(i) events(i)], ylim, 'color', 'k'); end
savefig(fullfile(pathname2,'Movement during stages with stim'))


%mettre une ligne "tag" sur le graphe
%line([8280 8280],ylim,'color','k','linewidth',2)


%%Pour checker combien de Stim par période
%Nb de stim
Stim=size(Start(TTLEpoch_merged),1)
%Nb de stim pendant le REM
StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)),1)
%Nb de stim pendant le SWS
StimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)),1)
%Nb de stim pendant Wake
StimWAKE=size(Start(and(TTLEpoch_merged,Wake)),1)
%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM StimSWS StimWAKE]


%%Pour checker combien de Stim par période incluant le noise
%Nb de stim
Stim=size(Start(TTLEpoch_merged),1)
%Nb de stim pendant le REM
StimREM_Noise=size(Start(and(TTLEpoch_merged,REMEpochWiNoise)),1)
%Nb de stim pendant le SWS
StimSWS_Noise=size(Start(and(TTLEpoch_merged,SWSEpochWiNoise)),1)
%Nb de stim pendant Wake
StimWAKE_Noise=size(Start(and(TTLEpoch_merged,WakeWiNoise)),1)
%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM_Noise StimSWS_Noise StimWAKE_Noise]


% VLPO-REM with Noise
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title({'VLPO REM with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 40])
savefig(fullfile(pathname2,'VLPO_REMWiNoise'))


% VLPO-SWS with Noise
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpochWiNoise),500,300);
title({'VLPO SWS with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 40])
savefig(fullfile(pathname2,'VLPO_SWSWiNoise'))


% VLPO-Wake with Noise
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),WakeWiNoise),500,300);
title({'VLPO Wake with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 43])
savefig(fullfile(pathname2,'VLPO_WakeWiNoise'))


% Bulb-REM with Noise
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title({'Bulb REM with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 55])
savefig(fullfile(pathname2,'Bulb_low_REMWiNoise'))


[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBh{2}*1E4,10*log10(SpectroBh{1})),SpectroBh{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title({'Bulb REM with Noise'})
xlim([-80 +80])
colormap(jet)
caxis([20 40])
savefig(fullfile(pathname2,'Bulb_high_REMWiNoise'))


% Bulb-SWS with Noise
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),SWSEpochWiNoise),500,300);
title({'Bulb SWS with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 55])
savefig(fullfile(pathname2,'Bulb_low_SWSWiNoise'))


[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBh{2}*1E4,10*log10(SpectroBh{1})),SpectroBh{3},Restrict(ts(events*1E4),SWSEpochWiNoise),500,300);
title({'Bulb SWS with Noise'})
xlim([-80 +80])
colormap(jet)
caxis([20 40])
savefig(fullfile(pathname2,'Bulb_high_SWSWiNoise'))


% Bulb-Wake with Noise
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroB{2}*1E4,10*log10(SpectroB{1})),SpectroB{3},Restrict(ts(events*1E4),WakeWiNoise),500,300);
title({'Bulb Wake with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 55])
savefig(fullfile(pathname2,'Bulb_low_WakeWiNoise'))


[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBh{2}*1E4,10*log10(SpectroBh{1})),SpectroBh{3},Restrict(ts(events*1E4),WakeWiNoise),500,300);
title({'Bulb Wake with Noise'})
xlim([-80 +80])
colormap(jet)
caxis([20 40])
savefig(fullfile(pathname2,'Bulb_high_WakeWiNoise'))


% PFC-REM with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title({'PFC REM with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'PFC_REMWiNoise'))


% PFC-SWS with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpochWiNoise),500,300);
title({'PFC SWS with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'PFC_SWSWiNoise'))


% PFC-Wake with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),WakeWiNoise),500,300);
title({'PFC Wake with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'PFC_WakeWiNoise'))


% HPC-REM with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title({'HPC REM with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'HPC_REMWiNoise'))


% HPC-SWS with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpochWiNoise),500,300);
title({'HPC SWS with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'HPC_SWSWiNoise'))


% HPC-Wake with Noise
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),WakeWiNoise),500,300);
title({'HPC Wake with Noise'})
xlim([-80 +80])
ylim([0 +20])
colormap(jet)
caxis([20 50])
savefig(fullfile(pathname2,'HPC_WakeWiNoise'))


%%%%%%%%%%%%%%%%%%%%%%%%Figures subplot%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = openfig('VLPO_REMWiNoise','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax1 = gca; % get handle to axes of figure

h2 = openfig('VLPO_WakeWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax2 = gca; % get handle to axes of figure

h3 = openfig('VLPO_SWSWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax3 = gca;

h4 = openfig('HPC_REMWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax4 = gca;

h5 = openfig('HPC_WakeWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax5 = gca;

h6 = openfig('HPC_SWSWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax6 = gca;

h7 = openfig('PFC_REMWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax7 = gca;

h8 = openfig('PFC_WakeWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax8 = gca;

h9 = openfig('PFC_SWSWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax9 = gca;

h10 = openfig('Bulb_low_REMWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax10 = gca;

h11 = openfig('Bulb_low_WakeWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax11 = gca;

h12 = openfig('Bulb_low_SWSWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax12 = gca;

h13 = openfig('Bulb_high_REMWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax13 = gca;

h14 = openfig('Bulb_high_WakeWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax14 = gca;

h15 = openfig('Bulb_high_SWSWiNoise.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-80 +80])
ax15 = gca;

h16 = figure; %create new figure


s1 = subplot(5,3,1); %create and get handle to the subplot axes
ylabel('Frequency')
xlabel('Time')
title('VLPO REM with Noise')
s2 = subplot(5,3,2);
ylabel('Frequency')
xlabel('Time')
title('VLPO Wake with Noise')
s3 = subplot(5,3,3);
ylabel('Frequency')
xlabel('Time')
title('VLPO SWS with Noise')

s4 = subplot(5,3,4);
ylabel('Frequency')
xlabel('Time')
title('HPC REM with Noise')
s5 = subplot(5,3,5);
ylabel('Frequency')
xlabel('Time')
title('HPC Wake with Noise')
s6 = subplot(5,3,6);
ylabel('Frequency')
xlabel('Time')
title('HPC SWS with Noise')

s7 = subplot(5,3,7);
ylabel('Frequency')
xlabel('Time')
title('PFC REM with Noise')
s8 = subplot(5,3,8);
ylabel('Frequency')
xlabel('Time')
title('PFC Wake with Noise')
s9 = subplot(5,3,9);
ylabel('Frequency')
xlabel('Time')
title('PFC SWS with Noise')

s10 = subplot(5,3,10);
ylabel('Frequency')
xlabel('Time')
title('OBlow REM with Noise')
s11 = subplot(5,3,11);
ylabel('Frequency')
xlabel('Time')
title('OBlow Wake with Noise')
s12 = subplot(5,3,12);
ylabel('Frequency')
xlabel('Time')
title('OBlow SWS with Noise')

s13 = subplot(5,3,13);
ylabel('Frequency')
xlabel('Time')
title('OBhigh REM with Noise')
s14 = subplot(5,3,14);
ylabel('Frequency')
xlabel('Time')
title('OBhigh Wake with Noise')
s15 = subplot(5,3,15);
ylabel('Frequency')
xlabel('Time')
title('OBhigh SWS with Noise')

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
fig5 = get(ax5,'children'); %get handle to all the children in the figure
fig6 = get(ax6,'children');
fig7 = get(ax7,'children'); %get handle to all the children in the figure
fig8 = get(ax8,'children');
fig9 = get(ax9,'children'); %get handle to all the children in the figure
fig10 = get(ax10,'children');
fig11 = get(ax11,'children'); %get handle to all the children in the figure
fig12 = get(ax12,'children');
fig13 = get(ax13,'children');
fig14 = get(ax14,'children'); %get handle to all the children in the figure
fig15 = get(ax15,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
copyobj(fig5,s5); %copy children to new parent axes i.e. the subplot axes
copyobj(fig6,s6);
copyobj(fig7,s7); %copy children to new parent axes i.e. the subplot axes
copyobj(fig8,s8);
copyobj(fig9,s9); %copy children to new parent axes i.e. the subplot axes
copyobj(fig10,s10);
copyobj(fig11,s11); %copy children to new parent axes i.e. the subplot axes
copyobj(fig12,s12);
copyobj(fig13,s13);
copyobj(fig14,s14); %copy children to new parent axes i.e. the subplot axes
copyobj(fig15,s15);

colormap(jet)
caxis([20 48])
xlim([-80 +80])
savefig(fullfile('M1055_opto_REM_Wake_SWS.fig')) 