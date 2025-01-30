function A = AllAnovas(A);


global ISTOTAL;


do_figures = false;
[A, cn] = getResource(A, 'AmygdalaCellList');
A = getResource(A, 'Experiment');
experiment = experiment{1};


A = getResource(A, 'VisualCountsTotal');


A = getResource(A, 'StimCode');

A = getResource(A, 'FRateBaseline');


load AmyphysLookupTables


A = registerResource(A, 'AnovasTotalSplit', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTotal', ...
		       ['a dictArray with all the anovas for the total period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session, it is split in the first and second part of the session']);
            
 A = registerResource(A, 'AnovasTableTotalSplit', 'cell', {'AmygdalaCellList', 1}, ...
		       'anovasTableTotal', ...
		       ['a dictArray with all the anova tables for the total period, ',...
                'the kind of anovas performed will depend on the experiment for that ',...
                'session, it is split in the first and second part of the session']);
            
 A = registerResource(A, 'SplitVisualTTest', 'numeric', {'AmygdalaCellList', 1}, ...
     'splitVisualTTest', ...
     ['test of visual responses in first and second half of session']);
 A = registerResource(A, 'SplitVisualRate', 'numeric', {'AmygdalaCellList', 2}, ...
     'splitVisualRate', ...
     ['firing rate in the first adn second half of session']);
 
% anova to be performed, per experiment:

% amyphys: monkey vs. object vs. human 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
%
% phys1: monkey vs. object vs. human vs. animal 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
%        Gaze Direct vs. Gaze Away 'Gaze'
% phys2: monkey vs. object vs. human. vs. animal 'StimKind'
%        monkey id/ expression (2-way) '2WayExprId'
% face:  n/a
% DandM: n/a
anovasTotal = cell(size(visCountsTotal));
anovasTableTotal = cell(size(visCountsTotal));
splitVisualTTest = zeros(size(visCountsTotal));
splitVisualRate = zeros([length(visCountsTotal), 2]);

global FIGURE_DIR;

FIGURE_DIR = [getenv('HOME') filesep 'Data' filesep 'amyphys' filesep 'HtmlStuff' filesep 'Anovas'];
%FIGURE_DIR = '';
for i = 1:length(visCountsTotal)
        totr = visCountsTotal{i};
        h = floor(length(totr)/2);
    sc = Data(stimCode{i});
    fig_st = {};
    close all
    global N_FIGURE;
    N_FIGURE = 1;
    [hh , splitVisualTTest(i), ci, stats] = ttest2(totr(1:h), totr((h+1):end));
    splitVisualRate(i,1) = mean(totr(1:h));
    splitVisualRate(i,2) = mean(totr((h+1):end));
    if splitVisualRate(i,2) < splitVisualRate(i,1)
        splitVisualTTest(i) = - splitVisualTTest(i);
    end
    
    
    aTO = dictArray;
    aTOT = dictArray;
   
    display(cn{i});

    
    switch(experiment)
        case 'amyphys'
            % get groups for StimKind anova
            kgroups = {'Monkey', 'Object', 'Human'};
            gr = getGroups(sc, Amyphys_StimLookup, kgroups);
          
            f = find(gr);
            f1 = f(find(f <= h));
            f2  = f(find(f > h));
            
            T1 = totr(f1);
            G1 = gr(f1);
            T2 = totr(f2);
            
            G2 = gr(f2);
          
            
              % total anova
            [p, table, stats] = anova1(T1,G1, 'off');
            aTO{'StimKind1'} = p;
            aTOT{'StimKind1'} = table;
       
              % total anova
            [p, table, stats] = anova1(T2,G2, 'off');
            aTO{'StimKind2'} = p;
            aTOT{'StimKind2'} = table;
       
    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Amyphys_StimLookup;
            
            T1 = totr(1:h);
            S1 = sc(1:h);
            T2 = totr((h+1):end);
            S2 = sc((h+1):end);
            
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T1, S1, kgroups, ...
                lookup, false);

            aTO{'2WayExprId1'} = p;
            aTOT{'2WayExprId1'} = table;
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T2, S2, kgroups, ...
                lookup, false);

            aTO{'2WayExprId2'} = p;
            aTOT{'2WayExprId2'} = table;


      
            
        case 'phys1'
            kgroups = {'Monkey', 'Object', 'Human', 'Animal'};
            gr = getGroups(sc, Phys1_StimLookup, kgroups);
            
            % get groups for StimKind anova
            f = find(gr);
            f1 = f(find(f <= h));
            f2  = f(find(f > h));
            
            T1 = totr(f1);
            G1 = gr(f1);
            T2 = totr(f2);
            G2 = gr(f2);
          
            
              % total anova
            [p, table, stats] = anova1(T1,G1, 'off');
            aTO{'StimKind1'} = p;
            aTOT{'StimKind1'} = table;
       
              % total anova
            [p, table, stats] = anova1(T2,G2, 'off');
            aTO{'StimKind2'} = p;
            aTOT{'StimKind2'} = table;
          
          
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Phys1_StimLookup;
            
              
            T1 = totr(1:h);
            S1 = sc(1:h);
            T2 = totr((h+1):end);
            S2 = sc((h+1):end);
            
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T1, S1, kgroups, ...
                lookup, false);

            aTO{'2WayExprId1'} = p;
            aTOT{'2WayExprId1'} = table;
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T2, S2, kgroups, ...
                lookup, false);

            aTO{'2WayExprId2'} = p;
            aTOT{'2WayExprId2'} = table;
         
            
        case 'phys2'
                        % get groups for StimKind anova
            kgroups = {'Monkey', 'Object', 'Human', 'Animal'};
            gr = getGroups(sc, Phys2_StimLookup, kgroups);
            
     % get groups for StimKind anova
            f = find(gr);
            f1 = f(find(f <= h));
            f2  = f(find(f > h));
            
            T1 = totr(f1);
            G1 = gr(f1);
            T2 = totr(f2);
            G2 = gr(f2);
          
            
              % total anova
            [p, table, stats] = anova1(T1,G1, 'off');
            aTO{'StimKind1'} = p;
            aTOT{'StimKind1'} = table;
       
              % total anova
            [p, table, stats] = anova1(T2,G2, 'off');
            aTO{'StimKind2'} = p;
            aTOT{'StimKind2'} = table;
          
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % the two way anova
            kgroups = {'Monkey', 'Expr'};
            lookup = Phys2_StimLookup;
 
               
            T1 = totr(1:h);
            S1 = sc(1:h);
            T2 = totr((h+1):end);
            S2 = sc((h+1):end);
            
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T1, S1, kgroups, ...
                lookup, false);

            aTO{'2WayExprId1'} = p;
            aTOT{'2WayExprId1'} = table;
            [p, table, fig_st, anovasMultCompareExpr{i}] = make2wayAnova(fig_st, T2, S2, kgroups, ...
                lookup, false);

            aTO{'2WayExprId2'} = p;
            aTOT{'2WayExprId2'} = table;
            
            
        case 'd&m'
            1;
            
        case 'face'
            1;
             
    end
    anovasTotal{i} = aTO;
    anovasTableTotal{i} = aTOT;
 
    
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
    
    if fname
        fig_st = make2wayHist(fig_st, tr, grm, levelKeys, fname);
    end
    
    
function makeAnovaTable(table, fname)

    data = table(2:end, 2:end);
    labelsRow = table(2:end,1);
    labelsColumn = table(1, 2:end);

    makeTable(data, labelsRow, labelsColumn, 'baretable', 1,  'fname', fname, ...
        'output', 'html');