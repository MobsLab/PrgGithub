%% Calculate Ashman's D

%Load data
load('StateEpochSB.mat', 'smooth_ghi')
load('StateEpochSB.mat', 'smooth_1020')
load('StateEpochSB.mat', 'smooth_1_8')
load('StateEpochSB.mat', 'smooth_01_05')
load('behavResources.mat', 'MovAcctsd')

% Gamma
[gamma_thresh , mu1 , mu2 , std1 , std2 , AshD_gamma] = GetGammaThresh(Data(smooth_ghi), 1, 1)
% beta
[beta_thresh , mu1 , mu2 , std1 , std2 , AshD_1020] = GetGammaThresh(Data(smooth_1020), 1, 1)
% 1-8 Hz
[one_eight_thresh , mu1 , mu2 , std1 , std2 , AshD_0108] = GetGammaThresh(Data(smooth_1_8), 1, 1)
% 0.1-0.5 Hz
[zeroone_zerofive_thresh , mu1 , mu2 , std1 , std2 , AshD_0105] = GetGammaThresh(Data(smooth_01_05), 1, 1)
% Accelerometer
[accelero_thresh , mu1 , mu2 , std1 , std2 , AshD_accelero] = GetGammaThresh(Data(smooth_Acc), 1, 1)

% Distributions
smooth_Acc = tsd(Range(MovAcctsd) , runmean(Data(MovAcctsd) , ceil(3/median(diff(Range(MovAcctsd,'s'))))));

