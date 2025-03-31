load('/home/gruffalo/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_30112023.mat')
% load DATA that contains all mice's data 
%Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

Mouse_ALL = [688 739 777 849 893 1171 9184 1189 1391 1392 1394];
MiceNumber = length(Mouse_ALL);

%load data
for i=1:length(Mouse_ALL)
    Mice{i}=['M' num2str(Mouse_ALL(i))];
    OneMouseData = DATA.(Mice{i});
    OneMouseTable = array2table(OneMouseData, 'VariableNames', {'OB_FrequencyArray', 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber'});
    PositionArray.(Mice{i}) = OneMouseTable.PositionArray';
    OB_FrequencyArray.(Mice{i}) = OneMouseTable.OB_FrequencyArray';
    GlobalTimeArray.(Mice{i}) = OneMouseTable.GlobalTimeArray';
    TimeSinceLastShockArray.(Mice{i}) = OneMouseTable.TimeSinceLastShockArray';
    TimeSpentFreezing.(Mice{i}) = OneMouseTable.TimeSpentFreezing';
    CumulTimeSpentFreezing.(Mice{i}) = OneMouseTable.CumulTimeSpentFreezing';
    EyelidNumber.(Mice{i}) = OneMouseTable.EyelidNumber';

end 

Best_Fitted_variables.INT8.LearnSlope = [0.0070 0.0100 0.0065 0.0020 0.0060 1.0000e-03 0.0100 0.0015 0.0020 0.0055 0.0100];
Best_Fitted_variables.INT8.LearnPoint = [0.2000 0.8000 0.6000 0.4000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000];

% INT8
Fit8varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit8SigGlocalTime', 'OB_FrequencyArray'};
for i=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mice{i}));
    SigPositionArray.(Mice{i}) = 1./(1+exp(-20*([PositionArray.(Mice{i})]-0.5)));
    Fit8SigGlobalTimeArray.(Mice{i}) = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(i)*([GlobalTimeArray.(Mice{i})]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(i)))));
    Fit8_GLMArray_mouse.(Mice{i}) = table( PositionArray.(Mice{i})', ...
        GlobalTimeArray.(Mice{i})', TimeSinceLastShockArray.(Mice{i})', CumulTimeSpentFreezing.(Mice{i})',...
        (SigPositionArray.(Mice{i})').*(TimeSinceLastShockArray.(Mice{i})'), ...
        (SigPositionArray.(Mice{i})').*(Fit8SigGlobalTimeArray.(Mice{i})'), ...
        OB_FrequencyArray.(Mice{i})', 'VariableNames',Fit8varNames);
    Fit8_GLMArray_mouse.(Mice{i}) = rmmissing(Fit8_GLMArray_mouse.(Mice{i}), 1);
end 


for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit8.(Mice{mousenum}) = cvpartition(size(Fit8_GLMArray_mouse.(Mice{mousenum}),1),...
        'KFold', size(Fit8_GLMArray_mouse.(Mice{mousenum}),1)); 
    
    clear tbl
    tbl=Fit8_GLMArray_mouse.(Mice{mousenum});
    indset=1;
    for i=1:size(Fit8_GLMArray_mouse.(Mice{mousenum}),1)
        ind_Train_mouse.Fit8.(Mice{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit8.(Mice{mousenum}),i);
        Array_Train.Fit8.(Mice{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit8.(Mice{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit8.(Mice{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit8.(Mice{mousenum}), i);
        Array_Test.Fit8.(Mice{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit8.(Mice{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit8.(Mice{mousenum}).Trainset,2)
        Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit8.(Mice{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit8.(Mice{mousenum}).Value(indset,:) = table2array(Array_Test.Fit8.(Mice{mousenum}).Testset(:,indset).table(:,7));
        [Test_mdl.Fit8.(Mice{mousenum}).Value(indset,:), Test_mdl.Fit8.(Mice{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit8.(Mice{mousenum}).Trainset(:,indset).table,Array_Test.Fit8.(Mice{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

%INT8_id
Fit8_idvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit8SigGlocalTime', 'OB_FrequencyArray'};
for i=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mice{i}));
    SigPositionArray.(Mice{i}) = 1./(1+exp(-20*([PositionArray.(Mice{i})]-0.5)));
    Fit8_idSigGlobalTimeArray.(Mice{i}) = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(i)*([GlobalTimeArray.(Mice{i})]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(i)))));
    Fit8_id_GLMArray_mouse.(Mice{i}) = table( PositionArray.(Mice{i})', ...
        GlobalTimeArray.(Mice{i})', TimeSinceLastShockArray.(Mice{i})', CumulTimeSpentFreezing.(Mice{i})',...
        (SigPositionArray.(Mice{i})').*(TimeSinceLastShockArray.(Mice{i})'), ...
        (SigPositionArray.(Mice{i})').*(Fit8_idSigGlobalTimeArray.(Mice{i})'), ...
        OB_FrequencyArray.(Mice{i})', 'VariableNames',Fit8_idvarNames);
    Fit8_id_GLMArray_mouse.(Mice{i}) = rmmissing(Fit8_id_GLMArray_mouse.(Mice{i}), 1);
end 


for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit8_id.(Mice{mousenum}) = cvpartition(size(Fit8_id_GLMArray_mouse.(Mice{mousenum}),1),...
        'KFold', size(Fit8_id_GLMArray_mouse.(Mice{mousenum}),1)); 
    
    clear tbl
    tbl=Fit8_id_GLMArray_mouse.(Mice{mousenum});
    indset=1;
    for i=1:size(Fit8_id_GLMArray_mouse.(Mice{mousenum}),1)
        ind_Train_mouse.Fit8_id.(Mice{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit8_id.(Mice{mousenum}),i);
        Array_Train.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit8_id.(Mice{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit8_id.(Mice{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit8_id.(Mice{mousenum}), i);
        Array_Test.Fit8_id.(Mice{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit8_id.(Mice{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit8_id.(Mice{mousenum}).Trainset,2)
        Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'identity');
        Output_GLM.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit8_id.(Mice{mousenum}).Value(indset,:) = table2array(Array_Test.Fit8_id.(Mice{mousenum}).Testset(:,indset).table(:,7));
        [Test_mdl.Fit8_id.(Mice{mousenum}).Value(indset,:), Test_mdl.Fit8_id.(Mice{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(:,indset).table,Array_Test.Fit8_id.(Mice{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end


for mousenum=1:length(Mouse_ALL)
    lenMousetrainset = length(Train_mdl.Fit8.(Mice{mousenum}).Trainset);
    for i=1:lenMousetrainset
        Rcarres.Fit8.(Mice{mousenum})(i) = Train_mdl.Fit8.(Mice{mousenum}).Trainset(i).table.Rsquared.Ordinary;
    end
    PlotRcarres.Fit8(mousenum) = mean(Rcarres.Fit8.(Mice{mousenum}));
end
   
for mousenum=1:length(Mouse_ALL)
    lenMousetrainset = length(Train_mdl.Fit8.(Mice{mousenum}).Trainset);
    for i=1:lenMousetrainsetFit8_idvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit8SigGlocalTime', 'OB_FrequencyArray'};

        Rcarres.Fit8_id.(Mice{mousenum})(i) = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(i).table.Rsquared.Ordinary;
    end
    PlotRcarres.Fit8_id(mousenum) = mean(Rcarres.Fit8_id.(Mice{mousenum}));
end

figure;
MakeSpreadAndBoxPlot3_ECSB({PlotRcarres.Fit8, PlotRcarres.Fit8_id}, {[0.8 0.2 0.2]  [.4,.6,.8]}, [1 2],{'R2 Fit8', 'R2 Fit8 id'},'paired',1,'showpoints',0)
xlim([0.5,2.5])
text(1,1,num2str(median(PlotRcarres.Fit8)))
text(2,1,num2str(median(PlotRcarres.Fit8_id)))


for mousenum=1:length(Mouse_ALL)
    TableauBeta(mousenum,2:7) = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(mousenum).table.Coefficients.Estimate(2:7).*max(table2array(Train_mdl.Fit8_id.M688.Trainset(1).table.Variables(:,1:6)))';
%     TableauSE(mousenum,:) = Train_mdl.Fit8_id.(Mice{mousenum}).Trainset(mousenum).table.Coefficients.SE;
end 


model = Train_mdl.Fit8_id.M688.Trainset(1).table;
coefs = model.Coefficients.Estimate;
dataAggrege = [ones(model.NumObservations,1) model.Variables{:,1:6}];

for icoef=1:length(coefs)
    ProportionBetaX(:,icoef) = dataAggrege(:,icoef)*coefs(icoef)./model.Fitted.Response;
end

figure;
MakeSpreadAndBoxPlot3_ECSB({ProportionBetaX(1:20:end,1), ProportionBetaX(1:20:end,2),ProportionBetaX(1:20:end,3),ProportionBetaX(1:20:end,4),...
    ProportionBetaX(1:20:end,5), ProportionBetaX(1:20:end,6), ProportionBetaX(1:20:end,7)},...
    {[0.8 0.2 0.2],[0.2 0.8 0.2],[0.2 0.2 0.8],[0.5 0.5 0.2],[0.2 0.5 0.5],[0.5 0.2 0.5],[0.5 0.5 0.5]},...
    [1 2 3 4 5 6 7],{'Constant', 'Pos', 'GT', 'TSLS','CTF','SigPosxTSLS', 'SIgPosxSigGT'},'paired',1,'showpoints',0, 'showsigstar', 'none')
xlim([0.5,7.5])
ylim([-3,4])

figure;
plot(ProportionBetaX(:,3), ProportionBetaX(:,5))

%calcul du R2 des valeurs prédites par la cross val 
y = Train_mdl.Fit8.M688.Trainset(1).table.Variables.OB_FrequencyArray;
ypred = Train_mdl.Fit8.M688.Trainset(1).table.Fitted.Response;
RsTest = 1 - sum((y - ypred).^2)/sum((y - mean(y)).^2);



models_table = Train_mdl.Fit8.M688.Trainset;
for i=1:model.NumObservations
   for j=i:model.NumObservations
         
        DistancesModels(i,j) = DistanceModel(models_table(i),models_table(j));
        
   end
   if mod(i,10) == 0
       disp(i)
   end
end
for i=1:model.NumObservations
   for j=i:model.NumObservations
       DistancesModels(j,i) = DistancesModels(i,j);
   end
end
DistMod.max = max(DistancesModels);
DistMod.min = min(DistancesModels);
DistMod.mean = mean(DistancesModels);
DistMod.median = median(DistancesModels);
DistMod.meanmean = mean(mean(DistancesModels));

figure;
plotSlice(model)

figure;
plotSlice(linear_mdl)
ylim([0 10])

figure; plotDiagnostics(linear_mdl)
figure; plotResiduals(linear_mdl)


plotPredictionVSReal(table2array(Array_Train.Fit8_id.(Mice{1}).Trainset(1).table(:,7)), ...
    table2array(Output_GLM.Train_mdl.Fit8_id.(Mice{1}).Trainset(1).table.Fitted(:,1)), ...
    table2array(Array_Train.Fit8_id.(Mice{1}).Trainset(1).table(:,1)))


figure;
plot(OneMouseTable.GlobalTimeArray, OneMouseTable.CumulTimeSpentFreezing, 'x'), hold on 
plot(OneMouseTable.GlobalTimeArray, OneMouseTable.GlobalTimeArray)



Best_Fitted_variables.INT8.LearnSlope = [0.0070 0.0100 0.0065 0.0020 0.0060 1.0000e-03 0.0100 0.0015 0.0020 0.0055 0.0100];
Best_Fitted_variables.INT8.LearnPoint = [0.2000 0.8000 0.6000 0.4000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000];

Mice = fieldnames(TotalArray_mouse);
MiceNumber = length(Mice);

global DATAtable Models
%Model fitted on all data 
for i = 1:MiceNumber
    OneMouseData = TotalArray_mouse.(Mice{i});
    DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_FrequencyArray', 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesDensity'}); 
    DATAtable.(Mice{i}) = rmmissing(DATAtable.(Mice{i}));
end

Fit8_idvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
for i = 1:MiceNumber
    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTimeArray);
    DATAtable.(Mice{i}).SigPositionArray = 1./(1+exp(-20*([DATAtable.(Mice{i}).PositionArray]-0.5)));
    DATAtable.(Mice{i}).SigGlobalTimeLearned = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(i)*([DATAtable.(Mice{i}).GlobalTimeArray]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(i)))));
    ConcatenateData = table( DATAtable.(Mice{i}).PositionArray, ...
        DATAtable.(Mice{i}).GlobalTimeArray, DATAtable.(Mice{i}).TimeSinceLastShockArray, DATAtable.(Mice{i}).CumulTimeSpentFreezing,...
        (DATAtable.(Mice{i}).SigPositionArray).*(DATAtable.(Mice{i}).TimeSinceLastShockArray), ...
        (DATAtable.(Mice{i}).SigPositionArray).*(DATAtable.(Mice{i}).SigGlobalTimeLearned), ...
        DATAtable.(Mice{i}).OB_FrequencyArray, 'VariableNames',Fit8_idvarNames);
    Models.Fit8_id.(Mice{i}) = fitglm(ConcatenateData,...
                'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'identity');
end

plotPredictionVSReal(DATAtable.(Mice{1}).OB_FrequencyArray, Models.Fit8_id.(Mice{1}).Fitted{:,1}, ...
    DATAtable.(Mice{1}).PositionArray);


%Load initial data 
for i=1:length(Mouse_ALL)
    Mice{i}=['M' num2str(Mouse_ALL(i))];
    OneMouseData = DATA.(Mice{i});
    DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_FrequencyArray', 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber'}); 
    DATAtable.(Mice{i}) = rmmissing(DATAtable.(Mice{i}));
end

%Enrichissement des données 
for i = 1:MiceNumber
    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTimeArray);
    DATAtable.(Mice{i}).SigPositionArray = 1./(1+exp(-20*([DATAtable.(Mice{i}).PositionArray]-0.5)));
    DATAtable.(Mice{i}).SigGlobalTimeLearned = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(i)*([DATAtable.(Mice{i}).GlobalTimeArray]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(i)))));
    DATAtable.(Mice{i}).SigPositionxSigGlobalTimeLearned =  DATAtable.(Mice{i}).SigPositionArray.*DATAtable.(Mice{i}).SigGlobalTimeLearned;
    DATAtable.(Mice{i}).SigPositionxTimeSinceLastShock = DATAtable.(Mice{i}).SigPositionArray.*DATAtable.(Mice{i}).TimeSinceLastShockArray;
end   

ListCorr.Global = zeros(width(DATAtable.(Mice{i})));
for i = 1:MiceNumber
    ListCorr.(Mice{i}) = abs(corrcoef(table2array(DATAtable.(Mice{i}))));
    figure;
    imagesc(ListCorr.(Mice{i}))
    title(Mice{i})
    xticks(1:width(DATAtable.(Mice{i})))
    xticklabels(DATAtable.(Mice{i}).Properties.VariableNames)
    xtickangle(45)
    yticks(1:width(DATAtable.(Mice{i})))
    yticklabels(DATAtable.(Mice{i}).Properties.VariableNames)
    ListCorr.Global = ListCorr.Global + ListCorr.(Mice{i});
end
ListCorr.Global = array2table(ListCorr.Global, 'VariableNames', DATAtable.(Mice{i}).Properties.VariableNames);

figure;
imagesc(table2array(ListCorr.Global))
colorbar
title("Mean of all mice")
xticks(1:width(DATAtable.(Mice{i})))
xticklabels(DATAtable.(Mice{i}).Properties.VariableNames)
xtickangle(45)
yticks(1:width(DATAtable.(Mice{i})))
yticklabels(DATAtable.(Mice{i}).Properties.VariableNames)


%ListCorrCorrected.Global = removevars(ListCorr.Global, {'CumulTimeSpentFreezing', 'EyelidNumber'});
PredToRemove = {'CumulTimeSpentFreezing', 'EyelidNumber', 'SigPositionArray', 'SigGlobalTimeLearned'};
ListCorrCorrected.Global = ListCorr.Global;
for i = 1:length(PredToRemove)
    index = find(strcmp(PredToRemove(i), ListCorrCorrected.Global.Properties.VariableNames), 1);
    ListCorrCorrected.Global(:, index) = [];
    ListCorrCorrected.Global(index, :) = [];
end
figure;
imagesc(table2array(ListCorrCorrected.Global))
colorbar
title("Mean of all mice CORRECTED")
xticks(1:width(ListCorrCorrected.Global))
xticklabels(ListCorrCorrected.Global.Properties.VariableNames)
xtickangle(45)
yticks(1:width(ListCorrCorrected.Global))
yticklabels(ListCorrCorrected.Global.Properties.VariableNames)

KeptPredictors = ListCorrCorrect.Gloabl.Properties.VariableNames;


for i=1:MiceNumber
    figure;
    plot(Models.Fit8_id.(Mice{i}).Variables.PositionArray, Models.Fit8_id.(Mice{i}).Variables.OB_FrequencyArray, 'x')
end 