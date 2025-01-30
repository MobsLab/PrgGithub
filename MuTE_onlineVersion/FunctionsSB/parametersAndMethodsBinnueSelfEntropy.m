function [output,params] = parametersAndMethodsBinnueSelfEntropy(listRealizations,sampling,pointsToDiscard,channels,autoPairwiseTarDriv,handPairwiseTarDriv,resultDir,dataDir,copyDir,numProcessors,varargin)

    % Data: Time series in the rows
    realizations        = length(listRealizations);
    numSeries           = length(channels);
    output              = cell(1,realizations);
    
    
    % ***************************************************************************************************
    %% Setting methods
    
   
    method_caseVect = find(strcmp('binnueSelf',varargin));
    binnue = 0;
    if (~isempty(method_caseVect))
        binnue                                             = 1;
        binNonUnifIdTargets                                = varargin{1,method_caseVect+1};
        binNonUnifIdDrivers                                = varargin{1,method_caseVect+2};
        binNonUnifIdOthersLagZero                          = varargin{1,method_caseVect+3};
        binNonUnifModelOrder                               = varargin{1,method_caseVect+4};
        binNonUnifAnalysisType                             = varargin{1,method_caseVect+5};
        binNonUnifQuantumlevels                            = varargin{1,method_caseVect+6};
        binNonUnifEntropyFun                               = varargin{1,method_caseVect+7};
        binNonUnifPreProcessingFun                         = varargin{1,method_caseVect+8};
        binNonUnifCaseVect2                                = varargin{1,method_caseVect+9};
        binNonUnifNumSurrogates                            = varargin{1,method_caseVect+10};
        binNonUnifAlphaPercentile                          = varargin{1,method_caseVect+11};
        binNonUnifGenerateCondTermFun                      = varargin{1,method_caseVect+12};
        binNonUnifUsePresent                               = varargin{1,method_caseVect+13};
        binNonUnifScalpConduction                          = varargin{1,method_caseVect+14};
    end
   
    % ***************************************************************************************************
    %% Setting the parameters for each method:
    
 

    if (binnue)
        paramsNonUniformTransferEntropy = createBinnueParams(numSeries,binNonUnifIdTargets,binNonUnifIdDrivers,binNonUnifIdOthersLagZero,binNonUnifModelOrder,binNonUnifAnalysisType,...
                                          binNonUnifQuantumlevels,binNonUnifEntropyFun,binNonUnifPreProcessingFun,binNonUnifCaseVect2,...
                                          binNonUnifNumSurrogates,binNonUnifAlphaPercentile,binNonUnifGenerateCondTermFun,binNonUnifUsePresent,binNonUnifScalpConduction);
        if (autoPairwiseTarDriv(2) == 1)
            [tarDrivRows] = allAgainstAll (channels);
            paramsNonUniformTransferEntropy.idTargets = tarDrivRows(1,:);
            paramsNonUniformTransferEntropy.idDrivers = tarDrivRows(2,:);
        end
    end
    
    
    % ***************************************************************************************************
    %% Putting all the parameters in one structure
    
   

    if (binnue)
        params.methods.binnue = paramsNonUniformTransferEntropy;
    end
    
    
    % ***************************************************************************************************
    %% Calling methods
    
    if (numProcessors > 1)
    try
        disp('Destroing any existance matlab pool session');
        matlabpool('close');
%         poolobj = gcp('nocreate');
%         delete(poolobj);
    catch
        disp('No matlab pool session found');
    end
        matlabpool(numProcessors);
    end
    
    
    keyboard
    cd(dataDir);
    for i = 1 : realizations%parfor
        dataLoaded               = load([dataDir listRealizations(i,1).name]);
        if (isempty(nnData))
            dataNN               = dataLoaded.data(channels,1:sampling:(end-pointsToDiscard));
        else
            dataNN               = nnData;
        end
        output{1,i}              = callingMethods(dataLoaded.data(channels,1:sampling:(end-pointsToDiscard)),dataNN,params);
    end

    % *****************************************************************
    
    
    if (numProcessors > 1)
        matlabpool close;
%         poolobj = gcp('nocreate');
%         delete(poolobj);
    end
    
    
    
    
    
    
return;