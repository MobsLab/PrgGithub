function [output] = binueSelfEntropy(data,methodParams)
% 
% Syntax:
% 
% [output] = binTransferEntropy(data,methodParams)
% 
% Description:
% 
% 1)  preprocessing the data according to the preprocess function chosen;
% 2)  evaluating the series terms involved to build the matrix containing
%     all the shifted series to evaluate the first conditional entropy 
%     term;
% 3)  evaluating the first conditional entropy term;
% 4)  evaluating the series terms involved to build the matrix containing
%     all the shifted series to evaluate the second conditional entropy 
%     term;
% 5)  evaluating the second conditional entropy term;
% 6)  evaluating the transfer entropy, for each target, as the difference
%     between the two conditional entropy terms;
% 8)  storing the most interesting outcomes, returning them in the output
%     structure
% 
% 
% Input:
% 
% data                  : matrix data
% 
% methodParams          : structure containing the current method 
%                         parameters
% 
% Output:
% 
% output                : structure containing the first conditional
%                         entropy term, the second conditional entropy term
%                         and the transfer entropy for each target
% 
% Calling function:
% 
% callingMethods

    infoSeries                    = methodParams.infoSeries;
    idTargets                     = methodParams.idTargets;
    idDrivers                     = methodParams.idDrivers;
    idOthersLagZero               = methodParams.idOthersLagZero;
    multi_bivAnalysis             = methodParams.multi_bivAnalysis;
    firstTermCaseVect             = methodParams.firstTermCaseVect;
    secondTermCaseVect            = methodParams.secondTermCaseVect;
    evalEntropyFun                = methodParams.entropyFun;
    preProcessingFun              = methodParams.preProcessingFun;
    genCondTermFunc               = methodParams.genCondTermFun;
    numSurrogates                 = methodParams.numSurrogates;
%     modelOrder                    = methodParams.modelOrder;

    if (max(size(data,1),size(data,2)) == size(data,1))
        data = data';
    end

    seriesToPreprocess            = [idTargets;idDrivers];

   
    %% STEP 1  | Preprocessing data
    dataPreprocessed              = preProcessingFun(data,seriesToPreprocess,multi_bivAnalysis,methodParams);


    %% STEP 2  | First Id Conditional Terms  | Targets (+ Other Variables if multi_bivAnalysis = 'multiv')
    if (~isempty(strfind(func2str(genCondTermFunc),'LagZero')))
        firstIdConditionalTerm        = genCondTermFunc(infoSeries,idTargets,idDrivers,idOthersLagZero,multi_bivAnalysis,firstTermCaseVect);
    else
        firstIdConditionalTerm        = genCondTermFunc(infoSeries,idTargets,idDrivers,multi_bivAnalysis,firstTermCaseVect);
    end


    %% STEP 3  | Evaluating the first conditional entropy term
%     fprintf('\n\nFirst Conditional Entropy Term Evaluation...');
    firstEntropyTerm              = evalEntropyFun(dataPreprocessed,idTargets,firstIdConditionalTerm);
%     fprintf('Done\n');
    
    %% Step 8  | Returning the output
    output                    = struct;

    output.preEntropy         = firstEntropyTerm(1,:);
    output.prepastEntropy     = firstEntropyTerm(2,:);
    output.pastEntropy        = firstEntropyTerm(3,:);
    output.trnasferEntropy      = firstEntropyTerm(1,:)-firstEntropyTerm(2,:)+firstEntropyTerm(3,:);
    output.params             = methodParams;


return;