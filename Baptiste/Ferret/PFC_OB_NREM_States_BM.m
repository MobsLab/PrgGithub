

%% illustration of sleep scoring
% initialization
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
LineHeight = 9.5;
Colors.Noise = [0 0 0];
smootime = 10;

% load and generate data
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20250103_LSP_saline')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma', 'Sleep', 'Info')
REMEpoch = mergeCloseIntervals(REMEpoch,25e4);
REMEpoch = dropShortIntervals(REMEpoch,25e4);


load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDeltaOB  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

load('ChannelsToAnalyse/PFCx_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDeltaPFC  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

load('ChannelsToAnalyse/AuCx.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDeltaAuC  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));



N2 = thresholdIntervals(SmoothDeltaOB , 10^2.62 , 'Direction' , 'Above');
N2 = mergeCloseIntervals(N2,5e4);
N2 = dropShortIntervals(N2,10e4);
N1 = SWSEpoch-N2;

Dur_NREM = sum(DurationEpoch(SWSEpoch))/3600e4;
Dur_REM = sum(DurationEpoch(REMEpoch))/3600e4;
Dur_N1 = sum(DurationEpoch(N1))/3600e4;
Dur_N2 = sum(DurationEpoch(N2))/3600e4;



H = load('H_Low_Spectrum.mat');
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});
[H_Sptsd_clean,~,~] = CleanSpectro(H_Sptsd , H.Spectro{3} , 5);
H_NREM = Restrict(H_Sptsd , SWSEpoch);
H_REM = Restrict(H_Sptsd , REMEpoch);
H_N1 = Restrict(H_Sptsd , N1);
H_N2 = Restrict(H_Sptsd , N2);

B = load('B_Low_Spectrum.mat');
B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});
[B_Sptsd_clean,~,EpochClean] = CleanSpectro(B_Sptsd , H.Spectro{3} , 5);
B_NREM = Restrict(B_Sptsd , SWSEpoch);
B_REM = Restrict(B_Sptsd , REMEpoch);
B_N1 = Restrict(B_Sptsd , N1);
B_N2 = Restrict(B_Sptsd , N2);

% scoring based on distrib and thresholding
figure
subplot(131)
[Y,X]=hist(log10(Data(SmoothGamma)),1000);
Y=runmean(Y,5)/sum(Y);
plot(X,runmean(Y,5) , 'k')
xlabel('OB gamma power (log)'), ylabel('PDF'), xlim([1.9 3]), ylim([0 8.2e-3])
v=vline(log10(Info.gamma_thresh),'-r'); v.LineWidth=5;
makepretty

subplot(132)
[Y,X]=hist(log10(Data(Restrict(SmoothTheta, Sleep))),1000);
Y=runmean(Y,5)/sum(Y);
plot(X,runmean(Y,5) , 'k')
xlabel('HPC theta power (log)'), ylabel('PDF'), xlim([-.55 1.15]), ylim([0 3e-3])
v=vline(log10(Info.theta_thresh),'-r'); v.LineWidth=5;
makepretty

subplot(133)
[Y,X]=hist(log10(Data(Restrict(SmoothDelta_OB, SWSEpoch))),1000);
Y=runmean(Y,5)/sum(Y);
plot(X,runmean(Y,5) , 'k')
xlabel('OB delta power (log)'), ylabel('PDF'), xlim([2.38 3]), ylim([0 6e-3])
v=vline(2.62,'-r'); v.LineWidth=5;
makepretty


% illustration of
figure
subplot(221)
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('HPC')
makepretty_BM2

