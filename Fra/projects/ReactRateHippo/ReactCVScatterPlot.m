function fig_st = ReactCVScatterPlot





hm = getenv('HOME');

pdir = [ hm filesep 'Data/DIRAC' ];
dsetList = [ pdir filesep 'dirs_BD1.list'];
datasets = List2Cell(dsetList);


global FIGURE_DIR;
FIGURE_DIR = [ hm filesep 'Data/DIRAC/ReactRateFigures'];


global N_FIGURE
N_FIGURE = 10;



A = Analysis(pdir);
nfig = 0;

fig_st = {};

for ds = 1:length(datasets)
  dset = datasets{ds};
  [A, frate_sleep1] = getResource(A, 'FRateSleep1', dset);
  [A, frate_sleep2] = getResource(A, 'FRateSleep2', dset);
  [A, frate_maze] = getResource(A, 'FRateMaze', dset);
  [A, frate_presleep1] = getResource(A, 'FRatePreSleep1', dset);
  [A, frate_postsleep2] = getResource(A, 'FRatePostSleep2', dset);
  [A, pyr] = getResource(A, 'IsPyramid', dset);
  pyr = find(pyr);
  
  display('dset');
  display(['# pyramidal cells: ' num2str(length(pyr))]);
  
  % react 
  figure(1), clf
  [a, b, r, p, X_ms1, X_s2s1] = regLine(frate_presleep1, frate_sleep1, ...
                                  frate_sleep2, frate_maze);
  plot(X_ms1, X_s2s1, '.');
  hold on 
  xl = get(gca, 'xlim');
  plot(xl, a + b * xl);
  
  % control 
  figure(2), clf
  [ar, br, rr, pr, X_ms1r, X_s2s1r] = regLine(frate_postsleep2, frate_sleep2, ...
                                  frate_sleep1, frate_maze);
  plot(X_ms1r, X_s2s1r, '.');
  hold on 
  xl = get(gca, 'xlim');
  plot(xl, ar + br * xl);
  
  display([' r = ' num2str(r) ' rr = ' num2str(rr)]);
  display([' p = ' num2str(p) ' pr = ' num2str(pr)]);
  
  
  do_plot = input('Do plot?')
  
  if do_plot
      
      nfig = nfig + 1;
      fig_direct = [];
      fig_direct.x{1} = X_ms1;
      fig_direct.n{1} = X_s2s1;
      x = [-3:3];
      
      fig_direct.xLim = [-3 3];
      fig_direct.yLim = [-3 3];
      fig_direct.x{2} = x;
      fig_direct.n{2} = a + b * x;

      fig_direct.xLabel = 'X_{MS1}';
      fig_direct.yLabel = 'X_{S2S1}';
      fig_direct.figureName = ['ScatterDirect_' num2str(nfig)];

      fig_direct.style{1} = 'k.';
      fig_direct.style{2} = 'k-';
      fig_direct.figureType = 'plot';

      fig_direct.axesProperties = {'DataAspectRatio', [1 1 1]};


      fig_inverse = fig_direct;

      
      fig_inverse.x{1} = X_ms1r;
      fig_inverse.n{1} = - X_s2s1r;
      x = [-3:3];
      fig_inverse.x{2} = x;
      fig_inverse.n{2} = ar + br * x;
      fig_inverse.xLabel = 'X_{MS2}';
      fig_inverse.yLabel = 'X_{S1S2}';
      fig_inverse.figureName = ['ScatterInverse_' num2str(nfig)];

  
      makeFigure({fig_direct fig_inverse});
      
  end
end







function [a, b, r, p,X_ms1, X_s2s1] = regLine(fp1, f1, f2, fm)
    
    
    X_ms1 = log10(fm./fp1);
    X_s2s1 = log10(f2./f1);
    [a, b, r, p] = regression_line(X_ms1, X_s2s1);
    
    ix = find(isfinite(X_ms1 .* X_s2s1));
    X_ms1 = X_ms1(ix);
    X_s2s1 = X_s2s1(ix);
    
    
    return
    
    
    
