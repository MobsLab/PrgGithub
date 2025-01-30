function A = HDThetaPosition(A)

pdir = parent_dir(A);

dset = current_dataset(A);

 A = registerResource(A, 'Eeg', 'tsdArray', ...
     {1,1}, 'eeg', ...
     'skull screw EEG containing theta');
 
  
 load(fullfile(pdir, dset, 'eeg0.mat'));
 
 
 A = saveAllResources(A);

