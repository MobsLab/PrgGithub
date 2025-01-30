function posterSFN04figs()
  
  
  
  do_figures = [80];
  dontdo_figures = [];
  
  do_figures = setdiff(do_figures, dontdo_figures);
  
  
  
  global FIGURE_DIR;
  
  if isempty(FIGURE_DIR)
    FIGURE_DIR = '/home/fpbatta/Data/DIRAC/posterSFN04';
  end
  
 
  logfile = ([FIGURE_DIR filesep 'analysis_logfile_' date_tag '.txt' ...
		  ]);

  createLogs(logfile);
  
  
    
  
  
  
  check_figure(@DIRACGlobalFigs, 1); % check global figures OK
  
  check_figure(@DIRACRichPoorFigs, 3); % OK 
  
  check_figure(@DIRACGlobalPyrIntFigs, 7); % OK 
  
  check_figure(@DIRACSpwFigs, 11); % OK
  
  check_figure(@DIRACReactSimulationFigs, 1000); % OK
  
  check_figure(@DIRACTimeCourseFigs2, 21); % OK
  
  check_figure(@DIRACRatePairCompareFigs, 20); % OK  
  
  check_figure(@DIRACReactHistFigs2, 30); % OK
  
  check_figure(@DIRACReactCVHistFigs, 35); % OK
  
  check_figure(@CRAMGlobalFigs, 41); % check global figures OK

  check_figure(@CRAMRatePairCompareFigs, 45); % check global figures OK

  check_figure(@CRAMRatePairCompareFigs, 51); % TODO 

  check_figure(@CRAMTimeCourseFigs, 52); % OK

  check_figure(@Hyper5GlobalFigs, 61); % check global figures OK
  
  check_figure(@Hyper5SpwFigs, 66) 

  check_figure(@Hyper5RatePairCompareFigs, 70); % OK  

  check_figure(@Hyper5ReactHistByType, 75); % OK  

  check_figure(@Hyper5FRateHist, 80); % OK  

  check_figure(@DIRACByDsetEbar, 85); % OK  
  check_figure(@DIRACByDSetScatter, 86); % OK    

  check_figure(@CRAMByDsetEbar, 90); % OK  
  check_figure(@CRAMByDsetScatter, 91); % OK  

  check_figure(@Hyper5ByDsetEbar, 92); % OK  
  check_figure(@Hyper5ByDsetScatter, 93); % OK  
  check_figure(@Hyper5TimeCourseFigs, 94); % OK
  closeLogs;
  
  
  
function h = date_tag()
  
  c = clock;
  h = [datestr(clock, 29) '_' datestr(clock, 13)];
  h(find(h == ':')) = '-';
  
    
function check_figure(fh, nf);
  
  global N_FIGURE
  df = evalin('caller', 'do_figures');
  
  if ismember(nf, df)
    N_FIGURE = nf;
    makeFigure(fh);
  end
  