% Load the data
clear all
FoldValidation = 5;
Opts.TempBinsize = 1;
PossibleBinNumbers = [5,10];
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/DecodingAnalysis';
Variables = {'HR','BR','speed','position'};
Regions = {'PFC','HPC'};
Periods{1} = {'Habituation','Conditionning','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
Periods{2} = {'Habituation','Conditionning','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
Periods{3} = {'Habituation','Conditionning','Freezing'};
Periods{4} = {'Habituation','Conditionning','Freezing'};

for reg = 1
    for var = 1:2%length(Variables)
        if var <3 & reg ==2
            Periods{var}(6:end) = [];
        end
        for binnum = 1:2
            Opts.BinNumber = PossibleBinNumbers(binnum);
            clear VarOfInterest spike_dat
            for per = 1:length(Periods{var})
                disp(['Loading ' Periods{var}{per}])
                switch Regions{reg}
                    case 'PFC'
                        [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per}),Opts] = PFC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
                    case 'HPC'
                        [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per}),Opts] = HPC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
                end
            end
            
            for per = 1:length(Periods{var})
                disp(['Analysing ' Periods{var}{per}])
                for mm = 1:length(VarOfInterest.(Periods{var}{per}))
                    BadGuys = find(isnan(VarOfInterest.(Periods{var}{per}){mm}));
                    Y = VarOfInterest.(Periods{var}{per}){mm}; Y(BadGuys) = [];
                    X = (spike_dat.(Periods{var}{per}){mm})';
                    %                 if dozscore
                    %                     Std_Spikes = std(X);
                    %                     Mn_Spikes = mean(X);
                    %                     X = (X-Mn_Spikes) / Std_Spikes;
                    %                 end
                    X(BadGuys,:) = [];
                    Opts.ParamBinLims(1) = min([Opts.ParamBinLims(1),min(Y)]);
                    Opts.ParamBinLims(end) = max([Opts.ParamBinLims(end),max(Y)]);
                    [Y,edges] = discretize(Y,Opts.ParamBinLims);
                    Y = edges(Y)';
                    NeurNum = size(X,2);
                    NeurNumToTry = [5:5:NeurNum];
                    
                    % Get error rate on same period, depending on number of neurons
                    Bins = 1:length(Y);
                    Bins = Bins(1:FoldValidation*floor(length(Bins)/FoldValidation));
                    Y = Y(Bins);
                    X = X(Bins,:);
                    BinsSplit = reshape(Bins', (floor(length(Bins)/FoldValidation)),(FoldValidation)).';  % Transpose after column-wise reshape
                    Mdl_All = fitcknn(X,Y);
                    
                    %% Full neuron number
                    AllPred = [];
                    clear ExplVariance Error
                    for split = 1:FoldValidation
                        TrainFolds = 1 : FoldValidation;
                        TrainFolds(split) = [];
                        TrainBins = BinsSplit(TrainFolds,:)'; TrainBins = TrainBins(:);
                        TestBins = BinsSplit(split,:)'; TestBins = TestBins(:);
                        Mdl = fitcknn(X(TrainBins,:),Y(TrainBins));
                        BrPred = predict(Mdl,X(TestBins,:));
                        AllPred = [AllPred;BrPred];
                    end
                    Corr.(Periods{var}{per})(mm) = corr(AllPred,Y);
                    MSECV.(Periods{var}{per})(mm) = nanmean((AllPred-Y).^2);
                    Accuracy.(Periods{var}{per})(mm) = nanmean(AllPred==Y);
                    Br_Pred.(Periods{var}{per}){mm} = AllPred;
                    Br_True.(Periods{var}{per}){mm} = Y;
                    Edges.(Periods{var}{per}){mm} = edges;
                    clear ConfMat
                    for ii = 1:length(edges)
                        for jj = 1:length(edges)
                            ConfMat(ii,jj) = sum(Y==edges(ii) & AllPred==edges(jj));
                        end
                    end
                    ConfusionMat.(Periods{var}{per}){mm} = ConfMat;
                    DistValuesTrain.(Periods{var}{per}){mm}  = sum(ConfMat');
                    AccByClass.(Periods{var}{per}){mm} = diag(ConfMat)./sum(ConfMat')';
                    
                    
                    %% Effect of neuron number
                    for nn = 1:length(NeurNumToTry)
                        for repeat = 1:10
                            NeurToUse = randperm(NeurNum,NeurNumToTry(nn));
                            clear ExplVariance Error
                            AllPred = [];
                            for split = 1:FoldValidation
                                TrainFolds = 1 : FoldValidation;
                                TrainFolds(split) = [];
                                TrainBins = BinsSplit(TrainFolds,:); TrainBins = TrainBins(:);
                                TestBins = BinsSplit(split,:); TestBins = TestBins(:);
                                Mdl = fitcknn(X(TrainBins,NeurToUse),Y(TrainBins));
                                BrPred = predict(Mdl,X(TestBins,NeurToUse));
                                AllPred = [AllPred;BrPred];
                            end
                            Corr_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = corr(AllPred,Y);
                            MSECV_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = nanmean((AllPred-Y).^2);
                            Accuracy_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = nanmean(AllPred==Y);
                            clear ConfMat
                            for ii = 1:length(edges)
                                for jj = 1:length(edges)
                                    ConfMat(ii,jj) = sum(Y==edges(ii) & AllPred==edges(jj));
                                end
                            end
                            AccByClassNeuronNum.(Periods{var}{per}){mm}(nn,repeat,:) = diag(ConfMat)./sum(ConfMat')';

                        end
                    end
                    
                    %% Test model on other data
                    % Train on everything in that session
                    PerToTest = 1 : length(Periods{var});
                    PerToTest(per) = [];
                    Corr_CrossPer.(Periods{var}{per}){mm}(per) = NaN;
                    MSECV_CrossPer.(Periods{var}{per}){mm}(per) = NaN;
                    Accuracy_CrossPer.(Periods{var}{per}){mm}(per) = NaN;
                    
                    for per_test = 1:length(PerToTest)
                        % Prepare data
                        Y = VarOfInterest.(Periods{var}{PerToTest(per_test)}){mm};
                        Y = discretize(Y,edges);
                        BadGuys = find(isnan(Y));
                        Y(BadGuys) = [];
                        Y = edges(Y)';
                        X = (spike_dat.(Periods{var}{PerToTest(per_test)}){mm})';
                        %                     if dozscore
                        %                         X = (X-Mn_Spikes) / Std_Spikes;
                        %                     end
                        X(BadGuys,:) = [];
                        AllPred = predict(Mdl_All,X);
                        
                        Corr_CrossPer.(Periods{var}{per}){mm}(PerToTest(per_test))  = corr(AllPred,Y);
                        MSECV_CrossPer.(Periods{var}{per}){mm}(PerToTest(per_test))  = nanmean((AllPred-Y).^2);
                        Accuracy_CrossPer.(Periods{var}{per}){mm}(PerToTest(per_test))  = nanmean(AllPred==Y);
                        clear ConfMat
                        for ii = 1:length(edges)
                            for jj = 1:length(edges)
                                ConfMat(ii,jj) = sum(Y==edges(ii) & AllPred==edges(jj));
                            end
                        end
                        ConfusionMat_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)}  = ConfMat;
                        DistValuesTest_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)}  = sum(ConfMat');
                        AccByClass_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)} = diag(ConfMat)./sum(ConfMat')';    
                    end
                    ConfusionMat_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)+1} = [];
                    DistValuesTest_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)+1} = [];
                    AccByClass_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)+1} = [];
                    
                    
                end
            end
            
            
            save([SaveFolder filesep Regions{reg} '_DecodingAnalysis_' Variables{var} '_BinNumber_',num2str(Opts.BinNumber),'.mat'],...
                'Corr','MSECV','Accuracy','Edges','ConfusionMat','DistValuesTrain','AccByClass','Corr_NeurNum','MSECV_NeurNum','Accuracy_NeurNum','AccByClassNeuronNum',...
                'Corr_CrossPer','MSECV_CrossPer','Accuracy_CrossPer','ConfusionMat_CrossPer','DistValuesTest_CrossPer','AccByClass_CrossPer','AccByClassNeuronNum')
            clear Corr MSECV Accuracy Edges ConfusionMat DistValuesTrain AccByClass Corr_NeurNum MSECV_NeurNum Accuracy_NeurNum Corr_CrossPer MSECV_CrossPer
            clear Accuracy_CrossPer ConfusionMat_CrossPer DistValuesTest_CrossPer AccByClass_CrossPer AccByClassNeuronNum
        end
    end
