function [distance,L] = ComputeOnceMahal(features,unit)

distance = NaN;
L=NaN;
nFeatures = size(features,2)-3;
unitStr = ['(' int2str(unit(1)) ',' int2str(unit(2)) ')'];

% Determine spikes inside vs outside cluster
spikesInCluster = features(:,2)==unit(1) & features(:,3)==unit(2);
nSpikesInCluster = sum(spikesInCluster);
spikesInElectrodeGroup = features(:,2)==unit(1);
nSpikesInElectrodeGroup = sum(spikesInElectrodeGroup);


% We need at least as many spikes as features, but not more than half the total number of spikes
if nSpikesInCluster < nFeatures,
	warning(['Not enough spikes for unit ' unitStr '.']);
	return
end
if nSpikesInCluster > nSpikesInElectrodeGroup/2,
	warning(['Too many spikes for unit ' unitStr '.']);
	return
end

% Compute Mahalanobis distance for spikes inside (mIn) and outside (mOut) the cluster
m = mahal(features(:,4:end),features(spikesInCluster,4:end));
mIn = m(spikesInCluster);
mOut = m(~spikesInCluster);
% Determine the Mahalanobis of the Nth closest spike outside the cluster (where N is the number of spikes inside the cluster)
sOut = sort(mOut);
distance = sOut(nSpikesInCluster);

df = size(features,2)-3;
L = sum(1-chi2cdf(distance,df));





