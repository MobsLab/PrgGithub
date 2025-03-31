
MovEpoch=thresholdIntervals(V,7,'Direction','Above');
ImmobEpoch=thresholdIntervals(V,2,'Direction','Below');

ch='200';
% epoch = or(hab,or(testPre,condi));
epoch=hab;
eval(['epochtemp=and(and(MovEpoch,epoch),EpochOK',ch,');'])
% epochtemp=and(and(MovEpoch,hab),GoodEpoch);
% eval(['epochtemp=and(and(ImmobEpoch,hab),EpochOK',ch,');'])
%eval(['epochtemp=and(hab,EpochOK',ch,');'])
% epochtemp=and(and(ImmobEpoch,hab),EpochOK504);
% epochtemp=and(hab,EpochOK36)

eval(['LinearTrueTsd = LinearTrueTsd',ch,';'])
eval(['LinearPredTsd = LinearPredTsd',ch,';'])

nbbin=20;
clear nb dur
for i=1:nbbin
    temp1=thresholdIntervals(LinearTrueTsd,(i-1)/(nbbin-1),'Direction','Above');
    temp2=thresholdIntervals(LinearTrueTsd,i/(nbbin-1),'Direction','Below');
    dur(i,:)=[(i-1)/nbbin i/nbbin];
    EpochLin{i}=and(epochtemp,and(temp1,temp2)); 
    nb(i)=length(Data(Restrict(LinearTrueTsd,EpochLin{i})));
end


clear R h h2
for i=1:nbbin
R(i,1)=mean(abs(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp)))));
R(i,2)=stdError(abs(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp)))));
[h(i,:),b]=hist(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp))),[-1:0.01:1]);
[h2(i,:),b2]=hist(Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp))),[0.025:0.05:0.975]);
end

[H,B]=hist(Data(Restrict(LinearTrueTsd,epochtemp)),[0.05:0.05:0.95]);


figure, 
subplot(1,3,1), errorbar([1:nbbin]/nbbin,R(:,1),R(:,2)), xlim([0 1])
subplot(1,3,2), imagesc(b,[1:nbbin]/nbbin,zscore(h')'), title(ch)
subplot(1,3,3), imagesc([0.025:0.05:0.975],[1:nbbin]/nbbin,zscore(h2))
subplot(1,3,1), xlabel('Linearized Position')
subplot(1,3,1), ylabel('Mean Linear Error')
subplot(1,3,2), xlabel('Value of the Error')
subplot(1,3,2), ylabel('Linearized Position')
subplot(1,3,3), xlabel('True Linearized Position')
subplot(1,3,3), ylabel('Decoded Linearized Position')


% figure, 
% subplot(1,3,[1,2]),plot(Data(Restrict(LinearTrueTsd200,epochtemp)))
% subplot(1,3,3),hold on, bar([1:nbbin]/nbbin,nb,1,'k'), plot(B,H,'ro-')
figure, 
subplot(1,3,[1,2]),plot(Data(Restrict(LinearTrueTsd,epochtemp)))
subplot(1,3,3),hold on, barh([1:nbbin]/nbbin,nb,1,'k'), plot(H,B,'ro-'), ylim([0 1])


figure, scatter(Data(Restrict(X,epochtemp)),Data(Restrict(Y,epochtemp)),10,Data(Restrict(LinearTrueTsd,Restrict(Y,epochtemp)))-Data(Restrict(LinearPredTsd,Restrict(Y,epochtemp))),'filled')
