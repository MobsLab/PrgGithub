function [whl,t,GoodRanges,ep] = LoadPosition(fbasename)

% USAGE
% [whl,t,GoodRanges,ep] = LoadPosition(fbasename)
% 
% output:
%   whl: the position matrix
%   t: time vector
%   Good Ranges: the weel defined trackis epochs (require intervalSet toolbox)
%   ep: name and time boundaries of the different whl files in the folder
%   

Fs = 1250/32;

d = dir([fbasename '*.whl']);
whl = [];
GoodRanges = [];
t=[];
ep = cell(length(d),2);

for ii=1:length(d)
    whlt = dlmread(d(ii).name);
    [whlc GoodRangest] = CleanWhlForR(whlt);
    %[whl2 GoodRangest] = CleanWhl(whlt);    
    %keyboard
    whl = [whl;whlc];
    tt = length(t)+(1:size(whlt,1))';
    GoodRanges = [GoodRanges;GoodRangest+length(t)];
    ep{ii,1} = [tt(1) tt(end)]/Fs;
    ep{ii,2} = d(ii).name;
    t = [t;tt];
end

t = t/Fs;
GoodRanges = GoodRanges/Fs;