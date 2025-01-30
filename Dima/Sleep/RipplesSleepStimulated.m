fh = figure('units','normalized', 'outerposition', [0 1 1 0.7]);

%% Remove 0V

G = find(~isnan(PosMat(:,4)));
int = PosMat(G,4);
idx_zerovolts = find(int==0);

St = Start(TTLInfo.StimEpoch);
En = End(TTLInfo.StimEpoch);
St(idx_zerovolts) = [];
En(idx_zerovolts) = [];
StimEpoch = intervalSet(St,En);
Stims = St;
%% Do
S = ts(ripples(:,2)*1E4);
center = ts(Start(StimEpoch));
TStart = -3E4;
TEnd = 3E4;

ripples12 = tsd(ripples(:,2)*1E4, ripples(:,2)*1E4);
is = intervalSet(Range(center)+TStart, Range(center)+TEnd);
sweeps = intervalSplit(S, is, 'OffsetStart', TStart);

fh = figure;
set(gca, 'FontWeight', 'bold');
set(gca, 'FontSize', 16);
RasterPlot(sweeps, 'FigureHandle', fh, 'TStart', TStart, 'TEnd', TEnd, 'LineWidth', 15);
xlim([-3000 3000]);
xlabel('Time (ms)')


figure,
[fh,sq,sweeps] = RasterPETH(ripples12, center, -100000, +100000,'BinSize',1000, 'LineWidth', 5);

title('Peri-stimulation ripples')