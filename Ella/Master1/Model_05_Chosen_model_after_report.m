%% Objectives of the code

% Focus on Fit8 model and apply the recommandations given during my
% presentations 

% Parameters of the Sig transformation and predictors in FIT8 model
%%% extracted with a lasso regression 

% Significance tests
%%% Chi2 test : only sig(Pos)xsig(GT) is significative
%%% Test on the estimated coefficients : GT is significative

% Correlations between predictors
%%% GT CFT highly correlated -> exclude one of them and run GLMs
%%% INT10 without GT and INT11 without CFT

% Transform in inverse sigmoid
%%% Int12 = Int10 with sig(GT) in inverse sigmoid

% Back to simple bio-insired model : TLS + sig(Pos)xsig(GT)

% Try to fit a model without the blocked epochs

%% Run the models for the selected mice
% We removed mice that have not learned (1393 spends 25% of her time
% in the shock zone in post cond) or that have freezed less than 40s (779,1170, 9205)
Mouse_ALL=[688 739 777 849 893 1171 9184 1189 1391 1392 1394];

%% Generate data for all mice that have learned (from Data_For_Model_BM.m)
Session_type={'Cond'};% sessions can be added
for sess=1:length(Session_type)
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) ,NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',[688 739 777 849 893 1171 9184 1189 1391 1392 1394],lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end


for mousenum=1:length(Mouse_ALL)
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

%% Fitted parameters on train and GLM array

% Create a structure with these parameters
Best_Fitted_variables.INT8.LearnSlope = [0.0070 0.0100 0.0065 0.0020 0.0060 1.0000e-03 0.0100 0.0015 0.0020 0.0055 0.0100];
Best_Fitted_variables.INT8.LearnPoint = [0.2000 0.8000 0.6000 0.4000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000];

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

%% Cross validation of the GLMs : train and test
% Create training and testing data set (KFold cross validation with K=N of
% observations per mice, train on N-1 and validate on 1 N times) 

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


%% Evaluate models and GOFs on train

% Plot test vs predicted test data
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    square=[2 10];
    plot(Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.(Mouse_names{mousenum}).Value, '.k')
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
title(han,'Prediction on test value of the chosen model trained on N-test values', 'FontSize', 20);

%% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit8(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit8(mousenum)=struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit8.Train = corrcoef(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit8.Test = corrcoef(Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit8(mousenum)=Corr_coef.Fit8.Train(1,2);
    Rsquared_Test_Fit8(mousenum)=Corr_coef.Fit8.Test(1,2);
end

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit8' Rsquared_Test_Fit8'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT8 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit8))

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit8(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit8(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.Fit8(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit8(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit8(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
    Compare_significant_predictors.Fit8(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(7,4));%
    
end

% Predictors
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


%% Predivctivity of the model

for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit8.(Mouse_names{mousenum}).Value)
    Array_Test.Fit8.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit8.(Mouse_names{mousenum}).Testset(i).table(:,7));
end
end

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

% figure with mean signal
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)),5)), hold on
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
%     leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,10];
%     legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
%     ylim([2.5 7])
%     set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
suptitle('INT8')

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


%% Chi2 tests on the proportion of mice for which a variable is significant

Xsigpred.Fit8(:,1) = sum(Compare_significant_predictors.Fit8<0.05);
Xsigpred.Fit8(:,2) = ones(1,6)*11;
Nmice(:,1) = ones(1,6)*11;
Nmice(:,2) = ones(1,6)*11;

for i=1:6
    [h(i),p(i),chi2stat(i),df(i)] = prop_test(Xsigpred.Fit8(i,:), Nmice(i,:), 'true');
end

% Only the sig(GT)xPos is significant
% But need to take into account that some variables appear more than once
%%% and so their significance is shared
% Should minimize the occurence of a given predictor 

%% Test the difference of each predictor to 0

for mousenum=1:length(Mouse_ALL)
    Compare_estimates.Fit8(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(2,1));%Position
    Compare_estimates.Fit8(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(3,1));%GT
    Compare_estimates.Fit8(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(4,1));%T since last shock
    Compare_estimates.Fit8(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(5,1));%T freezing
    Compare_estimates.Fit8(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(6,1));%T freezing cumul
    Compare_estimates.Fit8(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(7,1));%Position
end