end

%
%
% %%
% load('HPC_DecodingAnalysis_position.mat')
figure
AllPer = fieldnames(Accuracy_CrossPer);
for per = 1:length(AllPer)
    for mm = 1:length(Accuracy_CrossPer.Habituation)
        CrossPer(mm,per,:) = Accuracy_CrossPer.(AllPer{per}){mm};
    end
end

%% Corrected
LimBins = 20;
for per = 1:length(AllPer)
    for mm = 1:length(Accuracy_CrossPer.Habituation)
        Acc_Corrected{per}(mm) = nanmean(AccByClass.(AllPer{per}){mm}(DistValuesTrain.(AllPer{per}){mm}>LimBins));
    end
end
for per = 1:length(AllPer)
    for permatch = 1:length(AllPer)
        for mm = 1:length(Accuracy_CrossPer.Habituation)
            if not(isempty(AccByClass_CrossPer.(AllPer{per}){mm}{permatch}))
                CrossPer_Corrected{per}{permatch}(mm) = nanmean(AccByClass_CrossPer.(AllPer{per}){mm}{permatch}(DistValuesTrain.(AllPer{per}){mm}>LimBins));
            end
        end
    end
end
for per = 1:length(AllPer)
    subplot(2,3,per)
    CrossPer_Corrected{per}{per} = Acc_Corrected{per};
    MakeSpreadAndBoxPlot_BM(CrossPer_Corrected{per},[],[],AllPer,1,0)
    ylim([0 1])
