clear all
cd /media/nas6/ProjetEmbReact/SB_Data

load('VarE_V3.mat')
clear AllHist
MouseToUse_DZP = [11205,11204,11189,11184,11147,1200];
MouseToUse_Sal = [1205,1204,1189,1184,1147,11200,11206];

for mouse = 1:length(MouseToUse_DZP)
    id = find(VarE.MouseID==MouseToUse_DZP(mouse));
    DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
    temp = VarE.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP(mouse,:) = Y/sum(Y);
    
    id = find(VarE.MouseID==MouseToUse_Sal(mouse));
    DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
    temp = VarE.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL(mouse,:) = Y/sum(Y);
end
subplot(122)
plot([1:0.2:10],nanmean(AllHist_DZP),'b')
hold on
plot([1:0.2:10],nanmean(AllHist_SAL),'k')
makepretty
xlabel('Frequency')
legend('DZP','SAL')
title('Extinction')
cd /media/nas6/ProjetEmbReact/SB_Data

load('VarCond_V3.mat')
clear AllHist

for mouse = 1:length(MouseToUse_DZP)
    id = find(VarCond.MouseID==MouseToUse_DZP(mouse));
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
    temp = VarCond.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP(mouse,:) = Y/sum(Y);
    
        id = find(VarCond.MouseID==MouseToUse_Sal(mouse));
       DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
    temp = VarCond.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL(mouse,:) = Y/sum(Y);
end
subplot(121)
plot([1:0.2:10],nanmean(AllHist_DZP),'b')
hold on
plot([1:0.2:10],nanmean(AllHist_SAL),'k')
makepretty
xlabel('Frequency')
legend('DZP','SAL')
title('Cond')



%%
clear all
cd /media/nas6/ProjetEmbReact/SB_Data
figure
load('VarE_V3.mat')
load('VarCond_V3.mat')

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.MDZ = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'MDZ'))));
MiceID.MDZ(1) = [];
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.FlxAc(1) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];

% Extinction
clear AllHist
for mouse = 1:length(VarE.OB_WVFreq)
    temp = VarE.OB_WVFreq{mouse};
    tempSk = temp(VarE.PosFz{mouse}<0.5);
    tempSk(tempSk<1.8) = [];
    tempSk(tempSk>9) = [];
    [Y,X] = hist(tempSk,[1:0.2:10]);
    AllHist_Sk_E(mouse,:) = Y/sum(Y);
    
    tempSf = temp(VarE.PosFz{mouse}>0.5);
    tempSf(tempSf<1.8) = [];
    tempSf(tempSf>9) = [];
    [Y,X] = hist(tempSf,[1:0.2:10]);
    AllHist_Sf_E(mouse,:) = Y/sum(Y);
    
    temp = VarCond.OB_WVFreq{mouse};
    tempSk = temp(VarCond.PosFz{mouse}<0.5);
    tempSk(tempSk<1.8) = [];
    tempSk(tempSk>9) = [];
    [Y,X] = hist(tempSk,[1:0.2:10]);
    AllHist_Sk_C(mouse,:) = Y/sum(Y);
    
    tempSf = temp(VarCond.PosFz{mouse}>0.5);
    tempSf(tempSf<1.8) = [];
    tempSf(tempSf>9) = [];
    [Y,X] = hist(tempSf,[1:0.2:10]);
    AllHist_Sf_C(mouse,:) = Y/sum(Y);
end



DrugTypes = {'SALEarly','SALLate','FlxCh','FlxAc','MDZ','DZP'};
DrugTypes = {'SALEarly','SALLate','DZP'};
clf
for dtype = 1:length(DrugTypes)
    % Cond - safe
    subplot(221)
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        HistByDrug.(DrugTypes{dtype})(mm,:) = AllHist_Sf_C(MiceID.(DrugTypes{dtype})(mm),:);
    end
    plot(X,runmean(nanmean(HistByDrug.(DrugTypes{dtype})),1)),hold on
    
    % Cond - shock
    subplot(222)
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        HistByDrug.(DrugTypes{dtype})(mm,:) = AllHist_Sk_C(MiceID.(DrugTypes{dtype})(mm),:);
    end
    plot(X,runmean(nanmean(HistByDrug.(DrugTypes{dtype})),1)),hold on
    
    % Ext - safe
    subplot(223)
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        HistByDrug.(DrugTypes{dtype})(mm,:) = AllHist_Sf_E(MiceID.(DrugTypes{dtype})(mm),:);
    end
    plot(X,runmean(nanmean(HistByDrug.(DrugTypes{dtype})),1)),hold on
    
    % Ext shock
    subplot(224)
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        HistByDrug.(DrugTypes{dtype})(mm,:) = AllHist_Sk_E(MiceID.(DrugTypes{dtype})(mm),:);
    end
    plot(X,runmean(nanmean(HistByDrug.(DrugTypes{dtype})),1)),hold on
    
    
end
Titres = {'Cond safe','Cond - shock','Ext safe', 'Ext shock'}
for i = 1:4
    subplot(2,2,i)
    makepretty
    legend(DrugTypes)
    title(Titres{i})
end
