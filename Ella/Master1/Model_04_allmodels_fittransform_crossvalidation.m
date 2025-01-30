%% Objectives of the code

% Create the GLM arrays of all the tested models with the 
%%% fitted parameters for each transformation 

% Cross validation of the GLMs (K-Fold)

% Extract the R2 deviance on train and compute the classical R2 on train
% and test sets for a randomly chosen GLM for each model

% Report figures part III (pvalues of predictors, comparison of R2)

% Parameters of the Sig transformation and predictors in FIT8 model
% extracted with a lasso regression 

%% Run the models for the selected mice
% We removed mice that have not learned (1393 spends 25% of her time
% in the shock zone in post cond) or that have freezed less than 40s (779,1170, 9205)
Mouse_ALL=[688 739 777 849 893 1171 9184 1189 1391 1392 1394];

%% Generate data for all mice that have learned (from Data_For_Model_BM.m)
Session_type={'Cond'};
for sess=1:length(Session_type)% generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end

for mousenum=1:length(Mouse_ALL);
    Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    i=1;
    clear ep ind_to_use
    
    for ep=1:length(Start(Epoch1.Cond{mousenum, 3}))
       ShockTime_Fz_Distance_pre.(Mouse_names{mousenum}) = Start(Epoch1.Cond{mousenum, 2})-Start(subset(Epoch1.Cond{mousenum, 3},ep));

       ShockTime_Fz_Distance.(Mouse_names{mousenum}) = abs(max(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})<0))/1e4);
       if isempty(ShockTime_Fz_Distance.(Mouse_names{mousenum})); ShockTime_Fz_Distance.(Mouse_names{mousenum})=NaN; end

       for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1 % bin of 2s or less

           SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin)*1e4);
           PositionArray.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
           OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));       
           GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(bin-1);       
           TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(bin-1);       
           TimepentFreezing.(Mouse_names{mousenum})(i) = 2*(bin-1);
           i=i+1;
       end

       ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice

       SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{mousenum, 3},ep))); % last small epoch is a bin with time < 2s
       PositionArray.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(ind_to_use);
       TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(ind_to_use);
       try; TimepentFreezing.(Mouse_names{mousenum})(i) = 2*bin; catch; TimepentFreezing.(Mouse_names{mousenum})(i) = 0; end

       i=i+1;

    end
    
    Timefreezing_cumul.(Mouse_names{mousenum})(1) = 0;
    for j=2:length(TimepentFreezing.(Mouse_names{mousenum}))
        if TimepentFreezing.(Mouse_names{mousenum})(j) == 0
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1);
        else
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1) + 2;
        end
    end

    TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})'];

end 

%% Fitted parameters on train

% Create a structure with these parameters
Best_Fitted_variables.INT3.tau = [36 63 150 51 18 36 60 90 150 150 12 150 18 150 150];
Best_Fitted_variables.INT4.LearnSlope = [0.0045 0.0100 0.0050 1.0000e-03 0.0055 0.0085 0.0100 1.0000e-03 0.0040 0.0100 0.0030 1.0000e-03 0.0055 0.0065 0.0100];
Best_Fitted_variables.INT4.LearnPoint = [0.2000 0.1000 0.5000 0.9000 0.5000 0.8000 0.1000 0.5000 0.9000 0.9000 0.1000 0.1000 0.9000 0.7000 0.8000];

Best_Fitted_variables.INT5.Tau_exp = [33 54 150 150 21 42 108 129 150 150 9 81 21 150 150];
Best_Fitted_variables.INT5.LearnSlope = [0.0045 1.0000e-03 0.0055 0.0045 0.0060 0.0100 0.0100 0.0100 0.0045 0.0090 0.0025 1.0000e-03 0.0055 0.0060 0.0100];
Best_Fitted_variables.INT5.LearnPoint = [0.2000 0.6000 0.5000 0.9000 0.5000 0.6000 0.1000 0.9000 0.9000 0.9000 0.1000 0.4000 0.9000 0.7000 0.7000];

Best_Fitted_variables.INT6.LearnSlope = [0.0100 0.0100 0.0045 0.0065 0.0085 1.0000e-03 0.0100 0.0015 0.0015 0.0050 0.0100];
Best_Fitted_variables.INT6.LearnPoint = [0.3000 0.8000 0.5000 0.5000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000];

Best_Fitted_variables.INT7.LearnSlope = [0.0060 0.0095 0.0070 0.0020 0.0060 1.0000e-03 0.0070 0.0045 1.0000e-03 0.0055 0.0100];
Best_Fitted_variables.INT7.LearnPoint = [0.2000 0.4000 0.6000 0.4000 0.8000 0.7000 0.1000 0.5000 0.9000 0.9000 0.8000];

Best_Fitted_variables.INT8.LearnSlope = [0.0070 0.0100 0.0065 0.0020 0.0060 1.0000e-03 0.0100 0.0015 0.0020 0.0055 0.0100];
Best_Fitted_variables.INT8.LearnPoint = [0.2000 0.8000 0.6000 0.4000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000];

%% Create the fitted GLM arrays 

% Array for the linear, all interactions
varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimepentFreezing', 'Timefreezing_cumul', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', TimepentFreezing.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',varNames);
    GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Array for linear out1 and interaction out1
LinoutvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'Timefreezing_cumul', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    LinoutGLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',LinoutvarNames);
    LinoutGLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(LinoutGLMArray_mouse.(Mouse_names{mousenum}));
end 

% Int 1 : Linear model with Pos x last shock interaction
Int1varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int1_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Int1varNames);
    Int1_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int1_GLMArray_mouse.(Mouse_names{mousenum}));
end

% Int 2
Int2varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int2_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (PositionArray.(Mouse_names{mousenum})').*(GlobalTimeArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Int2varNames);
    Int2_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int2_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% INT3
Fit3varNames = {'PositionArray', 'GlobalTimeArray', 'Fit3ExpnegTimeSinceLastShockArray', 'PositionxFit3ExpnegTimeSinceLastShock', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/Best_Fitted_variables.INT3.tau(mousenum));
    Fit3_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
        Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Fit3varNames);
    Fit3_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit3_GLMArray_mouse.(Mouse_names{mousenum}));
end

% INT4
Fit4varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxFit4SigGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    Fit4SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT4.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT4.LearnPoint(mousenum)))));
    Fit4_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit4SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit4varNames);
    Fit4_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit4_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% INT5
Fit5varNames = {'PositionArray', 'GlobalTimeArray', 'Fit5Expneg_TimeSinceLastShockArray', 'PositionxFit5ExpnegTimeSinceLastShock', 'PositionxFit5SigGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/Best_Fitted_variables.INT5.Tau_exp(mousenum));
    Fit5SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT5.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT5.LearnPoint(mousenum)))));
    Fit5_GLMArray_mouse.(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
        GlobalTimeArray.(Mouse_names{mousenum})', Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
        (PositionArray.(Mouse_names{mousenum})').*(Fit5SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Fit5varNames);
    Fit5_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit5_GLMArray_mouse.(Mouse_names{mousenum}));
end

% INT6
Fit6varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit6SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit6SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT6.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT6.LearnPoint(mousenum)))));
    Fit6_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit6SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit6varNames);
    Fit6_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit6_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% INT8
Fit8varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit8SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit8SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(mousenum)))));
    Fit8_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit8SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit8varNames);
    Fit8_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit8_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% INT9
