close all
cd /media/nas6/ProjetEmbReact/SB_Data
load('VarE-Clean.mat')
load('VarEFirst-Clean.mat')
load('VarCond-Clean.mat')

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];

DrugTypes = {'SALEarly','FlxCh','FlxAc','SALLate','DZP'};
DrugTypes = {'SALEarly','FlxCh','FlxAc'};
DrugTypes = {'SALEarly','SALLate','DZP'};

%% Get histograms
figure
for dtype = 1:length(DrugTypes)
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
        id = MiceID.(DrugTypes{dtype})(mouse);
        DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
        %         temp = VarCond.OB_WVFreq{id}(DiffAbs);
        temp = median([VarCond.OB_WVFreq{id}(DiffAbs),VarCond.OB_PTFreq{id}(DiffAbs)]');
        temp(temp<1.8) = [];
        temp(temp>9) = [];
        [Y,X] = hist(temp,[1:0.2:10]);
        AllHist.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
    end
end

subplot(311)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHist.(DrugTypes{dtype})),1)),hold on
end
makepretty
legend(DrugTypes)
title('Cond')

for dtype = 1:length(DrugTypes)
    
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
        id = MiceID.(DrugTypes{dtype})(mouse);
        DiffAbs = abs(VarEFirst.OB_WVFreq{id} - VarEFirst.OB_PTFreq{id})<0.5;
        %         temp = VarEFirst.OB_WVFreq{id}(DiffAbs);
        temp = median([VarEFirst.OB_WVFreq{id}(DiffAbs),VarEFirst.OB_PTFreq{id}(DiffAbs)]');
        temp(temp<1.8) = [];
        temp(temp>9) = [];
        [Y,X] = hist(temp,[1:0.2:10]);
        AllHist.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
    end
end

subplot(312)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHist.(DrugTypes{dtype})),1)),hold on
end
makepretty
legend(DrugTypes)
title('Ext first')


for dtype = 1:length(DrugTypes)
    
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
        id = MiceID.(DrugTypes{dtype})(mouse);
        DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
        %         temp = VarE.OB_WVFreq{id}(DiffAbs);
        temp = median([VarE.OB_WVFreq{id}(DiffAbs),VarE.OB_PTFreq{id}(DiffAbs)]');
        temp(temp<1.8) = [];
        temp(temp>9) = [];
        [Y,X] = hist(temp,[1:0.2:10]);
        AllHist.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
    end
end

subplot(313)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHist.(DrugTypes{dtype})),1)),hold on
end
makepretty
legend(DrugTypes)
title('Ext')

%% Separate shock and safe
figure

for dtype = 1:length(DrugTypes)
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
        id = MiceID.(DrugTypes{dtype})(mouse);
        DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
        %         temp = VarCond.OB_WVFreq{id}(DiffAbs);
        temp = median([VarCond.OB_WVFreq{id}(DiffAbs),VarCond.OB_PTFreq{id}(DiffAbs)]');
        tempSk = temp(VarCond.PosFz{id}(DiffAbs)<0.2);
        tempSk(tempSk<1.8) = [];
        tempSk(tempSk>9) = [];
        [Y,X] = hist(tempSk,[1:0.2:10]);
        AllHistSk.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
        
        tempSf = temp(VarCond.PosFz{id}(DiffAbs)>0.8);
        tempSf(tempSf<1.8) = [];
        tempSf(tempSf>9) = [];
        [Y,X] = hist(tempSf,[1:0.2:10]);
        AllHistSf.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);

    end
end

subplot(3,2,1)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSk.(DrugTypes{dtype})),1)),hold on
end
makepretty
title('Cond - Shock')

subplot(3,2,2)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSf.(DrugTypes{dtype})),1)),hold on
end
makepretty
legend(DrugTypes)
title('Cond - Safe')

for dtype = 1:length(DrugTypes)
    
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
     id = MiceID.(DrugTypes{dtype})(mouse);
        DiffAbs = abs(VarEFirst.OB_WVFreq{id} - VarEFirst.OB_PTFreq{id})<0.5;
        %         temp = VarCond.OB_WVFreq{id}(DiffAbs);
        temp = median([VarEFirst.OB_WVFreq{id}(DiffAbs),VarEFirst.OB_PTFreq{id}(DiffAbs)]');
        tempSk = temp(VarEFirst.PosFz{id}(DiffAbs)<0.2);
        tempSk(tempSk<1.8) = [];
        tempSk(tempSk>9) = [];
        [Y,X] = hist(tempSk,[1:0.2:10]);
        AllHistSk.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
        
        tempSf = temp(VarEFirst.PosFz{id}(DiffAbs)>0.8);
        tempSf(tempSf<1.8) = [];
        tempSf(tempSf>9) = [];
        [Y,X] = hist(tempSf,[1:0.2:10]);
        AllHistSf.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);

    end
end

subplot(3,2,3)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSk.(DrugTypes{dtype})),1)),hold on
end
makepretty
title('ExtFirst - Shock')

subplot(3,2,4)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSf.(DrugTypes{dtype})),1)),hold on
end
makepretty
title('ExtFirst - Safe')

for dtype = 1:length(DrugTypes)
    
    for mouse = 1:length(MiceID.(DrugTypes{dtype}))
           id = MiceID.(DrugTypes{dtype})(mouse);
 DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
        %         temp = VarCond.OB_WVFreq{id}(DiffAbs);
        temp = median([VarE.OB_WVFreq{id}(DiffAbs),VarE.OB_PTFreq{id}(DiffAbs)]');
        tempSk = temp(VarE.PosFz{id}(DiffAbs)<0.2);
        tempSk(tempSk<1.8) = [];
        tempSk(tempSk>9) = [];
        [Y,X] = hist(tempSk,[1:0.2:10]);
        AllHistSk.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
        
        tempSf = temp(VarE.PosFz{id}(DiffAbs)>0.8);
        tempSf(tempSf<1.8) = [];
        tempSf(tempSf>9) = [];
        [Y,X] = hist(tempSf,[1:0.2:10]);
        AllHistSf.(DrugTypes{dtype})(mouse,:) = Y/sum(Y);
    end
end

subplot(3,2,5)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSk.(DrugTypes{dtype})),1)),hold on
end
makepretty
title('Ext - Shock')

subplot(3,2,6)
for dtype = 1:length(DrugTypes)
    hold on
    plot(X,runmean(nanmean(AllHistSf.(DrugTypes{dtype})),1)),hold on
end
makepretty
title('Ext - Safe')