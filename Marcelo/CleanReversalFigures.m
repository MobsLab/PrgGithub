%% Get Data
clear all
%  clearvars -except teste1
MouseNumber = 934; %Enter the mouse number: 863, 913, 934, 935 or 938
Control = 0; %0: It was an experiment, 1: It was a control with sham stim
use_block_session = 0; %0 don't use, 1 use
FracArea = 0.99;

if MouseNumber == 863 && Control == 0
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_00/cleanBehavResources.mat')
    OccupPre(:,1) = Occup;
    TrajPre{1} = CleanPosMatInit(:,[2,3]);
    SpeedPre{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(1) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=aux(ZoneIndices{1});
    SpeedSafePre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPre(1)=0;
    else
    NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=CleanPosMatInit(:,[2,3]);
    SpeedPreCat= Data(Vtsd);
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_01/cleanBehavResources.mat')
    OccupPre(:,2) = Occup;
    TrajPre{2} = CleanPosMatInit(:,[2,3]);
    SpeedPre{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(2) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(2)=0;
    else
    NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_02/cleanBehavResources.mat')
    OccupPre(:,3) = Occup;
    TrajPre{3} = CleanPosMatInit(:,[2,3]);
    SpeedPre{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(3) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));


    if isempty(ZoneIndices{1})
        NumEntPre(3)=0;
    else
    NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPre_03/cleanBehavResources.mat')
    OccupPre(:,4) = Occup;
    TrajPre{4} = CleanPosMatInit(:,[2,3]);
    SpeedPre{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(4) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(4)=0;
    else
    NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);


    % Post-PAG
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_00/cleanBehavResources.mat')
    OccupPosPAG(:,1)=Occup;
    TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(1) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=aux(ZoneIndices{1});
    SpeedSafePosPAG=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosPAG(1) = 0;
    else
    NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
    SpeedPosPAGCat= Data(Vtsd);
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_01/cleanBehavResources.mat')
    OccupPosPAG(:,2)=Occup;
    TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(2) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(2) = 0;
    else
    NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_02/cleanBehavResources.mat')
    OccupPosPAG(:,3)=Occup;
    TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(3) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(3) = 0;
    else
    NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_03/cleanBehavResources.mat')
    OccupPosPAG(:,4)=Occup;
    TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(4) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(4) = 0;
    else
    NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end


    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    % Post MFB
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_04/cleanBehavResources.mat')
    OccupPosMFB(:,1)=Occup;
    TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(1) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=aux(ZoneIndices{1});
    SpeedSafePosMFB=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosMFB(1)=0;
    else
    NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
    SpeedPosMFBCat= Data(Vtsd);
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_05/cleanBehavResources.mat')
    OccupPosMFB(:,2)=Occup;
    TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(2) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(2)=0;
    else
    NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_06/cleanBehavResources.mat')
    OccupPosMFB(:,3)=Occup;
    TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(3) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(3)=0;
    else
    NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-TestPost_07/cleanBehavResources.mat')
    OccupPosMFB(:,4)=Occup;
    TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(4) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(4)=0;
    else
    NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end



    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,2)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,6)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,7)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,8)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_06/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,9)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,10)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,10)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,10)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_07/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,11)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,11)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,11)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_08/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,12)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,12)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,12)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajPAG(TrajPAG == 0) = NaN;
    ShockPlacePAG(ShockPlacePAG == 0) = NaN;


    % MFB conditioning
    NumCondMFB=0;

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_09/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,1)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,2)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_10/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,3)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_11/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,4)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_12/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,5)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,6)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_13/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,7)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_14/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,8)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_15/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,9)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    if use_block_session == 1
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-CondWallShock_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,10)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,10)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,10)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_16/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,11)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,11)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,11)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Cond_17/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    OccupMFB(:,12)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,12)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,12)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajMFB(TrajMFB == 0) = NaN;
    ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

    %Explorations
    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Hab_00/cleanBehavResources.mat')
    OccupExploPre=Occup;
    TrajExploPre=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPre = aux(1);
    end
    TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPre=aux(ZoneIndices{1});
    SpeedSafeExploPre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPre=0;
    else
    NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
    end

    load('/media/vador/DataMOBS104/Marcelo/M863/20190223/Reversal/ERC-Mouse-863-23052019-Hab_03/cleanBehavResources.mat')
    OccupExploPos=Occup;
    TrajExploPos=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPos = aux(1);
    end
    TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPos=aux(ZoneIndices{1});
    SpeedSafeExploPos=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPos=0;
    else
    NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
    end
    
    
    stats = regionprops(mask, 'Area');
    tempmask=mask;
                AimArea=stats.Area*FracArea;
                ActArea=stats.Area;
                while AimArea<ActArea
                    tempmask=imerode(tempmask,strel('disk',1));
                    stats = regionprops(tempmask, 'Area');
                    ActArea=stats.Area;
                end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;
    
    %Hard coded escape latencies
    
    EscapeWallShockPAG = [0.0690 0.2070 8.2260];
    EscapeWallShockMFB =  [3.1720 0 12.4310];
    EscapeWallSafeMFB = [5.385 1.0760 0.5550];
    EscapeWallSafePAG = [0.9670 5.445 1.454];
    

end 

