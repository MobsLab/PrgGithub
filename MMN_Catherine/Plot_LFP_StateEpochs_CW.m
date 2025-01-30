% plot the data in function of the State epoch

try 
    load StateEpoch
    
catch
    disp('... no state Epoch was found, aborting...'); return
end
load LocalGlobalAssignment  



list_channel = [13 ];
for chan = list_channel
    eval(['load LFP' num2str(chan) ])
    eval(['LFP = LFP' num2str(chan) '; clearvars LFP' num2str(chan) ';'])
    %local_Effect
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, Restrict(ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), SWSEpoch), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
    %figure, [fh, rasterAx, histAx, MLdev1]=ImagePETH(LFP, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
    
    figure('Position', [50 100 500 600], 'Color', [1 1 1])
end