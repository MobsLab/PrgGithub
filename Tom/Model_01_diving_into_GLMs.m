%% Objectives of this code

% First assessment of the GLMs 
% Analysis done for a mouse then for all mice (after assessing their
% learning by looking at the sime spent in shock zone during test post)

% Visualize the data that will be used for the GLMs
% Chose the appropriate link function by looking at frequency distribution
% Fit different models (linear, interactions) 
% Try the tranformation of the time since the lask shock in a neg exp
% Examine the quality of the models (diagnostics)
% Test the predictivity of the model on 10% of observations for a given
% mouse and from one mouse to another

%% ALL mice
Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

%% Generate data for the GLM (from Data_For_Model_BM.m)
Session_type={'Cond'};
% generate all data required for analyses
[TSD_DATA.(Session_type{1}) , Epoch1.(Session_type{1}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse_ALL,lower(Session_type{1}),'respi_freq_BM','ripples','linearposition');

% Total array containing OB_FrequencyArray, PositionArray, GlobalTimeArray,
% TimeSinceLastShockArray, TimepentFreezing for a mouse
i=1;
for ep=1:length(Start(Epoch1.Cond{1, 3}))
   ShockTime_Fz_Distance_pre = Start(Epoch1.Cond{1, 2})-Start(subset(Epoch1.Cond{1, 3},ep));
   ShockTime_Fz_Distance = abs(max(ShockTime_Fz_Distance_pre(ShockTime_Fz_Distance_pre<0))/1e4);
   if isempty(ShockTime_Fz_Distance); ShockTime_Fz_Distance=NaN; end
       
   for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1 % bin of 2s or less

       SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin)*1e4);
       PositionArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
       OB_FrequencyArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));       
       GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(bin-1);       
       TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(bin-1);       
       TimepentFreezing(i) = 2*(bin-1);       
       i=i+1;
   end
   
   ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice
   
   SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{1, 3},ep))); % last small epoch is a bin with time < 2s
   PositionArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
   OB_FrequencyArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));
   GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(ind_to_use);
   TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(ind_to_use);
   try; TimepentFreezing(i) = 2*bin; catch; TimepentFreezing(i) = 0; end

   i=i+1;
   
end