clear p h
[p(1),h(1),statstemp(1,:)]=signrank(Compare_estimates.Fit8(:,1));
[p(2),h(2),statstemp(2,:)]=signrank(Compare_estimates.Fit8(:,2));
[p(3),h(3),statstemp(3,:)]=signrank(Compare_estimates.Fit8(:,3));
[p(4),h(4),statstemp(4,:)]=signrank(Compare_estimates.Fit8(:,4));
[p(5),h(5),statstemp(5,:)]=signrank(Compare_estimates.Fit8(:,5));
[p(6),h(6),statstemp(6,:)]=signrank(Compare_estimates.Fit8(:,6));

figure
clf
Vals = Compare_estimates.Fit8;
XPos = [1:6];

for k = 1:6
%     subplot(1,6,k)
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
    
%     StarPos=max(abs(X));
    StarPos=0.1;
    if p(k)<0.001
        text(k-0.22,StarPos,'***','FontSize',25)
    elseif p(k)<0.01
        text(k-0.22,StarPos,'**','FontSize',25)
    elseif p(k)<0.05
        text(k-0.12,StarPos,'*','FontSize',25)
    end
end

xlim([0 6.5])
ylabel('Estimates values, final model')
set(gca,'XTick',XPos,'XTickLabel',{'Pos','GT', 'TLS', 'CFT', 'Sig(Pos)xTLS', 'Sig(Pos)xSig(GT)'},'linewidth',1.5)
box off

% Only GT has an estimator significantly different than 0, there are some
% outliers that could account for this... 

%% Assess the correlation between two predictors 

% TLS and Position
for mousenum=1:length(Mouse_ALL)
    clear a b
    [a,b]=sort(TimeSinceLastShockArray.(Mouse_names{mousenum}));
    SortedPos.(Mouse_names{mousenum}) = PositionArray.(Mouse_names{mousenum})(b);
    SortedPos200(mousenum,:) = SortedPos.(Mouse_names{mousenum})(1:90);
    MSortedPos200(mousenum,:) = runmean_BM(SortedPos200(mousenum,:),2);
    SortedPos100(mousenum,:) = SortedPos.(Mouse_names{mousenum})(1:50);
    MSortedPos100(mousenum,:) = runmean_BM(SortedPos100(mousenum,:),1);
end

figure
Conf_Inter_TLS=nanstd(MSortedPos200)/sqrt(size(MSortedPos200,1));

shadedEB = shadedErrorBar(1:size(MSortedPos200,2), ...
    nanmean(MSortedPos200), Conf_Inter_TLS, 'k', 0); hold on;
shadedEB.mainLine.LineWidth = 4;
shadedEB.mainLine.Color = [[0 0.8  0]*0.8];
shadedEB.patch.FaceColor = [0.7 0.8 0.7];
shadedEB.edge(1).Color = [0.7 0.8 0.7];
shadedEB.edge(2).Color = [0.7 0.8 0.7];
makepretty
xlim([0 91])
ylim([0 1])
xlabel('Time since last shock recieved (s)');
ylabel('Linearized distance', 'FontSize', 13);
set(gca,'FontSize', 12, 'YTick',[0:0.2:1])

for mousenum=1:length(Mouse_ALL)
    clear a b corr
    [a,b]=sort(TimeSinceLastShockArray.(Mouse_names{mousenum}));
    corr = corrcoef(a(1:90), MSortedPos200(mousenum,:));
    PosTLScorr200(mousenum) = corr(1,2);
end

figure
Conf_Inter_TLS=nanstd(MSortedPos100)/sqrt(size(MSortedPos100,1));

shadedEB = shadedErrorBar(1:size(MSortedPos100,2), ...
    nanmean(MSortedPos100), Conf_Inter_TLS, 'k', 0); hold on;
shadedEB.mainLine.LineWidth = 4;
shadedEB.mainLine.Color = [[0 0.8  0]*0.8];
shadedEB.patch.FaceColor = [0.7 0.8 0.7];
shadedEB.edge(1).Color = [0.7 0.8 0.7];
shadedEB.edge(2).Color = [0.7 0.8 0.7];
makepretty
xlim([0 50])
ylim([0 1])
xlabel('Time since last shock recieved (s)');
ylabel('Linearized distance', 'FontSize', 13);
set(gca,'FontSize', 12, 'YTick',[0:0.2:1])

for mousenum=1:length(Mouse_ALL)
    clear a b corr
    [a,b]=sort(TimeSinceLastShockArray.(Mouse_names{mousenum}));
    corr = corrcoef(a(1:50), MSortedPos100(mousenum,:));
    PosTLScorr100(mousenum) = corr(1,2);
end

mean(PosTLScorr100)