if MouseNumber == 913 && Control == 0
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_00/cleanBehavResources.mat')
    OccupPre(:,1) = Occup;
    TrajPre{1} = CleanPosMatInit(:,[2,3]);
    SpeedPre{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(1) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=aux(ZoneIndices{1});
    SpeedSafePre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPre(1)=0;
    else
    NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=CleanPosMatInit(:,[2,3]);
    SpeedPreCat= Data(Vtsd);
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_01/cleanBehavResources.mat')
    OccupPre(:,2) = Occup;
    TrajPre{2} = CleanPosMatInit(:,[2,3]);
    SpeedPre{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(2) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(2)=0;
    else
    NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_02/cleanBehavResources.mat')
    OccupPre(:,3) = Occup;
    TrajPre{3} = CleanPosMatInit(:,[2,3]);
    SpeedPre{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(3) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(3)=0;
    else
    NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_03/cleanBehavResources.mat')
    OccupPre(:,4) = Occup;
    TrajPre{4} = CleanPosMatInit(:,[2,3]);
    SpeedPre{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(4) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(4)=0;
    else
    NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);




    % Post-PAG
    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_00/cleanBehavResources.mat')
    OccupPosPAG(:,1)=Occup;
    TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(1) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=aux(ZoneIndices{1});
    SpeedSafePosPAG=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosPAG(1) = 0;
    else
    NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
    SpeedPosPAGCat= Data(Vtsd);
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_01/cleanBehavResources.mat')
    OccupPosPAG(:,2)=Occup;
    TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(2) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(2) = 0;
    else
    NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_02/cleanBehavResources.mat')
    OccupPosPAG(:,3)=Occup;
    TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(3) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(3) = 0;
    else
    NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_03/cleanBehavResources.mat')
    OccupPosPAG(:,4)=Occup;
    TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(4) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(4) = 0;
    else
    NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);





    % Post MFB
    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_04/cleanBehavResources.mat')
    OccupPosMFB(:,1)=Occup;
    TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(1) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=aux(ZoneIndices{1});
    SpeedSafePosMFB=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosMFB(1)=0;
    else
    NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
    SpeedPosMFBCat= Data(Vtsd);
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_05/cleanBehavResources.mat')
    OccupPosMFB(:,2)=Occup;
    TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(2) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(2)=0;
    else
    NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_06/cleanBehavResources.mat')
    OccupPosMFB(:,3)=Occup;
    TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(3) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(3)=0;
    else
    NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_07/cleanBehavResources.mat')
    OccupPosMFB(:,4)=Occup;
    TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(4) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(4)=0;
    else
    NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);




    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(1)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,2)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(CleanPosMatInit(:,4) == 1,[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafePAG(1)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4)== 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);



    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(2)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end
    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafePAG(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,6)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,7)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,8)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafePAG(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,9)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajPAG(TrajPAG == 0) = NaN;
    ShockPlacePAG(ShockPlacePAG == 0) = NaN;

    % MFB conditioning
    NumCondMFB=0;

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,1)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(1)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end
    %

    OccupMFB(:,2)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafeMFB(1)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,3)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,4)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,5)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafeMFB(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,6)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Cond_06/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,7)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,8)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallSafe_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallSafeMFB(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,9)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajMFB(TrajMFB == 0) = NaN;
    ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

    EscapeWallShockPAG=EscapeWallShockPAG-180;
    EscapeWallShockMFB=EscapeWallShockMFB-180;
    EscapeWallSafeMFB=EscapeWallSafeMFB-180;
    EscapeWallSafePAG=EscapeWallSafePAG-180;

    %Explorations
    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Hab_00/cleanBehavResources.mat')
    OccupExploPre=Occup;
    TrajExploPre=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPre = aux(1);
    end
    TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPre=aux(ZoneIndices{1});
    SpeedSafeExploPre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPre=0;
    else
    NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
    end

    load('/media/vador/DataMOBS104/Marcelo/M913/20190529/Reversal/ERC-Mouse-913-29052019-Hab_03/cleanBehavResources.mat')
    OccupExploPos=Occup;
    TrajExploPos=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPos = aux(1);
    end
    TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPos=aux(ZoneIndices{1});
    SpeedSafeExploPos=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPos=0;
    else
    NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
    end
    
    stats = regionprops(mask, 'Area');
    tempmask=mask;
    AimArea=stats.Area*FracArea;
    ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;

end

