%% Objectives of the code
% Cross-validate on episodes
% Compare the error on the high and low fluctuations
% Finely quantify the error 

clear all
filepath = '/home/ratatouille/Dropbox/Kteam/PrgMatlab/Ella';

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

    try TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})' RipplesDensityArray.(Mouse_names{mousenum})']; end
%     TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})'];

end 

% save('Mouse_ALL.mat')
% load('TotalArray_mouse.mat')
%% Fitted parameters on train and GLM array

% Create a structure with these parameters : these have to be fitted again if 
% the raw data changes
Best_Fitted_variables.INT10.LearnSlope = [0.0090 1.0000e-03 0.0025 1.0000e-03 0.0065 0.0100 0.0045 0.0020 1.0000e-03 0.0045 0.0100];
Best_Fitted_variables.INT10.LearnPoint = [0.9000 0.5000 0.7000 0.6000 0.8000 0.4000 0.1000 0.4000 0.9000 0.9000 0.5000];

Best_Fitted_variables.INT13.LearnSlope = [0.0055 0.0100 0.0050 1.0000e-03 0.0100 0.0100 1.0000e-03 1.0000e-03 0.0030 0.0055 0.0055];
Best_Fitted_variables.INT13.LearnPoint = [0.1538 0.0769 0.3846 0.3077 0.4615 0.6154 0.4615 0.3077 0.1538 0.6923 0.2308];

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

% Fit13 : simple model
Fit13varNames = {'TimeSinceLastShockArray', 'SigPositionxFit13SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit13SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT13.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT13.LearnPoint(mousenum)))));
    Fit13_GLMArray_mouse.(Mouse_names{mousenum}) = ...
        table(TimeSinceLastShockArray.(Mouse_names{mousenum})', ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit13SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit13varNames);
%     Fit13_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit13_GLMArray_mouse.(Mouse_names{mousenum}));
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
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        
        indices_final = ismember(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(:,5), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(:,5)));
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(indices_final,:);
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit10varNames);
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table);
        
        indset = indset + 1;
    end
    
end

% INT13
for mousenum=1:length(Mouse_ALL)
    
    indset = 1;
    for j=1:length(Random_permutation_fzep.(Mouse_names{mousenum}))
        
        clear ind_picked_episode picked_episode_start picked_episode_length
        ind_picked_episode = Random_permutation_fzep.(Mouse_names{mousenum})(j);
        picked_episode_start = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,1);
        picked_episode_length = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,2);
        
        Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table(1,:) = table2array(Fit13_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start,:));
        for i=1:picked_episode_length-1
            Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table(i+1,:) = table2array(Fit13_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start+i,:));
        end
        Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table = array2table(Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table, 'VariableNames',Fit13varNames);
        Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table = rmmissing(Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table);
        
        Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit13_GLMArray_mouse.(Mouse_names{mousenum}));
        Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit13varNames);
        Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table);

        Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit13_GLMArray_mouse.(Mouse_names{mousenum}));
        for i=1:length(Index_fzepisodes.(Mouse_names{mousenum}))-1
            clear ind_episode episode_length
            ind_episode = Index_fzepisodes.(Mouse_names{mousenum})(i);
            episode_length = Length_fzepisodes.(Mouse_names{mousenum})(i);
            Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,3) = nanmean(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,3));
        end
        Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        
        indices_final = ismember(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(:,1), table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(:,1)));
        Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table(indices_final,:);
        Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit13varNames);
        Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table);
        
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

% GOF on observations
figure
MakeSpreadAndBoxPlot3_ECSB({Mean_Rsquared_deviance_Train_Fit10' Rsquared_Test_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
ylabel('GOF INT10 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit10))

% Compute p values of predictors
for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit10(mousenum,:) = table2array(Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table(2:6,4));
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
    clear mean_freq_episodes Corr_coef.Fit10.Train Corr_coef.Fit10.Mean_Train Corr_coef.Fit10.Test
    mean_freq_episodes = table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6));
    Corr_coef.Fit10.Mean_Train = corrcoef(mean_freq_episodes, table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Rsquared_Mean_Train_Fit10(mousenum)=Corr_coef.Fit10.Mean_Train(1,2);
    
    NormEpTrainArray.(Mouse_names{mousenum}) = table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6))- mean_freq_episodes;
    NormEpFittedArray.(Mouse_names{mousenum}) = table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)) - mean_freq_episodes;
    Corr_coef.Fit10.Norm_Train = corrcoef(NormEpTrainArray.(Mouse_names{mousenum}), NormEpFittedArray.(Mouse_names{mousenum})).^2;
    Rsquared_Norm_Train_Fit10(mousenum)=Corr_coef.Fit10.Norm_Train(1,2);
