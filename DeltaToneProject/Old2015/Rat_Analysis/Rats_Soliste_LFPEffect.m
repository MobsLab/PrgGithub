% Sleep Scoring : PFCx channel > # 1 , 2 , 3 & 4
!gunzip 190309eeg3.mat.gz
load('/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/190309/190309eeg3.mat')
!gzip 190309eeg3.mat
figure, plot(Range(EEG3,'s'),Data(EEG3))

EndSWSEpoch1=input('what end time for SWSEpoch1 ? ');
SWSEpoch1=intervalSet(0,EndSWSEpoch1*1E4);

StartSWSEpoch2=input('what start time for SWSEpoch2 ? ');
EndSWSEpoch2=input('what end time for SWSEpoch2 ? ');
SWSEpoch2=intervalSet(StartSWSEpoch2*1E4,EndSWSEpoch2*1E4);

load SpikeData
NumNeuronsOK=1:length(S);
Ssws=Restrict(S,SWSEpoch1);
Ssws2=Restrict(S,SWSEpoch2);

clear C
clear Cz


k=1;
for i=1:length(NumNeuronsOK)
    num=1:length(NumNeuronsOK);
    num(i)=[];
    [C(k,:),B]=CrossCorr(Range(Ssws{NumNeuronsOK(i)}),Range(poolNeurons(Ssws,NumNeuronsOK(num))),10,500);
    [Cend(k,:),B]=CrossCorr(Range(Ssws2{NumNeuronsOK(i)}),Range(poolNeurons(Ssws2,NumNeuronsOK(num))),10,500);
    k=k+1;
end

C2=C; C2(find(isnan(C2)))=0;
Cz=zscore(C2')';
Czs=SmoothDec(Cz,[0.01,3]);

C2end=Cend; C2end(find(isnan(C2end)))=0;
Czend=zscore(C2end')';
Czsend=SmoothDec(Czend,[0.01,3]);

p=1;
for i=1:length(NumNeuronsOK)
    if Cz(i,250)>2*mean(Cz(i,1:200))
        NeurChorID(p)=i;
        p=p+1;
    end
end

k=1;
for j=1:length(NumNeuronsOK)
    [m(k,:),s,tps]=mETAverage(Range(Ssws{j}),Range(EEG3),Data(EEG3),1,5000);
    [m2(k,:),s,tps]=mETAverage(Range(Ssws2{j}),Range(EEG3),Data(EEG3),1,5000);
    
    figure,
    subplot(4,1,1), plot(tps/1E3,m(k,:),'k'), yl=ylim; hold on, line([0 0],yl,'color','b'),
    subplot(4,1,1), plot(tps/1E3,m2(k,:),'r')
    hold on, title('mean LFP PFCx signal during Spiking activity')
    
    subplot(4,1,2), plot(B/1E3,Cz(j,:),'k')
    hold on, plot(B/1E3,Czend(j,:),'r'), yl=ylim; hold on, line([0 0],yl,'color','b')
    hold on, title('Population Spiking activity during single neuron spk activity')
    
    subplot(4,1,3), plot(tps/1E3,m(k,:),'k'), yl=ylim; hold on, line([0 0],yl,'color','b'), xlim([-0.5 0.5])
    subplot(4,1,3), plot(tps/1E3,m2(k,:),'r')
    hold on, title('mean LFP PFCx signal during Spiking activity (ZOOM)')
    
    subplot(4,1,4), plot(B/1E3,Cz(j,:),'k')
    hold on, plot(B/1E3,Czend(j,:),'r'), yl=ylim; hold on, line([0 0],yl,'color','b'), xlim([-0.5 0.5])
    hold on, title('Population Spiking activity during single neuron spk activity(ZOOM)')
    k=k+1;
end


% ----------------------------------------------------------------------------------------------------------------

m2=m;m(find(tps==0))=0;
m2(find(isnan(m2)))=0;
mz=zscore(m2')';
mzs=SmoothDec(mz,[0.01,5]);


figure, subplot(1,3,1), imagesc(B/1E3,NumNeuronsOK,C)
subplot(1,3,2), imagesc(B/1E3,NumNeuronsOK,Cz)
subplot(1,3,3), imagesc(B/1E3,NumNeuronsOK,Czs)
hold on, title('SWS Epoch 1')

figure, subplot(1,3,1), imagesc(B/1E3,NumNeuronsOK,Cend)
subplot(1,3,2), imagesc(B/1E3,NumNeuronsOK,Czend)
subplot(1,3,3), imagesc(B/1E3,NumNeuronsOK,Czsend)
hold on, title('SWS Epoch 2')

[BE,id]=sort(mean(Czs(:,200:300),2));
figure, subplot(1,6,1), imagesc(B/1E3,NumNeuronsOK,C(id,:)), xlim([-0.5 0.5])
subplot(1,6,2), imagesc(B/1E3,NumNeuronsOK,Cz(id,:)), xlim([-0.5 0.5])
subplot(1,6,3), imagesc(B/1E3,NumNeuronsOK,Czs(id,:)), xlim([-0.5 0.5])
subplot(1,6,4), imagesc(tps/1E3,NumNeuronsOK,m(id,:)), xlim([-0.5 0.5])
subplot(1,6,5), imagesc(tps/1E3,NumNeuronsOK,mz(id,:)), xlim([-0.5 0.5])
subplot(1,6,6), imagesc(tps/1E3,NumNeuronsOK,mzs(id,:)), xlim([-0.5 0.5])


