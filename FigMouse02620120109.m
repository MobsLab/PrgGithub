%FigMouse02620120109

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)
mouv=0; the=20; %10
smo=[1,1];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%%
cd([filename,'Mouse026/20120109'])

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

PlaceCellTrig=6;

listPlaceCells=[19];


EpochICSS=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);

map1=PlaceField(Restrict(stim,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
map2=PlaceField(Restrict(burst,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
map3=PlaceField(Restrict(S{PlaceCellTrig},EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);

EpochExploStimDetect=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
map4=PlaceField(Restrict(stim,EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);
map5=PlaceField(Restrict(S{PlaceCellTrig},EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);

Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
Epoch2=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
Epoch3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
% 
% EpochExploration=or(Epoch1,Epoch2);
% EpochExploration=or(EpochExploration,Epoch3);

EpochExploration=or(Epoch2,Epoch3);
map6=PlaceField(Restrict(S{PlaceCellTrig},EpochExploration),Restrict(X,EpochExploration),Restrict(Y,EpochExploration),'limitmaze',[0 160]);

EpochEnd=intervalSet(tpsdeb{10}*1E4,tpsfin{11}*1E4);
map7=PlaceField(Restrict(S{PlaceCellTrig},EpochEnd),Restrict(X,EpochEnd),Restrict(Y,EpochEnd),'limitmaze',[0 160]);


a=1;
for i=1:7
    for j=i+1:7
        try
            eval(['[r,p]=corrcoef(SmoothDec(map',num2str(i),'.rate,smo),SmoothDec(map',num2str(j),'.rate,smo));'])
% eval(['[r,p]=corrcoef(map',num2str(i),'.rate,map',num2str(j),'.rate);'])
R(1,a)=r(2,1);
P(1,a)=p(2,1);
    catch
R(1,a)=nan;
P(1,a)=nan;    
    
        end
        a=a+1;
    end

end



% 
%     'ICSS-Mouse-26-09012011-01-ExploRond-wideband'
%     'ICSS-Mouse-26-09012011-02-QuantifExplo1Rond-wideband'
%     'ICSS-Mouse-26-09012011-03-RestRond-wideband'
%     'ICSS-Mouse-26-09012011-04-SleepICSS5VRond-wideband'
%     'ICSS-Mouse-26-09012011-05-SleepICSS5VRond-wideband'
%     'ICSS-Mouse-26-09012011-06-QuantifExplo2Rond-wideband'
%     'ICSS-Mouse-26-09012011-07-ExploRond-wideband'
%     'ICSS-Mouse-26-09012011-08-QuantifExplo3Rond-wideband'
%     'ICSS-Mouse-26-09012011-09-ICSS5VRExploRond-wideband'
%     'ICSS-Mouse-26-09012011-10-QuantifExplo4Rond-wideband'
%     'ICSS-Mouse-26-09012011-11-ExploRond-wideband'
    
% 
% 
close all

Epoch=intervalSet(200*1E4,tpsfin{2}*1E4);
mapA=PlaceField(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));close
mapB=PlaceField(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));close


EpochPost=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
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



