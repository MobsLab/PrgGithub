clear all
clear Dir
Sessnames = {'TestPost_PostDrug'};
for d = 1
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 1:length(Dir{1}.path)-1
    try
        mouse
        VarTestPost.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarTestPost.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = Dir{d}.path{mouse};
        
        FreezeEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','freezeepoch');
%         ZoneEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','zoneepoch');
        LinPos = ConcatenateDataFromFolders_SB(AllPaths,'linearposition');
        
        ZoneEpoch{1} = thresholdIntervals(LinPos,0.3,'Direction','Below');
        ZoneEpoch{2} = thresholdIntervals(LinPos,0.7,'Direction','Above');
        ZoneEpoch{3} = thresholdIntervals(LinPos,0.45,'Direction','Below') -   ZoneEpoch{1};
        ZoneEpoch{4} = thresholdIntervals(LinPos,0.55,'Direction','Above') -   ZoneEpoch{2};
        ZoneEpoch{5} = (thresholdIntervals(LinPos,0.45,'Direction','Above') -  ZoneEpoch{2}) -  ZoneEpoch{4};
        
        % histogram of positions
        VarTestPost.LinPos(mouse,:) = hist(Data(LinPos),[0:0.1:1]);
        ZoneSkLarge = mergeCloseIntervals(or(ZoneEpoch{1},ZoneEpoch{3}),1E4);
        ZoneEpoch{6} = ZoneSkLarge;
        for z = 1:5
            VarTestPost.ZoneTime(mouse,z) = length(Data(Restrict(LinPos,ZoneEpoch{z})))./length(Data(LinPos));
            VarTestPost.ZoneAvTime(mouse,z) = nanmean(Stop(ZoneEpoch{z},'s') - Start(ZoneEpoch{z},'s'));
            VarTestPost.NumEntries(mouse,z) = length(Stop(ZoneEpoch{z},'s') - Start(ZoneEpoch{z},'s'));
        end
        % Transition probability
        % Center shock to shock
        [aft_cell,bef_cell]= transEpoch(ZoneEpoch{3},ZoneEpoch{1});
        [aft_cell2,bef_cell2]= transEpoch(ZoneEpoch{3},ZoneEpoch{5});
        CentSkToSk(mouse) = length(Start(aft_cell{1,2})) ./(length(Start(aft_cell{1,2}))+length(Start(aft_cell2{1,2})));
        
        % Center to center shock
        [aft_cell,bef_cell]= transEpoch(ZoneEpoch{5},ZoneEpoch{3});
        [aft_cell2,bef_cell2]= transEpoch(ZoneEpoch{5},ZoneEpoch{4});
        CentToCentSk(mouse) = length(Start(aft_cell{1,2})) ./(length(Start(aft_cell{1,2}))+length(Start(aft_cell2{1,2})));

        %     [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
% %Start(aft_cell{1,2}) ---> beginning of all SWS that is followed by Wake
% % Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
% %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
% %Start(aft_cell{2,1})---> beginning of all Wake  that is followed by SWS

        
        
    end
end

VarTestPost.DrugType{find(VarTestPost.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarTestPost.DrugType,'SALINE'))));
MiceID.MDZ = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'MDZ'))));
MiceID.MDZ(1) = [];
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarTestPost.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarTestPost.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.FlxAc(1) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarTestPost.MouseID(MiceID.SALLate)==1174) = [];


DrugTypes = {'SALLate','SALEarly','FlxCh','FlxAc','MDZ','DZP'};
for dtype = 1:length(DrugTypes)
disp(DrugTypes{dtype})
VarTestPost.MouseID(MiceID.(DrugTypes{dtype}))
end

