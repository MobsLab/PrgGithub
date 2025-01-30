function A = basicPETH(A)

fontSize = 12;
A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');
A = getResource(A,'GoodCells');
S = S(find(goodCells{1}));

A= getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = getResource(A, 'StartTrial');
startTrial = startTrial{1};

[success, message, messageid] = mkdir(parent_dir(A), 'PETHs');

pethdir = [parent_dir(A), filesep 'PETHs'];
[p,ds,e] = fileparts(current_dir(A));

r = Range(trialOutcome);
d = Data(trialOutcome);

st = Data(startTrial);

sr = st(d==0);
sl = st(d==1);

tr = r(d == 0);
tl = r(d==1);


for i = 1:length(S)

 figure(1), clf

    if length(sl) > 0
    [fh1, rasterAx1, histAx1] = RasterPETH(S{i}, ts(sl), -50000, 100000, ...
        'Markers', { subset(trialOutcome, find(d==1))} , 'MarkerTypes', {'r.' }, 'MarkerSize', 20, 'BinSize', 200);
    title([ ds '_' cellnames{i} ' left start '], 'interpreter', 'none', ...
        'FontSize', fontSize, 'FontName', 'Verdana');
    set(rasterAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx1, 'FontSize', fontSize, 'FontName', 'Verdana');

    xa = get(histAx1, 'ylim');
    y1 = xa(2);

    end;

    if length(sr) > 0

    figure(2), clf
    [fh2, rasterAx2, histAx2] = RasterPETH(S{i}, ts(sr), -50000, 100000, ...
        'Markers', { subset(trialOutcome, find(d==0))}, 'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);
    title([ ds '_' cellnames{i} ' right start '], 'interpreter', 'none', ...
        'FontSize', fontSize, 'FontName', 'Verdana');
    set(rasterAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
    set(histAx2, 'FontSize', fontSize, 'FontName', 'Verdana');

    xa = get(histAx2, 'ylim');
    y2 = xa(2);

    ymax = max(y1, y2);
    set(histAx1, 'ylim', [0 ymax]);
    set(histAx2, 'ylim', [0 ymax]);
    
    setSameAxisLim({rasterAx1, rasterAx2}, 'y');
    integerTicks(histAx1, 'y');
    integerTicks(histAx2, 'y');

    end

if length(sl)>0
    saveas(fh1, [pethdir filesep ds '_' cellnames{i} 'leftStartPETH'], 'png');
end
if length(sr)>0    
    saveas(fh2, [pethdir filesep ds '_' cellnames{i} 'rightStartPETH'], 'png');
end

%  
%      figure(1), clf
%      [fh1, rasterAx1, histAx1] = RasterPETH(S{i}, ts(tl), -100000, 50000, ...
%          'Markers', { subset(startTrial, find(d==1))} , 'MarkerTypes', {'r.' }, 'MarkerSize', 20, 'BinSize', 200);
%      title([ ds '_' cellnames{i} ' left end '], 'interpreter', 'none', ...
%          'FontSize', fontSize, 'FontName', 'Verdana');
%      set(rasterAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
%      set(histAx1, 'FontSize', fontSize, 'FontName', 'Verdana');
%  
%      xa = get(histAx1, 'ylim');
%      y1 = xa(2);
%  
%      figure(2), clf
%      [fh2, rasterAx2, histAx2] = RasterPETH(S{i}, ts(tr), -100000, 50000, ...
%          'Markers', { subset(startTrial, find(d==0))}, 'MarkerTypes',{ 'r.' }, 'MarkerSize', 20, 'BinSize', 200);
%      title([ ds '_' cellnames{i} ' right end '], 'interpreter', 'none', ...
%          'FontSize', fontSize, 'FontName', 'Verdana');
%      set(rasterAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
%      set(histAx2, 'FontSize', fontSize, 'FontName', 'Verdana');
%  
%      xa = get(histAx2, 'ylim');
%      y2 = xa(2);
%  
%      ymax = max(y1, y2);
%      set(histAx1, 'ylim', [0 ymax]);
%      set(histAx2, 'ylim', [0 ymax]);
%      
%      setSameAxisLim({rasterAx1, rasterAx2}, 'y');
%      integerTicks(histAx1, 'y');
%      integerTicks(histAx2, 'y');
%      saveas(fh1, [pethdir filesep ds '_' cellnames{i} 'leftOutcomePETH'], 'png');
%      saveas(fh2, [pethdir filesep ds '_' cellnames{i} 'rightOutcomePETH'], 'png');
%      
end

