function AnalyseQuantifExplo2(o,n,m)


smo=1;


try
    m;
catch
    m=n+8;
end

load behavResources

EpochS=ICSSEpoch;
EpochS=subset(EpochS,o);

XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);

[mapS,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,YS,'size',50,'limitmaze',[0 350]);close

Epoch1=subset(QuantifExploEpoch,n);
Epoch2=subset(QuantifExploEpoch,m);



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);

stimCenter(1)=mean(pxS);
stimCenter(2)=mean(pyS);


PF1=PF;
PF2=PF(size(PF,1):-1:1,:);
PF3=PF(size(PF,1):-1:1,size(PF,1):-1:1);
PF4=PF(:,size(PF,2):-1:1);

Centre=floor(centre);

figure('color',[1 1 1])
subplot(2,3,1), hold on
imagesc(PF1), axis xy
plot(Centre(1),Centre(2),'ko','markerfacecolor','w')
xlim([1 size(PF,1)])
ylim([1 size(PF,2)])
title('zone A')

subplot(2,3,2), hold on 
imagesc(PF2), axis xy
plot(Centre(1),Centre(2),'ko','markerfacecolor','w')
xlim([1 size(PF,1)])
ylim([1 size(PF,2)])
title('zone B')

subplot(2,3,4), hold on 
imagesc(PF3), axis xy
plot(Centre(1),Centre(2),'ko','markerfacecolor','w')
xlim([1 size(PF,1)])
ylim([1 size(PF,2)])
title('zone C')

subplot(2,3,5), hold on 
imagesc(PF4), axis xy
plot(Centre(1),Centre(2),'ko','markerfacecolor','w')
xlim([1 size(PF,1)])
ylim([1 size(PF,2)])
title('zone D')


numfig=gcf;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 350]);close
[Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 350]);close


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

m1a=OcR1;
m1a(PF==0)=0;
m2a=OcR2;
m2a(PF==0)=0;

m1Sa=OcRS1;
m1Sa(PF==0)=0;
m2Sa=OcRS2;
m2Sa(PF==0)=0;


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

m1b=OcR1;
m1b(PF2==0)=0;
m2b=OcR2;
m2b(PF2==0)=0;

m1Sb=OcRS1;
m1Sb(PF2==0)=0;
m2Sb=OcRS2;
m2Sb(PF2==0)=0;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

m1c=OcR1;
m1c(PF3==0)=0;
m2c=OcR2;
m2c(PF3==0)=0;

m1Sc=OcRS1;
m1Sc(PF3==0)=0;
m2Sc=OcRS2;
m2Sc(PF3==0)=0;


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

m1d=OcR1;
m1d(PF4==0)=0;
m2d=OcR2;
m2d(PF4==0)=0;

m1Sd=OcRS1;
m1Sd(PF4==0)=0;
m2Sd=OcRS2;
m2Sd(PF4==0)=0;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


legend{1}='Pr A';
legend{2}='Pr B';
legend{3}='Pr C';
legend{4}='Pr D';
legend{5}='Po A';
legend{6}='Po B';
legend{7}='Po C';
legend{8}='Po D';

figure(numfig)

subplot(2,3,[3,6])
bar([sum(sum(m1Sa)) sum(sum(m1Sb)) sum(sum(m1Sc)) sum(sum(m1Sd)) sum(sum(m2Sa)) sum(sum(m2Sb)) sum(sum(m2Sc)) sum(sum(m2Sd))],'k')

set(gca,'xtick',1:8)
set(gca,'xticklabel',legend)


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

% 
% load behavResources
% 
% Epoch=intervalSet(2000*1E4,3000*1E4);
% X=Restrict(X,Epoch);
% Y=Restrict(Y,Epoch);



ce=mean(Data(Restrict(X,or(Epoch1,Epoch2))));
ce(2)=mean(Data(Restrict(Y,or(Epoch1,Epoch2))));


ce(1)=190;
ce(2)=125;


