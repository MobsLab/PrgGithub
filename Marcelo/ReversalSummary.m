% Get Data M863
% Pre-tests
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

% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_06/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_07/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_08/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_09/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_10/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_11/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_12/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_13/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_14/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_15/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_16/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_17/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

%% Get Data M913
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

TrajPosMFB(TrajPosMFB == 0)=NaN;

% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_00/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_01/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_02/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_03/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_04/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_06/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_05/behavResources.mat')
Events=PosMat(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

%% Prepare data to plot

%Occupancy
OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBStd=std(OccupPosMFB,0,2);

OccupLabels={'Pre-test';'Post-PAG';'Post-MFB'};

OccupLabels_2={'Shock';'Safe'};

%First Time to enter shock Zone

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

%Number of entries in Shock zone

NumEntPreMean=mean(NumEntPre);
NumEntPreStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGStd=std(NumEntPosPAG);

NumEntPosMFBMean=mean(NumEntPosMFB);
NumEntPosMFBStd=std(NumEntPosMFB);

% Speed

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




%% Plot summary figure

figure

%Trajectories
subplot(4,4,1)
hold on
for i=1:4
    plot(TrajPre(:,1,i),TrajPre(:,2,i));
end

%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Pre Test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,50]);

hold off

subplot(4,4,2.5)
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
ylim([0,50]);

hold off

subplot(4,4,4)
hold on
for i=1:4
    plot(TrajPosMFB(:,1,i),TrajPosMFB(:,2,i));
end
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Post MFB Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim([0,60]);
ylim([0,50]);

hold off

% Occupancies

subplot(4,4,5)
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
title('Zone Occupancy in Pre Tests');
ylim([0 60]);

subplot(4,4,6.5)
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
ylim([0 60]);

subplot(4,4,8)
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
ylim([0 60]);

%%The second figure begins
%Shock Zone Occupancy
subplot(4,4,9)
% figure
% subplot(2,4,1)

bar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
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
title('Shock zone occupancy');

%First Time to enter Shock zone

subplot(4,4,10)
% subplot(2,4,2)
bar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
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
text(xrange(1),116,' No entries','Color','red','FontSize',8, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First entry in shock zone');

%Number of entries in shock zone

subplot(4,4,11)
% subplot(2,4,3)
bar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
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
title('Number of entries in shock zone');

%Number of Stimulations

subplot(4,4,12)
% subplot(2,4,4)

bar([1 2],[NumCondPAG NumCondMFB],'k')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('Number of PAG and MFB stimulations');
ylim([0 60]);

text([1 2],[NumCondPAG NumCondMFB],num2str([NumCondPAG NumCondMFB]'),'vert','bottom','horiz','center','FontSize',10, 'FontWeight','bold')

%Speed

subplot(4,4,13)
% subplot(2,4,5)

bar([1 2 3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],[SpeedShockPreStd SpeedShockPosPAGStd SpeedShockPosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Shock zone speed');
ylim([0 15]);

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])))),{'No entries'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(4,4,14)
% subplot(2,4,6)


bar([1 2],[SpeedShockPreMean SpeedSafePreMean],'k')
set(gca,'xticklabel',{'Shock';'Safe'})
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPreMean SpeedSafePreMean],[SpeedShockPreStd SpeedSafePreStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Pre-tests speed');
ylim([0 15]);

text(find(isnan([SpeedShockPreMean SpeedSafePreMean])),ones(length(find(isnan([SpeedShockPreMean SpeedSafePreMean])))),{'No entries'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(4,4,15)
% subplot(2,4,7)


bar([1 2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],'k')
set(gca,'xticklabel',{'Shock';'Safe'})
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],[SpeedShockPosPAGStd SpeedSafePosPAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Post-PAG speed');
ylim([0 15]);

text(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])),ones(length(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])))),{'No entries'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(4,4,16)
% subplot(2,4,8)


bar([1 2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],'k')
set(gca,'xticklabel',{'Shock';'Safe'})
set(gca,'FontWeight','bold')
set(gca,'FontSize',8)
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],[SpeedShockPosMFBStd SpeedSafePosMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Post-MFB speed');
ylim([0 15]);

text(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])),ones(length(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])))),{'No entries'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

annotation('textbox', [0 0.9 1 0.1],'String', 'Reversal Experiment M863 Summary','EdgeColor', 'none','HorizontalAlignment', 'center','FontSize',12, 'FontWeight','bold')