function amyphysFigs()
  
  
  
  do_figures = [1:100];
  dontdo_figures = [];
  
  do_figures = setdiff(do_figures, dontdo_figures);
  
  
  
  global FIGURE_DIR;
  
  if isempty(FIGURE_DIR)
    FIGURE_DIR = '/home/fpbatta/Data/DIRAC/posterSFN04';
  end
  
 
  logfile = ([FIGURE_DIR filesep 'analysis_logfile_' date_tag '.txt' ...
		  ]);

  createLogs(logfile);
  
  
    
  
  
  
  check_figure(@VisRespFigs, 1); % check global figures OK
  
  
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
  