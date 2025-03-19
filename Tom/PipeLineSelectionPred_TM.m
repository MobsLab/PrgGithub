function res = PipeLineSelectionPred_TM(DATAtable, InitialPred, Name, options)
%DATAtable = Table structure : a field is a datatable of a mouse with 
    %OB_Frequency and at least a column for each predictor 
%InitialPred = List String : columns names of uncorrelated predictors
%Name = String : Name of a model 
%options = String : define the type of optimization that is wanted 
    % "learningSigGT" means an optimization of hyperarameters learning
        % slope and learning point in the sigmoid of global time
    % "learningExpTSLS" means an optimization of the caracteristic time in
        % exponential of time since last shock 
    % "constraints" means that the optimization is under constraints, be
        % careful you have to change the function itself to define the precise
        % constraints 
  %These options can generally by mixed with a 'x' symbol between them

%Return = Array Structure Structure : Coefficients of hyperparameters such
%as tau of exponential(Time Since Last Shock) or learning points/slope of
%sigmoid 

%Side effects : add to global variable 'Models' a field with the name of the
%model and a structure with a model for each mouse 



    global Models
    Mice = fieldnames(DATAtable);
    MiceNumber = length(Mice);
    
    for i=1:MiceNumber
        disp(Name + " - " + Mice{i} + " start ...")
        pause(0.0001)
        dataMouse = DATAtable.(Mice{i})(:,[InitialPred 'OB_Frequency']);
        if options == ""
            Models.(Name).(Mice{i}) = fitglm(dataMouse,...
                'linear','ResponseVar','OB_Frequency','Distribution', 'gamma', 'link', 'identity');
        elseif options == "learningSigGT"

            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.0002;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.02;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            for indls=1:nLearnslope
                for indlp=1:nLearnpoint
                    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                    learnslope = startLearnslope + stepLearnslope * (indls-1);
                    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));                   
                    
                    dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                    modelLearned{indls, indlp} = fitglm(dataMouse,...
                'linear','ResponseVar','OB_Frequency','Distribution', 'gamma', 'link', 'identity');
       
                     res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                end
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
        
        elseif options == "learningSigGTxlearningExpTSLS"
            %Around 6hours to run 
%             startLearnslope = 0.0002;
%             endLearnslope = 0.02;
%             stepLearnslope = 0.0002;
%             nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
%             startLearnpoint = 0.1;
%             endLearnpoint = 0.9;
%             stepLearnpoint = 0.02;
%             nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
%             startTauExpTSLS = 10;
%             endTauExpTSLS = 300;
%             stepTauExpTSLS = 10;
%             nTauExpTSLS = round((endTauExpTSLS - startTauExpTSLS) / stepTauExpTSLS) + 1;
            
            
            
            %Around 18minutes (2minutes for a mouse) to run 
            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.001;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.05;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            startTauExpTSLS = 10;
            endTauExpTSLS = 300;
            stepTauExpTSLS = 20;
            nTauExpTSLS = round((endTauExpTSLS - startTauExpTSLS) / stepTauExpTSLS) + 1;
            
            disp([nLearnslope nLearnpoint nTauExpTSLS])

            res.All.(Mice{i}) = zeros(nLearnslope, nLearnpoint, nTauExpTSLS);
            modelLearned = cell(nLearnslope, nLearnpoint, nTauExpTSLS);
            
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    tic 
                    for indCES = 1:nTauExpTSLS

                        AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                        learnslope = startLearnslope + stepLearnslope * (indls-1);
                        learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));   
                        tauExpTSLS = startTauExpTSLS + stepTauExpTSLS * (indCES - 1);

                        dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                            ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                        dataMouse(:,'ExpTimeSinceLastShock') = table(exp(-DATAtable.(Mice{i}).TimeSinceLastShock ...
                            /tauExpTSLS));
                        modelLearned{indls, indlp, indCES} = fitglm(dataMouse,...
                    'linear','ResponseVar','OB_Frequency','Distribution', 'gamma', 'link', 'identity');

                        res.All.(Mice{i})(indls, indlp, indCES) = modelLearned{indls, indlp, indCES}.Rsquared.Ordinary;
                    end 
                    toc
                end
                
            end
            [maxres,index1] = max(res.All.(Mice{i}), [], 1); 
            [maxmaxres, index2] = max(maxres, [], 2); 
            [~, index3] = max(maxmaxres);
            max3 = index3;
            max2 = index2(1,1,max3);
            max1 = index1(1, max2, max3);
            res.SigGT.(Mice{i}) =  res.All.(Mice{i})(:, :, max3);
            res.ExpTSLS.(Mice{i}) =  squeeze(res.All.(Mice{i})(max1,max2,:));
            Models.(Name).(Mice{i}) = modelLearned{max1,max2,max3};
            
        elseif options == "constraintsxlearningSigGT"
            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.0002;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.02;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 2;
            ConstraintMatrix = zeros(n);
            ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
            %ConstraintMatrix(2,2) = -1;
            %ConstraintMatrix(3,3) = -1;
            ConstraintVector = zeros(n,1);
            ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage du safe
            % Constraint :  ConstraintMatrix * x <= ConstraintVector
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                    learnslope = startLearnslope + stepLearnslope * (indls-1);
                    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));                   
                    
                    dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                    
                    Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                    modelLearned{indls, indlp} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);
       
                    res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                end
                
                
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
        elseif options == "noConstraintsxlearningSigGT"
            
            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.0002;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.02;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 2;
            ConstraintMatrix = zeros(n);
            ConstraintVector = zeros(n,1);

            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                    learnslope = startLearnslope + stepLearnslope * (indls-1);
                    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));                   
                    
                    dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                    
                    Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                    modelLearned{indls, indlp} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);
       
                    res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                end
                
                
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
            
        elseif options == "noConstraintsxlearningSigGTxcorrection"
            
