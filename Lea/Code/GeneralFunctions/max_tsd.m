function maxTsd = max_tsd(tsa, is)

%  Returns the maximal value(s) and time(s) of a TSD object 
%
%  	USAGE:
%  	maxTsd = max_tsd(tsa, epoch)
%
%  	INPUTS:
%  	tsa - a tsd object
%  	epoch (optional) - an intervalSet object where max values have to be
%  	looked for. If epoch is specified, it overrides the internal TSD
%  	intervalSet.
%
%  	OUTPUTS:
%  	maxTsd - tsd of maximal value(s)
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
    error('The max function for tsd still doesn''t manage multidimensional data')
end

ld = length(d);
ls = length(st);
ix=1;

maxVal = [];
maxTimes = [];

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
    
    [m,t] = max(d(ixS:ix));
    maxVal = [maxVal;m];
    maxTimes = [maxTimes;rg(t+ixS-1)];
    
end

maxTsd = tsd(maxTimes, maxVal);