function fig_st = Hyper5FRateHist()
  
  
  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');

  [A, fr_maze1] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
  [A, int] = getResource(A, 'IsInterneuron', dsets);
  
  fr_maze1 = fr_maze1(find(~int));
  fr_s1 = fr_s1(find(~int));  
  fr_s2 = fr_s2(find(~int));  

  mx = max(max(fr_maze1), max(fr_s1));
  
  x = linspace(0, mx, 40);
  h = hist(fr_maze1, x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'Hyper5FRateHistMaze';
  fig.figureType = 'hist';
  fig.xLabel = ('Firing Rate (Hz)');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  
  x = linspace(0, mx, 40);
  h = hist(fr_s1, x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'Hyper5FRateHistSleep1';
  fig.figureType = 'hist';
  fig.xLabel = ('Firing Rate (Hz)');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;
  warning off
  
  fr_maze1 = fr_maze1(find(fr_maze1 > 0));
  fr_s1 = fr_s1(find(fr_s1 > 0));  
  fr_s2 = fr_s2(find(fr_s2 > 0));  
  
  minx = min(min(log10(fr_maze1)), min(log10(fr_s1)));
  maxx = max(max(log10(fr_maze1)), max(log10(fr_s1)));  
  
 
  
  x = linspace(minx, maxx, 40);
  h = hist(log10(fr_maze1), x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'Hyper5LogFRateHistMaze';
  fig.figureType = 'hist';
  fig.xLabel = ('Log( Firing Rate )');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  x = linspace(minx, maxx, 40);
  h = hist(log10(fr_s1), x);
  
  fig = [];
  fig.x = x;
  fig.n = h';
  fig.figureName = 'Hyper5LogFRateHistSleep1';
  fig.figureType = 'hist';
  fig.xLabel = ('Log( Firing Rate )');
  fig.yLabel = ('Cell Count');
  
  fig_st = [fig_st { fig } ] ;

  warning on
  
  
  %%%%%%%%%%%%%%%%
  %log/log frate plots
  warning off
  [A, fr_maze1] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
  [A, int] = getResource(A, 'IsInterneuron', dsets);
  
  fr_maze1 = fr_maze1(find(~int));
  fr_s1 = fr_s1(find(~int));  
  fr_s2 = fr_s2(find(~int));  
  
  
  fig_st = {};
  str = 'Log Maze/Sleep 1';
  fig = makeLogFigs(str, log10(fr_maze1), log10(fr_s1));
  fig.xLabel = ('log(f_{maze})');
  fig.yLabel = ('log(f_{S1})');
  fig.figureName = ('Hyper5LogMS1');
  
  fig_st = [fig_st { fig } ];
  
  str = 'Log Maze/Sleep 2';  
  fig = makeLogFigs(str, log10(fr_maze1), log10(fr_s2));
  fig.xLabel = ('log(f_{maze})');
  fig.yLabel = ('log(f_{S2})');
  fig.figureName = ('Hyper5LogMS2');
  
  fig_st = [fig_st { fig } ];
  
  
  str = 'Log Sleep 1/Sleep 2';
  fig = makeLogFigs(str, log10(fr_s1), log10(fr_s2));
  fig.xLabel = ('log(f_{S1})');
  fig.yLabel = ('log(f_{S2})');
  fig.figureName = ('Hyper5LogS1S2');
  
  fig_st = [fig_st { fig } ];
  
  str = 'Maze/Sleep 1';
  fig = makeLogFigs(str, (fr_maze1), (fr_s1));
  fig.xLabel = ('f_{maze} (Hz)');
  fig.yLabel = ('f_{S1} (Hz)');
  fig.figureName = ('Hyper5MS1');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  fig_st = [fig_st { fig } ];
  
  str = 'Maze/Sleep 2';  
  fig = makeLogFigs(str, (fr_maze1), (fr_s2));
  fig.xLabel = ('f_{maze} (Hz)');
  fig.yLabel = ('f_{S2} (Hz)');
  fig.figureName = ('Hyper5MS2');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  
  fig_st = [fig_st { fig } ];
  
  
  str = 'Sleep 1/Sleep 2';
  fig = makeLogFigs(str, (fr_s1), (fr_s2));
  fig.xLabel = ('f_{S1} (Hz)');
  fig.yLabel = ('f_{S2} (Hz)');
  fig.figureName = ('Hyper5S1S2');
  fig.xLim = [0 15];
  fig.yLim = [0 15];
  
  fig_st = [fig_st { fig } ];
  
  
  warning on
  
  
  
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
