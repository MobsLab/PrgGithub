%%get sleep scoring
load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
% load('SleepScoring_Accelero.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');

load('behavResources.mat','MovAcctsd')

%%get spectro
SpectroOBhi = load('B_High_Spectrum','Spectro');
SpectroP = load('PFCx_deep_Low_Spectrum','Spectro');
% SpectroH = load('dHPC_deep_Low_Spectrum','Spectro');
SpectroH = load('H_Low_Spectrum','Spectro');

% spectro OB high
freqOBhi = SpectroOBhi.Spectro{3};
sptsdOBhi = tsd(SpectroOBhi.Spectro{2}*1e4, SpectroOBhi.Spectro{1});
% spectro PFC
freqP = SpectroP.Spectro{3};
sptsdP = tsd(SpectroP.Spectro{2}*1e4, SpectroP.Spectro{1});
% spectro HPC
freqH = SpectroH.Spectro{3};
sptsdH = tsd(SpectroH.Spectro{2}*1e4, SpectroH.Spectro{1});

% [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
% [Stim, StimREM, StimN1, StimN2, StimN3, StimWake, Stimts] = FindOptoStim_SubStages_MC(Epoch{1},Epoch{2},Epoch{3},Epoch{4},Epoch{5});
load('SimulatedStims.mat')
Stim = Range(StimWake);

figure
subplot(511), PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,16); colorbar
% subplot(511), SleepSubStage = PlotSleepSubStage_MC(Epoch{1},Epoch{2},Epoch{3},Epoch{4},Epoch{5},Epoch{7},1); %close
hold on, plot([Stim/1e4 Stim/1e4], [20 20], 'k*')

subplot(512), imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar, ylabel('HPC'),
hold on, plot([Stim/1e4 Stim/1e4], [20 20], 'k*')

subplot(513), imagesc(Range(sptsdP)/1E4, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar, ylabel('PFC'), caxis([20 50])
hold on, plot([Stim/1e4 Stim/1e4], [20 20], 'k*')

subplot(514), imagesc(Range(sptsdOBhi)/1E4, freqOBhi, 10*log10(SpectroOBhi.Spectro{1}')), axis xy, colorbar, ylabel('OB hi'), caxis([10 40])
hold on, plot([Stim/1e4 Stim/1e4], [100 100], 'k*')

subplot(515), plot(Range(MovAcctsd)/1E4, (Data(MovAcctsd))),ylim([0 7e8]),ylabel('Accelero'), colorbar
hold on, plot([Stim/1e4 Stim/1e4], [20 20], 'k*')



%%
hold on, plot([StimWake/1e4 StimWake/1e4], [20 20], 'r*')

%%
time_bef = 100;
time_aft = 100;
% istim = 3;
istim=istim+1;
subplot(511), xlim([(StimWake(istim)/1e4)-time_bef (StimWake(istim)/1e4)+time_aft]), subplot(512), xlim([(StimWake(istim)/1e4)-time_bef (StimWake(istim)/1e4)+time_aft]),...
    subplot(513), xlim([(StimWake(istim)/1e4)-time_bef (StimWake(istim)/1e4)+time_aft]),subplot(514), xlim([(StimWake(istim)/1e4)-time_bef (StimWake(istim)/1e4)+time_aft]),...
    subplot(515), xlim([(StimWake(istim)/1e4)-time_bef (StimWake(istim)/1e4)+time_aft])




%%
load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
figure, plot([Stim Stim], [20 20], 'r*')



%%

time_bef = 100;
time_aft = 100;
% istim = 3;
istim=istim+1;
subplot(511), xlim([(st_n3(istim)/1e4)-time_bef (st_n3(istim)/1e4)+time_aft]), subplot(512), xlim([(st_n3(istim)/1e4)-time_bef (st_n3(istim)/1e4)+time_aft]),...
    subplot(513), xlim([(st_n3(istim)/1e4)-time_bef (st_n3(istim)/1e4)+time_aft]),subplot(514), xlim([(st_n3(istim)/1e4)-time_bef (st_n3(istim)/1e4)+time_aft]),...
    subplot(515), xlim([(st_n3(istim)/1e4)-time_bef (st_n3(istim)/1e4)+time_aft])

%%

time_bef = 100;
time_aft = 100;
% istim = 3;
istim=istim+1;
subplot(511), xlim([(StimN3(istim)/1e4)-time_bef (StimN3(istim)/1e4)+time_aft]), subplot(512), xlim([(StimN3(istim)/1e4)-time_bef (StimN3(istim)/1e4)+time_aft]),...
    subplot(513), xlim([(StimN3(istim)/1e4)-time_bef (StimN3(istim)/1e4)+time_aft]),subplot(514), xlim([(StimN3(istim)/1e4)-time_bef (StimN3(istim)/1e4)+time_aft]),...
    subplot(515), xlim([(StimN3(istim)/1e4)-time_bef (StimN3(istim)/1e4)+time_aft])
