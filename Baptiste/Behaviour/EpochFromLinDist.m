
function EpochLinDist = EpochFromLinDist(LinearDist , n)

for i=1:n
    Epoch1 = thresholdIntervals(LinearDist , (i-1)/n);
    Epoch2 = thresholdIntervals(LinearDist , i/n , 'Direction','Below');
    EpochLinDist{i} = and(Epoch1 , Epoch2);
end







