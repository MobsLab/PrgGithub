res=pwd;
load([res,'/LFPData/InfoLFP']);
load ScanFrequency

reference=input('which reference channel ? ');
load([res,'/LFPData/LFP',num2str(reference)]);

ref=LFP;
REF=Data(ref);
%REF=[REF,REF(end)];

% All Event
lim=1500;
LFPpeth=input('which channel do you want to analyse (PETH) ?     ');
for a=LFPpeth(1):LFPpeth(end)
    i=a+1;
    load([res,'/LFPData/LFP',num2str(i)]);
    LFPc=tsd(Range(LFP),Data(LFP)-REF);
    for j=1:6
        figure, [fh, rasterAx, histAx, Raster(i,j)]=ImagePETH(LFPc, ts(sort([AllEvent{j}])), -2000, 6000,'BinSize',800);close
        Raster(i,j)=tsd(Range(Raster(i,j)),RemoveLignsMatrix(Data(Raster(i,j))',lim)');
    end
end


% Selected Intensity (all frequency) 
k=input('which intensity do you want to analyse (1:4)?       ');
LFPpeth=input('which channel do you want to analyse (PETH) ?     ');
for i=LFPpeth(1):LFPpeth(end)
    load([res,'/LFPData/LFP',num2str(i)]);
    LFPc=tsd(Range(LFP),Data(LFP)-REF);
    %LFPc=LFP;
        lim=3*std(Data(LFP));
        for j=1:6
            figure, [fh, rasterAx, histAx, Raster(i+1,j)]=ImagePETH(LFPc, ts(sort([AllFrequency{j,k}])), -2000, 6000,'BinSize',800);close
            Raster(i+1,j)=tsd(Range(Raster(i+1,j)),RemoveLignsMatrix(Data(Raster(i+1,j))',lim)');
        end
end

for a=LFPpeth(1):LFPpeth(end)
    i=a+1; 
    figure('color',[1 1 1]),
    hold on,
    plot(Range(Raster(i,1),'ms'),nanmean(Data(Raster(i,1))'),'k')
    plot(Range(Raster(i,2),'ms'),nanmean(Data(Raster(i,2))'),'b')
    plot(Range(Raster(i,3),'ms'),nanmean(Data(Raster(i,3))'),'r')
    plot(Range(Raster(i,4),'ms'),nanmean(Data(Raster(i,4))'),'m')
    plot(Range(Raster(i,5),'ms'),nanmean(Data(Raster(i,5))'),'g')
    plot(Range(Raster(i,6),'ms'),nanmean(Data(Raster(i,6))'),'c')
    yl=ylim;
    ylim([yl(1)-10 yl(2)+10])
    yl=ylim;
    line([15 15],yl,'color',[0.6 0.6 0.6])
    title(['channel : ',num2str(a),'  - structure : ',InfoLFP.structure(i)])
end

% Selected Frequency (all intensity)
j=input('which frequency do you want to analyse (1:6)?       ');
LFPpeth=input('which channel do you want to analyse (PETH) ?     ');
for i=LFPpeth(1):LFPpeth(end)
    load([res,'/LFPData/LFP',num2str(i)]);
    LFPc=tsd(Range(LFP),Data(LFP)-REF);
    %LFPc=LFP;
        lim=3*std(Data(LFP));
        for k=1:4
            figure, [fh, rasterAx, histAx, Raster(i+1,j)]=ImagePETH(LFPc, ts(sort([AllFrequency{j,k}])), -2000, 6000,'BinSize',800);close
            Raster(i+1,k)=tsd(Range(Raster(i+1,k)),RemoveLignsMatrix(Data(Raster(i+1,k))',lim)');
        end
end

for a=LFPpeth(1):LFPpeth(end)
    i=a+1;
    figure('color',[1 1 1]),
    hold on,
    plot(Range(Raster(i,1),'ms'),nanmean(Data(Raster(i,1))'),'k')
    plot(Range(Raster(i,2),'ms'),nanmean(Data(Raster(i,2))'),'b')
    plot(Range(Raster(i,3),'ms'),nanmean(Data(Raster(i,3))'),'r')
    plot(Range(Raster(i,4),'ms'),nanmean(Data(Raster(i,4))'),'m')
    yl=ylim;
    ylim([yl(1)-10 yl(2)+10])
    yl=ylim;
    line([15 15],yl,'color',[0.6 0.6 0.6])
    title(['channel : ',num2str(a),'  - structure : ',InfoLFP.structure(i)])
end




for a=LFPpeth(1):LFPpeth(end)
    i=a+1;
    figure('color',[1 1 1]),
    subplot(1,1,1), hold on,
    plot(Range(Raster(i,1),'ms'),nanmean(Data(Raster(i,1))'),'k')
    plot(Range(Raster(i,2),'ms'),nanmean(Data(Raster(i,2))'),'b')
    plot(Range(Raster(i,3),'ms'),nanmean(Data(Raster(i,3))'),'r')
    plot(Range(Raster(i,4),'ms'),nanmean(Data(Raster(i,4))'),'m')
    plot(Range(Raster(i,5),'ms'),nanmean(Data(Raster(i,5))'),'g')
    plot(Range(Raster(i,6),'ms'),nanmean(Data(Raster(i,6))'),'c')
    yl=ylim;
    ylim([yl(1)-10 yl(2)+10])
    yl=ylim;
    line([0 0],yl,'color',[0.6 0.6 0.6])
    title(['channel : ',num2str(a),'  - structure : ',InfoLFP.structure(i)])
    
    %     subplot(2,1,2), hold on,
%     [M,S,E]=MeanDifNAn([nanmean(Data(Raster(i,1))');nanmean(Data(Raster(i,2))');nanmean(Data(Raster(i,3))');nanmean(Data(Raster(i,4))');nanmean(Data(Raster(i,5))');nanmean(Data(Raster(i,6))')]);
%     plot(Range(Raster(i,1),'ms'),M,'k','linewidth',2)
%     plot(Range(Raster(i,1),'ms'),M+E,'color',[0.7 0.7 0.7])
%     plot(Range(Raster(i,1),'ms'),M-E,'color',[0.7 0.7 0.7])
%     yl=ylim;
%     ylim([yl(1)-10 yl(2)+10])
%     yl=ylim;
%     line([0 0],yl,'color','r')
%     title(num2str(i))
end 
