%% %%           PETH visualisation for the different local-global Std-vs-Dvt block

% --------------------------------------- LFP --------------------------------------- 
for i=2:length(LFP)
    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdA)), -1000, +11000,'BinSize',50,title(['Block Local Standard - Global Standard   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
end
for i=2:length(LFP)
    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobDvtA)), -1000, +11000,'BinSize',50,title(['Block Local Standard - Global Deviant   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
end
for i=2:length(LFP)
    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdA)), -1000, +11000,'BinSize',50,title(['Block Local Deviant - Global Standard   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
end
for i=2:length(LFP)
    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +11000,'BinSize',50,title(['Block Local Deviant - Global Deviant    A  -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end    
end
for i=2:length(LFP)
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdB)), -1000, +11000,'BinSize',50,title(['Block Local Standard - Global Standard   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end    
end
for i=2:length(LFP)
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobDvtB)), -1000, +11000,'BinSize',50,title(['Block Local Standard - Global Deviant   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
end
for i=2:length(LFP)
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdB)), -1000, +11000,'BinSize',50,title(['Block Local Deviant - Global Standard   A   -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end    
end
for i=2:length(LFP)
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +11000,'BinSize',50,title(['Block Local Deviant - Global Deviant    A  -','channel LFP n°', num2str(i)]));
        for a=0:0.150:0.6
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end    
end
for i=2:length(LFP)
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sort(Omission)), -1000, +12000,'BinSize',50,title(['Block Omission      -','channel LFP n°', num2str(i)]));
end



% ------------------------------------- Spikes ------------------------------------- 
for i=1:length(S)
    figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{i}, ts(sort(LocalStdGlobStd)), -1000, +8000,'BinSize',50,title(['Block Local Standard - Global Standard      -','Spike n°', num2str(i)]));
    figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{i}, ts(sort(LocalStdGlobDvt)), -1000, +8000,'BinSize',50,title(['Block Local Standard - Global Deviant     -','Spike n°', num2str(i)]));
    figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{i}, ts(sort(LocalDvtGlobStd)), -1000, +8000,'BinSize',50,title(['Block Local Deviant - Global Standard     -','Spike n°', num2str(i)]));
    figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{i}, ts(sort(LocalDvtGlobDvt)), -1000, +8000,'BinSize',50,title(['Block Local Deviant - Global Deviant     ','Spike n°', num2str(i)]));
    figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{i}, ts(sort(Omission)), -1000, +8000,'BinSize',50,title(['Block Omission      -','Spike n°', num2str(i)]));
end

% ------------------------------------- Saving ------------------------------------- 

for i=1:25;
    figure(i)
    saveName=(['FigSpike', num2str(i)]);
    saveas(gcf, saveName, 'jpg');
    close
end

