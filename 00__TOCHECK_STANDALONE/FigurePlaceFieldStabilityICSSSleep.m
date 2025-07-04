% FigurePlaceFieldStabilityICSSSleep

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)
mouv=1; the=15; %10
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


clear r
clear p

nn=1;
MapF{nn}=map1;nn=nn+1;
MapF{nn}=map2;nn=nn+1;
MapF{nn}=map3;nn=nn+1;
MapF{nn}=map4;nn=nn+1;
MapF{nn}=map5;nn=nn+1;
MapF{nn}=map6;nn=nn+1;
MapF{nn}=map7;nn=nn+1;

clear map1
clear map2
clear map3
clear map4
clear map5
clear map6
clear map7






%%


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd([filename,'Mouse029/20120207'])

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
 
listPlaceCells=[7 36 38];

% 
% EpochICSS=intervalSet(tpsdeb{6}*1E4,tpsfin{6}*1E4);
% 
% map1=PlaceField(Restrict(stim,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
% map2=PlaceField(Restrict(burst,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
% map3=PlaceField(Restrict(S{PlaceCellTrig},EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);


% EpochExploStimDetect=intervalSet(tpsdeb{1}*1E4,tpsfin{4}*1E4);
EpochExploStimDetect=intervalSet(2000*1E4,2800*1E4);
map4=PlaceField(Restrict(stim,EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);
EpochExploStimDetect=intervalSet(tpsdeb{1}*1E4,tpsfin{4}*1E4);
map5=PlaceField(Restrict(S{PlaceCellTrig},EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);

Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
Epoch2=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
Epoch3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
EpochExploration=or(Epoch1,Epoch2);
EpochExploration=or(EpochExploration,Epoch3);

EpochExploration=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
map6=PlaceField(Restrict(S{PlaceCellTrig},EpochExploration),Restrict(X,EpochExploration),Restrict(Y,EpochExploration));


EpochEnd=EpochExploration;
map7=PlaceField(Restrict(S{PlaceCellTrig},EpochEnd),Restrict(X,EpochEnd),Restrict(Y,EpochEnd),'limitmaze',[0 160]);


a=1;
for i=1:7
    for j=i+1:7
        try
% eval(['[r,p]=corrcoef(map',num2str(i),'.rate,map',num2str(j),'.rate);'])
            eval(['[r,p]=corrcoef(SmoothDec(map',num2str(i),'.rate,smo),SmoothDec(map',num2str(j),'.rate,smo));'])
R(2,a)=r(2,1);
P(2,a)=p(2,1);
    catch
R(2,a)=nan;
P(2,a)=nan;    
    
        end
        a=a+1;
    end

end


clear r
clear p

MapF{nn}=[]; nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=map4;nn=nn+1;
MapF{nn}=map5;nn=nn+1;
MapF{nn}=map6;nn=nn+1;
MapF{nn}=map7;nn=nn+1;

clear map1
clear map2
clear map3
clear map4
clear map5
clear map6
clear map7



%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%%
cd([filename,'Mouse035/20120515'])

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

PlaceCellTrig=23;

listPlaceCells=[5 25];


EpochICSS=intervalSet(tpsdeb{13}*1E4,tpsfin{13}*1E4);

try
    map1=PlaceField(Restrict(stim,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
end
try    
    map2=PlaceField(Restrict(burst,EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
end
try
map3=PlaceField(Restrict(S{PlaceCellTrig},EpochICSS),Restrict(X,EpochICSS),Restrict(Y,EpochICSS),'limitmaze',[0 160]);
end

EpochExploStimDetect=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
try
    map4=PlaceField(Restrict(stim,EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);
end
try
    map5=PlaceField(Restrict(S{PlaceCellTrig},EpochExploStimDetect),Restrict(X,EpochExploStimDetect),Restrict(Y,EpochExploStimDetect),'limitmaze',[0 160]);
end

Epoch1=intervalSet(tpsdeb{12}*1E4,tpsfin{12}*1E4);
Epoch2=intervalSet(tpsdeb{15}*1E4,tpsfin{15}*1E4);
Epoch3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);

% EpochExploration=or(Epoch1,Epoch2);
% EpochExploration=or(EpochExploration,Epoch3);

EpochExploration=Epoch1;

try
map6=PlaceField(Restrict(S{PlaceCellTrig},EpochExploration),Restrict(X,EpochExploration),Restrict(Y,EpochExploration),'limitmaze',[0 160]);
end

EpochEnd=EpochExploration;
try
    map7=PlaceField(Restrict(S{PlaceCellTrig},EpochEnd),Restrict(X,EpochEnd),Restrict(Y,EpochEnd),'limitmaze',[0 160]);
end

a=1;
for i=1:7
    for j=i+1:7
        try
                        eval(['[r,p]=corrcoef(SmoothDec(map',num2str(i),'.rate,smo),SmoothDec(map',num2str(j),'.rate,smo));'])
% eval(['[r,p]=corrcoef(map',num2str(i),'.rate,map',num2str(j),'.rate);'])
R(3,a)=r(2,1);
P(3,a)=p(2,1);
    catch
R(3,a)=nan;
P(3,a)=nan;    
    
        end
        a=a+1;
    end

end


clear r
clear p

try
    MapF{nn}=map1; nn=nn+1;
catch
    MapF{nn}=[]; nn=nn+1;    
end

try
MapF{nn}=map2;nn=nn+1;
MapF{nn}=map3;nn=nn+1;
MapF{nn}=map4;nn=nn+1;
MapF{nn}=map5;nn=nn+1;
MapF{nn}=map6;nn=nn+1;
MapF{nn}=map7;nn=nn+1;
catch
 MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;
MapF{nn}=[];nn=nn+1;   
    
    
end



clear map1
clear map2
clear map3
clear map4
clear map5
clear map6
clear map7



%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%%
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


clear r
clear p

MapF{nn}=map1; nn=nn+1;
MapF{nn}=map2;nn=nn+1;
MapF{nn}=map3;nn=nn+1;
MapF{nn}=map4;nn=nn+1;
MapF{nn}=map5;nn=nn+1;
MapF{nn}=map6;nn=nn+1;
try
MapF{nn}=map7;nn=nn+1;
catch
    MapF{nn}=[];nn=nn+1;
end
clear map1
clear map2
clear map3
clear map4
clear map5
clear map6
clear map7





%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

close all



for id=1:7:22

    figure('color',[1 1 1])    
    try subplot(2,7,1), imagesc(MapF{id}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,2), imagesc(MapF{id+1}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,3), imagesc(MapF{id+2}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,4), imagesc(MapF{id+3}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,5), imagesc(MapF{id+4}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,6), imagesc(MapF{id+5}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,7), imagesc(MapF{id+6}.rate), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,8), imagesc(MapF{id}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,9), imagesc(MapF{id+1}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,10), imagesc(MapF{id+2}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,11), imagesc(MapF{id+3}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,12), imagesc(MapF{id+4}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,13), imagesc(MapF{id+5}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    try subplot(2,7,14), imagesc(MapF{id+6}.time), axis xy, ca=caxis; title(num2str(ca(2))), end
    set(gcf,'position',[31 434 1635 457])
end


R2=R;
R2(R2>0.99)=nan;
figure('color',[1 1 1]), PlotErrorBar(R2)

figure('color',[1 1 1]), PlotErrorBar(R2(:,[5 6 10 11 14 15 21]))


  