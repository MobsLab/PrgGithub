%ExpDecayBulbSleepCycle


%Stsd=tsd(tHpc*1E4,SpHpc);
%Stsd=tsd(tHpc*1E4,SpPfc);
Stsd=tsd(tHpc*1E4,SpBulb);


tps=0:0.01:1;
clear pow
ReNormT2=[];
ReNormT=zeros(length(tps),261);
clear ReNormTemp
for i=1:length(Start(SleepCycle))    
    [ReNormTemp{i},ff,tps]=RescaleSpectroram0to1(Stsd,f,subset(SleepCycle,i),tps);
    ReNormT=ReNormT+ReNormTemp{i};
    ReNormT2=[ReNormT2;ReNormTemp{i}];
    pow(i,:)=mean(ReNormTemp{i}(:,find(ff>2.5&ff<3.5)),2);
end
powT2=mean(ReNormT2(:,find(ff>2.5&ff<3.5)),2);

tpsT2=0:median(diff(tps)):(length(powT2)-1)*median(diff(tps));
[rT2,pT2]=corrcoef(tpsT2,powT2); rT2=rT2(1,2); pT2=pT2(1,2);
varT2=polyfit(tpsT2,powT2',1);
varT2e=polyfit(tpsT2,log(powT2)',1);

[rT2l,pT2l]=corrcoef(tpsT2,10*log10(powT2)); rT2l=rT2l(1,2); pT2l=pT2l(1,2);
varT2l=polyfit(tpsT2,10*log10(powT2'),1);
varT2le=polyfit(tpsT2,log(10*log10(powT2')),1);

figure('color',[1 1 1])
subplot(2,2,1), imagesc(tps,ff,10*log10(ReNormT)'), axis xy
subplot(2,2,2), imagesc(tps,ff,10*log10(ReNormT2)'), axis xy
%subplot(2,2,3), plot(SmoothDec(pow,[0.7 0.001]))
subplot(2,2,3),imagesc(10*log10(pow))
subplot(2,2,4), hold on, 
plot(tpsT2,10*log10(powT2))
% plot(tpsT2,varT2l(1)*tpsT2+varT2l(2),'r'), 
plot(tpsT2,exp(varT2le(2))*exp(tpsT2*varT2le(1)),'r'), 
title(['r= ',num2str(rT2),', p= ',num2str(pT2)])


figure('color',[1 1 1])
subplot(3,4,1:2), imagesc(tps,ff,(ReNormT)'), axis xy
subplot(3,4,3:4), imagesc(tps,ff,(ReNormT2)'), axis xy, caxis([0 3E5])
%subplot(2,2,3), plot(SmoothDec(pow,[0.7 0.001]))
subplot(3,4,5:6),imagesc((pow))
subplot(3,4,7:8), hold on, 
plot(tpsT2,powT2)
% plot(tpsT2,varT2(1)*tpsT2+varT2(2),'r'), 
plot(tpsT2,exp(varT2e(2))*exp(tpsT2*varT2e(1)),'r'), 
title(['r= ',num2str(rT2),', p= ',num2str(pT2)])



for i=1:length(Start(SleepCycle)) 
[rTemp,pTemp]=corrcoef(tpsT2,powT2); r(i)=rTemp(1,2); p(i)=pTemp(1,2);
var(i,:)=polyfit(tps,pow(i,:),1);
var2(i,:)=polyfit(tps,log(pow(i,:)),1);
end

nbSC=length(Start(SleepCycle)) ;

% subplot(3,4,9), hold on, 
% line([tps(1) tps(end)],[0 0],'color',[0.5 0.5 0.5],'linewidth',1)
% subplot(3,4,10), hold on, 
% line([tps(1) tps(end)],[0 0],'color',[0.5 0.5 0.5],'linewidth',2)
% 
% for i=1:nbSC
% subplot(3,4,9), hold on, plot(tps,var(i,1)*tps+var(i,2),'color',[0 0 i/nbSC])
% subplot(3,4,10), hold on, 
% plot(tps,var(i,1)*tps,'color',[i/nbSC 0 0])
% end
% subplot(3,4,11), hold on, plot(var(:,2),'bo-')
% subplot(3,4,11), hold on, 
% plot(var(:,1),'ro-')
% line([0 length(var)],[0 0],'color',[0.5 0.5 0.5])
% subplot(3,4,12), hold on, 
% plot(var(:,1),var(:,2),'ko','markerfacecolor','k')
% 


subplot(3,4,9), hold on, 
line([tps(1) tps(end)],[0 0],'color',[0.5 0.5 0.5],'linewidth',1)
subplot(3,4,10), hold on, 
line([tps(1) tps(end)],[0 0],'color',[0.5 0.5 0.5],'linewidth',2)

for i=1:nbSC
subplot(3,4,9), hold on, plot(tps,exp(var2(i,2))*exp(tps*var2(i,1)),'color',[0 0 i/nbSC])
subplot(3,4,10), hold on, 
plot(tps,exp(var2(i,1)*tps),'color',[i/nbSC 0 0])
end
subplot(3,4,11), hold on, plotyy(1:length(var2(:,1)),exp(var2(:,2)),1:length(var2(:,1)),exp(var2(:,1)))
% plot(exp(var2(:,2)),'bo-')
% subplot(3,4,11), hold on, 
% plot(exp(var2(:,1)),'ro-')
line([0 length(var)],[0 0],'color',[0.5 0.5 0.5])
subplot(3,4,12), hold on, 
plot((var(:,1)),(var(:,2)),'ko','markerfacecolor','k')









tps2=0:0.001:1;
idx=find((End(SleepCycle,'s')-Start(SleepCycle,'s'))>100);
ReNormT=zeros(3,length(tps2));
for i=1:length(idx) 
Mat=Restrict(SleepStagesC,subset(SleepCycle,idx(i)));
rg=Range(Mat);
MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
ReNormT(1,:)=ReNormT(1,:)+(Data(Restrict(MatTemp,tps2))==1)';
ReNormT(2,:)=ReNormT(2,:)+(Data(Restrict(MatTemp,tps2))==3)';
ReNormT(3,:)=ReNormT(3,:)+(Data(Restrict(MatTemp,tps2))==4)';
end

ReNormT(1,:)=ReNormT(1,:)/length(idx);
ReNormT(2,:)=ReNormT(2,:)/length(idx);
ReNormT(3,:)=ReNormT(3,:)/length(idx);

figure('color',[1 1 1]), plot(tps2,ReNormT')

%------------------------------------------------------------


NewSpleepStage=Data(SleepStagesC);

RG=Range(SleepStagesC);

RG1=Range(Restrict(SleepStagesC,N1));
RG2=Range(Restrict(SleepStagesC,N2));
RG3=Range(Restrict(SleepStagesC,N3));

id1=ismember(RG,RG1);
id2=ismember(RG,RG2);
id3=ismember(RG,RG3);

NewSpleepStage=Data(SleepStagesC);
NewSpleepStage(id1)=1.5;
NewSpleepStage(id2)=2;
NewSpleepStage(id3)=2.5;

SleepN=tsd(RG,NewSpleepStage);

tps2=0:0.0001:1;
idx=find((End(SleepCycle,'s')-Start(SleepCycle,'s'))>100);
ReNormTnew=zeros(5,length(tps2));
for i=1:length(idx) 
Mat=Restrict(SleepN,subset(SleepCycle,idx(i)));
rg=Range(Mat);
MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
ReNormTnew(1,:)=ReNormTnew(1,:)+(Data(Restrict(MatTemp,tps2))==1.5)';
ReNormTnew(2,:)=ReNormTnew(2,:)+(Data(Restrict(MatTemp,tps2))==2)';
ReNormTnew(3,:)=ReNormTnew(3,:)+(Data(Restrict(MatTemp,tps2))==2.5)';
ReNormTnew(4,:)=ReNormTnew(4,:)+(Data(Restrict(MatTemp,tps2))==3)';
ReNormTnew(5,:)=ReNormTnew(5,:)+(Data(Restrict(MatTemp,tps2))==4)';
end

ReNormTnew(1,:)=ReNormTnew(1,:)/length(idx);
ReNormTnew(2,:)=ReNormTnew(2,:)/length(idx);
ReNormTnew(3,:)=ReNormTnew(3,:)/length(idx);
ReNormTnew(4,:)=ReNormTnew(4,:)/length(idx);
ReNormTnew(5,:)=ReNormTnew(5,:)/length(idx);
figure('color',[1 1 1]), hold on
plot(tps2,ReNormTnew(1,:),'g','linewidth',2)
plot(tps2,ReNormTnew(2,:),'m','linewidth',2)
plot(tps2,ReNormTnew(3,:),'r','linewidth',2)
plot(tps2,ReNormTnew(4,:),'b','linewidth',2)
plot(tps2,ReNormTnew(5,:),'k','linewidth',2)
line([0 1],[1 1],'color','k')
line([1 1],[0 1],'color','k')


idx=find((End(REMEpochC,'s')-Start(REMEpochC,'s'))>25);
en=End(REMEpochC);
st=Start(REMEpochC);

figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(en(idx)),200,200,2,[],1); title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(st(idx)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(en(idx)),200,200,2,[],1); title('Hpc, SleepCycle')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(st(idx)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(en(idx)),200,200,2,[],1); title('Bulb')
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(st(idx)),200,200,2,[],1);


if 0

figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N1)),200,200,2,[],1);title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N1)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N1)),200,200,2,[],1); title('Hpc, N1')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N1)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N1)),200,200,2,[],1);
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N1)),200,200,2,[],1);




figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N2)),200,200,2,[],1);title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N2)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N2)),200,200,2,[],1); title('Hpc, N2')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N2)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N2)),200,200,2,[],1);title('Bulb')
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N2)),200,200,2,[],1);



figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N3)),200,200,2,[],1);title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N3)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N3)),200,200,2,[],1); title('Hpc, N3')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N3)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(N3)),200,200,2,[],1);title('Bulb')
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(N3)),200,200,2,[],1);




figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(WakeC)),200,200,2,[],1);title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(WakeC)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(WakeC)),200,200,2,[],1); title('Hpc, WakeC')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(WakeC)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(WakeC)),200,200,2,[],1);title('Bulb')
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(WakeC)),200,200,2,[],1);



figure('color',[1 1 1])
Stsd=tsd(tHpc*1E4,SpPfc);
subplot(2,3,1), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(SWSEpochC)),200,200,2,[],1);title('Pfc')
subplot(2,3,4), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(SWSEpochC)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpHpc);
subplot(2,3,2), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(SWSEpochC)),200,200,2,[],1); title('Hpc, SWS')
subplot(2,3,5), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(SWSEpochC)),200,200,2,[],1);
Stsd=tsd(tHpc*1E4,SpBulb);
subplot(2,3,3), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(End(SWSEpochC)),200,200,2,[],1);title('Bulb')
subplot(2,3,6), [M,S,t]=AverageSpectrogram(Stsd,fBulb,ts(Start(SWSEpochC)),200,200,2,[],1);

end

