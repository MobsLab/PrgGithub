%gen_Spike_DeltaToneEvt

%--------------------------------------------------------------------------------------------------------------------------------------

res=pwd;
load DeltaSleepEvent
load SpikeData
load([res,'/LFPData/InfoLFP']);

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/SpikesToAnalyse/PFCx_MUA']);
if length(number)>1
    PFCx_MUA=PoolNeurons(S,number);
    clear SS
    SS{1}=PFCx_MUA;
    SS=tsdArray(SS);
    QMua = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime1] = ImagePETH(QMua, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('PFCx MUA - time1')
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime2] = ImagePETH(QMua, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('PFCx MUA - time2')
    figure, [fh, rasterAx, histAx, matVal_MUA_DeltaDetect] = ImagePETH(QMua, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('PFCx MUA - DeltaDetect')
    
    save Spk_PFCx_Delta matVal_MUA_TONEtime1 matVal_MUA_TONEtime2 matVal_MUA_DeltaDetect
end
%<><>

load([res,'/SpikesToAnalyse/PFCx_Neurons']);
if length(number)>1
    PFCx_Neurons=PoolNeurons(S,number);
    clear SS
    SS{1}=PFCx_Neurons;
    SS=tsdArray(SS);
    Qspk = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - time1')
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime2] = ImagePETH(Qspk, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - time2')
    figure, [fh, rasterAx, histAx, matVal_Spk_DeltaDetect] = ImagePETH(Qspk, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - DeltaDetect')
    
    save Spk_PFCx_Delta -append matVal_Spk_TONEtime1 matVal_Spk_TONEtime2 matVal_Spk_DeltaDetect
end
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/SpikesToAnalyse/NRT_MUA']);
if length(number)>1
    NRT_MUA=PoolNeurons(S,number);
    clear SS
    SS{1}=NRT_MUA;
    SS=tsdArray(SS);
    QMua = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime1] = ImagePETH(QMua, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('NRT MUA - time1')
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime2] = ImagePETH(QMua, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('NRT MUA - time2')
    figure, [fh, rasterAx, histAx, matVal_MUA_DeltaDetect] = ImagePETH(QMua, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('NRT MUA - DeltaDetect')
    
    save Spk_NRT_Delta matVal_MUA_TONEtime1 matVal_MUA_TONEtime2 matVal_MUA_DeltaDetect
end
%<><>

load([res,'/SpikesToAnalyse/NRT_Neurons']);
if length(number)>1
    NRT_Neurons=PoolNeurons(S,number);
    clear SS
    SS{1}=NRT_Neurons;
    SS=tsdArray(SS);
    Qspk = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - time1')
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime2] = ImagePETH(Qspk, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - time2')
    figure, [fh, rasterAx, histAx, matVal_Spk_DeltaDetect] = ImagePETH(Qspk, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - DeltaDetect')
    
    save Spk_NRT_Delta -append matVal_Spk_TONEtime1 matVal_Spk_TONEtime2 matVal_Spk_DeltaDetect
end
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/SpikesToAnalyse/Bulb_MUA']);
if length(number)>1
    Bulb_MUA=PoolNeurons(S,number);
    clear SS
    SS{1}=Bulb_MUA;
    SS=tsdArray(SS);
    QMua = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime1] = ImagePETH(QMua, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('Bulb MUA - time1')
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime2] = ImagePETH(QMua, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('Bulb MUA - time2')
    figure, [fh, rasterAx, histAx, matVal_MUA_DeltaDetect] = ImagePETH(QMua, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('Bulb MUA - DeltaDetect')
    
    save Spk_Bulb_Delta matVal_MUA_TONEtime1 matVal_MUA_TONEtime2 matVal_MUA_DeltaDetect
end
%<><>

load([res,'/SpikesToAnalyse/Bulb_Neurons']);
if length(number)>1
    Bulb_Neurons=PoolNeurons(S,number);
    clear SS
    SS{1}=Bulb_Neurons;
    SS=tsdArray(SS);
    Qspk = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('Bulb spikes - time1')
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime2] = ImagePETH(Qspk, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('Bulb spikes - time2')
    figure, [fh, rasterAx, histAx, matVal_Spk_DeltaDetect] = ImagePETH(Qspk, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('Bulb spikes - DeltaDetect')
    
    save Spk_Bulb_Delta -append matVal_Spk_TONEtime1 matVal_Spk_TONEtime2 matVal_Spk_DeltaDetect
end
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/SpikesToAnalyse/dHPC_MUA']);
if length(number)>1
    dHPC_MUA=PoolNeurons(S,number);
    clear SS
    SS{1}=dHPC_MUA;
    SS=tsdArray(SS);
    QMua = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime1] = ImagePETH(QMua, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('dHPC MUA - time1')
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime2] = ImagePETH(QMua, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('dHPC MUA - time2')
    figure, [fh, rasterAx, histAx, matVal_MUA_DeltaDetect] = ImagePETH(QMua, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('dHPC MUA - DeltaDetect')
    
    save Spk_dHPC_Delta matVal_MUA_TONEtime1 matVal_MUA_TONEtime2 matVal_MUA_DeltaDetect
end
%<><>

load([res,'/SpikesToAnalyse/dHPC_Neurons']);
if length(number)>1
    dHPC_Neurons=PoolNeurons(S,number);
    clear SS
    SS{1}=dHPC_Neurons;
    SS=tsdArray(SS);
    Qspk = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - time1')
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime2] = ImagePETH(Qspk, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - time2')
    figure, [fh, rasterAx, histAx, matVal_Spk_DeltaDetect] = ImagePETH(Qspk, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - DeltaDetect')
    
    save Spk_dHPC_Delta -append matVal_Spk_TONEtime1 matVal_Spk_TONEtime2 matVal_Spk_DeltaDetect
end
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/SpikesToAnalyse/MoCx_MUA']);
if length(number)>1
    MoCx_MUA=PoolNeurons(S,number);
    clear SS
    SS{1}=MoCx_MUA;
    SS=tsdArray(SS);
    QMua = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime1] = ImagePETH(QMua, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('MoCx MUA - time1')
    figure, [fh, rasterAx, histAx, matVal_MUA_TONEtime2] = ImagePETH(QMua, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('MoCx MUA - time2')
    figure, [fh, rasterAx, histAx, matVal_MUA_DeltaDetect] = ImagePETH(QMua, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('MoCx MUA - DeltaDetect')
    
    save Spk_MoCx_Delta matVal_MUA_TONEtime1 matVal_MUA_TONEtime2 matVal_MUA_DeltaDetect
end
%<><>

load([res,'/SpikesToAnalyse/MoCx_Neurons']);
if length(number)>1
    MoCx_Neurons=PoolNeurons(S,number);
    clear SS
    SS{1}=MoCx_Neurons;
    SS=tsdArray(SS);
    Qspk = MakeQfromS(SS,200);
    
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(TONEtime1), -10000, +15000,'BinSize',500);
    hold on, title('MoCx spikes - time1')
    figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime2] = ImagePETH(Qspk, ts(TONEtime2), -10000, +15000,'BinSize',500);
    hold on, title('MoCx spikes - time2')
    figure, [fh, rasterAx, histAx, matVal_Spk_DeltaDetect] = ImagePETH(Qspk, ts(DeltaDetect), -10000, +15000,'BinSize',500);
    hold on, title('MoCx spikes - DeltaDetect')
    
    save Spk_MoCx_Delta -append matVal_Spk_TONEtime1 matVal_Spk_TONEtime2 matVal_Spk_DeltaDetect
end
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



