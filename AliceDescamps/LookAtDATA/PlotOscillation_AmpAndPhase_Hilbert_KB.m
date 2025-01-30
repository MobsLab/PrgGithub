%

    
    load ('SleepScoring_Accelero.mat', 'REMEpoch', 'SWSEpoch' ,'Wake')
    load(['ChannelsToAnalyse/ThetaREM' ''],'channel');
    load(['LFPData/LFP',num2str(channel)]);
a=1;
a=a+1;

temp=Restrict(LFP,subset(REMEpoch,a));

%Low bin window
fil=FilterLFP(temp,[5 10],96);
h=hilbert(Data(fil)); %to find amplitude and phase
ph = atan2(imag(h),real(h)); %phase

%
% fil=FilterLFP(temp,[9 15],1024);
% h=hilbert(Data(fil));
% ph = atan2(imag(h),real(h));

%High bin window : good for theta
fil2=FilterLFP(temp,[5 10],1024);
h2=hilbert(Data(fil2));
ph2 = atan2(imag(h2),real(h2));
%%
figure('color',[1 1 1]), 
subplot(4,1,1), 
plot(Range(temp),Data(temp))
hold on, plot(Range(fil),Data(fil),'r','linewidth',2) %filtered LFP signal
hold on, plot(Range(fil),abs(h),'k','linewidth',2) %enveloppe
line(xlim,[0 0],'linestyle',':')
subplot(4,1,2), 
plot(Range(fil),ph) %should be succession of ups and downs if well filtered

subplot(4,1,3), 
plot(Range(temp),Data(temp))
hold on, plot(Range(fil2),Data(fil2),'r','linewidth',2)
hold on, plot(Range(fil),abs(h2),'k','linewidth',2)
line(xlim,[0 0],'linestyle',':')
subplot(4,1,4), 
plot(Range(fil2),ph2)

figure('color',[1 1 1]), 
subplot(1,2,1), hist(ph,40) %should be flat if well filtered
subplot(1,2,2), hist(ph2,40)