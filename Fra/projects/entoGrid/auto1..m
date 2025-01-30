[nTimes, nCells] = size(Vconf);

AC = zeros(nCells, 101, 101);
for i = 1:nCells
    AC(i,:,:) = spaceAutoCorr(vv, xx, yy, 1, 50, 200);
end

ACM = mean(AC, 1);
