function minTsd = min_tsd(tsa, is)

%  Returns the minimal value(s) and time(s) of a TSD object 
%
%  	USAGE:
%  	minTsd = min_tsd(tsa, epoch)
%
%  	INPUTS:
%  	tsa - a tsd object
%  	epoch (optional) - an intervalSet object where min values have to be
%  	looked for. If epoch is specified, it overrides the internal TSD
%  	intervalSet.
%
%  	OUTPUTS:
%  	maxTsd - tsd of minimal value(s)
%
%  -----
%  14/05/2020 LP adapted from :
%
%  copyright (c) 2009 Adrien Peyrache, adrien.peyrache@gmail.com
%  This software is released under the GNU GPL
%  www.gnu.org/copyleft/gpl.html

if nargin==1
    is = intervalSet(tsa(1),tsa(end));
end

st = Start(is);
en = End(is);

rg = Range(tsa);
d = Data(tsa);

if size(d,2)>1
    error('The min function for tsd still doesn''t manage multidimensional data')
end

ld = length(d);
ls = length(st);
ix=1;

minVal = [];
minTimes = [];

for i=1:ls
    
    if rg(1) >= st(i)
        ix = 1;
    else
        while rg(ix)<st(i)
            ix=ix+1;
        end
    end
    
    ixS = ix;
    
    while rg(ix)<en(i)
        ix=ix+1;
        if ix>length(rg)
            ix = length(rg);
            break
        end
    end
    
    [m,t] = min(d(ixS:ix));
    minVal = [minVal;m];
    minTimes = [minTimes;rg(t+ixS-1)];
    
end

minTsd = tsd(minTimes, minVal);