%% Objectives of this code 

% Fit and compare the GLMs for all mice
%%% Models : 'Linear all','Linear without TFz and cumul TFz', 'All interactions', 
%%% 'Int1', 'Int2', 'Int3', 'Int4', 'Int5', 'All Int without TFz', 'Linear without TFz'

%%% INT1 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock'
%%% INT2 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxGlobalTime'
%%% INT3 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock'
%%% INT4 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime'
%%% INT5 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock', 'PositionxSigGlobalTime'
%%% INT6 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime'
%%% INT7 : 'SigPositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime'
%%% INT8 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime'
%%% INT9 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxGlobalTime'

% Fit the parameters for each transformation and extract the ones that
% maximize the R2 deviance for each mouse (Best Fitted Values structure)


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

% linear model with position, global time, time since last shock and
% cumulative time freezing
for mousenum=1:length(Mouse_ALL)
    linear_mdl_out1.(Mouse_names{mousenum}) = removeTerms(linear_mdl.(Mouse_names{mousenum}), 'TimepentFreezing');
    Output_GLM.linear_mdl_out1.(Mouse_names{mousenum}) = linear_mdl_out1.(Mouse_names{mousenum});
    Rsquared.linear_mdl_out1.(Mouse_names{mousenum}) = linear_mdl_out1.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.linear_mdl_out1.(Mouse_names{mousenum}) = linear_mdl_out1.(Mouse_names{mousenum}).Deviance;
    LR.linear_mdl_out1.(Mouse_names{mousenum}) = linear_mdl_out1.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.linear_mdl_out1.(Mouse_names{mousenum}) = Output_GLM.linear_mdl_out1.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.linear_out1(mousenum,1) = table2array(Table_estimates_pval.linear_mdl_out1.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.linear_out1(mousenum,2) = table2array(Table_estimates_pval.linear_mdl_out1.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.linear_out1(mousenum,3) = table2array(Table_estimates_pval.linear_mdl_out1.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.linear_out1(mousenum,4) = table2array(Table_estimates_pval.linear_mdl_out1.(Mouse_names{mousenum})(5,4));%T since last shock
end

% linear model with position, global time, time since last shock
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
title('pvalues of predictors for all mice in the linear model', 'FontSize', 25);

figure
[Linear_pval , Linear_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.linear_out1(:,1)...
    Compare_significant_predictors.linear_out1(:,2) Compare_significant_predictors.linear_out1(:,3)...
    Compare_significant_predictors.linear_out1(:,4)},...
    {[1 0 0],[0 0 1],[1 0.7 0],[.5 0.7 0.5]},[1 2 3 4],{'Position','Global Time', 'Time Since Last Shock', 'Cumul time freezing'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
line([0 20], [0.05 0.05], 'linewidth',4)
title('pvalues of predictors for all mice in the linear model without time freezing', 'FontSize', 25);

figure
[Linear_pval_out , Linear_stats_out]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.linear_out(:,1) Compare_significant_predictors.linear_out(:,2) Compare_significant_predictors.linear_out(:,3) },{[1 0 0],[0 0 1],[1 0.7 0], },[1 2 3],{'Position','Global Time', 'Time Since Last Shock'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

% All interactions
for mousenum=1:length(Mouse_ALL)
    interactions_mdl.(Mouse_names{mousenum}) = fitglm(GLMArray_mouse.(Mouse_names{mousenum}),'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum});
    Rsquared.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).Deviance;
    LR.interactions_mdl.(Mouse_names{mousenum}) = interactions_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum}) = Output_GLM.interactions_mdl.(Mouse_names{mousenum}).Coefficients;
end
% Here our model looks like 1/OB_freq = linear + all pairs of X times Bn

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.interactions_mdl(mousenum,1) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.interactions_mdl(mousenum,2) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.interactions_mdl(mousenum,3) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.interactions_mdl(mousenum,4) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(5,4));%T freezing
    Compare_significant_predictors.interactions_mdl(mousenum,5) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(6,4));%T freezing cumul
    Compare_significant_predictors.interactions_mdl(mousenum,6) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(7,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,7) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(8,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,8) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(9,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,9) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(10,4));
    Compare_significant_predictors.interactions_mdl(mousenum,10) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(11,4)); 
    Compare_significant_predictors.interactions_mdl(mousenum,11) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(12,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,12) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(13,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,13) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(14,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,14) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(15,4));%
    Compare_significant_predictors.interactions_mdl(mousenum,15) = table2array(Table_estimates_pval.interactions_mdl.(Mouse_names{mousenum})(16,4));%
end

