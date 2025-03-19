
clear all

Dir = PathForExperimentsOB({'Edel'}, 'head-fixed');

%%
for sess=1:length(Dir.path)
    clear fUS_ACx fUS_Hpc fUS_ACx_tsd fUS_Hpc_tsd SmoothGamma SmoothGamma_on_fUS
    try
        fileList = dir(fullfile(Dir.path{sess}, 'fUS*'));
        load([Dir.path{sess} filesep fileList.name])
        load([Dir.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SmoothGamma')
        load([Dir.path{sess} filesep 'LFPData/LFP37.mat'])
        fUS_trig = thresholdIntervals(LFP , -1e4 ,'Direction', 'Above');
        St=Start(fUS_trig); fUS_Start = St(1);
        
        fUS_ACx=tsd(Range(fUS_ACx_tsd{1})+fUS_Start , Data(fUS_ACx_tsd{1}));
        fUS_Hpc=tsd(Range(fUS_Hpc_tsd{1})+fUS_Start , Data(fUS_Hpc_tsd{1}));
        SmoothGamma_on_fUS = Restrict(SmoothGamma , fUS_ACx);
        
        %         [r_ACx(sess,:) , lags] = xcorr(runmean(zscore(Data(fUS_ACx)),40) , 'coeff');
        %         [r_HPC(sess,:) , lags] = xcorr(runmean(zscore(Data(fUS_Hpc)),40) , 'coeff');
        %         [r_Gamma(sess,:) , lags] = xcorr(runmean(zscore(Data(SmoothGamma_on_fUS)),40) , 'coeff');
        %         [r(sess,:) , lags] = xcorr(-runmean(zscore(Data(SmoothGamma_on_fUS)),40) , runmean(zscore(Data(fUS_ACx)),40) , 'coeff');
        
        [r_ACx(sess,:) , lags] = xcorr(zscore(Data(fUS_ACx)) , 'coeff');
        [r_HPC(sess,:) , lags] = xcorr(zscore(Data(fUS_Hpc)) , 'coeff');
        [r_Gamma(sess,:) , lags] = xcorr(zscore(Data(SmoothGamma_on_fUS)) , 'coeff');
        [r(sess,:) , lags] = xcorr(zscore(Data(SmoothGamma_on_fUS)) , zscore(Data(fUS_ACx)) , 'coeff');
        
        disp(sess)
    end
end
r_ACx(r_ACx==0) = NaN;
r_HPC(r_HPC==0) = NaN;
r_Gamma(r_Gamma==0) = NaN;
r(r==0) = NaN;


%%
figure
subplot(221)
Data_to_use = r_ACx;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(lags*.4/60 , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlim([-60 60]), box off

subplot(222)
Data_to_use = r_HPC;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(lags*.4/60 , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlim([-60 60]), box off

subplot(223)
Data_to_use = r_Gamma;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(lags*.4/60 , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlim([-60 60]), box off

subplot(224)
Data_to_use = -r;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(lags*.4/60 , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlim([-60 60]), box off





%% figures
figure
subplot(311)
plot(Range(fUS_ACx{1},'s')/60 , runmean(zscore(Data(fUS_ACx{1})),40) , 'Color' , [.7 .5 .3])
hold on
plot(Range(fUS_Hpc{1},'s')/60 , runmean(zscore(Data(fUS_Hpc{1})),40) , 'Color' , [.5 .3 .1])
plot(Range(SmoothGamma_on_fUS{1},'s')/60 , -runmean(zscore(Data(SmoothGamma_on_fUS{1})),100) , 'Color' , [0 0 1])
ylabel('Power (zscore)'), xlim([0 65]), ylim([-2 1.7])
legend('AuCx fUS','HPC fUS','OB gamma power (inverted)')
makepretty

subplot(312)
plot(Range(fUS_ACx{2},'s')/60 , runmean(zscore(Data(fUS_ACx{2})),40) , 'Color' , [.7 .5 .3])
hold on
plot(Range(fUS_Hpc{2},'s')/60 , runmean(zscore(Data(fUS_Hpc{2})),40) , 'Color' , [.5 .3 .1])
plot(Range(SmoothGamma_on_fUS{2},'s')/60 , -runmean(zscore(Data(SmoothGamma_on_fUS{2})),100) , 'Color' , [0 0 1])
ylabel('Power (zscore)'), xlim([0 65]), ylim([-2 2.5])
makepretty

subplot(313)
plot(Range(fUS_ACx{3},'s')/60 , runmean(zscore(Data(fUS_ACx{3})),40) , 'Color' , [.7 .5 .3])
hold on
plot(Range(fUS_Hpc{3},'s')/60 , runmean(zscore(Data(fUS_Hpc{3})),40) , 'Color' , [.5 .3 .1])
plot(Range(SmoothGamma_on_fUS{3},'s')/60 , -runmean(zscore(Data(SmoothGamma_on_fUS{3})),100) , 'Color' , [0 0 1])
ylabel('Power (zscore)'), xlabel('time (min)'), xlim([0 65]), ylim([-2 2.5])
makepretty


figure
subplot(131)
plot(lags , zscore(r_ACx')');
xlabel('time (min)'), ylabel('corr values (zscore)'), xlim([-40 40])
vline(0,'--r')
makepretty

subplot(132)
plot(lags , zscore(r_HPC')');
xlabel('time (min)'), ylabel('corr values (zscore)'), xlim([-40 40])
vline(0,'--r')
makepretty

subplot(133)
plot(lags , zscore(r_Gamma')');
xlabel('time (min)'), ylabel('corr values (zscore)'), xlim([-40 40])
vline(0,'--r')
makepretty



[M_fUS,T_fUS] = PlotRipRaw(fUS_ACx{1}, Sound_start{1}/1e4 , 5000,0,1,0);
[M_gamma,T_gamma] = PlotRipRaw(SmoothGamma_on_fUS{1} , Sound_start{1}/1e4 , 5000,0,1,1);

figure
Data_to_use = zscore(T_fUS')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(-5,5,21), nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlabel('time (s)'), ylabel('Power (a.u.)')
Data_to_use = zscore(T_gamma')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(-5,5,21), nanmean(Data_to_use) , Conf_Inter ,'-b',1); hold on;
vline(0,'--r'), text(-.2,1.02,'Sound','Color',[1 0 0],'FontSize',15)
f=get(gca,'Children'); l=legend([f([8 4])],'fUS','OB gamma');
makepretty
ylim([-.7 1])



fUS_response = nanmean(T_fUS(:,14:21)')-nanmean(T_fUS(:,7:14)');
Gamma_response = nanmean(T_gamma(:,11:15)')-nanmean(T_gamma(:,6:11)');

figure
PlotCorrelations_BM(log10(nanmean(T_gamma')) , fUS_response)
axis square
xlabel('OB gamma power (log scale)'), ylabel('fUS response amplitude')
makepretty_BM2



[~,b] = sort(log10(nanmean(T_gamma')));
a=jet;
l = linspace(1,64,100);

figure
for i=1:100
    plot(linspace(-5,5,21) , T_fUS(b(i),:)' , 'color',[a(round(l(i)),1) a(round(l(i)),2) a(round(l(i)),3)] , 'LineWidth',1), hold on
end
vline(0,'--r'), text(-.2,1.62,'Sound','Color',[1 0 0],'FontSize',15), xticks([-5:1:5])
makepretty_BM2
xlabel('time (s)'), ylabel('fUS power (a.u.)'), ylim([.3 1.5])
c=colorbar; c.Label.String='OB gamma power (a.u.)';  colormap jet


%% trash ?
load('LFPData/LFP36.mat')
SoundEpoch = thresholdIntervals(LFP , 2.8e4 ,'Direction', 'Above');
SoundEpoch = dropLongIntervals(SoundEpoch,2e4);
SoundEpoch = mergeCloseIntervals(SoundEpoch,2e4);
Sound_start{p} = Start(SoundEpoch)+5e4;




% SoundPrez = intervalSet(1250e4 , 2500e4);
% Before_SoundPrez = intervalSet(0 , 1250e4);
% After_SoundPrez = intervalSet(2500e4 , 3900e4);

figure
subplot(131)
A = log10(Data(Restrict(SmoothGamma_on_fUS , Before_SoundPrez))); B = Data(Restrict(fUS_ACx_tsd , Before_SoundPrez));
PlotCorrelations_BM(A(1:30:end) , B(1:30:end))
makepretty, axis square
xlabel('OB gamma power'), ylabel('fUS data')

subplot(132)
A = log10(Data(Restrict(SmoothGamma_on_fUS , SoundPrez))); B = Data(Restrict(fUS_ACx_tsd , SoundPrez));
PlotCorrelations_BM(A(1:30:end) , B(1:30:end))
makepretty, axis square
xlabel('OB gamma power'), ylabel('fUS data')

subplot(133)
A = log10(Data(Restrict(SmoothGamma_on_fUS , After_SoundPrez))); B = Data(Restrict(fUS_ACx_tsd , After_SoundPrez));
PlotCorrelations_BM(A(1:30:end) , B(1:30:end))
makepretty, axis square
xlabel('OB gamma power'), ylabel('fUS data')





plot(T_gamma')



