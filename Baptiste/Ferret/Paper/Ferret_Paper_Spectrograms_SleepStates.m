
clear all

pwd = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241213_TORCs';
smootime = 10;
LineHeight = 9.5;
Colors.N1 = [.8 .5 .2];
Colors.N2 = [1 0 0];
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = 'k';

%%
load([pwd filesep 'SleepScoring_OBGamma.mat'], 'Wake', 'REMEpoch', 'SWSEpoch', 'TotalNoiseEpoch', 'SmoothGamma', 'SmoothTheta')

% define IS & NREM
load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
FilDelta = FilterLFP(LFP,[.5 4],1024);
hilbert_delta = abs(hilbert(Data(FilDelta)));
SmoothDelta_OB = tsd(Range(LFP),runmean(hilbert_delta,ceil(smootime/median(diff(Range(LFP,'s'))))));

figure
gamma_thresh = GetGaussianThresh_BM(log10(Data(Restrict(SmoothDelta_OB , SWSEpoch))), 0, 1);
makepretty

N1 = and(thresholdIntervals(SmoothDelta_OB , 10^gamma_thresh , 'Direction' , 'Below') , SWSEpoch);
N2 = SWSEpoch-N1;


% clean epochs
REMEpoch = mergeCloseIntervals(REMEpoch,25e4);
REMEpoch = dropShortIntervals(REMEpoch,25e4);

Wake = or(Wake,TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,30e4);

B1 = load([pwd filesep 'B_Middle_Spectrum.mat']);
B_High_Sptsd = tsd(B1.Spectro{2}*1e4 , B1.Spectro{1});

H = load([pwd filesep 'H_Low_Spectrum.mat']);
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});

B2 = load([pwd filesep 'B_Low_Spectrum.mat']);
B_Low_Sptsd = tsd(B2.Spectro{2}*1e4 , B2.Spectro{1});


%% figures
figure
subplot(611) % OB High
imagesc(Range(B_High_Sptsd)/3.6e7 , B1.Spectro{3} , runmean(runmean(log10(Data(B_High_Sptsd)'),2)',1000)'), axis xy
ylabel('OB frequency (Hz)')
colormap viridis, ylim([20 100]), caxis([2.1 3.6])

PlotPerAsLine(Wake,95,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,95,Colors.REM,'timescaling',3.6e7);
PlotPerAsLine(N1,95,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,95,Colors.N2,'timescaling',3.6e7);

subplot(612)
plot(Range(SmoothGamma,'s')/3.6e3 , runmean(Data(SmoothGamma),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), %ylim([0 10])
box off
ylabel('OB Gamma power')


subplot(613) % HPC 
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),5)',50)'), axis xy
ylabel('HPC Frequency (Hz)'), ylim([0 10])
caxis([3.5 5])

subplot(614)
plot(Range(SmoothTheta,'s')/3.6e3 , runmean(Data(SmoothTheta),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 10])
box off
ylabel('HPC Theta/Delta')


subplot(615) % OB Low 
imagesc(Range(B_Low_Sptsd)/3.6e7 , B2.Spectro{3} , runmean(runmean(log10(Data(B_Low_Sptsd)'),5)',50)'), axis xy
ylabel('OB Frequency (Hz)'), ylim([0 10])
caxis([3.5 5])

PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
PlotPerAsLine(N1,LineHeight,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,LineHeight,Colors.N2,'timescaling',3.6e7);

subplot(616)
plot(Range(SmoothDelta_OB,'s')/3.6e3 , runmean(Data(SmoothDelta_OB),1e4) , 'k' , 'LineWidth',2)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 1e3])
box off
ylabel('OB Delta power')



%% trash ?
% % clean ?
[H_Sptsd_clean,~,EpochClean] = CleanSpectro(H_Sptsd , H.Spectro{3} , 8);

figure
imagesc(Range(H_Sptsd_clean)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd_clean)'),5)',50)'), axis xy
xlabel('time (hours)'), ylabel('Frequency (Hz)')
colormap jet

LineHeight = 19;
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = [0 0 0];
PlotPerAsLine(and(Wake,EpochClean),LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(and(SWSEpoch,EpochClean),LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(and(REMEpoch,EpochClean),LineHeight,Colors.REM,'timescaling',3.6e7);







