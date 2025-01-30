function Q=QuantifQuadrants(N,M,varargin)

load SpikeData
load behavResources

NumNeuron=0; %Neuron used for Place Field
NumExplo=1;
%N=1:8;
%M=9:16;
smo=4;
sizeMap=50;
Vth=15;
thPF=0.3;
posArt=1;
sav=0;
immobb=1;
thfalseTrial=50;

 for i = 1:2:length(varargin),

   %           if ~isa(varargin{i},'char'),
    %            error(['Parameter ' num2str(i) ' is not a property (type ''help ICSSexplo'' for details).']);
     %         end

              switch(lower(varargin{i})),

                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'figure',
                  plo = varargin{i+1};
                  if ~isa(plo,'numeric'),
                    error('Incorrect value for property ''figure'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
               case 'positions',
                  posArt = varargin{i+1};
                  if posArt=='y'
                      posArt=1;
                  else
                      posArt=0;
                  end
                  if ~isa(posArt,'numeric'),
                    error('Incorrect value for property ''positions'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'immobility',
                  immobb = varargin{i+1};
                  if immobb=='y'
                      immobb=1;
                  else
                      immobb=0;
                  end
                  
                  if ~isa(immobb,'numeric'),
                    error('Incorrect value for property ''immobility'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
  
                case 'save',
                  sav = varargin{i+1};
                  if sav=='y'
                      sav=1;
                  else
                      sav=0;
                  end
                  
                  if ~isa(immobb,'numeric'),
                    error('Incorrect value for property ''immobility'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                  
                 case 'thresholdPF',
                  thPF = varargin{i+1};
                  if ~isa(thPF,'numeric'),
                    error('Incorrect value for property ''thresholdPF'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end 
                  
                case 'speed',
                  Vth = varargin{i+1};
                  if ~isa(Vth,'numeric'),
                    error('Incorrect value for property ''speed'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'time',
                  limTemp = varargin{i+1};
                  if ~isa(limTemp,'numeric'),
                    error('Incorrect value for property ''time'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'size',
                  sizeMap = varargin{i+1};
                  if ~isa(sizeMap,'numeric'),
                    error('Incorrect value for property ''size'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end 

                case 'largearea',
                  LargeAreaTh = varargin{i+1};
                  if ~isa(LargeAreaTh,'numeric'),
                    error('Incorrect value for property ''LargeAreaTh'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end                   
                  
                case 'neuron',
                  temp = varargin{i+1};
                  NumNeuron=temp(1);
                  NumExplo=temp(2:end);
                
                case 'falsetrials',
                  thfalseTrial = varargin{i+1};  
                  
              end
 end
 
 
    Starts=[];
    Ends=[];
for i=NumExplo
    Starts=[Starts,tpsdeb{i}];
    Ends=[Ends,tpsfin{i}];
end
epPF=intervalSet(Starts*1E4,Ends*1E4);
epPF=intersect(epPF,TrackingEpoch);
if NumNeuron==0
    spike=Restrict(stim,epPF);
else
spike=Restrict(S{NumNeuron},epPF);
end


N=RemoveFalseTrialQuantifExplo(N,thfalseTrial,X,Y,QuantifExploEpoch);
M=RemoveFalseTrialQuantifExplo(M,thfalseTrial,X,Y,QuantifExploEpoch);

M

Epoch2=subset(QuantifExploEpoch,N); %Exlpo Pré
Epoch3=subset(QuantifExploEpoch,M); %Explo Post
Epoch2=intersect(Epoch2,TrackingEpoch);
Epoch3=intersect(Epoch3,TrackingEpoch);




if immobb
    Mvt=thresholdIntervals(V,Vth, 'Direction','Above');
    X=Restrict(X,Mvt);
    Y=Restrict(Y,Mvt);
    S=Restrict(S,Mvt);
    V=Restrict(V,Mvt);
end

listQuantif=find(diff(Start(QuantifExploEpoch,'s'))>200);


disp(' ')
disp(num2str(listQuantif))
disp(num2str(length(Start(QuantifExploEpoch,'s'))))
disp(' ')
namePos'
disp(' ')
%length(N)
%length(M)



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

ep=TrackingEpoch-SleepEpoch;
ep=ep-RestEpoch;


[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,ep,1);


dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

X=Restrict(X,EpochOk);
Y=Restrict(Y,EpochOk);
S=Restrict(S,EpochOk);

figure('color',[1 1 1])
plot(Data(Restrict(X,EpochOk)),Data(Restrict(Y,EpochOk)))
pause(1)
close


[mapini,mapSini,stats,px,py,FR,sizeFinal,PrFieldini,C,ScField,pfH,pf]=PlaceField(spike,Restrict(X,epPF),Restrict(Y,epPF),'threshold',thPF);

Cini=C;

siY=size(mapini.rate,1);
siX=size(mapini.rate,2);


try
    angCH;
    ang=angCH;
catch
    
if C(1)>siX/2&C(2)>siY/2

    ang=atan(abs(C(2)-siY/2)/abs(C(1)-siX/2));
    %ang=-ang*360/2/pi-90;
    ang=-ang-pi/2;
    
elseif C(1)>siX/2&C(2)<=siY/2

    ang=atan(abs(C(2)-siY/2)/abs(C(1)-siX/2));
    %ang=ang*360/2/pi-90;
    ang=ang-pi/2;
    
elseif C(1)<=siX/2&C(2)>siY/2

    ang=atan(abs(C(2)-siY/2)/abs(C(1)-siX/2));
    %ang=ang*360/2/pi+90;
    ang=ang+pi/2;
    
elseif C(1)<=siX/2&C(2)<=siY/2

    ang=atan(abs(C(2)-siY/2)/abs(C(1)-siX/2));    
    %ang=-ang*360/2/pi+90;
    ang=-ang+pi/2;
    
end

end

Xa=Data(X);
Ya=Data(Y);

pts=Rotate([Xa Ya],ang,C);


Xn=tsd(Range(X),pts(:,1)-min(pts(:,1)));
Yn=tsd(Range(Y),pts(:,2)-min(pts(:,2)));

save RotatePosition Xn Yn ang

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(spike,Restrict(Xn,epPF),Restrict(Yn,epPF),'threshold',0.2);

%keyboard

%Epoch1=subset(QuantifExploEpoch,1:20);
Epoch1=TrackingEpoch-SleepEpoch;
Epoch1=Epoch1-RestEpoch;

X1=Data(Restrict(Xn,Epoch1));
Y1=Data(Restrict(Yn,Epoch1));
x=[1:0.05:360];


centre=[(min(X1)+max(X1))/2 (min(Y1)+max(Y1))/2];
rayonXl=(min(X1)+max(X1))/2+5;
rayonYl=(min(Y1)+max(Y1))/2+5;
rayonXs=(min(X1)+max(X1))/5.7;
rayonYs=(min(Y1)+max(Y1))/5.7;


figure('color',[1 1 1])
subplot(2,3,1),
hold on, plot(Data(Restrict(Xn,Epoch1)),Data(Restrict(Yn,Epoch1)),'color',[0.7 0.7 0.7])

hold on, plot(rayonXl*cos(x)+centre(1),rayonYl*sin(x)+centre(2),'r','linewidth',2)
hold on, plot(rayonXs*cos(x)+centre(1),rayonYs*sin(x)+centre(2),'b','linewidth',2)

%hold on, plot((min(X1)+max(X1))/2*cos(x)+(min(X1)+max(X1))/2,(min(Y1)+max(Y1))/2*sin(x)+(min(Y1)+max(Y1))/2,'r')
%hold on, plot((min(X1)+max(X1))/5*cos(x)+(min(X1)+max(X1))/2,(min(Y1)+max(Y1))/5*sin(x)+(min(Y1)+max(Y1))/2,'b')

hold on, plot([0:max(X1)/200:max(X1)],[0:max(Y1)/200:max(Y1)],'g','linewidth',2)
hold on, plot([0:max(X1)/200:max(X1)],[max(Y1):-max(Y1)/200:0],'g','linewidth',2)

try
    hold on, plot(Data(Restrict(Xn,spike)),Data(Restrict(Yn,spike)),'r.')
catch
    if NumNeuron==0
     hold on, plot(Data(Restrict(Xn,Restrict(stim,ep))),Data(Restrict(Yn,Restrict(stim,ep))),'r.')   
    else
    hold on, plot(Data(Restrict(Xn,Restrict(S{NumNeuron},ep))),Data(Restrict(Yn,Restrict(S{NumNeuron},ep))),'r.')
    end
    end
xlim([-10 limMaz(2)+10])
ylim([-10 limMaz(2)+10])

DistanceCentre=tsd(Range(Xn),sqrt((Data(Xn)-centre(1)).^2+(Data(Yn)-centre(2)).^2));
DistanceDiag1=tsd(Range(Xn),Data(Xn)-Data(Yn));

DistanceDiag2=tsd(Range(Xn),Data(Xn)+Data(Yn)-max(Data(Yn)));

zonetotal=thresholdIntervals(DistanceCentre,max(rayonXl,rayonYl),'Direction','Below');
zone1=thresholdIntervals(DistanceCentre,max(rayonXs,rayonYs),'Direction','Below');
zone2=thresholdIntervals(DistanceCentre,max(rayonXs,rayonYs),'Direction','Above');

zoneD1a=thresholdIntervals(DistanceDiag1,0,'Direction','Above');
zoneD1b=thresholdIntervals(DistanceDiag1,0,'Direction','Below');
zoneD2a=thresholdIntervals(DistanceDiag2,0,'Direction','Above');
zoneD2b=thresholdIntervals(DistanceDiag2,0,'Direction','Below');


ZoneCentre=zone1;

ZoneEsttemp1=intersect(zoneD1a,zoneD2a);
ZoneEsttemp2=intersect(ZoneEsttemp1,zonetotal);
ZoneEst=intersect(ZoneEsttemp2,zone2);

ZoneSudtemp1=intersect(zoneD1a,zoneD2b);
ZoneSudtemp2=intersect(ZoneSudtemp1,zonetotal);
ZoneSud=intersect(ZoneSudtemp2,zone2);

ZoneOuesttemp1=intersect(zoneD1b,zoneD2b);
ZoneOuesttemp2=intersect(ZoneOuesttemp1,zonetotal);
ZoneOuest=intersect(ZoneOuesttemp2,zone2);

ZoneNordtemp1=intersect(zoneD1b,zoneD2a);
ZoneNordtemp2=intersect(ZoneNordtemp1,zonetotal);
ZoneNord=intersect(ZoneNordtemp2,zone2);



% figure('color',[1 1 1])
% subplot(2,3,1),
% hold on, plot(Data(Restrict(Xn,Epoch1)),Data(Restrict(Yn,Epoch1)),'color',[0.7 0.7 0.7])
% hold on, plot(Data(Restrict(Xn,ZoneEst)),Data(Restrict(Yn,ZoneEst)),'b.')
% hold on, plot(Data(Restrict(Xn,ZoneOuest)),Data(Restrict(Yn,ZoneOuest)),'k.')
% hold on, plot(Data(Restrict(Xn,ZoneSud)),Data(Restrict(Yn,ZoneSud)),'g.')
% hold on, plot(Data(Restrict(Xn,ZoneNord)),Data(Restrict(Yn,ZoneNord)),'r.')
% hold on, plot(Data(Restrict(Xn,ZoneCentre)),Data(Restrict(Yn,ZoneCentre)),'y.')
% title('Total')

Epoch1=TrackingEpoch;
X1=Restrict(Xn,Epoch1);
Y1=Restrict(Yn,Epoch1);
Q(1,1)=length(Data(Restrict(X1,ZoneNord)))/length(Data(Restrict(X1,zonetotal)))*100;
Q(1,2)=length(Data(Restrict(X1,ZoneCentre)))/length(Data(Restrict(X1,zonetotal)))*100;
Q(1,3)=length(Data(Restrict(X1,ZoneEst)))/length(Data(Restrict(X1,zonetotal)))*100;
Q(1,4)=length(Data(Restrict(X1,ZoneOuest)))/length(Data(Restrict(X1,zonetotal)))*100;
Q(1,5)=length(Data(Restrict(X1,ZoneSud)))/length(Data(Restrict(X1,zonetotal)))*100;


%Epoch2=subset(QuantifExploEpoch,1:8);
X2=Restrict(Xn,Epoch2);
Y2=Restrict(Yn,Epoch2);
Q(2,1)=length(Data(Restrict(X2,ZoneNord)))/length(Data(Restrict(X2,zonetotal)))*100;
Q(2,3)=length(Data(Restrict(X2,ZoneEst)))/length(Data(Restrict(X2,zonetotal)))*100;
Q(2,4)=length(Data(Restrict(X2,ZoneOuest)))/length(Data(Restrict(X2,zonetotal)))*100;
Q(2,5)=length(Data(Restrict(X2,ZoneSud)))/length(Data(Restrict(X2,zonetotal)))*100;
Q(2,2)=length(Data(Restrict(X2,ZoneCentre)))/length(Data(Restrict(X2,zonetotal)))*100;

subplot(2,3,2),
hold on, plot(Data(Restrict(X2,Epoch1)),Data(Restrict(Y2,Epoch1)),'color',[0.7 0.7 0.7])
hold on, plot(Data(Restrict(X2,ZoneEst)),Data(Restrict(Y2,ZoneEst)),'b.')
hold on, plot(Data(Restrict(X2,ZoneOuest)),Data(Restrict(Y2,ZoneOuest)),'k.')
hold on, plot(Data(Restrict(X2,ZoneSud)),Data(Restrict(Y2,ZoneSud)),'g.')
hold on, plot(Data(Restrict(X2,ZoneNord)),Data(Restrict(Y2,ZoneNord)),'r.')
hold on, plot(Data(Restrict(X2,ZoneCentre)),Data(Restrict(Y2,ZoneCentre)),'y.')
title('Pre')
xlim([-10 limMaz(2)+10])
ylim([-10 limMaz(2)+10])

%Epoch3=subset(QuantifExploEpoch,9:16);
X3=Restrict(Xn,Epoch3);
Y3=Restrict(Yn,Epoch3);
Q(3,1)=length(Data(Restrict(X3,ZoneNord)))/length(Data(Restrict(X3,zonetotal)))*100;
Q(3,3)=length(Data(Restrict(X3,ZoneEst)))/length(Data(Restrict(X3,zonetotal)))*100;
Q(3,4)=length(Data(Restrict(X3,ZoneOuest)))/length(Data(Restrict(X3,zonetotal)))*100;
Q(3,5)=length(Data(Restrict(X3,ZoneSud)))/length(Data(Restrict(X3,zonetotal)))*100;
Q(3,2)=length(Data(Restrict(X3,ZoneCentre)))/length(Data(Restrict(X3,zonetotal)))*100;

subplot(2,3,3),
hold on, plot(Data(Restrict(X3,Epoch1)),Data(Restrict(Y3,Epoch1)),'color',[0.7 0.7 0.7])
hold on, plot(Data(Restrict(X3,ZoneEst)),Data(Restrict(Y3,ZoneEst)),'b.')
hold on, plot(Data(Restrict(X3,ZoneOuest)),Data(Restrict(Y3,ZoneOuest)),'k.')
hold on, plot(Data(Restrict(X3,ZoneSud)),Data(Restrict(Y3,ZoneSud)),'g.')
hold on, plot(Data(Restrict(X3,ZoneNord)),Data(Restrict(Y3,ZoneNord)),'r.')
hold on, plot(Data(Restrict(X3,ZoneCentre)),Data(Restrict(Y3,ZoneCentre)),'y.')
title('Post')
xlim([-10 limMaz(2)+10])
ylim([-10 limMaz(2)+10])

subplot(2,3,4:6), bar(Q(2:3,:)')
set(gca,'xtick',[1:5])
set(gca,'xticklabel',{'Nord','Centre','Est','Ouest','Sud'})
ylabel('Percentage of time spet in each area (%)')


Q=Q';


smo2=smo;
%smo2=0.5;


%[OcTpre,OcSTpre,OcRTpre,OcRSTpre]=OccupancyMapKB(Restrict(Xn,Epoch2),Restrict(Yn,Epoch2),'axis',[0 15],'smoothing',smo2,'size',sizeMap,'limitmaze',limMaz);close
%[OcTpost,OcSTpost,OcRTpost,OcRSTpost]=OccupancyMapKB(Restrict(Xn,Epoch3),Restrict(Yn,Epoch3),'axis',[0 15],'smoothing',smo2,'size',sizeMap,'limitmaze',limMaz);close

%[occH2, x1, x2] = hist2d(Data(Restrict(Xn,Epoch2)),Data(Restrict(Yn,Epoch2)), 62, 62);
%[occH3, x1, x2] = hist2d(Data(Restrict(Xn,Epoch3)),Data(Restrict(Yn,Epoch3)), 62, 62);
limX(1)=min(Data(Xn));
limX(2)=max(Data(Xn));
limY(1)=min(Data(Yn));
limY(2)=max(Data(Yn));

[occH2, x1, x2] = hist2d([limX(1) ;Data(Restrict(Xn,Epoch2)) ;limX(2)], [limY(1) ;Data(Restrict(Yn,Epoch2)) ;limY(2)], 62, 62);
[occH3, x1, x2] = hist2d([limX(1) ;Data(Restrict(Xn,Epoch3)) ;limX(2)], [limY(1) ;Data(Restrict(Yn,Epoch3)) ;limY(2)], 62, 62);
occH2(1,1)=0;
occH2(end,end)=0;
occH3(1,1)=0;
occH3(end,end)=0;
    
occHS2=SmoothDec(occH2',[smo2,smo2]);
occHS3=SmoothDec(occH3',[smo2,smo2]);

kk=GravityCenter(PrField);
gg=gray;
invgray=gg(end:-1:1,:);


figure('color',[1 1 1]), 
subplot(1,2,1), 
hold on, imagesc(PrFieldini), axis xy
plot(Cini(1),Cini(2),'ko','markerfacecolor','w')
subplot(1,2,2), 
hold on, imagesc(PrField), axis xy
plot(C(1),C(2),'ko','markerfacecolor','w')


figure('color',[1 1 1]), 

subplot(1,2,1), 
hold on, imagesc(occHS2), axis xy
plot(kk(1),kk(2),'ko','markerfacecolor','r')
xlim([0 62])
ylim([0 62])

ca1=caxis;
subplot(1,2,2), 
hold on, imagesc(occHS3), axis xy
plot(kk(1),kk(2),'ko','markerfacecolor','r')
xlim([0 62])
ylim([0 62])
colormap(invgray)
ca2=caxis;
caxis([0 max(ca1(2), ca2(2))])
subplot(1,2,1), 
caxis([0 max(ca1(2), ca2(2))])
load('MyColormaps','mycmap')
numfigF=gcf;
set(numfigF,'Colormap',mycmap)
