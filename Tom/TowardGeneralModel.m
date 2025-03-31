for i= 1:MiceNumber
    n = height(DATAtable.(MiceDZP{i}));
    CumulRipplesArray = zeros(n,1);
    CumulRipples = 0;
    for j = 1:n
        CumulRipples = CumulRipples + DATAtable.(Mice{i}).RipplesDensity(j);
        CumulRipplesArray(j) = CumulRipples;
    end
    DATAtable.(Mice{i}).CumulRipples = CumulRipplesArray;
end 
 
colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};
        
TimeBlockedShock = [[480 780]; [1920 2220]; [3360 3660]; [4800 5100]];    

model = Models.IntuitiveCES;



%All Mice, finding links between fitted sigmod of Global Time (with ls&lp)
%and a priori predictors taht explained it such as CumulativeEntryShockZone
%or EyelidNumber or even CumulativeRipples

figure;

for i = 1:MiceNumber
    modelMice = model.(Mice{i});
    PredictorTable.(Mice{i}) = modelMice.Variables;
    SigPos = DATAtable.(Mice{i}).SigPositionArray;
    SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ SigPos;
        
    
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) +1)
    yyaxis left
    for j = 1:length(TimeBlockedShock)  
        area(TimeBlockedShock(j,:), [1 1], 'FaceColor', 'red', 'FaceAlpha', 0.1, 'linestyle', 'none'), hold on 
    end
    plot(DATAtable.(Mice{i}).GlobalTimeArray, SigGT, 'linewidth', 2)
%     plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulEntryShockZone/max(DATAtable.(Mice{i}).CumulEntryShockZone)))
%     plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).EyelidNumber/max(DATAtable.(Mice{i}).EyelidNumber)))
%     plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulRipples/max(DATAtable.(Mice{i}).CumulRipples)))
%     
    yyaxis right
    ylim([0 50])
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulEntryShockZone))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).EyelidNumber))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulRipples))
    
    title(Mice{i})
    if i == MiceNumber
        legend({'SigGT', 'EntryShockZone"', 'EyelidNumber', 'CumulRipples'}, 'Location', 'southeast')
    end 
    
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) + 1 + round(MiceNumber/2))
    imagesc(coefIntuitiveCES.SigGT.(Mice{i}));
    colorbar
    
end


%Sum up Figure for AllMice, diplaying prediction, essential predictors and
%the learning map associated

figure;

for i = 1:MiceNumber
    modelMice = model.(Mice{i});
    PredictorTable.(Mice{i}) = modelMice.Variables;
    SigPos = DATAtable.(Mice{i}).SigPositionArray;
    SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ SigPos;
        
    x=1:height(DATAtable.(Mice{i}));
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) +1)
    yyaxis left
    plot(x, DATAtable.(Mice{i}).OB_FrequencyArray, 'x', 'Color', colors{1}), hold on 
    %plot(x, movmean(DATAtable.(Mice{i}).OB_FrequencyArray, 8), 'x', 'Color', [0.85 0.85 0.85])
    plot(x, modelMice.Fitted.Response, 'o', 'Color', colors{2})
    ylabel('Frequency (Hz)')

    yyaxis right
    ylim([0 1])
    plot(x, DATAtable.(Mice{i}).PositionArray, 'Color', colors{4})
    plot(x, SigGT, '-', 'Color', colors {11}, 'linewidth', 2)
    ylabel('Linearized Position')
    
    
    shocks = diff(DATAtable.(Mice{i}).EyelidNumber);
    indexShocks = find(shocks>=1);
    for j = 1:length(indexShocks)
        plot([indexShocks(j) indexShocks(j)], [0 ,10], '--', 'Color', colors{3}), hold on          
    end


    if i == MiceNumber
        legend({'Observation', 'Fitted', 'Position', 'SigGlobalTime', 'Shocks'}, 'Location', 'southeast')
    end 
    
    title(Mice{i})
    
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) + 1 + round(MiceNumber/2))
    imagesc(coefIntuitiveCES.SigGT.(Mice{i}));
    colorbar
    
end







