function [output,params] = parametersAndMethodsBinueSelfEntropy(listRealizations,sampling,pointsToDiscard,channels,autoPairwiseTarDriv,handPairwiseTarDriv,resultDir,dataDir,copyDir,numProcessors,varargin)

    % Data: Time series in the rows
    realizations        = length(listRealizations);
    numSeries           = length(channels);
    output              = cell(1,realizations);
    
    
    % ***************************************************************************************************
    %% Setting methods
    
    method_caseVect = find(strcmp('binueSelf',varargin));
    binue = 0;
    if (~isempty(method_caseVect))
        binue                                              = 1;
        binUnifIdTargets                                   = varargin{1,method_caseVect+1};
        binUnifIdDrivers                                   = varargin{1,method_caseVect+2};
        binUnifIdOthersLagZero                             = varargin{1,method_caseVect+3};
        binUnifModelOrder                                  = varargin{1,method_caseVect+4};
        binUnifAnalysisType                                = varargin{1,method_caseVect+5};
        binUnifQuantumlevels                               = varargin{1,method_caseVect+6};
        binUnifEntropyFun                                  = varargin{1,method_caseVect+7};
        binUnifPreProcessingFun                            = varargin{1,method_caseVect+8};
        binUnifCaseVect1                                   = varargin{1,method_caseVect+9};
        binUnifCaseVect2                                   = varargin{1,method_caseVect+10};
        binUnifNumSurrogates                               = varargin{1,method_caseVect+11};
        binUnifAlphaPercentile                             = varargin{1,method_caseVect+12};
        binUnifTauMin                                      = varargin{1,method_caseVect+13};
        binUnifGenerateCondTermFun                         = varargin{1,method_caseVect+14};
        binUnifUsePresent                                  = varargin{1,method_caseVect+15};
    end
    nnData=[];
   
    % ***************************************************************************************************
    %% Setting the parameters for each method:
    
    if (binue)
        paramsBinTransferEntropy  = createBinueParams(numSeries,binUnifIdTargets,binUnifIdDrivers,binUnifIdOthersLagZero,binUnifModelOrder,binUnifAnalysisType,...
                                    binUnifQuantumlevels,binUnifEntropyFun,binUnifPreProcessingFun,binUnifCaseVect1,...
                                    binUnifCaseVect2,binUnifNumSurrogates,binUnifAlphaPercentile,binUnifTauMin,binUnifGenerateCondTermFun,binUnifUsePresent);
        if (autoPairwiseTarDriv(1) == 1)
            [tarDrivRows] = allAgainstAll (channels);
            paramsBinTransferEntropy.idTargets = tarDrivRows(1,:);
            paramsBinTransferEntropy.idDrivers = tarDrivRows(2,:);
        end
    end

  
    % ***************************************************************************************************
    %% Putting all the parameters in one structure
    
    if (binue)
        params.methods.binueSelfEntropy = paramsBinTransferEntropy;
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

 
    
    if (numProcessors > 1)
        matlabpool close;
%         poolobj = gcp('nocreate');
%         delete(poolobj);
    end
    
    
    
    
    
    
return;