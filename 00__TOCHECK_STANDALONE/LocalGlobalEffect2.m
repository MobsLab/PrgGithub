% LocalGlobalEffect2
% matVal{i,j}
% i=> numero de la voie LFP
% j=> associé à chaque variante de son dans le protocole Local/Global/Omission
% 1: Local Standard - Global Standard A
% 2: Local Standard - Global Standard B
% 3: Local Deviant - Global Standard A
% 4: Local Deviant - Global Standard B
% 5: Local Deviant - Global Deviant A
% 6: Local Deviant - Global Deviant B
% 7: Omission AAAA (bloc Omission only)
% 8: Omission rare A (during classical bloc - occurence 10%)
% 9: Omission BBBB (bloc Omission only)
% 10: Omission rare A (during classical bloc - occurence 10%)

plo=3;


% -----------------------   LFP   -----------------------------------------
if plo==0;
    for i=1:length(LFP);
    figure, [fh, rasterAx, histAx, matVal{i,1}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - channel LFP n°',num2str(i)]);close 
    figure, [fh, rasterAx, histAx, matVal{i,2}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,3}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,4}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,5}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,6}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,7}] = ImagePETH(LFP{i}, ts(sort(OmiAAAA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,8}] = ImagePETH(LFP{i}, ts(sort(OmissionRareA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,9}] = ImagePETH(LFP{i}, ts(sort(OmiBBBB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,10}] = ImagePETH(LFP{i}, ts(sort(OmissionRareB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
      end
end


% ----------------------- Spikes ------------------------------------------
if plo==1;
  for i=1:length(S)
    figure, [fh, rasterAx, histAx, matValSpk{i,1}] = RasterPETH(S{i}, ts(sort(LocalStdGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,2}] = RasterPETH(S{i}, ts(sort(LocalStdGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,3}] = RasterPETH(S{i}, ts(sort(LocalDvtGlobStdA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,4}] = RasterPETH(S{i}, ts(sort(LocalDvtGlobStdB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,5}] = RasterPETH(S{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,6}] = RasterPETH(S{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,7}] = RasterPETH(S{i}, ts(sort(OmiAAAA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,8}] = RasterPETH(S{i}, ts(sort(OmissionRareA)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,9}] = RasterPETH(S{i}, ts(sort(OmiBBBB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matValSpk{i,10}] = RasterPETH(S{i}, ts(sort(OmissionRareB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
  end
end



    
% -----------------------   LFP   -----------------------------------------
if plo==2;
  for i=2:length(LFP);
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot::Raster(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA      +  freqBBBBB - channeln°',num2str(i)]) 
    hold on, axis([-100 1100 -1500 1000])
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    [h,p]=ttest2(Data(matVal{i,1})',Data(matVal{i,3})');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'bx')  
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet LOCAL: FreqBBBBB vs FreqAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    [h,p]=ttest2(Data(matVal{i,2})',Data(matVal{i,4})');
    rg=Range(matVal{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'rx')  
    %----------------------------------------------------------------------
    % Effet Global Deviant A
    %----------------------------------------------------------------------    
    figure, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,5},'ms'),mean(Data(matVal{i,5})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet GLOBAL: FreqBBBBA vs RareBBBBA  +  freqBBBBB - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    %----------------------------------------------------------------------
    % Effet Global Deviant B
    %---------------------------------------------------------------------- 
    figure, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,6},'ms'),mean(Data(matVal{i,6})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet GLOBAL: FreqAAAAB vs RareAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])  
    %----------------------------------------------------------------------
    % Effet Omission son A
    %---------------------------------------------------------------------- 
%     figure, plot(Range(matVal{i,7},'ms'),mean(Data(matVal{i,7})'),'k','linewidth',2)
%     hold on, plot(Range(matVal{i,8},'ms'),mean(Data(matVal{i,8})'),'r','linewidth',2)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
%         end
%     hold on, title(['effet Omission: omission A attendue VS omission A rare',num2str(i)])
%     hold on, axis([-100 1100 -1500 1000])
%     %----------------------------------------------------------------------
%     % Effet Omission son B
%     %---------------------------------------------------------------------- 
%     figure, plot(Range(matVal{i,9},'ms'),mean(Data(matVal{i,9})'),'k','linewidth',2)
%     hold on, plot(Range(matVal{i,10},'ms'),mean(Data(matVal{i,10})'),'r','linewidth',2)
%         for a=0:150:600
%         hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
%         end
%     hold on, title(['effet Omission: omission B attendue VS omission B rare',num2str(i)])
%     hold on, axis([-100 1100 -1500 1000])
  end
end

    
  
  % -----------------------   LFP   -----------------------------------------
if plo==3;
  for i=2:length(S);
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot(Range(matValSpk{i,1},'ms'),mean(Data(matValSpk{i,1})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,3},'ms'),mean(Data(matValSpk{i,3})'),'r','linewidth',2)
    hold on, plot(Range(matValSpk{i,2},'ms'),mean(Data(matValSpk{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA      +  freqBBBBB - channeln°',num2str(i)]) 
    hold on, axis([-100 1100 -1500 1000])
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    [h,p]=ttest2(Data(matValSpk{i,1})',Data(matValSpk{i,3})');
    rg=Range(matValSpk{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'bx')  
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure, plot(Range(matValSpk{i,2},'ms'),mean(Data(matValSpk{i,2})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,4},'ms'),mean(Data(matValSpk{i,4})'),'r','linewidth',2)
    hold on, plot(Range(matValSpk{i,1},'ms'),mean(Data(matValSpk{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet LOCAL: FreqBBBBB vs FreqAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    [h,p]=ttest2(Data(matValSpk{i,2})',Data(matValSpk{i,4})');
    rg=Range(matValSpk{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'rx')  
    %----------------------------------------------------------------------
    % Effet Global Deviant A
    %----------------------------------------------------------------------    
    figure, plot(Range(matValSpk{i,3},'ms'),mean(Data(matValSpk{i,3})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,5},'ms'),mean(Data(matValSpk{i,5})'),'r','linewidth',2)
    hold on, plot(Range(matValSpk{i,1},'ms'),mean(Data(matValSpk{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet GLOBAL: FreqBBBBA vs RareBBBBA  +  freqBBBBB - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    %----------------------------------------------------------------------
    % Effet Global Deviant B
    %---------------------------------------------------------------------- 
    figure, plot(Range(matValSpk{i,4},'ms'),mean(Data(matValSpk{i,4})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,6},'ms'),mean(Data(matValSpk{i,6})'),'r','linewidth',2)
    hold on, plot(Range(matValSpk{i,1},'ms'),mean(Data(matValSpk{i,1})'),'g','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet GLOBAL: FreqAAAAB vs RareAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])  
    %----------------------------------------------------------------------
    % Effet Omission son A
    %---------------------------------------------------------------------- 
    figure, plot(Range(matValSpk{i,7},'ms'),mean(Data(matValSpk{i,7})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,8},'ms'),mean(Data(matValSpk{i,8})'),'r','linewidth',2)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet Omission: omission A attendue VS omission A rare',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    %----------------------------------------------------------------------
    % Effet Omission son B
    %---------------------------------------------------------------------- 
    figure, plot(Range(matValSpk{i,9},'ms'),mean(Data(matValSpk{i,9})'),'k','linewidth',2)
    hold on, plot(Range(matValSpk{i,10},'ms'),mean(Data(matValSpk{i,10})'),'r','linewidth',2)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
    hold on, title(['effet Omission: omission B attendue VS omission B rare',num2str(i)])
    hold on, axis([-100 1100 -1500 1000])
    end
end



