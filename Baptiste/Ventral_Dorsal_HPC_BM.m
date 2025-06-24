

clear all
load('ExpeInfo.mat')
BaseFileName = ['M' num2str(ExpeInfo.nmouse) '_' ExpeInfo.date '_' ExpeInfo.SessionType];
FinalFolder = cd;
is_OpenEphys = false;
system(['ndm_lfp ' BaseFileName])

% copy .xml .nrs LFPDattttta with InfoLFP ChannelsToAnalyse ExpeInfo.mat

SetCurrentSession([BaseFileName '.xml'])
SessLength = MakeData_LFP_PluggedOnly(FinalFolder,ExpeInfo);

for i=[190 210 215 239]
    disp(['loading and saving LFP' num2str(InfoLFP.channel(i)) ' in LFPData...']);
    % FMA toolbox function to load LFP
    LFP_temp = GetLFP(InfoLFP.channel(i));
    %data to tsd
    LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
    SessLength = max(LFP_temp(:,1));
    %save
    save([foldername '/LFPData/LFP' num2str(InfoLFP.channel(i))], 'LFP');
    clear LFP LFP_temp
end


load('ChannelsToAnalyse/dHPC_rip.mat')
LowSpectrumSB([cd filesep],channel,'dH')

load('ChannelsToAnalyse/vHPC_rip.mat')
LowSpectrumSB([cd filesep],channel,'vH')
VeryHighSpectrum([cd filesep],channel,'vH')


load('LFPData/LFP209.mat')
FilLFP = FilterLFP(LFP,[50 300],1024);
Noise = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(.3/median(diff(Range(FilLFP,'s'))))));
StimEpoch = thresholdIntervals(Noise , 2e3 , 'Direction' , 'Above');
StimEpoch = mergeCloseIntervals(StimEpoch , 1e4);
StimEpoch = intervalSet(Start(StimEpoch)-1e4 , Start(StimEpoch)+1.5e4);
Epoch = intervalSet(0 , max(Range(LFP)));
NoStimEpoch = Epoch-StimEpoch;
TotalNoiseEpoch = StimEpoch;

save('StateEpochSB.mat','StimEpoch','Epoch','NoStimEpoch','TotalNoiseEpoch')



CreateRipplesSleep('restrict',0,'clean',0)
CreateRipplesSleep('recompute',1,'thresh',[5 7;6 8],'restrict',0,'clean',0) % for ventral

load('dSWR.mat')
[Y,X] = hist(Range(tRipples,'s'),[0:1:max(Range(LFP,'s'))]);
Y = runmean(Y,1); % smooth to get a  better idea of ripple density
dSWR_density = tsd(X'*1E4,Y');
save('dSWR.mat','dSWR_density','-append')

load('vSWR.mat')
[Y,X] = hist(Range(tRipples,'s'),[0:1:max(Range(LFP,'s'))]);
Y = runmean(Y,1); % smooth to get a  better idea of ripple density
vSWR_density = tsd(X'*1E4,Y');
save('vSWR.mat','vSWR_density','-append')

smootime=5;
Frequency{1} = [5 10];
Frequency{2} = [2 5];
FilTheta = FilterLFP(LFP,Frequency{1},1024);
FilDelta = FilterLFP(LFP,Frequency{2},1024);
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_delta(hilbert_delta<100) = 100;
theta_ratio = hilbert_theta ./ hilbert_delta;
theta_ratio = hilbert_theta;
ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
save('StateEpochSB.mat','SmoothTheta','-append')




