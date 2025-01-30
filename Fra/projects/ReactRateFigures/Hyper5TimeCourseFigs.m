function fig_st = Hyper5TimeCourseFigs()
  
  fig_st = {};
  do_figures = [1:100];
  dontdo_figures = [];
  
  hm = getenv('HOME');
 
  dsets = List2Cell([hm '/Data/Hyper5/dirs_Hyper5.list']);
  A = Analysis([ hm '/Data/Hyper5/']);

  global FIGURE_DIR;
  FIGURE = [];
  
  if isempty(FIGURE_DIR)
    FIGURE_DIR = [ hm '/Data/DIRAC/ReactRateFigures'];
  end
  
 
  logfile = ([FIGURE_DIR filesep 'analysis_logfile_' date_tag '.txt' ...
		  ]);

  createLogs(logfile);
  
  
  [A, frate_binned_s2] = getResource(A, 'FRateBinnedS2', dsets);

  [A, R] = getResource(A, 'ReactTimeCourseR', dsets);
  
    
  
  RA = merge(R);
  ra = Data(RA);
  m = max(ra, [], 1);
  ram = ra * diag(1./m) ;
  m = mean(ram,2);
  e = sem(ram');
  t = Range(frate_binned_s2{1}, 's');
  t = t-t(1) +180;
  
  fig = [];
  fig.x{1} = t;
  fig.n{1} = m;
  fig.e{1} = e;
  fig.style{1} = 'k-';
  
  fig.xLabel = 'Time (s)';
  fig.yLabel = 'normalized reactivation';


  fig.figureType = 'errorbar';
  fig.figureName = 'Hyper5TimeCourse';


  fig_st = [fig_st { fig } ] ;

  
  check_figure(fig_st, 1);
 
  
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
  