if MouseNumber == 913 && Control == 1
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPre_00/cleanBehavResources.mat')
    OccupPre(:,1) = Occup;
    TrajPre{1} = CleanPosMatInit(:,[2,3]);
    SpeedPre{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(1) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=aux(ZoneIndices{1});
    SpeedSafePre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPre(1)=0;
    else
    NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=CleanPosMatInit(:,[2,3]);
    SpeedPreCat= Data(Vtsd);
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPre_01/cleanBehavResources.mat')
    OccupPre(:,2) = Occup;
    TrajPre{2} = CleanPosMatInit(:,[2,3]);
    SpeedPre{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(2) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(2)=0;
    else
    NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPre_02/cleanBehavResources.mat')
    OccupPre(:,3) = Occup;
    TrajPre{3} = CleanPosMatInit(:,[2,3]);
    SpeedPre{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(3) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(3)=0;
    else
    NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPre_03/cleanBehavResources.mat')
    OccupPre(:,4) = Occup;
    TrajPre{4} = CleanPosMatInit(:,[2,3]);
    SpeedPre{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPre(4) = aux(1);
    end
    TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
    SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPre(4)=0;
    else
    NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
    SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
    SpeedPreCat(end+1)=SpeedPreCat(end);




    % Post-PAG
    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_00/cleanBehavResources.mat')
    OccupPosPAG(:,1)=Occup;
    TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(1) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=aux(ZoneIndices{1});
    SpeedSafePosPAG=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosPAG(1) = 0;
    else
    NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
    SpeedPosPAGCat= Data(Vtsd);
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_01/cleanBehavResources.mat')
    OccupPosPAG(:,2)=Occup;
    TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(2) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(2) = 0;
    else
    NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_02/cleanBehavResources.mat')
    OccupPosPAG(:,3)=Occup;
    TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(3) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(3) = 0;
    else
    NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_03/cleanBehavResources.mat')
    OccupPosPAG(:,4)=Occup;
    TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosPAG{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosPAG(4) = aux(1);
    end
    TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
    SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosPAG(4) = 0;
    else
    NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
    SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
    SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);





    % Post MFB
    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_04/cleanBehavResources.mat')
    OccupPosMFB(:,1)=Occup;
    TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{1} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(1) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=aux(ZoneIndices{1});
    SpeedSafePosMFB=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntPosMFB(1)=0;
    else
    NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
    SpeedPosMFBCat= Data(Vtsd);
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_05/cleanBehavResources.mat')
    OccupPosMFB(:,2)=Occup;
    TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{2} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(2) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(2)=0;
    else
    NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_06/cleanBehavResources.mat')
    OccupPosMFB(:,3)=Occup;
    TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{3} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(3) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(3)=0;
    else
    NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-TestPost_07/cleanBehavResources.mat')
    OccupPosMFB(:,4)=Occup;
    TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
    SpeedPosMFB{4} = [Data(Vtsd); 0];
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockPosMFB(4) = aux(1);
    end
    TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
    SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

    if isempty(ZoneIndices{1})
        NumEntPosMFB(4)=0;
    else
    NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
    end

    TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
    SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
    SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);




    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(1)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,2)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(CleanPosMatInit(:,4) == 1,[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafePAG(1)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4)== 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);



    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(2)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end
    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafePAG(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,6)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));
    OccupPAG(:,7)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockPAG(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,8)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafePAG(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupPAG(:,9)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajPAG(TrajPAG == 0) = NaN;
    ShockPlacePAG(ShockPlacePAG == 0) = NaN;

    % MFB conditioning
    NumCondMFB=0;

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,1)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(1)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end
    %

    OccupMFB(:,2)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafeMFB(1)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,3)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,4)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,5)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_04/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafeMFB(2)=aux(1);

    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,6)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Cond_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));
    OccupMFB(:,7)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallShock_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{4},1);
    aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
    EscapeWallShockMFB(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,8)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-CondWallSafe_05/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondMFB = NumCondMFB +length(find(Events));

    aux=CleanPosMatInit(ZoneIndices{5},1);
    aux=aux(CleanPosMatInit(ZoneIndices{5},1)>180);
    EscapeWallSafeMFB(3)=aux(1);


    if use_block_session == 0
        cutOut=find(CleanPosMatInit(:,1) < 180);
        CleanPosMatInit(cutOut,:) = [];
        for i=1:7
        Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
        end
    end

    OccupMFB(:,9)=Occup;
    TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
    ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    TrajMFB(TrajMFB == 0) = NaN;
    ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

    EscapeWallShockPAG=EscapeWallShockPAG-180;
    EscapeWallShockMFB=EscapeWallShockMFB-180;
    EscapeWallSafeMFB=EscapeWallSafeMFB-180;
    EscapeWallSafePAG=EscapeWallSafePAG-180;

    %Explorations
    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Hab_00/cleanBehavResources.mat')
    OccupExploPre=Occup;
    TrajExploPre=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPre = aux(1);
    end
    TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPre=aux(ZoneIndices{1});
    SpeedSafeExploPre=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPre=0;
    else
    NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
    end

    load('/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl/ERC-Mouse-913-02072019-Hab_03/cleanBehavResources.mat')
    OccupExploPos=Occup;
    TrajExploPos=CleanPosMatInit(:,[2,3]);
    aux=cell2mat(ZoneIndices(1));
    if isempty(aux)
        IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
    else
    IndFirstTimeShockExploPos = aux(1);
    end
    TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

    aux=Data(Vtsd);
    aux(end+1)=aux(end);
    SpeedShockExploPos=aux(ZoneIndices{1});
    SpeedSafeExploPos=aux(ZoneIndices{2});

    if isempty(ZoneIndices{1})
        NumEntExploPos=0;
    else
    NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
    end
    
    stats = regionprops(mask, 'Area');
    tempmask=mask;
    AimArea=stats.Area*FracArea;
    ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;

end

if MouseNumber == 934 && Control == 0
    % Pre-tests
load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_00/cleanBehavResources.mat')
OccupPre(:,1) = Occup;
TrajPre{1} = CleanPosMatInit(:,[2,3]);
SpeedPre{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(1) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=aux(ZoneIndices{1});
SpeedSafePre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPre(1)=0;
else
NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=CleanPosMatInit(:,[2,3]);
SpeedPreCat= Data(Vtsd);
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_01/cleanBehavResources.mat')
OccupPre(:,2) = Occup;
TrajPre{2} = CleanPosMatInit(:,[2,3]);
SpeedPre{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(2) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(2)=0;
else
NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_02/cleanBehavResources.mat')
OccupPre(:,3) = Occup;
TrajPre{3} = CleanPosMatInit(:,[2,3]);
SpeedPre{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(3) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(3)=0;
else
NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_03/cleanBehavResources.mat')
OccupPre(:,4) = Occup;
TrajPre{4} = CleanPosMatInit(:,[2,3]);
SpeedPre{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(4) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(4)=0;
else
NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);




% Post-PAG
load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_00/cleanBehavResources.mat')
OccupPosPAG(:,1)=Occup;
TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(1) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=aux(ZoneIndices{1});
SpeedSafePosPAG=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosPAG(1) = 0;
else
NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
SpeedPosPAGCat= Data(Vtsd);
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_01/cleanBehavResources.mat')
OccupPosPAG(:,2)=Occup;
TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(2) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(2) = 0;
else
NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_02/cleanBehavResources.mat')
OccupPosPAG(:,3)=Occup;
TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(3) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(3) = 0;
else
NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_03/cleanBehavResources.mat')
OccupPosPAG(:,4)=Occup;
TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(4) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(4) = 0;
else
NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);





% Post MFB
load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_04/cleanBehavResources.mat')
OccupPosMFB(:,1)=Occup;
TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(1) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=aux(ZoneIndices{1});
SpeedSafePosMFB=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosMFB(1)=0;
else
NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
SpeedPosMFBCat= Data(Vtsd);
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_05/cleanBehavResources.mat')
OccupPosMFB(:,2)=Occup;
TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(2) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(2)=0;
else
NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_06/cleanBehavResources.mat')
OccupPosMFB(:,3)=Occup;
TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(3) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(3)=0;
else
NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_07/cleanBehavResources.mat')
OccupPosMFB(:,4)=Occup;
TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(4) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(4)=0;
else
NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);




% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,1)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(1)=360;
else
EscapeWallShockPAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,2)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(CleanPosMatInit(:,4) == 1,[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(1)=360;
else
EscapeWallSafePAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,3)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4)== 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);



