function fig_st = Hyper5ByDsetEbar() 
  
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
  
  

  cn_ok = 1:(length(dsets));
  
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
  fig.figureName = 'Hyper5ByDsetEbar';
  
  
  fig_st = [fig_st { fig } ] ;

  fig = [];
  
  fig.x{1} = 1:length(cn_ok);
  fig.n{1} = XX2(cn_ok);
  fig.e{1} = XX2(cn_ok) - XX2CI(cn_ok,1);
  fig.eHi{1} = XX2CI(cn_ok,2) - XX2(cn_ok);
  fig.style{1} = 'bo';
 
  fig.x{2} = 1:length(cn_ok);
  fig.n{2} = XXr2(cn_ok);
  fig.e{2} = XXr2(cn_ok) - XXr2CI(cn_ok,1);
  fig.eHi{2} = XXr2CI(cn_ok,2) - XXr2(cn_ok);
  fig.style{2} = 'ro';
 
  fig.xLabel = 'datasets';
  fig.yLabel = 'r^2';
  
  
  fig.figureType = 'errorbar';
  fig.figureName = 'Hyper5ByDsetEbar2';
  
  
  fig_st = [fig_st { fig } ] ;

  keyboard