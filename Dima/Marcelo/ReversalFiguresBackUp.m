% Get Data M863
clear all
use_block_session = 0; %0 don't use, 1 use

% Pre-tests
clear TrajPre TrajPreCat TrajPosPAG TrajPosPAGCat TrajPosMFB TrajPosMFBCat

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_00/behavResources.mat')
OccupPre(:,1) = Occup;
TrajPre(1:size(PosMat,1),:,1) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(1) = aux(1);
end
TimePre(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=aux(ZoneIndices{1});
SpeedSafePre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPre(1)=0;
else
NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=PosMat(:,[2,3]);
SpeedPreCat= Data(Vtsd);
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_01/behavResources.mat')
OccupPre(:,2) = Occup;
TrajPre(1:size(PosMat,1),:,2) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(2) = aux(1);
end
TimePre(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(2)=0;
else
NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);


load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_02/behavResources.mat')
OccupPre(:,3) = Occup;
TrajPre(1:size(PosMat,1),:,3) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(3) = aux(1);
end
TimePre(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));


if isempty(ZoneIndices{1})
    NumEntPre(3)=0;
else
NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_03/behavResources.mat')
OccupPre(:,4) = Occup;
TrajPre(1:size(PosMat,1),:,4) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(4) = aux(1);
end
TimePre(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(4)=0;
else
NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);


TrajPre(TrajPre == 0) = NaN;


% Post-PAG
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_00/behavResources.mat')
OccupPosPAG(:,1)=Occup;
TrajPosPAG(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(1) = aux(1);
end
TimePosPAG(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=aux(ZoneIndices{1});
SpeedSafePosPAG=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosPAG(1) = 0;
else
NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=PosMat(:,[2,3]);
SpeedPosPAGCat= Data(Vtsd);
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_01/behavResources.mat')
OccupPosPAG(:,2)=Occup;
TrajPosPAG(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(2) = aux(1);
end
TimePosPAG(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(2) = 0;
else
NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_02/behavResources.mat')
OccupPosPAG(:,3)=Occup;
TrajPosPAG(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(3) = aux(1);
end
TimePosPAG(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(3) = 0;
else
NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_03/behavResources.mat')
OccupPosPAG(:,4)=Occup;
TrajPosPAG(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(4) = aux(1);
end
TimePosPAG(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(4) = 0;
else
NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAG(TrajPosPAG == 0)=NaN;

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

% Post MFB
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_04/behavResources.mat')
OccupPosMFB(:,1)=Occup;
TrajPosMFB(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(1) = aux(1);
end
TimePosMFB(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=aux(ZoneIndices{1});
SpeedSafePosMFB=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosMFB(1)=0;
else
NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=PosMat(:,[2,3]);
SpeedPosMFBCat= Data(Vtsd);
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_05/behavResources.mat')
OccupPosMFB(:,2)=Occup;
TrajPosMFB(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(2) = aux(1);
end
TimePosMFB(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(2)=0;
else
NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_06/behavResources.mat')
OccupPosMFB(:,3)=Occup;
TrajPosMFB(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(3) = aux(1);
end
TimePosMFB(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(3)=0;
else
NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_07/behavResources.mat')
OccupPosMFB(:,4)=Occup;
TrajPosMFB(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(4) = aux(1);
end
TimePosMFB(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(4)=0;
else
NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFB(TrajPosMFB == 0)=NaN;

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,1)=Occup;
TrajPAG(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,1)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,2)=Occup;
TrajPAG(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,2)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,3)=Occup;
TrajPAG(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,3)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,4)=Occup;
TrajPAG(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,4)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,5)=Occup;
TrajPAG(1:size(PosMat,1),:,5)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,5)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,6)=Occup;
TrajPAG(1:size(PosMat,1),:,6)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,6)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,7)=Occup;
TrajPAG(1:size(PosMat,1),:,7)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,7)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,8)=Occup;
TrajPAG(1:size(PosMat,1),:,8)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,8)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_06/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,9)=Occup;
TrajPAG(1:size(PosMat,1),:,9)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,9)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,10)=Occup;
TrajPAG(1:size(PosMat,1),:,10)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,10)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_07/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,11)=Occup;
TrajPAG(1:size(PosMat,1),:,11)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,11)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_08/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

