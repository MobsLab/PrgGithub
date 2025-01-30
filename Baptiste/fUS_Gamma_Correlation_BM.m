
clear all
path{1} = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220520_n/';
path{2} = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220426_n/';
path{3} = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220421_m/';

fUS_slice = {'V','G','E'};
fUS_ind = [2 2 1];

for p=1:3
    
    clear SmoothGamma fUS_ACx_tsd fUS_Hpc_tsd
    load([path{p} 'fUS_data_' fUS_slice{p} '.mat'])
    load([path{p} 'SleepScoring_OBGamma.mat'], 'SmoothGamma')
    
    load('LFPData/LFP37.mat')
    fUS_trig = thresholdIntervals(LFP , -1e4 ,'Direction', 'Above');
    St=Start(fUS_trig); fUS_Start = St(1);
%     
    fUS_ACx{p}=tsd(Range(fUS_ACx_tsd{fUS_ind(p)})+fUS_Start , Data(fUS_ACx_tsd{fUS_ind(p)}));
    fUS_Hpc{p}=tsd(Range(fUS_Hpc_tsd{fUS_ind(p)})+fUS_Start , Data(fUS_Hpc_tsd{fUS_ind(p)}));
    SmoothGamma_on_fUS{p} = Restrict(SmoothGamma , fUS_ACx{p});
    SmoothGamma_all{p} = SmoothGamma;
    
    [r(p,:) , lags] = xcorr(-runmean(zscore(Data(SmoothGamma_on_fUS{p})),40) , runmean(zscore(Data(fUS_ACx{p})),1));
    
    % Sounds
    load('LFPData/LFP36.mat')
    SoundEpoch = thresholdIntervals(LFP , 2.8e4 ,'Direction', 'Above');
    SoundEpoch = dropLongIntervals(SoundEpoch,2e4);
    SoundEpoch = mergeCloseIntervals(SoundEpoch,2e4);
    Sound_start{p} = Start(SoundEpoch)+5e4;
    
end



%% figures
figure
subplot(1,5,1:4)
plot(Range(fUS_ACx{1},'s')/60 , runmean(zscore(Data(fUS_ACx{1})),20) , 'Color' , [.7 .5 .3])
hold on
plot(Range(fUS_Hpc{1},'s')/60 , runmean(zscore(Data(fUS_Hpc{1})),20) , 'Color' , [.5 .3 .1])
plot(Range(SmoothGamma_on_fUS{1},'s')/60 , -runmean(zscore(Data(SmoothGamma_on_fUS{1})),40) , 'Color' , [0 0 1])
ylabel('Power (zscore)'), xlabel('time (min)'), xlim([0 65]), ylim([-2 2.5])
legend('AuCx fUS','HPC fUS','OB gamma power (inverted)')
makepretty

subplot(155)
Data_to_use = zscore(r')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar((lags*.4)/60, nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
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



