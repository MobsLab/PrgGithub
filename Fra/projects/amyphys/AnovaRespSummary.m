function AnovaRespSummary

outputFormat = 'html';
sign_thresh = 0.05;
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
[A, at] = getResource(A, 'AnovasTonic', datasets);
[A, ato] = getResource(A, 'AnovasTotal', datasets);
[A, af] = getResource(A, 'AnovasFixspot', datasets);
[A, ap] = getResource(A, 'AnovasPhasic', datasets);


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
      'COL_fixspotKind',
      'COL_phasicKind',
      'COL_tonicKind',
      'COL_total2WayMonkey',
      'COL_total2WayExpr',
      'COL_total2WayInter',
      'COL_fixspot2WayMonkey',
      'COL_fixspot2WayExpr',
      'COL_fixspot2WayInter',
      'COL_phasic2WayMonkey',
      'COL_phasic2WayExpr',
      'COL_phasic2WayInter',
      'COL_tonic2WayMonkey',
      'COL_tonic2WayExpr',
      'COL_tonic2WayInter',
    });

cols = {};

cols{COL_baseRate} = 'Baseline Rate';
cols{COL_nucleus} = 'Nucleus';
cols{COL_cellClass} = 'Vis. Resp. Class';
cols{COL_tonicKind} = 'Tonic Stim. Kind';
cols{COL_totalKind} = 'Total Stim. Kind';
cols{COL_phasicKind} = 'Phasic Stim. Kind';
cols{COL_fixspotKind} = 'FixSpot Stim. Kind';
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

ncols = length(cols);

data = cell(nrows, ncols);



data(:,COL_baseRate) = cellifyArray(bs_rate);
data(:,COL_cellClass) = cc;
data(:,COL_nucleus) = ac;
for i = 1:length(at);
    L = at{i};
    atk(i) = L{'StimKind'};
    L = ap{i};
    apk(i) = L{'StimKind'};
    L = af{i};
    afk(i) = L{'StimKind'};
    L = ato{i};
    atok(i) = L{'StimKind'};
end

atk = cellifyArray(atk);
atok = cellifyArray(atok);
apk = cellifyArray(apk);
afk = cellifyArray(afk);

if strcmp(outputFormat, 'html')
    for i = 1:length(at)
        if str2num(atk{i}) < sign_thresh
            atk{i} = applyHtmlFormat(atk{i}, 'STRONG');
        end
       if str2num(atok{i}) < sign_thresh
            atok{i} = applyHtmlFormat(atok{i}, 'STRONG');
        end
        if str2num(apk{i}) < sign_thresh
            apk{i} = applyHtmlFormat(apk{i}, 'STRONG');
        end
        if str2num(afk{i}) < sign_thresh
            afk{i} = applyHtmlFormat(afk{i}, 'STRONG');
        end
    end
end
data(:, COL_tonicKind) = atk;
data(:, COL_totalKind) = atok;
data(:, COL_phasicKind) = apk;
data(:, COL_fixspotKind) = afk;

atm = cell(size(cn));
ate = cell(size(cn));
ati = cell(size(cn));
atom = cell(size(cn));
atoe = cell(size(cn));
atoi = cell(size(cn));
apm = cell(size(cn));
ape = cell(size(cn));
api = cell(size(cn));
afm = cell(size(cn));
afe = cell(size(cn));
afi = cell(size(cn));

for i = 1:length(at);
    if has_key(at{i}, '2WayExprId')
        L = at{i};
        pt = L{'2WayExprId'};
		L = ap{i};
        pp = L{'2WayExprId'};
		L = af{i};
        pf = L{'2WayExprId'};
        L = ato{i};
        pto = L{'2WayExprId'};
        atm{i} = num2str(pt(1));
        ate{i} = num2str(pt(2));
        ati{i} = num2str(pt(3));
       atom{i} = num2str(pto(1));
        atoe{i} = num2str(pto(2));
        atoi{i} = num2str(pto(3));
         apm{i} = num2str(pp(1));
        ape{i} = num2str(pp(2));
        api{i} = num2str(pp(3));
        afm{i} = num2str(pf(1));
        afe{i} = num2str(pf(2));
        afi{i} = num2str(pf(3));
       
        
        
        if strcmp(outputFormat, 'html')
            if str2num(atm{i}) < sign_thresh
                atm{i} = applyHtmlFormat(atm{i}, 'STRONG');
            end
            if str2num(ate{i}) < sign_thresh
                ate{i} = applyHtmlFormat(ate{i}, 'STRONG');
            end
            if str2num(ati{i}) < sign_thresh
                ati{i} = applyHtmlFormat(ati{i}, 'STRONG');
            end
            if str2num(atom{i}) < sign_thresh
                atom{i} = applyHtmlFormat(atom{i}, 'STRONG');
            end
            if str2num(atoe{i}) < sign_thresh
                atoe{i} = applyHtmlFormat(atoe{i}, 'STRONG');
            end
            if str2num(atoi{i}) < sign_thresh
                atoi{i} = applyHtmlFormat(atoi{i}, 'STRONG');
            end
            if str2num(apm{i}) < sign_thresh
                apm{i} = applyHtmlFormat(apm{i}, 'STRONG');
            end
            if str2num(ape{i}) < sign_thresh
                ape{i} = applyHtmlFormat(ape{i}, 'STRONG');
            end
            if str2num(api{i}) < sign_thresh
                api{i} = applyHtmlFormat(api{i}, 'STRONG');
            end
            if str2num(afm{i}) < sign_thresh
                afm{i} = applyHtmlFormat(afm{i}, 'STRONG');
            end
            if str2num(afe{i}) < sign_thresh
                afe{i} = applyHtmlFormat(afe{i}, 'STRONG');
            end
            if str2num(afi{i}) < sign_thresh
                afi{i} = applyHtmlFormat(afi{i}, 'STRONG');
            end
            
        end
        
    end
end
        
data(:,COL_tonic2WayMonkey) = atm;
data(:,COL_tonic2WayExpr) = ate;
data(:,COL_tonic2WayInter) = ati;
data(:,COL_total2WayMonkey) = atom;
data(:,COL_total2WayExpr) = atoe;
data(:,COL_total2WayInter) = atoi;
data(:,COL_phasic2WayMonkey) = apm;
data(:,COL_phasic2WayExpr) = ape;
data(:,COL_phasic2WayInter) = api;
data(:,COL_fixspot2WayMonkey) = afm;
data(:,COL_fixspot2WayExpr) = afe;
data(:,COL_fixspot2WayInter) = afi;

makeTable(data, rows, cols, 'output', outputFormat, ...
    'fname', 'AnovaRespSummary');

