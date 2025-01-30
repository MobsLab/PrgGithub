load('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline.mat');
DATAWV = load('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline_WV.mat');
DATASBF = load('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_AllSaline_SpecByF.mat');
DATADZP = load('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_KB/Data_Model_DZP.mat');

Mice = fieldnames(DATA.Cond);
MiceNumber = length(Mice);

MiceDZP = fieldnames(DATADZP.DATA.Cond);
MiceNumberDZP = length(MiceDZP);

MiceWV = fieldnames(DATAWV.DATA.Cond);
MiceNumberWV = length(MiceWV);

MiceSBF = fieldnames(DATASBF.DATA.Cond);
MiceNumberSBF = length(MiceSBF);

MicePAG = {'M404';'M437';'M471';'M483';'M484';'M485';'M490';...
    'M507';'M508';'M509';'M514'};
MiceEyelid = {'M561';'M567';'M568';'M569';'M688';'M739';'M777';...
    'M849';'M1096';'M1144';'M1146';'M1171';'M9184';'M1189';...
    'M9205';'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};

MiceEyelidCleared = {'M561';'M567';'M568';'M569';'M688';'M739';'M777';...
    'M849';'M1171';'M1189';...
    'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};

global DATAtable DATAtableDZP DATAtableWV DATAtableSBF DATAtablePAG DATAtableEyelid DATAtableEyelidCleared

%Load initial data 
for i=1:MiceNumber
    OneMouseData = DATA.Cond.(Mice{i});
    if size(OneMouseData, 2) == 9
        DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    elseif size(OneMouseData, 2) == 8
        DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    elseif size(OneMouseData, 2) == 7
        DATAtable.(Mice{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    end
    DATAtable.(Mice{i}) = rmmissing(DATAtable.(Mice{i}));
end


TimeBlockedShock = [[480 780]; [1920 2220]; [3360 3660]; [4800 5100]];   
TimeBlockedSafe = [[960 1260]; [2400 2700]; [3840 4140]; [5280 5580]];   

%Enrichissement des données 
for i = 1:MiceNumber
    DATAtable.(Mice{i}).SigPosition = 1./(1+exp(-20*([DATAtable.(Mice{i}).Position]-0.5)));
    DATAtable.(Mice{i}).SigPositionxTimeSinceLastShock = DATAtable.(Mice{i}).SigPosition.*DATAtable.(Mice{i}).TimeSinceLastShock;

    %Add CumulRipples
    try 
        n = height(DATAtable.(Mice{i}));
        CumulRipplesArray = zeros(n,1);
        CumulRipples = 0;
        for j = 1:n
            CumulRipples = CumulRipples + DATAtable.(Mice{i}).RipplesNumber(j);
            CumulRipplesArray(j) = CumulRipples;
        end
        DATAtable.(Mice{i}).CumulRipples = CumulRipplesArray;
    catch
    end 
    
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
    OneMouseData = DATADZP.DATA.Cond.(MiceDZP{i});
    if size(OneMouseData, 2) == 9
        DATAtableDZP.(MiceDZP{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    elseif size(OneMouseData, 2) == 8
        DATAtableDZP.(MiceDZP{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    elseif size(OneMouseData, 2) == 7
        DATAtableDZP.(MiceDZP{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    end
    DATAtableDZP.(MiceDZP{i}) = rmmissing(DATAtableDZP.(MiceDZP{i}));
end



%Enrichissement des données 
for i = 1:MiceNumberDZP
    DATAtableDZP.(MiceDZP{i}).SigPosition = 1./(1+exp(-20*([DATAtableDZP.(MiceDZP{i}).Position]-0.5)));
    DATAtableDZP.(MiceDZP{i}).SigPositionxTimeSinceLastShock = DATAtableDZP.(MiceDZP{i}).SigPosition.*DATAtableDZP.(MiceDZP{i}).TimeSinceLastShock;

    try
        %Add CumulRipples
        n = height(DATAtableDZP.(MiceDZP{i}));
        CumulRipplesArray = zeros(n,1);
        CumulRipples = 0;
        for j = 1:n
            CumulRipples = CumulRipples + DATAtableDZP.(MiceDZP{i}).RipplesNumber(j);
            CumulRipplesArray(j) = CumulRipples;
        end
        DATAtableDZP.(MiceDZP{i}).CumulRipples = CumulRipplesArray;
    catch
    end 
    
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
    OneMouseData = DATAWV.DATA.Cond.(MiceWV{i});
    if size(OneMouseData, 2) == 9
        DATAtableWV.(MiceWV{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    elseif size(OneMouseData, 2) == 8
        DATAtableWV.(MiceWV{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    elseif size(OneMouseData, 2) == 7
        DATAtableWV.(MiceWV{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    end
    DATAtableWV.(MiceWV{i}) = rmmissing(DATAtableWV.(MiceWV{i}));
end

%Enrichissement des données 
for i = 1:MiceNumberWV
    DATAtableWV.(MiceWV{i}).SigPosition = 1./(1+exp(-20*([DATAtableWV.(MiceWV{i}).Position]-0.5)));
    DATAtableWV.(MiceWV{i}).SigPositionxTimeSinceLastShock = DATAtableWV.(MiceWV{i}).SigPosition.*DATAtableWV.(MiceWV{i}).TimeSinceLastShock;

    try
        %Add CumulRipples
        n = height(DATAtableWV.(MiceWV{i}));
        CumulRipplesArray = zeros(n,1);
        CumulRipples = 0;
        for j = 1:n
            CumulRipples = CumulRipples + DATAtableWV.(MiceWV{i}).RipplesNumber(j);
            CumulRipplesArray(j) = CumulRipples;
        end
        DATAtableWV.(MiceWV{i}).CumulRipples = CumulRipplesArray;
    catch
    end
    
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







%Load initial data for respiration detection by spectrogram multiplied by f

for i=1:MiceNumberSBF
    OneMouseData = DATASBF.DATA.Cond.(MiceSBF{i});
    if size(OneMouseData, 2) == 9
        DATAtableSBF.(MiceSBF{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone', 'RipplesNumber'}); 
    elseif size(OneMouseData, 2) == 8
        DATAtableSBF.(MiceSBF{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'CumulTimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    elseif size(OneMouseData, 2) == 7
        DATAtableSBF.(MiceSBF{i}) = array2table(OneMouseData, 'VariableNames', {'OB_Frequency', 'Position', 'GlobalTime', 'TimeSinceLastShock', 'TimeSpentFreezing', 'EyelidNumber', 'CumulEntryShockZone'}); 
    end
    DATAtableSBF.(MiceSBF{i}) = rmmissing(DATAtableSBF.(MiceSBF{i}));
end

%Enrichissement des données 
for i = 1:MiceNumberSBF
    DATAtableSBF.(MiceSBF{i}).SigPosition = 1./(1+exp(-20*([DATAtableSBF.(MiceSBF{i}).Position]-0.5)));
    DATAtableSBF.(MiceSBF{i}).SigPositionxTimeSinceLastShock = DATAtableSBF.(MiceSBF{i}).SigPosition.*DATAtableSBF.(MiceSBF{i}).TimeSinceLastShock;

    try
        %Add CumulRipples
        n = height(DATAtableSBF.(MiceSBF{i}));
        CumulRipplesArray = zeros(n,1);
        CumulRipples = 0;
        for j = 1:n
            CumulRipples = CumulRipples + DATAtableSBF.(MiceSBF{i}).RipplesNumber(j);
            CumulRipplesArray(j) = CumulRipples;
        end
        DATAtableSBF.(MiceSBF{i}).CumulRipples = CumulRipplesArray;
    catch
    end
    
    %Add Interaction between SigPos and Learning Predictors
    DATAtableSBF.(MiceSBF{i}).SigPositionxEyelidNumber = DATAtableSBF.(MiceSBF{i}).SigPosition .* DATAtableSBF.(MiceSBF{i}).EyelidNumber;
    DATAtableSBF.(MiceSBF{i}).SigPositionxCumulEntryShockZone = DATAtableSBF.(MiceSBF{i}).SigPosition .* DATAtableSBF.(MiceSBF{i}).CumulEntryShockZone;
    %DATAtableSBF.(MiceSBF{i}).SigPositionxCumulRipples = DATAtableSBF.(MiceSBF{i}).SigPosition .* DATAtableSBF.(MiceSBF{i}).CumulRipples;
    
    %Add HasSlept
%     if i < ilimProtocollong
%         DATAtableSBF.(MiceSBF{i}).hasSlept = DATAtableSBF.(MiceSBF{i}).GlobalTime > 2880;
%     else 
%         DATAtableSBF.(MiceSBF{i}).hasSlept = zeros(height(DATAtableSBF.(MiceSBF{i})),1);
%     end
    
    %Add isBlockedShock : 0 si la souris n'est pas bloquée côté shock et 1 si elle l'est
    DATAtableSBF.(MiceSBF{i}).isBlockedShock = zeros(height(DATAtableSBF.(MiceSBF{i})),1);
    for j = 1:length(TimeBlockedShock)
        DATAtableSBF.(MiceSBF{i}).isBlockedShock = DATAtableSBF.(MiceSBF{i}).isBlockedShock ...
            | ( DATAtableSBF.(MiceSBF{i}).GlobalTime >= TimeBlockedShock(j,1) ...
            & DATAtableSBF.(MiceSBF{i}).GlobalTime <= TimeBlockedShock(j,2) );
    end 
    
    %Add isBlockedSafe : 0 si la souris n'est pas bloquée côté safe et 1 si elle l'est
    DATAtableSBF.(MiceSBF{i}).isBlockedSafe = zeros(height(DATAtableSBF.(MiceSBF{i})),1);
    for j = 1:length(TimeBlockedSafe)
        DATAtableSBF.(MiceSBF{i}).isBlockedSafe = DATAtableSBF.(MiceSBF{i}).isBlockedSafe ...
            | ( DATAtableSBF.(MiceSBF{i}).GlobalTime >= TimeBlockedSafe(j,1) ...
            & DATAtableSBF.(MiceSBF{i}).GlobalTime <= TimeBlockedSafe(j,2) );
    end
    
    %Add ExpTSLS with learned Tau 
    TauGlobalTSLS = 30;
    DATAtableSBF.(MiceSBF{i}).ExpTimeSinceLastShockGlobal = exp( - DATAtableSBF.(MiceSBF{i}).TimeSinceLastShock / TauGlobalTSLS);

    
    %Add Density 
end 




disp('Spectro Mice :')
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

disp(' ')
disp('Diazepam Mice :')

%Automated Removal of outliers for WaveLet Mouse
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableClearedDZP = DATAtableDZP;
MiceDZP = fieldnames(DATADZP.DATA.Cond);
MiceNumberDZP = length(MiceDZP);
MiceDZPCleared = {};
for i=1:MiceNumberDZP 
    %disp([MiceDZP{i} ' : ' num2str(height(DATAtable.(MiceDZP{i}))) ', ' num2str(sum(DATAtable.(MiceDZP{i}).Position > thresholdIsSafe))])
    if height(DATAtableDZP.(MiceDZP{i})) < thresholdNumObservation  
        DATAtableClearedDZP = rmfield(DATAtableClearedDZP, MiceDZP{i}); 
        disp(['Removal of ' MiceDZP{i} ' : Lack of points (' num2str(height(DATAtableDZP.(MiceDZP{i}))) ')'])
    elseif sum(DATAtableDZP.(MiceDZP{i}).Position > thresholdIsSafe) < thresholdFreezSafeExistence
        DATAtableClearedDZP = rmfield(DATAtableClearedDZP, MiceDZP{i}); 
        disp(['Removal of ' MiceDZP{i} ' : Not Enough Freeze Safe (' num2str(sum(DATAtableDZP.(MiceDZP{i}).Position > thresholdIsSafe)) ')'])
    else
        MiceDZPCleared{end+1} = MiceDZP{i};
    end 

end 



disp(' ')
disp('Wavelet Mice :')

%Automated Removal of outliers for WaveLet Mouse
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableClearedWV = DATAtableWV;
MiceWV = fieldnames(DATAWV.DATA.Cond);
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







%Add Data tabke with only pag or eyelid 
for i = 1:length(MicePAG)
    DATAtablePAG.(MicePAG{i}) = DATAtable.(MicePAG{i});
end
for i = 1:length(MiceEyelid)
    DATAtableEyelid.(MiceEyelid{i}) = DATAtable.(MiceEyelid{i});
end 
for i = 1:length(MiceEyelidCleared)
    DATAtableEyelidCleared.(MiceEyelidCleared{i}) = DATAtable.(MiceEyelidCleared{i});
end 