Int9varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int9_GLMArray_mouse.(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
        (SigPositionArray.(Mouse_names{mousenum})').*(GlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int9varNames);
    Int9_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int9_GLMArray_mouse.(Mouse_names{mousenum}));
end 


%% Cross validation of the GLMs : train and test
% Create training and testing data set (KFold cross validation with K=N of
% observations per mice, train on N-1 and validate on 1 N times) 

% linear
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.linear.(Mouse_names{mousenum}) = cvpartition(size(GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.linear.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.linear.(Mouse_names{mousenum}),i);
        Array_Train.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.linear.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.linear.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.linear.(Mouse_names{mousenum}), i);
        Array_Test.linear.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.linear.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.linear.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.linear.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.linear.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.linear.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.linear.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.linear.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.linear.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.linear.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% all interactions
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.interactions.(Mouse_names{mousenum}) = cvpartition(size(GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.interactions.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.interactions.(Mouse_names{mousenum}),i);
        Array_Train.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.interactions.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.interactions.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.interactions.(Mouse_names{mousenum}), i);
        Array_Test.interactions.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.interactions.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.interactions.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.interactions.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.interactions.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.interactions.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.interactions.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.interactions.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% linear out1
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.linear_out1.(Mouse_names{mousenum}) = cvpartition(size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=LinoutGLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.linear_out1.(Mouse_names{mousenum}),i);
        Array_Train.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.linear_out1.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.linear_out1.(Mouse_names{mousenum}), i);
        Array_Test.linear_out1.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.linear_out1.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.linear_out1.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.linear_out1.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.linear_out1.(Mouse_names{mousenum}).Testset(:,indset).table(:,5));
        [Test_mdl.linear_out1.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.linear_out1.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.linear_out1.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% all int without time freezing
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.interactions_out1.(Mouse_names{mousenum}) = cvpartition(size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=LinoutGLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(LinoutGLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.interactions_out1.(Mouse_names{mousenum}),i);
        Array_Train.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.interactions_out1.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.interactions_out1.(Mouse_names{mousenum}), i);
        Array_Test.interactions_out1.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.interactions_out1.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.interactions_out1.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.interactions_out1.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.interactions_out1.(Mouse_names{mousenum}).Testset(:,indset).table(:,5));
        [Test_mdl.interactions_out1.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.interactions_out1.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.interactions_out1.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT1
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Int1.(Mouse_names{mousenum}) = cvpartition(size(Int1_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Int1_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Int1_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Int1_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Int1.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Int1.(Mouse_names{mousenum}),i);
        Array_Train.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Int1.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Int1.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Int1.(Mouse_names{mousenum}), i);
        Array_Test.Int1.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Int1.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Int1.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Int1.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Int1.(Mouse_names{mousenum}).Testset(:,indset).table(:,5));
        [Test_mdl.Int1.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Int1.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Int1.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT2
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Int2.(Mouse_names{mousenum}) = cvpartition(size(Int2_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Int2_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Int2_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Int2_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Int2.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Int2.(Mouse_names{mousenum}),i);
        Array_Train.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Int2.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Int2.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Int2.(Mouse_names{mousenum}), i);
        Array_Test.Int2.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Int2.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Int2.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Int2.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Int2.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Int2.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Int2.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Int2.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT3
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit3.(Mouse_names{mousenum}) = cvpartition(size(Fit3_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit3_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit3_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit3_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit3.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit3.(Mouse_names{mousenum}),i);
        Array_Train.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit3.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit3.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit3.(Mouse_names{mousenum}), i);
        Array_Test.Fit3.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit3.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit3.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit3.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit3.(Mouse_names{mousenum}).Testset(:,indset).table(:,5));
        [Test_mdl.Fit3.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit3.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit3.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% Int4
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit4.(Mouse_names{mousenum}) = cvpartition(size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit4_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit4.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit4.(Mouse_names{mousenum}),i);
        Array_Train.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit4.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit4.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit4.(Mouse_names{mousenum}), i);
        Array_Test.Fit4.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit4.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit4.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit4.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit4.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit4.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit4.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit4.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT5
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit5.(Mouse_names{mousenum}) = cvpartition(size(Fit5_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit5_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit5_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit5_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit5.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit5.(Mouse_names{mousenum}),i);
        Array_Train.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit5.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit5.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit5.(Mouse_names{mousenum}), i);
        Array_Test.Fit5.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit5.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit5.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit5.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit5.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit5.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit5.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit5.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT6
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit6.(Mouse_names{mousenum}) = cvpartition(size(Fit6_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit6_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit6_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit6_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit6.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit6.(Mouse_names{mousenum}),i);
        Array_Train.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit6.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit6.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit6.(Mouse_names{mousenum}), i);
        Array_Test.Fit6.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit6.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit6.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit6.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit6.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit6.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit6.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit6.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% INT8
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit8.(Mouse_names{mousenum}) = cvpartition(size(Fit8_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit8_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit8_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit8_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit8.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit8.(Mouse_names{mousenum}),i);
        Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit8.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit8.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit8.(Mouse_names{mousenum}), i);
        Array_Test.Fit8.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit8.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit8.(Mouse_names{mousenum}).Testset(:,indset).table(:,7));
        [Test_mdl.Fit8.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit8.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit8.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

Train_mdl.Fit8.(Mouse_names{1}).Trainset(1).table.Formula

%INT9
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Int9.(Mouse_names{mousenum}) = cvpartition(size(Int9_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Int9_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Int9_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Int9_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Int9.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Int9.(Mouse_names{mousenum}),i);
        Array_Train.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Int9.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Int9.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Int9.(Mouse_names{mousenum}), i);
        Array_Test.Int9.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Int9.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Int9.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Int9.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Int9.(Mouse_names{mousenum}).Testset(:,indset).table(:,7));
        [Test_mdl.Int9.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Int9.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Int9.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end


%% Evaluate models and GOFs on train

% Plot test vs predicted test data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    square=[2 10];
    plot(Array_Test_frequencies.interactions.(Mouse_names{mousenum}).Value, Test_mdl.interactions.(Mouse_names{mousenum}).Value, '.k')
    axis square
    xlim(square)
    ylim(square)
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Test Data', 'FontSize', 20)
ylabel('Predicted Data', 'FontSize', 20)
title(han,'Prediction on test value of the interactions model trained on N-test values', 'FontSize', 20);

% Models_all = [linear, linear_out1, interactions, interactions_out1, Int1, Int2, Fit3, Fit4, Fit5];

% for modelnum=1:length(Models_all)
%     Model_name{modelnum} = [num2str(Models_all(modelnum))];
%     for mousenum=1:length(Mouse_ALL)
%         Corr_coef.(Model_name{modelnum}).Train = corrcoef(table2array(Array_Train.(Model_name{modelnum}).(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.(Model_name{modelnum}).(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
%         Corr_coef.(Model_name{modelnum}).Test = corrcoef(Array_Test_frequencies.(Model_name{modelnum}).(Mouse_names{mousenum}).Value, Test_mdl.(Model_name{modelnum}).(Mouse_names{mousenum}).Value).^2;
%     end
% end

%% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    clear Corr_coef
    Corr_coef.linear.Train = corrcoef(table2array(Array_Train.linear.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.linear.Test = corrcoef(Array_Test_frequencies.linear.(Mouse_names{mousenum}).Value, Test_mdl.linear.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.linear_out1.Train = corrcoef(table2array(Array_Train.linear_out1.(Mouse_names{mousenum}).Trainset(1).table(:,5)), table2array(Output_GLM.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.linear_out1.Test = corrcoef(Array_Test_frequencies.linear_out1.(Mouse_names{mousenum}).Value, Test_mdl.linear_out1.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.interactions.Train = corrcoef(table2array(Array_Train.interactions.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.interactions.Test = corrcoef(Array_Test_frequencies.interactions.(Mouse_names{mousenum}).Value, Test_mdl.interactions.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.interactions_out1.Train = corrcoef(table2array(Array_Train.interactions_out1.(Mouse_names{mousenum}).Trainset(1).table(:,5)), table2array(Output_GLM.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.interactions_out1.Test = corrcoef(Array_Test_frequencies.interactions_out1.(Mouse_names{mousenum}).Value, Test_mdl.interactions_out1.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Int1.Train = corrcoef(table2array(Array_Train.Int1.(Mouse_names{mousenum}).Trainset(1).table(:,5)), table2array(Output_GLM.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Int1.Test = corrcoef(Array_Test_frequencies.Int1.(Mouse_names{mousenum}).Value, Test_mdl.Int1.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Int2.Train = corrcoef(table2array(Array_Train.Int2.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Int2.Test = corrcoef(Array_Test_frequencies.Int2.(Mouse_names{mousenum}).Value, Test_mdl.Int2.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Fit3.Train = corrcoef(table2array(Array_Train.Fit3.(Mouse_names{mousenum}).Trainset(1).table(:,5)), table2array(Output_GLM.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit3.Test = corrcoef(Array_Test_frequencies.Fit3.(Mouse_names{mousenum}).Value, Test_mdl.Fit3.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Fit4.Train = corrcoef(table2array(Array_Train.Fit4.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit4.Test = corrcoef(Array_Test_frequencies.Fit4.(Mouse_names{mousenum}).Value, Test_mdl.Fit4.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Fit5.Train = corrcoef(table2array(Array_Train.Fit5.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit5.Test = corrcoef(Array_Test_frequencies.Fit5.(Mouse_names{mousenum}).Value, Test_mdl.Fit5.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Fit6.Train = corrcoef(table2array(Array_Train.Fit6.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit6.Test = corrcoef(Array_Test_frequencies.Fit6.(Mouse_names{mousenum}).Value, Test_mdl.Fit6.(Mouse_names{mousenum}).Value).^2;
    Corr_coef.Fit8.Train = corrcoef(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit8.Test = corrcoef(Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.(Mouse_names{mousenum}).Value).^2;
    
    Rsquared_Train(mousenum,1)=Corr_coef.linear.Train(1,2);
    Rsquared_Test(mousenum,1)=Corr_coef.linear.Test(1,2);
    Rsquared_Train(mousenum,2)=Corr_coef.linear_out1.Train(1,2);
    Rsquared_Test(mousenum,2)=Corr_coef.linear_out1.Test(1,2);
    Rsquared_Train(mousenum,3)=Corr_coef.interactions.Train(1,2);
    Rsquared_Test(mousenum,3)=Corr_coef.interactions.Test(1,2);
    Rsquared_Train(mousenum,4)=Corr_coef.interactions_out1.Train(1,2);
    Rsquared_Test(mousenum,4)=Corr_coef.interactions_out1.Test(1,2);
    Rsquared_Train(mousenum,5)=Corr_coef.Int1.Train(1,2);
    Rsquared_Test(mousenum,5)=Corr_coef.Int1.Test(1,2);
    Rsquared_Train(mousenum,6)=Corr_coef.Int2.Train(1,2);
    Rsquared_Test(mousenum,6)=Corr_coef.Int2.Test(1,2);
    Rsquared_Train(mousenum,7)=Corr_coef.Fit3.Train(1,2);
    Rsquared_Test(mousenum,7)=Corr_coef.Fit3.Test(1,2);
    Rsquared_Train(mousenum,8)=Corr_coef.Fit4.Train(1,2);
    Rsquared_Test(mousenum,8)=Corr_coef.Fit4.Test(1,2);
    Rsquared_Train(mousenum,9)=Corr_coef.Fit5.Train(1,2);
    Rsquared_Test(mousenum,9)=Corr_coef.Fit5.Test(1,2);
    Rsquared_Train(mousenum,10)=Corr_coef.Fit8.Train(1,2);
    Rsquared_Test(mousenum,10)=Corr_coef.Fit8.Test(1,2);
    Rsquared_Train(mousenum,11)=Corr_coef.Fit6.Train(1,2);
    Rsquared_Test(mousenum,11)=Corr_coef.Fit6.Test(1,2);
end


for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train(mousenum,1)=nanmean(struct2array(Rsquared.Train_mdl.linear.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,2)=nanmean(struct2array(Rsquared.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,3)=nanmean(struct2array(Rsquared.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,4)=nanmean(struct2array(Rsquared.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,5)=nanmean(struct2array(Rsquared.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,6)=nanmean(struct2array(Rsquared.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,7)=nanmean(struct2array(Rsquared.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,8)=nanmean(struct2array(Rsquared.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,9)=nanmean(struct2array(Rsquared.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,10)=nanmean(struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,11)=nanmean(struct2array(Rsquared.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset));
    Mean_Rsquared_deviance_Train(mousenum,12)=nanmean(struct2array(Rsquared.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset));


    Rsquared_deviance_Train(mousenum,1)=struct2array(Rsquared.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,2)=struct2array(Rsquared.Train_mdl.linear_out1.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,3)=struct2array(Rsquared.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,4)=struct2array(Rsquared.Train_mdl.interactions_out1.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,5)=struct2array(Rsquared.Train_mdl.Int1.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,6)=struct2array(Rsquared.Train_mdl.Int2.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,7)=struct2array(Rsquared.Train_mdl.Fit3.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,8)=struct2array(Rsquared.Train_mdl.Fit4.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,9)=struct2array(Rsquared.Train_mdl.Fit5.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,10)=struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,11)=struct2array(Rsquared.Train_mdl.Fit6.(Mouse_names{mousenum}).Trainset(1));
    Rsquared_deviance_Train(mousenum,12)=struct2array(Rsquared.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(1));

end

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train(mousenum,10)=nanmean(struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train(mousenum,10)=struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit8.Train = corrcoef(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit8.Test = corrcoef(Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train(mousenum,10)=Corr_coef.Fit8.Train(1,2);
    Rsquared_Test(mousenum,10)=Corr_coef.Fit8.Test(1,2);
end

for mousenum=1:length(Mouse_ALL)
    Rsquared_deviance_Train(mousenum,12)=struct2array(Rsquared.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Int9.Train = corrcoef(table2array(Array_Train.Int9.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Int9.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Int9.Test = corrcoef(Array_Test_frequencies.Int9.(Mouse_names{mousenum}).Value, Test_mdl.Int9.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train(mousenum,12)=Corr_coef.Int9.Train(1,2);
    Rsquared_Test(mousenum,12)=Corr_coef.Int9.Test(1,2);
end

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,5) Rsquared_Train(:,7)},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('R2 on train sets', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])
saveas(gcf, fullfile(SaveFigsTo, '03_Ex_transform_choice'), 'png');


figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,2) Rsquared_Test(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Linear model without time freezing', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,3) Rsquared_Test(:,3)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Interactions model', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,4) Rsquared_Test(:,4)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Interactions - Time Fz model', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
subplot(1,5,1)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,5) Rsquared_Test(:,5)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('INT1', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
subplot(1,5,2)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,6) Rsquared_Test(:,6)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('INT2', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
subplot(1,5,3)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,7) Rsquared_Test(:,7)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('INT3 model', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
subplot(1,5,4)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,8) Rsquared_Test(:,8)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('INT4 model', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

figure
subplot(1,5,5)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train(:,9) Rsquared_Test(:,9)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('INT5 model', 'FontSize', 20);median
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1])

%% Report figures

% Linear model : GOF and significant predictors 

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train(:,1) Rsquared_Test(:,1)},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF linear model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
saveas(gcf, fullfile(SaveFigsTo, '03_A_GOF_linear'), 'png');

% predictors
for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.linear(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.linear(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.linear(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.linear(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.linear(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.linear.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
end

sum(Compare_significant_predictors.linear<0.05)

% [1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1], [.5 0.7 0.5]

figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.linear(:,1)...
    Compare_significant_predictors.linear(:,2) Compare_significant_predictors.linear(:,3)...
    Compare_significant_predictors.linear(:,4) Compare_significant_predictors.linear(:,5)},...
    {},[1 2 3 4 5],...
    {'Pos','GT', 'TLS', 'EFT', 'CFT'},'paired',1,'showpoints',0)
%     {'Position','Global Time', 'Time Since Last Shock', 'Episode freezing', 'Cumulative freezing'},'paired',1,'showpoints',0)
% sum(Compare_significant_predictors.linear<0.05)
% legend({'8','3','7','2','2'})
xlim([0 6])
% ylim([-0.1 1.1])
txt = {'8','3','7','2','2'};
for i=1:length(txt)
text(i,1e-18,txt(i), 'FontSize', 12)
end
line(xlim, [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, linear model');
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 14)
saveas(gcf, fullfile(SaveFigsTo, '03_B_pvalues_linear'), 'png');

% All Int model 

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train(:,3) Rsquared_Test(:,3)},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF all interactions model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
saveas(gcf, fullfile(SaveFigsTo, '03_C_GOF_all_interactions'), 'png');

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.interactions(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.interactions(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.interactions(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.interactions(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.interactions(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
    Compare_significant_predictors.interactions(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(7,4));%
    Compare_significant_predictors.interactions(mousenum,7) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(8,4));%
    Compare_significant_predictors.interactions(mousenum,8) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(9,4));%
    Compare_significant_predictors.interactions(mousenum,9) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(10,4));
    Compare_significant_predictors.interactions(mousenum,10) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(11,4)); 
    Compare_significant_predictors.interactions(mousenum,11) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(12,4));%
    Compare_significant_predictors.interactions(mousenum,12) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(13,4));%
    Compare_significant_predictors.interactions(mousenum,13) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(14,4));%
    Compare_significant_predictors.interactions(mousenum,14) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(15,4));%
    Compare_significant_predictors.interactions(mousenum,15) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(16,4));%
    
    Compare_significant_predictors.interactions(mousenum,:) = table2array(Table_estimates_pval.Train_mdl.interactions.(Mouse_names{mousenum}).Trainset(1).table(2:16,4));%
end

figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.interactions(:,1)...
    Compare_significant_predictors.interactions(:,2) Compare_significant_predictors.interactions(:,3) ...
    Compare_significant_predictors.interactions(:,4) Compare_significant_predictors.interactions(:,5) ...
    Compare_significant_predictors.interactions(:,6) Compare_significant_predictors.interactions(:,7) ...
    Compare_significant_predictors.interactions(:,8) Compare_significant_predictors.interactions(:,9) ...
    Compare_significant_predictors.interactions(:,10) Compare_significant_predictors.interactions(:,11) ...
    Compare_significant_predictors.interactions(:,12) Compare_significant_predictors.interactions(:,13) ...
    Compare_significant_predictors.interactions(:,14) Compare_significant_predictors.interactions(:,15) },...
    {},[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15],...
    {'Pos','GT', 'TLS', 'EFT', 'CFT', ...
    'PosxGT', 'PosxTLS', 'PosxEFT', 'PosxCFT', ...
    'GTxTLS', 'GTxEFT', 'GTxCFT', ...
    'TLSxEFT', 'TLSxCFT', 'EFTxCFT'},'paired',1,'showpoints',0);
%     {'Position','Global Time', 'Time Since Last Shock', 'TimepentFreezing', 'TimepentFreezingCumul', ...
%     'Position:Global Time', 'PositionArray:TimeSinceLastShockArray', 'PositionArray:TimepentFreezing', 'PositionArray:Timefreezing_cumul', ...
%     'GlobalTimeArray:TimeSinceLastShockArray', 'GlobalTimeArray:TimepentFreezing', 'GlobalTimeArray:Timefreezing_cumul', ...
%     'TimeSinceLastShockArray:TimepentFreezing', 'TimeSinceLastShockArray:Timefreezing_cumul', 'TimepentFreezing:Timefreezing_cumul'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired dataylim([-0.1 1.1])
txt1 = string(sum(Compare_significant_predictors.interactions<0.05));
for i=1:length(txt1)
text(i,8e-6,txt1(i), 'FontSize', 12)
end
xlim([0 16])
ylim([1e-7 1])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, all interactions model', 'FontSize', 25);
xtickangle(40);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)
saveas(gcf, fullfile(SaveFigsTo, '03_D_pvalues_all_interactions'), 'png');

% Int - Ep Fz model (10 variables)

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train(:,4) Rsquared_Test(:,4)},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF interactions without EFT model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
saveas(gcf, fullfile(SaveFigsTo, '03_E_GOF_interactions_out_Ep'), 'png');

% Table with median R2 Deviance on train and handmade on test for all int
% models previously done

median_R2_Test = median(Rsquared_Test);
median_R2_Train = median(Rsquared_Train);
median_R2_deviance = median(Rsquared_deviance_Train);
save('Ella_Data.mat','Rsquared_deviance_Train','-append')

% Chosen Int8 model

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train(:,10) Rsquared_Test(:,10)},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF chosen interactions model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
saveas(gcf, fullfile(SaveFigsTo, '03_G_GOF_chosen_interactions'), 'png');

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit8(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit8(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.Fit8(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit8(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit8(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
    Compare_significant_predictors.Fit8(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(7,4));%
end

figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit8(:,1)...
    Compare_significant_predictors.Fit8(:,2) Compare_significant_predictors.Fit8(:,3) ...
    Compare_significant_predictors.Fit8(:,4) Compare_significant_predictors.Fit8(:,5) ...
    Compare_significant_predictors.Fit8(:,6)}, ...
    {},[1 2 3 4 5 6],...
    {'Pos','GT', 'TLS', 'CFT', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit8<0.05));
for i=1:length(txt1)
text(i,1e-10,txt1(i), 'FontSize', 12)
end
xlim([0 7])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)
saveas(gcf, fullfile(SaveFigsTo, '03_H_pval_chosen_interactions'), 'png');

%% Compare the mean R2 deviance for all models on train

figure
MakeSpreadAndBoxPlot3_ECSB({Mean_Rsquared_deviance_Train(:,1)...
    Mean_Rsquared_deviance_Train(:,2) Mean_Rsquared_deviance_Train(:,3) ...
    Mean_Rsquared_deviance_Train(:,4) Mean_Rsquared_deviance_Train(:,5) ...
    Mean_Rsquared_deviance_Train(:,6) Mean_Rsquared_deviance_Train(:,7) ...
    Mean_Rsquared_deviance_Train(:,8) Mean_Rsquared_deviance_Train(:,9) ...
    Mean_Rsquared_deviance_Train(:,10) Mean_Rsquared_deviance_Train(:,11) Mean_Rsquared_deviance_Train(:,12)},...
    {},[1 2 3 4 5 6 7 8 9 10 11 12],...
    {'Linear','Linear - EFT', 'All int', 'All int - EFT', 'INT1', ...
    'INT2', 'INT3', 'INT4', 'INT5', ...
    'INT8', 'INT6', 'INT9'},'paired',1,'showpoints',0);
xlim([0 13])
ylabel('Mean R2 deviance on train for all models', 'FontSize', 25);
xtickangle(40);
set(gca,'linewidth',1.5, 'FontSize', 14)

figure
MakeSpreadAndBoxPlot3_ECSB({Mean_Rsquared_deviance_Train(:,5) ...
    Mean_Rsquared_deviance_Train(:,6) Mean_Rsquared_deviance_Train(:,7) ...
    Mean_Rsquared_deviance_Train(:,8) Mean_Rsquared_deviance_Train(:,9) ...
    Mean_Rsquared_deviance_Train(:,10) Mean_Rsquared_deviance_Train(:,11) Mean_Rsquared_deviance_Train(:,12)},...
    {},[1 2 3 4 5 6 7 8 ],...
    {'INT1', ...
    'INT2', 'INT3', 'INT4', 'INT5', ...
    'INT8', 'INT6', 'INT9'},'paired',1,'showpoints',0);
xlim([0 9])
ylabel('Mean R2 deviance on train', 'FontSize', 25);
xtickangle(0);
set(gca,'linewidth',1.5, 'FontSize', 14)

saveas(gcf, fullfile(SaveFigsTo, 'ALL_R2_INT_models'), 'png');

%% Train vs train data Fit8

% Plot train and predicted train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    if mousenum==8; legend({'Data', 'Prediction'}); end
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Observation', 'FontSize', 20)
ylabel('Frequency', 'FontSize', 20)
title(han,'Prediction on train dataset vs train dataset for the Int4 model', 'FontSize', 20);


% Plot train vs train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(4,3,mousenum)
    square=[2 10];
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), '.k')
    axis square
    xlim(square)
    ylim(square)
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Training Data', 'FontSize', 20)
ylabel('Predicted Data', 'FontSize', 20)

% Plot train and predicted train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    if mousenum==8; legend({'Data', 'Prediction'}); end
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Observation', 'FontSize', 20)
ylabel('Frequency', 'FontSize', 20)
title(han,'Prediction on train dataset vs train dataset for the Int4 model', 'FontSize', 20);

figure
for mousenum=3
    clear a b c
    [a, b] = sort(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)));
    plot(a, 'x'), hold on 
    c = table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1));
    plot(c(b), 'o')
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    leg=legend({'Train data', 'Fitted value'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 7])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
saveas(gcf, fullfile(SaveFigsTo, '02_S4_Train_vs_train'), 'png');

figure
for mousenum=3
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)),5)), hold on
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 7])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
saveas(gcf, fullfile(SaveFigsTo, '02_S4_Train_vs_train'), 'png');

% Plot train vs train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(4,3,mousenum)
    square=[2 10];
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), '.k')
    axis square
    xlim(square)
    ylim(square)
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Training Data', 'FontSize', 20)
ylabel('Predicted Data', 'FontSize', 20)

% Plot test vs test data
for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit8.(Mouse_names{mousenum}).Value)
    Array_Test.Fit8.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit8.(Mouse_names{mousenum}).Testset(i).table(:,7));
end
end

fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(Array_Test.Fit8.(Mouse_names{mousenum}).ALL, 'x'), hold on 
    plot(Test_mdl.Fit8.(Mouse_names{mousenum}).Value, 'o')
    if mousenum==8; legend({'Data', 'Prediction'}); end
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel('Observation', 'FontSize', 20)
ylabel('Frequency', 'FontSize', 20)
title(han,'Prediction on test value of the Int4 model trained on N-test values', 'FontSize', 20);

figure
for mousenum=3
    plot(Array_Test.Fit8.(Mouse_names{mousenum}).ALL, 'x'), hold on 
    plot(Test_mdl.Fit8.(Mouse_names{mousenum}).Value, 'o')
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    leg=legend({'Test data', 'Predicted value'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 7])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
saveas(gcf, fullfile(SaveFigsTo, '02_S4_Test_vs_Test'), 'png');

figure
for mousenum=3
    [~, idx] = ismember(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), Array_Test.Fit8.(Mouse_names{mousenum}).ALL);
    
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)),'x','Color',[0.1 0.1 0.1]), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o', 'Color',[0.8 0 0]), hold on 
    plot(Test_mdl.Fit8.(Mouse_names{mousenum}).Value(idx), 'o', 'Color',[0.4 0.8 0.2])
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    leg=legend({'Dataset', 'Fitted value', 'Predicted value'}, 'FontSize', 12, 'Location', 'southwest');
%     leg=legend({'Test data', 'Predicted value'}, 'FontSize', 12, 'Location', 'southwest');
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2 7])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
saveas(gcf, fullfile(SaveFigsTo, '02_S4_Train_and_test_final'), 'png');

figure
for mousenum=3
    [~, idx] = ismember(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), Array_Test.Fit8.(Mouse_names{mousenum}).ALL);
    
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)),'x','Color',[0.1 0.1 0.1]), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o', 'Color',[0.8 0 0]), hold on 
    plot(Test_mdl.Fit8.(Mouse_names{mousenum}).Value(idx), 'o', 'Color',[0.4 0.8 0.2])
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    leg=legend({'Dataset', 'Fitted value', 'Predicted value'}, 'FontSize', 12, 'Location', 'southwest');
%     leg=legend({'Test data', 'Predicted value'}, 'FontSize', 12, 'Location', 'southwest');
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2 7])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end


%% Correlate GOF with the correlation between instfreq and spectro on the OB frequency



%% Look at the parameters of the Global Time transformation in Fit8 model

% GT transformed for each mouse
figure
% mousenum=1
for mousenum=1:length(Mouse_ALL)
plot(Fit8SigGlobalTimeArray.(Mouse_names{mousenum})), hold on
% plot(GlobalTimeArray.(Mouse_names{mousenum}))
LegendsStrings{mousenum}= ['LP = ',num2str(Best_Fitted_variables.INT8.LearnPoint(mousenum))];
end
makepretty
legend(LegendsStrings, 'FontSize', 12, 'Location', 'southeast')

% See to what shape each LS corresponds
for mousenum=1:length(Mouse_ALL)
AllTpsLearnGT(mousenum) = max(GlobalTimeArray.(Mouse_names{mousenum})); % Have an idea to do the next plot
end

figure
learnslope=0.001:0.0005:0.01;
for i=1:length(learnslope)
    plot(1:5000, 1./(1+exp(-learnslope(i)*([1:5000]-(5000*0.5))))), hold on
LegendsStrings{i}= ['LP = ',num2str(learnslope(i))];
end
makepretty
legend(LegendsStrings, 'FontSize', 12, 'Location', 'southeast')
ylabel('Example of sigmoids for different learn slopes')

figure
clf
Vals = {Best_Fitted_variables.INT8.LearnSlope', Best_Fitted_variables.INT8.LearnPoint'};
XPos = [1,2];

for k = 1:2
    subplot(1,2,k)
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[.4,.6,.8],'lineColor',[.4,.6,.8],'medianColor',[.4,.6,.8],'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.7)

    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',18)
end

% xlim([0 3])
ylabel('Fitted parameters on the GT transformation, final model')
ylim([0 1]) %for the learn point
set(gca,'XTick',XPos,'XTickLabel',{'Learn Slope','Learn Point'},'linewidth',1.5)
box off

%% Look at the estimates of the INT8 model

for mousenum=1:length(Mouse_ALL)
    Compare_estimates.Fit8(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(2,1));%Position
    Compare_estimates.Fit8(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(3,1));%GT
    Compare_estimates.Fit8(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(4,1));%T since last shock
    Compare_estimates.Fit8(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(5,1));%T freezing
    Compare_estimates.Fit8(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(6,1));%T freezing cumul
    Compare_estimates.Fit8(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(7,1));%Position
end

figure
clf
Vals = Compare_estimates.Fit8;
XPos = [1:6];

for k = 1:6
    subplot(1,6,k)
    X = Vals(:,k);
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[.4,.6,.8],'lineColor',[.4,.6,.8],'medianColor',[.4,.6,.8],'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.7)

    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',18)
end

xlim([5.5 6.5])
ylabel('Estimates values, final model')
set(gca,'XTick',XPos,'XTickLabel',{'Pos','GT', 'TLS', 'CFT', 'Sig(Pos)xTLS', 'Sig(Pos)xSig(GT)'},'linewidth',1.5)
box off

% Difficult to interpret -> fit a lasso linear regression

for mousenum=1:length(Mouse_ALL)
    [B.(Mouse_names{mousenum}),FitInfo.(Mouse_names{mousenum})] = lasso(table2array(Fit8_GLMArray_mouse.(Mouse_names{mousenum})(:,[1:6])),...
        table2array(Fit8_GLMArray_mouse.(Mouse_names{mousenum})(:,7)),'CV',size(Fit8_GLMArray_mouse.(Mouse_names{mousenum})(:,7),1),...
        'Alpha',0.00001, 'PredictorNames',{'Pos','GT', 'TLS', 'CFT', 'Sig(Pos)xTLS', 'Sig(Pos)xSig(GT)'});
end

for mousenum=1:length(Mouse_ALL)
    Compare_estimates_lasso.Fit8(mousenum,1) = B.(Mouse_names{mousenum})(1,1);%Position
    Compare_estimates_lasso.Fit8(mousenum,2) = B.(Mouse_names{mousenum})(2,1);%GT
    Compare_estimates_lasso.Fit8(mousenum,3) = B.(Mouse_names{mousenum})(3,1);%T since last shock
    Compare_estimates_lasso.Fit8(mousenum,4) = B.(Mouse_names{mousenum})(4,1);%T freezing
    Compare_estimates_lasso.Fit8(mousenum,5) = B.(Mouse_names{mousenum})(5,1);%T freezing cumul
    Compare_estimates_lasso.Fit8(mousenum,6) = B.(Mouse_names{mousenum})(6,1);%Position
end

figure
clf
Vals = Compare_estimates_lasso.Fit8;
XPos = [1:6];

for k = 1:6
    subplot(1,6,k)
    X = Vals(:,k);
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[.4,.6,.8],'lineColor',[.4,.6,.8],'medianColor',[.4,.6,.8],'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.7)

    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7); hold on;
    set(handlesplot{1},'MarkerSize',18)
end

ylabel('Estimates values, lasso regression of final model')
set(gca,'XTick',XPos,'XTickLabel',{'Pos','GT', 'TLS', 'CFT', 'Sig(Pos)xTLS', 'Sig(Pos)xSig(GT)'},'linewidth',1.5)
box off


% IndMinSE = FitInfo.(Mouse_names{mousenum}).Index1SE 
% B.(Mouse_names{mousenum})(:,IndMinSE)