%             startLearnslope = 0.0002;
%             endLearnslope = 0.02;
%             stepLearnslope = 0.0002;
%             nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            nLearnslope = 50;
            Xlogspace = logspace(-3, -1, nLearnslope);
            startLearnpoint = 0.01;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.01;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 2;
            ConstraintMatrix = zeros(n);
            ConstraintVector = zeros(n,1);

            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    AllTpsLearnGT = 5760;
                    learnslope = Xlogspace(indls);
                    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));                   
                    
                    dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                    
                    Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                    modelLearned{indls, indlp} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);
       
                    res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                end
                
                
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
        elseif options == "fixedConstantxlearningSigGT"
            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.0002;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.02;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            thresholdPosition = 0.25;
            MeanOBShock = mean(DATAtable.(Mice{i}).OB_Frequency(...
                DATAtable.(Mice{i}).Position <= thresholdPosition));
            
            Offset = MeanOBShock * ones(height(dataMouse), 1);
            
            Observed = table(dataMouse.OB_Frequency - Offset, 'VariableNames', {'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 1;
            ConstraintMatrix = zeros(n);
            ConstraintVector = zeros(n,1);
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                    learnslope = startLearnslope + stepLearnslope * (indls-1);
                    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));                   
                    
                    dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));
                    
                    
                    modelLearned{indls, indlp} = lsqlin_TM(dataMouse, Observed, ConstraintMatrix, ConstraintVector);
                    
                    res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                    modelLearned{indls, indlp}.Variables.OB_Frequency = modelLearned{indls, indlp}.Variables.OB_Frequency ...
                        + Offset;
                    modelLearned{indls, indlp}.Fitted.Response = modelLearned{indls, indlp}.Fitted.Response ...
                        + Offset;
                    modelLearned{indls, indlp}.Coefficients = table([MeanOBShock; ...
                        modelLearned{indls, indlp}.Coefficients.Estimate], ...
                        'VariableNames', {'Estimate'});
                    
                end
                
                
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
        elseif options == "constraintsxlearningSigGTxlearningExpTSLS"
            %Around 30min/mouse to run
            startLearnslope = 0.0002;
            endLearnslope = 0.02;
            stepLearnslope = 0.0002;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.02;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            startTauExpTSLS = 10;
            endTauExpTSLS = 300;
            stepTauExpTSLS = 10;
            nTauExpTSLS = round((endTauExpTSLS - startTauExpTSLS) / stepTauExpTSLS) + 1;
            
            
            
            %Around 18minutes (2minutes for a mouse) to run 
