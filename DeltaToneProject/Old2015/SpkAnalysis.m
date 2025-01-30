
load SpikeData
J1=-10000;
J2=+50000;

try 
    load ToneEvent
    spk=1;
end
try 
    load DeltaPaCx
    Delta=1;
end


%------------------------------------------------------------------------------------------------------------------------
%                                                       Spike Raster PETH
%------------------------------------------------------------------------------------------------------------------------
if spk==1;
    for i=1:length(S)
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([SeqTone])), J1, J2,'BinSize',800);close
        sq_Spk_Tone{i}=sq;
        sw_Spk_Tone{i}=sw;
        save SpkTone sq_Spk_Tone sw_Spk_Tone
    end
end

%------------------------------------------------------------------------------------------------------------------------
%                                                       Spike Raster PETH
%------------------------------------------------------------------------------------------------------------------------
if Delta==1
    for i=1:length(S)
        figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Range(tDeltaT2)])), J1, J2,'BinSize',800);close
        sq_Spk_PaCxDelta{i}=sq;
        sw_Spk_PaCxDelta{i}=sw;
        save SpkDelta sq_Spk_PaCxDelta sw_Spk_PaCxDelta
    end
end


%------------------------------------------------------------------------------------------------------------------------
%                                                       Spike Raster PETH
%------------------------------------------------------------------------------------------------------------------------
ToneEpoch=intervalSet(SeqTone-1E4,SeqTone+1E4);
DeltaNOTone=DeltaEpoch-ToneEpoch;

for i=1:length(S)
    figure, [fh, sq, sw, rasterAx, histAx]=RasterPETH(S{i}, ts(sort([Range(DeltaNOTone)])), J1, J2,'BinSize',800);close
    sq_Spk_PaCxDelta{i}=sq;
    sw_Spk_PaCxDelta{i}=sw;
    save SpkTone sq_Spk_PaCxDelta sw_Spk_PaCxDelta 
end


for i=1:length(S)
    figure, plot((Range(sq_Spk_Tone{i}, 'ms')), (Data(sq_Spk_Tone{i})/length(sw_Spk_Tone{i})),'k','linewidth',1);
    %hold on, plot((Range(sq_Spk_PaCxDelta{i}, 'ms')), (Data(sq_Spk_PaCxDelta{i})/length(sw_Spk_PaCxDelta{i})),'r','linewidth',1);
    hold on, title(['spike number: ',num2str(i),' - ',num2str(cellnames{i})])
    hold on, plot(0,min(ylim):0.01:max(ylim),'b');
    for a=200
    hold on, plot(a,min(ylim):0.01:max(ylim),'r');
    end
end









