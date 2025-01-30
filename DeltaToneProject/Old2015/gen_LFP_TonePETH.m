
%---------------------------------------------------
%                   load Intan Event Signal
%---------------------------------------------------
load ToneEvent
try load StateEpochSB
    stateEpoch=1;
end

res=pwd;
smo=2;
J1=-10000;
J2=+50000;

%-----------------------------------------------------------------------------------------------------------------------------------------
%                                                       analysis PETH single tone
%-----------------------------------------------------------------------------------------------------------------------------------------
try load LFP_Tone

catch
    load([res,'/LFPData/InfoLFP']);
    
    i=1;
    for num=InfoLFP.channel(1):InfoLFP.channel(end);
        clear LFP
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        
        figure, [fh, rasterAx, histAx, LFP_SingleTone(i)]=ImagePETH(LFP2, ts(sort([SingleTone])), J1, J2,'BinSize',800);close
        
        i=i+1;
    end
end
save LFP_Tone LFP_SingleTone

%-----------------------------------------------------------------------------------------------------------------------------------------
%                                                        analysis Delta PETH
%-----------------------------------------------------------------------------------------------------------------------------------------
load DeltaPaCx
ToneEpoch=intervalSet(SingleTone-0.5E4,SingleTone+0.5E4);
ToneEpoch=mergeCloseIntervals(ToneEpoch,1);
NoToneSWSEpoch=SWSEpoch-ToneEpoch;

try load LFP_Delta

catch
    load([res,'/LFPData/InfoLFP']);
    
    i=1;
    for num=InfoLFP.channel(1):InfoLFP.channel(end);
        clear LFP
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        
        %figure, [fh, rasterAx, histAx, LFP_Delta(i)]=ImagePETH(LFP2, ts(sort([Range(tDeltaT2)])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_Delta(i)]=ImagePETH(LFP2, Restrict(ts(sort([Range(tDeltaT2)])),NoToneSWSEpoch), J1, J2,'BinSize',800);close
        
        i=i+1;
    end
end          

%-----------------------------------------------------------------------------------------------------------------------------------------
%                                                        analysis PETH tone sequence
%-----------------------------------------------------------------------------------------------------------------------------------------

load([res,'/LFPData/InfoLFP']);
%seqTone=SeqTone(1:10:end);

i=1;
for num=InfoLFP.channel(1):InfoLFP.channel(end);
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    figure, [fh, rasterAx, histAx, LFP_SeqTone(i)]=ImagePETH(LFP2, ts(sort([SeqTone])), J1, J2,'BinSize',800);close

    i=i+1;
end
save LFP_Tone LFP_SeqTone



%-----------------------------------------------------------------------------------------------------------------------------------------
%                                                       analysis PETH single tone
%-----------------------------------------------------------------------------------------------------------------------------------------
if stateEpoch==1
    
    load([res,'/LFPData/InfoLFP']);
    i=1;
    
    for num=InfoLFP.channel(1):InfoLFP.channel(end);
        clear LFP
        load([res,'/LFPData/LFP',num2str(num)]);
        LFP2=ResampleTSD(LFP,500);
        
        figure, [fh, rasterAx, histAx, LFP_SingleTone_SWS(i)]=ImagePETH(LFP2, Restrict(ts(sort([SingleTone])),SWSEpoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_SingleTone_REM(i)]=ImagePETH(LFP2, Restrict(ts(sort([SingleTone])),REMEpoch), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, LFP_SingleTone_Wake(i)]=ImagePETH(LFP2, Restrict(ts(sort([SingleTone])),Wake), J1, J2,'BinSize',800);close
        i=i+1;
    end
    
    save -append LFP_Tone LFP_SingleTone_SWS LFP_SingleTone_REM LFP_SingleTone_Wake
end


 
