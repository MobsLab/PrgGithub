%MMNanalysisSpike

load SpikeData
load LocalGlobalTotalAssignment

J1=-2000;
J2=+13000;
smo=2;


%---------------------------------------------------------------------------
%<><><><><><><><><><><><><> Spike Raster Activity <><><><><><><><><><><><><>
%---------------------------------------------------------------------------
try
    load TotalRasterSpike
catch
    for i=1:length(S);  
        figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), J1, J2,'BinSize',50);      close 
        sqLstd{i}=sq;
        swLstd{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), J1, J2,'BinSize',50);      close
        sqLdvt{i}=sq;
        swLdvt{i}=sw;       
        figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), J1, J2,'BinSize',50);        close
        sqGdvt{i}=sq;
        swGdvt{i}=sw;        
        figure, [fh, sq, sw, rasterAx, histAx] =  RasterPETH(S{i}, ts(sort([OmiAAAA;OmiBBBB])), J1, J2,'BinSize',50);     close              
        sqOmiFreq{i}=sq;
        swOmiFreq{i}=sw;      
        figure, [fh, sq, sw, rasterAx, histAx] =  RasterPETH(S{i}, ts(sort([OmissionRareA;OmissionRareB])), J1, J2,'BinSize',50);    close
        sqOmiRare{i}=sq;
        swOmiRare{i}=sw;        
        sqGstd{i}=sqLstd{i};swGstd{i}=swLstd{i};
    end
    save TotalRasterSpike sqLstd swLstd sqLdvt swLdvt sqGdvt swGdvt sqGstd swGstd sqOmiFreq swOmiFreq sqOmiRare swOmiRare
end


for i=1:length(S);  
        %<><><><><><><><><><><><><><><><><><><><><><>   Local Effect   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        figure, subplot(3,1,1), 
        hold on, plot((Range(sqLstd{i}, 'ms')), SmoothDec((Data(sqLstd{i})/length(swLstd{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sqLdvt{i}, 'ms')), SmoothDec((Data(sqLdvt{i})/length(swLdvt{i})),smo),'r','linewidth',2);title(['Local Effect - Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        %<><><><><><><><><><><><><><><><><><><><><><>   Global Effect   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(3,1,2)
        hold on, plot((Range(sqGstd{i}, 'ms')), SmoothDec((Data(sqGstd{i})/length(swGstd{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sqGdvt{i}, 'ms')), SmoothDec((Data(sqGdvt{i})/length(swGdvt{i})),smo),'r','linewidth',2);title(['Global Effect - Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        %<><><><><><><><><><><><><><><><><><><><><><>   Omission Effect   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(3,1,3)
        hold on, plot((Range(sqOmiFreq{i}, 'ms')), SmoothDec((Data(sqOmiFreq{i})/length(swOmiFreq{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sqOmiRare{i}, 'ms')), SmoothDec((Data(sqOmiRare{i})/length(swOmiRare{i})),smo),'r','linewidth',2);title(['Omission Effect - Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
end




