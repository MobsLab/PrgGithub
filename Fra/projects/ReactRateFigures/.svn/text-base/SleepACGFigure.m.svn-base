function fig_st = SleepACGFigure()
  
  hm = getenv('HOME');
  fig_st = {};
  
  
  
  load([ hm filesep 'Data/DIRAC/AvACG.mat'])
  
 
  
  fig = [];
  fig.x{1} = AvACG_t;
  fig.n{1} = AvACG;
  fig.figureName = 'SleepACG';
  fig.figureType = 'plot';
  fig.xLabel = ('Time Lag (minutes)');
  fig.yLabel = ('Correlation');
  
  fig_st = [fig_st { fig } ] ;

  
 