load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,4)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(2)=360;
else
EscapeWallShockPAG(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
OccupPAG(:,5)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(2)=360;
else
EscapeWallSafePAG(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,6)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,7)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(3)=360;
else
EscapeWallShockPAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,8)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(3)=360;
else
EscapeWallSafePAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,9)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajPAG(TrajPAG == 0) = NaN;
ShockPlacePAG(ShockPlacePAG == 0) = NaN;

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,1)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(1)=360;
else
EscapeWallShockMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
%

OccupMFB(:,2)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(1)=360;
else
EscapeWallSafeMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,3)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,4)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(2)=360;
else
EscapeWallShockMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,5)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(2)=360;
else
EscapeWallSafeMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,6)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Cond_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,7)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(3)=360;
else
EscapeWallShockMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,8)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallSafe_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(3)=360;
else
EscapeWallSafeMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,9)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajMFB(TrajMFB == 0) = NaN;
ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

EscapeWallShockPAG=EscapeWallShockPAG-180;
EscapeWallShockMFB=EscapeWallShockMFB-180;
EscapeWallSafeMFB=EscapeWallSafeMFB-180;
EscapeWallSafePAG=EscapeWallSafePAG-180;

%Explorations
load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Hab_00/cleanBehavResources.mat')
OccupExploPre=Occup;
TrajExploPre=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPre = aux(1);
end
TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPre=aux(ZoneIndices{1});
SpeedSafeExploPre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPre=0;
else
NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
end

load('/media/vador/DataMOBS104/Marcelo/M934/20190612/Reversal/ERC-Mouse-934-12062019-Hab_03/cleanBehavResources.mat')
OccupExploPos=Occup;
TrajExploPos=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPos = aux(1);
end
TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPos=aux(ZoneIndices{1});
SpeedSafeExploPos=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPos=0;
else
NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
end

    stats = regionprops(mask, 'Area');
    tempmask=mask;
    AimArea=stats.Area*FracArea;
    ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;

end

if MouseNumber == 935 && Control == 1
    % Pre-tests
load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPre_00/cleanBehavResources.mat')
OccupPre(:,1) = Occup;
TrajPre{1} = CleanPosMatInit(:,[2,3]);
SpeedPre{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(1) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=aux(ZoneIndices{1});
SpeedSafePre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPre(1)=0;
else
NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=CleanPosMatInit(:,[2,3]);
SpeedPreCat= Data(Vtsd);
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPre_01/cleanBehavResources.mat')
OccupPre(:,2) = Occup;
TrajPre{2} = CleanPosMatInit(:,[2,3]);
SpeedPre{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(2) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(2)=0;
else
NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPre_02/cleanBehavResources.mat')
OccupPre(:,3) = Occup;
TrajPre{3} = CleanPosMatInit(:,[2,3]);
SpeedPre{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(3) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));


if isempty(ZoneIndices{1})
    NumEntPre(3)=0;
else
NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPre_03/cleanBehavResources.mat')
OccupPre(:,4) = Occup;
TrajPre{4} = CleanPosMatInit(:,[2,3]);
SpeedPre{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(4) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(4)=0;
else
NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);




% Post-PAG
load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_00/cleanBehavResources.mat')
OccupPosPAG(:,1)=Occup;
TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(1) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=aux(ZoneIndices{1});
SpeedSafePosPAG=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosPAG(1) = 0;
else
NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
SpeedPosPAGCat= Data(Vtsd);
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_01/cleanBehavResources.mat')
OccupPosPAG(:,2)=Occup;
TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(2) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(2) = 0;
else
NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_03/cleanBehavResources.mat')
OccupPosPAG(:,3)=Occup;
TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(3) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(3) = 0;
else
NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_04/cleanBehavResources.mat')
OccupPosPAG(:,4)=Occup;
TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(4) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(4) = 0;
else
NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);





% Post MFB
load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_02/cleanBehavResources.mat')
OccupPosMFB(:,1)=Occup;
TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(1) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=aux(ZoneIndices{1});
SpeedSafePosMFB=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosMFB(1)=0;
else
NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
SpeedPosMFBCat= Data(Vtsd);
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_05/cleanBehavResources.mat')
OccupPosMFB(:,2)=Occup;
TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(2) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(2)=0;
else
NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_06/cleanBehavResources.mat')
OccupPosMFB(:,3)=Occup;
TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(3) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(3)=0;
else
NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-TestPost_07/cleanBehavResources.mat')
OccupPosMFB(:,4)=Occup;
TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(4) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(4)=0;
else
NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,1)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(1)=360;
else
    EscapeWallShockPAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,2)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(CleanPosMatInit(:,4) == 1,[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(1)=360;
else
    EscapeWallSafePAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,3)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4)== 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);



load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,4)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(2)=360;
else
    EscapeWallShockPAG(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
OccupPAG(:,5)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(2)=360;
else
    EscapeWallSafePAG(2)=aux(1);
end
EscapeWallSafePAG(2)=aux(1);

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,6)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,7)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(3)=360;
else
    EscapeWallShockPAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,8)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(3)=360;
else
    EscapeWallSafePAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,9)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajPAG(TrajPAG == 0) = NaN;
ShockPlacePAG(ShockPlacePAG == 0) = NaN;

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,1)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(1)=360;
else
    EscapeWallShockMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
%

OccupMFB(:,2)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(1)=360;
else
    EscapeWallSafeMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,3)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,4)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(2)=360;
else
    EscapeWallShockMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,5)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(2)=360;
else
    EscapeWallSafeMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,6)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Cond_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,7)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(3)=360;
else
    EscapeWallShockMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,8)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallSafe_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(3)=360;
else
    EscapeWallSafeMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,9)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajMFB(TrajMFB == 0) = NaN;
ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

