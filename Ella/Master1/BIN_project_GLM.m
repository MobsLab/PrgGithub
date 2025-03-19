%% Objectives of the code
SavePath = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella';


%% Run the models for the selected mice
% We removed mice that have not learned (1393 spends 25% of her time
% in the shock zone in post cond) or that have freezed less than 40s (779,1170, 9205)
Mouse_ALL=[688 739 777 849 893 1171 9184 1189 1391 1392 1394];

%% Generate data for all mice that have learned (from Data_For_Model_BM.m)
Session_type={'Cond'};% sessions can be added
for sess=1:length(Session_type)
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) ,NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',[688 739 777 849 893 1171 9184 1189 1391 1392 1394],lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end

% The data is extracted by computing the median in bins of 2 seconds
for mousenum=1:length(Mouse_ALL)
    Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    clear ep ind_to_use Sta Sto
    i=1;
    Sta = Start(Epoch1.Cond{mousenum, 3});
    Sto = Stop(Epoch1.Cond{mousenum, 3});
    
    for ep=1:length(Start(Epoch1.Cond{mousenum, 3}))
       ShockTime_Fz_Distance_pre.(Mouse_names{mousenum}) = Start(Epoch1.Cond{mousenum, 2})-Start(subset(Epoch1.Cond{mousenum, 3},ep));

       ShockTime_Fz_Distance.(Mouse_names{mousenum}) = abs(max(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})<0))/1e4);
       if isempty(ShockTime_Fz_Distance.(Mouse_names{mousenum})); ShockTime_Fz_Distance.(Mouse_names{mousenum})=NaN; end

       for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1 % bin of 2s or less
           SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin)*1e4);
           PositionArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))));
           OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum})))); 
           try RipplesDensityArray.(Mouse_names{mousenum})(i) = sum(length(Data(Restrict(TSD_DATA.Cond.ripples.ts{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))))); end
           GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(bin-1);       
           TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(bin-1);       
           TimepentFreezing.(Mouse_names{mousenum})(i) = 2*(bin-1);
           i=i+1;
       end
       
       ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice

       SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{mousenum, 3},ep))); % last small epoch is a bin with time < 2s
       PositionArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       try RipplesDensityArray.(Mouse_names{mousenum})(i) = sum(length(Data(Restrict(TSD_DATA.Cond.ripples.ts{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))))); end
       GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(ind_to_use);
       TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(ind_to_use);
       try TimepentFreezing.(Mouse_names{mousenum})(i) = 2*bin; catch; TimepentFreezing.(Mouse_names{mousenum})(i) = 0; end

      % shock entries & stim number
      % Between freezing epoch
      if ep==1
          BetweenEpoch = intervalSet(0 , Sta(ep));
      else
          BetweenEpoch = intervalSet(Sto(ep-1) , Sta(ep));
      end
      
      % Shock zone entries
      ShockZoneEpoch.(Mouse_names{mousenum}) = and(Epoch1.Cond{mousenum, 7} , BetweenEpoch); 
      
      clear StaShock StoShock
      StaShock = Start(ShockZoneEpoch.(Mouse_names{mousenum})); 
      StoShock = Stop(ShockZoneEpoch.(Mouse_names{mousenum}));
      
      try % zone epoch only considered if longer than 1s and merge with 1s
          clear ind_to_use_shock; ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
          StaShock=StaShock([true ; ~ind_to_use_shock]);
          StoShock=StoShock([~ind_to_use_shock ; true]);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=intervalSet(StaShock , StoShock);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=dropShortIntervals(ShockZoneEpoch_Corrected.(Mouse_names{mousenum}),1e4);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=mergeCloseIntervals(ShockZoneEpoch_Corrected.(Mouse_names{mousenum}),1e4);
      catch
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum}) = intervalSet([],[]);
      end
      ShockZoneEntries.(Mouse_names{mousenum}) = length(Start(ShockZoneEpoch_Corrected.(Mouse_names{mousenum})));
      if ShockZoneEntries.(Mouse_names{mousenum})==0; ShockZoneEntries.(Mouse_names{mousenum})=-1; end
      if ep==1
          ShockZoneEntriesArray.(Mouse_names{mousenum})(1) = ShockZoneEntries.(Mouse_names{mousenum});
      else
          ShockZoneEntriesArray.(Mouse_names{mousenum})(ind_start(ep-1)) = ShockZoneEntries.(Mouse_names{mousenum});
      end
      
      % Eyelid stims
      EyelidEpoch.(Mouse_names{mousenum}) = and(Epoch1.Cond{mousenum, 2} , BetweenEpoch); 
      EyelidNumber.(Mouse_names{mousenum}) = length(Start(EyelidEpoch.(Mouse_names{mousenum})));
      if EyelidNumber.(Mouse_names{mousenum})==0; EyelidNumber.(Mouse_names{mousenum})=-1; end
      if ep==1
          EyelidNumberArray.(Mouse_names{mousenum})(1) = EyelidNumber.(Mouse_names{mousenum});
      else
          EyelidNumberArray.(Mouse_names{mousenum})(ind_start(ep-1)) = EyelidNumber.(Mouse_names{mousenum});
      end
      
      i=i+1;
      ind_start(ep) = i;
      
    end
    
    ShockZoneEntriesArray.(Mouse_names{mousenum})(ShockZoneEntriesArray.(Mouse_names{mousenum})==0)=NaN;
    ShockZoneEntriesArray.(Mouse_names{mousenum})(ShockZoneEntriesArray.(Mouse_names{mousenum})==-1)=0;
    ShockZoneEntriesArray.(Mouse_names{mousenum}) = cumsum(ShockZoneEntriesArray.(Mouse_names{mousenum}),'omitnan');
    ShockZoneEntriesArray.(Mouse_names{mousenum})(length(ShockZoneEntriesArray.(Mouse_names{mousenum})):length(TimeSinceLastShockArray.(Mouse_names{mousenum}))) = ShockZoneEntriesArray.(Mouse_names{mousenum})(end);
    
    EyelidNumberArray.(Mouse_names{mousenum})(EyelidNumberArray.(Mouse_names{mousenum})==0)=NaN;
    EyelidNumberArray.(Mouse_names{mousenum})(EyelidNumberArray.(Mouse_names{mousenum})==-1)=0;
    EyelidNumberArray.(Mouse_names{mousenum}) = cumsum(EyelidNumberArray.(Mouse_names{mousenum}),'omitnan');
    EyelidNumberArray.(Mouse_names{mousenum})(length(EyelidNumberArray.(Mouse_names{mousenum})):length(TimeSinceLastShockArray.(Mouse_names{mousenum}))) = EyelidNumberArray.(Mouse_names{mousenum})(end);
    
    
    Timefreezing_cumul.(Mouse_names{mousenum})(1) = 0;
    for j=2:length(TimepentFreezing.(Mouse_names{mousenum}))
        if TimepentFreezing.(Mouse_names{mousenum})(j) == 0
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1);
        else
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1) + 2;
        end
    end

