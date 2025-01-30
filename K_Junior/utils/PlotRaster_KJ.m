function PlotRaster_KJ()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
load('newDeltaPFCx.mat')
load('SpikeData.mat')
load('DeltaSleepEvent.mat', 'TONEtime2')

cells = 2:length(S) ;
St = PoolNeurons(S, cells);

%params
durations = [-1500 300]/1000;
center = ts(TONEtime2(50));

figure, [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH(St, center, TStart, TEnd,);
figure, [fh,sq,sweeps] = RasterPETH(St, center, -15000,+15000,'BinSize',10);

for i=2:length(S);
    figure, [fh, sq{i,1}, sweeps{i,1}, rasterAx, histAx] = RasterPETH(S{i}, center, -15000,+15000,'BinSize',10);close
end
