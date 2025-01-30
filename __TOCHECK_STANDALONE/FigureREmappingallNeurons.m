
%FigureREmappingallNeurons

remap=1;
sav=0;

% cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse026/20120109


close all
remap=1;

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse026/20120109'])

load behavResources
load SpikeData S cellnames

PlaceCellTrig=6;
   sav=0;
if sav
    save PlaceCellTrig PlaceCellTrig
end

load PlaceCellTrig

% 
% Epoch=and(intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4),TrackingEpoch);
% length(Restrict(S{PlaceCellTrig},Epoch));
% length(Restrict(stim,Epoch));
% PercDetection=length(Restrict(stim,Epoch))/length(Restrict(S{PlaceCellTrig},Epoch))*100;
% 

if 0

        try
            load xyMax
            xMaz;
            [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
        end

end

if 0
        Vth=0;
        EpochMvt=thresholdIntervals(V,Vth, 'Direction','Above');
        %EpochMvt=intersect(ep,Mvt);  
        X=Restrict(X,EpochMvt);
        Y=Restrict(Y,EpochMvt);
        S=Restrict(S,EpochMvt);
end


Epoch=and(intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4),TrackingEpoch);            
length(Restrict(S{PlaceCellTrig},Epoch));
length(Restrict(stim,Epoch));
PercDetection(1)=length(Restrict(stim,Epoch))/length(Restrict(S{PlaceCellTrig},Epoch))*100

PlaceFieldPoisson(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));
PlaceFieldPoisson(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));


cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
if sav
save PercDetection PercDetection
end


filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse026/20120109'])



if 0
    
        close all
        num=6; [MAP6,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]% Place Cell used as trigger

        num=8; [MAP8,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=12; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=13; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=14; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=15; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=18; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)]

        num=19; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)] % remaping

        num=20; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)] % int

        num=22; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,7), Rfr(1,11), Rfr(7,11)] % No remaping

        Epoch=and(intervalSet(tpsdeb{6}*1E4,tpsfin{6}*1E4),TrackingEpoch);
        PlaceFieldPoisson(Restrict(S{num},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));

end

if remap

        EpochBefore=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
        Epoch1=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
        Epoch2=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
        EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{6},S{8},S{12},S{13},S{14},S{15},S{18},S{19},S{20},S{22}}),X,Y,EpochBefore,EpochAfter,cellnames([6,8,12,13,14,15,18,19,20,22]),'positions','s','immobility','y','speed',15);


        EpochBefore=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
        EpochAfter=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{6},S{8},S{12},S{13},S{14},S{15},S{18},S{19},S{20},S{22}}),X,Y,EpochBefore,EpochAfter,cellnames([6,8,12,13,14,15,18,19,20,22]),'positions','s','immobility','y','speed',15);


        EpochBefore=intervalSet(tpsdeb{1}*1E4,tpsfin{1}/2*1E4);
        EpochAfter=intervalSet(tpsfin{1}/2*1E4,tpsfin{1}*1E4);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{6},S{8},S{12},S{13},S{14},S{15},S{18},S{19},S{20},S{22}}),X,Y,EpochBefore,EpochAfter,cellnames([6,8,12,13,14,15,18,19,20,22]),'positions','s','immobility','y','speed',15);


        EpochBefore=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
        EpochAfter=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{6},S{8},S{12},S{13},S{14},S{15},S{18},S{19},S{20},S{22}}),X,Y,EpochBefore,EpochAfter,cellnames([6,8,12,13,14,15,18,19,20,22]),'positions','s','immobility','y','speed',15);

        try
            load xyMax
            xMaz;
            [X2,Y2,S2,stim2]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
        end
        [Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(Restrict(X2,EpochAfter),Restrict(Y2,EpochAfter),'axis',[0 15],'smoothing',2.5,'size',50,'limitmaze',[0 50]);close
        figure('color',[1 1 1]), imagesc(OcRS1), axis xy
        load('MyColormaps','mycmap')
        numfig2=gcf;
        set(numfig2,'Colormap',mycmap)


end

clear


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

clear
close all
remap=1;
sav=0;

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

cd([filename,'Mouse029/20120209'])

PlaceCellTrig=12;
if sav
save PlaceCellTrig PlaceCellTrig
end

load behavResources
load SpikeData
load PlaceCellTrig


if 0
try
        load xyMax
        xMaz;
        [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
end

end
Vth=5;
EpochMvt=thresholdIntervals(V,Vth, 'Direction','Above');
%EpochMvt=intersect(ep,Mvt);  
X=Restrict(X,EpochMvt);
Y=Restrict(Y,EpochMvt);
S=Restrict(S,EpochMvt);

Epoch=and(intervalSet(tpsdeb{1}*1E4,tpsfin{3}*1E4),TrackingEpoch);            
length(Restrict(S{PlaceCellTrig},Epoch));
length(Restrict(stim,Epoch));

cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
load PercDetection PercDetection
PercDetection(2)=length(Restrict(stim,Epoch))/length(Restrict(S{PlaceCellTrig},Epoch))*100

PlaceFieldPoisson(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));
PlaceFieldPoisson(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));



cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
if sav
save PercDetection -Append PercDetection
end

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse029/20120209'])


% 
% 

% 
% 
% close all
% num=1;
% 
% num=num+1; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
% [Rfr(1,7), Rfr(1,11), Rfr(7,11)]
% 


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

clear
close all
remap=1;
sav=0;

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';


cd([filename,'Mouse035/20120515'])


load behavResources
load SpikeData S cellnames

PlaceCellTrig=23;
if sav
save PlaceCellTrig PlaceCellTrig
end

load PlaceCellTrig

try
        load xyMax
        xMaz;
        [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
end

Vth=20;
EpochMvt=thresholdIntervals(V,Vth, 'Direction','Above');
%EpochMvt=intersect(ep,Mvt);  
X=Restrict(X,EpochMvt);
Y=Restrict(Y,EpochMvt);
S=Restrict(S,EpochMvt);

Epoch=and(intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4),TrackingEpoch);            
length(Restrict(S{PlaceCellTrig},Epoch));
length(Restrict(stim,Epoch));
cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
load PercDetection
PercDetection(3)=length(Restrict(stim,Epoch))/length(Restrict(S{PlaceCellTrig},Epoch))*100

PlaceFieldPoisson(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));
PlaceFieldPoisson(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));



cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
if sav
save PercDetection -Append PercDetection
end
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse035/20120515'])





if 0
    
        close all
        num=2; [MAP6,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(2,3)] % remapping
        [Rfr(3,4), Rfr(3,11), Rfr(3,15)]% Place Cell in croix mais nulle part ailleurs

        num=8; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(2,3)] % no stable place field in env
        [Rfr(3,4), Rfr(3,11), Rfr(3,15)]


        close all
        num=11; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(2,3)] 
        [Rfr(3,4), Rfr(3,11), Rfr(3,15)]% remapping toward place field of the triggering place cell

        n=12 % clear place field in croix but no spikes elsewhere

        close all
        num=23; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(2,3)] %  Place Cell used as trigger
        [Rfr(3,4), Rfr(3,7), Rfr(3,11)]

        close all
        num=25; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(2,3)] % remapping
        [Rfr(3,4), Rfr(3,11), Rfr(3,15)]

end