figure
for dtype = 1:length(DrugTypes)
    
    subplot(length(DrugTypes),1,dtype)
    AllPos = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Pos = VarTestPost.LinPos(MiceID.(DrugTypes{dtype})(mm),:);
        AllPos = [AllPos;Pos/sum(Pos)];
    end
    plot([0:0.1:1],AllPos','color',[0.4 0.4 0.4])
    hold on
    plot([0:0.1:1],nanmean(AllPos),'k','linewidth',3)
    ylabel(DrugTypes{dtype})
    xlim([0 1]), ylim([0 1])
    xlabel('LinPos')
    Rem(dtype,:) = nanmean(AllPos);
end


clf
PlotLocation = [10,11,12;16,17,18;1,2,3;7,8,9;4,5,6];
for ZOI = 1:5
    for dtype = 1:length(DrugTypes)
        ShkTime{dtype} = VarTestPost.ZoneTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEp{dtype} = VarTestPost.ZoneAvTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEnter{dtype} = VarTestPost.NumEntries(MiceID.(DrugTypes{dtype}),ZOI);
        
    end
    
    subplot(2,9,PlotLocation(ZOI,1))
    PlotErrorBarN_KJ(ShkTime,'paired',0,'newfig',0)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Time spent in  zone')
    ylim([0 1])
    xtickangle(45)
    subplot(2,9,PlotLocation(ZOI,2))
    PlotErrorBarN_KJ(ShkEp,'paired',0,'newfig',0)
    set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
    ylabel('Duration of  zone episode')
    xtickangle(45)
    subplot(2,9,PlotLocation(ZOI,3))
    PlotErrorBarN_KJ(ShkEnter,'paired',0,'newfig',0)
    set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
    ylabel('Entries into  zone')
    xtickangle(45)
end


close all
ZoneName = {'shock','safe','centershock','centersafe','center'};

PlotLocation = [4,6,1,3,2];
for ZOI = 1:5
    for dtype = 1:length(DrugTypes)
        ShkTime{dtype} = VarTestPost.ZoneTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEp{dtype} = VarTestPost.ZoneAvTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEnter{dtype} = VarTestPost.NumEntries(MiceID.(DrugTypes{dtype}),ZOI);
        
    end
    Col = UMazeColors(ZoneName{ZOI});
    
    figure(1)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkTime,'paired',0,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Time spent in  zone')
    ylim([0 1])
    xtickangle(45)
    
    figure(2)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkEp,'paired',0,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Duration of  zone episode')
    xtickangle(45)
    
    figure(3)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkEnter,'paired',0,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Entries into  zone')
    xtickangle(45)
end


MiceID.DZPPair = (MiceID.DZP(1:end-1));
MiceID.SalPair = MiceID.SALLate([3,1,5,4,6,7]);
DrugTypes = {'SalPair','DZPPair'};
close all
ZoneName = {'shock','safe','centershock','centersafe','center'};
clear ShkEp ShkTime ShkEnter
PlotLocation = [4,6,1,3,2];
for ZOI = 1:5
    for dtype = 1:length(DrugTypes)
        ShkTime{dtype} = VarTestPost.ZoneTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEp{dtype} = VarTestPost.ZoneAvTime(MiceID.(DrugTypes{dtype}),ZOI);
        ShkEnter{dtype} = VarTestPost.NumEntries(MiceID.(DrugTypes{dtype}),ZOI);
        
    end
    Col = UMazeColors(ZoneName{ZOI});
    
    figure(1)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkTime,'paired',1,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Time spent in  zone')
    ylim([0 1])
    xtickangle(45)
    
    figure(2)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkEp,'paired',1,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Duration of  zone episode')
    xtickangle(45)
    
    figure(3)
    subplot(2,3,PlotLocation(ZOI))
    PlotErrorBarN_KJ(ShkEnter,'paired',1,'newfig',0,'barcolors',Col)
    set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
    ylabel('Entries into  zone')
    xtickangle(45)
end



MiceID.DZPPair = (MiceID.DZP(1:end-1));
MiceID.SalPair = MiceID.SALLate([3,1,5,4,6,7]);
DrugTypes = {'SalPair','DZPPair'};
close all
ZoneName = {'shock','safe','centershock','centersafe','center'};
clear ShkEp ShkTime ShkEnter
PlotLocation = [4,6,1,3,2];
for dtype = 1:length(DrugTypes)
    CentToCentSk_All{dtype} = CentToCentSk(MiceID.(DrugTypes{dtype}));
    CentSkToSk_All{dtype} = CentSkToSk(MiceID.(DrugTypes{dtype}));
    ToSkTransition{dtype} = CentToCentSk_All{dtype} +CentSkToSk_All{dtype};
end
Col = UMazeColors(ZoneName{1});

figure(1)
subplot(121)
PlotErrorBarN_KJ(CentToCentSk_All,'paired',1,'newfig',0,'barcolors',Col)
set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
ylabel('Proba center to center shock')
ylim([0 1])
xtickangle(45)

subplot(122)
PlotErrorBarN_KJ(CentSkToSk_All,'paired',1,'newfig',0,'barcolors',Col)
set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
ylabel('Proba center shock to shock')
xtickangle(45)

figure(1)
PlotErrorBarN_KJ(ToSkTransition,'paired',1,'newfig',0,'barcolors',Col)
set(gca,'XTick',1:length(DrugTypes),'XTickLabel',DrugTypes)
ylabel('Proba center to center shock')
ylim([0 1])
xtickangle(45)