end

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
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train_Fit10' Rsquared_Mean_Train_Fit10' Rsquared_Norm_Train_Fit10'},{[0.9 0.7 0.1] [0.2 0.7 0.45] [0.4 0.2 0.9]},...
    [1 2 3],{'2s bin','episode mean', 'substract mean'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT10 model');
xlim([0.5 3.5])
ylim([0 1])
xtickangle(45);
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

%% Fine analysis of the error

% First type of plot
% Error in the prediction along episode bins
mousenum=1;
clear diff_fit_raw episode_indices segments
diff_fit_raw = table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)) - table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6));
episode_indices = find(diff(table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6))) ~= 0);
segments = cell(1, length(episode_indices));
start_idx = 1;
for i = 1:length(episode_indices)
    end_idx = episode_indices(i);
    segments{i} = diff_fit_raw(start_idx:end_idx);
    start_idx = end_idx + 1;
end

figure;
hold on;
for i = 1:length(segments)
    plot(0:(length(segments{i}) - 1), segments{i});
end
makepretty
xlabel('Episode length (s)')
episode_labels = 0:2:20;
xticklabels(cellstr(num2str(episode_labels'))); % Set x-axis labels from 0 to 20 with pairs
ylabel('Difference between raw and fitted data')
%%% Is the error due to a bad fitting of the begining of the episodes or to
%%% the fact we can't fit rapid fluctuations 

%% Absolute error in the prediction along episode bins
mousenum=1;
clear diff_fit_raw episode_indices segments
% Find the indices where the values change
diff_fit_raw = abs(table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)) - table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)));
episode_indices = find(diff(table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6))) ~= 0);
segments = cell(1, length(episode_indices)); %Initialize segments
% Segment the data based on changes in values
start_idx = 1;
for i = 1:length(episode_indices)
    end_idx = episode_indices(i);
    segments{i} = diff_fit_raw(start_idx:end_idx);
    start_idx = end_idx + 1;
end

figure;
hold on;
for i = 1:length(segments)
    plot(0:(length(segments{i}) - 1), segments{i});
