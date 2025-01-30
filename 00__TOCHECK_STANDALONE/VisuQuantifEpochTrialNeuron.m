function positions=VisuQuantifEpochTrialNeuron(M,NumNeuron,o,numtrial,vTh,pos)


%vTh=25;


try 
    pos;
catch
    pos=0;
end

load behavResources
load SpikeData S

if pos
load ParametersAnalyseICSS X Y
end


% try

    load xyMax xMaz yMaz
    xMaz;
    
    [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
% end



le=length(o);
tpsD=[];
tpsF=[];

for i=1:le
    tpsD=[tpsD;tpsdeb{o(i)}*1E4];
    tpsF=[tpsF;tpsfin{o(i)}*1E4];
end

EpochS=intervalSet(tpsD,tpsF);
EpochS=and(EpochS,TrackingEpoch);

XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);

Mvt=thresholdIntervals(V,vTh,'Direction','Above');

stimS=Restrict(S{NumNeuron},and(EpochS,Mvt));


px =Data(Restrict(XS,stimS,'align','closest'));
py =Data(Restrict(YS,stimS,'align','closest'));

% 
% figure('color',[1 1 1]), plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
% hold on, hold on, plot(px,py,'ro','markerfacecolor','r')
% hold on, plot(Data(Restrict(X,subset(QuantifExploEpoch,M(numtrial)))),Data(Restrict(Y,subset(QuantifExploEpoch,M(numtrial)))),'k','linewidth',2)
% title(pwd)
for i=1:length(numtrial)
    Xx{i}=Data(Restrict(X,subset(QuantifExploEpoch,M(numtrial(i)))));
    Yy{i}=Data(Restrict(Y,subset(QuantifExploEpoch,M(numtrial(i)))));
    Xxx(i)=Xx{i}(1);
    Yyy(i)=Yy{i}(1);
end


figure('color',[1 1 1]), plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
hold on, hold on, plot(px,py,'r.','markerfacecolor','r')
hold on, plot(Data(Restrict(X,subset(QuantifExploEpoch,M(numtrial)))),Data(Restrict(Y,subset(QuantifExploEpoch,M(numtrial)))),'k','linewidth',2)
plot(Xxx,Yyy,'bo','markerfacecolor','b','linewidth',4)
title(pwd)


positions=[Data(Restrict(X,subset(QuantifExploEpoch,M(numtrial)))) Data(Restrict(Y,subset(QuantifExploEpoch,M(numtrial))))];


