function fig_st = Hyper5ByDsetScatter() 
  
  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/Hyper5/');
  dsets = List2Cell('/home/fpbatta/Data/Hyper5/dirs_Hyper5.list');
  
  [A, XX] = getResource(A, 'SMReactCVXX', dsets);
  [A, XXCI] = getResource(A, 'SMReactCVXXCI', dsets);  
  
  [A, XXr] = getResource(A, 'SMReactCVXXr', dsets);
  [A, XXrCI] = getResource(A, 'SMReactCVXXrCI', dsets);    
  
  [A, XX2] = getResource(A, 'SMReactCVXX2', dsets);
  [A, XX2CI] = getResource(A, 'SMReactCVXX2CI', dsets);  
  
  [A, XXr2] = getResource(A, 'SMReactCVXXr2', dsets);
  [A, XXr2CI] = getResource(A, 'SMReactCVXXr2CI', dsets);    

  [A, EV] = getResource(A, 'SMReactCVEV', dsets);
  [A, EVCI] = getResource(A, 'SMReactCVEVCI', dsets);  
  
  [A, EVr] = getResource(A, 'SMReactCVEVr', dsets);
  [A, EVrCI] = getResource(A, 'SMReactCVEVrCI', dsets);    
  
  [A, EV2] = getResource(A, 'SMReactCVEV2', dsets);
  [A, EV2CI] = getResource(A, 'SMReactCVEV2CI', dsets);  
  
  [A, EVr2] = getResource(A, 'SMReactCVEVr2', dsets);
  [A, EVr2CI] = getResource(A, 'SMReactCVEVr2CI', dsets);    

  %  [A,cn] = getResource(A, 'CellNumber', dsets);
  
  

  cn_ok = 1:length(XX);
  
  fig.x{1} = XXr(cn_ok);
  fig.n{1} = XX(cn_ok);
  fig.style{1} = 'k.';
  fig.lineProperties{1} = {'MarkerSize', 20};
  fig.lineProperties{2} = [];
  fig.lineProperties{3} = [];
  fig.lineProperties{4} = [];

  xmin = min(nanmin(XX(cn_ok)), nanmin(XXr(cn_ok)));
  xmin = floor(xmin*10)/10;
  xmax = max(nanmax(XX(cn_ok)), nanmax(XXr(cn_ok)));  
  xmax = ceil(xmax*10)/10;
  
  fig.x{2} = xmin:0.1:xmax;
  fig.n{2} = xmin:0.1:xmax;
  fig.style{2} = 'k--';
  fig.x{3} = zeros(size(xmin:0.1:xmax));
  fig.n{3} = xmin:0.1:xmax;
  fig.style{3} = 'k--';
  
  fig.x{4} = xmin:0.1:xmax;
  fig.n{4} = zeros(size(xmin:0.1:xmax));
  fig.style{4} = 'k--';
  fig.xLim = [xmin xmax];
  fig.yLim = [xmin xmax];
  
  
  fig.xLabel = 'Control correlation';
  fig.yLabel = 'Reactivation correlation';
  
  
  fig.figureType = 'plot';
  fig.figureName = 'Hyper5ByDsetScatter';
  
  
  fig_st = [fig_st { fig } ] ;
  %%%%%%%%%%%%%%%%%%
  XX = XX2;
  XXr = XXr2;
  
  
  fig.x{1} = XXr(cn_ok);
  fig.n{1} = XX(cn_ok);
  fig.style{1} = 'k.';
  fig.lineProperties{1} = {'MarkerSize', 20};
  fig.lineProperties{2} = [];
  fig.lineProperties{3} = [];
  fig.lineProperties{4} = [];

% $$$   xmin = min(nanmin(XX(cn_ok)), nanmin(XXr(cn_ok)));
% $$$   xmin = floor(xmin*10)/10;
% $$$   xmax = max(nanmax(XX(cn_ok)), nanmax(XXr(cn_ok)));  
% $$$   xmax = ceil(xmax*10)/10;
  xmin = -0.4;
  xmax = 1;
  
  fig.x{2} = xmin:0.1:xmax;
  fig.n{2} = xmin:0.1:xmax;
  fig.style{2} = 'k--';
  fig.xLim = [xmin xmax];
  fig.yLim = [xmin xmax];
  
  
  fig.xLabel = 'Control correlation';
  fig.yLabel = 'Reactivation correlation';
  
  
  fig.figureType = 'plot';
  fig.figureName = 'Hyper5_2ByDsetScatter';
  
  
  fig_st = [fig_st { fig } ] ;