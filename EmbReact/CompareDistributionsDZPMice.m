cd /media/nas6/ProjetEmbReact/SB_Data

load('VarE.mat')
load('VarCond.mat')
clear AllHist
MouseToUse_DZP = [11205,11204,11189,11184,11147];
MouseToUse_Sal = [1205,1204,1189,1184,1147];
MiceID.SAL = VarE.MouseID(find(not(cellfun(@isempty,strfind(VarE.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarE.DrugType,'SALINE')))));
MouseToUse_SalE = MiceID.SAL(1:7);

for mouse = 1:length(MouseToUse_DZP)
    id = find(VarE.MouseID==MouseToUse_DZP(mouse));
    DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
    temp = VarE.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP(mouse,:) = Y/sum(Y);
    
    temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP_Sk(mouse,:) = Y/sum(Y);

    temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP_Sf(mouse,:) = Y/sum(Y);
    
    id = find(VarE.MouseID==MouseToUse_Sal(mouse));
    DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
    temp = VarE.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL(mouse,:) = Y/sum(Y);
    
       temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL_Sk(mouse,:) = Y/sum(Y);

    temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL_Sf(mouse,:) = Y/sum(Y);
    
    id = find(VarE.MouseID==MouseToUse_SalE(mouse));
    DiffAbs = abs(VarE.OB_WVFreq{id} - VarE.OB_PTFreq{id})<0.5;
    temp = VarE.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE(mouse,:) = Y/sum(Y);
    
    temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE_Sk(mouse,:) = Y/sum(Y);
    
    temp = VarE.OB_WVFreq{id}(DiffAbs & VarE.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE_Sf(mouse,:) = Y/sum(Y);
end
subplot(234)
plot([1:0.2:10],nanmean(AllHist_DZP))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL))
plot([1:0.2:10],nanmean(AllHist_SALE))
makepretty
legend('DZP','SAL','SALBefore')
title('All fz')
xlabel('OB frequency')

subplot(235)
plot([1:0.2:10],nanmean(AllHist_DZP_Sf))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL_Sf))
plot([1:0.2:10],nanmean(AllHist_SALE_Sf))
makepretty
legend('DZP','SAL','SALBefore')
title('Safe fz')
xlabel('OB frequency')

subplot(236)
plot([1:0.2:10],nanmean(AllHist_DZP_Sk))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL_Sk))
plot([1:0.2:10],nanmean(AllHist_SALE_Sk))
makepretty
legend('DZP','SAL','SALBefore')
title('Shock fz')
xlabel('OB frequency')




for mouse = 1:length(MouseToUse_DZP)
    id = find(VarCond.MouseID==MouseToUse_DZP(mouse));
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
    temp = VarCond.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP(mouse,:) = Y/sum(Y);
    
    temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP_Sk(mouse,:) = Y/sum(Y);

    temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_DZP_Sf(mouse,:) = Y/sum(Y);
    
    id = find(VarCond.MouseID==MouseToUse_Sal(mouse));
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
    temp = VarCond.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL(mouse,:) = Y/sum(Y);
    
       temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL_Sk(mouse,:) = Y/sum(Y);

    temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SAL_Sf(mouse,:) = Y/sum(Y);
    
    id = find(VarCond.MouseID==MouseToUse_SalE(mouse));
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})<0.5;
    temp = VarCond.OB_WVFreq{id}(DiffAbs);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE(mouse,:) = Y/sum(Y);
    
       temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}<0.3);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE_Sk(mouse,:) = Y/sum(Y);

    temp = VarCond.OB_WVFreq{id}(DiffAbs & VarCond.PosFz{id}>0.6);
    temp(temp<1.8) = [];
    temp(temp>9) = [];
    [Y,X] = hist(temp,[1:0.2:10]);
    AllHist_SALE_Sf(mouse,:) = Y/sum(Y);
end

subplot(231)
plot([1:0.2:10],nanmean(AllHist_DZP))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL))
plot([1:0.2:10],nanmean(AllHist_SALE))
makepretty
legend('DZP','SAL','SALBefore')
title('All fz')
xlabel('OB frequency')

subplot(232)
plot([1:0.2:10],nanmean(AllHist_DZP_Sf))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL_Sf))
plot([1:0.2:10],nanmean(AllHist_SALE_Sf))
makepretty
legend('DZP','SAL','SALBefore')
title('Safe fz')
xlabel('OB frequency')

subplot(233)
plot([1:0.2:10],nanmean(AllHist_DZP_Sk))
hold on
plot([1:0.2:10],nanmean(AllHist_SAL_Sk))
plot([1:0.2:10],nanmean(AllHist_SALE_Sk))
makepretty
legend('DZP','SAL','SALBefore')
title('Shock fz')
xlabel('OB frequency')
