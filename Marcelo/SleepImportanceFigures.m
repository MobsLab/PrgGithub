%% Get Data
clear all
MouseNumber = 938; %Enter the mouse number: 863, 913, 934, 935 or 938
FracArea = 0.85;

if MouseNumber == 863
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPre_00/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPre_01/cleanBehavResources.mat')
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


    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPre_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPre_03/cleanBehavResources.mat')
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
    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPost_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPost_03/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPost_04/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-TestPost_05/cleanBehavResources.mat')
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


    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M863/20190520/SleepImport/ERC-Mouse-863-20052019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    
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

if MouseNumber == 913
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPre_00/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPre_01/cleanBehavResources.mat')
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


    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPre_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPre_03/cleanBehavResources.mat')
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
    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPost_01/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPost_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPost_03/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-TestPost_04/cleanBehavResources.mat')
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


    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M913/20190521/SleepImport/ERC-Mouse-913-21052019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    
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

if MouseNumber == 934
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPre_00/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPre_01/cleanBehavResources.mat')
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


    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPre_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPre_03/cleanBehavResources.mat')
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
    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPost_01/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPost_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPost_03/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-TestPost_04/cleanBehavResources.mat')
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


    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M934/20190531/SleepImport/ERC-Mouse-934-31052019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    
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

if MouseNumber == 935
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPre_00/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPre_01/cleanBehavResources.mat')
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


    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPre_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPre_03/cleanBehavResources.mat')
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
    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPost_01/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPost_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPost_03/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-TestPost_04/cleanBehavResources.mat')
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


    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M935/20190603/SleepImport/ERC-Mouse-935-03062019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    
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

if MouseNumber == 938
        % Pre-tests
    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPre_00/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPre_01/cleanBehavResources.mat')
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


    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPre_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPre_03/cleanBehavResources.mat')
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
    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPost_01/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPost_02/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPost_03/cleanBehavResources.mat')
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

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-TestPost_04/cleanBehavResources.mat')
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


    % PAG conditioning
    NumCondPAG=0;

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-Cond_00/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,1)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,1)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,1)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-Cond_01/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,3)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,3)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,3)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);

    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-Cond_02/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,4)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);


    load('/media/vador/DataMOBS104/Marcelo/M938/SleepImport/ERC-Mouse-938-06062019-Cond_03/cleanBehavResources.mat')
    Events=CleanPosMatInit(:,4);
    Events(isnan(Events)) = 0;
    NumCondPAG = NumCondPAG +length(find(Events));

    OccupPAG(:,5)=Occup;
    TrajPAG(1:size(CleanPosMatInit,1),:,4)=CleanPosMatInit(:,[2,3]);
    ShockPlacePAG(1:length(find(CleanPosMatInit(:,4) == 1)),:,4)=CleanPosMatInit(find(CleanPosMatInit(:,4) == 1),[2,3]);
    
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
%% Plots Shock zone occupancy during sleep importance experiments

OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);


OccupLabels={'Pre-test';'Post PAG'};


figure
bar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],100*[OccupPreStd(1) OccupPosPAGStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(size(OccupPre,2)),100*OccupPre(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(size(OccupPosPAG,2)),100*OccupPosPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Shock zone occupancy during sleep importance experiment');
%% First time to enter shock zone plot 
for i=1:4
    FirstTimeShockPre(i)=TimePre(IndFirstTimeShockPre(i),i);
    FirstTimeShockPosPAG(i)=TimePosPAG(IndFirstTimeShockPosPAG(i),i);
end

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreStd=std(FirstTimeShockPre);
FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGStd=std(FirstTimeShockPosPAG);

OccupLabels={'Pre-test';'Post PAG'};


figure
bar([1 2],[FirstTimeShockPreMean FirstTimeShockPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],[FirstTimeShockPreMean FirstTimeShockPosPAGMean],[FirstTimeShockPreStd FirstTimeShockPosPAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(FirstTimeShockPre)),FirstTimeShockPre,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(FirstTimeShockPosPAG)),FirstTimeShockPosPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in sleep importance experiment');



%% Compare Trajectories



OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPAGMean=mean(OccupPAG,2);
OccupPAGStd=std(OccupPAG,0,2);

[xmin,xmax] = bounds(NewMask(:,2));
[ymin,ymax] = bounds(NewMask(:,1));

y_range=[ymin-3 ymax+3];
x_range=[xmin-6 xmax+3];

y_range_bar = [0 100];

OccupLabels={'Pre-test';'PAG';'Post PAG'};


figure

set(gcf,'DefaultLineLineWidth',1)
set(gca,'FontWeight','bold')

subplot(2,3,1)
hold on
for i=1:4
    plot(TrajPre{i}(:,1),TrajPre{i}(:,2));
end
% plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Pre Test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);

hold off

subplot(2,3,2)
hold on

TrajPAG(TrajPAG == 0) = NaN;

for i=1:4
    plot(TrajPAG(:,1,i),TrajPAG(:,2,i));
    scatter(ShockPlacePAG(:,1,i),ShockPlacePAG(:,2,i),110,'r','filled','p');
end
% plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
    
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PAG conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);
hold off