TotalArray_mouse = [OB_FrequencyArray' PositionArray' GlobalTimeArray' TimeSinceLastShockArray' TimepentFreezing'];

%% Visualize the data for a mouse

load('/home/gruffalo/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_30112023.mat')

AMouse = DATA.M688;
OB_FrequencyArray = AMouse(:,1);
PositionArray = AMouse(:,2);
GlobalTimeArray = AMouse(:,3);
TimeSinceLastShockArray = AMouse(:,4);
TimepentFreezing = AMouse(:,5);

% Position across time
figure;
plot(AMouse(:,3)*0.2,AMouse(:,2), '.')
xlabel('Time (s)')
ylabel('Linearized distance')

% OB frequency across time
figure;
plot(AMouse(:,3)*0.2,AMouse(:,1), '-')
xlabel('Time (s)')
ylabel('Frequency (Hz)')

% Position versus time since last shock : 
figure;
plot(AMouse(:,4),AMouse(:,2), '.')
xlabel('Time since last shock (s)')
ylabel('Linearized distance')

% Time spent freezing versus position : more freezing on the safe side
figure;
plot(AMouse(:,2),AMouse(:,5), '.')
xlabel('Linearized distance')
ylabel('Time spent freezing (s)')

% Time spent freezing across time
figure;
plot(AMouse(:,3)*0.2,AMouse(:,5), '.')
xlabel('Time (s)')
ylabel('Time spent freezing (s)')

% OB frequency versus time spent freezing
figure;
plot(AMouse(:,5),AMouse(:,1), '.')
xlabel('Time (s)')
ylabel('Frequency (Hz)')

%% A/ Bio inspired model 

% code done in the first days, attempt to reproduce the figure generated
% with TryALittleModelUmaze.m to fit the parameters but quite a failure

% see next lines of Data_For_Model_BM.m to continue (gradient descent)

% Visualize the 10s freezing period at different positions and global times depending on time since shock

% Seperate episodes of freezing
ind = findall(TotalArray_mouse(:,5)==0)
for i=1:length(ind)-1
    TotalArray_fz{i} = TotalArray_mouse(ind(i):ind(i+1)-1,:) %check if it works
end

ind = find(TotalArray_mouse(:,5)==0);

TotalArray_new=[];
for i=1:length(ind)-1
    TotalArray_new{i} = TotalArray_mouse(ind(i):ind(i+1)-1,:);
end


% Subset data in different time bins (to represent the evolution of the mice's behaviour across time)

Timepoints = (1:64:length(TotalArray_mouse(:,3)));
for i=1:length(Timepoints)-1
    Timepoints(i)
    Timepoints(i+1)
    Timebin=TotalArray_mouse(Timepoints(i):Timepoints(i+1),:)
    figure
    plot(Timebin(:,5),Timebin(:,1))
end


%% B/ GLM

% Create table for a mouse
varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimepentFreezing', 'OB_FrequencyArray'};
GLMArray_mouse_2 = table( PositionArray, GlobalTimeArray, TimeSinceLastShockArray, TimepentFreezing, OB_FrequencyArray, 'VariableNames',varNames);
GLMArray_mouse = rmmissing(GLMArray_mouse);

% Take a look at the distribution of the response vairable
figure; 
nbins=25;
histogram(OB_FrequencyArray,nbins) %looks like an inverse gaussian or a gamma distribution
xlabel('OB frequency', 'FontSize', 25)
ylabel('count', 'FontSize', 25)

%% 1/ Create different models

linear_mdl = fitglm(GLMArray_mouse_2,'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');

figure; 
plot(GlobalTimeArray, linear_mdl.Fitted{:,1}, GlobalTimeArray, OB_FrequencyArray)

betas = linear_mdl.Coefficients.Estimate(2:5);
pred_diff = GLMArray_mouse_2{:,:}(:,1:4)*betas + 3.958909380055422;

for i=1:4
    tableauvaleur
tableauvaleur = 

linear_mdl2 = fitglm(GLMArray_mouse,'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
linear_mdl_out = removeTerms(linear_mdl, 'TimeSinceLastShockArray + GlobalTimeArray');
Output_GLM.linear_mdl.(Mouse_names{1}) = linear_mdl;
Table_estimates_pval.linear_mdl.(Mouse_names{1}) = Output_GLM.linear_mdl.(Mouse_names{1}).Coefficients;
% Here our model looks like 1/OB_freq = B0 + X1B1 + X2B2 + X3B3 + X4B4
% The 'real' parameters are thus 1/B
% Estimated Dispersion: 0.093
% significiant parameters : Position and time spent freezing

interactions_mdl = fitglm(GLMArray_mouse,'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
Output_GLM.interactions_mdl.(Mouse_names{1}) = interactions_mdl;
Table_estimates_pval.interactions_mdl.(Mouse_names{1}) = Output_GLM.interactions_mdl.(Mouse_names{1}).Coefficients;
% Here our model looks like 1/OB_freq = linear + all pairs of X times Bn
% Estimated Dispersion: 0.0928
% PositionArray:TimepentFreezing is significant and
% PositionArray:GlobalTimeArray is almost significant (0.05053)

% NB : parrallel between GLM parameters and linear model parameters
% sqrt(deviation) = residual standard error, deviation = mean square error 

%% Transform some data 

ExpnegTimeSinceLastShockArray = exp(-TimeSinceLastShockArray);

TransvarNames = {'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'TimepentFreezing', 'OB_FrequencyArray'};
GLMTransformedArray_mouse = table( PositionArray', GlobalTimeArray', ExpnegTimeSinceLastShockArray', TimepentFreezing', OB_FrequencyArray', 'VariableNames', TransvarNames);
GLMTransformedArray_mouse = rmmissing(GLMTransformedArray_mouse);

TransTST_linear_mdl = fitglm(GLMTransformedArray_mouse,'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
TransTST_interactions_mdl = fitglm(GLMTransformedArray_mouse,'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 

Output_GLM.TransTST_linear_mdl.(Mouse_names{1}) = TransTST_linear_mdl;
Table_estimates_pval.TransTST_linear_mdl.(Mouse_names{1}) = Output_GLM.TransTST_linear_mdl.(Mouse_names{1}).Coefficients;
Output_GLM.TransTST_interactions_mdl.(Mouse_names{1}) = TransTST_interactions_mdl;
Table_estimates_pval.TransTST_interactions_mdl.(Mouse_names{1}) = Output_GLM.TransTST_interactions_mdl.(Mouse_names{1}).Coefficients;

%% I think the below models are not that salient in our case
% purequadratic_mdl = fitglm(GLMArray_mouse,'purequadratic','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
% % Estimated Dispersion: 0.0936
% % Only time spent freezing is significant, its ² is almost
% 
% quadratic_mdl = fitglm(GLMArray_mouse,'quadratic','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
% % Estimated Dispersion: 0.0934
% % PositionArray:TimepentFreezing, PositionArray:GlobalTimeArray 
% % and TimepentFreezing^2 are significant
% 
% polynomial_mdl = fitglm(GLMArray_mouse,'poly1112','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal')
% % Estimated Dispersion: 0.0929
% PositionArray:TimepentFreezing and
% TimepentFreezing^2 are significant
% PositionArray:GlobalTimeArray is almost significant (0.063056)

% Shloud I try a fitting model with the OB bio inspired formula?

%% 2/ Examine the quality of the models (diagnostics)

clear model_to_examine
model_to_examine = TransGT_linear_mdl; % linear_mdl, TransGT_linear_mdl, interactions_mdl, TransTST_interactions_mdl

% Prediction Slice plots : see how well the model fits the data

% The green line in each plot represents the predicted response values as a function of a single predictor variable, 
% with the other predictor variables held constant. The red dotted lines are the 95% confidence bounds. 
% The y-axis label includes the predicted response value and the corresponding confidence bound for the point selected by the vertical and horizontal lines. 
% The x-axis label shows the predictor variable name and the predictor value for the selected point.

plotSlice(model_to_examine)

% Leverage plot : understand the effect of each observation, remove outliers

% The leverage of each point on the fit is higher for points with relatively extreme predictor values (in either direction) 
% and low for points with average predictor values. In examples with multiple predictors and with points not ordered by predictor value, 
% this plot can help you identify which observations have high leverage (high influence on the fitted model) 
% because they are outliers as measured by their predictor values.

figure; plotDiagnostics(model_to_examine)

% Residuals — Model Quality for Training Data, test model assumptions

% There are several residual plots to help you discover errors, outliers, or correlations in the model or data. 
% The simplest residual plots are the default histogram plot, which shows the range of the residuals and their frequencies, 
% and the probability plot, which shows how the distribution of the residuals compares to a normal distribution with matched variance.

figure; plotResiduals(model_to_examine) % assumed to follow a gamma distribution 
figure; plotResiduals(model_to_examine, 'fitted') % check wheter there is evidence of nonlinearity between residuals and fitted values
% figure; plotResiduals(model_to_examine, 'probability')

devianceTest(model_to_examine)

%% 3/ Test the predictivity of the model

% Generate the two datasets
Train_ind = randsample(size(GLMArray_mouse, 1), ceil(0.9*(size(GLMArray_mouse, 1))));
Test_ind = ~ismember((1:size(GLMArray_mouse, 1))', Train_ind);

TrainGLMArray_mouse = GLMArray_mouse(Train_ind, :);
TestGLMArray_mouse = GLMArray_mouse(Test_ind, :);

% sum(ismember(TrainGLMArray_mouse, TestGLMArray_mouse))

Train_linear_mdl = fitglm(TrainGLMArray_mouse,'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
[Predicted_linear_mdl, Predicted_CI] = predict(Train_linear_mdl, TestGLMArray_mouse);

% If 'Prediction' is 'curve', then predict predicts confidence bounds for f(Xnew), the fitted responses at Xnew.
% If 'Prediction' is 'observation', then predict predicts confidence bounds for y, the response observations at Xnew.
figure; plot(Predicted_linear_mdl, 'x'), hold on, plot(table2array(TestGLMArray_mouse(:,5)), 'o')
ylim([0 9])
makepretty
legend('Predictions', 'Data')

mousenum=1

%% Run the same models for all mice

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to
Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

% 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394

%% Take a look at the test post session to assess the learning of mice

Session_type={'TestPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TP_TSD_DATA.(Session_type{sess}) , EpochTP.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

for mousenum=1:length(Mouse_ALL);
    Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    Percent_Time.Shock.(Mouse_names{mousenum}) = 100*(sum(DurationEpoch(EpochTP.TestPost{mousenum,5}))+ sum(DurationEpoch(EpochTP.TestPost{mousenum,7})))/sum(DurationEpoch(EpochTP.TestPost{mousenum,1}));
    Percent_Time.Safe.(Mouse_names{mousenum}) = 100*(sum(DurationEpoch(EpochTP.TestPost{mousenum,6}))+ sum(DurationEpoch(EpochTP.TestPost{mousenum,8})))/sum(DurationEpoch(EpochTP.TestPost{mousenum,1}));
    Percent_Time_comparison(mousenum,1) = Percent_Time.Shock.(Mouse_names{mousenum});
    Percent_Time_comparison(mousenum,2) = Percent_Time.Safe.(Mouse_names{mousenum});
end

figure
[Time_pval , Time_stats_out]= MakeSpreadAndBoxPlot3_SB({Percent_Time_comparison(:,1) Percent_Time_comparison(:,2)},{[1 0 0],[0 0 1]},[1 2],{'Shock','Safe'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('% time in Shock and Safe zone during Post Cond session', 'FontSize', 25);

% Which mice we should exclude and based on what criterion? 

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

%% B/ GLM

%% 1/ Create different models

% Create table for a mouse
varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'TimepentFreezing', 'Timefreezing_cumul', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', TimepentFreezing.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',varNames);
    GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(GLMArray_mouse.(Mouse_names{mousenum}));
end 

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

% Linear model without interactions 
for mousenum=1:length(Mouse_ALL)
    linear_mdl.(Mouse_names{mousenum}) = fitglm(GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.linear_mdl.(Mouse_names{mousenum}) = linear_mdl.(Mouse_names{mousenum});
    Rsquared.linear_mdl.(Mouse_names{mousenum}) = linear_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;  
    Deviance.linear_mdl.(Mouse_names{mousenum}) = linear_mdl.(Mouse_names{mousenum}).Deviance;
    LR.linear_mdl.(Mouse_names{mousenum}) = linear_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.linear_mdl.(Mouse_names{mousenum}) = Output_GLM.linear_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.linear(mousenum,1) = table2array(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.linear(mousenum,2) = table2array(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.linear(mousenum,3) = table2array(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.linear(mousenum,4) = table2array(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum})(5,4));%T freezing
    Compare_significant_predictors.linear(mousenum,5) = table2array(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum})(6,4));%T freezing cumul
end

for mousenum=1:length(Mouse_ALL)
    linear_mdl_out.(Mouse_names{mousenum}) = removeTerms(linear_mdl.(Mouse_names{mousenum}), 'TimepentFreezing + Timefreezing_cumul');
    Output_GLM.linear_mdl_out.(Mouse_names{mousenum}) = linear_mdl_out.(Mouse_names{mousenum});
    Rsquared.linear_mdl_out.(Mouse_names{mousenum}) = linear_mdl_out.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.linear_mdl_out.(Mouse_names{mousenum}) = linear_mdl_out.(Mouse_names{mousenum}).Deviance;
    LR.linear_mdl_out.(Mouse_names{mousenum}) = linear_mdl_out.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum}) = Output_GLM.linear_mdl_out.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.linear_out(mousenum,1) = table2array(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.linear_out(mousenum,2) = table2array(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.linear_out(mousenum,3) = table2array(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum})(4,4));%T since last shock
end
% Here our model looks like 1/OB_freq = B0 + X1B1 + X2B2 + X3B3 + X4B4
% The 'real' parameters are thus 1/B

% Compare the two linear nested models
for mousenum=1:length(Mouse_ALL)
    h_linear_LRT.(Mouse_names{mousenum}) = lratiotest(LR.linear_mdl.(Mouse_names{mousenum}), LR.linear_mdl_out.(Mouse_names{mousenum}),2);
end

figure
[Linear_pval , Linear_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.linear(:,1) Compare_significant_predictors.linear(:,2) Compare_significant_predictors.linear(:,3) Compare_significant_predictors.linear(:,4) Compare_significant_predictors.linear(:,5)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1], [.5 0.7 0.5]},[1 2 3 4 5],{'Position','Global Time', 'Time Since Last Shock', 'Time spent freezing', 'Cumul time freezing'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

figure
[Linear_pval_out , Linear_stats_out]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.linear_out(:,1) Compare_significant_predictors.linear_out(:,2) Compare_significant_predictors.linear_out(:,3) },{[1 0 0],[0 0 1],[1 0.7 0], },[1 2 3],{'Position','Global Time', 'Time Since Last Shock'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

% Linear model with interactions
for mousenum=1:length(Mouse_ALL)
    interactions_mdl.(Mouse_names{mousenum}) = fitglm(GLMArray_mouse.(Mouse_names{mousenum}),'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum});
    Rsquared.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).Deviance;
    LR.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum}) = Output_GLM.interactions_mdl.(Mouse_names{mousenum}).Coefficients;
end
% Here our model looks like 1/OB_freq = linear + all pairs of X times Bn

% Linear model with some interactions : specify the pairs we want to use 
IntvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',IntvarNames);
    Int_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int_GLMArray_mouse.(Mouse_names{mousenum}));
end 

for mousenum=1:length(Mouse_ALL)
    chosen_interactions_mdl.(Mouse_names{mousenum}) = fitglm(Int_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.chosen_interactions_mdl.(Mouse_names{mousenum}) = chosen_interactions_mdl.(Mouse_names{mousenum});
    Rsquared.chosen_interactions_mdl.(Mouse_names{mousenum}) = chosen_interactions_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.chosen_interactions_mdl.(Mouse_names{mousenum}) = chosen_interactions_mdl.(Mouse_names{mousenum}).Deviance;
    LR.chosen_interactions_mdl.(Mouse_names{mousenum}) = chosen_interactions_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum}) = Output_GLM.chosen_interactions_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.chosen_interactions(mousenum,1) = table2array(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.chosen_interactions(mousenum,2) = table2array(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.chosen_interactions(mousenum,3) = table2array(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.chosen_interactions(mousenum,4) = table2array(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum})(5,4));%PositionxTimeSinceLastShock
end

figure
[Int_pval , Int_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.chosen_interactions(:,1) Compare_significant_predictors.chosen_interactions(:,2) Compare_significant_predictors.chosen_interactions(:,3) Compare_significant_predictors.chosen_interactions(:,4)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1]},[1 2 3 4],{'Position','Global Time', 'Time Since Last Shock', 'PositionxTime Since Last Shock'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

% NB : parrallel between GLM parameters and linear model parameters
% sqrt(deviation) = residual standard error, deviation = mean square error 

%% Compare models

% Compare with the R2 deviance
for mousenum=1:length(Mouse_ALL)
    Compare_models_R2(mousenum,1) = Rsquared.linear_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,2) = Rsquared.linear_mdl_out.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,3) = Rsquared.interactions_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,4) = Rsquared.chosen_interactions_mdl.(Mouse_names{mousenum});
end

figure
[R2_pval , R2_stats]= MakeSpreadAndBoxPlot3_SB({Compare_models_R2(:,1) Compare_models_R2(:,2) Compare_models_R2(:,3) Compare_models_R2(:,4)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1]},[1 2 3 4],{'Linear all','Linear without time freezing', 'All interactions', 'Position, GT, TSLSK, PxTSLSK'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
title('R2 deviance of different models for all mice', 'FontSize', 25);
% the deviance seems to be highly correlated with the size of the
% observations, which is coherent with its definition

% Compare the models with the deviance
for mousenum=1:length(Mouse_ALL)
    Compare_models_deviance(mousenum,1) = Deviance.linear_mdl.(Mouse_names{mousenum});
    Compare_models_deviance(mousenum,2) = Deviance.linear_mdl_out.(Mouse_names{mousenum});
    Compare_models_deviance(mousenum,3) = Deviance.interactions_mdl.(Mouse_names{mousenum});
    Compare_models_deviance(mousenum,4) = Deviance.chosen_interactions_mdl.(Mouse_names{mousenum});
end

figure
[Dev_pval , Dev_stats]= MakeSpreadAndBoxPlot3_SB({Compare_models_deviance(:,1) Compare_models_deviance(:,2) Compare_models_deviance(:,3) Compare_models_deviance(:,4)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1]},[1 2 3 4],{'Linear all','Linear without time freezing', 'All interactions', 'Position, GT, TSLSK, PxTSLSK'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
title('deviance of different models for all mice', 'FontSize', 25);
% the deviance seems to be highly correlated with the size of the
% observations, which is coherent with its definition

% Compare models with the LR test
alpha=.001;
for mousenum=1:length(Mouse_ALL)
    [Compare_models_LR(mousenum,1), pval_models_LR(mousenum,1)] = lratiotest(LR.linear_mdl.(Mouse_names{mousenum}), LR.linear_mdl_out.(Mouse_names{mousenum}), abs(size(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum}),1)-  size(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum}),1)),alpha); %h_linear_linear_out_LRT
    [Compare_models_LR(mousenum,2), pval_models_LR(mousenum,2)] = lratiotest(LR.interactions_mdl.(Mouse_names{mousenum}), LR.linear_mdl.(Mouse_names{mousenum}), abs(size(Table_estimates_pval.linear_mdl.(Mouse_names{mousenum}),1)-  size(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum}),1)),alpha);
    [Compare_models_LR(mousenum,3), pval_models_LR(mousenum,3)] = lratiotest(LR.interactions_mdl.(Mouse_names{mousenum}), LR.linear_mdl_out.(Mouse_names{mousenum}), abs(size(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum}),1)-  size(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum}),1)),alpha);
    [Compare_models_LR(mousenum,4), pval_models_LR(mousenum,4)] = lratiotest(LR.chosen_interactions_mdl.(Mouse_names{mousenum}), LR.linear_mdl_out.(Mouse_names{mousenum}), abs(size(Table_estimates_pval.linear_mdl_out.(Mouse_names{mousenum}),1)-  size(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum}),1)),alpha);
    [Compare_models_LR(mousenum,5), pval_models_LR(mousenum,5)] = lratiotest(LR.interactions_mdl.(Mouse_names{mousenum}), LR.chosen_interactions_mdl.(Mouse_names{mousenum}), abs(size(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum}),1)-  size(Table_estimates_pval.chosen_interactions_mdl.(Mouse_names{mousenum}),1)),alpha);