%% figures
% spectro
figure
dH_Low = load('dH_Low_Spectrum.mat');
dHLow_tsd = tsd(dH_Low.Spectro{2}*1e4 , dH_Low.Spectro{1});
subplot(211)
imagesc(dH_Low.Spectro{2}/60 , dH_Low.Spectro{3} , runmean(runmean(log10(dH_Low.Spectro{1}),30)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

vH_Low = load('vH_Low_Spectrum.mat');
vHLow_tsd = tsd(vH_Low.Spectro{2}*1e4 , vH_Low.Spectro{1});
subplot(212)
imagesc(vH_Low.Spectro{2}/60 , vH_Low.Spectro{3} , runmean(runmean(log10(vH_Low.Spectro{1}),30)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

colormap jet 



figure
dH_High = load('dH_VHigh_Spectrum.mat');
dHHigh_tsd = tsd(dH_High.Spectro{2}*1e4 , dH_High.Spectro{1});
subplot(211)
imagesc(dH_High.Spectro{2}/60 , dH_High.Spectro{3} , runmean(runmean(log10(dH_High.Spectro{3}.*dH_High.Spectro{3}.*dH_High.Spectro{1}),300)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2


vH_High = load('vH_VHigh_Spectrum.mat');
vHHigh_tsd = tsd(vH_High.Spectro{2}*1e4 , vH_High.Spectro{1});
subplot(212)
imagesc(vH_High.Spectro{2}/60 , vH_High.Spectro{3} , runmean(runmean(log10(dH_High.Spectro{3}.*dH_High.Spectro{3}.*vH_High.Spectro{1}),300)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2
colormap jet
colorbar


% mean spectrums
load('SleepScoring_OBGamma.mat')

figure
subplot(221)
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(dHLow_tsd , Wake))) , 'b')
hold on
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(dHLow_tsd , SWSEpoch))) , 'r')
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(dHLow_tsd , REMEpoch))) , 'g')
xlabel('Frequency (Hz)'), ylabel('dHPC power (a.u.)'), xlim([0 15])
legend('Wake','NREM','REM')
makepretty

subplot(223)
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(vHLow_tsd , Wake))) , 'b')
hold on
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(vHLow_tsd , SWSEpoch))) , 'r')
plot(dH_Low.Spectro{3} , nanmean(Data(Restrict(vHLow_tsd , REMEpoch))) , 'g')
xlabel('Frequency (Hz)'), ylabel('vHPC power (a.u.)'), xlim([0 15])
makepretty


subplot(222)
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(dHHigh_tsd , Wake))),2) , 'b')
hold on
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(dHHigh_tsd , SWSEpoch))),2) , 'r')
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(dHHigh_tsd , REMEpoch))),2) , 'g')
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([50 250]), %ylim([.03 2])
makepretty
% set(gca,'YScale','log')

subplot(224)
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(vHHigh_tsd , Wake))),1) , 'b')
hold on
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(vHHigh_tsd , SWSEpoch))),1) , 'r')
plot(dH_High.Spectro{3} , runmean(dH_High.Spectro{3}.*dH_High.Spectro{3}.*nanmean(Data(Restrict(vHHigh_tsd , REMEpoch))),1) , 'g')
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([50 250]), %ylim([.03 2])
makepretty



%% SWR
% CreateRipplesSleep('recompute',1,'thresh',[6 8;7 9]), freq=150;

d = load('dSWR.mat', 'tRipples');
dSWR_dens_Wake = length(Restrict(d.tRipples , Wake))./(sum(DurationEpoch(Wake))./1e4);
dSWR_dens_NREM = length(Restrict(d.tRipples , SWSEpoch))./(sum(DurationEpoch(SWSEpoch))./1e4);
dSWR_dens_REM = length(Restrict(d.tRipples , REMEpoch))./(sum(DurationEpoch(REMEpoch))./1e4);

v = load('vSWR.mat', 'tRipples');
vSWR_dens_Wake = length(Restrict(v.tRipples , Wake))./(sum(DurationEpoch(Wake))./1e4);
vSWR_dens_NREM = length(Restrict(v.tRipples , SWSEpoch))./(sum(DurationEpoch(SWSEpoch))./1e4);
vSWR_dens_REM = length(Restrict(v.tRipples , REMEpoch))./(sum(DurationEpoch(REMEpoch))./1e4);



figure
subplot(121)
bar(1,dSWR_dens_Wake,'FaceColor' , 'b'); hold on
bar(2,dSWR_dens_NREM,'FaceColor' , 'r');
bar(3,dSWR_dens_REM,'FaceColor' , 'g');
xticks([1:3]), xticklabels({'Wake','NREM','REM'}), ylabel('SWR occurence (#/s)')
makepretty

