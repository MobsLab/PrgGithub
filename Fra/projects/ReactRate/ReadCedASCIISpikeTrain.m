function TS = ReadCedASCIISpikeTrain(fname)
% READCEDASCIISPIKETRAIN - Reads one ascii Spike Train file exported by Spike 2
%   
  
  FILE = fopen(fname, 'r');
  
  % skip header: skip all lines that don't start with a numeric value
  
  d = '';
  
  while isempty(d)
    str = fgetl(FILE);
    d = sscanf(str, '%f');
  end
  
  % read in all lines
  
  d1 = fscanf(FILE, '%f');
  
  fclose(FILE);
  
  t = [d; d1] * 10000; % convert to 1/10000 s units
  

  
  TS = ts(t);