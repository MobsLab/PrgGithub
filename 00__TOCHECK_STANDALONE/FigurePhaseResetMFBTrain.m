%FigurePhaseResetMFBTrain

vth=5;

%--------------------------------------------------------------------
%--------------------------------------------------------------------
% place cell
%--------------------------------------------------------------------
%--------------------------------------------------------------------

clear

vth=5;
try
    cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011
catch
   cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse026/20111128
end
load behavResources
load StimMFB

%CorrectedMakeData

namePos'

session=9;
Nlfp=3;

Epoch=intervalSet(tpsdeb{session}*1E4,tpsfin{session}*1E4);
Mvt=thresholdIntervals(V,vth,'Direction','Above');
Epoch=intersect(Epoch,Mvt);

stimu=Restrict(burst,Epoch);

[muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
length(stimu)

%--------------------------------------------------------------------

% clear
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209
% load behavResources
% load StimMFB
% namePos'
% 
% 
% session=4;
% Nlfp=6;
% 
% Epoch=intervalSet(tpsdeb{session}*1E4,tpsfin{session}*1E4);
% Mvt=thresholdIntervals(V,vth,'Direction','Above');
% Epoch=intersect(Epoch,Mvt);
% 
% stimu=Restrict(burst,Epoch);
% 
% [muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
% length(stimu)


%--------------------------------------------------------------------

clear

vth=5;
try
    cd /media/DISK_1/Data1/creationData/Mouse017/ICSS-Mouse-17-22062011
catch
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110622
end
    
load behavResources
load StimMFB
namePos'


session1=12;
session2=13;
Nlfp=4;

Epoch=intervalSet(tpsdeb{session1}*1E4,tpsfin{session2}*1E4);
Mvt=thresholdIntervals(V,vth,'Direction','Above');
Epoch=intersect(Epoch,Mvt);

stimu=Restrict(burst,Epoch);

[muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
length(stimu)


%--------------------------------------------------------------------
%--------------------------------------------------------------------
% Manual
%--------------------------------------------------------------------
%--------------------------------------------------------------------


clear

vth=5;
try
cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110614/ICSS-Mouse-17-14062011
catch
cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110614
end
load behavResources
load StimMFB
namePos'


session1=5;
session2=9;
Nlfp=3;

Epoch2=intervalSet(tpsdeb{session1}*1E4,tpsfin{session1}*1E4);
Epoch1=intervalSet(tpsdeb{session2}*1E4,tpsfin{session2}*1E4);
Epoch=or(Epoch1,Epoch2);

Mvt=thresholdIntervals(V,vth,'Direction','Above');
Epoch=intersect(Epoch,Mvt);

stimu=Restrict(burst,Epoch);

[muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
length(stimu)

%--------------------------------------------------------------------

% 
% clear
% cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011
% load behavResources
% load StimMFB
% namePos'
% 
% 
% session1=4;
% session2=8;
% Nlfp=3;
% 
% Epoch2=intervalSet(tpsdeb{session1}*1E4,tpsfin{session1}*1E4);
% Epoch1=intervalSet(tpsdeb{session2}*1E4,tpsfin{session2}*1E4);
% Epoch=or(Epoch1,Epoch2);
% 
% Mvt=thresholdIntervals(V,vth,'Direction','Above');
% Epoch=intersect(Epoch,Mvt);
% 
% stimu=Restrict(burst,Epoch);
% 
% [muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
% length(stimu)
% 

%--------------------------------------------------------------------

clear

vth=5;
try
    
cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011


catch
 cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse013/20110420
 
end

load behavResources
load StimMFB
namePos'



session=9;
Nlfp=1;

Epoch=intervalSet(tpsdeb{session}*1E4,tpsfin{session}*1E4);
Mvt=thresholdIntervals(V,vth,'Direction','Above');
Epoch=intersect(Epoch,Mvt);

stimu=Restrict(burst,Epoch);

[muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
length(stimu)



%--------------------------------------------------------------------

clear

vth=5;

 cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse035/20120515
 
load behavResources
load StimMFB
namePos'



session=16;
Nlfp=6;

Epoch=intervalSet(tpsdeb{session}*1E4,tpsfin{session}*1E4);
Mvt=thresholdIntervals(V,vth,'Direction','Above');
Epoch=intersect(Epoch,Mvt);

stimu=Restrict(burst,Epoch);

[muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
length(stimu)



%--------------------------------------------------------------------
% 
% clear
% 
%  cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse042/20120801
%  
% load behavResources
% load StimMFB
% namePos'
% 
% 
% 
% session=14;
% Nlfp=6;
% 
% Epoch=intervalSet(tpsdeb{session}*1E4,tpsfin{session}*1E4);
% Mvt=thresholdIntervals(V,vth,'Direction','Above');
% Epoch=intersect(Epoch,Mvt);
% 
% stimu=Restrict(burst,Epoch);
% 
% [muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(Nlfp,stimu);
% length(stimu)



