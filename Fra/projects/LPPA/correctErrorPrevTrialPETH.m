function A = correctErrorPrevTrialPETH(A)

fontSize = 12;
A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');

A= getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = getResource(A, 'StartTrial');
startTrial = startTrial{1};

A = getResource(A, 'CorrectError');
correctError = correctError{1};

[success, message, messageid] = mkdir(parent_dir(A), 'PETHs');

pethdir = [parent_dir(A), filesep 'PETHs'];
[p,ds,e] = fileparts(current_dir(A));

ce = Data(correctError);

correctTrials = find(ce==1)+1;
correctTrials = correctTrials(find(correctTrials <= length(ce)));
errorTrials = find(ce ==0)+1;
errorTrials = errorTrials(find(errorTrials <= length(ce)));

for i = 1:length(S)

    figure(1), clf

    [fh1, rasterAx1, histAx1] = RasterPETH(S{i}, subset(startTrial, correctTrials), -50000, 100000, ...
        'Markers', {subset(trialOutcome, correctTrials)} , ...
        'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);

    title([cellnames{i} ' start previous correct'], 'FontSize', fontSize, 'FontName', 'Verdana', 'interpreter', 'none');
    set(rasterAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx1, 'FontSize', fontSize, 'FontName', 'Verdana');

    figure(2), clf

    [fh2, rasterAx2, histAx2] = RasterPETH(S{i}, subset(startTrial, errorTrials), -50000, 100000, ...
        'Markers', {subset(trialOutcome, errorTrials)}, ...
        'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);

    title([cellnames{i} ' start previous error'], 'FontSize', fontSize, 'FontName', 'Verdana', 'interpreter', 'none');
    set(rasterAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx2, 'FontSize', fontSize, 'FontName', 'Verdana');

    xa = get(histAx1, 'ylim');
    y1 = xa(2);
    xa = get(histAx2, 'ylim');
    y2 = xa(2);
    integerTicks(histAx1, 'y');
    integerTicks(histAx2, 'y');


    ymax = max(y1, y2);
    setSameAxisLim({rasterAx1, rasterAx2}, 'y');
    set(histAx1, 'ylim', [0 ymax]);
    set(histAx2, 'ylim', [0 ymax]);


    integerTicks(histAx1, 'y');
    integerTicks(histAx2, 'y');

    saveas(fh1, [pethdir filesep ds '_' cellnames{i} 'startCorrectPrevPETH'], 'png');
    saveas(fh2, [pethdir filesep ds '_' cellnames{i} 'startErrorPrevPETH'], 'png');
    
    figure(1), clf
    
    [fh1, rasterAx1, histAx1] = RasterPETH(S{i}, subset(trialOutcome, correctTrials), -100000, 50000, ...
        'Markers', { subset(startTrial, correctTrials) }, ...
        'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);

    
    title([cellnames{i} ' end previous correct'], 'FontSize', fontSize, 'FontName', 'Verdana', 'interpreter', 'none');
    set(rasterAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
    
    figure(2), clf

    [fh2, rasterAx2, histAx2] = RasterPETH(S{i}, subset(trialOutcome, errorTrials), -100000, 50000, ...
        'Markers', { subset(startTrial, errorTrials) } , ...
        'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);

    title([cellnames{i} ' end previous error'], 'FontSize', fontSize, 'FontName', 'Verdana', 'interpreter', 'none');
    set(rasterAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
    xa = get(histAx1, 'ylim');
    y1 = xa(2);
    xa = get(histAx2, 'ylim');
    y2 = xa(2);
    
    ymax = max(y1, y2);
    set(histAx1, 'ylim', [0 ymax]);
    set(histAx2, 'ylim', [0 ymax]);
    setSameAxisLim({rasterAx1, rasterAx2}, 'y');
    
    integerTicks(histAx1, 'y');
    integerTicks(histAx2, 'y');

    saveas(fh1, [pethdir filesep ds '_' cellnames{i} 'endCorrectPrevPETH'], 'png');
    saveas(fh2, [pethdir filesep ds '_' cellnames{i} 'endErrorPrevPETH'], 'png');
    
  

end