EscapeWallShockPAG=EscapeWallShockPAG-180;
EscapeWallShockMFB=EscapeWallShockMFB-180;
EscapeWallSafeMFB=EscapeWallSafeMFB-180;
EscapeWallSafePAG=EscapeWallSafePAG-180;

%Explorations
load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Hab_00/cleanBehavResources.mat')
OccupExploPre=Occup;
TrajExploPre=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPre = aux(1);
end
TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPre=aux(ZoneIndices{1});
SpeedSafeExploPre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPre=0;
else
NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
end

load('/media/vador/DataMOBS104/Marcelo/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-Hab_03/cleanBehavResources.mat')
OccupExploPos=Occup;
TrajExploPos=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPos = aux(1);
end
TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPos=aux(ZoneIndices{1});
SpeedSafeExploPos=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPos=0;
else
NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
end

    stats = regionprops(mask, 'Area');
    tempmask=mask;
    AimArea=stats.Area*FracArea;
    ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;

end

if MouseNumber == 938 && Control == 1
    % Pre-tests
load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPre_00/cleanBehavResources.mat')
OccupPre(:,1) = Occup;
TrajPre{1} = CleanPosMatInit(:,[2,3]);
SpeedPre{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(1) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=aux(ZoneIndices{1});
SpeedSafePre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPre(1)=0;
else
NumEntPre(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=CleanPosMatInit(:,[2,3]);
SpeedPreCat= Data(Vtsd);
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPre_01/cleanBehavResources.mat')
OccupPre(:,2) = Occup;
TrajPre{2} = CleanPosMatInit(:,[2,3]);
SpeedPre{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(2) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(2)=0;
else
NumEntPre(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPre_02/cleanBehavResources.mat')
OccupPre(:,3) = Occup;
TrajPre{3} = CleanPosMatInit(:,[2,3]);
SpeedPre{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(3) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(3)=0;
else
NumEntPre(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPre_03/cleanBehavResources.mat')
OccupPre(:,4) = Occup;
TrajPre{4} = CleanPosMatInit(:,[2,3]);
SpeedPre{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPre(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPre(4) = aux(1);
end
TimePre(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPre=cat(1,SpeedShockPre,aux(ZoneIndices{1}));
SpeedSafePre=cat(1,SpeedSafePre,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPre(4)=0;
else
NumEntPre(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPreCat=cat(1,TrajPreCat,CleanPosMatInit(:,[2,3]));
SpeedPreCat= cat(1,SpeedPreCat,Data(Vtsd));
SpeedPreCat(end+1)=SpeedPreCat(end);




% Post-PAG
load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_00/cleanBehavResources.mat')
OccupPosPAG(:,1)=Occup;
TrajPosPAG{1}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(1) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=aux(ZoneIndices{1});
SpeedSafePosPAG=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosPAG(1) = 0;
else
NumEntPosPAG(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=CleanPosMatInit(:,[2,3]);
SpeedPosPAGCat= Data(Vtsd);
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_01/cleanBehavResources.mat')
OccupPosPAG(:,2)=Occup;
TrajPosPAG{2}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(2) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(2) = 0;
else
NumEntPosPAG(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_02/cleanBehavResources.mat')
OccupPosPAG(:,3)=Occup;
TrajPosPAG{3}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(3) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(3) = 0;
else
NumEntPosPAG(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_03/cleanBehavResources.mat')
OccupPosPAG(:,4)=Occup;
TrajPosPAG{4}=CleanPosMatInit(:,[2,3]);
SpeedPosPAG{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosPAG(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosPAG(4) = aux(1);
end
TimePosPAG(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosPAG=cat(1,SpeedShockPosPAG,aux(ZoneIndices{1}));
SpeedSafePosPAG=cat(1,SpeedSafePosPAG,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosPAG(4) = 0;
else
NumEntPosPAG(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosPAGCat=cat(1,TrajPosPAGCat,CleanPosMatInit(:,[2,3]));
SpeedPosPAGCat= cat(1,SpeedPosPAGCat,Data(Vtsd));
SpeedPosPAGCat(end+1)=SpeedPosPAGCat(end);





% Post MFB
load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_04/cleanBehavResources.mat')
OccupPosMFB(:,1)=Occup;
TrajPosMFB{1}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{1} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(1) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(1) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=aux(ZoneIndices{1});
SpeedSafePosMFB=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntPosMFB(1)=0;
else
NumEntPosMFB(1)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=CleanPosMatInit(:,[2,3]);
SpeedPosMFBCat= Data(Vtsd);
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_05/cleanBehavResources.mat')
OccupPosMFB(:,2)=Occup;
TrajPosMFB{2}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{2} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(2) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(2) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),2) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(2)=0;
else
NumEntPosMFB(2)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_06/cleanBehavResources.mat')
OccupPosMFB(:,3)=Occup;
TrajPosMFB{3}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{3} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(3) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(3) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),3) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(3)=0;
else
NumEntPosMFB(3)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-TestPost_07/cleanBehavResources.mat')
OccupPosMFB(:,4)=Occup;
TrajPosMFB{4}=CleanPosMatInit(:,[2,3]);
SpeedPosMFB{4} = [Data(Vtsd); 0];
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockPosMFB(4) = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockPosMFB(4) = aux(1);
end
TimePosMFB(1:size(CleanPosMatInit,1),4) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockPosMFB=cat(1,SpeedShockPosMFB,aux(ZoneIndices{1}));
SpeedSafePosMFB=cat(1,SpeedSafePosMFB,aux(ZoneIndices{2}));

if isempty(ZoneIndices{1})
    NumEntPosMFB(4)=0;
else
NumEntPosMFB(4)=length(find(diff(ZoneIndices{1})>1))+1;
end

TrajPosMFBCat=cat(1,TrajPosMFBCat,CleanPosMatInit(:,[2,3]));
SpeedPosMFBCat= cat(1,SpeedPosMFBCat,Data(Vtsd));
SpeedPosMFBCat(end+1)=SpeedPosMFBCat(end);




% PAG conditioning
NumCondPAG=0;

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,1)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(1)=360;
else
EscapeWallShockPAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,2)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(CleanPosMatInit(:,4) == 1,[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_00/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(1)=360;
else
EscapeWallSafePAG(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,3)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4)== 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);



load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,4)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(2)=360;
else
EscapeWallShockPAG(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
OccupPAG(:,5)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_01/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(2)=360;
else
EscapeWallSafePAG(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,6)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));
OccupPAG(:,7)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockPAG(3)=360;
else
EscapeWallShockPAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,8)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_02/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondPAG = NumCondPAG +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafePAG(3)=360;
else
EscapeWallSafePAG(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupPAG(:,9)=Occup;
TrajPAG(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajPAG(TrajPAG == 0) = NaN;
ShockPlacePAG(ShockPlacePAG == 0) = NaN;

% MFB conditioning
NumCondMFB=0;

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,1)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(1)=360;
else
EscapeWallShockMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end
%

OccupMFB(:,2)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,2)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,2)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_03/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(1)=360;
else
EscapeWallSafeMFB(1)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,3)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,4)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(2)=360;
else
EscapeWallShockMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,5)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,5)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,5)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_04/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(2)=360;
else
EscapeWallSafeMFB(2)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,6)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,6)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,6)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Cond_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));
OccupMFB(:,7)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,7)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,7)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallShock_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallShockMFB(3)=360;
else
EscapeWallShockMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,8)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,8)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,8)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-CondWallSafe_05/cleanBehavResources.mat')
Events=CleanPosMatInit(:,4);
Events(isnan(Events)) = 0;
NumCondMFB = NumCondMFB +length(find(Events));

