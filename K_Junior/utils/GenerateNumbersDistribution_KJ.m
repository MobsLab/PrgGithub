%%GenerateNumbersDistribution_KJ
% 04.04.2018 KJ
%
% generate a list of numbers according a given distributions
%
% function numbers_generated = GenerateNumbersDistribution_KJ(x_distribution, y_distribution, n_points, varargin)
%
% INPUT:
% - x_distribution              = x values of the given distribution
% - y_distribution              = y values of the given distribution
% - n_points                    = number of points to generate
%                           
%
% - smooth (optional)           = smooth parameters to eventually smooth the given distributions 
%                               (default 0 - no smooth)
%
%
% OUTPUT:
% - numbers_generated           = list of numbers generated
%
%   see 
%       http://matlabtricks.com/post-44/generate-random-numbers-with-a-given-distribution
%


function numbers_generated = GenerateNumbersDistribution_KJ(x_distribution, y_distribution, n_points, varargin)


%% CHECK INPUTS

if nargin < 3 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'smooth'
            smoothing = varargin{i+1};
            if smoothing<=0
                error('Incorrect value for property ''smooth''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('smooth','var')
    smoothing=0;
end



%% normalise probability distribution
xq = x_distribution;

pdf = y_distribution;
pdf = pdf / sum(pdf);
pdf = Smooth(pdf, smoothing);

cdf = cumsum(pdf);

% remove non-unique elements
[cdf, mask] = unique(cdf);
xq = xq(mask);


%% generate
% create an array of random numbers
randomValues = rand(1, n_points);

% inverse interpolation to achieve P(x) -> x projection of the random values
projection = interp1(cdf, xq, randomValues);
numbers_generated = projection;


end
