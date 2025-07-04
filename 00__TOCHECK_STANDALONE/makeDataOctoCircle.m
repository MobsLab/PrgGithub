%makeDataOctoCircle
clear all

load ICSS-Mouse-108-07122013-01-ExploEnvBord-wideband

Art=130;
[PosC1,speed1]=RemoveArtifacts(Pos(:,1:3),Art); 

X=tsd(PosC1(:,1)*1E4,PosC1(:,2));
Y=tsd(PosC1(:,1)*1E4,PosC1(:,3));
Vtemp=tsd(PosC1(:,1)*1E4,[speed1;speed1(end)]);

rg=Range(X);
[X,Y,V,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,Vtemp,ts([]),intervalSet(rg(1),rg(end)),1);
load xyMax 
save xyMax1 xMaz yMaz


X1=tsd(Range(X),rescale(Data(X),0,100));
Y1=tsd(Range(Y),rescale(Data(Y),0,100));
V1=V;

load ICSS-Mouse-108-07122013-02-ExploEnvBord-wideband

Art=130;
[PosC2,speed2]=RemoveArtifacts(Pos(:,1:3),Art); 

X=tsd(PosC2(:,1)*1E4,PosC2(:,2));
Y=tsd(PosC2(:,1)*1E4,PosC2(:,3));
Vtemp=tsd(PosC2(:,1)*1E4,[speed2;speed2(end)]);

rg=Range(X);
[X,Y,V,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,Vtemp,ts([]),intervalSet(rg(1),rg(end)),1);

load xyMax
save xyMax2 xMaz yMaz

X2=tsd(Range(X),rescale(Data(X),0,100));
Y2=tsd(Range(Y),rescale(Data(Y),0,100));
V2=V;

freq1=1/median(diff(Range(X1,'s')));
freq2=1/median(diff(Range(X2,'s')));

freq=mean([freq1,freq2]);
 
X=tsd([1:length(Range(X1))+length(Range(X2))]'/freq*1E4,[Data(X1)',Data(X2)']');
Y=tsd([1:length(Range(Y1))+length(Range(Y2))]'/freq*1E4,[Data(Y1)',Data(Y2)']');
V=tsd([1:length(Range(Y1))+length(Range(Y2))]'/freq*1E4,[Data(V1)',Data(V2)']');
 
save behavResources X Y V freq

figure, plot(Data(X),Data(Y))
hold on, axis([-5 105 -5 105])





