%XcJitter_KJ
%16.01.2018 KJ
%
% [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_KJ(t1,t2,binS,nbBins,confInt,varargin)
%
% Data for determining synpatic connection between neurons
% Compute cross-correlogram and multiple CC for shuffled data
% Return confidence intervals and thresholds
%
%
%% INPUT:
%   t1,t2                       spike times in 10^-4 s
%   binS                        bins ~size (in ms)
%   nbBins                      number of bins
%   confInt                     width of the confidence interval (for example for alpha=0.05, confInt=0.95)
%
%   nbIter (optional)           double (default 1000)
%                               number of iteration for the shuffled data
%   jitter (optional)           double (default 100)   
%                               jitter parameter
%   parallelcomp (optional)     boolean (default 0)   
%                               use parallel computation if 1
%
%% OUTPUT:
%   H0                  normal CrossCorr
%   Hm                  Jittered average CrossCorr
%   HeI   
%   HeS   
%   Hstd  
%   B                   bin center points
%
%
% USER EXAMPLE 
%       [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_KJ(t1,t2,binS,nbBins,confInt)
% 
% See 
%   XcJitter_SB
%


function [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_KJ(t1,t2,binS,nbBins,confInt,varargin)


%% Initiation

if nargin < 5 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'nbIter'
            nbIter = varargin{i+1};
            if ~isfloat(nbIter) || nbIter <=0
                error('Incorrect value for property ''nbIter''.');
            end
        case 'jitter'
            jitter = varargin{i+1};
            if ~isfloat(jitter) || jitter <=0
                error('Incorrect value for property ''nbIter''.');
            end
        case 'parallelcomp'
            parallelcomp = varargin{i+1};
            if parallelcomp~=0 && parallelcomp ~=1
                error('Incorrect value for property ''parallelcomp''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~exist('nbIter', 'var')
    nbIter = 1000;
end
if ~exist('jitter', 'var')
    jitter = 100;
end
if ~exist('parallelcomp', 'var')
    parallelcomp = 0;
end


% Normal CrossCorr
if ~isempty(t1) && ~isempty(t2)
  [H0,B] = CrossCorr(t1,t2,binS,nbBins);
else
  display('Pb with vector size')
end

H1 = [];
% Surrogate CrossCorr
if parallelcomp
    parfor ii = 1:nbIter
        t2j = t2 + jitter*(rand(length(t2),1)-0.5);
        t2j = sort(t2j);
        if ~isempty(t1) && ~isempty(t2j)
            H = CrossCorr(t1,t2j,binS,nbBins);
            H1 = [H1;H'];
        else
          display('Pb with vector size')
        end    
    end
else
    for ii=1:nbIter
        t2j = t2 + jitter*(rand(length(t2),1)-0.5);
        t2j = sort(t2j);
        if ~isempty(t1) && ~isempty(t2j)
            H = CrossCorr(t1,t2j,binS,nbBins);
            H1 = [H1;H'];
        else
            display('Pb with vector size')
        end
    end
end


Hm = mean(H1);
HeI = zeros(length(B),1);
HeS = zeros(length(B),1);

HMaxMin(1,1) = prctile(max(H1(:,floor(size(H1,2)/2):end)'),confInt*100);
HMaxMin(2,1) = prctile(min(H1(:,floor(size(H1,2)/2):end)'),100-confInt*100);
HMaxMin(1,2) = prctile(max(H1(:,1:floor(size(H1,2)/2))'),confInt*100);
HMaxMin(2,2) = prctile(min(H1(:,1:floor(size(H1,2)/2))'),100-confInt*100);

% Get local significance bands
for b=1:length(B)
  t = H1(:,b);
  t = sort(t,'ascend');
  HeI(b) = t(round((1-confInt)/2*nbIter));
  HeS(b) = t(round((confInt + (1-confInt)/2)*nbIter));
  Hstd(b) = std(t);
end

end