end

for i=1:size(Compare_models_LR,2)
    Sum_compare_LR(i) = sum(Compare_models_LR(:,i))
end
size(Table_estimates_pval.linear_mdl.M688,1)  

figure
bar([1:2:10], Sum_compare_LR)
xlim([-1 11])
ylim([0 15])
xticks([1:2:10])
xticklabels({'Linear all vs Linear - Ep Fz - Cumul Fz','All interactions vs linear all', 'All interactions vs Linear - Ep Fz - Cumul Fz', 'Chosen interactions (Pos, GT, TSLSK, PosxTSLSK) vs Linear - Ep Fz - Cumul Fz', 'All interactions vs chosen interactions'})
xtickangle(30)
legend('alpha=0.001')
title('Number of mice for which the unrestricted (left) model fits the data better than the restricted model (right)', 'FontSize', 20);

%% Transform some variables 

% Warning : for the first two transformations I did it from the 'raw' array
% which is ok for the exp neg but not for the inflexion point of the
% sigmoid that is sampled across a longer global time than the one used in
% the GLM 

% Transform time since last shock by testing different tau variables

for tau=3:3:333
    for mousenum=1:length(Mouse_ALL)
        
        ExpnegTimeSinceLastShockArray.Tau(tau/3).(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/tau);

        TransvarNames = {'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'TimepentFreezing', 'OB_FrequencyArray'};
        GLMTransformedArray_mouse.Tau(tau/3).(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})', ExpnegTimeSinceLastShockArray.Tau(tau/3).(Mouse_names{mousenum})', TimepentFreezing.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', TransvarNames);
        GLMTransformedArray_mouse.Tau(tau/3).(Mouse_names{mousenum}) = rmmissing(GLMTransformedArray_mouse.Tau(tau/3).(Mouse_names{mousenum}));

        TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = fitglm(GLMTransformedArray_mouse.Tau(tau/3).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
        Output_GLM.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Table_estimates_pval.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = Output_GLM.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}).Coefficients;
        Rsquared.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}).Rsquared.Deviance;
        Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}).Deviance;
        LR.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum}).LogLikelihood;
        
        TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = fitglm(GLMTransformedArray_mouse.Tau(tau/3).(Mouse_names{mousenum}),'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
        Output_GLM.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Table_estimates_pval.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = Output_GLM.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}).Coefficients;
        Rsquared.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}).Rsquared.Deviance;
        Deviance.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}).Deviance;
        LR.TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}) = TransTST_interactions_mdl.Tau(tau/3).(Mouse_names{mousenum}).LogLikelihood;
    
    end