%%% Mean corr coef between Pos and 200 s of TLS = 0.4727
%%% There is a low positive correlation 

% GT and CFT
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(GlobalTimeArray.(Mouse_names{mousenum}),Timefreezing_cumul.(Mouse_names{mousenum}))
end

Time_interpolation = linspace(0, 1, 800);
for mousenum=1:length(Mouse_ALL)
    Normdatacorr.CFT.(Mouse_names{mousenum}) = (Timefreezing_cumul.(Mouse_names{mousenum}) - min(Timefreezing_cumul.(Mouse_names{mousenum})))/(max(Timefreezing_cumul.(Mouse_names{mousenum}))-min(Timefreezing_cumul.(Mouse_names{mousenum})));
    Normdatacorr.GT.(Mouse_names{mousenum}) = (GlobalTimeArray.(Mouse_names{mousenum}) - min(GlobalTimeArray.(Mouse_names{mousenum})))/(max(GlobalTimeArray.(Mouse_names{mousenum}))-min(GlobalTimeArray.(Mouse_names{mousenum})));
    Normdatacorr.InterpCFT.(Mouse_names{mousenum}) = interp1(Normdatacorr.GT.(Mouse_names{mousenum}), Normdatacorr.CFT.(Mouse_names{mousenum}), Time_interpolation);
    NorminterpCFT(mousenum,:) = Normdatacorr.InterpCFT.(Mouse_names{mousenum});
end

figure
Conf_Inter_TLS=nanstd(NorminterpCFT)/sqrt(size(NorminterpCFT,1));

shadedEB = shadedErrorBar(1:size(NorminterpCFT,2), ...
    nanmean(NorminterpCFT), Conf_Inter_TLS, 'k', 0); hold on;
shadedEB.mainLine.LineWidth = 4;
shadedEB.mainLine.Color = [[0 0.8  0]*0.8];
shadedEB.patch.FaceColor = [0.7 0.8 0.7];
shadedEB.edge(1).Color = [0.7 0.8 0.7];
shadedEB.edge(2).Color = [0.7 0.8 0.7];
makepretty
xlabel('Time in conditioning (s)');
ylabel('Cumulative time spent freezing (s)', 'FontSize', 13);
set(gca,'FontSize', 12, 'YTick',[0:0.2:1])

for mousenum=1:length(Mouse_ALL)
    clear a b corr;
    corr = corrcoef(Normdatacorr.GT.(Mouse_names{mousenum}), Normdatacorr.CFT.(Mouse_names{mousenum}));
    GTCFTcorr(mousenum) = corr(1,2);
end

mean(GTCFTcorr)

%%% Mean corr coef between GT and CTF = 0.9585
%%% They are highly correlated, we should remove one of them

%% Remove GT or CFT

%% Int 10 = Int 8 without GT
%%% Fit the parameters for the GT transformation
for mousenum=1:length(Mouse_ALL)
    
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    
    for learnslope=0.001:stepslope:0.01 
        
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
                
            SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int10varNames = {'PositionArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int10_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
                (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int10varNames);
            Int10_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int10_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int10_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;
            
        end
        
        indslope=indslope+1;
        
    end

end

% Extract values that maximize the R2 deviance for each mouse
clear LP_max_mouse LP_max_mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            
            Compare_models_R2_learnp.chosen_interactions10_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions10_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT10.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions10_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT10.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT10.learn(:,mousenum));
            Best_Fitted_variables.INT10.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT10.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

%     LearnSlope: [0.0100 0.0100 0.0065 0.0060 0.0065 0.0015 0.0045 1.0000e-03 0.0015 0.0050 0.0100]
%     LearnPoint: [0.3000 0.8000 0.6000 0.5000 0.8000 0.7000 0.1000 0.6000 0.9000 0.9000 0.8000]

%%% After Baptiste Modified his code 
%     LearnSlope: [0.0090 1.0000e-03 0.0025 1.0000e-03 0.0065 0.0100 0.0045 0.0020 1.0000e-03 0.0045 0.0100]
%     LearnPoint: [0.9000 0.5000 0.7000 0.6000 0.8000 0.4000 0.1000 0.4000 0.9000 0.9000 0.5000]

% Fit10 : apply the fitted parameters to the GT
Fit10varNames = {'PositionArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit10SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit10SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT10.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT10.LearnPoint(mousenum)))));
    Fit10_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit10SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit10varNames);
    Fit10_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Cross validation
