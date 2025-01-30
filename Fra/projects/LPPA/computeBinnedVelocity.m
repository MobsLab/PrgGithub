function A = computeBinnedVelocity(A)




A = getResource(A, 'PfcSpecgram');
A = getResource(A, 'Vs');
Vs = Vs{1};
A = registerResource(A, 'BinnedVelocity', 'tsdArray', {1,1}, ...
    'binnedVelocity', ...
    ['velocity binned with the same binning as the specgrams']);

movingwin = 2;
times = Range(pfcSpecgram{1});
is = intervalSet(times, times+movingwin(1)*10000);
binnedVelocity = intervalMean(Vs, is);
 
A = saveAllResources(A);