end

% Compare taus with R2 deviance
for tau=3:3:333
    for mousenum=1:length(Mouse_ALL)
        Compare_models_R2_tau.TransTST_linear_mdl(mousenum,tau/3) = Rsquared.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
    end
end

figure
scatter(1, mean(Compare_models_R2(:,1)), 'filled'), hold on
for tau=3:3:333
    scatter(tau, mean(Compare_models_R2_tau.TransTST_linear_mdl(:,tau/3)), 'filled'), hold on
    for i=1:15
        scatter(tau, Compare_models_R2_tau.TransTST_linear_mdl(i,tau/3))
    end
end
for tau=6:3:333
    if mean(Compare_models_R2_tau.TransTST_linear_mdl(:,tau/3)) > mean(Compare_models_R2_tau.TransTST_linear_mdl(:,(tau-3)/3))
        max_R2 = mean(Compare_models_R2_tau.TransTST_linear_mdl(:,tau/3));
        tau_max = tau;
    end
end
vline(tau_max)
legend(sprintf('tau_{max} = %d', tau_max))
xlim([0 350])
title('Mean R2 deviance for all mice vs different values of tau, linear model', 'FontSize', 20);
ylabel('R2 deviance', 'FontSize', 20)
xlabel('tau', 'FontSize', 20)

