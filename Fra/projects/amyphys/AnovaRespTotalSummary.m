function AnovaRespSummary

outputFormat = 'html';
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

% get the general non-ANOVA related resources 

[A, cn] = getResource(A, 'AmygdalaCellList', datasets);
[A, bs_rate] = getResource(A, 'FRateBaseline', datasets);
[A, ac] = getResource(A, 'AnatomyData', datasets);
[A, ato] = getResource(A, 'AnovasTotal', datasets);
[A, ato4] = getResource(A, 'AnovasStimKind4Total', datasets);


% retrieve cell class of visual responsiveness 
cc = cell(size(cn));
icol = strmatch('CellClass', visSummaryCols);
for i = 1:length(cn)
    q = cn{i};
    q = q(1:end-4);
    q = strrep(q, '+', '\+');
    ix = ~cellfun('isempty', regexp( visSummaryCn, q));
    cc{i} = visSummary{ix, icol};
end


if strcmp(outputFormat, 'html')
    for i = 1:length(cn)
        [p,n,e] = fileparts(cn{i});
        cn{i} = makeHtmlLink(['Anovas/' n '_anovas.html'], n, 'OpenNewWindow', 1);
    end
end
% prepare table
rows = cn;
nrows = length(rows);

enum({'COL_baseRate',
      'COL_nucleus',
      'COL_cellClass', 
      'COL_totalKind',
      'COL_total2WayMonkey',
      'COL_total2WayExpr',
      'COL_total2WayInter',
    });

cols = {};

cols{COL_baseRate} = 'Baseline Rate';
cols{COL_nucleus} = 'Nucleus';
cols{COL_cellClass} = 'Vis. Resp. Class';
cols{COL_totalKind} = 'Total Stim. Kind';
cols{COL_total2WayMonkey} = 'Total Monkey';
cols{COL_total2WayExpr} = 'Total Expr';
cols{COL_total2WayInter} = 'Total Interaction';


ncols = length(cols);

data = cell(nrows, ncols);



data(:,COL_baseRate) = cellifyArray(bs_rate);
data(:,COL_cellClass) = cc;
data(:,COL_nucleus) = ac;
for i = 1:length(ato);

    L = ato4{i};
    atok(i) = L{'StimKind'};
end


atok = cellifyArray(atok);


if strcmp(outputFormat, 'html')
    for i = 1:length(ato)
       if str2num(atok{i}) < sign_thresh
            atok{i} = applyHtmlFormat(atok{i}, 'STRONG');
        end
     
    end
end
data(:, COL_totalKind) = atok;

atom = cell(size(cn));
atoe = cell(size(cn));
atoi = cell(size(cn));


for i = 1:length(ato);
    if has_key(ato{i}, '2WayExprId')
   
        L = ato{i};
        pto = L{'2WayExprId'};
      
       atom{i} = num2str(pto(1));
        atoe{i} = num2str(pto(2));
        atoi{i} = num2str(pto(3));
     
        
        
        if strcmp(outputFormat, 'html')
        
            if str2num(atom{i}) < sign_thresh
                atom{i} = applyHtmlFormat(atom{i}, 'STRONG');
            end
            if str2num(atoe{i}) < sign_thresh
                atoe{i} = applyHtmlFormat(atoe{i}, 'STRONG');
            end
            if str2num(atoi{i}) < sign_thresh
                atoi{i} = applyHtmlFormat(atoi{i}, 'STRONG');
            end
          
            
        end
        
    end
end
        

data(:,COL_total2WayMonkey) = atom;
data(:,COL_total2WayExpr) = atoe;
data(:,COL_total2WayInter) = atoi;


makeTable(data, rows, cols, 'output', outputFormat, ...
    'fname', 'AnovaRespTotalSummary');

