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

%% ARIMA model

% Test if the series is stationary 

for mousenum=1:length(Mouse_ALL)
    [h(mousenum,:), pval(mousenum,:), stat(mousenum,:), cval(mousenum,:), reg(mousenum,:)] = adftest(OB_FrequencyArray.(Mouse_names{mousenum}));
end

% This is not the best model fitted with our data that evolves dynamically
% in time and that is not stationary 

%% 1D CNN 

%%% Only with the temporal series

clear data sequenceLength dataTrain splitratio splitIdx XTrain XTest YTrain YTest options layers net
% Create sequencies for the training of the CNN
data = OB_FrequencyArray.M1189;
sequenceLength = round(0.2*length(data));  % Length of each train sequence, helps the model to learns schemes at different timescales 
seq = buffer(data, sequenceLength, sequenceLength-1, 'nodelay'); % Creates sequences with 90% of the data, each sequence begins with the next value 

% Create a table with the sequencies 
% dataTrain = array2table(seq);

% Création des données pour le CNN 1D
XTrain = seq(1:end-1, :);  % Utilisez toutes les séquences sauf la dernière comme données d'entrée
YTrain = seq(end, :);  % Utilisez la dernière séquence comme étiquettes de sortie

% Transposez les données pour avoir la bonne forme
XTrain = XTrain';  % (numObservations, sequenceLength)
YTrain = YTrain';  % (numObservations, 1)


% Divide in train and test sets
splitRatio = 0.8;
splitIdx = floor(splitRatio * size(XTrain, 1));

XTrainSplit = XTrain(1:splitIdx, :);
YTrainSplit = YTrain(1:splitIdx, :);
XTest = XTrain(splitIdx+1:end, :);
YTest = YTrain(splitIdx+1:end, :);
% 
% dataTrain = table2array(dataTrain);
% 
% XTrain = dataTrain(1:splitIdx, 1:end-1);
% YTrain = dataTrain(1:splitIdx, end);
% XTest = dataTrain(splitIdx+1:end, 1:end-1);
% YTest = dataTrain(splitIdx+1:end, end);

% Create and define a CNN
layers = [
    sequenceInputLayer(sequenceLength)
    convolution2dLayer([3, 1], 16, 'Padding', 'same') %1D CNN 
    reluLayer()
    fullyConnectedLayer(1)
    regressionLayer()
];

% Train the network
options = trainingOptions('sgdm', ...  % SGD (no adam in this version)
    'MaxEpochs', 20, ...
    'MiniBatchSize', 10, ...
    'InitialLearnRate', 0.001);
net = trainNetwork(XTrainSplit, YTrainSplit, layers, options);