figure
[Linear_pval_out , Linear_stats_out]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.interactions_mdl(:,1)...
    Compare_significant_predictors.interactions_mdl(:,2) Compare_significant_predictors.interactions_mdl(:,3) ...
    Compare_significant_predictors.interactions_mdl(:,4) Compare_significant_predictors.interactions_mdl(:,5) ...
    Compare_significant_predictors.interactions_mdl(:,6) Compare_significant_predictors.interactions_mdl(:,7) ...
    Compare_significant_predictors.interactions_mdl(:,8) Compare_significant_predictors.interactions_mdl(:,9) ...
    Compare_significant_predictors.interactions_mdl(:,10) Compare_significant_predictors.interactions_mdl(:,11) ...
    Compare_significant_predictors.interactions_mdl(:,12) Compare_significant_predictors.interactions_mdl(:,13) ...
    Compare_significant_predictors.interactions_mdl(:,14) Compare_significant_predictors.interactions_mdl(:,15) },...
    {[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0]},...
    [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15],{'Position','Global Time', 'Time Since Last Shock', 'TimepentFreezing', 'TimepentFreezingCumul', ...
    'Position:Global Time', 'PositionArray:TimeSinceLastShockArray', 'PositionArray:TimepentFreezing', 'PositionArray:Timefreezing_cumul', ...
    'GlobalTimeArray:TimeSinceLastShockArray', 'GlobalTimeArray:TimepentFreezing', 'GlobalTimeArray:Timefreezing_cumul', ...
    'TimeSinceLastShockArray:TimepentFreezing', 'TimeSinceLastShockArray:Timefreezing_cumul', 'TimepentFreezing:Timefreezing_cumul'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
line([0 20], [0.05 0.05], 'linewidth',4)
title('pvalues of predictors for all mice in the all interactions model', 'FontSize', 25);

% Interactions without time freezing
% Create table for a mouse
IntoutvarNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'Timefreezing_cumul', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    IntoutGLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})', OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',IntoutvarNames);
    IntoutGLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(IntoutGLMArray_mouse.(Mouse_names{mousenum}));
end 

for mousenum=1:length(Mouse_ALL)
    interactions_mdl_out1.(Mouse_names{mousenum}) = fitglm(IntoutGLMArray_mouse.(Mouse_names{mousenum}),'interactions','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.interactions_mdl_out1.(Mouse_names{mousenum}) = interactions_mdl_out1.(Mouse_names{mousenum});
    Rsquared.interactions_mdl_out1.(Mouse_names{mousenum}) = interactions_mdl_out1.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.interactions_mdl_out1.(Mouse_names{mousenum}) = interactions_mdl_out1.(Mouse_names{mousenum}).Deviance;
    LR.interactions_mdl_out1.(Mouse_names{mousenum}) = interactions_mdl_out1.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum}) = Output_GLM.interactions_mdl_out1.(Mouse_names{mousenum}).Coefficients;
end
% Here our model looks like 1/OB_freq = linear + all pairs of X times Bn

for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.interactions_mdl_out1(mousenum,1) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.interactions_mdl_out1(mousenum,2) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.interactions_mdl_out1(mousenum,3) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.interactions_mdl_out1(mousenum,4) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(5,4));%T freezing
    Compare_significant_predictors.interactions_mdl_out1(mousenum,5) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(6,4));%T freezing cumul
    Compare_significant_predictors.interactions_mdl_out1(mousenum,6) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(7,4));%
    Compare_significant_predictors.interactions_mdl_out1(mousenum,7) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(8,4));%
    Compare_significant_predictors.interactions_mdl_out1(mousenum,8) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(9,4));%
    Compare_significant_predictors.interactions_mdl_out1(mousenum,9) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(10,4));
    Compare_significant_predictors.interactions_mdl_out1(mousenum,10) = table2array(Table_estimates_pval.interactions_mdl_out1.(Mouse_names{mousenum})(11,4)); 
end

figure
[Linear_pval_out , Linear_stats_out]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.interactions_mdl_out1(:,1)...
    Compare_significant_predictors.interactions_mdl_out1(:,2) Compare_significant_predictors.interactions_mdl_out1(:,3) ...
    Compare_significant_predictors.interactions_mdl_out1(:,4) Compare_significant_predictors.interactions_mdl_out1(:,5) ...
    Compare_significant_predictors.interactions_mdl_out1(:,6) Compare_significant_predictors.interactions_mdl_out1(:,7) ...
    Compare_significant_predictors.interactions_mdl_out1(:,8) Compare_significant_predictors.interactions_mdl_out1(:,9) ...
    Compare_significant_predictors.interactions_mdl_out1(:,10) },...
    {[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0],[1 0 0],[0 0 1],[1 0.7 0], [1 0 0]},...
    [1 2 3 4 5 6 7 8 9 10],{'Position','Global Time', 'Time Since Last Shock', 'TimepentFreezingCumul', ...
    'Position:Global Time', 'PositionArray:TimeSinceLastShockArray', 'PositionArray:Timefreezing_cumul', ...
    'GlobalTimeArray:TimeSinceLastShockArray', 'GlobalTimeArray:Timefreezing_cumul', ...
     'TimeSinceLastShockArray:Timefreezing_cumul'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
line([0 20], [0.05 0.05], 'linewidth',4)
title('pvalues of predictors for all mice in the interactions model without time freezing', 'FontSize', 25);


%% Final models : chose our interactions

% 1 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock'
% 2 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray',
% 'PositionxTimeSinceLastShock', 'PositionxGlobalTime'

% 3 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock'
% 4 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray',
% 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime'
% 5 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 
% 'PositionxExpnegTimeSinceLastShock', 'PositionxSigGlobalTime'

% Int 1 : Linear model with Pos x last shock interaction
Int1varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int1_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Int1varNames);
    Int1_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int1_GLMArray_mouse.(Mouse_names{mousenum}));
