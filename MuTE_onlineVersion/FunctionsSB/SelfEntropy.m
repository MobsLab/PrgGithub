function [conditionalEntropyTerm,entropyMtx] = SelfEntropy(dataPreprocessed,idTargets,idConditionalTerm)
% 
% Syntax:
% 
% [entropyTerm entropyMtx] = conditionalEntropy(dataPreprocessed,idTargets,idConditionalTerm)
% 
% Description:
% 
% the function uses idConditionaTerm to build the rigth shifted matrix and
% processes the data through a probability estimating function and then
% evaluates the conditional entropy term
% 
% Input:
% 
% dataPreprocessed        : matrix containing only the nacessary data rows
%                           preprocessed
% 
% idTargets               : row vector contanining the indeces of the 
%                           series you want to study as target series
% 
% idConditionalTerm       : cell array containing the id candidates for
%                           each target
% 
% Output:
% 
% entropyTerm             : vector containing the causal entropy for each
%                           target
% 
% entropyMtx              : cell array containing all the shifted matrices
%                           according to idTargets and idConditionalTerm
%                           inputs
% 
% Calling function:
% 
% every time the evaluation of a conditional entropy is required, so
% usually the calling function is the method function


    numTargets                    = length(idTargets);
    conditionalEntropyTerm        = zeros(1,numTargets);

    %% Building the delay matrix
    entropyMtx                           = buildingEntropyMtx(dataPreprocessed,idTargets,idConditionalTerm);

    %% Evaluating the conditional entropy
    for i = 1 : numTargets %parfor
        entropyPresent            = evaluateEntropy(entropyMtx{1,i}(1,:));
        entropyPresentandPast     = evaluateEntropy(entropyMtx{1,i}(1:end,:));
        entropyPast               = evaluateEntropy(entropyMtx{1,i}(2:end,:));
        conditionalEntropyTerm(1,i)      = entropyPresent ;
        conditionalEntropyTerm(2,i)      = entropyPresentandPast ;
        conditionalEntropyTerm(3,i)      = entropyPast;

        
    end


return;