%             startLearnslope = 0.0002;
%             endLearnslope = 0.02;
%             stepLearnslope = 0.001;
%             nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
%             startLearnpoint = 0.1;
%             endLearnpoint = 0.9;
%             stepLearnpoint = 0.05;
%             nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
%             startTauExpTSLS = 10;
%             endTauExpTSLS = 300;
%             stepTauExpTSLS = 20;
%             nTauExpTSLS = round((endTauExpTSLS - startTauExpTSLS) / stepTauExpTSLS) + 1;
            
            disp([nLearnslope nLearnpoint nTauExpTSLS])

            res.All.(Mice{i}) = zeros(nLearnslope, nLearnpoint, nTauExpTSLS);
            modelLearned = cell(nLearnslope, nLearnpoint, nTauExpTSLS);
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 3; %Constant + SIgGT + ExpTSLS
            ConstraintMatrix = zeros(n);
            ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
            ConstraintVector = zeros(n,1);
            ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage du safe
            % Constraint :  ConstraintMatrix * x <= ConstraintVector
            
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
    
                    for indCES = 1:nTauExpTSLS
                        AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);
                        learnslope = startLearnslope + stepLearnslope * (indls-1);
                        learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));
                        tauExpTSLS = startTauExpTSLS + stepTauExpTSLS * (indCES - 1);

                        dataMouse(:,'ExpTimeSinceLastShock') = table(exp(-DATAtable.(Mice{i}).TimeSinceLastShock ...
                            /tauExpTSLS));
                        dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                            ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));

                        Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                        
                        modelLearned{indls, indlp, indCES} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

                        res.All.(Mice{i})(indls, indlp, indCES) = modelLearned{indls, indlp, indCES}.Rsquared.Ordinary;
                    
                    end 
                    
                end
                
            end
            [maxres,index1] = max(res.All.(Mice{i}), [], 1); 
            [maxmaxres, index2] = max(maxres, [], 2); 
            [~, index3] = max(maxmaxres);
            max3 = index3;
            max2 = index2(1,1,max3);
            max1 = index1(1, max2, max3);
            res.SigGT.(Mice{i}) =  res.All.(Mice{i})(:, :, max3);
            res.ExpTSLS.(Mice{i}) =  squeeze(res.All.(Mice{i})(max1,max2,:));
            Models.(Name).(Mice{i}) = modelLearned{max1,max2,max3};
            
        elseif options == "noConstraintsxlearningSigGTxlearningExpTSLSxcorrection"
            %Around 30min/mouse to run
            nLearnslope = 50;
            Xlogspace = logspace(-3, -1, nLearnslope);
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.01;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.01;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            startTauExpTSLS = 10;
            endTauExpTSLS = 300;
            stepTauExpTSLS = 10;
            nTauExpTSLS = round((endTauExpTSLS - startTauExpTSLS) / stepTauExpTSLS) + 1;
            

            res.All.(Mice{i}) = zeros(nLearnslope, nLearnpoint, nTauExpTSLS);
            modelLearned = cell(nLearnslope, nLearnpoint, nTauExpTSLS);
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 3; %Constant + SigGT + ExpTSLS
            ConstraintMatrix = zeros(n);
            ConstraintVector = zeros(n,1);
            % Constraint :  ConstraintMatrix * x <= ConstraintVector
            
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
    
                    for indCES = 1:nTauExpTSLS
                        AllTpsLearnGT = 5760;
                        learnslope = Xlogspace(indls);
                        learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * (indlp-1));
                        tauExpTSLS = startTauExpTSLS + stepTauExpTSLS * (indCES - 1);

                        dataMouse(:,'ExpTimeSinceLastShock') = table(exp(-DATAtable.(Mice{i}).TimeSinceLastShock ...
                            /tauExpTSLS));
                        dataMouse(:,'SigPositionxSigGlobalTime') = table(DATAtable.(Mice{i}).SigPosition ...
                            ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint))));

                        Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                        
                        modelLearned{indls, indlp, indCES} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

                        res.All.(Mice{i})(indls, indlp, indCES) = modelLearned{indls, indlp, indCES}.Rsquared.Ordinary;
                    
                    end 
                    
                end
                
            end
            [maxres,index1] = max(res.All.(Mice{i}), [], 1); 
            [maxmaxres, index2] = max(maxres, [], 2); 
            [~, index3] = max(maxmaxres);
            max3 = index3;
            max2 = index2(1,1,max3);
            max1 = index1(1, max2, max3);
            res.SigGT.(Mice{i}) =  res.All.(Mice{i})(:, :, max3);
            res.ExpTSLS.(Mice{i}) =  squeeze(res.All.(Mice{i})(max1,max2,:));
            Models.(Name).(Mice{i}) = modelLearned{max1,max2,max3};
        
        elseif options == "constraintsxlearningSigCES"
            startLearnslope = 0.01;
            endLearnslope = 1;
            stepLearnslope = 0.01;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 1;
            endLearnpoint = max(DATAtable.(Mice{i}).CumulEntryShockZone);
            stepLearnpoint = 1;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            
            res.SigGT.(Mice{i}) = zeros(nLearnslope, nLearnpoint);
            modelLearned = cell(nLearnslope, nLearnpoint);
            
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 2;
            ConstraintMatrix = zeros(n);
            ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
            ConstraintVector = zeros(n,1);
            ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage du safe
            % Constraint :  ConstraintMatrix * x <= ConstraintVector
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    
                    learnslope = startLearnslope + stepLearnslope * (indls-1);
                    learnpoint = startLearnpoint + stepLearnpoint * (indlp-1);                   
                    
                    dataMouse(:,'SigPositionxSigCumulEntryShockZone') = table(DATAtable.(Mice{i}).SigPosition ...
                        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).CumulEntryShockZone - learnpoint))));
                    
                    Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];
                    modelLearned{indls, indlp} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);
       
                    res.SigGT.(Mice{i})(indls, indlp) = modelLearned{indls, indlp}.Rsquared.Ordinary;
                    
                end
                
                
            end
            [maxres,index1] = max(res.SigGT.(Mice{i})); 
            [~, index2] = max(maxres); 
            Models.(Name).(Mice{i}) = modelLearned{index1(index2),index2};
            
            
        elseif options == 'learningCumulative'       
            %Around 18minutes (2minutes for a mouse) to run 
            startLearnslope = 0.1;
            endLearnslope = 10;
            stepLearnslope = 0.2;
            nLearnslope = round((endLearnslope - startLearnslope) / stepLearnslope) + 1;
            startLearnpoint = 0.1;
            endLearnpoint = 0.9;
            stepLearnpoint = 0.05;
            nLearnpoint = round((endLearnpoint - startLearnpoint) / stepLearnpoint) + 1;
            nCoefCumulEntryShock = 20;
            nCoefCumulRipples = 20;
            
            disp([nLearnslope nLearnpoint nCoefCumulEntryShock nCoefCumulRipples])

            res.All.(Mice{i}) = zeros(nLearnslope, nLearnpoint, nCoefCumulEntryShock, nCoefCumulRipples) - 1;
            modelLearned = cell(nLearnslope, nLearnpoint, nCoefCumulEntryShock, nCoefCumulRipples);
            
            Observed = dataMouse(:,{'OB_Frequency'});
            dataMouse(:,{'OB_Frequency'}) = [];

            n = size(InitialPred, 2) + 2; %Constant + Sig(a+b+c)
            ConstraintMatrix = zeros(n);
            ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
            ConstraintVector = zeros(n,1);
            ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage du safe
            % Constraint :  ConstraintMatrix * x <= ConstraintVector
            
            
            maxCES = max(DATAtable.(Mice{i}).CumulEntryShockZone);
            maxRip = max(DATAtable.(Mice{i}).CumulEntryShockZone);
            maxEyelid = max(DATAtable.(Mice{i}).EyelidNumber);
            
            for indls=1:nLearnslope
                
                for indlp=1:nLearnpoint
                    
                    for indCES = 1:(nCoefCumulEntryShock - 2)
                        
                        for indrip = 1:(nCoefCumulRipples - 1 - indCES)
                            learnslope = startLearnslope + stepLearnslope * (indls-1);
                            learnpoint = startLearnpoint + stepLearnpoint * (indlp-1);
                            indEyelid = 20 - indCES - indrip; 
                            

                            dataMouse(:,'SigPositionxSigLearningPred') = table(DATAtable.(Mice{i}).SigPosition ...
                                ./ (1+ exp(-learnslope * (indCES / maxCES * DATAtable.(Mice{i}).CumulEntryShockZone +...
                                indrip / maxRip * DATAtable.(Mice{i}).CumulRipples + ...
                                indEyelid / maxEyelid * DATAtable.(Mice{i}).EyelidNumber - learnpoint))));

                            Predictors = [table(ones(height(dataMouse), 1), 'VariableNames', {'Constant'}) dataMouse];

                            modelLearned{indls, indlp, indCES, indrip} = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

                            res.All.(Mice{i})(indls, indlp, indCES, indrip) = modelLearned{indls, indlp, indCES, indrip}.Rsquared.Ordinary;
                        end 
                    end 
                    
                end
            end
            [maxres,index1] = max(res.All.(Mice{i}), [], 1); 
            [maxmaxres, index2] = max(maxres, [], 2);
            [maxmaxmaxres, index3] = max(maxmaxres, [], 3);
            [~, index4] = max(maxmaxmaxres);
            max4 = index4;
            max3 = index3(1, 1, 1, max4);
            max2 = index2(1, 1, max3, max4);
            max1 = index1(1, max2, max3, max4);
            res.SigGT.(Mice{i}) =  res.All.(Mice{i})(:, :, max3, max4);
            res.RepartitionMap.(Mice{i}) =  squeeze(res.All.(Mice{i})(max1,max2,:,:));
            Models.(Name).(Mice{i}) = modelLearned{max1, max2, max3, max4};
        end 
        
        
        
        disp(Name + " - " + Mice{i} + " done") 
    end
    
end