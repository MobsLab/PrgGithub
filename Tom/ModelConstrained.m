
ilimProtocollong = 5;

TimeBlockedShock = [[480 780]; [1920 2220]; [3360 3660]; [4800 5100]];   
TimeBlockedSafe = [[960 1260]; [2400 2700]; [3840 4140]; [5280 5580]];   

%Préparation des données 
for i = 1:MiceNumber 
    DATAtable.(Mice{i}).SigPositionxEyelidNumber = DATAtable.(Mice{i}).SigPositionArray .* DATAtable.(Mice{i}).EyelidNumber;
    DATAtable.(Mice{i}).SigPositionxCumulEntryShockZone = DATAtable.(Mice{i}).SigPositionArray .* DATAtable.(Mice{i}).CumulEntryShockZone;
    DATAtable.(Mice{i}).SigPositionxCumulRipples = DATAtable.(Mice{i}).SigPositionArray .* DATAtable.(Mice{i}).CumulRipples;
    if i < ilimProtocollong
        DATAtable.(Mice{i}).hasSlept = DATAtable.(Mice{i}).GlobalTimeArray > 2880;
    else 
        DATAtable.(Mice{i}).hasSlept = zeros(height(DATAtable.(Mice{i})),1);
    end
    
    %Ajout isBlockedShock : 0 si la souris n'est pas bloquée côté shock et 1 si elle l'est
    DATAtable.(Mice{i}).isBlockedShock = zeros(height(DATAtable.(Mice{i})),1);
    for j = 1:length(TimeBlockedShock)
        DATAtable.(Mice{i}).isBlockedShock = DATAtable.(Mice{i}).isBlockedShock ...
            | ( DATAtable.(Mice{i}).GlobalTimeArray >= TimeBlockedShock(j,1) ...
            & DATAtable.(Mice{i}).GlobalTimeArray <= TimeBlockedShock(j,2) );
    end 
    
    %Ajout isBlockedSafe : 0 si la souris n'est pas bloquée côté safe et 1 si elle l'est
    DATAtable.(Mice{i}).isBlockedSafe = zeros(height(DATAtable.(Mice{i})),1);
    for j = 1:length(TimeBlockedSafe)
        DATAtable.(Mice{i}).isBlockedSafe = DATAtable.(Mice{i}).isBlockedSafe ...
            | ( DATAtable.(Mice{i}).GlobalTimeArray >= TimeBlockedSafe(j,1) ...
            & DATAtable.(Mice{i}).GlobalTimeArray <= TimeBlockedSafe(j,2) );
    end 
end 

nameOfModel = "ConstraintsIntuitiveBlock";

%Fit 
for i = 1:MiceNumber 
    
    Predictors = DATAtable.(Mice{i})(:,{'SigPositionxEyelidNumber',...
        'SigPositionxCumulEntryShockZone', 'SigPositionxCumulRipples', 'hasSlept', ...
        'TimeSinceLastShockArray', 'isBlockedSafe', 'isBlockedShock'});
     
    
    Predictors = [table(ones(height(Predictors), 1), 'VariableNames', {'Constant'}) Predictors];
    Observed = DATAtable.(Mice{i})(:,{'OB_FrequencyArray'});
    
    n = size(Predictors, 2);
    ConstraintMatrix = eye(n);
    ConstraintMatrix(1,1) = -1; %on inverse le sens de l'inéquation on veut x>b
    ConstraintMatrix(end-1,end-1) = 0; %pas d'a priori sur le fait que la souris soit bloquée 
    ConstraintMatrix(end,end) = 0; %pas d'a priori sur le fait que la souris soit bloquée
    ConstraintVector = zeros(n,1);
    ConstraintVector(1,1) = -4; %constante supérieure à 4Hz car on veut apprentissage 
    % Constraint :  ConstraintMatrix * x <= ConstraintVector
    
    Models.(nameOfModel).(Mice{i}) = lsqlin_TM(Predictors, Observed, ConstraintMatrix, ConstraintVector);

end

GuiDashboard_TM(DATAtable, Models.(nameOfModel), nameOfModel)