figure
scatter(1, mean(Compare_models_R2(:,1)), 'filled'), hold on
for tau=3:3:333
    scatter(tau, mean(Compare_models_R2_tau.TransTST_linear_mdl(:,tau/3)), 'filled'), hold on
end
for mousenum=1:length(Mouse_ALL)
    a =rand(1,3);
    plot([3:3:333], Compare_models_R2_tau.TransTST_linear_mdl(mousenum,:), '-', 'Color', a), hold on
    [max_mouse(mousenum), tau_max_mouse(mousenum)] = max(Compare_models_R2_tau.TransTST_linear_mdl(mousenum,:));
    line([tau_max_mouse(mousenum)*3 tau_max_mouse(mousenum)*3], [0 1], 'Color', a)
end

color=[1,0,1]
rand(1)
% figure
% MakeSpreadAndBoxPlot3_SB({Compare_models_R2_tau.TransTST_linear_mdl(:,1) Compare_models_R2_tau.TransTST_linear_mdl(:,2)...
%     Compare_models_R2_tau.TransTST_linear_mdl(:,3) Compare_models_R2_tau.TransTST_linear_mdl(:,4) Compare_models_R2_tau.TransTST_linear_mdl(:,5) Compare_models_R2_tau.TransTST_linear_mdl(:,6)...
%     Compare_models_R2_tau.TransTST_linear_mdl(:,7) Compare_models_R2_tau.TransTST_linear_mdl(:,8) Compare_models_R2_tau.TransTST_linear_mdl(:,9) Compare_models_R2_tau.TransTST_linear_mdl(:,10) Compare_models_R2_tau.TransTST_linear_mdl(:,11)},... 
%     {[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0 0],[0 0 1],[1 0.7 0]},[1 2 3 4 5 6 7 8 9 10 11],...
%     {'3','6','9','12','15','18','21','24','27','30','33'},'paired',1,'showpoints',0)
% set(gca,'Yscale','log')
% title('R2 deviance for all mice vs different values of tau', 'FontSize', 20);
% ylabel('R2 deviance', 'FontSize', 20)
% xlabel('tau', 'FontSize', 20)