end 

for mousenum=1:length(Mouse_ALL)
    chosen_interactions1_mdl.(Mouse_names{mousenum}) = fitglm(Int1_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.chosen_interactions1_mdl.(Mouse_names{mousenum}) = chosen_interactions1_mdl.(Mouse_names{mousenum});
    Rsquared.chosen_interactions1_mdl.(Mouse_names{mousenum}) = chosen_interactions1_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.chosen_interactions1_mdl.(Mouse_names{mousenum}) = chosen_interactions1_mdl.(Mouse_names{mousenum}).Deviance;
    LR.chosen_interactions1_mdl.(Mouse_names{mousenum}) = chosen_interactions1_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.chosen_interactions1_mdl.(Mouse_names{mousenum}) = Output_GLM.chosen_interactions1_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.chosen_interactions1(mousenum,1) = table2array(Table_estimates_pval.chosen_interactions1_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.chosen_interactions1(mousenum,2) = table2array(Table_estimates_pval.chosen_interactions1_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.chosen_interactions1(mousenum,3) = table2array(Table_estimates_pval.chosen_interactions1_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.chosen_interactions1(mousenum,4) = table2array(Table_estimates_pval.chosen_interactions1_mdl.(Mouse_names{mousenum})(5,4));%PositionxTimeSinceLastShock
end

% Look at significative explicative variables
figure
[Int_pval , Int_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.chosen_interactions1(:,1) Compare_significant_predictors.chosen_interactions1(:,2) Compare_significant_predictors.chosen_interactions1(:,3) Compare_significant_predictors.chosen_interactions1(:,4)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1]},[1 2 3 4],{'Position','Global Time', 'Time Since Last Shock', 'PositionxTime Since Last Shock'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

% Int 2
Int2varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Int2_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (PositionArray.(Mouse_names{mousenum})').*(GlobalTimeArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Int2varNames);
    Int2_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int2_GLMArray_mouse.(Mouse_names{mousenum}));
end 

for mousenum=1:length(Mouse_ALL)
    chosen_interactions2_mdl.(Mouse_names{mousenum}) = fitglm(Int2_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
    Output_GLM.chosen_interactions2_mdl.(Mouse_names{mousenum}) = chosen_interactions2_mdl.(Mouse_names{mousenum});
    Rsquared.chosen_interactions2_mdl.(Mouse_names{mousenum}) = chosen_interactions2_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.chosen_interactions2_mdl.(Mouse_names{mousenum}) = chosen_interactions2_mdl.(Mouse_names{mousenum}).Deviance;
    LR.chosen_interactions2_mdl.(Mouse_names{mousenum}) = chosen_interactions2_mdl.(Mouse_names{mousenum}).LogLikelihood;
    Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum}) = Output_GLM.chosen_interactions2_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.chosen_interactions2(mousenum,1) = table2array(Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.chosen_interactions2(mousenum,2) = table2array(Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.chosen_interactions2(mousenum,3) = table2array(Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum})(4,4));%T since last shock
    Compare_significant_predictors.chosen_interactions2(mousenum,4) = table2array(Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum})(5,4));%PositionxTimeSinceLastShock
    Compare_significant_predictors.chosen_interactions2(mousenum,5) = table2array(Table_estimates_pval.chosen_interactions2_mdl.(Mouse_names{mousenum})(6,4));%PositionxGT
end

% Look at significative explicative variables
figure
[Int_pval , Int_stats]= MakeSpreadAndBoxPlot3_SB({Compare_significant_predictors.chosen_interactions2(:,1) Compare_significant_predictors.chosen_interactions2(:,2) Compare_significant_predictors.chosen_interactions2(:,3) Compare_significant_predictors.chosen_interactions2(:,4) Compare_significant_predictors.chosen_interactions2(:,5)},...
    {[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1],[1 0.7 0.4]},[1 2 3 4 5],{'Position','Global Time', 'Time Since Last Shock', 'PositionxTime Since Last Shock', 'PositionxGlobalTime'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
ylim([-0.1 1.1])
hline(0.05)
title('pvalues of predictors for all mice', 'FontSize', 25);

% NB : parrallel between GLM parameters and linear model parameters
% sqrt(deviation) = residual standard error, deviation = mean square error 

%% Compare models without transformation

% Compare with the R2 deviance
for mousenum=1:length(Mouse_ALL)
    Compare_models_R2(mousenum,1) = Rsquared.linear_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,2) = Rsquared.linear_mdl_out.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,3) = Rsquared.interactions_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,4) = Rsquared.chosen_interactions1_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,5) = Rsquared.chosen_interactions2_mdl.(Mouse_names{mousenum});