aux=CleanPosMatInit(ZoneIndices{4},1);
aux=aux(CleanPosMatInit(ZoneIndices{4},1)>180);
if isempty(aux)
    EscapeWallSafeMFB(3)=360;
else
EscapeWallSafeMFB(3)=aux(1);
end

if use_block_session == 0
    cutOut=find(CleanPosMatInit(:,1) < 180);
    CleanPosMatInit(cutOut,:) = [];
    for i=1:7
    Occup(i)=length(find(ZoneIndices{i}>cutOut(end)))/(length(Data(Xtsd))-length(cutOut));
    end
end

OccupMFB(:,9)=Occup;
TrajMFB(1:size(CleanPosMatInit,1),:,9)=CleanPosMatInit(:,[2,3]);
ShockPlaceMFB(1:length(find(CleanPosMatInit(:,4) == 1)),:,9)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

TrajMFB(TrajMFB == 0) = NaN;
ShockPlaceMFB(ShockPlaceMFB == 0) = NaN;

EscapeWallShockPAG=EscapeWallShockPAG-180;
EscapeWallShockMFB=EscapeWallShockMFB-180;
EscapeWallSafeMFB=EscapeWallSafeMFB-180;
EscapeWallSafePAG=EscapeWallSafePAG-180;

%Explorations
load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Hab_00/cleanBehavResources.mat')
OccupExploPre=Occup;
TrajExploPre=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPre = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPre = aux(1);
end
TimeExploPre(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPre=aux(ZoneIndices{1});
SpeedSafeExploPre=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPre=0;
else
NumEntExploPre=length(find(diff(ZoneIndices{1})>1))+1;
end

load('/media/vador/DataMOBS104/Marcelo/M938/ReversalControl/ERC-Mouse-938-18062019-Hab_03/cleanBehavResources.mat')
OccupExploPos=Occup;
TrajExploPos=CleanPosMatInit(:,[2,3]);
aux=cell2mat(ZoneIndices(1));
if isempty(aux)
    IndFirstTimeShockExploPos = find(CleanPosMatInit == CleanPosMatInit(end,1));
else
IndFirstTimeShockExploPos = aux(1);
end
TimeExploPos(1:size(CleanPosMatInit,1),1) = CleanPosMatInit(:,1);

aux=Data(Vtsd);
aux(end+1)=aux(end);
SpeedShockExploPos=aux(ZoneIndices{1});
SpeedSafeExploPos=aux(ZoneIndices{2});

if isempty(ZoneIndices{1})
    NumEntExploPos=0;
else
NumEntExploPos=length(find(diff(ZoneIndices{1})>1))+1;
end

    stats = regionprops(mask, 'Area');
    tempmask=mask;
    AimArea=stats.Area*FracArea;
    ActArea=stats.Area;
        while AimArea<ActArea
            tempmask=imerode(tempmask,strel('disk',1));
            stats = regionprops(tempmask, 'Area');
            ActArea=stats.Area;
        end
    new_mask=bwboundaries(tempmask);
    NewMask=new_mask{1}./Ratio_IMAonREAL;

end

%% Save Data for avereges
MouseData =[];
struct(MouseData);

MouseData.MouseName = ['M' num2str(MouseNumber)];

%Trajectories

MouseData.TrajPre = TrajPreCat;
MouseData.TrajPosPAG = TrajPosPAGCat;
MouseData.TrajPosMFB = TrajPosMFBCat;

%Occupancies

MouseData.OccupPre = OccupPre;
MouseData.OccupPreMean=mean(OccupPre,2);
MouseData.OccupPreStd=std(OccupPre,0,2);

MouseData.OccupPosPAG = OccupPosPAG;
MouseData.OccupPosPAGMean=mean(OccupPosPAG,2);
MouseData.OccupPosPAGStd=std(OccupPosPAG,0,2);

MouseData.OccupPosMFB = OccupPosMFB;
MouseData.OccupPosMFBMean=mean(OccupPosMFB,2);
MouseData.OccupPosMFBStd=std(OccupPosMFB,0,2);

if MouseNumber == 863 && use_block_session == 0
    OccupPAG(:,[2,6,10]) = [];
    OccupMFB(:,[2,6,10]) = [];
end

MouseData.OccupPAGMean=mean(OccupPAG,2);
MouseData.OccupPAGStd=std(OccupPAG,0,2);

MouseData.OccupMFBMean=mean(OccupMFB,2);
MouseData.OccupMFBStd=std(OccupMFB,0,2);

% Number of entries

MouseData.NumEntPre=NumEntPre;
MouseData.NumEntPreMean=mean(NumEntPre);
MouseData.NumEntPreStd=std(NumEntPre);

MouseData.NumEntPosPAG=NumEntPosPAG;
MouseData.NumEntPosPAGMean=mean(NumEntPosPAG);
MouseData.NumEntPosPAGStd=std(NumEntPosPAG);

MouseData.NumEntPosMFB=NumEntPosMFB;
MouseData.NumEntPosMFBMean=mean(NumEntPosMFB);
MouseData.NumEntPosMFBStd=std(NumEntPosMFB);

% Number of stimulations

MouseData.NumCondMFB = NumCondMFB;
MouseData.NumCondPAG = NumCondPAG;

% First time to enter shock zone
for i=1:4
    FirstTimeShockPre(i)=TimePre(IndFirstTimeShockPre(i),i);
    FirstTimeShockPosPAG(i)=TimePosPAG(IndFirstTimeShockPosPAG(i),i);
    FirstTimeShockPosMFB(i)=TimePosMFB(IndFirstTimeShockPosMFB(i),i);
end

MouseData.FirstTimeShockPre=FirstTimeShockPre;
MouseData.FirstTimeShockPreMean=mean(FirstTimeShockPre);
MouseData.FirstTimeShockPreStd=std(FirstTimeShockPre);

MouseData.FirstTimeShockPosPAG=FirstTimeShockPosPAG;
MouseData.FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
MouseData.FirstTimeShockPosPAGStd=std(FirstTimeShockPosPAG);

MouseData.FirstTimeShockPosMFB=FirstTimeShockPosMFB;
MouseData.FirstTimeShockPosMFBMean=mean(FirstTimeShockPosMFB);
MouseData.FirstTimeShockPosMFBStd=std(FirstTimeShockPosMFB);

% Speed

MouseData.SpeedPre=cellfun(@nanmean,SpeedPre);
MouseData.SpeedPosPAG=cellfun(@nanmean,SpeedPosPAG);
MouseData.SpeedPosMFB=cellfun(@nanmean,SpeedPosMFB);

MouseData.SpeedShockPreMean=nanmean(SpeedShockPre);
MouseData.SpeedShockPreStd=nanstd(SpeedShockPre);

MouseData.SpeedSafePreMean=nanmean(SpeedSafePre);
MouseData.SpeedSafePreStd=nanstd(SpeedSafePre);

MouseData.SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
MouseData.SpeedShockPosPAGStd=nanstd(SpeedShockPosPAG);

MouseData.SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
MouseData.SpeedSafePosPAGStd=nanstd(SpeedSafePosPAG);

MouseData.SpeedShockPosMFBMean=nanmean(SpeedShockPosMFB);
MouseData.SpeedShockPosMFBStd=nanstd(SpeedShockPosMFB);

MouseData.SpeedSafePosMFBMean=nanmean(SpeedSafePosMFB);
MouseData.SpeedSafePosMFBStd=nanstd(SpeedSafePosMFB);

% Escape Latencies

MouseData.EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
MouseData.EscapeWallShockPAGStd=nanstd(EscapeWallShockPAG);

MouseData.EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
MouseData.EscapeWallShockMFBStd=nanstd(EscapeWallShockMFB);

MouseData.EscapeWallSafeMFBMean=nanmean(EscapeWallSafeMFB);
MouseData.EscapeWallSafeMFBStd=nanstd(EscapeWallSafeMFB);

MouseData.EscapeWallSafePAGMean=nanmean(EscapeWallSafePAG);
MouseData.EscapeWallSafePAGStd=nanstd(EscapeWallSafePAG);

if Control == 0
    save(['/home/vador/Documents/Marcelo/Results/Reversal/Averages/SingleMiceData/' 'M' num2str(MouseNumber) '.mat'],'MouseData')
elseif Control == 1 
    save(['/home/vador/Documents/Marcelo/Results/ReversalControl/Averages/SingleMiceData/' 'M' num2str(MouseNumber) '.mat'],'MouseData')
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
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
% ylim([0 30]);
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

OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBStd=std(OccupPosMFB,0,2);

if MouseNumber == 863 && use_block_session == 0
    OccupPAG(:,[2,6,10]) = [];
    OccupMFB(:,[2,6,10]) = [];
end

OccupPAGMean=mean(OccupPAG,2);
OccupPAGStd=std(OccupPAG,0,2);

OccupMFBMean=mean(OccupMFB,2);
OccupMFBStd=std(OccupMFB,0,2);

[xmin,xmax] = bounds(NewMask(:,2));
[ymin,ymax] = bounds(NewMask(:,1));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

y_range_bar = [0 100];

OccupLabels={'Pre-test';'PAG';'Post PAG';'Post MFB'};


figure

set(gcf,'DefaultLineLineWidth',1)
set(gca,'FontWeight','bold')

subplot(2,5,1)
hold on
for i=1:4
    plot(TrajPre{i}(:,1),TrajPre{i}(:,2));
end

plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Pre Test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);