subplot(2,3,3)
hold on
for i=1:4
    plot(TrajPosPAG{i}(:,1),TrajPosPAG{i}(:,2));
end
% plot(NewMask(:,2),NewMask(:,1),'k','LineWidth',2)
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

OccupLabels_2={'Shock';'Safe'};

subplot(2,3,4)

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

subplot(2,3,5)

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


subplot(2,3,6)

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

%% Speed

SpeedShockPreMean=nanmean(SpeedShockPre);
SpeedShockPreStd=nanstd(SpeedShockPre);

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreStd=nanstd(SpeedSafePre);

SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
SpeedShockPosPAGStd=nanstd(SpeedShockPosPAG);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGStd=nanstd(SpeedSafePosPAG);

figure

subplot(2,3,1)
bar([1 2],[SpeedShockPreMean SpeedShockPosPAGMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1 2],[SpeedShockPreMean SpeedShockPosPAGMean],[SpeedShockPreStd SpeedShockPosPAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during sleep importance experiment');
ylim([0 15]);

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,3,2)
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


subplot(2,3,3)
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

%% Number of entries in shock zone

NumEntPreMean=mean(NumEntPre);
NumEntPreStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGStd=std(NumEntPosPAG);

OccupLabels={'Pre-test';'Post PAG'};

figure
bar([1 2],[NumEntPreMean NumEntPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[NumEntPreMean NumEntPosPAGMean],[NumEntPreStd NumEntPosPAGStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(length(NumEntPre)),NumEntPre,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(length(NumEntPosPAG)),NumEntPosPAG,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 5]);
title('Number of entries in shock zone during sleep importance experiment');

%% Density map
TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);
figure
subplot(1,2,1)
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
        
        subplot(1,2,2)
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
        

%% Speed trajectories
[xmin,xmax] = bounds(NewMask(:,2));
[ymin,ymax] = bounds(NewMask(:,1));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

figure
subplot(1,2,1)
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

subplot(1,2,2)
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



%% Save Data for avereges
MouseData =[];
struct(MouseData);

%Occupancies

MouseData.MouseName = ['M' num2str(MouseNumber)];
MouseData.OccupPreMean=mean(OccupPre,2);
MouseData.OccupPreStd=std(OccupPre,0,2);

MouseData.OccupPosPAGMean=mean(OccupPosPAG,2);
MouseData.OccupPosPAGStd=std(OccupPosPAG,0,2);

MouseData.OccupPAGMean=mean(OccupPAG,2);
MouseData.OccupPAGStd=std(OccupPAG,0,2);


% Number of entries

MouseData.NumEntPreMean=mean(NumEntPre);
MouseData.NumEntPreStd=std(NumEntPre);

MouseData.NumEntPosPAGMean=mean(NumEntPosPAG);
MouseData.NumEntPosPAGStd=std(NumEntPosPAG);

% Number of stimulations

MouseData.NumCondPAG = NumCondPAG;

% First time to enter shock zone
for i=1:4
    FirstTimeShockPre(i)=TimePre(IndFirstTimeShockPre(i),i);
    FirstTimeShockPosPAG(i)=TimePosPAG(IndFirstTimeShockPosPAG(i),i);
end

MouseData.FirstTimeShockPreMean=mean(FirstTimeShockPre);
MouseData.FirstTimeShockPreStd=std(FirstTimeShockPre);
MouseData.FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
MouseData.FirstTimeShockPosPAGStd=std(FirstTimeShockPosPAG);

% Speed

MouseData.SpeedShockPreMean=nanmean(SpeedShockPre);
MouseData.SpeedShockPreStd=nanstd(SpeedShockPre);

MouseData.SpeedSafePreMean=nanmean(SpeedSafePre);
MouseData.SpeedSafePreStd=nanstd(SpeedSafePre);

MouseData.SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
MouseData.SpeedShockPosPAGStd=nanstd(SpeedShockPosPAG);

MouseData.SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
MouseData.SpeedSafePosPAGStd=nanstd(SpeedSafePosPAG);

save(['/home/vador/Documents/Marcelo/Results/SleepImportance/SingleMiceData/' 'M' num2str(MouseNumber) '.mat'],'MouseData')