%Préparation des données 
ilimProtocollong = 5;
for i = 1:MiceNumber 
    dataMouse = DATAtable.(Mice{i});
    dataMouseSafe = dataMouse(dataMouse.PositionArray >= 0.5, :);
    ReducedDATAtable.(Mice{i}) = dataMouseSafe;
    ReducedDATAtable.(Mice{i}).OBFrequencySafe = dataMouseSafe.OB_FrequencyArray;
    if i < ilimProtocollong
        ReducedDATAtable.(Mice{i}).hasSlept = dataMouseSafe.GlobalTimeArray > 2880;
    end
    
 
end 
    

%Fit 
for i = 1:ilimProtocollong 
    if i < ilimProtocollong
        Predictors.(Mice{i}) = ReducedDATAtable.(Mice{i})(:,{'EyelidNumber',...
            'CumulEntryShockZone', 'CumulRipples', 'hasSlept'});
    else 
        Predictors.(Mice{i}) = ReducedDATAtable.(Mice{i})(:,{'EyelidNumber',...
            'CumulEntryShockZone', 'CumulRipples'});
    end 
    Predictors.(Mice{i}) = [table(ones(height(Predictors.(Mice{i})), 1),...
        'VariableNames', {'Constant'})  Predictors.(Mice{i})];
    Observed.(Mice{i}) = ReducedDATAtable.(Mice{i})(:,{'OBFrequencySafe'});
    
    n = size(Predictors.(Mice{i}), 2);
    ConstraintMatrix = eye(n);
    ConstraintMatrix(1,1) = 0;
    ConstraintVector = zeros(n,1);
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.testlsqlinHasSlept.(Mice{i}) = lsqlin_TM(Predictors.(Mice{i}), Observed.(Mice{i}), ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(ReducedDATAtable, Models.testlsqlin, 'Test LsqLin', struct([]))

% for i = 1:MiceNumber 
%     plotPredAndMeanedPred(Observed.(Mice{i}), Predicted.(Mice{i}), string(Mice{i}))
%     disp([Mice(i) num2str(Betas.(Mice{i})')])
% end
