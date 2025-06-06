% clear all
% PossibleBinNumbers = [5,10];
% SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/DecodingAnalysis';
% Variables = {'HR','BR','speed','position'};
% Regions = {'PFC','HPC'};
% Periods{1} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
% Periods{2} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
% Periods{3} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Freezing'};
% Periods{4} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Freezing'};
%
MinBinNum = 10;

POI_Te = 'Habituation';
POI_Tr = 'Wake_Home';
clear MnAcc_Tr MnAcc_Te MnAcc_TeRand
for mm = 1 :length(VarOfInterest.(POI_Tr))
    
    % Prepare train data
    Y_Tr = VarOfInterest.(POI_Tr){mm};
    X_Tr = spike_dat.(POI_Tr){mm}';
    BadGuys = find(isnan(Y_Tr));
    % Get rid of NANs
    Y_Tr(BadGuys) = [];
    X_Tr(BadGuys,:) = [];
    
    % Prepare test data
    Y_Te = VarOfInterest.(POI_Te){mm};
    X_Te = spike_dat.(POI_Te){mm}';
    BadGuys = find(isnan(Y_Te));
    % Get rid of NANs
    Y_Te(BadGuys) = [];
    X_Te(BadGuys,:) = [];
    
    Opts.ParamBinLims(1) = min([Opts.ParamBinLims(1),min(Y_Te),min(Y_Tr)]);
    Opts.ParamBinLims(end) = max([Opts.ParamBinLims(end),max(Y_Te),max(Y_Tr)]);
    
    
    % Make Y into classes
    [Y_Tr,edges] = discretize(Y_Tr,Opts.ParamBinLims);
    Y_Tr = edges(Y_Tr)';
    [Y_Te,edges] = discretize(Y_Te,Opts.ParamBinLims);
    Y_Te = edges(Y_Te)';
    
    % Equalize class distributions
    El_Te = hist(Y_Te,edges(1:end-1));
    El_Tr = hist(Y_Tr,edges(1:end-1));
    
    % Get rid of training bins withou enough data
    GoodClass_Tr = El_Tr>MinBinNum;
    GoodClass_Tr
    % Equalize the remaining class numbers
    EqualBinNumber = min(El_Tr(GoodClass_Tr));
    
    % Resample training data
    for perm = 1:1
        Y_Tr_Resampled = [];
        X_Tr_Resampled = [];
        for ed = 1:length(edges)-1
            Bins_temp = find(Y_Tr==edges(ed));
            Bins_temp = Bins_temp(randperm(length(Bins_temp),EqualBinNumber));
            Y_Tr_Resampled = [Y_Tr_Resampled;Y_Tr(Bins_temp)];
            X_Tr_Resampled = [X_Tr_Resampled;X_Tr(Bins_temp,:)];
        end
        
        % Get training accuracy (still CV)
        Mdl_Half = fitcknn(X_Tr_Resampled(1:2:end,:),Y_Tr_Resampled(1:2:end));
        X_Tr_Acc_CV = X_Tr_Resampled(2:2:end,:);
        Y_Tr_Acc_CV = Y_Tr_Resampled(2:2:end,:);
        BrPred_Tr = predict(Mdl_Half,X_Tr_Acc_CV);
        clear Acc_Tr
        for ed = 1:length(edges)-1
            Bins_temp = find(Y_Tr_Acc_CV==edges(ed));
            Acc_Tr(ed) = nanmean(BrPred_Tr(Bins_temp)==Y_Tr_Acc_CV(Bins_temp));
        end
        
        % Get test accuracy
        clear Acc_Te
        Mdl_All = fitcknn(X_Tr_Resampled,Y_Tr_Resampled);
        BrPred = predict(Mdl_All,X_Te);
        for ed = 1:length(edges)-1
            Bins_temp = find(Y_Te==edges(ed));
            Acc_Te(ed) = nanmean(BrPred(Bins_temp)==Y_Te(Bins_temp));
        end
        
        % Get test accuracy random
        clear Acc_TeRand
        BrPred = predict(Mdl_All,X_Te(randperm(size(X_Te,1),size(X_Te,1)),:));
        for ed = 1:length(edges)-1
            Bins_temp = find(Y_Te==edges(ed));
            Acc_TeRand(ed) = nanmean(BrPred(Bins_temp)==Y_Te(Bins_temp));
        end
        
        MnAcc_Tr(perm,mm) = nanmean(Acc_Tr(GoodClass_Tr));
        MnAcc_Te(perm,mm) = nanmean(Acc_Te(GoodClass_Tr));
        MnAcc_TeRand(perm,mm) = nanmean(Acc_TeRand(GoodClass_Tr));
    end
end
% clf
% subplot(211)
% plot(Acc_Tr)
% hold on
% plot(Acc_Te)
% line(xlim,[1 1]*0.2)
% subplot(212)
% plot(El_Tr)
%
figure
for mm = 1:7
    subplot(3,3,mm)
    A{1} = MnAcc_Tr(:);
    A{2} = MnAcc_Te(:);
    A{3} = MnAcc_TeRand(:);
    MakeSpreadAndBoxPlot_BM(A,[],[],{'Hab','Cond','Rand'},1,0)
    line(xlim,[1 1]*prctile(A{2},5),'color','r')
    line(xlim,[1 1]*prctile(A{3},95),'color','b')
    
    line(xlim,[1 1]*0.2)
    
end