for i = 1:MiceNumber
    modelMice = model.(Mice{i});
    PredictorTable.(Mice{i}) = modelMice.Variables;
    SigPos = DATAtable.(Mice{i}).SigPositionArray;
    SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ SigPos;
        
    

    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulEntryShockZone/max(DATAtable.(Mice{i}).CumulEntryShockZone)))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).EyelidNumber/max(DATAtable.(Mice{i}).EyelidNumber)))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulRipples/max(DATAtable.(Mice{i}).CumulRipples)))

    
end

figure;
for i = 1:MiceNumber
    modelMice = model.(Mice{i});
    PredictorTable.(Mice{i}) = modelMice.Variables;
    SigPos = DATAtable.(Mice{i}).SigPositionArray;
    SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ SigPos;
        
    
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) +1)
    plot(DATAtable.(Mice{i}).GlobalTimeArray, SigGT, 'linewidth', 2), hold on 
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulEntryShockZone/max(DATAtable.(Mice{i}).CumulEntryShockZone)))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).EyelidNumber/max(DATAtable.(Mice{i}).EyelidNumber)))
    plot(DATAtable.(Mice{i}).GlobalTimeArray, (DATAtable.(Mice{i}).CumulRipples/max(DATAtable.(Mice{i}).CumulRipples)))
    title(Mice{i})
    if i == MiceNumber
        legend({'SigGT', 'EntryShockZone"', 'EyelidNumber', 'CumulRipples'}, 'Location', 'southeast')
    end 
    
    subplot(4,round(MiceNumber/2),mod(i-1, round(MiceNumber/2))+floor((i-1)/round(MiceNumber/2))*2*round(MiceNumber/2) + 1 + round(MiceNumber/2))
    imagesc(coefIntuitiveCES.SigGT.(Mice{i}));
    colorbar
    
end


%General Model for PAG 
MicePAG = {'M404';'M437';'M439';'M469';'M471';'M483';'M484';'M485';'M490';'M507';...
    'M508';'M509';'M510';'M512';'M514'};
for i = 1:length(MicePAG)
    DATAtablePAG.(MicePAG{i}) = DATAtable.(MicePAG{i});
end 

startLearnslope = 0.0002;
endLearnslope = 0.02;
stepLearnslope = 0.0002;
startLearnpoint = 0.1;
endLearnpoint = 0.9;
stepLearnpoint = 0.02;
nameOfModel = "TowardGeneralPAG";

for i = 1:length(MicePAG)  
    AllTpsLearnGT = max(DATAtablePAG.(MicePAG{i}).GlobalTime);  
    learnslope = startLearnslope + stepLearnslope * 10;
    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * 13); 
                    
    DATAtablePAG.(MicePAG{i}).SigPositionxSigGlobalTimeGlobal = DATAtablePAG.(MicePAG{i}).SigPosition ...
        ./ (1+ exp(-learnslope * (DATAtablePAG.(MicePAG{i}).GlobalTime - learnpoint)));

    Predictors = DATAtablePAG.(MicePAG{i})(:,{'ExpTimeSinceLastShockGlobal', 'SigPositionxSigGlobalTimeGlobal'});

    Predictors = [table(ones(height(Predictors), 1), 'VariableNames', {'Constant'}) Predictors];
    Observed = DATAtablePAG.(MicePAG{i})(:,{'OB_Frequency'});
    
    n = size(Predictors, 2);
    ConstraintMatrix = zeros(n);
    ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
    ConstraintVector = zeros(n,1);
    ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage 
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.(nameOfModel).(MicePAG{i}) = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(DATAtablePAG, Models.(nameOfModel), nameOfModel)


%General Model for All 

startLearnslope = 0.0002;
endLearnslope = 0.02;
stepLearnslope = 0.0002;
startLearnpoint = 0.1;
endLearnpoint = 0.9;
stepLearnpoint = 0.02;
nameOfModel = "TowardGeneralGlobal";

r = 4; %Max of Global Normalized Mean
c = 11;

% r = 17; %Max of product of normalized Mean and Std 
% c = 9;