end

figure
[R2_pval , R2_stats]= MakeSpreadAndBoxPlot3_SB({Compare_models_R2(:,1) Compare_models_R2(:,2) Compare_models_R2(:,3) Compare_models_R2(:,4) Compare_models_R2(:,5)},{[1 0 0],[0 0 1],[1 0.7 0],[0.2 0 1], [0.8 0 1]},[1 2 3 4 5],{'Linear all','Linear without time freezing', 'All interactions', 'Position, GT, TSLSK, PxTSLSK', 'Pos, GT, LS, PosxLS, PosxGT'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
title('R2 deviance of different models for all mice', 'FontSize', 25);
% the deviance seems to be highly correlated with the size of the
% observations, which is coherent with its definition

%% Transform some variables 

% 3 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock'
% 4 : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray',
% 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime'
% 5 : 'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 
% 'PositionxExpnegTimeSinceLastShock', 'PositionxSigGlobalTime'

% Int 3
for tau=3:3:150
    for mousenum=1:length(Mouse_ALL)
        
        ExpnegTimeSinceLastShockArray.Tau(tau/3).(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/tau);

        Int3varNames = {'PositionArray', 'GlobalTimeArray', 'ExpnegTimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock', 'OB_FrequencyArray'};
        Int3_GLMArray_mouse.Tau(tau/3).(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
            ExpnegTimeSinceLastShockArray.Tau(tau/3).(Mouse_names{mousenum})', ...
            (PositionArray.(Mouse_names{mousenum})').*(ExpnegTimeSinceLastShockArray.Tau(tau/3).(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int3varNames);
        Int3_GLMArray_mouse.Tau(tau/3).(Mouse_names{mousenum}) = rmmissing(Int3_GLMArray_mouse.Tau(tau/3).(Mouse_names{mousenum}));

        chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = fitglm(Int3_GLMArray_mouse.Tau(tau/3).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
        Output_GLM.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum});
        Table_estimates_pval.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}).Coefficients;
        Rsquared.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}).Rsquared.Deviance;
        Deviance.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}).Deviance;
        LR.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}) = chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum}).LogLikelihood;
        
    end
end

% Compare taus with R2 deviance to int 1 and
% Extract best tau value for each mouse
for mousenum=1:length(Mouse_ALL)
    for tau=3:3:150
        Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,tau/3) = Rsquared.chosen_interactions3_mdl.Tau(tau/3).(Mouse_names{mousenum});
    end 
    [MaxR2_mouse.INT3.tau(mousenum), Ind.INT3.tau_max_mouse(mousenum)] = max(Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,:));
    Best_Fitted_variables.INT3.tau(mousenum) = Ind.INT3.tau_max_mouse(mousenum)*3;
end

% tau: [36 63 150 51 18 36 60 90 150 150 12 150 18 150 150]

figure
scatter(1, mean(Compare_models_R2(:,4)), 'filled'), hold on % Reference value : int 1
for tau=3:3:150
    scatter(tau, mean(Compare_models_R2_tau.chosen_interactions3_mdl(:,tau/3)), 'filled'), hold on
%     for i=1:15
%         scatter(tau, Compare_models_R2_tau.chosen_interactions3_mdl(i,tau/3))
%     end
end
for tau=6:3:150
    if mean(Compare_models_R2_tau.chosen_interactions3_mdl(:,tau/3)) > mean(Compare_models_R2_tau.chosen_interactions3_mdl(:,(tau-3)/3))
        max_R2 = mean(Compare_models_R2_tau.chosen_interactions3_mdl(:,tau/3));
        tau_max = tau;
    end
end 
vline(tau_max)
legend(sprintf('tau_{max} = %d', tau_max))
xlim([0 150])
title('Mean R2 deviance for all mice vs different values of tau, Int 3 model', 'FontSize', 20);
ylabel('R2 deviance', 'FontSize', 20)
xlabel('tau', 'FontSize', 20)

figure
scatter(1, mean(Compare_models_R2(:,1)), 'filled'), hold on
for tau=3:3:150
    scatter(tau, mean(Compare_models_R2_tau.chosen_interactions3_mdl(:,tau/3)), 'filled'), hold on