%-------------------------------------------------------------------------


zone1=thresholdIntervals(X1,ce(1),'Direction','Above');
zone2=thresholdIntervals(X1,ce(1),'Direction','Below');
zone3=thresholdIntervals(Y1,ce(2),'Direction','Above');
zone4=thresholdIntervals(Y1,ce(2),'Direction','Below');

zoneNE=and(zone1,zone3);
zoneSE=and(zone1,zone4);
zoneNW=and(zone2,zone3);
zoneSW=and(zone2,zone4);


figure('color',[1 1 1]), 
subplot(2,2,1), hold on, 
plot(pxS,pyS,'.','color',[0.9 0.9 0.9])
plot(Data(X1), Data(Y1))
plot(ce(1),ce(2),'ko','markerfacecolor','k')
plot(Data(Restrict(X1,zoneNE)), Data(Restrict(Y1,zoneNE)),'g')
plot(Data(Restrict(X1,zoneSE)), Data(Restrict(Y1,zoneSE)),'r')
plot(Data(Restrict(X1,zoneNW)), Data(Restrict(Y1,zoneNW)),'k')
xlim([0 300])
ylim([0 300])

TpsNE1=length(Data(Restrict(X1,zoneNE)))/30;
TpsSE1=length(Data(Restrict(X1,zoneSE)))/30;
TpsNW1=length(Data(Restrict(X1,zoneNW)))/30;
TpsSW1=length(Data(Restrict(X1,zoneSW)))/30;


%-------------------------------------------------------------------------


zone1=thresholdIntervals(X2,ce(1),'Direction','Above');
zone2=thresholdIntervals(X2,ce(1),'Direction','Below');
zone3=thresholdIntervals(Y2,ce(2),'Direction','Above');
zone4=thresholdIntervals(Y2,ce(2),'Direction','Below');

zoneNE=and(zone1,zone3);
zoneSE=and(zone1,zone4);
zoneNW=and(zone2,zone3);
zoneSW=and(zone2,zone4);



subplot(2,2,2), hold on, 
plot(pxS,pyS,'.','color',[0.9 0.9 0.9])
plot(Data(X2), Data(Y2))
plot(ce(1),ce(2),'ko','markerfacecolor','k')
plot(Data(Restrict(X2,zoneNE)), Data(Restrict(Y2,zoneNE)),'g')
plot(Data(Restrict(X2,zoneSE)), Data(Restrict(Y2,zoneSE)),'r')
plot(Data(Restrict(X2,zoneNW)), Data(Restrict(Y2,zoneNW)),'k')
xlim([0 300])
ylim([0 300])


TpsNE2=length(Data(Restrict(X2,zoneNE)))/30;
TpsSE2=length(Data(Restrict(X2,zoneSE)))/30;
TpsNW2=length(Data(Restrict(X2,zoneNW)))/30;
TpsSW2=length(Data(Restrict(X2,zoneSW)))/30;



legend2{1}='Pr NE';
legend2{2}='Pr SE';
legend2{3}='Pr NW';
legend2{4}='Pr SW';
legend2{5}='Po NE';
legend2{6}='Po SE';
legend2{7}='Po NW';
legend2{8}='Po SW';
TpsT1=(TpsNE1+TpsSE1+TpsNW1+TpsSW1)/100;
TpsT2=(TpsNE2+TpsSE2+TpsNW2+TpsSW2)/100;

subplot(2,2,3:4), 
%bar([TpsNE1 TpsSE1 TpsNW1 TpsSW1 TpsNE2 TpsSE2 TpsNW2 TpsSW2 ],'k')

bar([TpsNE1/TpsT1 TpsSE1/TpsT1 TpsNW1/TpsT1 TpsSW1/TpsT1 TpsNE2/TpsT2 TpsSE2/TpsT2 TpsNW2/TpsT2 TpsSW2/TpsT2],'k')




set(gca,'xtick',1:8)
set(gca,'xticklabel',legend2)




