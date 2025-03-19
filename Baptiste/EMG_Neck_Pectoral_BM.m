

%% Freezing

% emg neck and 2 fz type
clear all
Session_type = {'Fear','Cond','Ext'};
GetEmbReactMiceFolderList_BM
Mouse=Mouse(98:121);
Mouse_names=Mouse_names(98:121);

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
        'emg_neck','emg_pect','respi_freq_bm');
end


Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1:2];
Legends = {'Shock','Safe'};

figure
subplot(221)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Cond.emg_neck.mean(:,5)) log10(OutPutData.Cond.emg_neck.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('neck EMG power (log scale)'), ylim([3.5 6.5])
title('Cond')

subplot(222)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Ext.emg_neck.mean(:,5)) log10(OutPutData.Ext.emg_neck.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([3.5 6.5])
title('Ext')

subplot(223)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Cond.emg_pect.mean(:,5)) log10(OutPutData.Cond.emg_pect.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('pectoral EMG power (log scale)'), ylim([3.5 6.5])

subplot(224)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Ext.emg_pect.mean(:,5)) log10(OutPutData.Ext.emg_pect.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([3.5 6.5])


figure
subplot(221)
PlotCorrelations_BM(log10(OutPutData.Cond.emg_neck.mean(:,5)) , log10(OutPutData.Cond.emg_pect.mean(:,5))')
axis square
xlabel('EMG neck, shock'), ylabel('EMG pect, shock')
subplot(222)
PlotCorrelations_BM(log10(OutPutData.Cond.emg_neck.mean(:,6)) , log10(OutPutData.Cond.emg_pect.mean(:,6))')
axis square
xlabel('EMG neck, safe'), ylabel('EMG pect, safe')
subplot(223)
PlotCorrelations_BM(log10(OutPutData.Cond.emg_neck.mean(:,5)) , log10(OutPutData.Cond.emg_neck.mean(:,6))')
axis square
xlabel('EMG neck, shock'), ylabel('EMG neck, safe')
subplot(224)
PlotCorrelations_BM(log10(OutPutData.Cond.emg_pect.mean(:,5)) , log10(OutPutData.Cond.emg_pect.mean(:,6))')
axis square
xlabel('EMG pect, shock'), ylabel('EMG pect, safe')

figure
subplot(221)
PlotCorrelations_BM(log10(OutPutData.Ext.emg_neck.mean(:,5)) , log10(OutPutData.Ext.emg_pect.mean(:,5))')
axis square
xlabel('EMG neck, shock'), ylabel('EMG pect, shock')
subplot(222)
PlotCorrelations_BM(log10(OutPutData.Ext.emg_neck.mean(:,6)) , log10(OutPutData.Ext.emg_pect.mean(:,6))')
axis square
xlabel('EMG neck, safe'), ylabel('EMG pect, safe')
subplot(223)
PlotCorrelations_BM(log10(OutPutData.Ext.emg_neck.mean(:,5)) , log10(OutPutData.Ext.emg_neck.mean(:,6))')
axis square
xlabel('EMG neck, shock'), ylabel('EMG neck, safe')
subplot(224)
PlotCorrelations_BM(log10(OutPutData.Ext.emg_pect.mean(:,5)) , log10(OutPutData.Ext.emg_pect.mean(:,6))')
axis square
xlabel('EMG pect, shock'), ylabel('EMG pect, safe')


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            clear EMG_interp1 EMG_interp2 A1 A2 B
            EMG_interp1 = interp1(linspace(0,1,length(OutPutData.(Session_type{sess}).emg_neck.tsd{mouse,3})) , log10(Data(OutPutData.(Session_type{sess}).emg_neck.tsd{mouse,3})) , linspace(0,1,length(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3})));
            EMG_interp2 = interp1(linspace(0,1,length(OutPutData.(Session_type{sess}).emg_pect.tsd{mouse,3})) , log10(Data(OutPutData.(Session_type{sess}).emg_pect.tsd{mouse,3})) , linspace(0,1,length(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3})));
            A1 = EMG_interp1;
            A2 = EMG_interp2;
            B = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
            [R1.(Session_type{sess})(mouse),P1.(Session_type{sess})(mouse)]=PlotCorrelations_BM(A1(1:10:end) , B(1:10:end)');
            [R2.(Session_type{sess})(mouse),P2.(Session_type{sess})(mouse)]=PlotCorrelations_BM(A2(1:10:end) , B(1:10:end)');
        end
        disp(Mouse_names{mouse})
    end
end

figure
subplot(221)
MakeSpreadAndBoxPlot4_SB({R1.Cond},{[.3 .3 .3]},1,{'neck Cond'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R1.Cond,zeros(1,length(R1.Cond)))
title(['p = ' num2str(p)])

subplot(222)
MakeSpreadAndBoxPlot4_SB({R1.Ext},{[.3 .3 .3]},1,{'neck Cond'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R1.Ext,zeros(1,length(R1.Ext)))
title(['p = ' num2str(p)])

subplot(223)
MakeSpreadAndBoxPlot4_SB({R2.Cond},{[.3 .3 .3]},1,{'neck Cond'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R2.Cond,zeros(1,length(R2.Cond)))
title(['p = ' num2str(p)])

subplot(224)
MakeSpreadAndBoxPlot4_SB({R2.Ext},{[.3 .3 .3]},1,{'neck Cond'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R2.Ext,zeros(1,length(R2.Ext)))
title(['p = ' num2str(p)])






%% Sleep
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch', 'Epoch', 'TotalNoiseEpoch')
load('HeartBeatInfo.mat')

% make neckal EMG spectrogram
load('ChannelsToAnalyse/EMG.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])

LowSpectrumSB([cd filesep],channel,'EMG')
HighSpectrum([cd filesep],channel,'EMG');
VeryHighSpectrum([cd filesep],channel,'EMG')

% make pectoral EMG spectrogram
Before_HeartBeat = ts(Range(EKG.HBTimes)-100);
After_HeartBeat = ts(Range(EKG.HBTimes)+100);
HeartBeat_Epoch=intervalSet(Before_HeartBeat,After_HeartBeat);
EMG_Epoch = Epoch-HeartBeat_Epoch;

load('ChannelsToAnalyse/EKG.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])
EMG_TSD = Restrict(LFP, EMG_Epoch);
LIA = ismember(Range(LFP) , Range(EMG_TSD));
D = Data(LFP);
D(~LIA) = NaN;
D = naninterp(D);
LFP = D
save('LFPData/LFP36.mat','LFP')

LowSpectrumSB([cd filesep],36,'EKG')
HighSpectrum([cd filesep],36,'EKG');
VeryHighSpectrum([cd filesep],36,'EKG')

%% Figures
figure
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
subplot(211)
plot(Range(Restrict(LFP,Wake),'s')/3.6e3 , Data(Restrict(LFP,Wake)) , 'b')
hold on
plot(Range(Restrict(LFP,SWSEpoch),'s')/3.6e3 , Data(Restrict(LFP,SWSEpoch)) , 'r')
plot(Range(Restrict(LFP,REMEpoch),'s')/3.6e3 , Data(Restrict(LFP,REMEpoch)) , 'g')
xlim([0 6.3]); ylim([-1.5e4 1.5e4])
ylabel('amplitude (a.u.)')
title('LFP EKG')
legend('Wake','SWS','REM')
subplot(212)
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
plot(Range(Restrict(LFP,Wake),'s')/3.6e3 , Data(Restrict(LFP,Wake)) , 'b')
hold on
plot(Range(Restrict(LFP,SWSEpoch),'s')/3.6e3 , Data(Restrict(LFP,SWSEpoch)) , 'r')
plot(Range(Restrict(LFP,REMEpoch),'s')/3.6e3 , Data(Restrict(LFP,REMEpoch)) , 'g')
xlim([0 6.3]); ylim([-1.5e4 1.5e4])
xlabel('time (h)'); ylabel('amplitude (a.u.)')
title('LFP EMG')

a=suptitle('Raw LFP, sleep session'); a.FontSize=20;


figure
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
subplot(211)
plot(Range(Restrict(LFP,SWSEpoch),'s')/3.6e3 , Data(Restrict(LFP,SWSEpoch)) , 'r')
hold on
plot(Range(Restrict(LFP,REMEpoch),'s')/3.6e3 , Data(Restrict(LFP,REMEpoch)) , 'g')
xlim([3.15 3.5]); ylim([-5e3 5e3])
ylabel('amplitude (a.u.)')
title('LFP EKG')
legend('SWS','REM')
subplot(212)
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
plot(Range(Restrict(LFP,SWSEpoch),'s')/3.6e3 , Data(Restrict(LFP,SWSEpoch)) , 'r')
hold on
plot(Range(Restrict(LFP,REMEpoch),'s')/3.6e3 , Data(Restrict(LFP,REMEpoch)) , 'g')
xlim([3.15 3.5]); ylim([-3e3 3e3])
xlabel('time (h)'); ylabel('amplitude (a.u.)')
title('LFP EMG')

a=suptitle('Raw LFP, sleep session'); a.FontSize=20;

%%
load('EMG_Data/EMG_Low_Spectrum.mat')
load('EMG_Data/EMG_VHigh_Spectrum.mat')

Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
Sp_REM = Restrict(Sp_tsd , REMEpoch);
Sp_NREM = Restrict(Sp_tsd , SWSEpoch);
Sp_Wake = Restrict(Sp_tsd , Wake);
ind=8;

% whole spectrogram
figure
imagesc(Spectro{2}/3.6e3 , Spectro{3} , log(Spectro{1})'), axis xy
xlabel('time (hour)'); ylabel('Frequency (Hz)')
colormap jet
caxis([0 ind])
title('Pectoral EMG spectrogram Low')
title('Pectoral EMG spectrogram Very High')
title('Neck EMG spectrogram Low')
title('Neck EMG spectrogram Very High')

yl=ylim;
LineHeight = yl(2);
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'c';
Colors.Noise = [0 0 0];
PlotPerAsLine(REMEpoch, LineHeight, Colors.REM, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(SWSEpoch, LineHeight, Colors.SWS, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(TotalNoiseEpoch, LineHeight, Colors.Noise, 'timescaling', 3600e4, 'linewidth',5);
xlim([0 6.3])

% spectrogram by state
figure
subplot(311)
imagesc(Range(Sp_Wake)/3.6e7 , Spectro{3} , log(Data(Sp_Wake)')), axis xy
caxis([0 ind]); ylabel('Frequency (Hz)'); hline(10.8,'--k')
title('Wake')
subplot(312)
imagesc(Range(Sp_NREM)/3.6e7 , Spectro{3} , log(Data(Sp_NREM)')), axis xy
caxis([0 ind]); ylabel('Frequency (Hz)'); hline(7.6,'--k')
title('SWS')
subplot(313)
imagesc(Range(Sp_REM)/3.6e7 , Spectro{3} , log(Data(Sp_REM)')), axis xy
caxis([0 ind]); ylabel('Frequency (Hz)'); xlabel('time (h)'); hline(8.85,'--k')
title('REM')
a=suptitle('Pectoral EMG spectrogram Low'); a.FontSize=20;
a=suptitle('Neck EMG spectrogram Low'); a.FontSize=20;
a=suptitle('Neck EMG spectrogram Very High'); a.FontSize=20;

colormap jet

% Mean spectrum
figure
plot(Spectro{3} , nanmean(log(Data(Sp_Wake))) , 'b')
hold on
plot(Spectro{3} , nanmean(log(Data(Sp_NREM))) , 'r')
plot(Spectro{3} , nanmean(log(Data(Sp_REM))) , 'g')
xlabel('Frequency (Hz)'); ylabel('Power (log scale)')
legend('Wake','SWS','REM')
vline(3.2,'--g')
makepretty

title('Pectoral EMG mean spectrum Low')
title('Neck EMG mean spectrum Low')
title('Neck EMG mean spectrum Very High')



%% EMG scoring usidn 50-300Hz filtered signal
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
smootime=1;
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));

EMGData_Wake = Restrict(EMGData , Wake);
EMGData_SWS = Restrict(EMGData , SWSEpoch);
EMGData_REM = Restrict(EMGData , REMEpoch);

subplot(121)
[Y,X]=hist(log(Data(EMGData_Wake)),1000);
Y=Y/sum(Y);
plot(X,Y,'b')
hold on
clear X Y
[Y,X]=hist(log(Data(EMGData_SWS)),1000);
Y=Y/sum(Y);
plot(X,Y,'r')
clear X Y
[Y,X]=hist(log(Data(EMGData_REM)),1000);
Y=Y/sum(Y);
plot(X,Y,'g')
makepretty
ylabel('#'); xlabel('EMG power (log scale)')
legend('Wake','NREM','REM')
title('Pectoral')

load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
smootime=1;
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));

EMGData_Wake = Restrict(EMGData , Wake);
EMGData_SWS = Restrict(EMGData , SWSEpoch);
EMGData_REM = Restrict(EMGData , REMEpoch);

subplot(122)
[Y,X]=hist(log(Data(EMGData_Wake)),1000);
Y=Y/sum(Y);
plot(X,Y,'b')
hold on
clear X Y
[Y,X]=hist(log(Data(EMGData_SWS)),1000);
Y=Y/sum(Y);
plot(X,Y,'r')
clear X Y
[Y,X]=hist(log(Data(EMGData_REM)),1000);
Y=Y/sum(Y);
plot(X,Y,'g')
makepretty
xlabel('EMG power (log scale)')
title('Neck')

a=suptitle('EMG power values distribution, filtered 50-300Hz'); a.FontSize=20;


%% enveloppe figures
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
clear Y EMGData EMGData_Wake EMGData_SWS EMGData_REM
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Y,~] = envelope(Data(FilLFP),3e3,'rms');
EMGData = tsd(Range(LFP) , Y);

EMGData_Wake = Restrict(EMGData , Wake);
EMGData_SWS = Restrict(EMGData , SWSEpoch);
EMGData_REM = Restrict(EMGData , REMEpoch);

subplot(121)
[Y,X]=hist(log(Data(EMGData_Wake)),1000);
Y=Y/sum(Y);
plot(X,Y,'b')
hold on
clear X Y
[Y,X]=hist(log(Data(EMGData_SWS)),1000);
Y=Y/sum(Y);
plot(X,Y,'r')
clear X Y
[Y,X]=hist(log(Data(EMGData_REM)),1000);
Y=Y/sum(Y);
plot(X,Y,'g')
makepretty
ylabel('#'); xlabel('EMG power (log scale)')
legend('Wake','NREM','REM')
title('Pectoral')

load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
clear Y EMGData EMGData_Wake EMGData_SWS EMGData_REM
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Y,~] = envelope(Data(FilLFP),3e3,'rms');
EMGData = tsd(Range(LFP) , Y);

EMGData_Wake = Restrict(EMGData , Wake);
EMGData_SWS = Restrict(EMGData , SWSEpoch);
EMGData_REM = Restrict(EMGData , REMEpoch);

subplot(122)
[Y,X]=hist(log(Data(EMGData_Wake)),1000);
Y=Y/sum(Y);
plot(X,Y,'b')
hold on
clear X Y
[Y,X]=hist(log(Data(EMGData_SWS)),1000);
Y=Y/sum(Y);
plot(X,Y,'r')
clear X Y
[Y,X]=hist(log(Data(EMGData_REM)),1000);
Y=Y/sum(Y);
plot(X,Y,'g')
makepretty
xlabel('EMG power (log scale)')
title('Neck')

a=suptitle('EMG enveloppe values distribution, filtered 0.1-5Hz'); a.FontSize=20;



%% correlations
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
smootime=1;
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
clear X Y
X = log(Data(SmoothGamma)); Y = log(Data(EMGData)); 

figure
subplot(121)
plot(X(1:1000:end) , Y(1:1000:end) , '.k')
 xlabel('OB gamma power (log scale)'); ylabel('EMG power (log scale)');
title('Pectoral')

load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
smootime=1;
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
clear X Y
X = log(Data(EMGData)); Y = log(Data(SmoothGamma));

subplot(122)
plot(Y(1:1000:end) , X(1:1000:end) , '.k')
ylabel('EMG power (log scale)'); xlabel('OB gamma power (log scale)')
title('Neck')

a=suptitle('Correlation of OB gamma power and EMG power filtered 50-300Hz, all epochs'); a.FontSize=20;



%% only sleep
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Yr,~] = envelope(Data(Restrict(FilLFP,Sleep)),3e3,'rms');
clear X Y
X = log(Yr); Y = log(Data(Restrict(SmoothTheta,Sleep)));

figure
subplot(121)
plot(Y(1:1000:end) , X(1:1000:end) , '.k')
ylabel('EMG power (log scale)'); xlabel('Theta/delta ratio (log scale)'); ylim([4 7])
title('Pectoral')

load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Yr,~] = envelope(Data(Restrict(FilLFP,Sleep)),3e3,'rms');
clear X Y
X = log(Yr); Y = log(Data(Restrict(SmoothTheta,Sleep)));

subplot(122)
plot(Y(1:1000:end) , X(1:1000:end) , '.k')
xlabel('EMG power (log scale)'); ylabel('Theta/delta ratio (log scale)'); ylim([4 7])
title('Neck')

a=suptitle('Correlation of Theta/Delta ratio and EMG power filtered 0.1-5Hz, sleep epochs'); a.FontSize=20;


%% EMG correlations
%% only sleep
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
[Yr1,~] = envelope(Data(FilLFP),3e3,'rms');
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
FilLFP=FilterLFP(LFP,[50 300],1024);
[Yr2,~] = envelope(Data(FilLFP),3e3,'rms');
clear X Y
X = log(Yr1); Y = log(Yr2);

figure
subplot(121)
plot(X(1:1000:end) , Y(1:1000:end) , '.k')
xlabel('EMG pectoral power (log scale)'); ylabel('EMG neck power (log scale)'); 
title('All epoch, EMG power filtered 50-300Hz')

load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP36.mat')
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Yr1,~] = envelope(Data(Restrict(FilLFP,Sleep)),3e3,'rms');
load('/media/nas7/ProjetEmbReact/Mouse1379/20221019/LFPData/LFP6.mat')
FilLFP=FilterLFP(LFP,[.1 5],1024);
[Yr2,~] = envelope(Data(Restrict(FilLFP,Sleep)),3e3,'rms');
clear X Y
X = log(Yr1); Y = log(Yr2);

subplot(122)
plot(Y(1:1000:end) , X(1:1000:end) , '.k')
xlabel('EMG pectoral power (log scale)'); ylabel('EMG neck power (log scale)'); 
title('Sleep epoch, EMG power filtered 0.1-5Hz')

a=suptitle('Correlation of pectoral and neck EMG'); a.FontSize=20;