figure
sgtitle("Distributions of different oscillations. Ashman's D", 'FontSize', 25,'FontWeight','bold')
%Accelero
subplot(2, 3, 1)
[Y,X]=hist(log(Data(smooth_Acc)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('Accelerometer values (log)')
title('Accelerometer')
vline(accelero_thresh, '--r')
annotation('textbox', [0.18, 0.77, 0.1, 0.1], 'String', "Ashman's D = " + AshD_accelero)
u=text(-8,3e-3,'All Epochs','FontSize',20,'FontWeight','bold'), set(u,'Rotation',90)
makepretty

%Gamma
subplot(2, 3, 2)
[Y,X]=hist(log(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('gamma power value (log)')
title('Gamma (40-60Hz)')
vline(gamma_thresh, '--r')
annotation('textbox', [0.48, 0.77, 0.1, 0.1], 'String', "Ashman's D = " + AshD_gamma)
makepretty

%Beta
subplot(2, 3, 4)
[Y,X]=hist(log(Data(smooth_1020)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('beta power value (log)')
title('Beta (10-20Hz)')
vline(beta_thresh, '--r')
annotation('textbox', [0.18, 0.33, 0.1, 0.1], 'String', "Ashman's D = " + AshD_1020)
u=text(4.6,1e-3,'Sleep Epoch','FontSize',20,'FontWeight','bold'), set(u,'Rotation',90)
makepretty

%1-8
subplot(2, 3, 5)
[Y,X]=hist(log(Data(smooth_1_8)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('1-8 Hz power value (log)')
title('1-8 Hz')
vline(one_eight_thresh, '--r')
annotation('textbox', [0.48, 0.33, 0.1, 0.1], 'String', "Ashman's D = " + AshD_0108)
makepretty

%0.1-0.5
subplot(2, 3, 6)
[Y,X]=hist(log(Data(smooth_01_05)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('0.1-0.5 Hz power value (log)')
title('0.1-0.5 Hz')
vline(zeroone_zerofive_thresh, '--r')
annotation('textbox', [0.78, 0.33, 0.1, 0.1], 'String', "Ashman's D = " + AshD_0105)
makepretty

%% The second way to do that

load('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/LFPData/LFP24.mat')
load('StateEpochSB.mat', 'Epoch')

%% Ashman's D for gamma
load('StateEpochSB.mat', 'gamma_thresh')

load('StateEpochSB.mat', 'Sleep')
load('StateEpochSB.mat', 'Wake')

% distribution of values
figure
% subplot(1, 3, 1)
[Y,X]=hist(log10(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('')
xlabel('gamma power value (log10)')
title('Gamma (40-60Hz)')
vline(log10(gamma_thresh), '--r')
xlim([1 3.5])
ylim([0 7e-3])

% Calculate Ashman's D
LFP_Wake = Restrict(LFP, Wake);
LFP_Sleep = Restrict(LFP, Sleep);

mean_wake = nanmean(Data(LFP_Wake));
mean_sleep = nanmean(Data(LFP_Sleep));

std_wake = std(Data(LFP_Wake));
std_sleep = std(Data(LFP_Sleep));

disp('gamma:')
Ash_D_gamma = sqrt(2)*(abs(mean_wake-mean_sleep)/abs(std_wake+std_sleep))
annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', "Ashman's D = " + Ash_D_gamma)
% annotation('textbox', [0.2, 0.78, 0.1, 0.1] , 'String', 'Threshold: ' + log10(gamma_thresh))

%% Ashman's D for beta
load('StateEpochSB.mat', 'TenTwenty_thresh')

load('StateEpochSB.mat', 'TenTwentyEpoch')

% distribution of values
figure
subplot(1, 3, 1)
[Y,X]=hist(log(Data(smooth_1020)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('')
xlabel('beta power value (log)')
title('Beta (10-20Hz)')
vline(log(beta_thresh), '--r')

% Calculate Ashman's D
[beta_thresh , mu1 , mu2 , std1 , std2 , AshD_1020] = GetGammaThresh(Data(smooth_1020), 1, 1)

% Zscored
    % smooth_1020_zscore = tsd(Range(smooth_1020) , zscore(Data(smooth_1020)));
    % LFP_Above_1020 = Restrict(smooth_1020_zscore, TenTwentyEpoch);
    % LFP_Below_1020 = Restrict(smooth_1020_zscore, Epoch - TenTwentyEpoch);

% not-zscored
LFP_Above_1020 = Restrict(smooth_1020, TenTwentyEpoch);
LFP_Below_1020 = Restrict(smooth_1020, Epoch - TenTwentyEpoch);

mean_Above_1020 = nanmean(Data(LFP_Above_1020));
mean_Below_1020 = nanmean(Data(LFP_Below_1020));

std_Above_1020 = std(Data(LFP_Above_1020));
std_Below_1020 = std(Data(LFP_Below_1020));

disp('beta AshD:')
Ash_D_1020 = sqrt(2)*(abs(mean_Above_1020-mean_Below_1020)/abs(std_Above_1020+std_Below_1020));
annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', "Ashman's D = " + Ash_D_1020)
% annotation('textbox', [0.2, 0.78, 0.1, 0.1] , 'String', 'Threshold: ' + log10(gamma_thresh))

%% Ashman's D for 1-8 Hz 
load('StateEpochSB.mat', 'OneEight_thresh')

load('StateEpochSB.mat', 'OneEightEpoch')

% distribution of values
subplot(1, 3, 2)
[Y,X]=hist(log(Data(smooth_1_8)),1000);

Y=Y/sum(Y);
plot(X,Y)
ylabel('')
xlabel('1-8 Hz power value (log)')
title('1-8 Hz')
vline(log(OneEight_thresh), '--r')

% Calculate Ashman's D

% Zscored
% smooth_1_8_zscore = tsd(Range(smooth_1_8) , zscore(Data(smooth_1_8)));
% LFP_REM_1_8 = Restrict(smooth_1_8_zscore, OneEightEpoch);
% LFP_SWS_1_8 = Restrict(smooth_1_8_zscore, Epoch - OneEightEpoch);

% not Zscored
LFP_REM_1_8 = Restrict(smooth_1_8, OneEightEpoch);
LFP_SWS_1_8 = Restrict(smooth_1_8, Epoch - OneEightEpoch);

mean_REM_1_8 = nanmean(Data(LFP_REM_1_8));
mean_SWS_1_8 = nanmean(Data(LFP_SWS_1_8));

std_REM_1_8 = std(Data(LFP_REM_1_8));
std_SWS_1_8 = std(Data(LFP_SWS_1_8));

disp('1-8 Hz:')
Ash_D_1_8 = sqrt(2)*(abs(mean_REM_1_8 - mean_SWS_1_8)/abs(std_REM_1_8 + std_SWS_1_8))
annotation('textbox', [0.43, 0.8, 0.1, 0.1], 'String', "Ashman's D = " + Ash_D_1_8)
% + ' threshold: ' + log10(OneEight_thresh))

%% Ashman's D for 0.1-0.5 Hz 
load('StateEpochSB.mat', 'thresh_01_05')

load('StateEpochSB.mat', 'Epoch_01_05')

% distribution of values
subplot(1, 3, 3)
[Y,X]=hist(log(Data(smooth_01_05)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('')
xlabel('0.1-0.5 Hz power value (log)')
title('0.1-0.5 Hz')
vline(log(thresh_01_05), '--r')

% Calculate Ashman's D
%Zscore
% smooth_01_05_zscore = tsd(Range(smooth_01_05) , zscore(Data(smooth_01_05)));
% smooth_01_05_Above = Restrict(smooth_01_05_zscore , Epoch_01_05);
% smooth_01_05_Below = Restrict(smooth_01_05_zscore , Epoch - Epoch_01_05);
       
% not zscored
smooth_01_05_Above = Restrict(smooth_01_05, Epoch_01_05);
smooth_01_05_Below = Restrict(smooth_01_05, Epoch - Epoch_01_05);

mean_Above_01_05 = nanmean(Data(smooth_01_05_Above));
mean_Below_01_05 = nanmean(Data(smooth_01_05_Below));

std_Above_01_05 = std(Data(smooth_01_05_Above));
std_Below_01_05 = std(Data(smooth_01_05_Below));

disp('0.1-0.5 Hz:')
Ash_D_01_05 = sqrt(2)*(abs(mean_Above_01_05 - mean_Below_01_05)/abs(std_Above_01_05 + std_Below_01_05))
annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', "Ashman's D = " + Ash_D_01_05)
% + ' threshold: ' + log10(thresh_01_05))