end
makepretty
xlabel('Episode length')
episode_labels = 0:2:20;
xticklabels(cellstr(num2str(episode_labels'))); % Set x-axis labels from 0 to 20 with pairs
ylabel('Absolute difference between raw and fitted data')

% Mean and std of long and short episodes
% Separate segments based on their length
short_segments = {};
long_segments = {};
threshold_length = 3;

for i = 1:length(segments)
    if length(segments{i}) <= threshold_length
        short_segments = [short_segments, segments{i}];
    else
        long_segments = [long_segments, segments{i}];
    end
end

% Calculate mean and std for both groups
mean_short = mean(cellfun(@mean, short_segments));
std_short = mean(cellfun(@std, short_segments));

mean_long = mean(cellfun(@mean, long_segments));
std_long = mean(cellfun(@std, long_segments));

% Plotting mean and std
figure;
bar([mean_short, mean_long]);
hold on;
errorbar([mean_short, mean_long], [std_short, std_long], 'k.', 'LineWidth', 1);
xticks([1, 2]);
xticklabels({'Short Episodes', 'Long Episodes > 4s'});
ylabel('Value');
title('Mean and Standard Deviation of Episodes');

% Comparing the errors 
[p, h, stats] = signrank(mean_short, mean_long);
disp(['Wilcoxon signed-rank test p-value: ', num2str(p)]);
disp(['Test statistics: ', num2str(stats.signedrank)]);

% Only with the 3 first values in each episode
% Extract the first 3 values from each segment
first_three_short = cellfun(@(x) x(1:min(3, length(x))), short_segments, 'UniformOutput', false);
first_three_long = cellfun(@(x) x(1:min(3, length(x))), long_segments, 'UniformOutput', false);

% Calculate mean and std for the first three values in both groups
mean_first_three_short = mean(cellfun(@mean, first_three_short));
std_first_three_short = mean(cellfun(@std, first_three_short));

mean_first_three_long = mean(cellfun(@mean, first_three_long));
std_first_three_long = mean(cellfun(@std, first_three_long));

% Plotting mean and std of the first three values
figure;
bar([mean_first_three_short, mean_first_three_long]);
hold on;
errorbar([mean_first_three_short, mean_first_three_long], [std_first_three_short, std_first_three_long], 'k.', 'LineWidth', 1);
xticks([1, 2]);
xticklabels({'First 3 Values (Short)', 'First 3 Values (Long)'});
ylabel('Absolute error');
title('Mean and Standard Deviation of First 3 Values in Episodes');

[p, h, stats] = signrank(mean_first_three_short, mean_first_three_long);
disp(['Wilcoxon signed-rank test p-value: ', num2str(p)]);
disp(['Test statistics: ', num2str(stats.signedrank)]);

%% Plot short and long episodes separately

% Plot short segments
figure;
% subplot(2, 1, 1);
hold on;
for i = 1:length(short_segments)
    plot(0:(length(short_segments{i}) - 1), short_segments{i});
end
hold off;
makepretty
xlabel('Episode length')
episode_labels = 0:1:4;
xticklabels(cellstr(num2str(episode_labels'))); % Set x-axis labels from 0 to 20 with pairs
ylabel('Absolute difference between raw and fitted data')
title('Short Episodes');

% Plot long segments
figure
% subplot(2, 1, 2);
hold on;
for i = 1:length(long_segments)
    plot(0:(length(long_segments{i}) - 1), long_segments{i});
end
hold off;
makepretty
xlabel('Episode length')
episode_labels = 0:4:20;
xticklabels(cellstr(num2str(episode_labels'))); % Set x-axis labels from 0 to 20 with pairs
ylabel('Absolute difference between raw and fitted data')
title('Long Episodes');

%% Plot the mean error for a given position in the episode
% Generate a matrix ouf of the cells
for i=1:length(short_segments)
   ShortEp(i,1:length(short_segments{i})) = short_segments{i};
end
ShortEp(ShortEp==0)=NaN;

for i=1:length(long_segments)
   LongEp(i,1:length(long_segments{i})) = long_segments{i};
end
LongEp(LongEp==0)=NaN;

% Shaded plot
figure
Data_to_use = ShortEp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:3] , Mean_All_Sp,Conf_Inter,'-r',1); hold on;

Data_to_use = LongEp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:11] , Mean_All_Sp,Conf_Inter,'-b',1); hold on;

xlabel('Episode length')
episode_labels = 0:2:20;
xticklabels(cellstr(num2str(episode_labels'))); % Set x-axis labels from 0 to 20 with pairs
ylabel('Mean absolute difference between raw and fitted data')
makepretty

%% Second type of plot
clear x_values y_values c_values

% Plotting each segment with jitter in x and y, and color
figure;
hold on;
for i = 1:length(segments)
    segment_length = length(segments{i});
    x_values = (0:(segment_length - 1)) + 0.18 * randn(1, segment_length);
    y_values = ones(1, segment_length) * segment_length + 0.18 * randn(1, segment_length);
    c_values = segments{i};
    
    % Scatter plot for each segment
    scatter(x_values, y_values, 30, log(c_values), 'filled');
end
colormap('jet');
colorbar;
hold off;
xlabel('Position in Segment (X-axis)');
ylabel('Segment Length (Y-axis)');
episode_labels = 0:2:20;
yticklabels(cellstr(num2str(episode_labels')));
title('Data Representation on Color Scale with Jitter');
%% INT13
for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = fitglm(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table;
        Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table.Deviance;
        LR.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table = Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table.Coefficients;
        
        Array_Test_frequencies.Fit13.(Mouse_names{mousenum}).Testset(indset).Value = table2array(Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table(:,3));
        [Test_mdl.Fit13.(Mouse_names{mousenum}).Testset(indset).Value, Test_mdl.Fit13.(Mouse_names{mousenum}).Testset(indset).CI] = predict(Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(indset).table, Array_Test.Fit13.(Mouse_names{mousenum}).Testset(indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train
for mousenum=1:length(Mouse_ALL)
    indset=1;
    Array_Test_corr.Fit13.(Mouse_names{mousenum}) = [];
    Array_Predict_corr.Fit13.(Mouse_names{mousenum}) = [];
    for i=1:size(Array_Test.Fit13.(Mouse_names{mousenum}).Testset,2)
        Array_Test_corr.Fit13.(Mouse_names{mousenum}) = [Array_Test_corr.Fit13.(Mouse_names{mousenum}), Array_Test_frequencies.Fit13.(Mouse_names{mousenum}).Testset(indset).Value'];
        Array_Predict_corr.Fit13.(Mouse_names{mousenum}) = [Array_Predict_corr.Fit13.(Mouse_names{mousenum}), Test_mdl.Fit13.(Mouse_names{mousenum}).Testset(indset).Value'];
    indset=indset+1;
    end
end

% Compute R2 
for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit13(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit13(mousenum)=struct2array(Rsquared.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit13.Train = corrcoef(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit13.Test = corrcoef(Array_Test_corr.Fit13.(Mouse_names{mousenum}), Array_Predict_corr.Fit13.(Mouse_names{mousenum})).^2;
    Rsquared_Train_Fit13(mousenum)=Corr_coef.Fit13.Train(1,2);
    Rsquared_Test_Fit13(mousenum)=Corr_coef.Fit13.Test(1,2);
end

% Compute p values of predictors
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

%% Separate the error
% Compute R2 on mean episodes frequencies and on the frequencies to which
% the mean is substracted
for mousenum=1:length(Mouse_ALL)
    clear mean_freq_episodes Corr_coef.Fit13.Train Corr_coef.Fit13.Mean_Train Corr_coef.Fit13.Test
    mean_freq_episodes = table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3));
    Corr_coef.Fit13.Mean_Train = corrcoef(mean_freq_episodes, table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Rsquared_Mean_Train_Fit13(mousenum)=Corr_coef.Fit13.Mean_Train(1,2);
    
    NormEpTrainArray.(Mouse_names{mousenum}) = table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3))- mean_freq_episodes;
    NormEpFittedArray.(Mouse_names{mousenum}) = table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)) - mean_freq_episodes;
    Corr_coef.Fit13.Norm_Train = corrcoef(NormEpTrainArray.(Mouse_names{mousenum}), NormEpFittedArray.(Mouse_names{mousenum})).^2;
    Rsquared_Norm_Train_Fit13(mousenum)=Corr_coef.Fit13.Norm_Train(1,2);
end

% GOF on observations
figure
MakeSpreadAndBoxPlot3_ECSB({Mean_Rsquared_deviance_Train_Fit13' Rsquared_Test_Fit13'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT13 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit13))

% GOF on the mean episode frequency
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train_Fit13' Rsquared_Mean_Train_Fit13'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'2s bin','episode mean'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT13 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)

% GOF on mean episode frequency and substracted mean
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_Train_Fit13' Rsquared_Mean_Train_Fit13' Rsquared_Norm_Train_Fit13'},{[0.9 0.7 0.1] [0.2 0.7 0.45] [0.4 0.2 0.9]},...
    [1 2 3],{'2s bin','episode mean', 'substract mean'},'paired',1,'showpoints',0);
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('GOF INT13 model');
xlim([0.5 3.5])
ylim([0 1])
xtickangle(45);
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)



%% Visualize the results

%% INT10

% Lock all the parameters to the data in an array for a given model (different
% trainsets and we remove the raws in which there is at least one NaN value)
for mousenum=1:length(Mouse_ALL)
    clear Mod_ind
    Mod_ind = ismember(TotalArray_mouse.(Mouse_names{mousenum})(:,1), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)));
    % Extract indexes of frequencies available in my trainset array that
    % correspond to a frequency in the total array (selected observations)
    PositionArray.Fit10.(Mouse_names{mousenum}) = PositionArray.(Mouse_names{mousenum})(Mod_ind);
    try RipplesDensityArray.Fit10.(Mouse_names{mousenum}) = RipplesDensityArray.(Mouse_names{mousenum})(Mod_ind); end
    ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}) = ShockZoneEntriesArray.(Mouse_names{mousenum})(Mod_ind);
    NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}) = diff(ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}));
    NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum})(1) = ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum})(1);
    EyelidNumberArray.Fit10.(Mouse_names{mousenum}) = EyelidNumberArray.(Mouse_names{mousenum})(Mod_ind);
    NumEyelidNumberArray.Fit10.(Mouse_names{mousenum}) = diff(EyelidNumberArray.Fit10.(Mouse_names{mousenum}));
    NumEyelidNumberArray.Fit10.(Mouse_names{mousenum})(1) = EyelidNumberArray.Fit10.(Mouse_names{mousenum})(1);
