%% Quick Spike Sorting script for ferret data
function SpikeSorting_Analysis_AG(directory)
%{
- SetCurrentSession
- GetSpikes(’all’, ‘output’, ‘full’)
- Load sound trigger channel and use thresholdIntervals to extract trigger timings
- You can check collection of raster figures: *Raster*
- Check the raster plots for every channel to select interesting channels
%}
%% for KlustaKwik preprocessing generate list of .spk files
% name = 'M4_20241206_Shropshire_20241206_fm_TORCs' ;
% % [32 34 35 38 45:55 57 59:72 94 95]
% diary('klusta_input')
% for i = 1:30
%     disp(['KlustaKwik ' name ' ' num2str(i)])
% end
% diary('klusta_input')

%% Access KlustaKwik data
% channels = [32 34 35 38 50 51 52 53 54 55 57 60 61 62 63 64 65 66 67 68 69 70 71 72 93 94 45 46 47 48 49 59];  % for 05
% % channels = [31 32 34 35 38 39 45 46 47 49 50 51 52 53 54 55 57 59 60 61 62 68 69 70 82 85 91 92 93 94]; %for 06/09/10/11/12/13/14/21/23 FM TORCs
% % ACx1 = [31 32 34 35 38 39 45 46 47 49 50 51 52 53 54 55 57 59 60 61 62]
% % ACx2 = [68 69 70 82 85 91 92 93 94]
% 
% cd([directory '/SpikeSorting'])
% 
% SetCurrentSession(name)
% % SetCurrentSession('same')
% spikes = GetSpikes('all','output','full');

%% For KlustaKwik
% for ii = 1:size(channels)
%     figure
% %     [fh,sq,sweeps] = RasterPETH(ts(spikes(spikes(:,2)==ii,1)*1e4), ts(Starttime*2/3), -10000, +15000,'BinSize',100);
%     [fh,sq,sweeps] = RasterPETH(ts(spikes(spikes(:,2)==ii,1)*1e4), ts(Starttime), -10000, +50000,'BinSize',240);
%     title(['channel #' num2str(channels(ii))])
%     Resp(ii,:) = Data(sq);
% end

%% Access wave_clus data
clear all
close all
% Options: 
% 20241204_TORCs, 20241205_TORCs, 20241206_TORCs, 20241209_TORCs, 20241212_TORCs, 20241213_TORCs, 20241214_TORCs, 20241221_TORCs, 20241223_TORCs

exp_path  = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/';
session = '20241223_TORCs';
directory = [exp_path session];

%% Load spikes
[spikes, metadata] = load_wave_clus(directory);

%%
clear Starttime stim_start
load([directory '/LFPData/LFP111.mat'])

StartSound = thresholdIntervals(LFP,4000,'Direction','Above');
Starttime = Start(StartSound);

% Convert to proper format
% stim_start = Starttime/1e4;
% save([exp_path 'stim_starts/' 'stim_start_' session], 'stim_start')

% edit Raster
clear Data Resp
set(0, 'DefaultFigureWindowStyle', 'docked');
% set(0, 'DefaultFigureWindowStyle', 'normal');

%% For wave_clus, plot raster PSTH
for ii = 1:size(spikes, 2)
    figure
    [fh,sq,sweeps] = RasterPETH(ts(spikes(:, ii)*1e1), ts(Starttime), -10000, +50000,'BinSize',240);
    i = metadata(ii, :);
    title(['channel #' num2str(i(1)) ', cluster #' num2str(i(2))])
    Resp(ii,:) = Data(sq);
end

%% Correction for 20241205_TORCs
if session == '20241205_TORCs'
    metadata([64:75], :) = [];
    spikes(:, [64:75]) = [];
end

%% Fetch the preselected channels list
clear chcl
chcl = get_chcl(session);

%%
% To access a chosen channel and cluster
clear colIndex

for s = 1:length(chcl)
    colIndex(s) = find(metadata(:, 1) == chcl{s}(1) & metadata(:, 2) == chcl{s}(2));
end
% spikeTimes = spikes(:, colIndex);
% spikeTimes = spikeTimes(~isnan(spikeTimes)); % Remove NaN values

%% Analysis
load([directory '/SleepScoring_OBGamma.mat'], 'Wake', 'Sleep', 'SWSEpoch', 'REMEpoch', 'Epoch_S1', 'Epoch_S2', 'SmoothGamma')

clear A B Q D

