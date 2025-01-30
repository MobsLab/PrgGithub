

clear all
GetEmbReactMiceFolderList_BM

InstFreq_PT = ConcatenateDataFromFolders_SB(CondSess.M688,'instfreq','suffix_instfreq','B','method','PT');
InstFreq_WV = ConcatenateDataFromFolders_SB(CondSess.M688,'instfreq','suffix_instfreq','B','method','WV');
Respi_Spectro = ConcatenateDataFromFolders_SB(CondSess.M688,'respi_freq_bm');
OB_Spec = ConcatenateDataFromFolders_SB(CondSess.M688,'spectrum','prefix','B_Low');

FreezeEpoch = ConcatenateDataFromFolders_SB(CondSess.M688,'epoch','epochname','freezeepoch');
ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.M688,'epoch','epochname','zoneepoch');
ShockZone = ZoneEpoch{1};
SafeZone = or(ZoneEpoch{2} , ZoneEpoch{5});
FreezingShock = and(FreezeEpoch , ShockZone);
FreezingSafe = and(FreezeEpoch , SafeZone);

InstFreq_PT_FzShock = Restrict(InstFreq_PT,FreezingShock);
InstFreq_PT_FzSafe = Restrict(InstFreq_PT,FreezingSafe);

InstFreq_WV_FzShock = Restrict(InstFreq_WV,FreezingShock);
InstFreq_WV_FzSafe = Restrict(InstFreq_WV,FreezingSafe);

Respi_Spectro_FzShock = Restrict(Respi_Spectro,FreezingShock);
Respi_Spectro_FzSafe = Restrict(Respi_Spectro,FreezingSafe);

OB_Spec_FzShock = Restrict(OB_Spec,FreezingShock);
OB_Spec_FzSafe = Restrict(OB_Spec,FreezingSafe);


smootime=2;
A = tsd(Range(Respi_Spectro) , movmean(Data(Respi_Spectro) , ceil(smootime/median(diff(Range(Respi_Spectro,'s')))),'omitnan'));
B = tsd(Range(InstFreq_PT) , runmean(Data(InstFreq_PT) , ceil(smootime/median(diff(Range(InstFreq_PT))))));
C = tsd(Range(InstFreq_WV) , runmean(Data(InstFreq_WV) , ceil(smootime/median(diff(Range(InstFreq_WV))))));

B_interp = Restrict(B,A);
C_interp = Restrict(C,A);
B_interp2 = Restrict(B,C);

A_interp3 = Restrict(Restrict(A,FreezeEpoch),Restrict(C,FreezeEpoch));
B_interp3 = Restrict(Restrict(B_interp2,FreezeEpoch),Restrict(C,FreezeEpoch));
C_interp3 = Restrict(Restrict(C_interp,FreezeEpoch),Restrict(A,FreezeEpoch));


% Overlap values 
n1=sum(abs(Data(A)-Data(B_interp))>1)/length(Data(A))
n2=nanmedian(abs(Data(A)-Data(B_interp)))

n3=sum(abs(Data(A)-Data(C_interp))>1)/length(Data(A))
n4=nanmedian(abs(Data(A)-Data(C_interp)))

n5=sum(abs(Data(B_interp2)-Data(C))>1)/length(Data(C))
n6=median(abs(Data(B_interp2)-Data(C)))



p1=1-sum(abs(Data(A_interp3)-Data(B_interp3))>1)/length(Data(B_interp3))
p2=nanmedian(abs(Data(A_interp3)-Data(B_interp3)))

p3=1-sum(abs(Data(A_interp3)-Data(Restrict(C,FreezeEpoch)))>1)/length(Data(Restrict(C,FreezeEpoch)))
p4=nanmedian(abs(Data(A_interp3)-Data(Restrict(C,FreezeEpoch))))

p5=1-sum(abs(Data(B_interp3)-Data(Restrict(C,FreezeEpoch)))>1)/length(Data(Restrict(C,FreezeEpoch)))
p6=median(abs(Data(B_interp3)-Data(Restrict(C,FreezeEpoch))))


%% figures
% evolution time
smootime=2;
figure
subplot(311)
plot(Range(InstFreq_PT,'s') , runmean(Data(InstFreq_PT) , ceil(smootime/median(diff(Range(InstFreq_PT,'s'))))))
subplot(312)
plot(Range(InstFreq_WV,'s') , runmean(Data(InstFreq_WV) , ceil(smootime/median(diff(Range(InstFreq_WV,'s'))))))
subplot(313)
plot(Range(Respi_Spectro,'s') , movmean(Data(Respi_Spectro) , ceil(smootime/median(diff(Range(Respi_Spectro,'s')))),'omitnan'))


% OB mean spectrum
load('B_Low_Spectrum.mat')
figure
plot(Spectro{3} , nanmean(Data(OB_Spec_FzShock)),'r')
hold on
plot(Spectro{3} ,nanmean(Data(OB_Spec_FzSafe)),'b')
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')


% histogram
h = histogram(Data(InstFreq_PT_FzShock),'BinLimits',[0 15],'NumBins',196);
h_PT_Shock = h.Values;
h = histogram(Data(InstFreq_PT_FzSafe),'BinLimits',[0 15],'NumBins',196);
h_PT_Safe = h.Values;

