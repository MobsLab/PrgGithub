function fig_st = GlobalFRateHist()
  
  hm = getenv('HOME');
  fig_st = {};
  
  A = Analysis([ hm filesep 'Data/DIRAC/']);
  dsets = List2Cell([ hm filesep 'Data/DIRAC/dirs_BD1.list']);

  [A, fr_maze1_D] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1_D] = getResource(A, 'FRateSleep1', dsets);  
  [A, fr_s2_D] = getResource(A, 'FRateSleep2', dsets);  
  [A, int_D] = getResource(A, 'IsInterneuron', dsets);
  
  fr_maze1_D = fr_maze1_D(find(~int_D));
  fr_s1_D= fr_s1_D(find(~int_D));  
  fr_s2_D = fr_s2_D(find(~int_D));  

  
  
  A_H5 = Analysis([hm filesep 'Data/Hyper5/']);
  dsets = List2Cell([hm filesep 'Data/Hyper5/dirs_Hyper5.list']);
  
  [A, fr_maze1_H5] = getResource(A_H5, 'FRateMaze', dsets);
  [A, fr_s1_H5] = getResource(A_H5, 'FRateSleep1', dsets);  
  [A, fr_s2_H5] = getResource(A_H5, 'FRateSleep2', dsets);  
  
%   fr_maze1_H5 = fr_maze1_H5(find(~int_H5));
%   fr_s1_H5= fr_s1_H5(find(~int_H5));  
%   fr_s2_H5 = fr_s2_H5(find(~int_H5));  

  
  A_C = Analysis([hm filesep 'Data/CRAM/']);
  dsets = List2Cell([hm filesep 'Data/CRAM/dirs_CRAM.list']);
  
  [A, fr_maze1_C] = getResource(A_C, 'FRateMaze', dsets);
  [A, fr_s1_C] = getResource(A_C, 'FRateSleep1', dsets);  
  [A, fr_s2_C] = getResource(A_C, 'FRateSleep2', dsets);  
  



  
  fr_maze1 = [fr_maze1_D ; fr_maze1_H5 ; fr_maze1_C];
  fr_s1 = [fr_s1_D ; fr_s1_H5 ; fr_s1_C];
  fr_s2 = [fr_s2_D ; fr_s2_H5 ; fr_s2_C];
  
    mx = max(max(fr_maze1), max(fr_s1));

  
  x = linspace(0, mx, 40);
  V = fr_maze1;
  str = ('Maze');
  logParameters(str, V);
  
  h = hist(fr_maze1, x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'GlobalFRateHistMaze';
  fig.figureType = 'hist';
  fig.xLabel = ('Firing Rate (Hz)');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  
  x = linspace(0, mx, 40);
  V = fr_s1;   
  str = ('Sleep 1');
  logParameters(str, V);
  h = hist(fr_s1, x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'GlobalFRateHistSleep1';
  fig.figureType = 'hist';
  fig.xLabel = ('Firing Rate (Hz)');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;
  warning off
  
  
  ix = find(fr_maze1 > 0 & fr_s1 > 0 & fr_s2 > 0);
  fr_maze1 = fr_maze1(ix);
  fr_s1 = fr_s1(ix);  
  fr_s2 = fr_s2(ix);  
  
  minx = min(min(log10(fr_maze1)), min(log10(fr_s1)));
  maxx = max(max(log10(fr_maze1)), max(log10(fr_s1)));  
  
 
  
  x = linspace(minx, maxx, 40);
  V = log10(fr_maze1);
  str = ('Log(Maze)');
  logParameters(str, V);

  h = hist(log10(fr_maze1), x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'GlobalLogFRateHistMaze';
  fig.figureType = 'hist';
  fig.xLabel = ('Log( Firing Rate )');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  x = linspace(minx, maxx, 40);
  V = log10(fr_s1);
  str = ('Log(Sleep 1)');
  logParameters(str, V);
  h = hist(log10(fr_s1), x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'GlobalLogFRateHistSleep1';
  fig.figureType = 'hist';
  fig.xLabel = ('Log( Firing Rate )');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  warning on
  
  
  %%%%%%%%%%%%%%%%
  %log/log frate plots
  warning off

  
 
  
  
  str = 'Log Maze/Sleep 1';
  fig = makeLogFigs(str, log10(fr_maze1), log10(fr_s1));
  fig.xLabel = ('log(f_{maze})');
  fig.yLabel = ('log(f_{S1})');
  fig.figureName = ('GlobalLogMS1');
  
  fig_st = [fig_st { fig } ];
  
  str = 'Log Maze/Sleep 2';  
  fig = makeLogFigs(str, log10(fr_maze1), log10(fr_s2));
  fig.xLabel = ('log(f_{maze})');
  fig.yLabel = ('log(f_{S2})');
  fig.figureName = ('GlobalLogMS2');
  
  fig_st = [fig_st { fig } ];
  
  
  str = 'Log Sleep 1/Sleep 2';
  fig = makeLogFigs(str, log10(fr_s1), log10(fr_s2));
  fig.xLabel = ('log(f_{S1})');
  fig.yLabel = ('log(f_{S2})');
  fig.figureName = ('GlobalLogS1S2');
  
  fig_st = [fig_st { fig } ];
  
  str = 'Maze/Sleep 1';
  fig = makeLogFigs(str, (fr_maze1), (fr_s1));
  fig.xLabel = ('f_{maze} (Hz)');
  fig.yLabel = ('f_{S1} (Hz)');
  fig.figureName = ('GlobalMS1');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  fig_st = [fig_st { fig } ];
  
  str = 'Maze/Sleep 2';  
  fig = makeLogFigs(str, (fr_maze1), (fr_s2));
  fig.xLabel = ('f_{maze} (Hz)');
  fig.yLabel = ('f_{S2} (Hz)');
  fig.figureName = ('GlobalMS2');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  
  fig_st = [fig_st { fig } ];
  
  
  str = 'Sleep 1/Sleep 2';
  fig = makeLogFigs(str, (fr_s1), (fr_s2));
  fig.xLabel = ('f_{S1} (Hz)');
  fig.yLabel = ('f_{S2} (Hz)');
  fig.figureName = ('GlobalS1S2');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  
  fig_st = [fig_st { fig } ];
  
  
  warning on
  
  
function logParameters(str, V);
   
  me = mean(V);
  sdev = std(V);
  skw = skewness(V);
  kurt = kurtosis(V);
  
  log_string = [ str ' mean: ' num2str(me) ' std: ' num2str(sdev)  ' skewness = ' num2str(skw) ' kurtosis = ' num2str(kurt)];
  
  logger(log_string);
  
  
function fig = makeLogFigs(str, x, y)
  
  fig.x{1} = x;
  fig.n{1} = y;
  [ar, br, rr, pr] = regression_line(x, y);
  fig.style{1} = 'k.';
  fig.style{2} = 'k-';  
  fig.figureType = 'plot';

  fig.axesProperties = {'DataAspectRatio', [1 1 1]};

  xm = ceil(max(max(x), max(y)));
  [ar, br, rr, pr] = regression_line(x, y);
  log_string = ...
      [str ' all cells',  newline, ...
       'slope = ' num2str(br), ' intercept = ', num2str(ar), newline, ...
       'correlation = ', num2str(rr^2)];
  logger(log_string);
% $$$   fig.x{2} = x;
% $$$   fig.n{2} = ar + br * x;
