function HDSummary

do_figures = 1:100;
global FIGURE_DIR;

FIGURE_DIR = [];
if isempty(FIGURE_DIR)
    hm = getenv('HOME');
    FIGURE_DIR = [ hm filesep 'Data/Angelo/figures'];
end


outputFormat = 'excel';
sign_thresh = 0.01;  
hm = getenv('HOME');
parent_dir = [ hm '/Data/Angelo'];
sign_thresh = 0.01;

datasets = List2Cell([ parent_dir filesep 'datasets_eeg.list' ] );

A = Analysis(parent_dir);

[A, cn] = getResource(A, 'HDThetaCellList', datasets);
[A, HDMean] = getResource(A, 'CellHDMean', datasets);
[A, HDDelta] = getResource(A, 'CellHDDelta', datasets);
[A, HDPval] = getResource(A, 'CellHDPval', datasets);


   
lgroup = intersect(strmatch('l', ac,'exact'),find(~doub));
blgroup = intersect(strmatch( 'bl', ac, 'exact'), find(~doub));
bgroup = intersect(strmatch( 'b', ac, 'exact'), find(~doub));
sigroup = intersect(strmatch( 'si', ac, 'exact'), find(~doub));

group_ix = zeros(size(tr));
group_ix(lgroup) = 1; % code 1 for lateral
group_ix(bgroup) = 2; % code 2 for basal
group_ix(sigroup) = 3; % code 3 for si 
group_ix(blgroup) = 4; % code 4 for basal/lateral

enum({'ROW_lateral', 'ROW_basal', 'ROW_si', 'ROW_bl', 'ROW_anova'});

rows{ROW_lateral} ='lateral';
rows{ROW_basal} = 'basal';
rows{ROW_si} = 'subst. inn.';
rows{ROW_bl} = 'bl';
rows{ROW_anova} = 'ANOVA p-value';


nrows = length(rows);

enum({'COL_totCells', 
    'COL_baseRate', 
    'COL_burstiness', 
    'COL_fixSens',
    'COL_fixPercent', 
    'COL_fixChange', 
    'COL_phasSens', 
    'COL_phasPercent', 
    'COL_phasChange', 
    'COL_tonicSens', 
    'COL_tonicPercent', 
    'COL_tonicChange', 
    'COL_imgoffSens', 
    'COL_imgoffPercent', 
    'COL_imgoffChange'
    });

cols{COL_totCells} = 'Tot. cells';
cols{COL_baseRate} = 'Baseline Rate';
cols{COL_burstiness} = 'Burstiness';
cols{COL_fixSens} = 'fixspot sensitive';
cols{COL_fixPercent} = '%';
cols{COL_fixChange} = 'fixspot change';
cols{COL_phasSens} = 'phasic sensitive';
cols{COL_phasPercent} = '%';
cols{COL_phasChange} = 'phasic change';
cols{COL_tonicSens} = 'tonic sensitive';
cols{COL_tonicPercent} = '%';
cols{COL_tonicChange} = 'tonic change';
cols{COL_imgoffSens} = 'imgoff sensitive';
cols{COL_imgoffPercent} = '%';
cols{COL_imgoffChange} = 'imgoff change';



ncols = length(cols);


data = cell(nrows, ncols);



% lateral nucleus 

data{ROW_lateral, COL_totCells} = length(lgroup);

bm = mean(bs_rate(lgroup));
bs = sem(bs_rate(lgroup));
data{ROW_lateral, COL_baseRate} = [num2str(bm) ' +/- ' num2str(bs)];

rm = mean(brs(lgroup));
rs = sem(brs(lgroup));
data{ROW_lateral, COL_burstiness} = [num2str(rm) ' +/- ' num2str(rs)];


s = sum(fp(lgroup) < sign_thresh);
data{ROW_lateral, COL_fixSens} = s;
data{ROW_lateral, COL_fixPercent} = 100 * s / length(lgroup);
cm = mean(fr(lgroup));
cs = sem(fr(lgroup));
data{ROW_lateral, COL_fixChange} = [num2str(cm) ' +/- ' num2str(cs)];

