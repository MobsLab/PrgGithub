%CajalSchoolFirstStepSpindles2018

loadSubstageCajal
disp(' ')
numLFP=input('Choose the number of LFP: ');

LFPtemp=LoadLFPsCajal(numLFP);
LFP=LFPtemp{1};
ti=num2str(numLFP);

SpiO=ObservationSpindlesSingle(LFP,SWSEpoch,[10 15]); 

a=a+5; xlim([SpiO(a,1)-3 SpiO(a,3)+3])



[msp,s,tps]=mETAverage(Spi(:,2)*1E4,Range(LFP),Data(LFP),1,1500);

figure, hold on, 
plot(tps,msp,'color',[0.2 0 0])
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])

