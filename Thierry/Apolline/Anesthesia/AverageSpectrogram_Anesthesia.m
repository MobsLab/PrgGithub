function [M,S,t]=AverageSpectrogram_Anesthesia(Stsd,f,tps,binSize,nbBins,plo,smo,logplot)


% [M,S,t]=AverageSpectrogram(Stsd,f,tps,binSize,nbBins,plo,smo,logplot)
% tps in s*1e4
%   *        binsize: the size of the bin in ms
%   *        nbins: the number of bins to compute 

try
    plo;
catch
    plo=1;
end

try
    logplot;
catch
    logplot=0;
end

if logplot
    Sp=10*log10(Data(Stsd)); 
else
    Sp=Data(Stsd);   
end

for i=1:length(f)
    
    [M(i,:),S(i,:),t]=mETAverage(Range(tps),Range(Stsd),Sp(:,i),binSize,nbBins);
    
end

if plo>0
    try
        smo;
        if plo<2
        figure('color',[1 1 1]), hold on
        end
        imagesc(t/1E3,f,SmoothDec(M,[smo smo])), axis xy
        yl=ylim;
%         line([0 0],yl,'color','w')
        ylabel('Frequency (Hz)')
        xlabel('Times (s)')    
        xlim([t(2) t(end-1)]/1E3)
%         ylim([f(1) f(end)])  
        ylim([0 10])
        caxis([20 65])
        
    catch
        if plo<2
        figure('color',[1 1 1]), hold on
        end
        imagesc(t/1E3,f,M), axis xy
        yl=ylim;
%         line([0 0],yl,'color','w')
        ylabel('Frequency (Hz)')
        xlabel('Times (s)')
        xlim([t(2) t(end-1)]/1E3)
%         ylim([f(1) f(end)])
        ylim([0 10])
        caxis([20 65])
        
    end
    
end
