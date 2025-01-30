function fig_st = CRAMByDsetEbar() 
  
  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/CRAM/');
  dsets = List2Cell('/home/fpbatta/Data/CRAM/dirs_CRAM.list');
  
  [A, XX] = getResource(A, 'SMReactCVXX', dsets);
  [A, XXCI] = getResource(A, 'SMReactCVXXCI', dsets);  
  
  [A, XXr] = getResource(A, 'SMReactCVXXr', dsets);
  [A, XXrCI] = getResource(A, 'SMReactCVXXrCI', dsets);    
  
  [A,cn] = getResource(A, 'CellNumber', dsets);
  
  cn_ok = find(cn> 15);
  
  fig.x{1} = 1:length(cn_ok);
  fig.n{1} = XX(cn_ok);
  fig.e{1} = XX(cn_ok) - XXCI(cn_ok,1);
  fig.eHi{1} = XXCI(cn_ok,2) - XX(cn_ok);
  fig.style{1} = 'bo';
 
  fig.x{2} = 1:length(cn_ok);
  fig.n{2} = XXr(cn_ok);
  fig.e{2} = XXr(cn_ok) - XXrCI(cn_ok,1);
  fig.eHi{2} = XXrCI(cn_ok,2) - XXr(cn_ok);
  fig.style{2} = 'ro';
 
  fig.xLabel = 'datasets';
  fig.yLabel = 'r^2';
  
  
  fig.figureType = 'errorbar';
  fig.figureName = 'CRAMByDsetEbar';
  
  
  fig_st = [fig_st { fig } ] ;

  