end
for mousenum=1:length(Mouse_ALL)
    a =rand(1,3);
    plot([3:3:150], Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,:), '-', 'Color', a), hold on
    [MaxR2_mouse.tau(mousenum), tau_max_mouse(mousenum)] = max(Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,:));
    line([tau_max_mouse(mousenum)*3 tau_max_mouse(mousenum)*3], [0 1], 'Color', a)
end

fig=figure;
for mousenum=1:length(Mouse_ALL)
    subplot(5,3,mousenum)
%     a =rand(1,3);
    line([0 100],[Compare_models_R2(mousenum,4) Compare_models_R2(mousenum,4)], 'Color', [1 0 1]), hold on
    plot([3:3:150], Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,:), '-', 'Color', [1 0 0]), hold on
    [MaxR2_mouse.tau(mousenum), tau_max_mouse(mousenum)] = max(Compare_models_R2_tau.chosen_interactions3_mdl(mousenum,:));
    line([tau_max_mouse(mousenum)*3 tau_max_mouse(mousenum)*3], [0 1], 'Color', [0 1 0])
    title(Mouse_names(mousenum))
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'tau', 'FontSize', 25);
ylabel(han,'R2 deviance', 'FontSize', 25);
title(han,'R2 deviance for Int1 (hline) and Int3 at different tau', 'FontSize', 25);
% Looks like it is at least the same R2 as for int 1, so let's transform this

% Int4 model : 'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray',
% 'PositionxTimeSinceLastShock', 'PositionxSigGlobalTime'
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

% Extract values that maximize the R2 deviance for each mouse
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

% LearnSlope: [0.0045 0.0100 0.0050 1.0000e-03 0.0055 0.0085 0.0100 1.0000e-03 0.0040 0.0100 0.0030 1.0000e-03 0.0055 0.0065 0.0100]
% LearnPoint: [0.2000 0.1000 0.5000 0.9000 0.5000 0.8000 0.1000 0.5000 0.9000 0.9000 0.1000 0.1000 0.9000 0.7000 0.8000]

% Int 5 : takes an hour to compute
indtau=1;

for tau=3:3:150
    
    for mousenum=1:length(Mouse_ALL)
        
        clear AllTpsLearnGT steplp
    
        AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
        stepslope=0.0005;
        steplp=0.1;
        indslope=1;
    
        for learnslope=0.001:stepslope:0.01 
        
        indlearnpt = 1;
        
            for learnpt=0.1:steplp:0.9

                Expneg5_TimeSinceLastShockArray.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/tau);
                Sig5_GlobalTimeArray.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

                Int5varNames = {'PositionArray', 'GlobalTimeArray', 'Expneg5_TimeSinceLastShockArray', 'PositionxExpnegTimeSinceLastShock', 'PositionxSigGlobalTime', 'OB_FrequencyArray'};
                Int5_GLMArray_mouse.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                    GlobalTimeArray.(Mouse_names{mousenum})', Expneg5_TimeSinceLastShockArray.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})', ...
                    (PositionArray.(Mouse_names{mousenum})').*(Expneg5_TimeSinceLastShockArray.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'),...
                    (PositionArray.(Mouse_names{mousenum})').*(Sig5_GlobalTimeArray.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                    OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int5varNames);
                Int5_GLMArray_mouse.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int5_GLMArray_mouse.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

                chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int5_GLMArray_mouse.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
                Output_GLM.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
                Table_estimates_pval.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
                Rsquared.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
                Deviance.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
                LR.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

                indlearnpt = indlearnpt +1;

            end
        
        indslope=indslope+1;
        
        end
    end
    
    indtau = indtau+1;
end


% Extract all fitted values that maximize the R2 deviance
indtau=1;
for tau=3:3:150

    for mousenum=1:length(Mouse_ALL)
        stepslope=0.0005;
        steplp=0.1;
        indslope=1;
        lrnslope=0.001:stepslope:0.01;
        
        clear ind_best_tau ind_best_learnslope

        for learnslope=0.001:stepslope:0.01 
            indlearnpt = 1;

            for learnpt=0.1:steplp:0.9
                
%                 Compare_models_R2_tau_learnp.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
%                 [MaxR2_mouse.chosen_interactions5_mdl.Tau(indtau).learn(indslope,mousenum), LP5_max_mouse.Tau(indtau).LP5(indslope,mousenum)] = max(Compare_models_R2_tau_learnp.chosen_interactions5_mdl.Tau(indtau).LearnSlope(indslope).LearnP(mousenum,:));
%                 [MaxR2_mouse.chosen_interactions5_mdl.Tau(indtau).learnslope(mousenum), LS5_max_mouse.Tau(indtau).LS5(mousenum)] = max(MaxR2_mouse.chosen_interactions5_mdl.Tau(indtau).learn(:,mousenum));
%                 Compare_tau_all_mice_Int5(indtau,mousenum) = MaxR2_mouse.chosen_interactions5_mdl.Tau(indtau).learnslope(mousenum);
                [MaxR2_mouse.chosen_interactions5_mdl.tau_max(mousenum), LS5_max_mouse.tau_max(mousenum)] = max(Compare_tau_all_mice_Int5(:,mousenum));
                Best_Fitted_variables.INT5.Tau_exp(mousenum) = LS5_max_mouse.tau_max(mousenum)*3;
                ind_best_tau = LS5_max_mouse.tau_max(mousenum);
                ind_best_learnslope = LS5_max_mouse.Tau(ind_best_tau).LS5(mousenum);
                Best_Fitted_variables.INT5.LearnSlope(mousenum) = lrnslope(ind_best_learnslope);
                Best_Fitted_variables.INT5.LearnPoint(mousenum) = LP5_max_mouse.Tau(ind_best_tau).LP5(ind_best_learnslope,mousenum)/10;

                
                indlearnpt = indlearnpt +1;

            end

            indslope=indslope+1;

        end

    end
    indtau = indtau+1;
end

%     Tau_exp: [33 54 150 150 21 42 108 129 150 150 9 81 21 150 150]
%     LearnSlope: [0.0045 1.0000e-03 0.0055 0.0045 0.0060 0.0100 0.0100 0.0100 0.0045 0.0090 0.0025 1.0000e-03 0.0055 0.0060 0.0100]
%     LearnPoint: [0.2000 0.6000 0.5000 0.9000 0.5000 0.6000 0.1000 0.9000 0.9000 0.9000 0.1000 0.4000 0.9000 0.7000 0.7000]

% Int 6 : transform position in a sigmoid
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
                
            SigGlobalTimeArray.INT6.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = 1./(1+exp(-learnslope*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*learnpt))));

            Int6varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int6_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
                (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.INT6.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int6varNames);
            Int6_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int6_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int6_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

            indlearnpt = indlearnpt +1;
            
        end
        
        indslope=indslope+1;
        
    end