end

% Add shock zone entries and eyelid stimulations 
figure
for mousenum=1:length(Mouse_ALL) 
    % plot mean episode frequency and fitted data
    clear common_ind mean_freq_episodes
    subplot(4,3,mousenum)
%     plot(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), 'x'), hold on 
    common_ind = ismember(table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6));
    plot(mean_freq_episodes(common_ind), 'x'), hold on
    plot(table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    plot(PositionArray.Fit10.(Mouse_names{mousenum}))
    makepretty
    
    % plot ripples
    clear x y color
    try x = 1:length(RipplesDensityArray.(Mouse_names{mousenum}));
    y = 1.5*ones(1,length(RipplesDensityArray.(Mouse_names{mousenum})))+rand(1, length(RipplesDensityArray.(Mouse_names{mousenum})));
    color = RipplesDensityArray.(Mouse_names{mousenum});
    scatter(x,y,[],color); end
    hold on;
    colormap(brewermap(8,'Reds'))
    if mousenum==2; title('INT10'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 10])

    % plot shock zone entries 
    clear ind x y sz vect
    x = NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 8*ones(1,length(vect));
    scatter(vect, y, 10*sz)
%     plot(8+((ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}))./max(ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}))));
    
    % plot shocks
    clear ind x y sz vect
    x = NumEyelidNumberArray.Fit10.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 10*ones(1,length(vect));
    scatter(vect, y, 10*sz)
    