%     try TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})' RipplesDensityArray.(Mouse_names{mousenum})']; end
    TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})'];

end 

save(SavePath, 'TotalArray_mouse', 'Mouse_ALL') 
load('TotalArray_mouse.mat')
load('Mouse_ALL')

%% Fitted parameters on train and GLM array

% Create a structure with these parameters
Best_Fitted_variables.INT10.LearnSlope = [0.0100 0.0100 0.0065 0.0060 0.0065 0.0015 0.0045 1.0000e-03 0.0015 0.0050 0.0100];
Best_Fitted_variables.INT10.LearnPoint = [0.3000 0.8000 0.6000 0.5000 0.8000 0.7000 0.1000 0.6000 0.9000 0.9000 0.8000];

% Fit10 : Fit 8 without GT
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
%     Fit10_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
end 

%% Cross-validation on the episodes

% Create train and test arrays
for mousenum=1:length(Mouse_ALL)
    Index_fzepisodes.(Mouse_names{mousenum}) = find(TimepentFreezing.(Mouse_names{mousenum})==0);
    Length_fzepisodes.(Mouse_names{mousenum}) = diff(Index_fzepisodes.(Mouse_names{mousenum}));
    Length_fzepisodes.(Mouse_names{mousenum})(end+1) = length(TimepentFreezing.(Mouse_names{mousenum}))-Index_fzepisodes.(Mouse_names{mousenum})(end)+1;
    IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,1) = Index_fzepisodes.(Mouse_names{mousenum});
    IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,2) = Length_fzepisodes.(Mouse_names{mousenum});
    Random_permutation_fzep.(Mouse_names{mousenum}) = randperm(length(IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,1)));
end

% INT10
for mousenum=1:length(Mouse_ALL)
    
    indset = 1;
    for j=1:length(Random_permutation_fzep.(Mouse_names{mousenum}))
        
        clear ind_picked_episode picked_episode_start picked_episode_length
        ind_picked_episode = Random_permutation_fzep.(Mouse_names{mousenum})(j);
        picked_episode_start = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,1);
        picked_episode_length = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,2);
        
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(1,:) = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start,:));
        for i=1:picked_episode_length-1
            Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(i+1,:) = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start+i,:));
        end
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table = array2table(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table, 'VariableNames',Fit10varNames);
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table = rmmissing(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table);
        
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit10varNames);
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table);

        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
        for i=1:length(Index_fzepisodes.(Mouse_names{mousenum}))-1
            clear ind_episode episode_length
            ind_episode = Index_fzepisodes.(Mouse_names{mousenum})(i);
            episode_length = Length_fzepisodes.(Mouse_names{mousenum})(i);
            Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,6) = nanmean(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,6));
        end
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(~isnan(table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum})(:,6))),:);
        %% Coordonner les NaN ensemble pour avoir la même taille au final
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit10varNames);
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table);
        
        
        indset = indset + 1;
    end
    
