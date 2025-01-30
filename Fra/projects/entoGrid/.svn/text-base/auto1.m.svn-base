[nCells, nTimes] = size(Vconf);

AC = zeros(nCells, 101, 101);
for i = 1:nCells
    if mod(i,50)==0
        i
    end
    
    vv = double(Vconf(i,:));
    AC(i,:,:) = spaceAutoCorr(vv, xx, yy, 1, 50, 100);
end

ACM = mean(AC, 1);