end

% Extract values that maximize the R2 deviance for each mouse
clear LP_max_mouse LS_max_mouse
for mousenum=1:length(Mouse_ALL)
    stepslope=0.0005;
    steplp=0.1;
    indslope=1;
    lrnslope=0.001:stepslope:0.01;
    
    
    for learnslope=0.001:stepslope:0.01 
        indlearnpt = 1;
        
        for learnpt=0.1:steplp:0.9
            
            Compare_models_R2_learnp.chosen_interactions6_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions6_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT6.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions6_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT6.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT6.learn(:,mousenum));
            Best_Fitted_variables.INT6.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT6.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

%     LearnSlope: [0.0100 0.0100 0.0045 0.0065 0.0085 1.0000e-03 0.0100 0.0015 0.0015 0.0050 0.0100]
%     LearnPoint: [0.3000 0.8000 0.5000 0.5000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000]

% INT7
% Int 7 
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

            Int7varNames = {'SigPositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int7_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(SigPositionArray.(Mouse_names{mousenum})',...
                GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
                (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int7varNames);
            Int7_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int7_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int7_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

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
            
            Compare_models_R2_learnp.chosen_interactions7_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions7_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT7.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions7_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT7.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT7.learn(:,mousenum));
            Best_Fitted_variables.INT7.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT7.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

% LearnSlope: [0.0060 0.0095 0.0070 0.0020 0.0060 1.0000e-03 0.0070 0.0045 1.0000e-03 0.0055 0.0100]
% LearnPoint: [0.2000 0.4000 0.6000 0.4000 0.8000 0.7000 0.1000 0.5000 0.9000 0.9000 0.8000]

% Int 8
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

            Int8varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxSigGlobalTime', 'OB_FrequencyArray'};
            Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
                GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
                (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
                (SigPositionArray.(Mouse_names{mousenum})').*(SigGlobalTimeArray.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum})'), ...
                OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int8varNames);
            Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = rmmissing(Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}));

            chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = fitglm(Int8_GLMArray_mouse.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
            Output_GLM.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            Table_estimates_pval.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = Output_GLM.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Coefficients;
            Rsquared.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Rsquared.Deviance;
            Deviance.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).Deviance;
            LR.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}) = chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum}).LogLikelihood;

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
            
            Compare_models_R2_learnp.chosen_interactions8_mdl.LearnSlope(indslope).LearnP(mousenum,indlearnpt) = Rsquared.chosen_interactions8_mdl.LearnSlope(indslope).LearnPoint(indlearnpt).(Mouse_names{mousenum});
            [MaxR2_mouse.INT8.learn(indslope,mousenum), LP_max_mouse(indslope,mousenum)] = max(Compare_models_R2_learnp.chosen_interactions8_mdl.LearnSlope(indslope).LearnP(mousenum,:));
            [MaxR2_mouse.INT8.learnslope(mousenum), LS_max_mouse(mousenum)] = max(MaxR2_mouse.INT8.learn(:,mousenum));
            Best_Fitted_variables.INT8.LearnSlope(mousenum) = lrnslope(LS_max_mouse(mousenum));
            Best_Fitted_variables.INT8.LearnPoint(mousenum) = LP_max_mouse(LS_max_mouse(mousenum),mousenum)/10;
            
            indlearnpt = indlearnpt +1;
                  
        end
        
        indslope=indslope+1;
        
    end
