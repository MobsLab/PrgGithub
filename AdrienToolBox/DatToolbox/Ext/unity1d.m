% function U = unity(A) 
% A is  a signal vector
% the function gives a unity signal
% i.e. [signal-mean(signal)] / std(signal)

function [U,stdA] = unity1d(A,sd,restrict)

if ~isempty(restrict)
    meanA = mean(A(restrict));
    stdA = std(A(restrict));
else
    meanA = mean(A);
    stdA = std(A);
end
if ~isempty(sd)
    stdA = sd;
end

U = (A - meanA)/stdA;
end