% INT10
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit10.(Mouse_names{mousenum}) = cvpartition(size(Fit10_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit10_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit10_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit10_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit10.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit10.(Mouse_names{mousenum}),i);
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit10.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit10.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit10.(Mouse_names{mousenum}), i);
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit10.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit10.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit10.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit10.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit10(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit10(mousenum)=struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit10.Train = corrcoef(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit10.Test = corrcoef(Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Value, Test_mdl.Fit10.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit10(mousenum)=Corr_coef.Fit10.Train(1,2);
    Rsquared_Test_Fit10(mousenum)=Corr_coef.Fit10.Test(1,2);
end
median(Mean_Rsquared_deviance_Train_Fit8)
median(Mean_Rsquared_deviance_Train_Fit10)

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit10' Rsquared_Test_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT10 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit10))


for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit10(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit10(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(3,4));
    Compare_significant_predictors.Fit10(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit10(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit10(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul    
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit10(:,1)...
    Compare_significant_predictors.Fit10(:,2) Compare_significant_predictors.Fit10(:,3) ...
    Compare_significant_predictors.Fit10(:,4) Compare_significant_predictors.Fit10(:,5) }, ...
    {},[1 2 3 4 5],...
    {'Pos','TLS', 'CFT', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit10<0.05));
for i=1:length(txt1)
text(i,1e-10,txt1(i), 'FontSize', 12)
end
xlim([0 6])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

% Predivctivity of the model
for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit10.(Mouse_names{mousenum}).Value)
    Array_Test.Fit10.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(i).table(:,6));
end
end

% figure with mean signal
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)),5)), hold on
    plot(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)))
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
%     leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,10];
%     legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([0 10])
%     set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
suptitle('INT10')

%% Int 11 = Int 8 without CFT
for mousenum=1:length(Mouse_ALL)
    
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    
    for learnslope=0.001:stepslope:0.01 
        
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
                
            SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int11varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int11_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
                (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int11varNames);
            Int11_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int11_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int11_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;
            
        end
        
        indslope=indslope+1;
        
    end

end

% Extract values that maximize the R2 deviance for each mouse
clear LP_max_mouse LP_max_mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            
            Compare_models_R2_learnp.chosen_interactions11_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions11_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT11.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions11_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT11.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT11.learn(:,mousenum));
            Best_Fitted_variables.INT11.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT11.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

%     LearnSlope: [0.0100 0.0100 0.0045 0.0065 0.0085 1.0000e-03 0.0100 0.0015 0.0015 0.0050 0.0100]
%     LearnPoint: [0.3000 0.8000 0.5000 0.5000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000]

% Fit11 : apply the fitted parameters to the GT
Fit11varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit11SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit11SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT11.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT11.LearnPoint(mousenum)))));
    Fit11_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit11SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit11varNames);
    Fit11_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit11_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Cross validation
% INT11
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit11.(Mouse_names{mousenum}) = cvpartition(size(Fit11_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit11_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit11_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit11_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit11.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit11.(Mouse_names{mousenum}),i);
        Array_Train.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit11.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit11.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit11.(Mouse_names{mousenum}), i);
        Array_Test.Fit11.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit11.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit11.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit11.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit11.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit11.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit11.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit11.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit11(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit11(mousenum)=struct2array(Rsquared.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit11.Train = corrcoef(table2array(Array_Train.Fit11.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit11.Test = corrcoef(Array_Test_frequencies.Fit11.(Mouse_names{mousenum}).Value, Test_mdl.Fit11.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit11(mousenum)=Corr_coef.Fit11.Train(1,2);
    Rsquared_Test_Fit11(mousenum)=Corr_coef.Fit11.Test(1,2);
end

median(Mean_Rsquared_deviance_Train_Fit10)
median(Mean_Rsquared_deviance_Train_Fit11)

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit11' Rsquared_Test_Fit11'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT11 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit11))

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit11(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit11(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table(3,4));
    Compare_significant_predictors.Fit11(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit11(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit11(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul    
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit11(:,1)...
    Compare_significant_predictors.Fit11(:,2) Compare_significant_predictors.Fit11(:,3) ...
    Compare_significant_predictors.Fit11(:,4) Compare_significant_predictors.Fit11(:,5) }, ...
    {},[1 2 3 4 5],...
    {'Pos','GT', 'TLS', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit11<0.05));
for i=1:length(txt1)
text(i,1e-11,txt1(i), 'FontSize', 12)
end
xlim([0 6])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

% Predivctivity of the model
for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit11.(Mouse_names{mousenum}).Value)
    Array_Test.Fit11.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit11.(Mouse_names{mousenum}).Testset(i).table(:,6));
end
end

figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit11.(Mouse_names{mousenum}).Trainset(1).table(:,6)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit11.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit11.(Mouse_names{mousenum}).Trainset(1).table(:,6)),5)), hold on
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
%     leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,10];
%     legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
%     ylim([2.5 7])
%     set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
suptitle('INT11')