h = histogram(Data(InstFreq_WV_FzShock),'BinLimits',[0 15],'NumBins',196);
h_WV_Shock = h.Values;
h = histogram(Data(InstFreq_WV_FzSafe),'BinLimits',[0 15],'NumBins',196);
h_WV_Safe = h.Values;

h = histogram(Data(Respi_Spectro_FzShock),'BinLimits',[0 15],'NumBins',196);
h_Spec_Shock = h.Values;
h = histogram(Data(Respi_Spectro_FzSafe),'BinLimits',[0 15],'NumBins',196);
h_Spec_Safe = h.Values;

clear D1 D2 ind
InstFreq_PT_FzShock_interp = Restrict(InstFreq_PT_FzShock,InstFreq_WV_FzShock);
D1 = Data(InstFreq_PT_FzShock_interp);
D2 = Data(InstFreq_WV_FzShock);
ind = abs(D1-D2)<1;
sum(ind)/length(ind)
h=histogram(nanmedian([D1(ind) D2(ind)]'),'BinLimits',[0 15],'NumBins',196);
h_PTWV_Shock = h.Values;
clear D1 D2 ind
InstFreq_PT_FzSafe_interp = Restrict(InstFreq_PT_FzSafe,InstFreq_WV_FzSafe);
D1 = Data(InstFreq_PT_FzSafe_interp);
D2 = Data(InstFreq_WV_FzSafe);
ind = abs(D1-D2)<1;
sum(ind)/length(ind)
h=histogram(nanmedian([D1(ind) D2(ind)]'),'BinLimits',[0 15],'NumBins',196);
h_PTWV_Safe = h.Values;



figure
subplot(131)
plot(Spectro{3}(1:196) , h_PT_Shock/sum(h_PT_Shock),'r')
hold on
plot(Spectro{3}(1:196) , h_PT_Safe/sum(h_PT_Safe),'b')
legend('Fz safe','Fz shock'), ylabel('#'), xlabel('Frequency (Hz)'),box off
title('InstFreq PT')

subplot(132)
plot(Spectro{3}(1:196) , h_WV_Shock/sum(h_WV_Shock),'r')
hold on
plot(Spectro{3}(1:196) , h_WV_Safe/sum(h_WV_Safe),'b')
xlabel('Frequency (Hz)'), box off
title('InstFreq WV')

subplot(133)
plot(Spectro{3}(1:196) , h_Spec_Shock/sum(h_Spec_Shock),'r')
hold on
plot(Spectro{3}(1:196) , h_Spec_Safe/sum(h_Spec_Safe),'b')
xlabel('Frequency (Hz)'), box off
title('Spectrum Respi')



% Correlations
X = Data(A);
Y = Data(B_interp);
bin=10;
figure
subplot(231)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
xlim([0 15]), ylim([0 15]), axis square
line([0 15],[0 15],'LineStyle','--','Color','r')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
xlabel('Spectro'), ylabel('PT')
title(['Overlap = ' num2str(n1) ', median diff = ' num2str(n2)])

X = Data(A);
Y = Data(C_interp);
subplot(232)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
line([0 15],[0 15],'LineStyle','--','Color','r')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
xlim([0 15]), ylim([0 15]), axis square
xlabel('Spectro'), ylabel('WV')
title(['Overlap = ' num2str(n3) ', median diff = ' num2str(n4)])

X = Data(B_interp2);
Y = Data(C);
subplot(233)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
line([0 15],[0 15],'LineStyle','--','Color','r')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
xlim([0 15]), ylim([0 15]), axis square
xlabel('PT'), ylabel('WV')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
title(['Overlap = ' num2str(n5) ', median diff = ' num2str(n6)])



% correlations during freezing
X = Data(A_interp3);
Y = Data(B_interp3);
bin=1;
subplot(234)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
line([0 15],[0 15],'LineStyle','--','Color','r')
xlim([0 15]), ylim([0 15]), axis square
xlabel('Spectro'), ylabel('PT')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
title(['Overlap = ' num2str(p1) ', median diff = ' num2str(p2)])


X = Data(A_interp3);
Y = Data(Restrict(C,FreezeEpoch));
subplot(235)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
line([0 15],[0 15],'LineStyle','--','Color','r')
xlim([0 15]), ylim([0 15]), axis square
xlabel('Spectro'), ylabel('WV')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
title(['Overlap = ' num2str(p3) ', median diff = ' num2str(p4)])


X = Data(B_interp3);
Y = Data(Restrict(C,FreezeEpoch));
subplot(236)
plot(X(1:bin:end) , Y(1:bin:end) , '.k')
line([0 15],[0 15],'LineStyle','--','Color','r')
xlim([0 15]), ylim([0 15]), axis square
xlabel('PT'), ylabel('WV')
line([0 14],[1 15],'LineStyle','--','Color','r')
line([1 15],[0 14],'LineStyle','--','Color','r')
title(['Overlap = ' num2str(p5) ', median diff = ' num2str(p6)])










