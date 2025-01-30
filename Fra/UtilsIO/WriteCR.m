function WriteCR(CR, filename)
  
  RECSIZE = 512;
  
  fid = fopen(filename, 'w', 'b');
  if fid < 0
    error(['error while opening ' filename '.']);
  end
  
  
  fprintf(fid, '%%%%BEGINHEADER\n%%\n%%\n%%%%ENDHEADER\n');
  Nrec = floor(length(Range(CR, 'ts')) / RECSIZE);
  q = Data(CR);
  q = q(1:Nrec*512);
  q = reshape(q, 512, Nrec);
  tt = Range(CR, 'ts');
  tt = tt(1:Nrec*512);
  sfreq = 10000 / median(diff(tt));
  sf1 = floor(sfreq/65536);
  sf2 = mod(sfreq, 65536);
  clear CR;
  
  t0 = tt(1:512:length(tt));
  clear tt
  
  t1 = floor(t0/65536)';
  t2 = mod(t0, 65536)';
  t3 = 512 * ones(1,Nrec);
  t4 = sf1 * ones(1,Nrec);
  t5 = sf2 * ones(1,Nrec);
  
  q = [t1; t2; t3; t4; t5; q];
  
  count = fwrite(fid, q, 'int16');
  
  
  fclose(fid);
 
  