%% group spikes
n=1;
for i = colIndex
    %     A{n}= ts(spikes(spikes(:,2)==i,1)*1e4); %klusta
    A{n}= ts(spikes(:,i)*1e1);
    n = n+1;
end

%% Raster
figure
RasterPlot(A)

%% binned raster
Binsize = 10*1e4;
% Binsize = 120*1e4;
B = tsdArray(A);

Q = MakeQfromS(B,Binsize);
Q = tsd(Range(Q),nanzscore(full(Data(Q))));
D = Data(Q);

figure
subplot(3,1,1:2)
imagesc([1:size(D,1)*Binsize/1e4]/60 , [1:size(D,2)] , D'), axis xy, caxis([-2 2]), colormap viridis
ylabel('clusters')
makepretty
c=colorbar; c.Label.String='firing rate (zscore)';

subplot(313)
plot(linspace(0,size(D,1)*Binsize/1e4/60,size(D,1)) , movmean(nanmean(D'),5) , 'k' , 'LineWidth',2)
xlim([0 size(D,1)*Binsize/1e4/60])
xlabel('time (min)'), ylabel('Mean FR'), ylim([-1 3])
makepretty

%% covariance Gamma-pupil
Mean_FR_on_Gamma = interp1(linspace(0,1,length(D)) , movmean(nanmean(D'),5) , linspace(0,1,length(SmoothGamma)));
Mean_FR_on_Gamma_tsd = tsd(Range(SmoothGamma) , Mean_FR_on_Gamma');


figure
subplot(211)
plot(Range(SmoothGamma,'s')/60 , movmean(log10(Data(SmoothGamma)),1e3) , 'k')
ylabel('OB gamma power (log scale)')
yyaxis right
plot(Range(Mean_FR_on_Gamma_tsd,'s')/60 , Data(Mean_FR_on_Gamma_tsd))
xlabel('time (min)'), ylabel('FR (zscore)')
xlim([0 240])
makepretty

subplot(246)
X = Data(Restrict(Mean_FR_on_Gamma_tsd,Wake)); Y = log10(Data(Restrict(SmoothGamma,Wake)));
PlotCorrelations_BM(X(1:1e4:end) , Y(1:1e4:end))
xlabel('Mean FR (zscore)'), ylabel('OB gamma power (log scale)')
axis square
makepretty_BM2
xlim([-1 2.5])
xlim([-1 2.5]), ylim([2.2 2.9])
title('Wake')

subplot(247)
X = Data(Restrict(Mean_FR_on_Gamma_tsd,Sleep)); Y = log10(Data(Restrict(SmoothGamma,Sleep)));
PlotCorrelations_BM(X(1:1e5:end) , Y(1:1e5:end))
xlabel('Mean FR (zscore)'),
ylabel('OB gamma power (log scale)'), %xlim([-1 2.5])
axis square
title('Sleep')
makepretty_BM2
xlim([-1 1.5])


figure
[c,lags] = xcorr(X , Y);
plot(lags*(median(diff(Range(Mean_FR_on_Gamma_tsd,'s'))))/60,c)
vline(0,'--r')

%% matrix
figure, imagesc(corr(D))

%% matrix
Q_Wake = Restrict(Q, Wake);
D_Wake = Data(Q_Wake);
Q_NREM = Restrict(Q, SWSEpoch);
D_NREM = Data(Q_NREM);
Q_REM = Restrict(Q, REMEpoch);
D_REM = Data(Q_REM);
Q_NREM1 = Restrict(Q, and(Sleep , Epoch_S2)-REMEpoch);
D_NREM1 = Data(Q_NREM1);
Q_NREM2 = Restrict(Q, and(Sleep , Epoch_S1)-REMEpoch);
D_NREM2 = Data(Q_NREM2);

figure
subplot(231)
imagesc(corr(D(:,:)')), axis xy, colormap redblue
title('full')
axis square
caxis([-1 1])

subplot(232)
imagesc(corr(D_Wake(:,:)')), axis xy, colormap redblue
title('Wake')
axis square
caxis([-1 1])

subplot(233)
imagesc(corr(D_REM(:,:)')), axis xy, colormap redblue
title('REM')
axis square
caxis([-1 1])

subplot(234)
imagesc(corr(D_NREM(:,:)')), axis xy, colormap redblue
title('NREM')
axis square
caxis([-1 1])

subplot(235)
imagesc(corr(D_NREM1(:,:)')), axis xy, colormap redblue
title('NREM1')
axis square
caxis([-1 1])

subplot(236)
imagesc(corr(D_NREM2(:,:)')), axis xy, colormap redblue
title('NREM2')
axis square
caxis([-1 1])
 
 
%% firing rate across channels
figure
imagesc(corr([D_Wake(:,:) ; D_NREM(:,:) ; D_REM(:,:)]')), axis xy, colormap redblue
axis square, caxis([-1 1])
vline([248 997],'-k'), hline([248 997],'-k')

%
FiringRate_State(1,:) = nanmean(D);
FiringRate_State(2,:) = nanmean(D_Wake);
FiringRate_State(3,:) = nanmean(D_NREM);
FiringRate_State(4,:) = nanmean(D_REM);
FiringRate_State(5,:) = nanmean(D_NREM1);
FiringRate_State(6,:) = nanmean(D_NREM2);

figure
plot(FiringRate_State(1,:) , '--k')
hold on
plot(FiringRate_State(2,:) , 'b')
plot(FiringRate_State(3,:) , 'r')
plot(FiringRate_State(4,:) , 'g')
plot(FiringRate_State(5,:) , 'Color' , [1 .5 .5])
plot(FiringRate_State(6,:) , 'Color' , [.5 0 0])
makepretty
xlabel('neurons'), ylabel('Mean firing rate')
axis square
xlim([1 length(chcl)])


figure
subplot(331)
PlotCorrelations_BM(FiringRate_State(2,:) , FiringRate_State(3,:))
axis square, makepretty
xlabel('FR Wake'), ylabel('FR NREM')

subplot(332)
PlotCorrelations_BM(FiringRate_State(2,:) , FiringRate_State(4,:))
axis square, makepretty
xlabel('FR Wake'), ylabel('FR NREM')

subplot(333)
PlotCorrelations_BM(FiringRate_State(3,:) , FiringRate_State(4,:))
axis square, makepretty
xlabel('FR NREM'), ylabel('FR REM')


subplot(334)
PlotCorrelations_BM(FiringRate_State(5,:) , FiringRate_State(2,:))
axis square, makepretty
xlabel('FR NREM1'), ylabel('FR Wake')

subplot(335)
PlotCorrelations_BM(FiringRate_State(5,:) , FiringRate_State(4,:))
axis square, makepretty
xlabel('FR NREM1'), ylabel('FR REM')

subplot(336)
PlotCorrelations_BM(FiringRate_State(5,:) , FiringRate_State(6,:))
axis square, makepretty
xlabel('FR NREM1'), ylabel('FR NREM2')


subplot(337)
PlotCorrelations_BM(FiringRate_State(6,:) , FiringRate_State(2,:))
axis square, makepretty
xlabel('FR NREM1'), ylabel('FR Wake')

subplot(338)
PlotCorrelations_BM(FiringRate_State(6,:) , FiringRate_State(4,:))
axis square, makepretty
xlabel('FR NREM1'), ylabel('FR REM')


figure
imagesc(corr(FiringRate_State([2 4:6],:)'))
axis square
xticks([1:5]), yticks([1:5]), xtickangle(45)
xticklabels({'Wake','REM','NREM1','NREM2'}), yticklabels({'Wake','REM','NREM1','NREM2'})
colormap redblue
caxis([-1 1])


%% box plots nrem1 nrem2
Cols = {[1 .5 .5],[.5 0 0]};
X = [1 2];
Legends = {'NREM1','NREM2'};

figure
MakeSpreadAndBoxPlot3_SB({FiringRate_State(5,:) FiringRate_State(6,:)},Cols,X,Legends,'showpoints',0,'paired',1)
title(['n_{clusters} = ' num2str(length(FiringRate_State))])

%% hist
figure
i=1
subplot(122)
clear d, d=D_NREM2(:,i); d(or(d<-2.5 , d>2.5))=NaN;
hist(d,100)
xlim([-2.5 2.5]);

subplot(121)
clear d, d=D_NREM1(:,i); d(or(d<-2.5 , d>2.5))=NaN;
hist(d,100)
xlim([-2.5 2.5]);

%% correlations
SmoothGamma_onSpikes = Restrict(SmoothGamma , Q);
SmoothGamma_onSpikes_Wake = Restrict(SmoothGamma_onSpikes , Wake);
SmoothGamma_onSpikes_NREM = Restrict(SmoothGamma_onSpikes , SWSEpoch);
SmoothGamma_onSpikes_REM = Restrict(SmoothGamma_onSpikes , REMEpoch);
SmoothGamma_onSpikes_NREM1 = Restrict(SmoothGamma_onSpikes , and(Sleep , Epoch_S2)-REMEpoch);
SmoothGamma_onSpikes_NREM2 = Restrict(SmoothGamma_onSpikes , and(Sleep , Epoch_S1)-REMEpoch);

figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes)); D2 = D(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [0 0 0] , 'Marker_Size' , 15);
title(['Full, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
i=i+1;


figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes_Wake)); D2 = D_Wake(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [0 0 1]);
title(['Wake, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
xlabel('OB gamma power (log scale)'), ylabel('FR (zscore)')
i=i+1;


figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes_NREM)); D2 = D_NREM(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [1 0 0]);
title(['NREM, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
i=i+1;


figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes_REM)); D2 = D_REM(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [0 1 0]);
title(['REM, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
i=i+1;


figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes_NREM1)); D2 = D_NREM1(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [1 .5 .5]);
title(['NREM1, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
i=i+1;

figure
i = 1;
clf
D1 = log10(Data(SmoothGamma_onSpikes_NREM2)); D2 = D_NREM2(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
PlotCorrelations_BM(D1 , D2, 'color', [.5 0 0]);
title(['NREM2, channel #' num2str(metadata(colIndex(i), 1)) ' cluster #' num2str(metadata(colIndex(i), 2))])
i=i+1;

%% box plots 

Cols = {[0 0 1],[0 1 0],[1 .5 .5],[.5 0 0]};    
X = [1:4];
Legends = {'Wake','REM','NREM1','NREM2'}; 

figure
MakeSpreadAndBoxPlot3_SB({FiringRate_State(2,:) FiringRate_State(4,:) ...
    FiringRate_State(5,:) FiringRate_State(6,:)},Cols,X,Legends,'showpoints',0,'paired',1)
% set(gca , 'Yscale','log')
ylabel('firing rate (Hz)')
makepretty_BM2

%% correlations
figure
for i=1:16
    clf
    subplot(151)
    D1 = log10(Data(SmoothGamma_onSpikes)); D2 = D(:,i); %D3(D2>0) = sqrt(D2(D2>0)); D3(D2<0) = sqrt(-D2(D2<0));
    [R(i) , P(i)] = PlotCorrelations_BM(D1 , D2);
    xlabel('gamma power (log scale)'), ylabel('firing rate (zscore)')
    title('all')
    axis square, box off
    
    subplot(152)
    D1 = log10(Data(SmoothGamma_onSpikes_Wake)); D2 = D_Wake(:,i); D2(D2==0)=NaN;
    [R_Wake(i) , P_Wake(i)] = PlotCorrelations_BM(D1 , D2 , 'color' , [0 0 1]);
    xlabel('gamma power (log scale)'), ylabel('firing rate (zscore)')
    title('Wake')
    axis square, box off
    
    subplot(153)
    D1 = log10(Data(SmoothGamma_onSpikes_NREM1)); D2 = D_NREM1(:,i); D2(D2==0)=NaN;
    [R_NREM1(i) , P_NREM1(i)] = PlotCorrelations_BM(D1 , D2 , 'color' , [1 0 0]);
    xlabel('gamma power (log scale)'), ylabel('firing rate (zscore)')
    title('NREM ')
    axis square, box off
        
    subplot(154)
    D1 = log10(Data(SmoothGamma_onSpikes_NREM2)); D2 = D_NREM2(:,i); D2(D2==0)=NaN;
    [R_NREM2(i) , P_NREM2(i)] = PlotCorrelations_BM(D1 , D2 , 'color' , [1 0 0]);
    xlabel('gamma power (log scale)'), ylabel('firing rate (zscore)')
    title('NREM ')
    axis square, box off
    
    subplot(155)
    D1 = log10(Data(SmoothGamma_onSpikes_REM)); D2 = D_REM(:,i); D2(D2==0)=NaN;
    [R_REM(i) , P_REM(i)] = PlotCorrelations_BM(D1 , D2 , 'color' , [0 1 0]);
    xlabel('gamma power (log scale)'), ylabel('firing rate (zscore)')
    title('REM')
    axis square, box off
end
close


figure
MakeSpreadAndBoxPlot3_SB({R_Wake(P_Wake<.05) R_NREM1(P_NREM1<.05) R_NREM2(P_NREM2<.05) R_REM(P_REM<.05)},Cols,X,Legends,'showpoints',1,'paired',0)
hline(0,'--r')
ylabel('R values'), ylim([-1 1])


[h,p] = ttest(R_Wake(P_Wake<.05) , zeros(1,12))


end