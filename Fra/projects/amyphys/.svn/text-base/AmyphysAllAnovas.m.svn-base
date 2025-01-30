function A = AllAnovas(A);


global ISTOTAL;


do_figures = false;
[A, cn] = getResource(A, 'AmygdalaCellList');
A = getResource(A, 'Experiment');
experiment = experiment{1};

A = getResource(A, 'VisualCountsTonic');

A = getResource(A, 'VisualCountsTotal');

A = getResource(A, 'VisualCountsPhasic');

A = getResource(A, 'FixCountsFastPhasic');

A = getResource(A, 'StimCode');

A = getResource(A, 'FRateBaseline');


load AmyphysLookupTables

A = registerResource(A, 'AnovasPhasic', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasPhasic', ...
		       ['a dictArray with all the anovas for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
A = registerResource(A, 'AnovasTablePhasic', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTablePhasic', ...
		       ['a dictArray with all the anova tables for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
      
                
 A = registerResource(A, 'AnovasTonic', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTonic', ...
		       ['a dictArray with all the anovas for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
             A = registerResource(A, 'AnovasTableTonic', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTableTonic', ...
		       ['a dictArray with all the anova tables for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
      
A = registerResource(A, 'AnovasTotal', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTotal', ...
		       ['a dictArray with all the anovas for the total period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
            
 A = registerResource(A, 'AnovasTableTotal', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTableTotal', ...
		       ['a dictArray with all the anova tables for the total period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
            
 A = registerResource(A, 'AnovasFixspot', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasFixspot', ...
		       ['a dictArray with all the anovas for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
            
 A = registerResource(A, 'AnovasTableFixspot', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTableFixspot', ...
		       ['a dictArray with all the anova tables for the phasic period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session']);
                    
                
 A = registerResource(A, 'AnovasMultCompareExpr', 'cell', {'AmygdalaCellList', 1}, ...
     'anovasMultCompareExpr', ...
     ['the multcompare matrix for  all the expression comparison, use only those that gave a significant anova']);
 
% anova to be performed, per experiment:

% amyphys: monkey vs. object vs. human 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
%
% phys1: monkey vs. object vs. human vs. animal 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
%        Gaze Direct vs. Gaze Away 'Gaze'
% phys2: monkey vs. object vs. human. vs. animal 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
% face:  Fullbody/Face 'Expr'
% DandM: Monkey vs. Dog 
anovasTotal = cell(size(visCountsTotal));
anovasTableTotal = cell(size(visCountsTotal));
anovasTonic = cell(size(visCountsTonic));
anovasTableTonic = cell(size(visCountsTonic));
anovasPhasic = cell(size(visCountsTonic));
anovasTablePhasic = cell(size(visCountsTonic));
anovasFixspot = cell(size(visCountsTonic));
anovasTableFixspot = cell(size(visCountsTonic));
anovasMultCompareExpr = cell(size(visCountsTonic));
global FIGURE_DIR;

FIGURE_DIR = [getenv('HOME') filesep 'Data' filesep 'amyphys' filesep 'HtmlStuff' filesep 'Anovas'];
%FIGURE_DIR = '';
for i = 1:length(visCountsTonic)
    tr = visCountsTonic{i};
        totr = visCountsTotal{i};

    pr = visCountsPhasic{i};
    fr = fixCountsFastPhasic{i};
    sc = Data(stimCode{i});
    anovasMultCompareExpr{i} = [];
    fig_st = {};
    close all
    global N_FIGURE;
    N_FIGURE = 1;
    
    aTO = dictArray;
    aTOT = dictArray;
    aT=  dictArray;
    aTT=  dictArray;
    aP=  dictArray;
    aTP=  dictArray;
    aF=  dictArray;
    aTF=  dictArray;

    display(cn{i});

    switch(experiment)
        case 'amyphys'
            % get groups for StimKind anova
            if findstr(cn{i}, 'slap0521_phys3_ch11_1+2')
                1;
            end
            
            kgroups = {'Monkey', 'Object', 'Human'};
            gr = getGroups(sc, Amyphys_StimLookup, kgroups);
            
              % total anova
            [p, table, stats] = anova1(totr(find(gr)), gr(find(gr)), 'off');
            aTO{'StimKind'} = p;
            aTOT{'StimKind'} = table;
            fname = '_StimKind_Total';
            fig_st = make1wayHist(fig_st, totr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
         

            % tonic anova
            [p, table, stats] = anoqq   va1(tr(find(gr)), gr(find(gr)), 'off');
            aT{'StimKind'} = p;
            aTT{'StimKind'} = table;
            fname = '_StimKind_Tonic';
            fig_st = make1wayHist(fig_st, tr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            
            %phasic anova
            [p, table, stats] = anova1(pr(find(gr)), gr(find(gr)), 'off');
            aP{'StimKind'} = p;
            aTP{'StimKind'} = table;
            fname = '_StimKind_Phasic';
            fig_st = make1wayHist(fig_st, pr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            %fixspot anova
            [p, table, stats] = anova1(fr(find(gr)), gr(find(gr)), 'off');
            aF{'StimKind'} = p;
            aTF{'StimKind'} = table;
           
            fname = '_StimKind_Fixspot ';
            fig_st = make1wayHist(fig_st, fr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            fig_st = {};
            close all
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Amyphys_StimLookup;
            
            fname = '_2WayExprId_Total';
            
            
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, totr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aTO{'2WayExprId'} = p;
            aTOT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            fname = '_2WayExprId_Tonic';
            [p, table, fig_st] = make2wayAnova(fig_st, tr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aT{'2WayExprId'} = p;
            aTT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            fname = '_2WayExprId_Phasic';
            [p, table, fig_st] = make2wayAnova(fig_st, pr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aP{'2WayExprId'} = p;
            aTP{'2WayExprId'} = table; 
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            fname = '_2WayExprId_Fixspot';
            [p, table, fig_st] = make2wayAnova(fig_st, fr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aF{'2WayExprId'} = p;
            aTF{'2WayExprId'} = table; 
            makeAnovaTable(table, [ FIGURE_DIR filesep cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            
            
        case 'phys1'
            % get groups for StimKind anova
            kgroups = {'Monkey', 'Object', 'Human', 'Animal'};
            gr = getGroups(sc, Phys1_StimLookup, kgroups);
            
            [p, table, stats] = anova1(totr(find(gr)), gr(find(gr)), 'off');
            aTO{'StimKind'} = p;
            aTOT{'StimKind'} = table;
            fname = '_StimKind_Total';
            fig_st = make1wayHist(fig_st, totr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [ cn{i} fname]);

            [p, table, stats] = anova1(tr(find(gr)), gr(find(gr)), 'off');
            aT{'StimKind'} = p;
            aTT{'StimKind'} = table;
            fname = '_StimKind_Tonic';
            fig_st = make1wayHist(fig_st, tr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [ cn{i} fname]);

            
            %phasic anova
            [p, table, stats] = anova1(pr(find(gr)), gr(find(gr)), 'off');
            aP{'StimKind'} = p;
            aTP{'StimKind'} = table;
            fname = '_StimKind_Phasic';
            fig_st = make1wayHist(fig_st, pr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [ cn{i} fname]);
            
            %fixspot anova
            [p, table, stats] = anova1(fr(find(gr)), gr(find(gr)), 'off');
            aF{'StimKind'} = p;
            aTF{'StimKind'} = table;
           
            fname = '_StimKind_Fixspot';
            fig_st = make1wayHist(fig_st, fr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            
            fig_st = {};
            close all
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Phys1_StimLookup;
            
            fname = '_2WayExprId_Total';
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, totr, sc, kgroups, ...
                lookup, [cn{i} fname]);
    
            aTO{'2WayExprId'} = p;
            aTOT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            fname = '_2WayExprId_Tonic';
            [p, table, fig_st] = make2wayAnova(fig_st, tr, sc, kgroups, ...
                lookup, [cn{i} fname]);
    
            aT{'2WayExprId'} = p;
            aTT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            fname = '_2WayExprId_Phasic';
            [p, table, fig_st] = make2wayAnova(fig_st, pr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aP{'2WayExprId'} = p;
            aTP{'2WayExprId'} = table; 
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            fname = '_2WayExprId_Fixspot';
            [p, table, fig_st] = make2wayAnova(fig_st, fr, sc, kgroups, ...
                lookup, [cn{i} fname]);
    
            aF{'2WayExprId'} = p;
            aTF{'2WayExprId'} = table; 
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            if do_figures
                makeFigure(fig_st);
            end
            
        case 'phys2'
                        % get groups for StimKind anova
            kgroups = {'Monkey', 'Object', 'Human', 'Animal'};
            gr = getGroups(sc, Phys2_StimLookup, kgroups);
            
            
            [p, table, stats] = anova1(totr(find(gr)), gr(find(gr)), 'off');
            aTO{'StimKind'} = p;
            aTOT{'StimKind'} = table;
            fname = '_StimKind_Total';
            fig_st = make1wayHist(fig_st, totr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            [p, table, stats] = anova1(tr(find(gr)), gr(find(gr)), 'off');
            aT{'StimKind'} = p;
            aTT{'StimKind'} = table;
            fname = '_StimKind_Tonic';
            fig_st = make1wayHist(fig_st, tr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            
            %phasic anova
            [p, table, stats] = anova1(pr(find(gr)), gr(find(gr)), 'off');
            aP{'StimKind'} = p;
            aTP{'StimKind'} = table;
            fname = '_StimKind_Phasic';
            fig_st = make1wayHist(fig_st, pr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            %fixspot anova
            [p, table, stats] = anova1(fr(find(gr)), gr(find(gr)), 'off');
            aF{'StimKind'} = p;
            aTF{'StimKind'} = table;
           
            fname = '_StimKind_Fixspot';
            fig_st = make1wayHist(fig_st, fr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            
            fig_st = {};
            close all
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Phys2_StimLookup;
 
            fname = '_2WayExprId_Total';
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, totr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aTO{'2WayExprId'} = p;
            aTOT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
           
            fname = '_2WayExprId_Tonic';
            [p, table, fig_st] = make2wayAnova(fig_st, tr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aT{'2WayExprId'} = p;
            aTT{'2WayExprId'} = table;
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            fname = '_2WayExprId_Phasic';
            [p, table, fig_st] = make2wayAnova(fig_st, pr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aP{'2WayExprId'} = p;
            aTP{'2WayExprId'} = table; 
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            fname = '_2WayExprId_Fixspot';
            [p, table, fig_st] = make2wayAnova(fig_st, fr, sc, kgroups, ...
                lookup, [ cn{i} fname]);
    
            aF{'2WayExprId'} = p;
            aTF{'2WayExprId'} = table; 
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            if do_figures
                makeFigure(fig_st);
            end
            
            
        case 'd&m'
                                  % get groups for StimKind anova
            kgroups = {'Monkey', 'Dog'};
            gr = getGroups(sc, DandM_StimLookup, kgroups);
            
            [p, table, stats] = anova1(totr(find(gr)), gr(find(gr)), 'off');
            aTO{'StimKind'} = p;
            aTOT{'StimKind'} = table;
            fname = '_StimKind_Total';
            fig_st = make1wayHist(fig_st, totr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            [p, table, stats] = anova1(tr(find(gr)), gr(find(gr)), 'off');
            aT{'StimKind'} = p;
            aTT{'StimKind'} = table;
            fname = '_StimKind_Tonic';
            fig_st = make1wayHist(fig_st, tr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            
            %phasic anova
            [p, table, stats] = anova1(pr(find(gr)), gr(find(gr)), 'off');
            aP{'StimKind'} = p;
            aTP{'StimKind'} = table;
            fname = '_StimKind_Phasic';
            fig_st = make1wayHist(fig_st, pr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            %fixspot anova
            [p, table, stats] = anova1(fr(find(gr)), gr(find(gr)), 'off');
            aF{'StimKind'} = p;
            aTF{'StimKind'} = table;
           
            fname = '_StimKind_Fixspot';
            fig_st = make1wayHist(fig_st, fr, gr, kgroups, [cn{i} fname]);
            makeAnovaTable(table, [ cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            
            fig_st = {};
            close all
            
        case 'face'
            kgroups = {'Expr Fullbody', 'Expr Faces'};
            gr = getGroups(sc, Face_StimLookup, kgroups);
            
            [p, table, stats] = anova1(totr(find(gr)), gr(find(gr)), 'off');
            aTO{'StimKind'} = p;
            aTOT{'StimKind'} = table;
            fname = '_StimKind_Total';
            fig_st = make1wayHist(fig_st, totr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            
            [p, table, stats] = anova1(tr(find(gr)), gr(find(gr)), 'off');
            aT{'StimKind'} = p;
            aTT{'StimKind'} = table;
            fname = '_StimKind_Tonic';
            fig_st = make1wayHist(fig_st, tr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);

            
            %phasic anova
            [p, table, stats] = anova1(pr(find(gr)), gr(find(gr)), 'off');
            aP{'StimKind'} = p;
            aTP{'StimKind'} = table;
            fname = '_StimKind_Phasic';
            fig_st = make1wayHist(fig_st, pr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            %fixspot anova
            [p, table, stats] = anova1(fr(find(gr)), gr(find(gr)), 'off');
            aF{'StimKind'} = p;
            aTF{'StimKind'} = table;
           
            fname = '_StimKind_Fixspot';
            fig_st = make1wayHist(fig_st, fr, gr, kgroups, [ cn{i} fname]);
            makeAnovaTable(table, [FIGURE_DIR filesep cn{i} fname]);
            
            if do_figures
                makeFigure(fig_st);
            end
            
            fig_st = {};
            close all
   
    
             
    end
    anovasTotal{i} = aTO;
    anovasTableTotal{i} = aTOT;
 
    anovasTonic{i} = aT;
    anovasTableTonic{i} = aTT;
    anovasPhasic{i} = aP;
    anovasTablePhasic{i} = aTP;
    anovasFixspot{i} = aF;
    anovasTableFixspot{i} = aTF;
    
end

A = saveAllResources(A);



function gr = getGroups(sc, dict, kgroups)
    gr = zeros(size(sc));
    k = keys(dict);

    for i = 1:length(kgroups)
        ks = strmatch(kgroups{i}, k);
        ks = k(ks);
        kstims{i} = getStims(dict, ks);
        gr(ismember(sc, kstims{i})) = i;

    end
    
    return 

    
function [grm, levelKeys] = getMultiGroups(sc, dict, kgroups)
    
    grm = cell(1, length(kgroups));
    k = keys(dict); % all the keys
    
    
    for g = 1:length(kgroups) % each item in kroups is a level
        gr = zeros(size(sc));
        ks = strmatch(kgroups{g}, k); % indices to all the keys for that
                                      % level
        sgroups = k(ks);
        levelKeys{g} = sgroups;
        for i = 1:length(sgroups)
            sstims = dict{ (sgroups{i}) };
            gr(ismember(sc, sstims)) = i;
        end
        
        grm{g} = gr;
    end
    
        
        
    
function stims = getStims(dict, ks)
    stims = [];
    for i = 1:length(ks);
        stims = [stims dict{ (ks{i}) }];
    end
    
    
    return
    

function fig_st = make1wayHist(fig_st, tr, gr, kgroups, fname)

    fig = [];
    e =[];
    y = [];
    for g = 1:length(kgroups)
        y(g) = mean(tr(gr == g));
        e(g) = sem(tr(gr == g));
    end
    %e = { e(:) };
    fig.xTickLabel = kgroups;
    fig.figureType = 'histerror';
    fig.x = 1:length(kgroups);
    fig.n = y(:);
    fig.e = e(:);
    fig.figureName = fname;
    fig_st = [fig_st {  fig }];
   
function fig_st = make2wayHist(fig_st, tr, grm, levelKeys, fname)


    % make histogram
    fig = [];
    e =[];
    y = [];
    for g = 1:length(levelKeys{1})
        for j = 1:length(levelKeys{2})
            y(g,j) = mean(tr(grm{1} == g & grm{2} == j));
            e(g,j) = sem(tr(grm{1} == g & grm{2} == j));
        end

    end
    
    for l = 1:length(levelKeys{1});
        xtl{l} = ['M ' num2str(l)];
    end
    
    fig.xTickLabel = xtl;
    fig.legend = levelKeys{2};
    fig.figureType = 'histerror';
    fig.x = 1:length(levelKeys{1});
    fig.n = y;
    fig.e = e;
    fig.figureName = fname;
    fig.position = [241   479   679   420];
    fig_st = [fig_st {  fig }];
    

      
    
function [p, table, fig_st, c] = make2wayAnova(fig_st, tr, sc, kgroups, lookup, fname)

    [grm, levelKeys] = getMultiGroups(sc, lookup, kgroups);
    gz = ones(size(grm{1}));

    for i = 1:length(grm)
        gz = gz .* grm{i};
    end
    gz = find(gz);

    for i = 1:length(grm)
        gp = grm{i};
        gp = gp(gz);
        grm{i} = gp;
    end

    tr = tr(gz);
    
    [p, table, stats] = anovan(tr, grm, ...
        'varnames', kgroups, ...
        'display', 'off', ...
        'model', 'interaction');

    if nargout == 4
        c = multcompare(stats, 'dimension', 2, 'alpha', 0.05, 'display', 'off');
        
    end
    
    fig_st = make2wayHist(fig_st, tr, grm, levelKeys, fname);

    
    
function makeAnovaTable(table, fname)

    data = table(2:end, 2:end);
    labelsRow = table(2:end,1);
    labelsColumn = table(1, 2:end);

    makeTable(data, labelsRow, labelsColumn, 'baretable', 1,  'fname', fname, ...
        'output', 'html');