end

% LearnSlope: [0.0070 0.0100 0.0065 0.0020 0.0060 1.0000e-03 0.0100 0.0015 0.0020 0.0055 0.0100]
% LearnPoint: [0.2000 0.8000 0.6000 0.4000 0.8000 0.7000 0.2000 0.5000 0.9000 0.9000 0.8000]

% Int 9 : transform position in a sigmoid
for mousenum=1:length(Mouse_ALL)
    
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));

    Int9varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxGlobalTime', 'OB_FrequencyArray'};
    Int9_GLMArray_mouse.(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
        (SigPositionArray.(Mouse_names{mousenum})').*(GlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int9varNames);
    Int9_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Int9_GLMArray_mouse.(Mouse_names{mousenum}));

    chosen_interactions9_mdl.(Mouse_names{mousenum}) = fitglm(Int9_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
    Output_GLM.chosen_interactions9_mdl.(Mouse_names{mousenum}) = chosen_interactions9_mdl.(Mouse_names{mousenum});
    Table_estimates_pval.chosen_interactions9_mdl.(Mouse_names{mousenum}) = Output_GLM.chosen_interactions9_mdl.(Mouse_names{mousenum}).Coefficients;
    Rsquared.chosen_interactions9_mdl.(Mouse_names{mousenum}) = chosen_interactions9_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.chosen_interactions9_mdl.(Mouse_names{mousenum}) = chosen_interactions9_mdl.(Mouse_names{mousenum}).Deviance;
    LR.chosen_interactions9_mdl.(Mouse_names{mousenum}) = chosen_interactions9_mdl.(Mouse_names{mousenum}).LogLikelihood;

end

%% Create the fitted GLM arrays on train

% INT3
Fit3varNames = {'PositionArray', 'GlobalTimeArray', 'Fit3ExpnegTimeSinceLastShockArray', 'PositionxFit3ExpnegTimeSinceLastShock', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)

    Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/Best_Fitted_variables.INT3.tau(mousenum));

    Fit3_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', GlobalTimeArray.(Mouse_names{mousenum})',...
        Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit3ExpnegTimeSinceLastShockArray.(Mouse_names{mousenum})'), OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Int3varNames);
    Fit3_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit3_GLMArray_mouse.(Mouse_names{mousenum}));

    fitted_interactions3_mdl.(Mouse_names{mousenum}) = fitglm(Fit3_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
    Output_GLM.fitted_interactions3_mdl.(Mouse_names{mousenum}) = fitted_interactions3_mdl.(Mouse_names{mousenum});
    Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum}) = Output_GLM.fitted_interactions3_mdl.(Mouse_names{mousenum}).Coefficients;
    Rsquared.fitted_interactions3_mdl.(Mouse_names{mousenum}) = fitted_interactions3_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.fitted_interactions3_mdl.(Mouse_names{mousenum}) = fitted_interactions3_mdl.(Mouse_names{mousenum}).Deviance;
    LR.fitted_interactions3_mdl.(Mouse_names{mousenum}) = fitted_interactions3_mdl.(Mouse_names{mousenum}).LogLikelihood;
end

for mousenum=1:length(Mouse_ALL)
    Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum}) = Output_GLM.fitted_interactions3_mdl.(Mouse_names{mousenum}).Coefficients;
    Compare_significant_predictors.fitted_interactions3_mdl(mousenum,1) = table2array(Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.fitted_interactions3_mdl(mousenum,2) = table2array(Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.fitted_interactions3_mdl(mousenum,3) = table2array(Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum})(4,4));%expneg T since last shock
    Compare_significant_predictors.fitted_interactions3_mdl(mousenum,4) = table2array(Table_estimates_pval.fitted_interactions3_mdl.(Mouse_names{mousenum})(5,4));%PositionxexpnegTimeSinceLastShock
end

% INT4
Fit4varNames = {'PositionArray', 'GlobalTimeArray', 'TimeSinceLastShockArray', 'PositionxTimeSinceLastShock', 'PositionxFit4SigGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    
    Fit4SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT4.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT4.LearnPoint(mousenum)))));

    Fit4_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        GlobalTimeArray.(Mouse_names{mousenum})', TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit4SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
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