end
subplot(4,3,12); colorbar; caxis([0 7]);
saveas(gcf, fullfile(filepath, 'Mean_episodes_INT10'), 'png');






%% INT13

% Lock all the parameters to the data in an array for a given model (different
% trainsets and we remove the raws in which there is at least one NaN value)
for mousenum=1:length(Mouse_ALL)
    clear Mod_ind
    Mod_ind = ismember(TotalArray_mouse.(Mouse_names{mousenum})(:,1), table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)));
    % Extract indexes of frequencies available in my trainset array that
    % correspond to a frequency in the total array (selected observations)
    PositionArray.Fit13.(Mouse_names{mousenum}) = PositionArray.(Mouse_names{mousenum})(Mod_ind);
    try RipplesDensityArray.Fit13.(Mouse_names{mousenum}) = RipplesDensityArray.(Mouse_names{mousenum})(Mod_ind); end
    ShockZoneEntriesArray.Fit13.(Mouse_names{mousenum}) = ShockZoneEntriesArray.(Mouse_names{mousenum})(Mod_ind);
    NumShockZoneEntriesArray.Fit13.(Mouse_names{mousenum}) = diff(ShockZoneEntriesArray.Fit13.(Mouse_names{mousenum}));
    NumShockZoneEntriesArray.Fit13.(Mouse_names{mousenum})(1) = ShockZoneEntriesArray.Fit13.(Mouse_names{mousenum})(1);
    EyelidNumberArray.Fit13.(Mouse_names{mousenum}) = EyelidNumberArray.(Mouse_names{mousenum})(Mod_ind);
    NumEyelidNumberArray.Fit13.(Mouse_names{mousenum}) = diff(EyelidNumberArray.Fit13.(Mouse_names{mousenum}));
    NumEyelidNumberArray.Fit13.(Mouse_names{mousenum})(1) = EyelidNumberArray.Fit13.(Mouse_names{mousenum})(1);
end

