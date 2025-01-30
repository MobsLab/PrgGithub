function ReactRateSimPlots

do_figures = [1:100];
  dontdo_figures = [];
  
  do_figures = setdiff(do_figures, dontdo_figures);
  
  s_ehs = [0  0.1 0.2 0.3 ];
  e_ehs =[0 0.1 0.2 0.3 0.4 0.5 0.6];
  
  
  
  global FIGURE_DIR;
  
  if isempty(FIGURE_DIR)
    FIGURE_DIR = '/home/fpbatta/Data/NetworkSim/figures';
  end
  
 
  logfile = ([FIGURE_DIR filesep 'analysis_logfile_' date_tag '.txt' ...
		  ]);

  createLogs(logfile);
  
  load SynEnhResults
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = s_ehs;
  fig.n{1} = rEnhRate;
  fig.e{1} = rsEnhRate;
  fig.style{1} = 'kd-';
  fig.x{2} = s_ehs;
  fig.n{2} = rUnEnhRate;
  fig.e{2} = rsUnEnhRate;
  fig.style{2} = 'ks-';
  fig.yLabel = 'Firing Rate';
  fig.xLabel = 'synaptic potentiation';


  fig.figureType = 'errorbar';
  fig.figureName = 'SynExcRates';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 1);
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = s_ehs;
  fig.n{1} = rCorrEnh;
  fig.e{1} = rsCorrEnh;
  fig.style{1} = 'kd-';
  fig.x{2} = s_ehs;
  fig.n{2} = rCorrNon;
  fig.e{2} = rsCorrNon;
  fig.style{2} = 'ks-';
  fig.yLabel = 'Pairwise correlation';
  fig.xLabel = 'synaptic potentiation';


  fig.figureType = 'errorbar';
  fig.figureName = 'SynExcCorr';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 2);
  
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = s_ehs;
  fig.n{1} = rEnhOverlap;
  
  fig.style{1} = 'kd-';
  fig.x{2} = s_ehs;
  fig.n{2} = rCorrNon;
  
  fig.style{2} = 'ks-';
  fig.xLabel = 'Overlap';
  fig.yLabel = 'synaptic potentiation';


  fig.figureType = 'plot';
  fig.figureName = 'SynExcOverlap';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 3);
 
  
  load ExcEnhResults
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = e_ehs;
  fig.n{1} = rEnhRate;
  fig.e{1} = rsEnhRate;
  fig.style{1} = 'kd-';
  fig.x{2} = e_ehs;
  fig.n{2} = rUnEnhRate;
  fig.e{2} = rsUnEnhRate;
  fig.style{2} = 'ks-';
  fig.yLabel = 'Firing Rate';
  fig.xLabel = 'excitability change';


  fig.figureType = 'errorbar';
  fig.figureName = 'ExcExcRates';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 4);
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = e_ehs;
  fig.n{1} = rCorrEnh;
  fig.e{1} = rsCorrEnh;
  fig.style{1} = 'kd-';
  fig.x{2} = e_ehs;
  fig.n{2} = rCorrNon;
  fig.e{2} = rsCorrNon;
  fig.style{2} = 'ks-';
  fig.yLabel = 'Pairwise correlation';
  fig.xLabel = 'excitability change';

    keyboard
  fig.figureType = 'errorbar';
  fig.figureName = 'ExcExcCorr';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 5);
  
  
  
  fig_st = {};
  fig = [];
  fig.x{1} = e_ehs;
  fig.n{1} = rEnhOverlap;
  
  fig.style{1} = 'kd-';
  fig.x{2} = e_ehs;
  fig.n{2} = rCorrNon;
  
  fig.style{2} = 'ks-';
  fig.xLabel = 'Overlap';
  fig.yLabel = 'excitability change';


  fig.figureType = 'plot';
  fig.figureName = 'ExcExcOverlap';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 6);
  
  
  
  load s2n2000p100baseline vFinal
  
  mm = mean(vFinal, 2);
  
  bins = linspace(-6, 30, 20);
  h = hist(mm, bins);
  
  fig_st = {};
  fig = [];
  fig.x = bins;
  fig.n = h';
  fig.xLabel = 'log(firing rate)';
  fig.yLabel = 'excitability change';


  fig.figureType = 'hist';
  fig.figureName = 'BaselineRate';
  
  fig_st = [fig_st { fig } ] ;
  
  check_figure(fig_st, 6);
  
  closeLogs;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
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
  