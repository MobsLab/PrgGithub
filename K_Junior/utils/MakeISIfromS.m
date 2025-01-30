function ISI = MakeISIfromS(S, stepsize, varargin)
% 26.01.2018 KJ
%
% function ISI = MakeISIfromS(S,binsize, varargin)
%
% INPUT:
% - S                       a cell array of ts objects 
%                           (as generated, for example, by LoadSpikes)
% - binsize                 timestep for ctsd (measured in timestamps!) 
%  
%
% OUTPUT:
% - ISI   =  a ctsd in which the main structure is a |t| x nCells histogram of ISI
%
%
%       see MakeQfromS
%


%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end


%% INIT
%start and end time
T_start = inf;
T_end = -inf;
for iC = 1:length(S)
   if ~isempty(Data(S{iC})) %class(ts)
      T_start = min(T_start, StartTime(S{iC})); %class(ts)
      T_end = max(T_end, EndTime(S{iC})); %class(ts)
   end
end
T_start=0;

%intervalSet of size stepsize
start_intv = T_start:stepsize:T_end;
nb_intervals = length(start_intv);
for i=1:nb_intervals
    intervals_cells{i} = [start_intv(i), start_intv(i) + stepsize];
end


%% Build ISI Matrix

nCells = length(S); % number of cells
ISIdata = zeros(nb_intervals, nCells); 

for iC = 1:nCells
      
   if ~isempty(Data(S{iC}))  % class(ts)     
      spikeTimes = Restrict(S{iC}, T_start, T_end); % class(ts)
      isi_interval = cellfun(@(v)IsiOnInterval(spikeTimes, v), intervals_cells);
      isi_interval(isnan(isi_interval)) = 0;
        
      ISIdata(:,iC) = isi_interval';
   end                           
end	

ISI = tsd(start_intv, sparse(ISIdata));

end


function isi_interval = IsiOnInterval(spikeTimes, interval)
%   
% INPUTS:  
% spikeTimes: ts of spike times
% interval: intervalSet
%
% OUTPUT:
% isi_interval : isi on the interval
%

if nargin < 2
  error('Incorrect number of parameters.');
end


isi_interval = mean(diff(Data(Restrict(spikeTimes, intervalSet(interval(1),interval(2)) ))));

end