s = sum(pp(lgroup) < sign_thresh);
data{ROW_lateral, COL_phasSens} = s;
data{ROW_lateral, COL_phasPercent} = 100 * s / length(lgroup);
cm = mean(pr(lgroup));
cs = sem(pr(lgroup));
data{ROW_lateral, COL_phasChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(tp(lgroup) < sign_thresh);
data{ROW_lateral, COL_tonicSens} = s;
data{ROW_lateral, COL_tonicPercent} = 100 * s / length(lgroup);
cm = mean(tr(lgroup));
cs = sem(tr(lgroup));
data{ROW_lateral, COL_tonicChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(op(lgroup) < sign_thresh);
data{ROW_lateral, COL_imgoffSens} = s;
data{ROW_lateral, COL_imgoffPercent} = 100 * s / length(lgroup);
cm = mean(or(lgroup));
cs = sem(or(lgroup));
data{ROW_lateral, COL_imgoffChange} = [num2str(cm) ' +/- ' num2str(cs)];



% basal nucleus 

data{ROW_basal, COL_totCells} = length(bgroup);

bm = mean(bs_rate(bgroup));
bs = sem(bs_rate(bgroup));
data{ROW_basal, COL_baseRate} = [num2str(bm) ' +/- ' num2str(bs)];

rm = mean(brs(bgroup));
rs = sem(brs(bgroup));
data{ROW_basal, COL_burstiness} = [num2str(rm) ' +/- ' num2str(rs)];

s = sum(fp(bgroup) < sign_thresh);
data{ROW_basal, COL_fixSens} = s;
data{ROW_basal, COL_fixPercent} = 100 * s / length(bgroup);
cm = mean(fr(bgroup));
cs = sem(fr(bgroup));
data{ROW_basal, COL_fixChange} = [num2str(cm) ' +/- ' num2str(cs)];

s = sum(pp(bgroup) < sign_thresh);
data{ROW_basal, COL_phasSens} = s;
data{ROW_basal, COL_phasPercent} = 100 * s / length(bgroup);
cm = mean(pr(bgroup));
cs = sem(pr(bgroup));
data{ROW_basal, COL_phasChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(tp(bgroup) < sign_thresh);
data{ROW_basal, COL_tonicSens} = s;
data{ROW_basal, COL_tonicPercent} = 100 * s / length(bgroup);
cm = mean(tr(bgroup));
cs = sem(tr(bgroup));
data{ROW_basal, COL_tonicChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(op(bgroup) < sign_thresh);
data{ROW_basal, COL_imgoffSens} = s;
data{ROW_basal, COL_imgoffPercent} = 100 * s / length(lgroup);
cm = mean(or(bgroup));
cs = sem(or(bgroup));
data{ROW_basal, COL_imgoffChange} = [num2str(cm) ' +/- ' num2str(cs)];



% si nucleus 

data{ROW_si, COL_totCells} = length(sigroup);

bm = mean(bs_rate(sigroup));
bs = sem(bs_rate(sigroup));
data{ROW_si, COL_baseRate} = [num2str(bm) ' +/- ' num2str(bs)];

rm = mean(brs(sigroup));
rs = sem(brs(sigroup));
data{ROW_si, COL_burstiness} = [num2str(rm) ' +/- ' num2str(rs)];

s = sum(fp(sigroup) < sign_thresh);
data{ROW_si, COL_fixSens} = s;
data{ROW_si, COL_fixPercent} = 100 * s / length(sigroup);
cm = mean(fr(sigroup));
cs = sem(fr(sigroup));
data{ROW_si, COL_fixChange} = [num2str(cm) ' +/- ' num2str(cs)];

s = sum(pp(sigroup) < sign_thresh);
data{ROW_si, COL_phasSens} = s;
data{ROW_si, COL_phasPercent} = 100 * s / length(sigroup);
cm = mean(pr(sigroup));
cs = sem(pr(sigroup));
data{ROW_si, COL_phasChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(tp(sigroup) < sign_thresh);
data{ROW_si, COL_tonicSens} = s;
data{ROW_si, COL_tonicPercent} = 100 * s / length(sigroup);
cm = mean(tr(sigroup));
cs = sem(tr(sigroup));
data{ROW_si, COL_tonicChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(op(sigroup) < sign_thresh);
data{ROW_si, COL_imgoffSens} = s;
data{ROW_si, COL_imgoffPercent} = 100 * s / length(lgroup);
cm = mean(or(sigroup));
cs = sem(or(sigroup));
data{ROW_si, COL_imgoffChange} = [num2str(cm) ' +/- ' num2str(cs)];


% bl nucleus 

data{ROW_bl, COL_totCells} = length(blgroup);

bm = mean(bs_rate(blgroup));
bs = sem(bs_rate(blgroup));
data{ROW_bl, COL_baseRate} = [num2str(bm) ' +/- ' num2str(bs)];

rm = mean(brs(blgroup));
rs = sem(brs(blgroup));
data{ROW_bl, COL_burstiness} = [num2str(rm) ' +/- ' num2str(rs)];

s = sum(fp(blgroup) < sign_thresh);
data{ROW_bl, COL_fixSens} = s;
data{ROW_bl, COL_fixPercent} = 100 * s / length(blgroup);
cm = mean(fr(blgroup));
cs = sem(fr(blgroup));
data{ROW_bl, COL_fixChange} = [num2str(cm) ' +/- ' num2str(cs)];

s = sum(pp(blgroup) < sign_thresh);
data{ROW_bl, COL_phasSens} = s;
data{ROW_bl, COL_phasPercent} = 100 * s / length(blgroup);
cm = mean(pr(blgroup));
cs = sem(pr(blgroup));
data{ROW_bl, COL_phasChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(tp(blgroup) < sign_thresh);
data{ROW_bl, COL_tonicSens} = s;
data{ROW_bl, COL_tonicPercent} = 100 * s / length(blgroup);
cm = mean(tr(blgroup));
cs = sem(tr(blgroup));
data{ROW_bl, COL_tonicChange} = [num2str(cm) ' +/- ' num2str(cs)];


s = sum(op(blgroup) < sign_thresh);
data{ROW_bl, COL_imgoffSens} = s;
data{ROW_bl, COL_imgoffPercent} = 100 * s / length(lgroup);
cm = mean(or(blgroup));
cs = sem(or(blgroup));
data{ROW_bl, COL_imgoffChange} = [num2str(cm) ' +/- ' num2str(cs)];


% ANOVAS

% ANOVAS only for cells in basal, lateral, si

gc = find(group_ix<4);

grp = group_ix(gc);
p = anova1(bs_rate(gc),grp, 'off');
data{ROW_anova, COL_baseRate} = p;

p = anova1(brs(gc), grp, 'off');
data{ROW_anova, COL_burstiness} = p;

p = anova1(fr(gc), grp, 'off');
data{ROW_anova, COL_fixChange} = p;

p = anova1(pr(gc), grp, 'off');
data{ROW_anova, COL_phasChange} = p;

p = anova1(tr(gc), grp, 'off');
data{ROW_anova, COL_tonicChange} = p;

p = anova1(or(gc), grp, 'off');
data{ROW_anova, COL_imgoffChange} = p;


makeTable(data, rows, cols, 'output', outputFormat, 'fname', 'visRespSummary' );


cd /home/fpbatta/Data/amyphys
save VisualRespSummary ROW* COL* rows cols data 

fig_st = [];

fig = [];

mpr = [mean(pr(bgroup)); mean(pr(lgroup)); mean(pr(sigroup))];
mtr = [mean(tr(bgroup)); mean(tr(lgroup)); mean(tr(sigroup))];
mor = [mean(or(bgroup)); mean(or(lgroup)); mean(or(sigroup))];

fig.x = (1:3)';
fig.n = [mpr mtr mor];

fig.xTickLabel = {'phasic', 'tonic', 'image off'};
fig.figureType = 'hist';
fig.figureName = 'VisRespHist';

fig_st = { fig };
check_figure(fig_st, 1);




 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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
  