OccupPAG(:,12)=Occup;
TrajPAG(1:size(PosMat,1),:,12)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,12)=PosMat(find(PosMat(:,4) == 1),[2,3]);

TrajPAG(TrajPAG == 0) = NaN;
ShockPlacePAG(ShockPlacePAG == 0) = NaN;


% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_09/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,1)=Occup;
TrajMFB(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,1)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,2)=Occup;
TrajMFB(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,2)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_10/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,3)=Occup;
TrajMFB(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,3)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_11/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,4)=Occup;
TrajMFB(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,4)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_12/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,5)=Occup;
TrajMFB(1:size(PosMat,1),:,5)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,5)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,6)=Occup;
TrajMFB(1:size(PosMat,1),:,6)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,6)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_13/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,7)=Occup;
TrajMFB(1:size(PosMat,1),:,7)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,7)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_14/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,8)=Occup;
TrajMFB(1:size(PosMat,1),:,8)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,8)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_15/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,9)=Occup;
TrajMFB(1:size(PosMat,1),:,9)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,9)=PosMat(find(PosMat(:,4) == 1),[2,3]);

if use_block_session == 1
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,10)=Occup;
TrajMFB(1:size(PosMat,1),:,10)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,10)=PosMat(find(PosMat(:,4) == 1),[2,3]);
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_16/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,11)=Occup;
TrajMFB(1:size(PosMat,1),:,11)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,11)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_17/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

OccupMFB(:,12)=Occup;
TrajMFB(1:size(PosMat,1),:,12)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,12)=PosMat(find(PosMat(:,4) == 1),[2,3]);

TrajMFB(TrajMFB == 0) = NaN;
ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