subplot(122)
bar(1,vSWR_dens_Wake,'FaceColor' , 'b'); hold on
bar(2,vSWR_dens_NREM,'FaceColor' , 'r');
bar(3,vSWR_dens_REM,'FaceColor' , 'g');
xticks([1:3]), xticklabels({'Wake','NREM','REM'}), ylabel('SWR occurence (#/s)')
makepretty


% cross corr
[B1, C1] = CrossCorr(Range(d.tRipples)./1e4 , Range(v.tRipples)./1e4, .05, 100);
[B2, C2] = CrossCorr(Range(v.tRipples)./1e4 , Range(d.tRipples)./1e4, .05, 100);

figure
subplot(121)
bar(C1,runmean(B1,2),'FaceColor',[.3 .3 .3])
vline(0,'--r')

subplot(122)
bar(C2,runmean(B2,2),'FaceColor',[.3 .3 .3])
vline(0,'--r')




[B1, C1] = CrossCorr(Range(Restrict(d.tRipples , SWSEpoch))./1e4 , Range(Restrict(v.tRipples , SWSEpoch))./1e4, .05, 100);
[B2, C2] = CrossCorr(Range(Restrict(v.tRipples , SWSEpoch))./1e4 , Range(Restrict(d.tRipples , SWSEpoch))./1e4, .05, 100);

figure
subplot(121)
bar(C1,runmean(B1,2),'FaceColor',[.3 .3 .3])
xlabel('time (s)'), ylabel('vSWR #'), vline(0,'--r'), text(0,800,'dHPC SWR','FontSize',15,'Color','r')
makepretty_BM2

subplot(122)
bar(C2,runmean(B2,2),'FaceColor',[.3 .3 .3])
xlabel('time (s)'), ylabel('dSWR #'), vline(0,'--r'), text(0,5500,'vHPC SWR','FontSize',15,'Color','r')
makepretty_BM2

a=suptitle('NREM'); a.FontSize=20;


[B1, C1] = CrossCorr(Range(Restrict(d.tRipples , Wake))./1e4 , Range(Restrict(v.tRipples , Wake))./1e4, .05, 100);
[B2, C2] = CrossCorr(Range(Restrict(v.tRipples , Wake))./1e4 , Range(Restrict(d.tRipples , Wake))./1e4, .05, 100);

figure
subplot(121)
bar(C1,runmean(B1,2),'FaceColor',[.3 .3 .3])
xlabel('time (s)'), ylabel('vSWR #'), vline(0,'--r'), text(0,800,'dHPC SWR','FontSize',15,'Color','r')
makepretty_BM2

subplot(122)
bar(C2,runmean(B2,2),'FaceColor',[.3 .3 .3])
xlabel('time (s)'), ylabel('dSWR #'), vline(0,'--r'), text(0,4500,'vHPC SWR','FontSize',15,'Color','r')
makepretty_BM2

a=suptitle('Wake'); a.FontSize=20;



%% features
d_fet = load('dSWR.mat', 'ripples');
dSWR_dur_Wake = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,4)) , Wake));
dSWR_dur_NREM = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,4)) , SWSEpoch));
dSWR_freq_Wake = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,5)) , Wake));
dSWR_freq_NREM = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,5)) , SWSEpoch));
dSWR_amp_Wake = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,6)) , Wake));
dSWR_amp_NREM = Data(Restrict(tsd(d_fet.ripples(:,2)*1e4 , d_fet.ripples(:,6)) , SWSEpoch));

v_fet = load('vSWR.mat', 'ripples');
vSWR_dur_Wake = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,4)) , Wake));
vSWR_dur_NREM = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,4)) , SWSEpoch));
vSWR_freq_Wake = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,5)) , Wake));
vSWR_freq_NREM = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,5)) , SWSEpoch));
vSWR_amp_Wake = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,6)) , Wake));
vSWR_amp_NREM = Data(Restrict(tsd(v_fet.ripples(:,2)*1e4 , v_fet.ripples(:,6)) , SWSEpoch));

