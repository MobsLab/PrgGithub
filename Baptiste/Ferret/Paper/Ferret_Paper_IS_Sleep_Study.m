


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
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SWSEpoch','Epoch','TotalNoiseEpoch','Sleep', 'REMEpoch')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
            DurTot{ferret}(sess) = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))/3600e4;
            DurSleep{ferret}(sess) = sum(DurationEpoch(Sleep))/3600e4;
            DurNREM{ferret}(sess) = sum(DurationEpoch(SWSEpoch))/3600e4;
            DurREM{ferret}(sess) = sum(DurationEpoch(REMEpoch))/3600e4;

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
    DurREM{ferret}(DurREM{ferret}==0) = NaN;
end

figure
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        try

            [DeltaOB_tresh(ferret,sess),~,~,~,~,AshD_OB(ferret,sess)] = GetGaussianThresh_BM(Data(SmoothDelta_OB{ferret}{sess}),0,1); makepretty

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
            N1_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  DeltaOB_tresh(ferret,sess) , 'Direction' , 'Below');
            N2_OB{ferret}{sess} = thresholdIntervals(SmoothDelta_OB{ferret}{sess} ,  DeltaOB_tresh(ferret,sess) , 'Direction' , 'Above');
            
            N1_prop_OB{ferret}(sess) = sum(DurationEpoch(N1_OB{ferret}{sess}))./(sum(DurationEpoch(N1_OB{ferret}{sess}))+sum(DurationEpoch(N2_OB{ferret}{sess})));
            REM_prop{ferret}(sess) = DurREM{ferret}(sess)/DurSleep{ferret}(sess);
            
            disp(sess)
        end
    end
end


%% figures
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


LIM = {[2.2 3.2],[1.7 2.6],[2.3 3.2]};
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
HistData{2}(1,:) = NaN;

THR = [2.72 2.1 2.655];
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




DurSleep_tot = []; N1_prop_OB_tot = [];  REM_prop_OB_tot = [];
for ferret=1:3
    DurSleep_tot = [DurSleep_tot DurSleep{ferret}];
    N1_prop_OB_tot = [N1_prop_OB_tot N1_prop_OB{ferret}];
    REM_prop_OB_tot = [REM_prop_OB_tot REM_prop{ferret}];
end
N1_prop_OB_tot(N1_prop_OB_tot>.6) = NaN;


figure
subplot(131)
PlotCorrelations_BM(DurSleep_tot , N1_prop_OB_tot);
xlabel('sleep duration (hour)'), ylabel('N1 proportion'), axis square
makepretty_BM2

subplot(132)
PlotCorrelations_BM(DurSleep_tot , REM_prop_OB_tot);
xlabel('sleep duration (hour)'), ylabel('REM proportion'), axis square
makepretty_BM2

subplot(133)
PlotCorrelations_BM(N1_prop_OB_tot , REM_prop_OB_tot);
xlabel('N1 proportion'), ylabel('REM proportion'), axis square
makepretty_BM2













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



