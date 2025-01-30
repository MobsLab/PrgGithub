function fig_st = DIRACByDSetScatter() 
  
  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
  
  [A, XX] = getResource(A, 'SMReactCVXX', dsets);
  [A, XXCI] = getResource(A, 'SMReactCVXXCI', dsets);  
  
  [A, XXr] = getResource(A, 'SMReactCVXXr', dsets);
  [A, XXrCI] = getResource(A, 'SMReactCVXXrCI', dsets);    
  
  [A,cn] = getResource(A, 'CellNumber', dsets);
  
  cn_ok = find(cn> 15);
  
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
  fig.figureName = 'DIRACByDsetScatter';
  
  
  fig_st = [fig_st { fig } ] ;

  