%Explorations
load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Hab_00/behavResources.mat')
OccupExploPre=Occup;
TrajExploPre=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPre = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockExploPre = aux(1);
end
TimeExploPre(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPre=aux(ZoneIndices{1});
SpeedSafeExploPre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPre=0;
else
NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
end

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Hab_03/behavResources.mat')
OccupExploPos=Occup;
TrajExploPos=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPos = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockExploPos = aux(1);
end
TimeExploPos(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPos=aux(ZoneIndices{1});
SpeedSafeExploPos=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPos=0;
else
NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
end
%% Get Data M913
clear all
use_block_session = 0; %0 don't use, 1 use

% Pre-tests
load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_00/behavResources.mat')
OccupPre(:,1) = Occup;
TrajPre(1:size(PosMat,1),:,1) = PosMat(:,[2,3]);

aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(1) = aux(1);
end
TimePre(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=aux(ZoneIndices{1});
SpeedSafePre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPre(1)=0;
else
NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=PosMat(:,[2,3]);
SpeedPreCat= Data(Vtsd);
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_01/behavResources.mat')
OccupPre(:,2) = Occup;
TrajPre(1:size(PosMat,1),:,2) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(2) = aux(1);
end
TimePre(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(2)=0;
else
NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_02/behavResources.mat')
OccupPre(:,3) = Occup;
TrajPre(1:size(PosMat,1),:,3) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(3) = aux(1);
end
TimePre(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(3)=0;
else
NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_03/behavResources.mat')
OccupPre(:,4) = Occup;
TrajPre(1:size(PosMat,1),:,4) = PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPre(4) = aux(1);
end
TimePre(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(4)=0;
else
NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,PosMat(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

TrajPre(TrajPre == 0) = NaN;


% Post-PAG
load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_00/behavResources.mat')
OccupPosPAG(:,1)=Occup;
TrajPosPAG(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(1) = aux(1);
end
TimePosPAG(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=aux(ZoneIndices{1});
SpeedSafePosPAG=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosPAG(1) = 0;
else
NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=PosMat(:,[2,3]);
SpeedPosPAGCat= Data(Vtsd);
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_01/behavResources.mat')
OccupPosPAG(:,2)=Occup;
TrajPosPAG(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(2) = aux(1);
end
TimePosPAG(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(2) = 0;
else
NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_02/behavResources.mat')
OccupPosPAG(:,3)=Occup;
TrajPosPAG(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(3) = aux(1);
end
TimePosPAG(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(3) = 0;
else
NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_03/behavResources.mat')
OccupPosPAG(:,4)=Occup;
TrajPosPAG(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosPAG(4) = aux(1);
end
TimePosPAG(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(4) = 0;
else
NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,PosMat(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


TrajPosPAG(TrajPosPAG == 0)=NaN;


% Post MFB
load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_04/behavResources.mat')
OccupPosMFB(:,1)=Occup;
TrajPosMFB(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(1) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(1) = aux(1);
end
TimePosMFB(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=aux(ZoneIndices{1});
SpeedSafePosMFB=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosMFB(1)=0;
else
NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=PosMat(:,[2,3]);
SpeedPosMFBCat= Data(Vtsd);
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_05/behavResources.mat')
OccupPosMFB(:,2)=Occup;
TrajPosMFB(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(2) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(2) = aux(1);
end
TimePosMFB(1:size(PosMat,1),2) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(2)=0;
else
NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_06/behavResources.mat')
OccupPosMFB(:,3)=Occup;
TrajPosMFB(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(3) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(3) = aux(1);
end
TimePosMFB(1:size(PosMat,1),3) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(3)=0;
else
NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_07/behavResources.mat')
OccupPosMFB(:,4)=Occup;
TrajPosMFB(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(4) = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockPosMFB(4) = aux(1);
end
TimePosMFB(1:size(PosMat,1),4) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(4)=0;
else
NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,PosMat(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


TrajPosMFB(TrajPosMFB == 0)=NaN;

% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,1)=Occup;
TrajPAG(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,1)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockPAG(1)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,2)=Occup;
TrajPAG(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,2)=PosMat(PosMat(:,4) == 1,[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafePAG(1)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,3)=Occup;
TrajPAG(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4)== 1)),:,3)=PosMat(find(PosMat(:,4) == 1),[2,3]);



load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,4)=Occup;
TrajPAG(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,4)=PosMat(find(PosMat(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockPAG(2)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
OccupPAG(:,5)=Occup;
TrajPAG(1:size(PosMat,1),:,5)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,5)=PosMat(find(PosMat(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafePAG(2)=aux(1);

if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,6)=Occup;
TrajPAG(1:size(PosMat,1),:,6)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,6)=PosMat(find(PosMat(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,7)=Occup;
TrajPAG(1:size(PosMat,1),:,7)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,7)=PosMat(find(PosMat(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockPAG(3)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,8)=Occup;
TrajPAG(1:size(PosMat,1),:,8)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,8)=PosMat(find(PosMat(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafePAG(3)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,9)=Occup;
TrajPAG(1:size(PosMat,1),:,9)=PosMat(:,[2,3]);
ShockPlacePAG(1:length(find(PosMat(:,4) == 1)),:,9)=PosMat(find(PosMat(:,4) == 1),[2,3]);

TrajPAG(TrajPAG == 0) = NaN;
ShockPlacePAG(ShockPlacePAG == 0) = NaN;

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,1)=Occup;
TrajMFB(1:size(PosMat,1),:,1)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,1)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockMFB(1)=aux(1);

if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
%

OccupMFB(:,2)=Occup;
TrajMFB(1:size(PosMat,1),:,2)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,2)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafeMFB(1)=aux(1);

if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,3)=Occup;
TrajMFB(1:size(PosMat,1),:,3)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,3)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,4)=Occup;
TrajMFB(1:size(PosMat,1),:,4)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,4)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockMFB(2)=aux(1);

if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,5)=Occup;
TrajMFB(1:size(PosMat,1),:,5)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,5)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafeMFB(2)=aux(1);

if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,6)=Occup;
TrajMFB(1:size(PosMat,1),:,6)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,6)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_06/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,7)=Occup;
TrajMFB(1:size(PosMat,1),:,7)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,7)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallShockMFB(3)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,8)=Occup;
TrajMFB(1:size(PosMat,1),:,8)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,8)=PosMat(find(PosMat(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=PosMat(ZoneIndices{4},1);
aux=aux(PosMat(ZoneIndices{4},1)>180);
EscapeWallSafeMFB(3)=aux(1);


if use_block_session == 0
    cutOut=find(PosMat(:,1) < 180);
    PosMat(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,9)=Occup;
TrajMFB(1:size(PosMat,1),:,9)=PosMat(:,[2,3]);
ShockPlaceMFB(1:length(find(PosMat(:,4) == 1)),:,9)=PosMat(find(PosMat(:,4) == 1),[2,3]);

TrajMFB(TrajMFB == 0) = NaN;
ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

EscapeWallShockPAG=EscapeWallShockPAG-180;
EscapeWallShockMFB=EscapeWallShockMFB-180;
EscapeWallSafeMFB=EscapeWallSafeMFB-180;
EscapeWallSafePAG=EscapeWallSafePAG-180;

%Explorations
load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Hab_00/behavResources.mat')
OccupExploPre=Occup;
TrajExploPre=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPre = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockExploPre = aux(1);
end
TimeExploPre(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPre=aux(ZoneIndices{1});
SpeedSafeExploPre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPre=0;
else
NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
end

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Hab_03/behavResources.mat')
OccupExploPos=Occup;
TrajExploPos=PosMat(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPos = find(PosMat == PosMat(end,1));
else
IndFirstTimeShockExploPos = aux(1);
end
TimeExploPos(1:size(PosMat,1),1) = PosMat(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPos=aux(ZoneIndices{1});
SpeedSafeExploPos=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPos=0;
else
NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
end


%% Plots Shock zone occupancy during reversal experiments

OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBStd=std(OccupPosMFB,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};


figure
bar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],100*[OccupPreStd(1) OccupPosPAGStd(1) OccupPosMFBStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(size(OccupPre,2)),100*OccupPre(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(size(OccupPosPAG,2)),100*OccupPosPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(3*ones(size(OccupPosMFB,2)),100*OccupPosMFB(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Shock zone occupancy during reversal experiment');

%% First time to enter shock zone plot 
for i=1:4
    FirstTimeShockPre(i)=TimePre(IndFirstTimeShockPre(i),i);
    FirstTimeShockPosPAG(i)=TimePosPAG(IndFirstTimeShockPosPAG(i),i);
    FirstTimeShockPosMFB(i)=TimePosMFB(IndFirstTimeShockPosMFB(i),i);
end

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreStd=std(FirstTimeShockPre);
FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGStd=std(FirstTimeShockPosPAG);
FirstTimeShockPosMFBMean=mean(FirstTimeShockPosMFB);
FirstTimeShockPosMFBStd=std(FirstTimeShockPosMFB);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};


figure
bar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],[FirstTimeShockPreStd FirstTimeShockPosPAGStd FirstTimeShockPosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(FirstTimeShockPre)),FirstTimeShockPre,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(FirstTimeShockPosPAG)),FirstTimeShockPosPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(3*ones(length(FirstTimeShockPosMFB)),FirstTimeShockPosMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in reversal experiment');



%% Compare Trajectories

mouse_863 = 0; % 1 is mouse 863

OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBStd=std(OccupPosMFB,0,2);

if mouse_863 == 1 && use_block_session == 0
    OccupPAG(:,[2,6,10]) = [];
    OccupMFB(:,[2,6,10]) = [];
end

OccupPAGMean=mean(OccupPAG,2);
OccupPAGStd=std(OccupPAG,0,2);

OccupMFBMean=mean(OccupMFB,2);
OccupMFBStd=std(OccupMFB,0,2);

OccupLabels={'Pre-test';'PAG';'Post PAG';'Post MFB'};


figure

set(gcf,'DefaultLineLineWidth',1)
set(gca,'FontWeight','bold')

subplot(2,5,1)
hold on
for i=1:4
    plot(TrajPre(:,1,i),TrajPre(:,2,i));
end

%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Pre Test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,45]);

hold off

subplot(2,5,2)
hold on
for i=1:9
    plot(TrajPAG(:,1,i),TrajPAG(:,2,i));
    scatter(ShockPlacePAG(:,1,i),ShockPlacePAG(:,2,i),110,'r','filled','p');

end

%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PAG conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,45]);
hold off


subplot(2,5,3)
hold on
for i=1:4
    plot(TrajPosPAG(:,1,i),TrajPosPAG(:,2,i));
end
% lgd=legend('Trial 1','Trial 2','Trial 3','Trial 4');
% aux=lgd.Location;
% lgd.Location='southoutside';
% aux=lgd.Orientation;
% lgd.Orientation = 'horizontal';

title('Post PAG Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,45]);

hold off

subplot(2,5,4)
hold on
for i=1:9
    plot(TrajMFB(:,1,i),TrajMFB(:,2,i));
    scatter(ShockPlaceMFB(:,1,i),ShockPlaceMFB(:,2,i),110,'g','filled','p');

end

%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('MFB conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,45]);
hold off

subplot(2,5,5)
hold on
for i=1:4
    plot(TrajPosMFB(:,1,i),TrajPosMFB(:,2,i));
end
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Post MFB Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,45]);
hold off

OccupLabels_2={'Shock';'Safe'};

subplot(2,5,6)

bar([1 2],100*[OccupPreMean(1) OccupPreMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPreMean(1) OccupPreMean(2)],100*[OccupPreStd(1) OccupPreStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Pre Tests');
ylim([0 100]);
plot(ones(size(OccupPre,2)),100*OccupPre(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPre,2)),100*OccupPre(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);

subplot(2,5,7)

bar([1 2],100*[OccupPAGMean(1) OccupPAGMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPAGMean(1) OccupPAGMean(2)],100*[OccupPAGStd(1) OccupPAGStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy PAG conditioning');
ylim([0 100]);
plot(ones(size(OccupPAG,2)),100*OccupPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPAG,2)),100*OccupPAG(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);


subplot(2,5,8)

bar([1 2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],100*[OccupPosPAGStd(1) OccupPosPAGStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post PAG');
ylim([0 100]);
plot(ones(size(OccupPosPAG,2)),100*OccupPosPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPosPAG,2)),100*OccupPosPAG(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);

subplot(2,5,9)

bar([1 2],100*[OccupMFBMean(1) OccupMFBMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupMFBMean(1) OccupMFBMean(2)],100*[OccupMFBStd(1) OccupMFBStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy MFB conditioning');
ylim([0 100]);
plot(ones(size(OccupMFB,2)),100*OccupMFB(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupMFB,2)),100*OccupMFB(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);


subplot(2,5,10)

bar([1 2],100*[OccupPosMFBMean(1) OccupPosMFBMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPosMFBMean(1) OccupPosMFBMean(2)],100*[OccupPosMFBStd(1) OccupPosMFBStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post MFB');
ylim([0 100]);
plot(ones(size(OccupPosMFB,2)),100*OccupPosMFB(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPosMFB,2)),100*OccupPosMFB(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);


%% Speed

SpeedShockPreMean=nanmean(SpeedShockPre);
SpeedShockPreStd=nanstd(SpeedShockPre);

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreStd=nanstd(SpeedSafePre);

SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
SpeedShockPosPAGStd=nanstd(SpeedShockPosPAG);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGStd=nanstd(SpeedSafePosPAG);

SpeedShockPosMFBMean=nanmean(SpeedShockPosMFB);
SpeedShockPosMFBStd=nanstd(SpeedShockPosMFB);

SpeedSafePosMFBMean=nanmean(SpeedSafePosMFB);
SpeedSafePosMFBStd=nanstd(SpeedSafePosMFB);

figure

subplot(2,2,1)
bar([1 2 3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],[SpeedShockPreStd SpeedShockPosPAGStd SpeedShockPosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during reversal experiment');
ylim([0 15]);

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,2,2)
bar([1 2],[SpeedShockPreMean SpeedSafePreMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPreMean SpeedSafePreMean],[SpeedShockPreStd SpeedSafePreStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during pre-tests in reversal experiment');
ylim([0 15]);

text(find(isnan([SpeedShockPreMean SpeedSafePreMean])),ones(length(find(isnan([SpeedShockPreMean SpeedSafePreMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')


subplot(2,2,3)
bar([1 2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],[SpeedShockPosPAGStd SpeedSafePosPAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during post-PAG in reversal experiment');
ylim([0 15]);

text(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])),ones(length(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')


subplot(2,2,4)
bar([1 2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],[SpeedShockPosMFBStd SpeedSafePosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during post-MFB tests in reversal experiment');
ylim([0 15]);

text(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])),ones(length(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

%% Number of entries in shock zone

NumEntPreMean=mean(NumEntPre);
NumEntPreStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGStd=std(NumEntPosPAG);

NumEntPosMFBMean=mean(NumEntPosMFB);
NumEntPosMFBStd=std(NumEntPosMFB);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};


figure
bar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean],[NumEntPreStd NumEntPosPAGStd NumEntPosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(NumEntPre)),NumEntPre,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(NumEntPosPAG)),NumEntPosPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(3*ones(length(NumEntPosMFB)),NumEntPosMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);


ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 5]);
title('Number of entries in shock zone during reversal experiment');

%% Number of Stimulations

figure
bar([1 2],[NumCondPAG NumCondMFB],'k')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('Number of PAG and MFB stimulations during reversal experiment');
ylim([0 250]);

text([1 2],[NumCondPAG NumCondMFB],num2str([NumCondPAG NumCondMFB]'),'vert','bottom','horiz','center','FontSize',10, 'FontWeight','bold')


%% Density map
TrajPreCat(TrajPreCat == 0) = NaN;
TrajPosPAGCat(TrajPosPAGCat == 0) = NaN;
TrajPosMFBCat(TrajPosMFBCat == 0) = NaN;

figure
subplot(1,3,1)
[occH, x1, x2] = hist2(TrajPreCat(:,1), TrajPreCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        % -- trajectories
        for i=1:4
            pl=plot(TrajPre(:,1,i),TrajPre(:,2,i), 'w', 'linewidth',.05);
            pl.Color(4) = .3;    %control line color intensity here
            hold on
            set(gca, 'XTickLabel', []);
            set(gca, 'YTickLabel', []);
        end
        
        title('Occupancy map during pre-tests');
        
        subplot(1,3,2)
[occH, x1, x2] = hist2(TrajPosPAGCat(:,1), TrajPosPAGCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        % -- trajectories
        for i=1:4
            pl=plot(TrajPosPAG(:,1,i),TrajPosPAG(:,2,i), 'w', 'linewidth',.05);
            pl.Color(4) = .3;    %control line color intensity here
            hold on
            set(gca, 'XTickLabel', []);
            set(gca, 'YTickLabel', []);
        end
        
        title('Occupancy map during post-PAG tests');
        
        subplot(1,3,3)
[occH, x1, x2] = hist2(TrajPosMFBCat(:,1), TrajPosMFBCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        % -- trajectories
        
        for i=1:4
            pl=plot(TrajPosMFB(:,1,i),TrajPosMFB(:,2,i), 'w', 'linewidth',.05);
            pl.Color(4) = .3;    %control line color intensity here
            hold on
            set(gca, 'XTickLabel', []);
            set(gca, 'YTickLabel', []);
        end
        
        title('Occupancy map during post-MFB tests');
%% Speed map (NOT GOOD - it is biased by occupancy)

subplot(2,3,4)
[SpeedPreAvg posX posY] = speedDensity(TrajPreCat(:,1),TrajPreCat(:,2),SpeedPreCat);

imagesc(posX,posY,SpeedPreAvg')
colormap(jet)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
title('Speed density map during pre-tests')

subplot(2,3,5)
[SpeedPosPAGAvg posX posY] = speedDensity(TrajPosPAGCat(:,1),TrajPosPAGCat(:,2),SpeedPosPAGCat);

imagesc(posX,posY,SpeedPosPAGAvg')
colormap(jet)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
title('Speed density map during post-PAG tests')

subplot(2,3,6)
[SpeedPosMFBAvg posX posY] = speedDensity(TrajPosMFBCat(:,1),TrajPosMFBCat(:,2),SpeedPosMFBCat);

imagesc(posX,posY,SpeedPosMFBAvg')
colormap(jet)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
title('Speed density map during post-PAG tests')

%%

%% Escape Latency

EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
EscapeWallShockPAGStd=nanstd(EscapeWallShockPAG);

EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
EscapeWallShockMFBStd=nanstd(EscapeWallShockMFB);

EscapeWallSafeMFBMean=nanmean(EscapeWallSafeMFB);
EscapeWallSafeMFBStd=nanstd(EscapeWallSafeMFB);

EscapeWallSafePAGMean=nanmean(EscapeWallSafePAG);
EscapeWallSafePAGStd=nanstd(EscapeWallSafePAG);

figure
subplot(2,2,1)
bar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],'k')
set(gca,'xticklabel',{'PAG Conditioning','MFB Conditioning'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],[EscapeWallShockPAGStd EscapeWallShockMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallShockPAG)),EscapeWallShockPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallShockMFB)),EscapeWallShockMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);


ylabel('Time of escape','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Escape Latency from Shock Zone');

subplot(2,2,2)
bar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],'k')
set(gca,'xticklabel',{'PAG Conditioning','MFB Conditioning'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],[EscapeWallSafePAGStd EscapeWallSafeMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallSafePAG)),EscapeWallSafePAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallSafeMFB)),EscapeWallSafeMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);


ylabel('Time of escape','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Escape Latency from Safe Zone');

subplot(2,2,3)
bar([1,2],[EscapeWallShockPAGMean EscapeWallSafePAGMean],'k')
set(gca,'xticklabel',{'Shock Zone','Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallSafePAGMean],[EscapeWallShockPAGStd EscapeWallSafePAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallShockPAG)),EscapeWallShockPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallSafePAG)),EscapeWallSafePAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Time of escape','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Escape Latency During PAG Conditioning');

subplot(2,2,4)
bar([1,2],[EscapeWallShockMFBMean EscapeWallSafeMFBMean],'k')
set(gca,'xticklabel',{'Shock Zone','Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockMFBMean EscapeWallSafeMFBMean],[EscapeWallShockMFBStd EscapeWallSafeMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallShockMFB)),EscapeWallShockMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallSafeMFB)),EscapeWallSafeMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Time of escape','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Escape Latency During MFB Conditioning');

%% Compare Explorations

figure
subplot(2,2,1)
[occH, x1, x2] = hist2(TrajExploPre(:,1), TrajExploPre(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        % -- trajectories

        pl=plot(TrajExploPre(:,1),TrajExploPre(:,2), 'w', 'linewidth',.05);
        pl.Color(4) = .3;    %control line color intensity here
        hold on
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);

        
        title('Occupancy map during Pre-exploration');
        
subplot(2,2,2)
[occH, x1, x2] = hist2(TrajExploPos(:,1), TrajExploPos(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=x1;
        y=x2;
        
        imagesc(x1,x2,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        % -- trajectories

        pl=plot(TrajExploPos(:,1),TrajExploPos(:,2), 'w', 'linewidth',.05);
        pl.Color(4) = .3;    %control line color intensity here
        hold on
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);

        
        title('Occupancy map during Post-exploration');
        
subplot(2,2,3)
bar([1 2],100*[OccupExploPre(1) OccupExploPre(2)],'k')
set(gca,'xticklabel',{'Shock','Safe'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Pre-exploration');
ylim([0 60]);

subplot(2,2,4)
bar([1 2],100*[OccupExploPos(1) OccupExploPos(2)],'k')
set(gca,'xticklabel',{'Shock','Safe'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post-exploration');
ylim([0 60]);

% 


