function [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_SB(t1,t2,binS,nbBins,confInt,varargin)

%  [H0,Hm,HeI,HeS,P] = XcConnection(t1,t2,binS,nbBins,confInt)
%  Find Synpatic conenctivity based on cross-correlograms
%  
%  INPUT:
%    t1,t2 : spike times in 10^-4 s
%    binS: bins ~size (in ms)
%    nbBins: number of bins
%    confInt: width o f the confidence interval, for example for
%    alpha=0.05, confInt=0.95
%  
%  OUTPUT:
%    H0: normal CrossCorr
%    Hm: Jittered average CrossCorr
%    HeI:
%    HeS: 
%    B: bin center points
%  
%  Adrien Peyrache 2010 
%  modified by SB 2016

% Parameters:
nbIter = 1000;

if isempty(varargin)>0
  jitter = varargin{1};
else
  jitter = 100;
end

% Normal CrossCorr
if ~isempty(t1) && ~isempty(t2)
  [H0,B] = CrossCorr(t1,t2,binS,nbBins);
else
  display('Pb with vector size')
end
H1 = [];

% Surrogate CrossCorr
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

