
% AnalysisQuantifExploJan2012(o,N,M,varargin)
%
%
% o: epoch inter Quantif Explo: donner numéro TrackingEpoch
% N: epoch Pre
% M: epoch Post


%% INITIATION

immobb=1; % remove immobile state
thPF=0.5;
smo=3;
sizeMap=50;
tpsTh=0.75*1E4;
Limdist=11; %11
Vth=20;
NumNeuron=0; % 0 si pas de place field, 6 pr M17-20110622
NumExplo=1; % Explo pour calculer le place field
limTemp=60;% Time length per session (s)
sav=0;
LargeAreaTh=6; %default value 6
thfalseTrial=30;
limitNbTrial=0;

pwd


load behavResources
if NumNeuron~=0
    load SpikeData S cellnames
end


listQuantif=find(diff(Start(QuantifExploEpoch,'s'))>200);

NbTrials=length(N);
N=RemoveFalseTrialQuantifExplo(N,thfalseTrial,X,Y,QuantifExploEpoch);
M=RemoveFalseTrialQuantifExplo(M,thfalseTrial,X,Y,QuantifExploEpoch);
if limitNbTrial>1
    M=M(1:limitNbTrial);
end

%% Tracking

limMaz=[0 400];
[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,TrackingEpoch,posArt);
if 1
    dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
    EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');
    X=Restrict(X,EpochOk);
    Y=Restrict(Y,EpochOk);
    S=Restrict(S,EpochOk);
end



legend{1}='Pre';
legend{2}='Post';
legend{3}='Pre';
legend{4}='Post';

Mvt=thresholdIntervals(V,Vth,'Direction','Above');

if immobb
    try
        [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,RestEpoch);
    catch
        [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,SleepEpoch);    
    end
end

Epoch1=subset(QuantifExploEpoch,N);
Epoch2=subset(QuantifExploEpoch,M);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);

%%
EpochS=TrackingEpoch;
EpochS=subset(EpochS,o);
XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);





