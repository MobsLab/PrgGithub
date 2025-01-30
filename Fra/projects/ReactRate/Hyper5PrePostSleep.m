function AO = Hyper5PrePostSleep(A)
  
  
  
  


  
  A = registerResource(A, 'Sleep1_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep1', ...
		       ['10 minutes of sleep ending 3 mins before beginning', ...
		    ' of maze epoch']);
  
  A = registerResource(A, 'Sleep2_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep2', ...
		       ['10 minutes of sleep starting  3 mins after end', ...
		    ' of maze epoch']);
  
  A = registerResource(A, 'Sleep2_2_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep2_2', ...
		       ['10 minutes of sleep starting  3 mins after end', ...
		    ' of maze epoch']);
  
  A = registerResource(A, 'Sleep3_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep3', ...
		       ['10 minutes of sleep ending 3 mins before beginning', ...
		    ' of maze epoch']);

  A = registerResource(A, 'Sleep1_All_Epoch', 'cell', {1, 1}, ...
		       'Sleep1_all', ...
		       ['The whole sleep 1 epoch']);
  
  A = registerResource(A, 'Sleep2_All_Epoch', 'cell', {1, 1}, ...
		       'Sleep2_all', ...
		       ['The whole sleep 2 epoch']);
  
  A = registerResource(A, 'Sleep3_All_Epoch', 'cell', {1, 1}, ...
		       'Sleep3_all', ...
		       ['The whole sleep 3 epoch']);

  
  A = registerResource(A, 'Maze_Epoch', 'cell', {1, 1}, ...
		       'Maze', ...
		       ['Maze 1 epoch']);

  A = registerResource(A, 'Maze2_Epoch', 'cell', {1, 1}, ...
		       'Maze2', ...
		       ['Maze 2 epoch']);

  A = registerResource(A, 'PreSleep1_10min_Epoch', 'cell', {1, 1}, ...
		       'PreSleep1', ...
		       ['the portion of sleep 1 before the 10 min epoch in',...
		    'Sleep1_10min_Epoch' ]);
  
  A = registerResource(A, 'PostSleep3_10min_Epoch', 'cell', {1, 1}, ...
		       'PostSleep3', ...
		       ['the portion of sleep after  the 10 min epoch in',...
		    'Sleep3_10min_Epoch']);
  
   
  fid = fopen([current_dir(A) filesep 'epoch_times.ascii'], 'r');
  
  
  str = fgetl(fid);
  [str1, str2] = strtok(str);
  s1_start = timestr_conv(str1);
  s1_end = timestr_conv(str2);
  S1 = intervalSet(s1_end-7200000, s1_end-1200000);
  S1_all = intervalSet(s1_start, s1_end);

  preS1 = intervalSet(s1_end-13200000, s1_end-7200000);
  
  
  str = fgetl(fid);
  [str1, str2] = strtok(str);
  m1_start = timestr_conv(str1);
  m1_end = timestr_conv(str2);
  M = intervalSet(m1_start, m1_end);
  

  str = fgetl(fid);
  [str1, str2] = strtok(str);
  s2_start = timestr_conv(str1);
  s2_end = timestr_conv(str2);
  S2 = intervalSet(s2_start+1200000, s2_start+7200000);
  S2_2 = intervalSet(s2_end-7200000, s2_end-1200000);
  S2_all = intervalSet(s2_start, s2_end);
  
  str = fgetl(fid);
  [str1, str2] = strtok(str);
  m2_start = timestr_conv(str1);
  m2_end = timestr_conv(str2);
  
  M2 = intervalSet(m2_start, m2_end);
  
  str = fgetl(fid);
  [str1, str2] = strtok(str);
  s3_start = timestr_conv(str1);
  s3_end = timestr_conv(str2);
  S3 = intervalSet(s3_start+1200000, s3_start+7200000);
  S3_all = intervalSet(s3_start, s3_end);
 
  postS3 = intervalSet(s3_start+7200000, s3_start + 13200000);
  
  
  
 
  
  
   
   
   


  
  Maze{1} = M;
  Maze2{1} = M2;
  PreSleep1{1} = preS1;
  Sleep1{1} = S1;
  Sleep2{1} = S2;
  Sleep2_2{1} = S2_2;
  Sleep3{1} = S3;
  PostSleep3{1} = postS3;
  Maze{1} = M;
  Sleep1_all{1} = S1_all;
  Sleep2_all{1} = S2_all;
  Sleep3_all{1} = S3_all;
  
  A = saveAllResources(A);
      
  
  AO = A;
  
  
function t = timestr_conv(S)
% converts time string in time in 1/10000s  
  t = datenum(S)*86400* 10000;