% Figure with raw signal and runmeaned curve (cf runmean_BM)
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), 'x'), hold on 
    plot(table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
%     for i=1:20
    plot(runmean_BM(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)),5)), hold on
    plot(PositionArray.Fit13.(Mouse_names{mousenum}))
%     end
    makepretty
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Frequency (Hz)', 'FontSize', 20)
    clear x y color
    try x = 1:length(RipplesDensityArray.(Mouse_names{mousenum}));
    y = 1.5*ones(1,length(RipplesDensityArray.(Mouse_names{mousenum})))+rand(1, length(RipplesDensityArray.(Mouse_names{mousenum})));
    color = RipplesDensityArray.(Mouse_names{mousenum});
    scatter(x,y,[],color); end
    colormap(brewermap(8,'Reds'))
    
    
    if mousenum==2; title('INT13'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 10])
    caxis([0 7])
end
subplot(4,3,12); colorbar;

% Figure with mean episode frequency
figure
for mousenum=1:length(Mouse_ALL) 
    clear common_ind mean_freq_episodes
    subplot(4,3,mousenum)
%     plot(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), 'x'), hold on 
    common_ind = ismember(table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3));
    plot(mean_freq_episodes(common_ind), 'x'), hold on
    plot(table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    plot(PositionArray.Fit13.(Mouse_names{mousenum}))
    makepretty
    
    if mousenum==2; title('INT13'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 8])
end

% Add ripples on mean episode frequency
figure
for mousenum=1:length(Mouse_ALL) 
    clear common_ind mean_freq_episodes
    subplot(4,3,mousenum)
%     plot(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), 'x'), hold on 
    common_ind = ismember(table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3));
    plot(mean_freq_episodes(common_ind), 'x'), hold on
    plot(table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    plot(PositionArray.Fit13.(Mouse_names{mousenum}))
    makepretty
    
    clear x y color
    try x = 1:length(RipplesDensityArray.(Mouse_names{mousenum}));
    y = 1.5*ones(1,length(RipplesDensityArray.(Mouse_names{mousenum})))+rand(1, length(RipplesDensityArray.(Mouse_names{mousenum})));
    color = RipplesDensityArray.(Mouse_names{mousenum});
    scatter(x,y,[],color); end
    colormap(brewermap(8,'Reds'))
    
    
    if mousenum==2; title('INT13'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 10])
    caxis([0 7])
end
subplot(4,3,12); colorbar;

% Add shock zone entries and eyelid stimulations 
figure
for mousenum=1:length(Mouse_ALL) 
    % plot mean episode frequency and fitted data
    clear common_ind mean_freq_episodes
    subplot(4,3,mousenum)
%     plot(table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3)), 'x'), hold on 
    common_ind = ismember(table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit13.(Mouse_names{mousenum}).Trainset(1).table(:,3));
    plot(mean_freq_episodes(common_ind), 'x'), hold on
    plot(table2array(Output_GLM.Train_mdl.Fit13.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    plot(PositionArray.Fit13.(Mouse_names{mousenum}))
    makepretty
    
    % plot ripples
    clear x y color
    try x = 1:length(RipplesDensityArray.(Mouse_names{mousenum}));
    y = 1.5*ones(1,length(RipplesDensityArray.(Mouse_names{mousenum})))+rand(1, length(RipplesDensityArray.(Mouse_names{mousenum})));
    color = RipplesDensityArray.(Mouse_names{mousenum});
    scatter(x,y,[],color); end
    hold on;
    colormap(brewermap(8,'Reds'))
    if mousenum==2; title('INT13'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 10])

    % plot shock zone entries 
    clear ind x y sz vect
    x = NumShockZoneEntriesArray.Fit13.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 8*ones(1,length(vect));
    scatter(vect, y, 10*sz)
%     plot(8+((ShockZoneEntriesArray.Fit13.(Mouse_names{mousenum}))./max(ShockZoneEntriesArray.Fit13.(Mouse_names{mousenum}))));
    
    % plot shocks
    clear ind x y sz vect
    x = NumEyelidNumberArray.Fit13.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 10*ones(1,length(vect));
    scatter(vect, y, 10*sz)
    
end
subplot(4,3,12); colorbar; caxis([0 7]);
































