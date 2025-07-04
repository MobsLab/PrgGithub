%ValidationDetectionOscillationsVSspikes

load StateEpochSB SWSEpoch Wake REMEpoch

try 
    ch;
catch
    ch=1;
end

try
    S;
    NumNeurons;
catch
    LoadNeuronPFCx
end

%load newDeltaPaCx
%load newDeltaMoCx
load newDeltaPFCx

tDelta=Range(Restrict(ts(tDelta),SWSEpoch));

if ch
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,0,[20 70],1);
else
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.02,1,5,[20 70],1);
end

Down=and(Down,SWSEpoch);
%Down=mergeCloseIntervals(Down,200);
Down=dropShortIntervals(Down,700);

par=[50 150];
[C1,B1]=CrossCorr(tDelta,Start(Down),par(1),par(2));
[C1b,B1b]=CrossCorr(Start(Down),tDelta,par(1),par(2));
[C2,B2]=CrossCorr(Start(Down),Start(Down),par(1),par(2));C2(B2==0)=0;
[C3,B3]=CrossCorr(tDelta,tDelta,par(1),par(2));C3(B3==0)=0;

figure('color',[1 1 1]), hold on
plot(B1/1E3,C1,'k'),plot(B1b/1E3,C1b,'color',[0.6 0.4 0.4]),plot(B2/1E3,C2,'b'),plot(B3/1E3,C3,'r')
xlim([B1(2) B1(end-1)]/1E3)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])


% smo=1.5;
% figure('color',[1 1 1]), hold on
% plot(B1/1E3,SmoothDec(C1,smo),'k'),
% plot(B2/1E3,SmoothDec(C2,smo),'b'),
% plot(B3/1E3,SmoothDec(C3,smo),'r')
% 

clear del
for i=1:length(tDelta)
   del(i)=min(abs(tDelta(i)-(Start(Down)+End(Down))/2));
end
Res(1)=length(tDelta);
Res(2)=length(find(del<2000))/length(del)*100;

clear del2
st=Start(Down);en=End(Down);
for i=1:length(Start(Down))
   del2(i)=min(abs(((st(i)+en(i))/2)-tDelta));
end
Res(3)=length(Start(Down));
Res(4)=length(find(del2<2000))/length(del2)*100;

OccDown=length(Start(Down))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
OccDelta=length(tDelta)/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));

title(['Delta (red): ',num2str(floor(Res(1))),',  ',num2str(floor(Res(2))),'%, ',num2str(floor(100*OccDelta)/100),' Hz;    Down (blue): ',num2str(floor(Res(3))),',  ',num2str(floor(Res(4))),'%,  ',num2str(floor(100*OccDown)/100),' Hz'])


