%genSpikeScanFrequency

J1=-1000;
J2=+2000;

meanORindFQ=input('do you want to analyse Spike Raster for mean of individual intensity? (e.g. mean=0 / ind=1)');

if meanORindFQ==0
    %--------------------------------------------------------------------------------------------------------------------------
    %                                            Spike Raster PETH for mean all intensity
    %--------------------------------------------------------------------------------------------------------------------------
 
    Fq5kHz=[Fq5kHz_int1;Fq5kHz_int2;Fq5kHz_int3;Fq5kHz_int4];
    Fq10kHz=[Fq10kHz_int1;Fq10kHz_int2;Fq10kHz_int3;Fq10kHz_int4];
    Fq15kHz=[Fq15kHz_int1;Fq15kHz_int2;Fq15kHz_int3;Fq15kHz_int4];
    Fq20kHz=[Fq20kHz_int1;Fq20kHz_int2;Fq20kHz_int3;Fq20kHz_int4];
    Fq25kHz=[Fq25kHz_int1;Fq25kHz_int2;Fq25kHz_int3;Fq25kHz_int4];
    Fq30kHz=[Fq30kHz_int1;Fq30kHz_int2;Fq30kHz_int3;Fq30kHz_int4];
    
    for i=1:length(S)
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq5kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_5kHz{i}=sq;
        sw_5kHz{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq10kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_10kHz{i}=sq;
        sw_10kHz{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq15kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_15kHz{i}=sq;
        sw_15kHz{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq20kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_20kHz{i}=sq;
        sw_20kHz{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq25kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_25kHz{i}=sq;
        sw_25kHz{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq30kHz])), J1, J2,'BinSize',800);title(num2str(i))
        sq_30kHz{i}=sq;
        sw_30kHz{i}=sw;
    end
    
    save SpkLocalGlobal sq_5kHz sw_5kHz sq_10kHz sw_10kHz
    save SpkLocalGlobal -append sq_15kHz sw_15kHz sq_20kHz sw_20kHz
    save SpkLocalGlobal -append sq_25kHz sw_25kHz sq_30kHz sw_30kHz
    
elseif meanORindFQ==1
    %--------------------------------------------------------------------------------------------------------------------------
    %                                     Spike Raster PETH for each individual intensity
    %--------------------------------------------------------------------------------------------------------------------------
    
    
    for i=1:length(S)
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq5kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_5kHz_int1{i}=sq;
        sw_5kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq5kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_5kHz_int2{i}=sq;
        sw_5kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq5kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_5kHz_int3{i}=sq;
        sw_5kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq5kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_5kHz_int4{i}=sq;
        sw_5kHz_int4{i}=sw;
        
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq10kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_10kHz_int1{i}=sq;
        sw_10kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq10kHz_int2])), J1, J2,'BinSize',800);title(num2str(i))
        sq_10kHz_int2{i}=sq;
        sw_10kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq10kHz_int3])), J1, J2,'BinSize',800);title(num2str(i))
        sq_10kHz_int3{i}=sq;
        sw_10kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq10kHz_int4])), J1, J2,'BinSize',800);title(num2str(i))
        sq_10kHz_int4{i}=sq;
        sw_10kHz_int4{i}=sw;
        
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq15kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_15kHz_int1{i}=sq;
        sw_15kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq15kHz_int2])), J1, J2,'BinSize',800);title(num2str(i))
        sq_15kHz_int2{i}=sq;
        sw_15kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq15kHz_int3])), J1, J2,'BinSize',800);title(num2str(i))
        sq_15kHz_int3{i}=sq;
        sw_15kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq15kHz_int4])), J1, J2,'BinSize',800);title(num2str(i))
        sq_15kHz_int4{i}=sq;
        sw_15kHz_int4{i}=sw;
        
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq20kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_20kHz_int1{i}=sq;
        sw_20kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq20kHz_int2])), J1, J2,'BinSize',800);title(num2str(i))
        sq_20kHz_int2{i}=sq;
        sw_20kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq20kHz_int3])), J1, J2,'BinSize',800);title(num2str(i))
        sq_20kHz_int3{i}=sq;
        sw_20kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq20kHz_int4])), J1, J2,'BinSize',800);title(num2str(i))
        sq_20kHz_int4{i}=sq;
        sw_20kHz_int4{i}=sw;
        
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq25kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_25kHz_int1{i}=sq;
        sw_25kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq25kHz_int2])), J1, J2,'BinSize',800);title(num2str(i))
        sq_25kHz_int2{i}=sq;
        sw_25kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq25kHz_int3])), J1, J2,'BinSize',800);title(num2str(i))
        sq_25kHz_int3{i}=sq;
        sw_25kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq25kHz_int4])), J1, J2,'BinSize',800);title(num2str(i))
        sq_25kHz_int4{i}=sq;
        sw_25kHz_int4{i}=sw;
        
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq30kHz_int1])), J1, J2,'BinSize',800);title(num2str(i))
        sq_30kHz_int1{i}=sq;
        sw_30kHz_int1{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq30kHz_int2])), J1, J2,'BinSize',800);title(num2str(i))
        sq_30kHz_int2{i}=sq;
        sw_30kHz_int2{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq30kHz_int3])), J1, J2,'BinSize',800);title(num2str(i))
        sq_30kHz_int3{i}=sq;
        sw_30kHz_int3{i}=sw;
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Fq30kHz_int4])), J1, J2,'BinSize',800);title(num2str(i))
        sq_30kHz_int4{i}=sq;
        sw_30kHz_int4{i}=sw;
    end
    
    save SpkScanFrequency_IndIntensity sq_5kHz_int1 sw_5kHz_int1 sq_5kHz_int2 sw_5kHz_int2 sq_5kHz_int3 sw_5kHz_int3 sq_5kHz_int4 sw_5kHz_int4
    save SpkScanFrequency_IndIntensity -append sq_10kHz_int1 sw_10kHz_int1 sq_10kHz_int2 sw_10kHz_int2 sq_10kHz_int3 sw_10kHz_int3 sq_10kHz_int4 sw_10kHz_int4
    save SpkScanFrequency_IndIntensity -append sq_15kHz_int1 sw_15kHz_int1 sq_15kHz_int2 sw_15kHz_int2 sq_15kHz_int3 sw_15kHz_int3 sq_15kHz_int4 sw_15kHz_int4
    save SpkScanFrequency_IndIntensity -append sq_20kHz_int1 sw_20kHz_int1 sq_20kHz_int2 sw_20kHz_int2 sq_20kHz_int3 sw_20kHz_int3 sq_20kHz_int4 sw_20kHz_int4
    save SpkScanFrequency_IndIntensity -append sq_25kHz_int1 sw_25kHz_int1 sq_25kHz_int2 sw_25kHz_int2 sq_25kHz_int3 sw_25kHz_int3 sq_25kHz_int4 sw_25kHz_int4
    save SpkScanFrequency_IndIntensity -append sq_30kHz_int1 sw_30kHz_int1 sq_30kHz_int2 sw_30kHz_int2 sq_30kHz_int3 sw_30kHz_int3 sq_30kHz_int4 sw_30kHz_int4
    
end