end



%% Not Corrected
AllPer = fieldnames(Accuracy_CrossPer);
clear Acc_Corrected  CrossPer_Corrected
LimBins = -1;
for per = 1:length(AllPer)
    for mm = 1:length(Accuracy_CrossPer.Habituation)
        Acc_Corrected{per}(mm) = nanmean(AccByClass.(AllPer{per}){mm});
    end
end
for per = 1:length(AllPer)
    for permatch = 1:length(AllPer)
        for mm = 1:length(Accuracy_CrossPer.Habituation)
            if not(isempty(AccByClass_CrossPer.(AllPer{per}){mm}{permatch}))
                CrossPer_Corrected{per}{permatch}(mm) = nanmean(AccByClass_CrossPer.(AllPer{per}){mm}{permatch});
            end
        end
    end
end
figure
for per = 1:length(AllPer)
    subplot(3,3,per)
    CrossPer_Corrected{per}{per} = Acc_Corrected{per};
    MakeSpreadAndBoxPlot_BM(CrossPer_Corrected{per},[],[],AllPer,1,0)
    ylim([0 1])
end

    for mm = 1:length(Accuracy_CrossPer.Habituation)
AccCl(mm,:) = AccByClass.Habituation{mm};
    end
    
      for mm = 1:length(Accuracy_CrossPer.Habituation)
AccClCr(mm,:) = AccByClass_CrossPer.Habituation{mm}{2};
    end
    

    MakeSpreadAndBoxPlot_BM(Acc_Corrected,[],[],AllPer,1,0)

A{1} = Accuracy.Habituation;
A{2} = Accuracy.EPM;
A{3} = cellfun(@(x) x(2),Accuracy_CrossPer.Habituation);%A{3}(end) = [];
A{4} = cellfun(@(x) x(2),Accuracy_CrossPer.EPM);%A{4}(end) = [];
MakeSpreadAndBoxPlot_BM(A,[],[],{'Hab','Cond','Hab/Cond','Cond/Hab'},1,0)
makepretty
ylabel('Accuracy')
line(xlim, [1 1]/5)
ylim([0 1])
%
%
% figure
% A{1} = Accuracy.Sleep;
% A{2} = Accuracy.Wake_Home;
% A{3} = cellfun(@(x) x(2),Accuracy_CrossPer.Sleep);%A{3}(end) = [];
% A{4} = cellfun(@(x) x(2),Accuracy_CrossPer.Wake_Home);%A{4}(end) = [];
% MakeSpreadAndBoxPlot_BM(A,[],[],{'Hab','Cond','Hab/Cond','Cond/Hab'},1,0)
% makepretty
% ylabel('Accuracy')
% line(xlim, [1 1]/5)
% ylim([0 1])