% Compare taus with deviance
for tau=3:3:33
    for mousenum=1:length(Mouse_ALL)
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Compare_models_deviance_tau.TransTST_linear_mdl(mousenum,tau/3) = Deviance.TransTST_linear_mdl.Tau(tau/3).(Mouse_names{mousenum});
    end
end

figure
scatter(1, mean(Compare_models_deviance(:,1))), hold on
for tau=3:3:33
    scatter(tau, mean(Compare_models_deviance_tau.TransTST_linear_mdl(:,tau/3)), 'filled'), hold on
end
xlim([0 35])
title('Mean deviance for all mice vs different values of tau, linear model', 'FontSize', 20);
ylabel('deviance', 'FontSize', 20)
xlabel('tau', 'FontSize', 20)

% figure
% MakeSpreadAndBoxPlot3_SB({Compare_models_deviance_tau.TransTST_linear_mdl(:,1) Compare_models_deviance_tau.TransTST_linear_mdl(:,2)...
%     Compare_models_deviance_tau.TransTST_linear_mdl(:,3) Compare_models_deviance_tau.TransTST_linear_mdl(:,4) Compare_models_deviance_tau.TransTST_linear_mdl(:,5) Compare_models_deviance_tau.TransTST_linear_mdl(:,6)...
%     Compare_models_deviance_tau.TransTST_linear_mdl(:,7) Compare_models_deviance_tau.TransTST_linear_mdl(:,8) Compare_models_deviance_tau.TransTST_linear_mdl(:,9) Compare_models_deviance_tau.TransTST_linear_mdl(:,10) Compare_models_deviance_tau.TransTST_linear_mdl(:,11)},... 
%     {[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0 0],[0 0 1],[1 0.7 0]},[1 2 3 4 5 6 7 8 9 10 11],...
%     {'3','6','9','12','15','18','21','24','27','30','33'},'paired',1,'showpoints',0)
% set(gca,'Yscale','log')
% title('Deviance for all mice vs different values of tau', 'FontSize', 20);
% ylabel('deviance', 'FontSize', 20)
% xlabel('tau', 'FontSize', 20)

