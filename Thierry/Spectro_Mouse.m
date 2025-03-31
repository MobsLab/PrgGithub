
%% Spectre HPC 929

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat') 
subplot(4,1,1); 
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage1')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,2)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('CNO')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,3)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage2')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,4)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
xlabel('Time(s)')
title('Saline')
set(gca,'FontSize',12)
suptitle('\fontsize{15}\bfSpectro HPC M929')


%% Spectre Bulbe 929
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat') 
subplot(4,1,1); 
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage1')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,2)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('CNO')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,3)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage2')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,4)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
xlabel('Time(s)')
title('Saline')
set(gca,'FontSize',12)
suptitle('\fontsize{15}\bfSpectro OB M929')

savefig(fullfile('Spectro_OB_929'))


%% Spectre HPC 930

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat') 
subplot(4,1,1); 
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage1')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,2)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('CNO')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,3)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage2')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
subplot(4,1,4)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
xlabel('Time(s)')
title('Saline')
set(gca,'FontSize',12)
suptitle('\fontsize{15}\bfSpectro HPC M930')

savefig(fullfile('Spectro_HPC_930'))

%% Spectre Bulbe 930
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat') 
subplot(4,1,1); 
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage1')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,2)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('CNO')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,3)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
title('Homecage2')
set(gca,'FontSize',12)

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('B_High_Spectrum.mat')
subplot(4,1,4)
imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
colormap(jet)
caxis([20 55])
ylabel('Frequency (Hz)')
xlabel('Time(s)')
title('Saline')
set(gca,'FontSize',12)
suptitle('\fontsize{15}\bfSpectro OB M930')

savefig(fullfile('Spectro_OB_930'))


%% Subplot Spectre HPC-OB 

clear all
%M929
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
h1 = openfig('Spectro_HPC_929.fig','reuse'); 
ax1 = gca; 
h2 = openfig('Spectro_OB_929.fig','reuse'); 
ax2 = gca;

h3 = figure; %create new figure

s1 = subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Frequency')
xlabel('time (s)')
title('Spectro_HPC_929')
set(gca,'FontSize',14)

s2 = subplot(1,2,2); %create and get handle to the subplot axes
ylabel('Frequency')
xlabel('time (s)')
title('Spectro_OB_929')
set(gca,'FontSize',14)

fig1 = get(ax1,'children'); 
fig2 = get(ax2,'children');

copyobj(fig1,s1); 
copyobj(fig2,s2);