hold off

subplot(2,5,2)
hold on

if MouseNumber == 863
    for i=1:12
        plot(TrajPAG(:,1,i),TrajPAG(:,2,i));
        scatter(ShockPlacePAG(:,1,i),ShockPlacePAG(:,2,i),110,'r','filled','p');
    end
    plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
else
    for i=1:9
        plot(TrajPAG(:,1,i),TrajPAG(:,2,i));
        scatter(ShockPlacePAG(:,1,i),ShockPlacePAG(:,2,i),110,'r','filled','p');
    end
    plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
end
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PAG conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);
hold off


subplot(2,5,3)
hold on
for i=1:4
    plot(TrajPosPAG{i}(:,1),TrajPosPAG{i}(:,2));
end
plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
% lgd=legend('Trial 1','Trial 2','Trial 3','Trial 4');
% aux=lgd.Location;
% lgd.Location='southoutside';
% aux=lgd.Orientation;
% lgd.Orientation = 'horizontal';

title('Post PAG Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);

hold off

subplot(2,5,4)
hold on
if MouseNumber == 863
    for i=1:12
        plot(TrajMFB(:,1,i),TrajMFB(:,2,i));
        scatter(ShockPlaceMFB(:,1,i),ShockPlaceMFB(:,2,i),110,'g','filled','p');
    end
    plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
else
    for i=1:9
        plot(TrajMFB(:,1,i),TrajMFB(:,2,i));
        scatter(ShockPlaceMFB(:,1,i),ShockPlaceMFB(:,2,i),110,'g','filled','p');
    end
    plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
end

%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('MFB conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);
hold off

subplot(2,5,5)
hold on
for i=1:4
    plot(TrajPosMFB{i}(:,1),TrajPosMFB{i}(:,2));
end
plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Post MFB Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);
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
ylim(y_range_bar);
plot(ones(size(OccupPre,2)),100*OccupPre(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPre,2)),100*OccupPre(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);

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
ylim(y_range_bar);
plot(ones(size(OccupPAG,2)),100*OccupPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPAG,2)),100*OccupPAG(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

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
ylim(y_range_bar);
plot(ones(size(OccupPosPAG,2)),100*OccupPosPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPosPAG,2)),100*OccupPosPAG(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);

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
ylim(y_range_bar);
plot(ones(size(OccupMFB,2)),100*OccupMFB(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupMFB,2)),100*OccupMFB(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);


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
ylim(y_range_bar);
plot(ones(size(OccupPosMFB,2)),100*OccupPosMFB(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(size(OccupPosMFB,2)),100*OccupPosMFB(2,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);


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
ylim([0 30]);
title('Number of entries in shock zone during reversal experiment');

%% Number of Stimulations

figure
bar([1 2],[NumCondPAG NumCondMFB],'k')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('Number of PAG and MFB stimulations during reversal experiment');
ylim([0 100]);

text([1 2],[NumCondPAG NumCondMFB],num2str([NumCondPAG NumCondMFB]'),'vert','bottom','horiz','center','FontSize',10, 'FontWeight','bold')


%% Density map
TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);
TrajPosMFBCat = TrajPosMFBCat(all(~isnan(TrajPosMFBCat),2),:);

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
            pl=plot(TrajPre{i}(:,1),TrajPre{i}(:,2), 'w', 'linewidth',.05);
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
            pl=plot(TrajPosPAG{i}(:,1),TrajPosPAG{i}(:,2), 'w', 'linewidth',.05);
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
            pl=plot(TrajPosMFB{i}(:,1),TrajPosMFB{i}(:,2), 'w', 'linewidth',.05);
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

%% Speed trajectories
[xmin,xmax] = bounds(NewMask(:,2));
[ymin,ymax] = bounds(NewMask(:,1));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

figure
subplot(1,3,1)
hold on
for i=1:4
x = TrajPre{i}(:,1);  % X data
y = TrajPre{i}(:,2);  % Y data
z = SpeedPre{i};               

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
     'FaceColor', 'none', ...    % Don't bother filling faces with color
     'EdgeColor', 'interp', ...  % Use interpolated color for edges
     'LineWidth', 2);            % Make a thicker line
 
end
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlabel('Position X (cm)')
ylabel('Position Y (cm)')
title('Speed during Pre-tests')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(1,3,2)
hold on
for i=1:4
x = TrajPosPAG{i}(:,1);  % X data
y = TrajPosPAG{i}(:,2);  % Y data
z = SpeedPosPAG{i};               

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
     'FaceColor', 'none', ...    % Don't bother filling faces with color
     'EdgeColor', 'interp', ...  % Use interpolated color for edges
     'LineWidth', 2);            % Make a thicker line
 
end
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlabel('Position X (cm)')
ylabel('Position Y (cm)')
title('Speed during Post-PAG tests')

view(2);   % Default 2-D view
hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(1,3,3)
hold on
for i=1:4
x = TrajPosMFB{i}(:,1);  % X data
y = TrajPosMFB{i}(:,2);  % Y data
z = SpeedPosMFB{i};               

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
     'FaceColor', 'none', ...    % Don't bother filling faces with color
     'EdgeColor', 'interp', ...  % Use interpolated color for edges
     'LineWidth', 2);            % Make a thicker line
 
