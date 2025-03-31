%% Movie PosMat each 30 frames
k = 1;
for i=1:500
    k
    PosMat(k,1)
    plot(PosMat(k:(k+30),2), PosMat(k:(k+30),3))
    xlim([15 55])
    ylim([0 40])
    pause(2)
    k = k+30;
end


%% Remove immobility periods

A = Data(Vtsd);
B = runmean(A,7);
Vtsd_smoothed = tsd(Range(Vtsd), B);
int = thresholdIntervals(Vtsd_smoothed, 0.13, 'Direction', 'Above');
int = dropShortIntervals(int, 1*1E4);
a=0;
a=a+1; [map,mapS,stats] = PlaceField(Restrict(S{a}, int),Xtsd,Ytsd,'smoothing', 2.5, 'size', 75); stats