% INT5
Fit5varNames = {'PositionArray', 'GlobalTimeArray', 'Fit5Expneg_TimeSinceLastShockArray', 'PositionxFit5ExpnegTimeSinceLastShock', 'PositionxFit5SigGlobalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum}) = exp((-TimeSinceLastShockArray.(Mouse_names{mousenum}))/Best_Fitted_variables.INT5.Tau_exp(mousenum));
    Fit5SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT5.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT5.LearnPoint(mousenum)))));

    Fit5_GLMArray_mouse.(Mouse_names{mousenum}) = table(PositionArray.(Mouse_names{mousenum})',...
        GlobalTimeArray.(Mouse_names{mousenum})', Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (PositionArray.(Mouse_names{mousenum})').*(Fit5Expneg_TimeSinceLastShockArray.(Mouse_names{mousenum})'),...
        (PositionArray.(Mouse_names{mousenum})').*(Fit5SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames', Fit5varNames);
    Fit5_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit5_GLMArray_mouse.(Mouse_names{mousenum}));

    fitted_interactions5_mdl.(Mouse_names{mousenum}) = fitglm(Fit5_GLMArray_mouse.(Mouse_names{mousenum}),'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal'); 
    Output_GLM.fitted_interactions5_mdl.(Mouse_names{mousenum}) = fitted_interactions5_mdl.(Mouse_names{mousenum});
    Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum}) = Output_GLM.fitted_interactions5_mdl.(Mouse_names{mousenum}).Coefficients;
    Rsquared.fitted_interactions5_mdl.(Mouse_names{mousenum}) = fitted_interactions5_mdl.(Mouse_names{mousenum}).Rsquared.Deviance;
    Deviance.fitted_interactions5_mdl.(Mouse_names{mousenum}) = fitted_interactions5_mdl.(Mouse_names{mousenum}).Deviance;
    LR.fitted_interactions5_mdl.(Mouse_names{mousenum}) = fitted_interactions5_mdl.(Mouse_names{mousenum}).LogLikelihood;
end
for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.fitted_interactions5_mdl(mousenum,1) = table2array(Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum})(2,4));%Position
    Compare_significant_predictors.fitted_interactions5_mdl(mousenum,2) = table2array(Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum})(3,4));%GT
    Compare_significant_predictors.fitted_interactions5_mdl(mousenum,3) = table2array(Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum})(4,4));%Expneg T since last shock
    Compare_significant_predictors.fitted_interactions5_mdl(mousenum,4) = table2array(Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum})(5,4));%PositionxExpnegTimeSinceLastShock
    Compare_significant_predictors.fitted_interactions5_mdl(mousenum,5) = table2array(Table_estimates_pval.fitted_interactions5_mdl.(Mouse_names{mousenum})(6,4));%PositionxSigGT
end


%% Compare all the models : train vs train R2 deviance

for mousenum=1:length(Mouse_ALL)
    Compare_models_R2(mousenum,1) = Rsquared.linear_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,2) = Rsquared.linear_mdl_out.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,3) = Rsquared.interactions_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,4) = Rsquared.chosen_interactions1_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,5) = Rsquared.chosen_interactions2_mdl.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,6) = MaxR2_mouse.tau(mousenum);
    Compare_models_R2(mousenum,7) = MaxR2_mouse.learnslope(mousenum);
    Compare_models_R2(mousenum,8) = MaxR2_mouse.chosen_interactions5_mdl.tau_max(mousenum);
    Compare_models_R2(mousenum,9) = Rsquared.interactions_mdl_out1.(Mouse_names{mousenum});
    Compare_models_R2(mousenum,10) = Rsquared.linear_mdl_out1.(Mouse_names{mousenum});
    
end

figure
[R2_pval , R2_stats]= MakeSpreadAndBoxPlot3_SB({Compare_models_R2(:,1) Compare_models_R2(:,2) Compare_models_R2(:,3)...
    Compare_models_R2(:,4) Compare_models_R2(:,5) Compare_models_R2(:,6) Compare_models_R2(:,7) Compare_models_R2(:,8)...
    Compare_models_R2(:,9) Compare_models_R2(:,10)},...
    {[1 0 0],[0 0 1],[1 0.7 0], [0.8 0 1],[1 0 0],[0 0 1],[1 0.7 0],[0.8 0 1],[1 0 0],[0 0 1]},[1 2 3 4 5 6 7 8 9 10],...
    {'Linear all','Linear without TFz and cumul', 'All interactions', 'Int1', 'Int2', 'Int3', 'Int4', 'Int5', 'All Int without TFz', 'Linear without TFz'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
title('R2 deviance of different models for all mice', 'FontSize', 25);
ylim([0 1])
hline(0.18)
% the deviance seems to be highly correlated with the size of the
% observations, which is coherent with its definition

% Int4 seems to be the best compromize between having not too much
% explicative variables and explaining a good part of the variance of our data 

