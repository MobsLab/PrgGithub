function [ r ] = reccPlot( s )
%RECCPLOT Compute the reccurent plot of the input
%   http://en.wikipedia.org/wiki/Recurrence_plot
%
% by antoine.delhomme@espci.fr
%

% Ensure that s is a col-vector
if size(s, 1) < size(s, 2)
    s = s';
end

% Define aliases
N = length(s);

% Prepare the reccurent plot matrix
r = zeros(N, N);

sig = sqrt(var(s));
if sig > 0.2
    s = s / sqrt(var(s));
end

for i = 1:N
    r(:, i) = abs(s - s(i));
end

end

