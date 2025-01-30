function AnovaRespByNucleus

do_figures = 1:100;

outputFormat = 'excel';
sign_thresh = 0.0005;
hm = getenv('HOME');
parent_dir = [hm '/Data/amyphys'];
cd(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_2way.list' ] );

load VisualRespTable data cols cn
visSummary = data;
visSummaryCn = cn;
visSummaryCols = cols;


A = Analysis(parent_dir);


[A, cn] = getResource(A, 'AmygdalaCellList', datasets);
[A, bs_rate] = getResource(A, 'FRateBaseline', datasets);
[A, ac] = getResource(A, 'AnatomyData', datasets);
[A, at] = getResource(A, 'AnovasTonic', datasets);
[A, ato] = getResource(A, 'AnovasTotal', datasets);
[A, af] = getResource(A, 'AnovasFixspot', datasets);
[A, ap] = getResource(A, 'AnovasPhasic', datasets);
[A, monkey] = getResource(A, 'MonkeySubjectCell', datasets);
[A, doub] = getResource(A, 'IsDouble', datasets);

lgroup = intersect(strmatch('l', ac,'exact'),find(~doub));
blgroup = intersect(strmatch( 'bl', ac, 'exact'), find(~doub));
bgroup = intersect(strmatch( 'b', ac, 'exact'), find(~doub));
sigroup = intersect(strmatch( 'si', ac, 'exact'), find(~doub));
agroup = intersect(strmatch( 'a', ac, 'exact'), find(~doub));
mgroup = intersect(strmatch( 'm', ac, 'exact'), find(~doub));
cgroup = intersect(strmatch( 'c', ac, 'exact'), find(~doub));

sirloinGroup = intersect(find(monkey==0), find(~doub));
shriekerGroup = intersect(find(monkey==1), find(~doub));


enum({'ROW_lateral', 'ROW_basal', 'ROW_si', 'ROW_bl', 'ROW_accb', 'ROW_central', 'ROW_medial', 'ROW_sirloin', 'ROW_shrieker'});
rows{ROW_lateral} ='lateral';
rows{ROW_basal} = 'basal';
rows{ROW_si} = 'subst. inn.';
rows{ROW_bl} = 'bl';
rows{ROW_accb} = 'Acc. b';
rows{ROW_central} = 'Central';
rows{ROW_medial} = 'Medial';
rows{ROW_sirloin} = 'Sirloin';
rows{ROW_shrieker} = 'Shrieker';
nrows = length(rows);


enum({'COL_totCells',
      'COL_fixspotKind',
      'COL_fixspotKindPercent',
      'COL_phasicKind',
      'COL_phasicKindPercent',
      'COL_tonicKind',
      'COL_tonicKindPercent',
       'COL_totalKind',
      'COL_totalKindPercent',
     'COL_fixspot2WayMonkey',
      'COL_fixspot2WayMonkeyPercent',
      'COL_fixspot2WayExpr',
      'COL_fixspot2WayExprPercent',
      'COL_fixspot2WayInter',
      'COL_fixspot2WayInterPercent',
      'COL_phasic2WayMonkey',
      'COL_phasic2WayMonkeyPercent',
      'COL_phasic2WayExpr',
      'COL_phasic2WayExprPercent',
      'COL_phasic2WayInter',
      'COL_phasic2WayInterPercent',
      'COL_tonic2WayMonkey',
      'COL_tonic2WayMonkeyPercent',
      'COL_tonic2WayExpr',
      'COL_tonic2WayExprPercent',
      'COL_tonic2WayInter',
      'COL_tonic2WayInterPercent',
      'COL_total2WayMonkey',
      'COL_total2WayMonkeyPercent',
      'COL_total2WayExpr',
      'COL_total2WayExprPercent',
      'COL_total2WayInter',
      'COL_total2WayInterPercent',
    });

cols = {};


cols{COL_tonicKind} = 'Tonic Stim. Kind';
cols{COL_phasicKind} = 'Phasic Stim. Kind';
cols{COL_fixspotKind} = 'FixSpot Stim. Kind';
cols{COL_totalKind} = 'Total Stim. Kind';

cols{COL_phasic2WayMonkey} = 'Phasic Monkey';
cols{COL_phasic2WayExpr} = 'Phasic Expr';
cols{COL_phasic2WayInter} = 'Phasic Interaction';
cols{COL_tonic2WayMonkey} = 'Tonic Monkey';
cols{COL_tonic2WayExpr} = 'Tonic Expr';
cols{COL_tonic2WayInter} = 'Tonic Interaction';
cols{COL_total2WayMonkey} = 'Total Monkey';
cols{COL_total2WayExpr} = 'Total Expr';
cols{COL_total2WayInter} = 'Total Interaction';
cols{COL_fixspot2WayMonkey} = 'Fixspot Monkey';
cols{COL_fixspot2WayExpr} = 'Fixspot Expr';
cols{COL_fixspot2WayInter} = 'Fixspot Interaction';

cols{COL_tonicKindPercent} = '%';
cols{COL_totalKindPercent} = '%';
cols{COL_phasicKindPercent} = '%';
cols{COL_fixspotKindPercent} = '%';
cols{COL_phasic2WayMonkeyPercent} = '%';
cols{COL_phasic2WayExprPercent} = '%';
cols{COL_phasic2WayInterPercent} = '%';
cols{COL_tonic2WayMonkeyPercent} = '%';
cols{COL_tonic2WayExprPercent} = '%';
cols{COL_tonic2WayInterPercent} = '%';
cols{COL_total2WayMonkeyPercent} = '%';
cols{COL_total2WayExprPercent} = '%';
cols{COL_total2WayInterPercent} = '%';
cols{COL_fixspot2WayMonkeyPercent} = '%';
cols{COL_fixspot2WayExprPercent} = '%';
cols{COL_fixspot2WayInterPercent} = '%';



ncols = length(cols);


data = cell(nrows, ncols);

data{ROW_lateral, COL_totCells} = length(lgroup);
data{ROW_basal, COL_totCells} = length(bgroup);
data{ROW_si, COL_totCells} = length(sigroup);
data{ROW_bl, COL_totCells} = length(blgroup);
data{ROW_medial, COL_totCells} = length(mgroup);
data{ROW_central, COL_totCells} = length(cgroup);
data{ROW_accb, COL_totCells} = length(agroup);


data{ROW_sirloin, COL_totCells} = length(sirloinGroup);
data{ROW_shrieker, COL_totCells} = length(shriekerGroup);

anovaDict = dictarray;
anovaDict{'phasic'} = ap;
anovaDict{'fixspot'} = af;
anovaDict{'tonic'} = at;
anovaDict{'total'} = ato;


rowGroup = dictArray;
rowGroup{'ROW_lateral'} = lgroup;
rowGroup{'ROW_basal'} = bgroup;
rowGroup{'ROW_si'} = sigroup;
rowGroup{'ROW_bl'} = blgroup;
rowGroup{'ROW_accb'} = agroup;
rowGroup{'ROW_medial'} = mgroup;
rowGroup{'ROW_central'} = cgroup;
rowGroup{'ROW_sirloin'} = sirloinGroup;
rowGroup{'ROW_shrieker'} = shriekerGroup;

theCols  ={     
      'COL_fixspotKind',
      'COL_phasicKind',
      'COL_tonicKind',
      'COL_totalKind',
      'COL_fixspot2WayMonkey',
      'COL_fixspot2WayExpr',
      'COL_fixspot2WayInter',
      'COL_phasic2WayMonkey',
      'COL_phasic2WayExpr',
      'COL_phasic2WayInter',
      'COL_tonic2WayMonkey',
      'COL_tonic2WayExpr',
      'COL_tonic2WayInter',
      'COL_total2WayMonkey',
      'COL_total2WayExpr',
      'COL_total2WayInter'};
  
      
theRows = keys(rowGroup);


for r = 1:length(theRows)
    for c = 1:length(theCols)
        if findstr( 'fixspot', theCols{c})
            epoch = 'fixspot';
        elseif findstr('phasic', theCols{c})
            epoch = 'phasic';
        elseif findstr('tonic', theCols{c})
            epoch = 'tonic';
        elseif findstr('total', theCols{c})
            epoch = 'total';
        else
            error('What the Hell?');
        end
        
        ix = findstr(theCols{c}, epoch) + length(epoch);
        anv = theCols{c}(ix:end);
        
        [n, percent] = extractNSignCells(anovaDict{epoch}, anv, ...
                                        rowGroup{theRows{r} }, sign_thresh);
        eval(['data{' theRows{r} ',' theCols{c} '} = n;']);
        eval(['data{' theRows{r} ',' theCols{c} 'Percent} = percent;']);        
    end
end
makeTable(data, rows, cols, 'output', outputFormat, 'fname', 'AnovaRespByNucleus' );
       

% make histogram figures 
pcRowsStr = {'ROW_lateral', 'ROW_basal', 'ROW_si'};
for i = 1:length(pcRowsStr)
    eval(['pcRows(i) = ' pcRowsStr{i} ';']);
end


% histogram for stimKind Phasic

colHist = [COL_phasicKindPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(pcRows))';
fig.n = d;
fig.figureType = 'hist';
fig.figureName = 'AmyphysPhasicByKindHist';
fig.yLim = [0 35];
fig.xTickLabel = {'lateral', 'basal', 's.i.'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,1);

    
      % histogram for 2way Phasic

colHist = [COL_phasic2WayMonkeyPercent, ...
      COL_phasic2WayExprPercent, ...
      COL_phasic2WayInterPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(colHist))';
fig.n = d';
fig.figureType = 'hist';
fig.figureName = 'AmyphysPhasic2wayHist';
fig.yLim = [0 25];
fig.xTickLabel = {'Monkey', 'Expr', 'Interaction'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,2);


% histogram for stimKind tonic

colHist = [COL_tonicKindPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(pcRows))';
fig.n = d;
fig.figureType = 'hist';
fig.figureName = 'AmyphysTonicByKindHist';
fig.yLim = [0 35];
fig.xTickLabel = {'lateral', 'basal', 's.i.'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,3);


    
      % histogram for 2way tonic

colHist = [COL_tonic2WayMonkeyPercent, ...
      COL_tonic2WayExprPercent,...
      COL_tonic2WayInterPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(colHist))';
fig.n = d';
fig.figureType = 'hist';
fig.figureName = 'AmyphysTonic2wayHist';
fig.yLim = [0 25];
fig.xTickLabel = {'Monkey', 'Expr', 'Interaction'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,4);

% histogram for stimKind total

colHist = [COL_totalKindPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(pcRows))';
fig.n = d;
fig.figureType = 'hist';
fig.figureName = 'AmyphysTotalByKindHist';
fig.yLim = [0 35];
fig.xTickLabel = {'lateral', 'basal', 's.i.'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,5);


    
      % histogram for 2way total

colHist = [COL_total2WayMonkeyPercent, ...
      COL_total2WayExprPercent,...
      COL_total2WayInterPercent],

d = arrayfyCell(data(pcRows, colHist));
fig_st = {};
fig = [];
fig.x = (1:length(colHist))';
fig.n = d';
fig.figureType = 'hist';
fig.figureName = 'AmyphysTotal2wayHist';
fig.yLim = [0 25];
fig.xTickLabel = {'Monkey', 'Expr', 'Interaction'};
fig_st = [fig_st { fig } ];

check_figure(fig_st,6);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function a =  arrayfyCell(c)

    a = zeros(size(c));
    
    for i = 1:numel(c)
        a(i) = double(c{i});
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a =  arrayfyCell(c)

    a = zeros(size(c));
    
    for i = 1:numel(c)
        a(i) = double(c{i});
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [n, percent] = extractNSignCells(data, theAnova, group, sign_thresh)     


    factor_ix = dictArray;
    factor_ix{'Monkey'} = 1;
    factor_ix{'Expr'} = 2;
    factor_ix{'Inter'} = 3;
    
    length(group);
    if strmatch('2Way', theAnova)
        np = 0;
        for i = 1:length(group)
            
            dd = data{group(i)};
            if ~has_key(dd, '2WayExprId')
                continue
            end
            
            dd = dd{'2WayExprId'};
            factor = factor_ix{theAnova(5:end)};
            np = np+1;
            pval(np) = dd(factor);
            
        end
    else
        for i = 1:length(group) 
            dd = data{group(i)};
            dd = dd{'StimKind'};
            pval(i) = dd;
        end
        np = length(group);
    end
    
    n = sum(pval < sign_thresh);
    percent = 100 * n/np;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
 function h = date_tag()
  
  c = clock;
  h = [datestr(clock, 29) '_' datestr(clock, 13)];
  h(find(h == ':')) = '-';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function check_figure(fh, nf);
  
  global N_FIGURE
  df = evalin('caller', 'do_figures');
  
  if ismember(nf, df)
    N_FIGURE = nf;
    makeFigure(fh);
  end
  