if remap
    

        Epoch1=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
        Epoch2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
        EpochBefore=or(Epoch1,Epoch2);
        Epoch1=intervalSet(tpsdeb{12}*1E4,tpsfin{12}*1E4);
        Epoch2=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);
        EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{2},S{8},S{11},S{23},S{25}}),X,Y,EpochBefore,EpochAfter,cellnames([2,8,11,23,25]),'positions','s','immobility','y','speed',15);




        %Epoch1=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
        EpochBefore=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
        %EpochBefore=or(Epoch1,Epoch2);
        EpochAfter=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);
        %Epoch2=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);
        %EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{2},S{8},S{11},S{23},S{25}}),X,Y,EpochBefore,EpochAfter,cellnames([2,8,11,23,25]),'positions','s','immobility','y','speed',15);





        Epoch1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
        Epoch2=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
        EpochBefore=or(Epoch1,Epoch2);
        Epoch1=intervalSet(tpsdeb{13}*1E4,tpsfin{13}*1E4);
        Epoch2=intervalSet(tpsdeb{16}*1E4,tpsfin{16}*1E4);
        EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{2},S{8},S{11},S{23},S{25}}),X,Y,EpochBefore,EpochAfter,cellnames([2,8,11,23,25]),'positions','s','immobility','y','speed',15);


        try
            load xyMax
            xMaz;
            [X2,Y2,S2,stim2]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
        end
        [Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(Restrict(X2,EpochAfter),Restrict(Y2,EpochAfter),'axis',[0 15],'smoothing',2.5,'size',50,'limitmaze',[0 50]);close
        figure('color',[1 1 1]), imagesc(OcRS1), axis xy
        load('MyColormaps','mycmap')
        numfig2=gcf;
        set(numfig2,'Colormap',mycmap)
        %caxis([0 0.45])

end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

clear
close all
remap=1;
sav=0;

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

 cd([filename,'Mouse042/20120801'])
 

load behavResources
load SpikeData S cellnames



PlaceCellTrig=12;
if sav
save PlaceCellTrig PlaceCellTrig
end

load PlaceCellTrig

try
        load xyMax
        xMaz;
        [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
end


Vth=5;
EpochMvt=thresholdIntervals(V,Vth, 'Direction','Above');
%EpochMvt=intersect(ep,Mvt);  
X=Restrict(X,EpochMvt);
Y=Restrict(Y,EpochMvt);
S=Restrict(S,EpochMvt);


Epoch=and(intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4),TrackingEpoch);            
length(Restrict(S{PlaceCellTrig},Epoch));
length(Restrict(stim,Epoch));
cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
load PercDetection 
PercDetection(4)=length(Restrict(stim,Epoch))/length(Restrict(S{PlaceCellTrig},Epoch))*100

PlaceFieldPoisson(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));
PlaceFieldPoisson(Restrict(S{PlaceCellTrig},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));



cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
if sav
save PercDetection -Append PercDetection
end
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
 cd([filename,'Mouse042/20120801'])




if 0
        close all
        num=2; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(1,4),Rfr(2,3),Rfr(2,4),Rfr(3,4)] 
        [Rfr(4,11), Rfr(4,11), Rfr(4,15)]

        num=8; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(1,4),Rfr(2,3),Rfr(2,4),Rfr(3,4)] 
        [Rfr(4,11), Rfr(4,12), Rfr(4,15)]

        num=9; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(1,4),Rfr(2,3),Rfr(2,4),Rfr(3,4)] 
        [Rfr(4,11), Rfr(4,12), Rfr(4,15)]


        num=12; [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(num,'immobility','y','speed',15);
        [Rfr(1,2),Rfr(1,3),Rfr(1,4),Rfr(2,3),Rfr(2,4),Rfr(3,4)] 
        [Rfr(4,10), Rfr(4,11), Rfr(4,14)]%  Place Cell used as trigger

end



if remap


        Epoch1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
        Epoch2=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
        EpochBefore=or(Epoch1,Epoch2);
        Epoch1=intervalSet(tpsdeb{11}*1E4,tpsfin{12}*1E4);
        Epoch2=intervalSet(tpsdeb{15}*1E4,tpsfin{15}*1E4);
        EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{2},S{8},S{9},S{12}}),X,Y,EpochBefore,EpochAfter,cellnames([2,8,9,12]),'positions','s','immobility','y','speed',15);



        Epoch1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
        Epoch2=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
        EpochBefore=or(Epoch1,Epoch2);
        Epoch1=intervalSet(tpsdeb{14}*1E4,tpsfin{14}*1E4);
        Epoch2=intervalSet(tpsdeb{17}*1E4,tpsfin{17}*1E4);
        EpochAfter=or(Epoch1,Epoch2);
        [r,p,rc,pc]=StabilityPFEpoch(tsdArray({S{2},S{8},S{9},S{12}}),X,Y,EpochBefore,EpochAfter,cellnames([2,8,9,12]),'positions','s','immobility','y','speed',15);

        try
            load xyMax
            xMaz;
            [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
        end
        [Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(Restrict(X2,EpochAfter),Restrict(Y2,EpochAfter),'axis',[0 15],'smoothing',2.5,'size',50,'limitmaze',[0 50]);close
        figure('color',[1 1 1]), imagesc(OcRS1), axis xy
        load('MyColormaps','mycmap')
        numfig2=gcf;
        set(numfig2,'Colormap',mycmap)
        caxis([0 0.45])

end

close all
clear



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try
        load PercDetection
end

cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data
load PercDetection
mean(PercDetection)
stdError(PercDetection)


