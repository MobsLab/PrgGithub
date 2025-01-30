load('/home/gruffalo/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline.mat');
DATAWV = load('/home/gruffalo/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline_WV.mat');
DATADZP = load('/home/gruffalo/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_DZP.mat');

Mice = fieldnames(DATA.Fear);
MiceNumber = length(Mice);

MiceDZP = fieldnames(DATADZP.DATA.Fear);
MiceNumberDZP = length(MiceDZP);

MiceWV = fieldnames(DATAWV.DATA.Fear);
MiceNumberWV = length(MiceWV);

global DATAtable DATAtableDZP DATAtableWV

%Load initial data 
for i=1:MiceNumber
    OneMouseData = DATA.Fear.(Mice{i});
    DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    DATAtable.(Mice{i}) = rmmissing(DATAtable.(Mice{i}));
end


ilimProtocollong = 5;

TimeBlockedShock = [[480 780]; [1920 2220]; [3360 3660]; [4800 5100]];   
TimeBlockedSafe = [[960 1260]; [2400 2700]; [3840 4140]; [5280 5580]];   

%Enrichissement des données 
for i = 1:MiceNumber
    DATAtable.(Mice{i}).SigPosition = 1./(1+exp(-20*([DATAtable.(Mice{i}).Position]-0.5)));
    DATAtable.(Mice{i}).SigPositionxTimeSinceLastShock = DATAtable.(Mice{i}).SigPosition.*DATAtable.(Mice{i}).TimeSinceLastShock;

    %Add CumulRipples
    n = height(DATAtable.(Mice{i}));
    CumulRipplesArray = zeros(n,1);
    CumulRipples = 0;
    for j = 1:n
        CumulRipples = CumulRipples + DATAtable.(Mice{i}).RipplesNumber(j);
        CumulRipplesArray(j) = CumulRipples;
    end
    DATAtable.(Mice{i}).CumulRipples = CumulRipplesArray;
%     
    %Add Interaction between SigPos and Learning Predictors
    DATAtable.(Mice{i}).SigPositionxEyelidNumber = DATAtable.(Mice{i}).SigPosition .* DATAtable.(Mice{i}).EyelidNumber;
    DATAtable.(Mice{i}).SigPositionxCumulEntryShockZone = DATAtable.(Mice{i}).SigPosition .* DATAtable.(Mice{i}).CumulEntryShockZone;
    %DATAtable.(Mice{i}).SigPositionxCumulRipples = DATAtable.(Mice{i}).SigPosition .* DATAtable.(Mice{i}).CumulRipples;
    
    %Add HasSlept
%     if i < ilimProtocollong
%         DATAtable.(Mice{i}).hasSlept = DATAtable.(Mice{i}).GlobalTime > 2880;
%     else 
%         DATAtable.(Mice{i}).hasSlept = zeros(height(DATAtable.(Mice{i})),1);
%     end
    
    %Add isBlockedShock : 0 si la souris n'est pas bloquée côté shock et 1 si elle l'est
    DATAtable.(Mice{i}).isBlockedShock = zeros(height(DATAtable.(Mice{i})),1);
    for j = 1:length(TimeBlockedShock)
        DATAtable.(Mice{i}).isBlockedShock = DATAtable.(Mice{i}).isBlockedShock ...
            | ( DATAtable.(Mice{i}).GlobalTime >= TimeBlockedShock(j,1) ...
            & DATAtable.(Mice{i}).GlobalTime <= TimeBlockedShock(j,2) );
    end 
    
    %Add isBlockedSafe : 0 si la souris n'est pas bloquée côté safe et 1 si elle l'est
    DATAtable.(Mice{i}).isBlockedSafe = zeros(height(DATAtable.(Mice{i})),1);
    for j = 1:length(TimeBlockedSafe)
        DATAtable.(Mice{i}).isBlockedSafe = DATAtable.(Mice{i}).isBlockedSafe ...
            | ( DATAtable.(Mice{i}).GlobalTime >= TimeBlockedSafe(j,1) ...
            & DATAtable.(Mice{i}).GlobalTime <= TimeBlockedSafe(j,2) );
    end
    
    %Add ExpTSLS with learned Tau 
    TauGlobalTSLS = 30;
    DATAtable.(Mice{i}).ExpTimeSinceLastShockGlobal = exp( - DATAtable.(Mice{i}).TimeSinceLastShock / TauGlobalTSLS);

    
    %Add Density 
end 