end

%% Run GLMs

%% INT10
for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = fitglm(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table;
        Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Deviance;
        LR.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Coefficients;
        
        Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Testset(indset).Value = table2array(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(:,6));
        [Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).Value, Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).CI] = predict(Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train
for mousenum=1:length(Mouse_ALL)
    indset=1;
    Array_Test_corr.Fit10.(Mouse_names{mousenum}) = [];
    Array_Predict_corr.Fit10.(Mouse_names{mousenum}) = [];
    for i=1:size(Array_Test.Fit10.(Mouse_names{mousenum}).Testset,2)
        Array_Test_corr.Fit10.(Mouse_names{mousenum}) = [Array_Test_corr.Fit10.(Mouse_names{mousenum}), Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Testset(indset).Value'];
        Array_Predict_corr.Fit10.(Mouse_names{mousenum}) = [Array_Predict_corr.Fit10.(Mouse_names{mousenum}), Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).Value'];
    indset=indset+1;
    end
end

% Compute R2 
for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit10(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit10(mousenum)=struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit10.Train = corrcoef(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit10.Test = corrcoef(Array_Test_corr.Fit10.(Mouse_names{mousenum}), Array_Predict_corr.Fit10.(Mouse_names{mousenum})).^2;
    Rsquared_Train_Fit10(mousenum)=Corr_coef.Fit10.Train(1,2);
    Rsquared_Test_Fit10(mousenum)=Corr_coef.Fit10.Test(1,2);
end

% Compute p values of predictors
for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit10(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit10(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(3,4));
    Compare_significant_predictors.Fit10(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(4,4));%Position
    Compare_significant_predictors.Fit10(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(5,4));
    Compare_significant_predictors.Fit10(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(6,4));
end

% Predictors
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit10(:,1)...
    Compare_significant_predictors.Fit10(:,2) Compare_significant_predictors.Fit10(:,3) Compare_significant_predictors.Fit10(:,4) Compare_significant_predictors.Fit10(:,5)}, ...
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

%% Separate the errors of the fit due to 
%%% low fluctuations : the error on the mean frequency in each episode
%%% high fluctuations : the error on the evolution of the frequency in a given episode (substract the mean of each episode to the raw and fitted data) 

% Compute R2 on mean episodes frequencies and on the frequencies to which
% the mean is substracted
for mousenum=1:length(Mouse_ALL)
    clear common_ind mean_freq_episodes Corr_coef.Fit10.Train Corr_coef.Fit10.Mean_Train Corr_coef.Fit10.Test
    common_ind = ismember(table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6));
    Corr_coef.Fit10.Mean_Train = corrcoef(mean_freq_episodes(common_ind), table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Rsquared_Mean_Train_Fit10(mousenum)=Corr_coef.Fit10.Mean_Train(1,2);
    
    NormEpTrainArray.(Mouse_names{mousenum}) = table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6))- mean_freq_episodes(common_ind);
    NormEpFittedArray.(Mouse_names{mousenum}) = table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)) - mean_freq_episodes(common_ind);
    Corr_coef.Fit10.Norm_Train = corrcoef(NormEpTrainArray.(Mouse_names{mousenum}), NormEpFittedArray.(Mouse_names{mousenum})).^2;
    Rsquared_Norm_Train_Fit10(mousenum)=Corr_coef.Fit10.Norm_Train(1,2);
end

% GOF on observations
figure
MakeSpreadAndBoxPlot3_ECSB({Mean_Rsquared_deviance_Train_Fit10' Rsquared_Test_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT10 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit10))

% GOF on the mean episode frequency
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train_Fit10' Rsquared_Mean_Train_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'2s bin','episode mean'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT10 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

% GOF on mean episode frequency and substracted mean
% figure
% MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train_Fit10' Rsquared_Mean_Train_Fit10' Rsquared_Norm_Train_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45] [0.4 0.2 0.9]},...
%     [1 2 3],{'2s bin','episode mean', 'substract mean'},'paired',1,'showpoints',0);
% % ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
% ylabel('GOF INT10 model');
% xlim([0.5 3.5])
% ylim([0 1])
% xtickangle(45);
% set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