for i = 1:length(Mice)  
    AllTpsLearnGT = max(DATAtable.(Mice{i}).GlobalTime);  
    learnslope = startLearnslope + stepLearnslope * r;
    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * c); 
                    
    DATAtable.(Mice{i}).SigPositionxSigGlobalTimeGeneralGlobal = DATAtable.(Mice{i}).SigPosition ...
        ./ (1+ exp(-learnslope * (DATAtable.(Mice{i}).GlobalTime - learnpoint)));

    Predictors = DATAtable.(Mice{i})(:,{'ExpTimeSinceLastShockGlobal', 'SigPositionxSigGlobalTimeGeneralGlobal'});

    Predictors = [table(ones(height(Predictors), 1), 'VariableNames', {'Constant'}) Predictors];
    Observed = DATAtable.(Mice{i})(:,{'OB_Frequency'});
    
    n = size(Predictors, 2);
    ConstraintMatrix = zeros(n);
    ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
    ConstraintVector = zeros(n,1);
    ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage 
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.(nameOfModel).(Mice{i}) = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(DATAtable, Models.(nameOfModel), nameOfModel)



%General Model for All 

startLearnslope = 0.0002;
endLearnslope = 0.02;
stepLearnslope = 0.0002;
startLearnpoint = 0.1;
endLearnpoint = 0.9;
stepLearnpoint = 0.02;
nameOfModel = "TowardGeneralDZP";

r = 100; %Max of Global Normalized Mean
c = 35;


for i = 1:length(MiceDZP)  
    AllTpsLearnGT = max(DATAtableDZP.(MiceDZP{i}).GlobalTime);  
    learnslope = startLearnslope + stepLearnslope * r;
    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * c); 
                    
    DATAtableDZP.(MiceDZP{i}).SigPositionxSigGlobalTimeGeneralGlobal = DATAtableDZP.(MiceDZP{i}).SigPosition ...
        ./ (1+ exp(-learnslope * (DATAtableDZP.(MiceDZP{i}).GlobalTime - learnpoint)));

    Predictors = DATAtableDZP.(MiceDZP{i})(:,{'ExpTimeSinceLastShockGlobal', 'SigPositionxSigGlobalTimeGeneralGlobal'});

    Predictors = [table(ones(height(Predictors), 1), 'VariableNames', {'Constant'}) Predictors];
    Observed = DATAtableDZP.(MiceDZP{i})(:,{'OB_Frequency'});
    
    n = size(Predictors, 2);
    ConstraintMatrix = zeros(n);
    %ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
    ConstraintVector = zeros(n,1);
    %ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage 
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.(nameOfModel).(MiceDZP{i}) = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(DATAtableDZP, Models.(nameOfModel), nameOfModel)

Gui_ModelsComparison(DATAtableDZP, Models.AnalysisDZP, Models.TowardGeneralDZP, ...
    'Optim SigGT DZP', 'Fixed SigGT DZP', coefAnalysisDZP)




%General Model for Eyelid

startLearnslope = 0.0002;
endLearnslope = 0.02;
stepLearnslope = 0.0002;
startLearnpoint = 0.1;
endLearnpoint = 0.9;
stepLearnpoint = 0.02;
nameOfModel = "TowardGeneralEyelid";

r = 2; %Max of Global Normalized Mean
c = 15;

for i = 1:length(MiceEyelid)  
    AllTpsLearnGT = max(DATAtable.(MiceEyelid{i}).GlobalTime);  
    learnslope = startLearnslope + stepLearnslope * r;
    learnpoint = AllTpsLearnGT * (startLearnpoint + stepLearnpoint * c); 
                    
    DATAtable.(MiceEyelid{i}).SigPositionxSigGlobalTimeGeneralGlobal = DATAtable.(MiceEyelid{i}).SigPosition ...
        ./ (1+ exp(-learnslope * (DATAtable.(MiceEyelid{i}).GlobalTime - learnpoint)));

    Predictors = DATAtable.(MiceEyelid{i})(:,{'ExpTimeSinceLastShockGlobal', 'SigPositionxSigGlobalTimeGeneralGlobal'});

    Predictors = [table(ones(height(Predictors), 1), 'VariableNames', {'Constant'}) Predictors];
    Observed = DATAtable.(MiceEyelid{i})(:,{'OB_Frequency'});
    
    n = size(Predictors, 2);
    ConstraintMatrix = zeros(n);
    ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
    ConstraintVector = zeros(n,1);
    ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage 
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.(nameOfModel).(MiceEyelid{i}) = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(DATAtable, Models.(nameOfModel), nameOfModel)