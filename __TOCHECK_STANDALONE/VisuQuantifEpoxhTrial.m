function VisuQuantifEpoxhTrial(N,o,numtrial,pos)

try 
    pos;
catch
    pos=0;
end

load behavResources
if pos
load ParametersAnalyseICSS X Y
end
EpochS=ICSSEpoch;
EpochS=subset(EpochS,o);
XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);

px =Data(Restrict(XS,stimS,'align','closest'));
py =Data(Restrict(YS,stimS,'align','closest'));
figure('color',[1 1 1]), plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
hold on, plot(Data(Restrict(X,subset(QuantifExploEpoch,N(numtrial)))),Data(Restrict(Y,subset(QuantifExploEpoch,N(numtrial)))),'k','linewidth',2)
hold on, hold on, plot(px,py,'r.')
title(num2str(numtrial))