%genLFPScanFrequency

% Load Information
res=pwd;
load([res,'/LFPData/InfoLFP']);
load ScanFrequency
load IntanEvt

% Window analysis of ERPs and PETH
J1=-1000;
J2=+2000;


% ERPs analysis all event 
i=1;
for num=0:length(InfoLFP.structure)-1;
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    figure, [fh, rasterAx, histAx, LFPEvent1(i)]=ImagePETH(LFP2, ts(sort([Event1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPEvent2(i)]=ImagePETH(LFP2, ts(sort([Event2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPEvent3(i)]=ImagePETH(LFP2, ts(sort([Event3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPEvent4(i)]=ImagePETH(LFP2, ts(sort([Event4])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPEvent5(i)]=ImagePETH(LFP2, ts(sort([Event5])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPEvent6(i)]=ImagePETH(LFP2, ts(sort([Event6])), J1, J2,'BinSize',800);close
    i=i+1;
end
save LFPScanFrequency -append LFPEvent1 LFPEvent2 LFPEvent3 LFPEvent4 LFPEvent5 LFPEvent6


% ERPs analysis all frequency
i=1;
for num=0:length(InfoLFP.structure)-1;
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    
    figure, [fh, rasterAx, histAx, LFPFq5kHz(i)]=ImagePETH(LFP2, ts(sort([Fq5kHz])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPFq10kHz(i)]=ImagePETH(LFP2, ts(sort([Fq10kHz])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPFq15kHz(i)]=ImagePETH(LFP2, ts(sort([Fq15kHz])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPFq20kHz(i)]=ImagePETH(LFP2, ts(sort([Fq20kHz])), J1, J2,'BinSize',800);
    figure, [fh, rasterAx, histAx, LFPFq25kHz(i)]=ImagePETH(LFP2, ts(sort([Fq25kHz])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, LFPFq30kHz(i)]=ImagePETH(LFP2, ts(sort([Fq30kHz])), J1, J2,'BinSize',800);
    i=i+1;
end

save LFPScanFrequency -append LFPFq5kHz LFPFq10kHz LFPFq12kHz LFPFq15kHz LFPFq20kHz LFPFq25kHz LFPFq30kHz


% ERPs analysis all intensity
i=1;
for num=0:length(InfoLFP.structure)-1;
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    figure, [fh, rasterAx, histAx, Fq5kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq5kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq5kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq5kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq5kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq5kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq5kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq5kHz_int4])), J1, J2,'BinSize',800);close
    
    figure, [fh, rasterAx, histAx, Fq10kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq10kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq10kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq10kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq10kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq10kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq10kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq10kHz_int4])), J1, J2,'BinSize',800);close
    
    figure, [fh, rasterAx, histAx, Fq15kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq15kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq15kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq15kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq15kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq15kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq15kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq15kHz_int4])), J1, J2,'BinSize',800);close
    
    figure, [fh, rasterAx, histAx, Fq20kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq20kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq20kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq20kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq20kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq20kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq20kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq20kHz_int4])), J1, J2,'BinSize',800);close
    
    figure, [fh, rasterAx, histAx, Fq25kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq25kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq25kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq25kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq25kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq25kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq25kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq25kHz_int4])), J1, J2,'BinSize',800);close
    
    figure, [fh, rasterAx, histAx, Fq30kHz1(i)]=ImagePETH(LFP2, ts(sort([Fq30kHz_int1])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq30kHz2(i)]=ImagePETH(LFP2, ts(sort([Fq30kHz_int2])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq30kHz3(i)]=ImagePETH(LFP2, ts(sort([Fq30kHz_int3])), J1, J2,'BinSize',800);close
    figure, [fh, rasterAx, histAx, Fq30kHz4(i)]=ImagePETH(LFP2, ts(sort([Fq30kHz_int4])), J1, J2,'BinSize',800);close

    i=i+1;
end

save LFPScanFrequency -append Fq5kHz1 Fq5kHz2 Fq5kHz3 Fq5kHz4
save LFPScanFrequency -append Fq10kHz1 Fq10kHz2 Fq10kHz3 Fq10kHz4
save LFPScanFrequency -append Fq15kHz1 Fq15kHz2 Fq15kHz3 Fq15kHz4
save LFPScanFrequency -append Fq20kHz1 Fq20kHz2 Fq20kHz3 Fq20kHz4
save LFPScanFrequency -append Fq25kHz1 Fq25kHz2 Fq25kHz3 Fq25kHz4
save LFPScanFrequency -append Fq30kHz1 Fq30kHz2 Fq30kHz3 Fq30kHz4

