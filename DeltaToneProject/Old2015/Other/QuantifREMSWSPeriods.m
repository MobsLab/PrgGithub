function [ThetaRatio,thetaPeriod,Sp,t,f,ThetaRatioTSD]=QuantifREMSWSPeriods(LFP,num,SleepEpoch,ThThetaDetection)

try
    ThThetaDetection;
catch
    ThThetaDetection=2.5;
end
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];

if length(Start(SleepEpoch))>1
    disp('Attention SleepEpoch en plusieurs morceaux')
end

movingwin=[3 0.2];
params.tapers=[3 5];
[Sp,t,f]=mtspecgramc(Data(Restrict(LFP{num},SleepEpoch)),movingwin,params);


stt=Start(SleepEpoch);
try
    load StimMFB
    bus=Range(Restrict(burst,SleepEpoch),'s');
end

figure('color',[1 1 1]), hold on
imagesc((t*1E4+stt(1))/1E4,f,10*log10(Sp)'), axis xy, caxis([20 55])

try
    hold on, plot(bus,3*ones(length(bus),1),'ko','markerfacecolor','w')
end
ylabel('Frequency (Hz)')
xlabel('Time (s)')


pasTheta=100;

FilTheta=FilterLFP(Restrict(LFP{num},SleepEpoch),[5 10],1024);
FilDelta=FilterLFP(Restrict(LFP{num},SleepEpoch),[3 6],1024);

HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));

ThetaRatio=abs(HilTheta)./abs(HilDelta);
rgThetaRatio=Range(FilTheta,'s');

ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
rgThetaRatio=rgThetaRatio(1:pasTheta:end);

plot(rgThetaRatio,ThetaRatio,'k','linewidth',2)

ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);

thetaPeriod=thresholdIntervals(ThetaRatioTSD,ThThetaDetection,'Direction','Above');
thetaPeriod=mergeCloseIntervals(thetaPeriod,10*1E4);
thetaPeriod=dropShortIntervals(thetaPeriod,20*1E4);

% hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)
% hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)

hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')]',(ones(size(Start(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)
hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')]',(ones(size(End(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)

ylim([0 30])
xlim([t(1)+stt(1)/1E4 t(end)+stt(1)/1E4])



ThetaRatio=sum(End(thetaPeriod,'s')-Start(thetaPeriod,'s'))/sum(End(subset(SleepEpoch,1),'s')-Start(subset(SleepEpoch,1),'s'))



