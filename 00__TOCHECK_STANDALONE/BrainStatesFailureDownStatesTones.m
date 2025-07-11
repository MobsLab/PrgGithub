%BrainStatesFailureDownStatesTones

try
    delay;
catch
    delay=0;
end


[Tones,idOK,idBad,del,del2,del3,C,B,Aj,Bj,Cj]=ToneDeltaKB(0,2,delay);

load StateEpochSB SWSEpoch REMEpoch Wake

tonOK=ts(Tones(idOK));
tonBad=ts(Tones(idBad));

Res(1)=length(Range(Restrict(tonBad,SWSEpoch)))/(length(Range(Restrict(tonBad,SWSEpoch)))+length(Range(Restrict(tonOK,SWSEpoch))))*100;
Res(2)=length(Range(Restrict(tonBad,REMEpoch)))/(length(Range(Restrict(tonBad,REMEpoch)))+length(Range(Restrict(tonOK,REMEpoch))))*100;
Res(3)=length(Range(Restrict(tonBad,Wake)))/(length(Range(Restrict(tonBad,Wake)))+length(Range(Restrict(tonOK,Wake))))*100;

Res(4)=length(Range(Restrict(tonBad,SWSEpoch)))/length(Range(tonBad))*100;
Res(5)=length(Range(Restrict(tonBad,REMEpoch)))/length(Range(tonBad))*100;
Res(6)=length(Range(Restrict(tonBad,Wake)))/length(Range(tonBad))*100;

disp(' ')
disp(num2str(Res))
disp(' ')

if 1
TonesOK=Range(Restrict(tonOK,SWSEpoch));
TonesBad=Range(Restrict(tonBad,SWSEpoch));
end

if 0
    
load H_Low_Spectrum
t=Spectro{2};f=Spectro{3};Sp=Spectro{1};
Stsd=tsd(t*1E4,Sp);
Stsd2=Stsd;t2=t;f2=f;

load B_High_Spectrum
t=Spectro{2};f=Spectro{3};Sp=Spectro{1};
Stsd=tsd(t*1E4,Sp);

par=[400 6000];
par=[200 70];
par=[200 50];

idi2=find(f2>1&f2<3);
%idi2=find(f2>5&f2<10);
idi1=find(f>50&f<70);

figure('color',[1 1 1])
subplot(3,2,1),
[M1,S1,tps]=AverageSpectrogram(Stsd,f,ts(TonesOK),par(1),par(2),2,0.7);title('OK')
subplot(3,2,2),
[M2,S2,tps]=AverageSpectrogram(Stsd,f,ts(TonesBad),par(1),par(2),2,0.7);title('Bad')
subplot(3,2,3),
[M3,S3,tps]=AverageSpectrogram(Stsd2,f2,ts(TonesOK),par(1),par(2),2,0.7);
subplot(3,2,4),
[M4,S4,tps]=AverageSpectrogram(Stsd2,f2,ts(TonesBad),par(1),par(2),2,0.7);
subplot(3,2,5),hold on
plot(tps/1E3,zscore(mean(M1(idi1(1),:),1)),'k','linewidth',1)
plot(tps/1E3,zscore(mean(M3(idi2(1),:),1)),'r')
yl=ylim;
line([0 0],yl,'color','k')
xlim([tps(1) tps(end)]/1E3)
xlabel('Times (s)')    
subplot(3,2,6), hold on
plot(tps/1E3,zscore(mean(M2(idi1,:),1)),'b','linewidth',1)
plot(tps/1E3,zscore(mean(M4(idi2,:),1)),'m')
yl=ylim;
line([0 0],yl,'color','k')
xlim([tps(1) tps(end)]/1E3)
xlabel('Times (s)')    


end