%% Conclusion 
% INT10 seems to better follow the global tendencies of the data (model
% corresponding to INT8 without GT)

%% Int 12 = Int 10 with inverse sigmoid on GT
%%% Fit the parameters for the GT transformation

% Fit12 : apply the fitted parameters to the GT
Fit12varNames = {'PositionArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit12InvSigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit12InvSigGlobalTimeArray.(Mouse_names{mousenum}) = 1 - 1./(1+exp(-Best_Fitted_variables.INT10.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT10.LearnPoint(mousenum)))));
    Fit12_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit12InvSigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit12varNames);
    Fit12_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit12_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Cross validation
% INT12
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit12.(Mouse_names{mousenum}) = cvpartition(size(Fit12_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit12_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit12_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit12_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit12.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit12.(Mouse_names{mousenum}),i);
        Array_Train.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit12.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit12.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit12.(Mouse_names{mousenum}), i);
        Array_Test.Fit12.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit12.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit12.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit12.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit12.(Mouse_names{mousenum}).Testset(:,indset).table(:,6));
        [Test_mdl.Fit12.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit12.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit12.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train
for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit12(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit12(mousenum)=struct2array(Rsquared.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit12.Train = corrcoef(table2array(Array_Train.Fit12.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit12.Test = corrcoef(Array_Test_frequencies.Fit12.(Mouse_names{mousenum}).Value, Test_mdl.Fit12.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit12(mousenum)=Corr_coef.Fit12.Train(1,2);
    Rsquared_Test_Fit12(mousenum)=Corr_coef.Fit12.Test(1,2);
end
median(Mean_Rsquared_deviance_Train_Fit12)

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit12' Rsquared_Test_Fit12'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT12 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit12))


for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit12(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit12(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table(3,4));
    Compare_significant_predictors.Fit12(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit12(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit12(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul    
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit12(:,1)...
    Compare_significant_predictors.Fit12(:,2) Compare_significant_predictors.Fit12(:,3) ...
    Compare_significant_predictors.Fit12(:,4) Compare_significant_predictors.Fit12(:,5) }, ...
    {},[1 2 3 4 5],...
    {'Pos','TLS', 'CFT', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit12<0.05));
for i=1:length(txt1)
text(i,1e-12,txt1(i), 'FontSize', 12)
end
xlim([0 6])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

% Predivctivity of the model
for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit12.(Mouse_names{mousenum}).Value)
    Array_Test.Fit12.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit12.(Mouse_names{mousenum}).Testset(i).table(:,6));
end
end

% figure with mean signal
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit12.(Mouse_names{mousenum}).Trainset(1).table(:,6)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit12.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit12.(Mouse_names{mousenum}).Trainset(1).table(:,6)),5)), hold on
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
%     leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,12];
%     legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
%     ylim([2.5 7])
%     set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
suptitle('INT12')

%% Int 13 = Int 8 without GT
%%% Fit the parameters for the GT transformation
for mousenum=1:length(Mouse_ALL)
    
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    
    for learnslope=0.001:stepslope:0.01 
        
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
                
            SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int13varNames = {'TimeSinceLastShockArray', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int13_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = ...
                table(TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int13varNames);
            Int13_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int13_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int13_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;
            
        end
        
        indslope=indslope+1;
        
    end

end

% Extract values that maximize the R2 deviance for each mouse
clear LP_max_mouse LP_max_mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            
            Compare_models_R2_learnp.chosen_interactions13_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions13_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT13.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions13_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT13.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT13.learn(:,mousenum));
            Best_Fitted_variables.INT13.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT13.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/13;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

%     LearnSlope: [0.0055 0.0100 0.0050 1.0000e-03 0.0100 0.0100 1.0000e-03 1.0000e-03 0.0030 0.0055 0.0055]
%     LearnPoint: [0.1538 0.0769 0.3846 0.3077 0.4615 0.6154 0.4615 0.3077 0.1538 0.6923 0.2308]