subplot(223)
imagesc(linspace(0,Dur_NREM,length(H_NREM)) , H.Spectro{3} , runmean(runmean(log10(Data(H_NREM)'),2)',100)'), axis xy
ylabel('Frequency_N_R_E_M_o_n_l_y (Hz)')
ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
h=hline(9.5,'-r'); h.LineWidth=5;
makepretty_BM2

subplot(222)
imagesc(Range(B_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), caxis([3 5.5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('OB')
makepretty_BM2

subplot(224)
imagesc(linspace(0,Dur_NREM,length(B_NREM)) , H.Spectro{3} , runmean(runmean(log10(Data(B_NREM)'),2)',100)'), axis xy
ylabel('Frequency_N_R_E_M_o_n_l_y (Hz)')
ylim([0 10]), hline([.5 4],'--r'), caxis([3 5.5])
h=hline(9.5,'-r'); h.LineWidth=5;
makepretty_BM2




figure
subplot(421)
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('HPC')
makepretty_BM2

subplot(423)
imagesc(linspace(0,Dur_REM,length(H_REM)) , H.Spectro{3} , runmean(runmean(log10(Data(H_REM)'),2)',100)'), axis xy
ylabel('Frequency_R_E_M (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2

subplot(425)
imagesc(linspace(0,Dur_N1,length(H_N1)) , H.Spectro{3} , runmean(runmean(log10(Data(H_N1)'),2)',100)'), axis xy
ylabel('Frequency_N_1 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2

subplot(427)
imagesc(linspace(0,Dur_N2,length(H_N2)) , H.Spectro{3} , runmean(runmean(log10(Data(H_N2)'),2)',100)'), axis xy
ylabel('Frequency_N_2 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2


subplot(422)
imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('OB')
makepretty_BM2

subplot(424)
imagesc(linspace(0,Dur_REM,length(B_REM)) , B.Spectro{3} , runmean(runmean(log10(Data(B_REM)'),2)',100)'), axis xy
ylabel('Frequency_R_E_M (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2

subplot(426)
imagesc(linspace(0,Dur_N1,length(B_N1)) , B.Spectro{3} , runmean(runmean(log10(Data(B_N1)'),2)',100)'), axis xy
ylabel('Frequency_N_1 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2

subplot(428)
imagesc(linspace(0,Dur_N2,length(B_N2)) , B.Spectro{3} , runmean(runmean(log10(Data(B_N2)'),2)',100)'), axis xy
ylabel('Frequency_N_2 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5])
makepretty_BM2





bin = 5e3;
figure
subplot(131)
X = log10(Data(Restrict(SmoothDeltaOB , SWSEpoch)));
Y = log10(Data(Restrict(SmoothDeltaPFC , SWSEpoch)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
axis square
xlabel('OB delta power'), ylabel('PFC delta power'), xlim([2.3 3]), ylim([2.1 3.1])
vline(2.65,'-r'), hline(2.7,'-r')
makepretty_BM2

subplot(132)
X = log10(Data(Restrict(SmoothDeltaOB , SWSEpoch)));
Y = log10(Data(Restrict(SmoothDeltaAuC , SWSEpoch)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
axis square
xlabel('OB delta power'), ylabel('AuC delta power'), xlim([2.3 3]), ylim([2.2 2.8])
makepretty_BM2

subplot(133)
X = log10(Data(Restrict(SmoothDeltaPFC , SWSEpoch)));
Y = log10(Data(Restrict(SmoothDeltaAuC , SWSEpoch)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
axis square
xlabel('PFC delta power'), ylabel('AuC delta power'), xlim([2.1 3.1]), ylim([2.2 2.8])
makepretty_BM2




figure
bin = 5e3;
X = log10(Data(Restrict(SmoothDeltaOB , REMEpoch)));
Y = log10(Data(Restrict(SmoothTheta , REMEpoch)));
plot(X(1:bin:end) , Y(1:bin:end) , '.g'), hold on
bin = 1e3;
X = log10(Data(Restrict(SmoothDeltaOB , N1)));
Y = log10(Data(Restrict(SmoothTheta , N1)));
plot(X(1:bin:end) , Y(1:bin:end) , '.' , 'Color' , [.8 .5 .2])
bin = 5e3;
X = log10(Data(Restrict(SmoothDeltaOB , N2)));
Y = log10(Data(Restrict(Restrict(SmoothTheta,SmoothDeltaOB) , N2)));
plot(X(1:bin:end) , Y(1:bin:end) , '.r')
axis square
xlabel('OB delta power'), ylabel('HPC theta power'), xlim([2.3 3]), ylim([-.5 1.2])
legend('REM','N1','N2')
makepretty_BM2


%% all ferrets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labneh: 24 OB, 1 AuCx
% Brynza: 26 PFC, 10 OB
% Shropshire: 12 PFC, 21 OB, 34 AuCx

%% parametrization
clear all
Frequency = [.5 4];
Frequency2 = [.1 1];
smootime = 10;

%% get sessions
Dir1 = PathForExperimentsOB({'Labneh'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Labneh'}, 'freely-moving','none');
Dir{1} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Brynza'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Brynza'}, 'freely-moving','none');
Dir{2} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','none');
Dir{3} = MergePathForExperiment(Dir1,Dir2);


%% get data
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SWSEpoch','Epoch','TotalNoiseEpoch','Sleep')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
            DurTot{ferret}(sess) = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))/3600e4;
            DurSleep{ferret}(sess) = sum(DurationEpoch(Sleep))/3600e4;
            DurNREM{ferret}(sess) = sum(DurationEpoch(SWSEpoch))/3600e4;

            try
                % OB
                load([Dir{ferret}.path{sess} filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
                load([Dir{ferret}.path{sess} filesep 'LFPData/LFP' num2str(channel)])
                LFP = tsd(Range(LFP) , Data(LFP));%-Data(LFP6));
                Fil_Delta = FilterLFP(Restrict(LFP , SWSEpoch),Frequency,1024);
                tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
                SmoothDelta_OB{ferret}{sess}  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
                    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
            end

            disp(sess)
        end
    end
    DurTot{ferret}(DurTot{ferret}==0) = NaN;
    DurSleep{ferret}(DurSleep{ferret}==0) = NaN;
    DurNREM{ferret}(DurNREM{ferret}==0) = NaN;
end

figure
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try

            [DeltaOB_tresh(ferret,sess),~,~,~,~,AshD_OB(ferret,sess)] = GetGammaThresh_BM(Data(SmoothDelta_OB{ferret}{sess}),0,1); makepretty

            clf
            disp(sess)
        end
    end
end
AshD_OB(AshD_OB==0) = NaN;
DeltaOB_tresh(DeltaOB_tresh==0) = NaN;

for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try
            N1_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  exp(DeltaOB_tresh(ferret,sess)) , 'Direction' , 'Below');
            N2_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  exp(DeltaOB_tresh(ferret,sess)) , 'Direction' , 'Above');
            
            N1_prop_OB{ferret}(sess) = sum(DurationEpoch(N1_OB{ferret}{sess}))./(sum(DurationEpoch(N1_OB{ferret}{sess}))+sum(DurationEpoch(N2_OB{ferret}{sess})));
            
            disp(sess)
        end
    end
end

Cols = {[.2 .5 .8],[.8 .5 .2],[.5 .2 .8]};
X = 1:3;
Legends = {'Labneh','Brynza','Shropshire'};

figure
subplot(231)
MakeSpreadAndBoxPlot3_SB(DurTot,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('total duration (hour)')
makepretty_BM2

subplot(232)
MakeSpreadAndBoxPlot3_SB(DurSleep,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Sleep duration (hour)')
makepretty_BM2

subplot(233)
MakeSpreadAndBoxPlot3_SB(DurNREM,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('NREM duration (hour)')
makepretty_BM2

subplot(246)
MakeSpreadAndBoxPlot3_SB({DurSleep{1}./DurTot{1} DurSleep{2}./DurTot{2} DurSleep{3}./DurTot{3}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Sleep proportion')
makepretty_BM2

subplot(247)
MakeSpreadAndBoxPlot3_SB({DurNREM{1}./DurTot{1} DurNREM{2}./DurTot{2} DurNREM{3}./DurTot{3}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('NREM proportion')
makepretty_BM2


LIM = {[2.3 3.2],[1.7 2.6],[2.3 3.2]};
figure, 
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try
            D = log10(Data(SmoothDelta_OB{ferret}{sess}));
            h=histogram(D,'BinLimits',LIM{ferret},'NumBins',100);
            HistData{ferret}(sess,:) = h.Values;
        end
    end
    HistData{ferret}(HistData{ferret}==0) = NaN;
end
close

THR = [2.72 2.13 2.655];
figure
for ferret=1:3
    subplot(1,3,ferret)
    Data_to_use = HistData{ferret};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(LIM{ferret}(1),LIM{ferret}(2),100) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
    xlabel('delta power OB (log)'), xlim(LIM{ferret}), if ferret==1, ylabel('PDF'), end
    title(Legends{ferret})
    makepretty
    v=vline(THR(ferret),'-r'); v.LineWidth=5;
end
xlim([2.3 3])




DurSleep_tot = []; N1_prop_OB_tot = [];
for ferret=1:3
    DurSleep_tot = [DurSleep_tot DurSleep{ferret}];
    N1_prop_OB_tot = [N1_prop_OB_tot N1_prop_OB{ferret}];
end
N1_prop_OB_tot(N1_prop_OB_tot>.6) = NaN;

figure
PlotCorrelations_BM(DurSleep_tot , N1_prop_OB_tot);
xlabel('sleep duration (hour)'), ylabel('N1 proportion')
makepretty_BM2






%% old
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SWSEpoch','Epoch','TotalNoiseEpoch','Sleep')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
            DurTot{ferret}(sess) = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))/3600e4;
            DurSleep{ferret}(sess) = sum(DurationEpoch(Sleep))/3600e4;
            DurNREM{ferret}(sess) = sum(DurationEpoch(SWSEpoch))/3600e4;
            %             try
            %                 % PFC
            %                 load([Dir{ferret}.path{sess} filesep 'ChannelsToAnalyse/PFCx_deep.mat'])
            %                 load([Dir{ferret}.path{sess} filesep 'LFPData/LFP' num2str(channel)])
            %                 LFP = tsd(Range(LFP) , Data(LFP));
            %                 Fil_Delta = FilterLFP(Restrict(LFP , SWSEpoch),Frequency,1024);
            %                 tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
            %                 SmoothDelta_PFC{ferret}{sess}  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
            %                     ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
            %             end
            try
                % OB
                load([Dir{ferret}.path{sess} filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
                load([Dir{ferret}.path{sess} filesep 'LFPData/LFP' num2str(channel)])
                LFP = tsd(Range(LFP) , Data(LFP));%-Data(LFP6));
                Fil_Delta = FilterLFP(Restrict(LFP , SWSEpoch),Frequency,1024);
                tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
                SmoothDelta_OB{ferret}{sess}  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
                    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
            end
            %             try
            %                 % AuCx
            %                 load([Dir{ferret}.path{sess} filesep 'ChannelsToAnalyse/AuCx.mat'])
            %                 load([Dir{ferret}.path{sess} filesep 'LFPData/LFP' num2str(channel)])
            %                 Fil_Delta = FilterLFP(Restrict(LFP , SWSEpoch),Frequency,1024);
            %                 tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
            %                 SmoothDelta_AuC{ferret}{sess}  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
            %                     ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
            %             end
            disp(sess)
        end
    end
    DurTot{ferret}(DurTot{ferret}==0) = NaN;
    DurSleep{ferret}(DurSleep{ferret}==0) = NaN;
    DurNREM{ferret}(DurNREM{ferret}==0) = NaN;
end

figure
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try
            %         subplot(3,5,sess)
            %         [GammaTresh{1}(sess),~,~,~,~,AshD{1}(sess)] = GetGammaThresh_BM(Data(SmoothDelta_PFC{sess}),0,1); makepretty
            
%             subplot(3,5,sess+5)
            [DeltaOB_tresh(ferret,sess),~,~,~,~,AshD_OB(ferret,sess)] = GetGammaThresh_BM(Data(SmoothDelta_OB{ferret}{sess}),0,1); makepretty
            
            %         subplot(3,5,sess+10)
            %         [GammaTresh{3}(sess),~,~,~,~,AshD{3}(sess)] = GetGammaThresh_BM(Data(SmoothDelta_AuC{sess}),0,1); makepretty
            
            clf
            disp(sess)
        end
    end
end
AshD_OB(AshD_OB==0) = NaN;
DeltaOB_tresh(DeltaOB_tresh==0) = NaN;


for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try
            %         N1_PFC{sess} = thresholdIntervals(SmoothDelta_PFC{sess} , exp(GammaTresh(ferret,sess)) , 'Direction' , 'Below');
            %         N2_PFC{sess} = thresholdIntervals(SmoothDelta_PFC{sess} ,  exp(GammaTresh(ferret,sess)) , 'Direction' , 'Above');
            
            N1_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  exp(DeltaOB_tresh(ferret,sess)) , 'Direction' , 'Below');
            N2_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  exp(DeltaOB_tresh(ferret,sess)) , 'Direction' , 'Above');
            
            %         N1_AuC{sess} = thresholdIntervals(SmoothDelta_AuC{sess} ,  exp(GammaTresh{3}(sess)) , 'Direction' , 'Below');
            %         N2_AuC{sess} = thresholdIntervals(SmoothDelta_AuC{sess} ,  exp(GammaTresh{3}(sess)) , 'Direction' , 'Above');
            
%             Se_OB_PFC(sess) = sum(DurationEpoch(and(N1_OB{sess} , N1_PFC{sess})))./sum(DurationEpoch(N1_OB{sess}));
%             Sp_OB_PFC(sess) = sum(DurationEpoch(and(N1_OB{sess} , N1_PFC{sess})))./sum(DurationEpoch(N1_PFC{sess}));
            
            %         Se_OB_AuC(sess) = sum(DurationEpoch(and(N1_OB{sess} , N1_AuC{sess})))./sum(DurationEpoch(N1_OB{sess}));
            %         Sp_OB_AuC(sess) = sum(DurationEpoch(and(N1_OB{sess} , N1_AuC{sess})))./sum(DurationEpoch(N1_AuC{sess}));
            
            %         Se_PFC_AuC(sess) = sum(DurationEpoch(and(N1_PFC{sess} , N1_AuC{sess})))./sum(DurationEpoch(N1_PFC{sess}));
            %         Sp_PFC_AuC(sess) = sum(DurationEpoch(and(N1_PFC{sess} , N1_AuC{sess})))./sum(DurationEpoch(N1_AuC{sess}));
            
%             Se_OB_PFC2(sess) = sum(DurationEpoch(and(N2_OB{sess} , N2_PFC{sess})))./sum(DurationEpoch(N2_OB{sess}));
%             Sp_OB_PFC2(sess) = sum(DurationEpoch(and(N2_OB{sess} , N2_PFC{sess})))./sum(DurationEpoch(N2_PFC{sess}));
            
            %         Se_OB_AuC2(sess) = sum(DurationEpoch(and(N2_OB{sess} , N2_AuC{sess})))./sum(DurationEpoch(N2_OB{sess}));
            %         Sp_OB_AuC2(sess) = sum(DurationEpoch(and(N2_OB{sess} , N2_AuC{sess})))./sum(DurationEpoch(N2_AuC{sess}));
            
            %         Se_PFC_AuC2(sess) = sum(DurationEpoch(and(N2_PFC{sess} , N2_AuC{sess})))./sum(DurationEpoch(N2_PFC{sess}));
            %         Sp_PFC_AuC2(sess) = sum(DurationEpoch(and(N2_PFC{sess} , N2_AuC{sess})))./sum(DurationEpoch(N2_AuC{sess}));
            
%             N2_prop_PFC(sess) = sum(DurationEpoch(N1_PFC{sess}))./(sum(DurationEpoch(N1_PFC{sess}))+sum(DurationEpoch(N2_PFC{sess})));
                    N1_prop_OB{ferret}(sess) = sum(DurationEpoch(N1_OB{ferret}{sess}))./(sum(DurationEpoch(N1_OB{ferret}{sess}))+sum(DurationEpoch(N2_OB{ferret}{sess})));
            %         N1_prop_AuC(sess) = sum(DurationEpoch(N1_AuC{sess}))./(sum(DurationEpoch(N1_AuC{sess}))+sum(DurationEpoch(N2_AuC{sess})));
            
            disp(sess)
        end
    end
end
% GammaTresh{2}([3 6 7 9]) = [6.13 6.1 6.142 6.208];



Cols = {[1 0 0],[0 0 1],[.2 .5 .8]};
X = 1:3;
Legends = {'PFC','OB','AuC'};

figure
MakeSpreadAndBoxPlot3_SB(AshD_OB,Cols,X,Legends,'showpoints',1,'paired',0);


Cols = {[.3 .3 .3],[.6 .6 .6]};
X = 1:2;
Legends = {'Se','Sp'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Se_OB_PFC Sp_OB_PFC},Cols,X,Legends,'showpoints',1,'paired',0);
title('OB-PFC')

subplot(132)
MakeSpreadAndBoxPlot3_SB({Se_OB_AuC Sp_OB_AuC},Cols,X,Legends,'showpoints',1,'paired',0);
title('OB-AuC')

subplot(133)
MakeSpreadAndBoxPlot3_SB({Se_PFC_AuC Sp_PFC_AuC},Cols,X,Legends,'showpoints',1,'paired',0);
title('PFC-AuC')




bin = 5e3;
figure
subplot(221)
X = log10(Data(Restrict(SmoothTheta , Sleep)));
Y = log10(Data(Restrict(SmoothDelta_PFC{sess} , Sleep)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')

subplot(222)
X = log10(Data(Restrict(SmoothTheta , Sleep)));
Y = log10(Data(Restrict(SmoothULow_PFC{sess} , Sleep)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')

subplot(223)
X = log10(Data(Restrict(SmoothTheta , Sleep)));
Y = log10(Data(Restrict(SmoothDelta_OB{sess} , Sleep)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')

subplot(224)
X = log10(Data(Restrict(SmoothTheta , Sleep)));
Y = log10(Data(Restrict(SmoothULow_OB{sess} , Sleep)));
plot(X(1:bin:end) , Y(1:bin:end) , '.k')



bin = 5e3;
figure
for sess=1:5
    subplot(2,3,sess)
    X = log10(Data(SmoothDelta_OB{sess}));
    Y = log10(Data(SmoothDelta_PFC{sess}));
    plot(X(1:bin:end) , Y(1:bin:end) , '.k')
end

figure
for sess=1:5
    subplot(2,3,sess)
    X = log10(Data(SmoothDelta_OB{sess}));
    Y = log10(Data(SmoothDelta_AuC{sess}));
    plot(X(1:bin:end) , Y(1:bin:end) , '.k')
end

figure
for sess=1:5
    subplot(2,3,sess)
    X = log10(Data(SmoothDelta_AuC{sess}));
    Y = log10(Data(SmoothDelta_PFC{sess}));
    plot(X(1:bin:end) , Y(1:bin:end) , '.k')
end






figure
for sess=1:10
    
    D = Data(SmoothDelta_OB{sess});
    D(D<=0)=[];
    [Y,X]=hist(log(D),1000);
    Y=runmean(Y,5)/sum(Y);
    plot(X,runmean(Y,5)), hold on
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%% old
clear all

%% sessions
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/')
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/')
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241205_TORCs/')

%% change PFC chan
% channel=12;
% save('ChannelsToAnalyse/PFCx_deep.mat','channel')

%% load data
load('SleepScoring_OBGamma.mat', 'Sleep', 'SWSEpoch')
load('ChannelsToAnalyse/Bulb_deep.mat')
channel_ob = channel;
load('ChannelsToAnalyse/PFCx_deep.mat')
channel_pfc = channel;
smootime=10;
Frequency = [.5 4];
Frequency2 = [.1 1];

load(['LFPData/LFP' num2str(channel_ob) '.mat'])
Fil_Delta = FilterLFP(LFP,Frequency,1024); % filtering
tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_Delta))) ); 
SmoothDelta_OB = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
SmoothDelta_OB_NREM = Restrict(SmoothDelta_OB , SWSEpoch);
Fil_ULow = FilterLFP(LFP,Frequency2,1024); % filtering
tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_ULow))) ); 
SmoothULow_OB = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(10/median(diff(Range(tEnveloppe,'s'))))));
SmoothULow_OB_NREM = Restrict(SmoothULow_OB , SWSEpoch);
LFP_bulb = LFP;

load(['LFPData/LFP' num2str(channel_pfc) '.mat'])
Fil_Delta = FilterLFP(LFP,Frequency,1024); % filtering
tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_Delta))) ); 
SmoothDelta_PFC = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
SmoothDelta_PFC_NREM = Restrict(SmoothDelta_PFC , SWSEpoch);
Fil_ULow = FilterLFP(LFP,Frequency2,1024); % filtering
tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_ULow))) ); 
SmoothULow_PFC = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
SmoothULow_PFC_NREM = Restrict(SmoothULow_PFC , SWSEpoch);
LFP_pfc = LFP;

% load('LFPData/LFP1.mat')
% LFP_acx = LFP;

Dur_NREM = sum(DurationEpoch(SWSEpoch))/60e4;

% spectro
load('B_Low_Spectrum.mat')
B_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
B_NREM = Restrict(B_tsd , SWSEpoch);
load('PFCx_Low_Spectrum.mat')
P_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
P_NREM = Restrict(P_tsd , SWSEpoch);
load('AuCx_Low_Spectrum.mat')
A_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
A_NREM = Restrict(A_tsd , SWSEpoch);



% coherence
params.Fs=1/median(diff(Range(LFP_bulb,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];

[Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(Restrict(LFP_bulb ,...
    SWSEpoch)) , Data(Restrict(LFP_pfc , SWSEpoch)) , movingwin , params);

%% figures
figure
subplot(9,5,[1:4 6:9])
imagesc(linspace(0,Dur_NREM,length(B_NREM)) , Spectro{3} , runmean(runmean(log10(Data(B_NREM)),50)',1)), axis xy
xticklabels({''}), ylabel('OB frequency (Hz)'), hline([.5 4],'--r'), c=caxis; makepretty
subplot(9,5,11:14)
plot(linspace(0,Dur_NREM,length(SmoothDelta_OB_NREM)) , log10(Data(SmoothDelta_OB_NREM)) , 'k')
xlim([0 Dur_NREM]), ylim([1.8 2.5])
xticklabels({''}), ylabel('0.1-1 Hz power')
makepretty

subplot(355)
[Y,X]=hist(log10(Data(SmoothDelta_OB_NREM)),1000);
Y=Y/sum(Y);
plot(X,Y,'k')
xlim([1.3 2.5])
makepretty
xlabel('0.1-1 Hz power'), ylabel('PDF'), axis square

subplot(9,5,[16:19 21:24])
imagesc(linspace(0,Dur_NREM,length(B_NREM)) , Spectro{3} , runmean(runmean(log10(Data(P_NREM)),50)',1)), axis xy
xticklabels({''}), ylabel('PFC frequency (Hz)'), hline([.5 4],'--r'), caxis(c), makepretty
subplot(9,5,26:29)
plot(linspace(0,Dur_NREM,length(SmoothDelta_PFC_NREM)) , log10(Data(SmoothDelta_PFC_NREM)) , 'k')
xlim([0 Dur_NREM]), ylim([1.5 2.5])
ylabel('.5-4Hz power'), xticklabels({''})
makepretty

subplot(3,5,10)
[Y,X]=hist(log10(Data(SmoothDelta_PFC_NREM)),1000);
Y=Y/sum(Y);
plot(X,Y,'k')
xlim([1.5 2.4])
makepretty
xlabel('0.5-4Hz power'), ylabel('PDF'), axis square

subplot(9,5,[31:34 36:39])
imagesc(t/60,f,runmean(runmean(Ctemp,50)',1)), axis xy
xticklabels({''}), ylabel('coherence power'), makepretty

subplot(9,5,41:44)
plot(linspace(0,Dur_NREM,length(Ctemp)) , runmean(nanmean(Ctemp(:,1:5)'),50) , 'k')
xlim([0 Dur_NREM]), ylim([.2 .9])
makepretty



%% they are the same 0.1-0.5 OB / delta PFC
minduration=10;

gamma_thresh = GetGammaThresh(Data(SmoothDelta_OB_NREM), 1);
gamma_thresh = exp(gamma_thresh);
N1_OB = thresholdIntervals(SmoothDelta_OB_NREM, gamma_thresh, 'Direction','Below');
N1_OB = mergeCloseIntervals(N1_OB, minduration*1e4);
N1_OB = dropShortIntervals(N1_OB, minduration*1e4);
close

gamma_thresh = GetGammaThresh(Data(SmoothDelta_PFC_NREM), 1);
gamma_thresh = exp(gamma_thresh);
N1_PFC = thresholdIntervals(SmoothDelta_PFC_NREM, gamma_thresh, 'Direction','Below');
N1_PFC = mergeCloseIntervals(N1_PFC, minduration*1e4);
N1_PFC = dropShortIntervals(N1_PFC, minduration*1e4);
close

subplot(9,5,45)
a = pie([sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_OB)) 1-sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_OB))]);
set(a(1), 'FaceColor', [.2 .2 .8]); set(a(3), 'FaceColor', [.2 .2 .2]);

subplot(9,5,40)
a = pie([sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_PFC)) 1-sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_PFC))]);
set(a(1), 'FaceColor', [.8 .2 .2]); set(a(3), 'FaceColor', [.2 .2 .2]);










%% trash ?
minduration=10;

gamma_thresh = GetGammaThresh(Data(SmoothDelta_OB_NREM), 1);
gamma_thresh = exp(gamma_thresh);
N1_OB = thresholdIntervals(SmoothDelta_OB_NREM, gamma_thresh, 'Direction','Below');
N1_OB = mergeCloseIntervals(N1_OB, minduration*1e4);
N1_OB = dropShortIntervals(N1_OB, minduration*1e4);
close

gamma_thresh = GetGammaThresh(Data(SmoothDelta_PFC_NREM), 1);
gamma_thresh = exp(gamma_thresh);
N1_PFC = thresholdIntervals(SmoothDelta_PFC_NREM, gamma_thresh, 'Direction','Below');
N1_PFC = mergeCloseIntervals(N1_PFC, minduration*1e4);
N1_PFC = dropShortIntervals(N1_PFC, minduration*1e4);
close

subplot(9,5,45)
a = pie([sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_OB)) 1-sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_OB))]);
set(a(1), 'FaceColor', [.2 .2 .8]); set(a(3), 'FaceColor', [.2 .2 .2]);

subplot(9,5,40)
a = pie([sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_PFC)) 1-sum(DurationEpoch(and(N1_OB , N1_PFC)))./sum(DurationEpoch(N1_PFC))]);
set(a(1), 'FaceColor', [.8 .2 .2]); set(a(3), 'FaceColor', [.2 .2 .2]);



Dir{1} = PathForExperimentsOB({'Shropshire'}, 'freely-moving', 'saline');
Dir{2} = PathForExperimentsOB({'Shropshire'}, 'freely-moving', 'atropine');





% figure
% plot(linspace(0,Dur_NREM,length(SmoothDelta_OB_NREM)) , zscore(log10(Data(SmoothDelta_OB_NREM))) , 'k')
% hold on
% plot(linspace(0,Dur_NREM,length(SmoothDelta_PFC_NREM)) , zscore(log10(Data(SmoothDelta_PFC_NREM))) , 'r')
% plot(linspace(0,Dur_NREM,length(SmoothDelta_AuC_NREM)) , zscore(log10(Data(SmoothDelta_AuC_NREM))) , 'c')
% plot(linspace(0,Dur_NREM,length(SmoothULow_OB_NREM)) , zscore(log10(Data(SmoothULow_OB_NREM))) , 'g')
% plot(linspace(0,Dur_NREM,length(SmoothULow_PFC_NREM)) , zscore(log10(Data(SmoothULow_PFC_NREM))) , 'm')
% plot(linspace(0,Dur_NREM,length(SmoothULow_AuC_NREM)) , zscore(log10(Data(SmoothULow_AuC_NREM))))
% 
% 
% 
% 
% [Y,X]=hist(log10(Data(SmoothULow_PFC_NREM)),1000);
% Y=Y/sum(Y);
% plot(X,Y,'k')
% xlim([1.7 2.5])
%    
% 
% 
% 



% 
% 
% 
% load('LFPD')
% [C_25_26]=cohgramc(Data(Restrict(LFP_bulb ,...
%     SWSEpoch)) , Data(Restrict(LFP_pfc , SWSEpoch)) , movingwin , params);
% 
% 
% 
% 
% 
% 
% load(['LFPData/LFP1.mat'])
% Fil_Delta = FilterLFP(LFP,Frequency,1024); % filtering
% tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_Delta))) ); 
% SmoothDelta_AuC = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
%     ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
% SmoothDelta_AuC_NREM = Restrict(SmoothDelta_AuC , SWSEpoch);
% Fil_ULow = FilterLFP(LFP,[.1 .5],1024); % filtering
% tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(Fil_ULow))) ); 
% SmoothULow_AuC = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
%     ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));
% SmoothULow_AuC_NREM = Restrict(SmoothULow_AuC , SWSEpoch);
% LFP_AuC = LFP;
% 
% 
% 
% figure
% subplot(9,5,[1:4 6:9])
% imagesc(linspace(0,Dur_NREM,length(B_NREM)) , Spectro{3} , runmean(runmean(log10(Data(B_NREM)),50)',5)), axis xy
% % ylim([0 15])
% subplot(9,5,11:14)
% plot(linspace(0,Dur_NREM,length(SmoothDelta_OB_NREM)) , log10(Data(SmoothDelta_OB_NREM)) , 'k')
% xlim([0 Dur_NREM]), ylim([1.8 3])
% makepretty
% 
% subplot(355)
% [Y,X]=hist(log10(Data(SmoothDelta_OB_NREM)),1000);
% Y=Y/sum(Y);
% plot(X,Y,'k')
% xlim([1.7 2.5])
% makepretty
% 
% subplot(9,5,[16:19 21:24])
% imagesc(linspace(0,Dur_NREM,length(B_NREM)) , Spectro{3} , runmean(runmean(log10(Data(P_NREM)),50)',5)), axis xy
% % ylim([0 15])
% subplot(9,5,26:29)
% plot(linspace(0,Dur_NREM,length(SmoothDelta_PFC_NREM)) , log10(Data(SmoothDelta_PFC_NREM)) , 'k')
% xlim([0 Dur_NREM]), ylim([1.8 3])
% makepretty
% 
% subplot(3,5,10)
% [Y,X]=hist(log10(Data(SmoothDelta_PFC_NREM)),1000);
% Y=Y/sum(Y);
% plot(X,Y,'k')
% xlim([1.5 2.7])
% makepretty
% 
% subplot(9,5,[31:34 36:39])
% imagesc(t/60,f,runmean(runmean(Ctemp,50)',3)), axis xy
% ylim([0 15])
% 
% subplot(9,5,41:44)
% plot(linspace(0,Dur_NREM,length(Ctemp)) , runmean(nanmean(Ctemp(:,2:13)'),1e1) , 'k')
% xlim([0 Dur_NREM]), ylim([.2 .8])
% makepretty
% 
% 
% 
% [Ctemp_bulb_aucx,phi2]=cohgramc(Data(Restrict(LFP_bulb ,...
%     SWSEpoch)) , Data(Restrict(LFP_acx , SWSEpoch)) , movingwin , params);
% 
% 
% [C_aucx_pfc,phi3]=cohgramc(Data(Restrict(LFP_acx ,...
%     SWSEpoch)) , Data(Restrict(LFP_pfc , SWSEpoch)) , movingwin , params);
% 
% 
% subplot(211)
% imagesc(t/60,f,runmean(runmean(Ctemp_bulb_aucx,50)',3)), axis xy, %caxis([0 1])
% 
% subplot(212)
% imagesc(t/60,f,runmean(runmean(C_aucx_pfc,50)',3)), axis xy, %caxis([0 1])
% 
% 
% 
% 
% 
% 
