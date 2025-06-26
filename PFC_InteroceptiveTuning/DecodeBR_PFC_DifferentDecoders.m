% Load the data
clear all
FoldValidation = 10;
Opts.TempBinsize = 1;
Opts.BinNumber = 10;
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/DecodingAnalysis';
Variables = {'BR'};
Regions = {'PFC'};
Periods{1} = {'Habituation','Conditionning','Sleep','Wake_Home','Sound_Hab','EPM'};
Distances = {'euclidean','seuclidean','mahalanobis','correlation','spearman'};
reg = 1;
var = 1;


clear VarOfInterest spike_dat
for per = 1:length(Periods{var})
    disp(['Loading ' Periods{var}{per}])
    switch Regions{reg}
        case 'PFC'
            [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per})] = PFC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
        case 'HPC'
            [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per})] = HPC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
    end
end
for dd = 1:length(Distances)
    disp(['Decoding with ' Distances{dd}])
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
            [Y,edges] = discretize(Y,Opts.BinNumber);
            Y = edges(Y)';
            NeurNum = size(X,2);
            NeurNumToTry = [5:5:NeurNum];
            
            % Get error rate on same period, depending on number of neurons
            Bins = 1:length(Y);
            Bins = Bins(1:FoldValidation*floor(length(Bins)/FoldValidation));
            Y = Y(Bins);
            X = X(Bins,:);
            BinsSplit = reshape(Bins', (floor(length(Bins)/FoldValidation)),(FoldValidation)).';  % Transpose after column-wise reshape
            Mdl_All = fitcknn(X,Y,'Distance',Distances{dd});
            DistValuesTrain.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = hist(Y,edges);

            %% Full neuron number
            AllPred = [];
            clear ExplVariance Error
            for split = 1:FoldValidation
                TrainFolds = 1 : FoldValidation;
                TrainFolds(split) = [];
                TrainBins = BinsSplit(TrainFolds,:)'; TrainBins = TrainBins(:);
                TestBins = BinsSplit(split,:)'; TestBins = TestBins(:);
                Mdl = fitcknn(X(TrainBins,:),Y(TrainBins),'Distance',Distances{dd});
                BrPred = predict(Mdl,X(TestBins,:));
                AllPred = [AllPred;BrPred];
            end
            Corr.(Periods{var}{per})(mm) = corr(AllPred,Y);
            MSECV.(Periods{var}{per})(mm) = nanmean((AllPred-Y).^2);
            Accuracy.(Periods{var}{per})(mm) = nanmean(AllPred==Y);
            Br_Pred.(Periods{var}{per}){mm} = AllPred;
            Br_True.(Periods{var}{per}){mm} = Y(Bins);
            
            
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
                        Mdl = fitcknn(X(TrainBins,NeurToUse),Y(TrainBins),'Distance',Distances{dd});
                        BrPred = predict(Mdl,X(TestBins,NeurToUse));
                        AllPred = [AllPred;BrPred];
                    end
                    Corr_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = corr(AllPred,Y);
                    MSECV_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = nanmean((AllPred-Y).^2);
                    Accuracy_NeurNum.(Periods{var}{per}){mm}(nn,repeat) = nanmean(AllPred==Y);
                end
            end
            
            %% Test model on other data
            % Train on everything in that session
            PerToTest = 1 : length(Periods{var});
            PerToTest(per) = [];
            
            for per_test = 1:length(PerToTest)
                % Prepare data
                Y = VarOfInterest.(Periods{var}{PerToTest(per_test)}){mm}; 
                Y = discretize(Y,edges);
                BadGuys = find(isnan(Y));
                Y(BadGuys) = [];
                Y = edges(Y)';
                X = (spike_dat.(Periods{var}{PerToTest(per_test)}){mm})';diag(confusionmat(Y,AllPred))

                %                     if dozscore
                %                         X = (X-Mn_Spikes) / Std_Spikes;
                %                     end
                X(BadGuys,:) = [];
               
                AllPred = predict(Mdl_All,X);
                
                Corr_CrossPer.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = corr(AllPred,Y);
                MSECV_CrossPer.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = nanmean((AllPred-Y).^2);
                Accuracy_CrossPer.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = nanmean(AllPred==Y);
                ConfusionMat_CrossPer.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = confusionmat(Y,AllPred);
                DistValuesTest_CrossPer.(Periods{var}{per}){mm}(per,PerToTest(per_test))  = hist(Y,edges);
                AccByClass_CrossPer

            end
        end
    end
    
    save([SaveFolder filesep Regions{reg} '_DecodingAnalysis_' Variables{var} '_NoZscore_Distance_',Distances{dd},'.mat'],...
        'Corr','MSECV','Accuracy',...
        'Corr_NeurNum','MSECV_NeurNum','Accuracy_NeurNum',...
        'Corr_CrossPer','MSECV_CrossPer','Accuracy_CrossPer');
    clear Corr MSECV Accuracy Corr_NeurNum MSECV_NeurNum Accuracy_NeurNum Corr_CrossPer MSECV_CrossPer Accuracy_CrossPer
    
end
for ii = 1:length(edges)
                        if nansum(Y==edges(ii))>0
                        AccByClass_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)}(ii)  = nansum(AllPred(Y==edges(ii))==edges(ii))/nansum(Y==edges(ii));
                        else
                            AccByClass_CrossPer.(Periods{var}{per}){mm}{PerToTest(per_test)}(ii)  = NaN;
                        end
                    end



% load('HPC_DecodingAnalysis_position.mat')
% figure
% A{1} = Accuracy.Habituation;
% A{2} = Accuracy.Conditionning;
% A{3} = cellfun(@(x) x(2),Accuracy_CrossPer.Habituation);%A{3}(end) = [];
% A{4} = cellfun(@(x) x(2),Accuracy_CrossPer.Conditionning);%A{4}(end) = [];
% MakeSpreadAndBoxPlot_BM(A,[],[],{'Hab','Cond','Hab/Cond','Cond/Hab'},1,0)
% makepretty
% ylabel('Accuracy')
% line(xlim, [1 1]/5)
% ylim([0 1])

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
