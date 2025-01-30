%  Pour faire des Rasters
%  
%  
%  
%  ------------------------------------------------------------------------
%  Raster toute la population en fonction du temps
%  
%  	figure, RasterPlot(S)
%  
%  RasterPlot(Restrict(S,Epoch1),'Markers',{Range(Restrict(stim,Epoch1),'ms')},'MarkerTypes',{'ro','r'});
%
%  ------------------------------------------------------------------------
%  Raster 1 neurone par essais en fonction du temps
%  
%  --------------------
%  figure, [fh,sq,sweeps] = RasterPETH(S{num}, ts(st), -10000, +15000,'BinSize',500);
%  plot(Data(sq)/length(sweeps))
%
%  figure, [fh,sq,sweeps] = RasterPETH(S{num}, ts(st), -95000,+15000,'BinSize',1000,'Markers',{ts(to)},'MarkerTypes',{'ro','r'});
%  figure, [fh,sq,sweeps] = RasterPETH(S{k}, ts(st), -550000,+550000,'BinSize',6500,'Markers',{ts(to)},'MarkerTypes',{'ro','r'},'Markers2',{ts(tpsArm)},'MarkerTypes2',{'bo','b'},'MarkerLine',1);
%  
% plus rapide :
% [C, B] = CrossCorr(st,Range(S{num}),1,2000);
% identique au haut de RasterPETH(S{num},ts(st),-1E4,1E4)
%
%  ------------------------------------------------------------------------  
%  Raster avec les phases en couleur en fonction du temps
%  
%  BinSize,Avant,Apres : en 10000ème de s !!!!!!
%  
%  [Si,sq,sweeps]=RasterPHASE(S,neuron,EEGh,Epoch,st,to,split,BinSize,Avant,Apres)
%  
%  si pas de to....... to=0;
%  
%  --------------------
%  
%  C=colormap(HSV);
%  for i=1:64
%  list(i)=65-i;
%  end
%  A=C(list,:);
%  figure, 
%  for i=1:split
%  
%  	hold on, plot(Range(sq{i}, 'ms'), Data(sq{i})/length(sweeps{i}), 'Color',A(floor(i*64/split),:), 'lineWidth',2);
%  
%  end
%  
%  
%  ------------------------------------------------------------------------  
%  
%  
%  ------------------------------------------------------------------------  
%  Raster en fonction du temps - valeur continue (ou spikes binned)
%  
%  
%  	Qs = MakeQfromS(S,500);
% 	ratek = Restrict(Qs,intervalSet(st(1)-30000,to(end)+3000));
%   ratek=Qs;
% 	rate = Data(ratek);
% 	ratek = tsd(Range(ratek),rate(:,k));
% 	
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(st), -10000, +15000,'BinSize',500);

% 
% figure, plot(mean(matVal))
%  ou figure, plot(mean(Data(matVal)))
%  
%  ------------------------------------------------------------------------  
%  Raster en fonction de la position - valeur continue (ou spikes binned)
%  
%  
%  	phiG=LinearTraj(journum);
% 	Qs = MakeQfromS(S,1000);
% 	ratek = Restrict(Qs,intervalSet(st(1)-30000,to(end)+3000));
% 	rate = Data(ratek);
% 	ratek = tsd(Range(ratek),rate(:,k));
% 	
% figure, [fh, rasterAx, histAx, matVal] = RasterPPH(ratek, phiG, tsd(Start(ArmExtEpoch),Start(ArmExtEpoch)) , trialOutcome{1},'SpaceBin', 0.01);
% 
% 
% figure, plot(mean(matVal))




%  ------------------------------------------------------------------------
%  Raster en fonction de la position 
%  
%  
% spacePETH = RasterSpace(S, phiG, TStart, TEnd, varargin)



%  ------------------------------------------------------------------------






