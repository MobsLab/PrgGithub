function A = HDThetaPosition(A)

pdir = parent_dir(A);

dset = current_dataset(A);

 A = registerResource(A, 'Flags', 'tsdArray', ...
     {1,1}, 'flags', ...
     'tsd containing all recording flags');
 
A = registerResource(A, 'ControlInterval', 'cell', ...
    {1,1}, 'controlInterval', ...
    'intervalSet of first interval preceding all planetarium rotation');

A = registerResource(A, 'FirstRotationInterval', 'cell', ...
    {1,1}, 'firstRotationInterval', ...
    'intervalSet of first planetarium rotation');

 A = registerResource(A, 'AllRotationsInterval', 'cell', ...
    {1,1}, 'allRotationsInterval', ...
    'intervalSet of first planetarium rotation');

  A = registerResource(A, 'NonRotationInterval', 'cell', ...
    {1,1}, 'nonRotationInterval', ...
    'intervalSet of first planetarium rotation');

 
load(fullfile(pdir, dset, 'flags.mat'));
load(fullfile(pdir, dset, 'rotationCodes.mat'));

 
 rr = Range(flags);
 ff = Data(flags);
 mx = rr(min(find(rr > 0)));
 
 controlInterval = intervalSet(0, mx);
 
 i0 = rr(min(strmatch('A _', ff)));
 i1= rr(min(strmatch('B _', ff)));
 
 
 firstRotationInterval = intervalSet(i0, i1);
 
 i0 = [];
 i1 = [];
 
 for i = 1:length(rotationCodes)
     c_on = rotationCodes(i);
     c_off = rotationCodesOff(i);
     i0(i) = rr(min(strmatch([c_on ' _'], ff)));
     i1(i)= rr(min(strmatch([c_off ' _'], ff)));
 end 
 
 allRotationsInterval = intervalSet(i0, i1);
 
 c0 = rr(1);
 c1 = rr(end);
 
 nonRotationInterval = diff(intervalSet(c0, c1), allRotationsInterval);
 
 
 
 A = saveAllResources(A);