%Load initial data for Diazepam
for i=1:MiceNumberDZP
    OneMouseData = DATADZP.DATA.Fear.(MiceDZP{i});
    DATAtableDZP.(MiceDZP{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    DATAtableDZP.(MiceDZP{i}) = rmmissing(DATAtableDZP.(MiceDZP{i}));
end


%Enrichissement des données 
for i = 1:MiceNumberDZP
    DATAtableDZP.(MiceDZP{i}).SigPosition = 1./(1+exp(-20*([DATAtableDZP.(MiceDZP{i}).Position]-0.5)));
    DATAtableDZP.(MiceDZP{i}).SigPositionxTimeSinceLastShock = DATAtableDZP.(MiceDZP{i}).SigPosition.*DATAtableDZP.(MiceDZP{i}).TimeSinceLastShock;

    %Add CumulRipples
    n = height(DATAtableDZP.(MiceDZP{i}));
    CumulRipplesArray = zeros(n,1);
    CumulRipples = 0;
    for j = 1:n
        CumulRipples = CumulRipples + DATAtableDZP.(MiceDZP{i}).RipplesNumber(j);
        CumulRipplesArray(j) = CumulRipples;
    end
    DATAtableDZP.(MiceDZP{i}).CumulRipples = CumulRipplesArray;
    
    %Add Interaction between SigPos and Learning Predictors
    DATAtableDZP.(MiceDZP{i}).SigPositionxEyelidNumber = DATAtableDZP.(MiceDZP{i}).SigPosition .* DATAtableDZP.(MiceDZP{i}).EyelidNumber;
    DATAtableDZP.(MiceDZP{i}).SigPositionxCumulEntryShockZone = DATAtableDZP.(MiceDZP{i}).SigPosition .* DATAtableDZP.(MiceDZP{i}).CumulEntryShockZone;
    %DATAtableDZP.(MiceDZP{i}).SigPositionxCumulRipples = DATAtableDZP.(MiceDZP{i}).SigPosition .* DATAtableDZP.(MiceDZP{i}).CumulRipples;
    
    %Add HasSlept
%     if i < ilimProtocollong
%         DATAtableDZP.(MiceDZP{i}).hasSlept = DATAtableDZP.(MiceDZP{i}).GlobalTime > 2880;
%     else 
%         DATAtableDZP.(MiceDZP{i}).hasSlept = zeros(height(DATAtableDZP.(MiceDZP{i})),1);
%     end
    
    %Add isBlockedShock : 0 si la souris n'est pas bloquée côté shock et 1 si elle l'est
    DATAtableDZP.(MiceDZP{i}).isBlockedShock = zeros(height(DATAtableDZP.(MiceDZP{i})),1);
    for j = 1:length(TimeBlockedShock)
        DATAtableDZP.(MiceDZP{i}).isBlockedShock = DATAtableDZP.(MiceDZP{i}).isBlockedShock ...
            | ( DATAtableDZP.(MiceDZP{i}).GlobalTime >= TimeBlockedShock(j,1) ...
            & DATAtableDZP.(MiceDZP{i}).GlobalTime <= TimeBlockedShock(j,2) );
    end 
    
    %Add isBlockedSafe : 0 si la souris n'est pas bloquée côté safe et 1 si elle l'est
    DATAtableDZP.(MiceDZP{i}).isBlockedSafe = zeros(height(DATAtableDZP.(MiceDZP{i})),1);
    for j = 1:length(TimeBlockedSafe)
        DATAtableDZP.(MiceDZP{i}).isBlockedSafe = DATAtableDZP.(MiceDZP{i}).isBlockedSafe ...
            | ( DATAtableDZP.(MiceDZP{i}).GlobalTime >= TimeBlockedSafe(j,1) ...
            & DATAtableDZP.(MiceDZP{i}).GlobalTime <= TimeBlockedSafe(j,2) );
    end
    
    %Add ExpTSLS with learned Tau 
    TauGlobalTSLS = 30;
    DATAtableDZP.(MiceDZP{i}).ExpTimeSinceLastShockGlobal = exp( - DATAtableDZP.(MiceDZP{i}).TimeSinceLastShock / TauGlobalTSLS);

    
    %Add Density 
end 




%Load initial data for respiration detection technic Wavelet 
for i=1:MiceNumberWV
    OneMouseData = DATAWV.DATA.Fear.(MiceWV{i});
    DATAtableWV.(MiceWV{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    DATAtableWV.(MiceWV{i}) = rmmissing(DATAtableWV.(MiceWV{i}));
end

%Enrichissement des données 
for i = 1:MiceNumberWV
    DATAtableWV.(MiceWV{i}).SigPosition = 1./(1+exp(-20*([DATAtableWV.(MiceWV{i}).Position]-0.5)));
    DATAtableWV.(MiceWV{i}).SigPositionxTimeSinceLastShock = DATAtableWV.(MiceWV{i}).SigPosition.*DATAtableWV.(MiceWV{i}).TimeSinceLastShock;

    %Add CumulRipples
    n = height(DATAtableWV.(MiceWV{i}));
    CumulRipplesArray = zeros(n,1);
    CumulRipples = 0;
    for j = 1:n
        CumulRipples = CumulRipples + DATAtableWV.(MiceWV{i}).RipplesNumber(j);
        CumulRipplesArray(j) = CumulRipples;
    end
    DATAtableWV.(MiceWV{i}).CumulRipples = CumulRipplesArray;
    
    %Add Interaction between SigPos and Learning Predictors
    DATAtableWV.(MiceWV{i}).SigPositionxEyelidNumber = DATAtableWV.(MiceWV{i}).SigPosition .* DATAtableWV.(MiceWV{i}).EyelidNumber;
    DATAtableWV.(MiceWV{i}).SigPositionxCumulEntryShockZone = DATAtableWV.(MiceWV{i}).SigPosition .* DATAtableWV.(MiceWV{i}).CumulEntryShockZone;
    %DATAtableWV.(MiceWV{i}).SigPositionxCumulRipples = DATAtableWV.(MiceWV{i}).SigPosition .* DATAtableWV.(MiceWV{i}).CumulRipples;
    
    %Add HasSlept
%     if i < ilimProtocollong
%         DATAtableWV.(MiceWV{i}).hasSlept = DATAtableWV.(MiceWV{i}).GlobalTime > 2880;
%     else 
%         DATAtableWV.(MiceWV{i}).hasSlept = zeros(height(DATAtableWV.(MiceWV{i})),1);
%     end
    
    %Add isBlockedShock : 0 si la souris n'est pas bloquée côté shock et 1 si elle l'est
    DATAtableWV.(MiceWV{i}).isBlockedShock = zeros(height(DATAtableWV.(MiceWV{i})),1);
    for j = 1:length(TimeBlockedShock)
        DATAtableWV.(MiceWV{i}).isBlockedShock = DATAtableWV.(MiceWV{i}).isBlockedShock ...
            | ( DATAtableWV.(MiceWV{i}).GlobalTime >= TimeBlockedShock(j,1) ...
            & DATAtableWV.(MiceWV{i}).GlobalTime <= TimeBlockedShock(j,2) );
    end 
    
    %Add isBlockedSafe : 0 si la souris n'est pas bloquée côté safe et 1 si elle l'est
    DATAtableWV.(MiceWV{i}).isBlockedSafe = zeros(height(DATAtableWV.(MiceWV{i})),1);
    for j = 1:length(TimeBlockedSafe)
        DATAtableWV.(MiceWV{i}).isBlockedSafe = DATAtableWV.(MiceWV{i}).isBlockedSafe ...
            | ( DATAtableWV.(MiceWV{i}).GlobalTime >= TimeBlockedSafe(j,1) ...
            & DATAtableWV.(MiceWV{i}).GlobalTime <= TimeBlockedSafe(j,2) );
    end
    
    %Add ExpTSLS with learned Tau 
    TauGlobalTSLS = 30;
    DATAtableWV.(MiceWV{i}).ExpTimeSinceLastShockGlobal = exp( - DATAtableWV.(MiceWV{i}).TimeSinceLastShock / TauGlobalTSLS);

    
    %Add Density 
end 




%Automated Removal of outliers 
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableCleared = DATAtable;
Mice = fieldnames(DATA.Cond);
MiceNumber = length(Mice);
MiceCleared = {};
for i=1:MiceNumber 
    %disp([Mice{i} ' : ' num2str(height(DATAtable.(Mice{i}))) ', ' num2str(sum(DATAtable.(Mice{i}).Position > thresholdIsSafe))])
    if height(DATAtable.(Mice{i})) < thresholdNumObservation  
        DATAtableCleared = rmfield(DATAtableCleared, Mice{i}); 
        disp(['Removal of ' Mice{i} ' : Lack of points (' num2str(height(DATAtable.(Mice{i}))) ')'])
    elseif sum(DATAtable.(Mice{i}).Position > thresholdIsSafe) < thresholdFreezSafeExistence
        DATAtableCleared = rmfield(DATAtableCleared, Mice{i}); 
        disp(['Removal of ' Mice{i} ' : Not Enough Freeze Safe (' num2str(sum(DATAtable.(Mice{i}).Position > thresholdIsSafe)) ')'])
    else
        MiceCleared{end+1} = Mice{i};
    end 

end 

%Automated Removal of outliers for WaveLet Mouse
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableClearedWV = DATAtableWV;
Mice = fieldnames(DATA.Cond);
MiceWVNumber = length(MiceWV);
MiceWVCleared = {};
for i=1:MiceWVNumber 
    %disp([MiceWV{i} ' : ' num2str(height(DATAtable.(MiceWV{i}))) ', ' num2str(sum(DATAtable.(MiceWV{i}).Position > thresholdIsSafe))])
    if height(DATAtableWV.(MiceWV{i})) < thresholdNumObservation  
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Lack of points (' num2str(height(DATAtableWV.(MiceWV{i}))) ')'])
    elseif sum(DATAtableWV.(MiceWV{i}).Position > thresholdIsSafe) < thresholdFreezSafeExistence
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Not Enough Freeze Safe (' num2str(sum(DATAtableWV.(MiceWV{i}).Position > thresholdIsSafe)) ')'])
    elseif size(DATAtableWV.(MiceWV{i}),1) ~=  size(DATAtable.(MiceWV{i}),1)
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Not the same Array Size (' num2str([size(DATAtableWV.(MiceWV{i}),1)  size(DATAtable.(MiceWV{i}),1)]) ')'])
    
    else
        MiceWVCleared{end+1} = MiceWV{i};
    end 

end 