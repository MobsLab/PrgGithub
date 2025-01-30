%% Objectives of this code

% Test the K-Fold cross-validation with the INT4 model that was the first
% selected one

% K-Fold cross-validation is done by running as much GLMs as the number of
% observations a given mouse has, and taking each time one observation to
% test the corresponding (missing this observation) GLM

% Look at the train vs train and test vs test data

%% Run the models for all mice

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to
Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

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

%% GLM

% Take a look at the distribution of the response variable
figure; 
nbins=25;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    histogram(OB_FrequencyArray.(Mouse_names{mousenum}),nbins) %looks like an inverse gaussian or a gamma distribution
    xlabel('OB frequency', 'FontSize', 25)
    ylabel('count', 'FontSize', 25)
    title(mouse)
end

%% Fit the transformation for each mouse 

% Int4 model : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray',
% 'PositionxTimeSinceLastShock', 'PositionxSigGlocalTime'
for mousenum=1:length(Mouse_ALL)
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
                
            SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int4varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int4_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
                (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (PositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int4varNames);
            Int4_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int4_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int4_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;    
        end
        indslope=indslope+1;
    end
end

% Extract values that minimize the R2 deviance for each mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            Compare_models_R2_learnp.chosen_interactions4_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions4_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions4_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.learn(:,mousenum));
            Best_Fitted_variables.INT4.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT4.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        indslope=indslope+1; 
    end
end

%% Create the fitted GLM

Fit4varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    
    FitSigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.LearnPoint(mousenum)))));

    Fit4_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (PositionArray.(Mouse_names{mousenum})').*(FitSigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit4varNames);
    Fit4_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit4_GLMArray_mouse.(Mouse_names{mousenum}));
end 

for mousenum=1:length(Mouse_ALL)
    fitted_interactions4_mdl.(Mouse_names{mousenum}) = fitglm(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.fitted_interactions4_mdl.(Mouse_names{mousenum}) = fitted_interactions4_mdl.(Mouse_names{mousenum});
    Rsquared.fitted_interactions4_mdl.(Mouse_names{mousenum}) = fitted_interactions4_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.fitted_interactions4_mdl.(Mouse_names{mousenum}) = fitted_interactions4_mdl.(Mouse_names{mousenum}).Deviance;
    LR.fitted_interactions4_mdl.(Mouse_names{mousenum}) = fitted_interactions4_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum}) = Output_GLM.fitted_interactions4_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.fitted_interactions4(mousenum,1) = table2array(Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.fitted_interactions4(mousenum,2) = table2array(Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.fitted_interactions4(mousenum,3) = table2array(Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.fitted_interactions4(mousenum,4) = table2array(Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum})(5,4));%PositionxTimeSinceLastShock
    Compare_significant_predictors.fitted_interactions4(mousenum,5) = table2array(Table_estimates_pval.fitted_interactions4_mdl.(Mouse_names{mousenum})(6,4));%PositionxSigGT
end

% Look at significative explicative variables
figure
[Int_pval , Int_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.fitted_interactions4(:,1)...
    Compare_significant_predictors.fitted_interactions4(:,2) Compare_significant_predictors.fitted_interactions4(:,3)...
    Compare_significant_predictors.fitted_interactions4(:,4) Compare_significant_predictors.fitted_interactions4(:,5)},...
    {[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0.7 0.4]},[1 2 3 4 5],{'Position','Global Time', 'Time Since Last Shock', 'PositionxTime Since Last Shock', 'PositionxGlobalTime'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice in the fitted Int4 model', 'FontSize', 25);

% Plot train and predicted train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(table2array(Fit4_GLMArray_mouse.(Mouse_names{mousenum})(:,6)), 'x'), hold on 
    plot(table2array(Output_GLM.fitted_interactions4_mdl.(Mouse_names{mousenum}).Fitted(:,1)), 'o')
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

% Plot train vs predicted train data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    square=[2 10];
    plot(table2array(Fit4_GLMArray_mouse.(Mouse_names{mousenum})(:,6)), table2array(Output_GLM.fitted_interactions4_mdl.(Mouse_names{mousenum}).Fitted(:,1)), '.k')
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

%% Cross validation of the fitted GLM 4

% Create training and testing data set (KFold cross validation with K=N of
% observations per mice, train on N-1 and validate on 1 N times) 
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.(Mouse_names{mousenum}) = cvpartition(size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit4_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit4_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.(Mouse_names{mousenum}),i);
        Array_Train.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.(Mouse_names{mousenum}), i);
        Array_Test.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.(Mouse_names{mousenum}).Trainset,2)
        Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_Fit4.(Mouse_names{mousenum}).Value(indset,:), Test_Fit4.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end


fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(Array_Test_frequencies.(Mouse_names{mousenum}).Value, 'x'), hold on 
    plot(Test_Fit4.(Mouse_names{mousenum}).Value, 'o')
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

crossval(Train_Fit4_mdl.(Mouse_names{mousenum}).Trainset(:,indset).table)







