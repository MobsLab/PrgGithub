function spacePETH = RasterSpace(S, phiG, TStart, TEnd, varargin)


    
opt_varargin = varargin;

defined_options  = dictArray({ { 'RasterFraction', {0.7, {'numeric'}} }
                               { 'BinSize', {10, {'numeric'}}},
                                {'LineWidth', {1, {'numeric'} } },
                                {'Markers', { {}, {'cell'}} } ,
                                 {'MarkerTypes', { {}, {'cell'}}}, 
                                {'MarkerSize', { [], {'numeric'} } }
                                {'SpaceBin', {0.1, {'numeric'} } }

                                });
getOpt;

is = intervalSet(Range(TStart), Range(TEnd));

dPhi = Data(phiG);

mx = max(dPhi);
mn = min(dPhi);

binnedSpace = [-1:SpaceBin:1];

phiR = Restrict(phiG,is);

spacePETH = zeros(length(binnedSpace),1);

for i=1:length(binnedSpace)-1

	ep1 = thresholdIntervals(phiR,binnedSpace(i),'Direction','Above');
	ep2 = thresholdIntervals(phiR,binnedSpace(i+1),'Direction','Below');

	ep = intersect(ep1,ep2);

	spacePETH(i) = nanmean(Data(intervalRate(S,ep)));

end