% Transform gloabal time array 
for mousenum=1:length(Mouse_ALL)
    
    clear AllTpsLearnGT steplp
    
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    LearnSlope=0.01;
    steplp=0.1;
    
    for learnpt=0.1:steplp:0.9
    
        SigGlobalTimeArray.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = 1./(1+exp(-LearnSlope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));
               
        TransvarNames = {'PositionArray', 'SigGlobalTimeArray', 'TimeSinceLastShockArray', 'TimepentFreezing', 'OB_FrequencyArray'};
        GLMTransformedArray_mouse.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', SigGlobalTimeArray.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', TimepentFreezing.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', TransvarNames);
        GLMTransformedArray_mouse.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = rmmissing(GLMTransformedArray_mouse.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}));

        TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = fitglm(GLMTransformedArray_mouse.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
        Output_GLM.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum});
        Table_estimates_pval.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = Output_GLM.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Coefficients;
        Rsquared.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Rsquared.Deviance;
        Deviance.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Deviance;
        LR.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).LogLikelihood;
        
        TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = fitglm(GLMTransformedArray_mouse.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}),'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
        Output_GLM.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum});
        Table_estimates_pval.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = Output_GLM.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Coefficients;
        Rsquared.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Rsquared.Deviance;
        Deviance.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).Deviance;
        LR.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}) = TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum}).LogLikelihood;
    
    end
end

% Compare taus with R2 deviance
steplp=0.1;
for learnpt=0.1:steplp:0.9
    for mousenum=1:length(Mouse_ALL)
        Compare_models_R2_learnp.TransGT_linear_mdl(mousenum,round(learnpt/steplp)) = Rsquared.TransGT_linear_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum});
        Compare_models_R2_learnp.TransGT_interactions_mdl(mousenum,round(learnpt/steplp)) = Rsquared.TransGT_interactions_mdl.LearnPoint(round(learnpt/steplp)).(Mouse_names{mousenum});
    end
end

% model to plot : TransGT_linear_mdl, TransGT_interactions_mdl
figure
scatter(0, mean(Compare_models_R2(:,3)), 'filled'), hold on % change column number as follows : 1=linear, 2=linear_out, 3=interactions all, 4=chosen interactions
for learnpt=0.1:steplp:0.9
    scatter(round(learnpt/steplp)*10, mean(Compare_models_R2_learnp.TransGT_interactions_mdl(:,round(learnpt/steplp))), 'filled'), hold on
end
xlim([-10 100])
title('Mean R2 deviance for all mice vs different values of %lp, interactions model', 'FontSize', 20);
ylabel('R2 deviance', 'FontSize', 20)
xlabel('%lp', 'FontSize', 20)

fig=figure;
for mousenum=1:length(Mouse_ALL)
    subplot(5,3,mousenum)
%     a =rand(1,3);
    line([0 100],[Compare_models_R2(mousenum,3) Compare_models_R2(mousenum,3)], 'Color', [1 0 1]), hold on
    plot([10:10:90], Compare_models_R2_learnp.TransGT_interactions_mdl(mousenum,:), '-', 'Color', [0 .7 0.8]), hold on
    [max_mouse(mousenum), lp_max_mouse(mousenum)] = max(Compare_models_R2_learnp.TransGT_interactions_mdl(mousenum,:));
    line([lp_max_mouse(mousenum)*10 lp_max_mouse(mousenum)*10], [0 1], 'Color', [.5 .6 0])
    title(Mouse_names(mousenum))
    ylim([0 Compare_models_R2(mousenum,3)+0.1])
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'position of the learning point as a % of global time', 'FontSize', 25);
xlabel(han,'R2 deviance', 'FontSize', 25);
title(han,'R2 deviance for linear (hline) and sigmoidal values at different lp, interactions model', 'FontSize', 25);


for learnpt=0.15:steplp:0.85
    if mean(Compare_models_R2_learnp.TransGT_linear_mdl(:,round(learnpt/steplp))) > mean(Compare_models_R2_learnp.TransGT_linear_mdl(:,round(learnpt/steplp)-1))
        max_R2 = mean(Compare_models_R2_learnp.TransGT_linear_mdl(:,round(learnpt/steplp)));
        lp_max = learnpt;
    end
end
vline(tau_max)
legend(sprintf('tau_{max} = %d', tau_max))
xlim([0 350])
title('Mean R2 deviance for all mice vs different values of tau, linear model', 'FontSize', 20);
ylabel('R2 deviance', 'FontSize', 20)
xlabel('tau', 'FontSize', 20)

% Transform PositionxGlobalTime in the chosen interactions model

%% 2/ Examine the quality of the models (diagnostics)

clear model_to_examine
mousenum=12;
model_to_examine.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}); % linear_mdl, TransGT_linear_mdl, interactions_mdl, TransTST_interactions_mdl

% Prediction Slice plots : see how well the model fits the data

% The green line in each plot represents the predicted response values as a function of a single predictor variable, 
% with the other predictor variables held constant. The red dotted lines are the 95% confidence bounds. 
% The y-axis label includes the predicted response value and the corresponding confidence bound for the point selected by the vertical and horizontal lines. 
% The x-axis label shows the predictor variable name and the predictor value for the selected point.

plotSlice(model_to_examine.(Mouse_names{mousenum}))

% Leverage plot : understand the effect of each observation, remove outliers

% The leverage of each point on the fit is higher for points with relatively extreme predictor values (in either direction) 
% and low for points with average predictor values. In examples with multiple predictors and with points not ordered by predictor value, 
% this plot can help you identify which observations have high leverage (high influence on the fitted model) 
% because they are outliers as measured by their predictor values.

