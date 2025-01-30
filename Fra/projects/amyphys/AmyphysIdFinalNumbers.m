m = getenv('HOME');

signThresh = 0.05;
parent_dir =  [hm filesep 'Data/amyphys'];
cd(parent_dir);


datasets = List2Cell([ parent_dir filesep 'datasets_amyphys.list' ] );

%

A = Analysis(parent_dir);
A = getResource(A, 'ExprSelective', datasets);
A = getResource(A, 'IdSelective', datasets);
A = getResource(A, 'InterSelective', datasets);

upMod = dictArray;
downMod = dictArray;
totCells = dictArray;
rateId = dictArray;

for i = 1:length(datasets)
    
    A = getResource(A, 'IsTwoWay', datasets{i});
    if isTwoWay(1)
        [A, ids] = getResource(A, 'IdSelective', datasets{i});
        [A, pval] = getResource(A, 'PostHocPvalId', datasets{i});
        [A, ud] = getResource(A, 'PostHocUpDownModulated', datasets{i});
        [A, ss] = getResource(A, 'StimSet', datasets{i});
        [A, ri] = getResource(A, 'RateId', datasets{i});
        ss = ss{1};
        
        if ~has_key(upMod, ss)
            upMod{ss} = zeros(size(pval{1}));
            downMod{ss} = zeros(size(pval{1}));
            rateId{ss} = zeros(0, length(pval{1}));
            totCells{ss} = 0;
        end
        
        for c = 1:length(ids)
            if ids(c) 
                um = upMod{ss};
                dm = downMod{ss};
                totCells{ss} = totCells{ss} + 1;
            
                um = um + (pval{c} < (0.05/length(pval{c})) .* (ud{c} > 0));
                dm = dm + (pval{c} < (0.05/length(pval{c})) .* (ud{c} < 0));
                rateId{ss} = [rateId{ss}; ri{c}];
                
            
                upMod{ss} = um;
                downMod{ss} = dm;
            end
        end
        
    
    end
end
 
fid = fopen('idPostHoc.txt', 'w');
 fprintf(fid, 'at significance level %g\n', signThresh);
  
  fprintf(fid, 'expression selective cells = %d; identity selective = %d; interaction selective cells = %d\n', ...
    sum(exprSelective), sum(idSelective), sum(interSelective));
       
 k = keys(totCells);
    
    for s = k
        ss = s{1};
        fprintf(fid, 'of the %d identity selective cells for stimulus set %s :\n\n', totCells{ss}, ss);
        um = upMod{ss};
        dm= downMod{ss};
        
        fprintf(fid, 'monkey\t\t');
        
        for i = 1:length(um)
            fprintf(fid, '%d\t', i);
        end
        fprintf(fid, '\n');
        fprintf(fid, 'up.mod.\t\t');
        
        for i = 1:length(um)
            fprintf(fid, '%d\t', um(i));
        end
        
        fprintf(fid, '\n');
        fprintf(fid, 'down.mod.\t');
        
        for i = 1:length(dm)
            fprintf(fid, '%d\t', dm(i));
        end
        
        [pval, chisq, df, ranks] = FriedmanAnova(rateId{ss});
        fprintf(fid, '\n\nFriedman ANOVA p = %g\n\n', pval);
        fprintf(fid, '\n\n\n---------------------------------------------------------\n');
    end
    