end
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlabel('Position X (cm)')
ylabel('Position Y (cm)')
title('Speed during Post-MFB tests')

view(2);   % Default 2-D view
hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);
%% Escape Latency

EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
EscapeWallShockPAGStd=nanstd(EscapeWallShockPAG);

EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
EscapeWallShockMFBStd=nanstd(EscapeWallShockMFB);

EscapeWallSafeMFBMean=nanmean(EscapeWallSafeMFB);
EscapeWallSafeMFBStd=nanstd(EscapeWallSafeMFB);

EscapeWallSafePAGMean=nanmean(EscapeWallSafePAG);
EscapeWallSafePAGStd=nanstd(EscapeWallSafePAG);

y_range=[0 60];

figure
subplot(2,2,1)
bar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],'k')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],[EscapeWallShockPAGStd EscapeWallShockMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallShockPAG)),EscapeWallShockPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallShockMFB)),EscapeWallShockMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);


ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency from Shock Zone');

subplot(2,2,2)
bar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],'k')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],[EscapeWallSafePAGStd EscapeWallSafeMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(EscapeWallSafePAG)),EscapeWallSafePAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(EscapeWallSafeMFB)),EscapeWallSafeMFB,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);


ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
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

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
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

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency During MFB Conditioning');

%% Compare Explorations

TrajExploPre = TrajExploPre(all(~isnan(TrajExploPre),2),:);
TrajExploPos = TrajExploPos(all(~isnan(TrajExploPos),2),:);



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
%         xlim([18 52])
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
ylim([0 30]);

subplot(2,2,4)
bar([1 2],100*[OccupExploPos(1) OccupExploPos(2)],'k')
set(gca,'xticklabel',{'Shock','Safe'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post-exploration');
ylim([0 30]);