Cols = {[.3 .3 .3],[.5 .5 .5],[.3 .3 .3],[.5 .5 .5]};
X = [1 2 4 5];
Legends = {'d Wake','d NREM','v Wake','v NREM'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({dSWR_dur_Wake dSWR_dur_NREM vSWR_dur_Wake vSWR_dur_NREM},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SWR duration (ms)')

subplot(132)
MakeSpreadAndBoxPlot3_SB({dSWR_freq_Wake dSWR_freq_NREM vSWR_freq_Wake vSWR_freq_NREM},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SWR frequency (Hz)')

subplot(133)
MakeSpreadAndBoxPlot3_SB({dSWR_amp_Wake dSWR_amp_NREM vSWR_amp_Wake vSWR_amp_NREM},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SWR amplitude (Hz)')


figure
subplot(131)
violinplot(table(dSWR_dur_Wake' , dSWR_dur_NREM' , vSWR_dur_NREM' , vSWR_dur_NREM'))

subplot(132)
violinplot(table(dSWR_freq_Wake', dSWR_freq_NREM' , vSWR_freq_NREM' , vSWR_freq_NREM'))

subplot(133)
violinplot(table(dSWR_amp_Wake' , dSWR_amp_NREM' , vSWR_amp_NREM' , vSWR_amp_NREM'))


% mean waveform
%% features
d_meanw = load('dSWR.mat', 'M');
v_meanw = load('vSWR.mat', 'M');


figure 
subplot(121)
h=shadedErrorBar(d_meanw.M(:,1), d_meanw.M(:,2), d_meanw.M(:,4) ,'-b',1);
col = [.2 .8 .2]; h.mainLine.Color=col; h.patch.FaceColor=col;
xlabel('time (s)'), ylabel('amplitude (a.u.)'), xlim([-.05 .05]), ylim([-20 180])
axis square, makepretty

subplot(122)
h=shadedErrorBar(v_meanw.M(:,1), v_meanw.M(:,2), v_meanw.M(:,4) ,'-b',1);
col = [.2 .8 .5]; h.mainLine.Color=col; h.patch.FaceColor=col;
xlabel('time (s)'), ylabel('amplitude (a.u.)'), xlim([-.05 .05])
axis square, makepretty


%% synchrony
w_size = .1;
Around_dSWR_Wake = intervalSet(Range(Restrict(d.tRipples , Wake))-w_size*1e4 , Range(Restrict(d.tRipples , Wake))+w_size*1e4);
Around_dSWR_NREM = intervalSet(Range(Restrict(d.tRipples , SWSEpoch))-w_size*1e4 , Range(Restrict(d.tRipples , SWSEpoch))+w_size*1e4);
Around_vSWR_Wake = intervalSet(Range(Restrict(v.tRipples , Wake))-w_size*1e4 , Range(Restrict(v.tRipples , Wake))+w_size*1e4);
Around_vSWR_NREM = intervalSet(Range(Restrict(v.tRipples , SWSEpoch))-w_size*1e4 , Range(Restrict(v.tRipples , SWSEpoch))+w_size*1e4);


v_sync_Wake = length(Restrict(v.tRipples , Around_dSWR_Wake))./length(Restrict(v.tRipples , Wake));
v_sync_NREM = length(Restrict(v.tRipples , Around_dSWR_NREM))./length(Restrict(v.tRipples , SWSEpoch));

d_sync_Wake = length(Restrict(d.tRipples , Around_vSWR_Wake))./length(Restrict(d.tRipples , Wake));
d_sync_NREM = length(Restrict(d.tRipples , Around_vSWR_Wake))./length(Restrict(d.tRipples , SWSEpoch));


figure
subplot(141)
a = pie([v_sync_Wake 1-v_sync_Wake]);

subplot(142)
a = pie([v_sync_NREM 1-v_sync_NREM]);

subplot(143)
a = pie([d_sync_Wake 1-d_sync_Wake]);

subplot(144)
a = pie([d_sync_NREM 1-d_sync_NREM]);



for i=1:10
   saveFigure(i,['FM_' num2str(i)],'/home/ratatouille/Desktop/Figures_Baptiste/') 
end




%% trash ?




figure
dH_Low = load('dH_rad_Low_Spectrum.mat');
dHLow_tsd = tsd(dH_Low.Spectro{2}*1e4 , dH_Low.Spectro{1});
subplot(211)
imagesc(dH_Low.Spectro{2}/60 , dH_Low.Spectro{3} , runmean(runmean(log10(dH_Low.Spectro{1}),10)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

vH_Low = load('vH_Low_Spectrum.mat');
vHLow_tsd = tsd(vH_Low.Spectro{2}*1e4 , vH_Low.Spectro{1});
subplot(212)
imagesc(vH_Low.Spectro{2}/60 , vH_Low.Spectro{3} , runmean(runmean(log10(vH_Low.Spectro{1}),10)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

colormap jet 



figure
dH_Middle = load('vH_Middle_Spectrum.mat');
dH_Middle_tsd = tsd(dH_Middle.Spectro{2}*1e4 , dH_Middle.Spectro{1});
subplot(211)
imagesc(dH_Middle.Spectro{2}/60 , dH_Middle.Spectro{3} , runmean(runmean(log10(dH_Middle.Spectro{3}.*dH_Middle.Spectro{1}),100)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

vH_High = load('vH_VHigh_Spectrum.mat');
vHHigh_tsd = tsd(vH_High.Spectro{2}*1e4 , vH_High.Spectro{1});
subplot(212)
imagesc(vH_High.Spectro{2}/60 , vH_High.Spectro{3} , runmean(runmean(log10(vH_High.Spectro{1}),10)',3)), axis xy
xlabel('time (min)'), ylabel('Frequency (Hz)')
makepretty_BM2

colormap jet 



figure
subplot(121)
plot(dH_Middle.Spectro{3} , nanmean(log10(dH_Middle.Spectro{3}.*Data(Restrict(dH_Middle_tsd , NoStimEpoch)))))

subplot(122)
plot(vH_High.Spectro{3} , nanmean(log10(vH_High.Spectro{3}.*Data(Restrict(vHHigh_tsd , NoStimEpoch)))))





St = Start(StimEpoch);
win_size = 20;
for i=1:length(St)

    dHPC_Around_stim(i,:,:) = Data(Restrict(dHLow_tsd , intervalSet(St(i)-win_size*1e4 , St(i)+win_size*1e4)));

end

figure
for i=1:length(St)
    subplot(2,5,i)
    imagesc(linspace(-win_size , win_size , size(dHPC_Around_stim,2)) , dH_Low.Spectro{3} , runmean(runmean(log10(squeeze(dHPC_Around_stim(i,:,:))),5)',3)), axis xy
end
colormap jet



figure
imagesc(linspace(-10 , 10 , 100) , dH_Low.Spectro{3} , runmean(runmean(log10(squeeze(nanmean(dHPC_Around_stim))),1)',3)), axis xy
colormap jet




[M,T] = PlotRipRaw(SmoothTheta, Start(StimEpoch)/1e4, 20e3, 0, 1,1);


[M,T] = PlotRipRaw(vSWR_density, Start(StimEpoch)/1e4, 20e3, 0, 1,1);
[M,T] = PlotRipRaw(dSWR_density, Start(StimEpoch)/1e4, 20e3, 0, 1,1);

figure
plot(Range(dSWR_density,'s')/60 , runmean(Data(dSWR_density),3))
hold on 
plot(Range(vSWR_density,'s')/60 , runmean(Data(vSWR_density),3))
vline(Start(StimEpoch)/60e4 ,'--k')
xlabel('time (min)'), ylabel('SWR occurence (#/s)')
legend('dSWRs','vSWRs')
makepretty


[c,lags] = xcorr(Data(vSWR_density) , Data(dSWR_density)); 
figure
plot(lags , c)


load('LFPData/LFP189.mat')
FilLFP = FilterLFP(Restrict(LFP,NoStimEpoch),[.5 5],1024);
Gamma_v = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(.3/median(diff(Range(FilLFP,'s'))))));


[M,T] = PlotRipRaw(Gamma_v, Start(StimEpoch)/1e4, 20e3, 0, 1,1);



for i=1:7
   saveFigure(i,['FM_ShockObs_' num2str(i)],'/home/ratatouille/Desktop/Figures_Baptiste/') 
end