%%% After Batpiste modified the function
%     LearnSlope: [0.0040 0.0015 0.0015 1.0000e-03 0.0100 0.0100 0.0085 1.0000e-03 0.0050 0.0100 0.0025]
%     LearnPoint: [0.0769 0.3846 0.4615 0.0769 0.4615 0.3077 0.5385 0.3077 0.0769 0.1538 0.2308]

% Fit13 : apply the fitted parameters to the GT
Fit13varNames = {'TimeSinceLastShockArray', 'SigPositionxFit13SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit13SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT13.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT13.LearnPoint(mousenum)))));
    Fit13_GLMArray_mouse.(Mouse_names{mousenum}) = ...
        table(TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit13SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit13varNames);
    Fit13_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit13_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Cross validation
% INT13
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit13.(Mouse_names{mousenum}) = cvpartition(size(Fit13_GLMArray_mouse.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit13_GLMArray_mouse.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit13_GLMArray_mouse.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit13_GLMArray_mouse.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit13.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit13.(Mouse_names{mousenum}),i);
        Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit13.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit13.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit13.(Mouse_names{mousenum}), i);
        Array_Test.Fit13.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit13.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit13.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit13.(Mouse_names{mousenum}).Testset(:,indset).table(:,3));
        [Test_mdl.Fit13.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit13.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit13.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit13(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit13(mousenum)=struct2array(Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit13.Train = corrcoef(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit13.Test = corrcoef(Array_Test_frequencies.Fit13.(Mouse_names{mousenum}).Value, Test_mdl.Fit13.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit13(mousenum)=Corr_coef.Fit13.Train(1,2);
    Rsquared_Test_Fit13(mousenum)=Corr_coef.Fit13.Test(1,2);
end
median(Mean_Rsquared_deviance_Train_Fit8)
median(Mean_Rsquared_deviance_Train_Fit13)

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit13' Rsquared_Test_Fit13'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT13 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit13))


for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit13(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit13(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table(3,4));
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit13(:,1)...
    Compare_significant_predictors.Fit13(:,2) }, ...
    {},[1 2 ],...
    {'TLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit13<0.05));
for i=1:length(txt1)
text(i,1e-13,txt1(i), 'FontSize', 12)
end
xlim([0 3])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

% Predivctivity of the model
for mousenum=1:length(Mouse_ALL)
for i=1:length(Test_mdl.Fit13.(Mouse_names{mousenum}).Value)
    Array_Test.Fit13.(Mouse_names{mousenum}).ALL(i) = table2array(Array_Test.Fit13.(Mouse_names{mousenum}).Testset(i).table(:,3));
end
end

% figure with mean signal
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)),5)), hold on
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
%     leg=legend({'Train data', 'Fitted value', 'Mean signal'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,13];
%     legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
%     ylim([2.5 7])
%     set(gca, 'FontSize', 14, 'Ytick', [3:1:7])
end
suptitle('INT13')


%% Try to remove the blocked epochs and see if we still predict as well

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

for mousenum=1:length(Mouse_ALL)
    for i=1:6
    Epoch2.Cond{mousenum,i} = Epoch1.Cond{mousenum,i}-BlockedEpoch.Cond.(Mouse_names{mousenum}); %timepoints of fz in shock zone without being blocked
    end
end

for mousenum=1:length(Mouse_ALL)
    Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    i=1;
    clear ep ind_to_use
    
    for ep=1:length(Start(Epoch2.Cond{mousenum, 3}))
       ShockTime_Fz_Distance_pre.NotBlocked.(Mouse_names{mousenum}) = Start(Epoch2.Cond{mousenum, 2})-Start(subset(Epoch2.Cond{mousenum, 3},ep));

       ShockTime_Fz_Distance.NotBlocked.(Mouse_names{mousenum}) = abs(max(ShockTime_Fz_Distance_pre.NotBlocked.(Mouse_names{mousenum})(ShockTime_Fz_Distance_pre.NotBlocked.(Mouse_names{mousenum})<0))/1e4);
       if isempty(ShockTime_Fz_Distance.NotBlocked.(Mouse_names{mousenum})); ShockTime_Fz_Distance.NotBlocked.(Mouse_names{mousenum})=NaN; end

       for bin=1:ceil((sum(Stop(subset(Epoch2.Cond{mousenum, 3},ep))-Start(subset(Epoch2.Cond{mousenum, 3},ep)))/1e4)/2)-1 % bin of 2s or less

           SmallEpoch.NotBlocked.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch2.Cond{mousenum, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch2.Cond{mousenum, 3},ep))+2*(bin)*1e4);
           PositionArray.NotBlocked.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.NotBlocked.(Mouse_names{mousenum}))));
           OB_FrequencyArray.NotBlocked.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.NotBlocked.(Mouse_names{mousenum}))));       
           GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})(i) = Start(subset(Epoch2.Cond{mousenum, 3},ep))/1e4+2*(bin-1);       
           TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.NotBlocked.(Mouse_names{mousenum})+2*(bin-1);       
           TimepentFreezing.NotBlocked.(Mouse_names{mousenum})(i) = 2*(bin-1);
           i=i+1;
       end

       ind_to_use = ceil((sum(Stop(subset(Epoch2.Cond{mousenum, 3},ep))-Start(subset(Epoch2.Cond{mousenum, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice

       SmallEpoch.NotBlocked.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch2.Cond{mousenum, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch2.Cond{mousenum, 3},ep))); % last small epoch is a bin with time < 2s
       PositionArray.NotBlocked.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.NotBlocked.(Mouse_names{mousenum}))));
       OB_FrequencyArray.NotBlocked.(Mouse_names{mousenum})(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.NotBlocked.(Mouse_names{mousenum}))));
       GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})(i) = Start(subset(Epoch2.Cond{mousenum, 3},ep))/1e4+2*(ind_to_use);
       TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.NotBlocked.(Mouse_names{mousenum})+2*(ind_to_use);
       try; TimepentFreezing.NotBlocked.(Mouse_names{mousenum})(i) = 2*bin; catch; TimepentFreezing.NotBlocked.(Mouse_names{mousenum})(i) = 0; end

       i=i+1;

    end
    
    Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})(1) = 0;
    for j=2:length(TimepentFreezing.NotBlocked.(Mouse_names{mousenum}))
        if TimepentFreezing.NotBlocked.(Mouse_names{mousenum})(j) == 0
           Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})(j) = Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})(j-1);
        else
           Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})(j) = Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})(j-1) + 2;
        end
    end

    TotalArray_mouse.NotBlocked.(Mouse_names{mousenum}) = [OB_FrequencyArray.NotBlocked.(Mouse_names{mousenum})' PositionArray.NotBlocked.(Mouse_names{mousenum})' GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})' TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})' TimepentFreezing.NotBlocked.(Mouse_names{mousenum})' Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})'];

