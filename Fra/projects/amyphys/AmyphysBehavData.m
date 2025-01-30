function AO = AmyphysBehavData(A)
  
  
  
  parentDir = parent_dir(A);
  rawDataDir = [parentDir filesep 'RawData'];
  
  A = registerResource(A, 'BehaviorFlags', 'tsdArray', {1,1}, ...
		       'behavFlags', ...
		       ['a tsd containing all the behavior flags ', ...
		    'describing process in the trials']);
  
  A = registerResource(A, 'ImageFlag', 'tsdArray', {1,1}, ...
		       'imageFlags', ...
		       ['a tsd containing the image code for all the ', ...
		    'images presented']);
  
  dset = current_dataset(A);
  
  cd(rawDataDir);
  
  behavFname = [dset '_ae.txt'];
  imageFname = [dset '_encodes.txt'];

  
  % take care of the images encodes: they have no encode so they can
  % be swallowed in with a single load instruction
  
  img = load(imageFname);
  imageFlags = tsd(img(:,1)*10000, img(:,2));
  
% $$$   % the behavioral flag routine is a bit more involved as the file is a
% $$$   % direct spike 2 dump
% $$$   
% $$$   FILE = fopen(behavFname, 'r');
% $$$   
% $$$   
% $$$   % skip header: skip all lines that don't start with a numeric value
% $$$   
% $$$   t = '';
% $$$   
% $$$   while isempty(t)
% $$$     str = fgetl(FILE);
% $$$     [t, ct, em, ni] = sscanf(str, '%f', 1);
% $$$   end
% $$$ 
% $$$   str = str(ni:end);
% $$$   [dummy, ct, em, ni] = sscanf(str, '%s', 1);
% $$$   str = str(ni:end);
% $$$   [f, ct, em, ni] = sscanf(str, '%f', 1);
% $$$   
% $$$   
% $$$   kount = 1;
% $$$   while(1)
% $$$     str = fgetl(FILE);
% $$$     if str == -1
% $$$       break;
% $$$     end
% $$$     kount = kount + 1;
% $$$     [tt, ct, em, ni] = sscanf(str, '%f', 1);
% $$$     if isempty(tt)
% $$$       break;
% $$$     end
% $$$     t(kount) = tt;
% $$$     str = str(ni:end);
% $$$     [dummy, ct, em, ni] = sscanf(str, '%s', 1);
% $$$     str = str(ni:end);
% $$$     ff = '';
% $$$     dk = 1;
% $$$     while isempty(ff)
% $$$       [ff, ct, em, ni] = sscanf(str, '%f', 1);
% $$$       [dummy, ct, em, ni] = sscanf(str, '%s', 1);
% $$$       str = str(ni:end);
% $$$ % $$$       if dk > 1
% $$$ % $$$ 	dk
% $$$ % $$$ 	keyboard
% $$$ % $$$       end
% $$$ % $$$       dk = dk + 1;
% $$$     end
% $$$     f(kount) = ff;
% $$$   end
% $$$   
% $$$   t = t(:);
% $$$   f = f(:);
% $$$   
  behav = load(behavFname);
  behavFlags = tsd(behav(:,1)*10000, behav(:,2));
    
% consistency check: check that there are "cueOn" flags and image flags
% at the same times   
  load ([parent_dir(A) filesep 'AmyphysLookupTables']);
  CueOn = find(behavFlags, ['Td == '  num2str(BehaviorLookup{'CueOn'}) ]);
  rt = Restrict(CueOn, imageFlags, 'align', 'closest');
  rt = Range(rt);
  ri = Range(imageFlags);
  
  if any(abs(rt - ri) > 0.01)
    display([dset ' data mismatch.']);
  end
  
 
  
  cd(parentDir);
  A =  saveAllResources(A);

  AO = A;