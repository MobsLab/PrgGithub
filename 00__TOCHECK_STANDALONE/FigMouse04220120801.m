%FigMouse04220120801

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)
mouv=1; the=20; %10
smo=[1,1];


cd([filename,'Mouse042/20120801'])
  
 %--------------------------------------------------------------------------

load behavResources
load SpikeData
load StimMFB

%--------------------------------------------------------------------------

            load xyMax xMaz yMaz

            Xx=Data(X);
            Yy=Data(Y);
            rg=Range(X);
            goodInterval1=thresholdIntervals(X,min(xMaz),'Direction','Above');
            goodInterval2=thresholdIntervals(X,max(xMaz),'Direction','Below');
            goodInterval3=thresholdIntervals(Y,min(yMaz),'Direction','Above');
            goodInterval4=thresholdIntervals(Y,max(yMaz),'Direction','Below');

            goodIntervalA=intersect(goodInterval1,goodInterval2);
            goodIntervalB=intersect(goodInterval3,goodInterval4);

            goodInterval=intersect(goodIntervalA,goodIntervalB);

            X=Restrict(X,goodInterval);
            Y=Restrict(Y,goodInterval);
            S=Restrict(S,goodInterval);
            stim=Restrict(stim,goodInterval);

            Xx=Data(X);
            Yy=Data(Y);
            X=tsd(Range(X),Xx-min(xMaz));
            Y=tsd(Range(Y),Yy-min(yMaz));
            limMaz=[0 max(max(xMaz)-min(xMaz),max(yMaz)-min(yMaz))];

            dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
            EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

            X=Restrict(X,EpochOk);
            Y=Restrict(Y,EpochOk);
            S=Restrict(S,EpochOk);

if mouv
Mvt=thresholdIntervals(V, the,'Direction','Above');
S=Restrict(S,Mvt);
X=Restrict(X,Mvt);
Y=Restrict(Y,Mvt);
end

%--------------------------------------------------------------------------

PlaceCellTrig=12;


EpochICSS=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);

map1=PlaceField(Restrict(stim,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
map2=PlaceField(Restrict(burst,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
map3=PlaceField(Restrict(S{PlaceCellTrig},EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);


EpochExploStimDetect=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
map4=PlaceField(Restrict(stim,EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);
map5=PlaceField(Restrict(S{PlaceCellTrig},EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);

Epoch1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
Epoch2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
Epoch3=intervalSet(tpsdeb{12}*1E4,tpsfin{12}*1E4);
Epoch4=intervalSet(tpsdeb{16}*1E4,tpsfin{16}*1E4);

EpochExploration=or(Epoch1,Epoch2);
EpochExploration=or(EpochExploration,Epoch3);
EpochExploration=or(EpochExploration,Epoch4);

map6=PlaceField(Restrict(S{PlaceCellTrig},EpochExploration),Restrict(X,EpochExploration),Restrict(Y,EpochExploration),'limitmaze',[0 160]);


EpochEnd=intervalSet(tpsdeb{16}*1E4,tpsfin{16}*1E4);
try
    map7=PlaceField(Restrict(S{PlaceCellTrig},EpochEnd),Restrict(X,EpochEnd),Restrict(Y,EpochEnd),'limitmaze',[0 160]);
end

a=1;
for i=1:7
    for j=i+1:7
        try
                        eval(['[r,p]=corrcoef(SmoothDec(map',num2str(i),'.rate,smo),SmoothDec(map',num2str(j),'.rate,smo));'])
% eval(['[r,p]=corrcoef(map',num2str(i),'.rate,map',num2str(j),'.rate);'])
R(4,a)=r(2,1);
P(4,a)=p(2,1);
    catch
R(4,a)=nan;
P(4,a)=nan;    
    
        end
        a=a+1;
    end

end


%close all
% 
%     'ICSS-Mouse-42-01082012-01-Explo1Croix-wideband'
%     'ICSS-Mouse-42-01082012-02-Explo1Rond-wideband'
%     'ICSS-Mouse-42-01082012-03-Explo1Arena-wideband'
%     'ICSS-Mouse-42-01082012-04-Explo2Rond-wideband'
%     'ICSS-Mouse-42-01082012-05-QuantifExplo1Rond-wideband'
%     'ICSS-Mouse-42-01082012-06-ICSS7VSleep1-wideband'
%     'ICSS-Mouse-42-01082012-07-ICSS7VSleep2-wideband'
%     'ICSS-Mouse-42-01082012-08-ICSS7VSleep3-wideband'
%     'ICSS-Mouse-42-01082012-09-ICSS7VSleep4-wideband'
%     'ICSS-Mouse-42-01082012-10-ICSS7VSleep5-wideband'
%     'ICSS-Mouse-42-01082012-11-QuantifExplo2Rond-wideband'
%     'ICSS-Mouse-42-01082012-12-Explo3Rond-wideband'
%     'ICSS-Mouse-42-01082012-13-QuantifExplo3Rond-wideband'
%     'ICSS-Mouse-42-01082012-14-ICSS7VAwakeExploRond-wideband'
%     'ICSS-Mouse-42-01082012-15-QuantifExplo4Rond-wideband'
%     'ICSS-Mouse-42-01082012-16-Explo4Rond-wideband'
%     'ICSS-Mouse-42-01082012-17-RandomICSS7VExploRond-wideband'
    
close all

Epoch=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
mapA=PlaceField(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));close
mapB=PlaceField(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));close


EpochPost=intervalSet(tpsdeb{12}*1E4,tpsfin{17}*1E4);
mapC=PlaceField(Restrict(S{PlaceCellTrig},EpochPost),Restrict(X,EpochPost),Restrict(Y,EpochPost));close

figure('color',[1 1 1]), imagesc(mapA.rate), axis xy,colorbar, title('Firing Map Pre')
figure('color',[1 1 1]), imagesc(mapB.rate), axis xy,colorbar, title('Firing Map (stim) Pre')
figure('color',[1 1 1]), imagesc(SmoothDec(mapB.rate,[4 4])), axis xy,colorbar, title('Firing Map (stim) Pre')
figure('color',[1 1 1]), imagesc(mapA.time), axis xy,colorbar, title('Occupancy Pre')
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)
figure('color',[1 1 1]), imagesc(mapA.time), axis xy,colorbar, title('Occupancy Pre'), caxis([0 0.8])
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)

figure('color',[1 1 1]), imagesc(mapC.rate), axis xy,colorbar, title('Firing Map Post')
figure('color',[1 1 1]), imagesc(mapC.time), axis xy,colorbar, title('Occupancy Post')
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)
figure('color',[1 1 1]), imagesc(mapC.time), axis xy,colorbar, title('Occupancy Post'), caxis([0 0.8])
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)


map1=PlaceField(Restrict(stim,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);close

map3=PlaceField(Restrict(S{PlaceCellTrig},EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);close

figure('color',[1 1 1]), imagesc(map1.rate), axis xy,colorbar, title('Firing Map (stim) ICSS')
figure('color',[1 1 1]), imagesc(map3.rate), axis xy,colorbar, title('Firing Map ICSS')
figure('color',[1 1 1]), imagesc(map3.time), axis xy,colorbar, title('Occupancy ICSS')
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)
figure('color',[1 1 1]), imagesc(map3.time), axis xy,colorbar, title('Occupancy ICSS'), caxis([0 0.8])
load('MyColormaps','mycmap')
numfig=gcf;
set(numfig,'Colormap',mycmap)