figure; plotDiagnostics(model_to_examine.(Mouse_names{mousenum}))

% Residuals — Model Quality for Training Data, test model assumptions

% There are several residual plots to help you discover errors, outliers, or correlations in the model or data. 
% The simplest residual plots are the default histogram plot, which shows the range of the residuals and their frequencies, 
% and the probability plot, which shows how the distribution of the residuals compares to a normal distribution with matched variance.

figure; plotResiduals(model_to_examine.(Mouse_names{mousenum}));  % assumed to follow a gamma distribution 
figure; plotResiduals(model_to_examine.(Mouse_names{mousenum}), 'fitted') % check wheter there is evidence of nonlinearity between residuals and fitted values
% figure; plotResiduals(model_to_examine.(Mouse_names{mousenum}), 'probability')

devianceTest(model_to_examine.(Mouse_names{mousenum}))

%% 3/ Test the predictivity of the model

% For a given mouse

% Generate the two datasets
for mousenum=1:length(Mouse_ALL)
    Train_ind.(Mouse_names{mousenum}) = randsample(size(GLMArray_mouse.(Mouse_names{mousenum}), 1), ceil(0.9*(size(GLMArray_mouse.(Mouse_names{mousenum}), 1))));
    Test_ind.(Mouse_names{mousenum}) = ~ismember((1:size(GLMArray_mouse.(Mouse_names{mousenum}), 1))', Train_ind.(Mouse_names{mousenum}));

    TrainGLMArray_mouse.(Mouse_names{mousenum}) = GLMArray_mouse.(Mouse_names{mousenum})(Train_ind.(Mouse_names{mousenum}), :);
    TestGLMArray_mouse.(Mouse_names{mousenum}) = GLMArray_mouse.(Mouse_names{mousenum})(Test_ind.(Mouse_names{mousenum}), :);
end 

% Generate the two datasets : train on 90% of freezing episodes and test on
% 10% of them 

find(GLMArray_mouse.(Mouse_names{mousenum})==0)

% sum(ismember(TrainGLMArray_mouse, TestGLMArray_mouse))
for mousenum=1:length(Mouse_ALL)
    Train_linear_mdl.(Mouse_names{mousenum}) = fitglm(TrainGLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
    [Predicted_linear_mdl.(Mouse_names{mousenum}), Predicted_CI.(Mouse_names{mousenum})] = predict(Train_linear_mdl.(Mouse_names{mousenum}), TestGLMArray_mouse.(Mouse_names{mousenum}));
end

mousenum=1
[Predict_linear_mdl.(Mouse_names{mousenum}), Predict_CI.(Mouse_names{mousenum})] = predict(Train_linear_mdl.(Mouse_names{mousenum}), Train_linear_mdl.(Mouse_names{mousenum}))
% If 'Prediction' is 'curve', then predict predicts confidence bounds for f(Xnew), the fitted responses at Xnew.
% If 'Prediction' is 'observation', then predict predicts confidence bounds for y, the response observations at Xnew.
figure; 
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
%     subplot(2,1,mousenum)
    plot(Predict_linear_mdl.(Mouse_names{mousenum}), 'x'), hold on, plot(table2array(TestGLMArray_mouse.(Mouse_names{mousenum})(:,5)), 'o')
    ylim([0 9])
    title(mouse)
    makepretty
    legend('Predictions', 'Data')
end
suptitle('Prediction of the OB frequency on 10% of the dataset using 90% of the dataset')

% From a mouse to another
mousenum1 = 2; % will be used to predict 
mousenum2= 1; % will be predicted
[Intermouse_predicted_linear_mdl.(Mouse_names{mousenum1}).(Mouse_names{mousenum2}), Intermouse_predicted_CI.(Mouse_names{mousenum1}).(Mouse_names{mousenum2})] = predict(linear_mdl.(Mouse_names{mousenum2}), GLMArray_mouse.(Mouse_names{mousenum1}));

figure; 
plot(Intermouse_predicted_linear_mdl.(Mouse_names{mousenum1}).(Mouse_names{mousenum2}), 'x'), hold on, 
plot(table2array(GLMArray_mouse.(Mouse_names{mousenum1})(:,5)), 'o')
ylim([0 9])
title(sprintf('Prediction of %s using %s data', Mouse_names{mousenum2}, Mouse_names{mousenum1}))
makepretty
legend('Predictions', 'Data')

figure
plot(table2array(GLMArray_mouse.M688(:,6)), table2array(Output_GLM.linear_mdl.M688.Fitted(:,1)), '.')
axis square
ylim([0 10])
xlim([0 10])

figure
for mousenum=1:length(Mouse_ALL)
    mouse=Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(table2array(GLMArray_mouse.(Mouse_names{mousenum})(:,6)), 'x'), hold on 
    plot(table2array(Output_GLM.linear_mdl.(Mouse_names{mousenum}).Fitted(:,1)), 'o')
    legend({'Data', 'Prediction'})
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency', 'FontSize', 20)
    title(mouse)
end

figure
plot(table2array(GLMArray_mouse.M1170(:,6)), 'x'), hold on 
plot(table2array(Output_GLM.linear_mdl.M1170.Fitted(:,1)), 'o')
legend({'Data', 'Prediction'})
xlabel('Observation', 'FontSize', 20)
ylabel('Frequency', 'FontSize', 20)

