% LocalGlobalEffect


for i=1:length(LFP);
    figure, [fh, rasterAx, histAx, matVal{i,1}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - channel LFP n°',num2str(i)]);close 
    figure, [fh, rasterAx, histAx, matVal{i,2}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,3}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,4}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,7}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,8}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,8}] = ImagePETH(LFP{i}, ts(sort(Omission)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);

% Comparaisons des effets locaux et globaux pour les deviants A et B
    figure, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet LOCAL: FreqBBBBB vs FreqAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -600 600])
    [h,p]=ttest2(Data(matVal{i,2})',Data(matVal{i,4})');
    rg=Range(matVal{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(find(p<0.05)),pr(p<0.05),'rx')
%--------------------------------------------------------------------------
    figure, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,8},'ms'),mean(Data(matVal{i,8})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet GLOBAL: FreqAAAAB vs RareAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -600 600])
%--------------------------------------------------------------------------
    figure, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA      +  freqBBBBB - channeln°',num2str(i)]) 
    hold on, axis([-100 1100 -600 600])
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    [h,p]=ttest2(Data(matVal{i,1})',Data(matVal{i,3})');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(find(p<0.05)),pr(p<0.05),'bx')
%--------------------------------------------------------------------------
    figure, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,7},'ms'),mean(Data(matVal{i,7})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet GLOBAL: FreqBBBBA vs RareBBBBA  +  freqBBBBB - channeln°',num2str(i)])
    hold on, axis([-100 1100 -600 600])
end

% matVal1015HzJourMois=matVal;
% save matVal1015HzJourMois matVal1015HzJourMois;
