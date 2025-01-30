%FigMouse02920120207'

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)
mouv=1; the=25; %10
smo=[1,1];



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