end 

% Fitted parameters on train and GLM array

% Int 8
for mousenum=1:length(Mouse_ALL)
    
    SigPositionArray.NotBlocked.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.NotBlocked.(Mouse_names{mousenum})]-0.5)));
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.NotBlocked.(Mouse_names{mousenum}));
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    
    for learnslope=0.001:stepslope:0.01 
        
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
                
            SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int8varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = table(PositionArray.NotBlocked.(Mouse_names{mousenum})',...
                GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})', TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})', Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})',...
                (SigPositionArray.NotBlocked.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})'),...
                (SigPositionArray.NotBlocked.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.NotBlocked.(Mouse_names{mousenum})', 'VariableNames', Int8varNames);
            Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = rmmissing(Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}));

            chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = fitglm(Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = Output_GLM.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;
            
        end
        
        indslope=indslope+1;
        
    end

end

% Extract values that maximize the R2 deviance for each mouse
clear LP_max_mouse LP_max_mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            
            Compare_models_R2_learnp.chosen_interactions8_mdl.NotBlocked.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).NotBlocked.(Mouse_names{mousenum});
            [MaxR2_mouse.INT8.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions8_mdl.NotBlocked.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT8.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT8.learn(:,mousenum));
            Best_Fitted_variables.INT8.NotBlocked.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT8.NotBlocked.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

% Create a structure with these parameters

Best_Fitted_variables.INT8.NotBlocked.LearnSlope = [0.0070 0.0015 0.0100 0.0025 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010 0.0100];
Best_Fitted_variables.INT8.NotBlocked.LearnPoint = [0.2000 0.7000 0.3000 0.9000 0.2000 0.2000 0.8000 0.2000 0.1000 0.9000 0.5000];

% INT8
Fit8varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit8SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.NotBlocked.(Mouse_names{mousenum}));
    SigPositionArray.NotBlocked.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.NotBlocked.(Mouse_names{mousenum})]-0.5)));
    Fit8SigGlobalTimeArray.NotBlocked.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT8.LearnSlope(mousenum)*([GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT8.LearnPoint(mousenum)))));
    Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}) = table( PositionArray.NotBlocked.(Mouse_names{mousenum})', ...
        GlobalTimeArray.NotBlocked.(Mouse_names{mousenum})', TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})', Timefreezing_cumul.NotBlocked.(Mouse_names{mousenum})',...
        (SigPositionArray.NotBlocked.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.NotBlocked.(Mouse_names{mousenum})'), ...
        (SigPositionArray.NotBlocked.(Mouse_names{mousenum})').*(Fit8SigGlobalTimeArray.NotBlocked.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.NotBlocked.(Mouse_names{mousenum})', 'VariableNames',Fit8varNames);
    Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}) = rmmissing(Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}));
end 

% Cross validation of the GLMs : train and test
% Create training and testing data set (KFold cross validation with K=N of
% observations per mice, train on N-1 and validate on 1 N times) 

% INT8
for mousenum=1:length(Mouse_ALL)
    CV_partition_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}) = cvpartition(size(Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}),1),...
        'KFold', size(Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}),1)); 
    
    clear tbl
    tbl=Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum});
    indset=1;
    for i=1:size(Fit8_GLMArray_mouse.NotBlocked.(Mouse_names{mousenum}),1)
        ind_Train_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset) = training(CV_partition_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}),i);
        Array_Train.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = tbl(ind_Train_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset),:);
        ind_Test_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}).Testset(:,indset) = test(CV_partition_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}), i);
        Array_Test.Fit8.NotBlocked.(Mouse_names{mousenum}).Testset(:,indset).table = tbl(ind_Test_mouse.Fit8.NotBlocked.(Mouse_names{mousenum}).Testset(:,indset),:);
        indset=indset+1;
    end
end

for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = fitglm(Array_Train.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table;
        Rsquared.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table.Deviance;
        LR.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table = Output_GLM.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table.Coefficients;
        
        Array_Test_frequencies.Fit8.NotBlocked.(Mouse_names{mousenum}).Value(indset,:) = table2array(Array_Test.Fit8.NotBlocked.(Mouse_names{mousenum}).Testset(:,indset).table(:,7));
        [Test_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Value(indset,:), Test_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).CI(indset,:)] = predict(Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(:,indset).table,Array_Test.Fit8.NotBlocked.(Mouse_names{mousenum}).Testset(:,indset).table);
        indset=indset+1;
    end
end

%% Evaluate models and GOFs on train

for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit8_NotBlocked(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit8_NotBlocked(mousenum)=struct2array(Rsquared.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit8.NotBlocked.Train = corrcoef(table2array(Array_Train.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit8.NotBlocked.Test = corrcoef(Array_Test_frequencies.Fit8.NotBlocked.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit8_NotBlocked(mousenum)=Corr_coef.Fit8.NotBlocked.Train(1,2);
    Rsquared_Test_Fit8_NotBlocked(mousenum)=Corr_coef.Fit8.NotBlocked.Test(1,2);
end

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit8_NotBlocked' Rsquared_Test_Fit8_NotBlocked'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT8 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
    Compare_significant_predictors.Fit8_NotBlocked(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.NotBlocked.(Mouse_names{mousenum}).Trainset(1).table(7,4));%
    
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit8_NotBlocked(:,1)...
    Compare_significant_predictors.Fit8_NotBlocked(:,2) Compare_significant_predictors.Fit8_NotBlocked(:,3) ...
    Compare_significant_predictors.Fit8_NotBlocked(:,4) Compare_significant_predictors.Fit8_NotBlocked(:,5) ...
    Compare_significant_predictors.Fit8_NotBlocked(:,6)}, ...
    {},[1 2 3 4 5 6],...
    {'Pos','GT', 'TLS', 'CFT', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit8_NotBlocked<0.05));
for i=1:length(txt1)
text(i,1e-7,txt1(i), 'FontSize', 12)
end
xlim([0 7])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

%% Compare two models

% GOF
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit8_NotBlocked' Rsquared_deviance_Train_Fit8'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Not Blocked','Blocked'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT8 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

%%% No significative difference between the median values

%% Look at the distribution of the predictors

% Position
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    histogram(PositionArray.NotBlocked.(Mouse_names{mousenum}), 'BinWidth',0.02)
    xlim([0 1])
end

% We observe a vast majority of safe side positions, which can explain
%%% the least importance of Pos as a predictor, and matches our hypothesis
%%% that lead to the transformation of the position : the difference in
%%% breathing frequency between two positions on the safe side is not as
%%% important as the one between two position son the shock side

% The blocked epochs and therefore the shock side freezing has to be taken
%%% into account to be able to assess the influence of our predictors
























