%DownStatesAnalysis
res=pwd;
load([res,'/LFPData/InfoLFP']);

load SpikeData;
load ToneEvent
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;

try load ToneEvent ToneSWS
catch
    disp(' ')
    toto=input('Single or Seq Tone ?   ');
    disp(' ')
    
    if strcmp('Single', toto)
        Tone=SingleTone;
    elseif strcmp('Seq', toto)
        Tone=SeqTone;
    end
    ToneEvent_BrainStates
end
%<><><><><><><><><><><><><><><><><><><><><><><><> Find  Channel to Analyse  <><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/ChannelsToAnalyse/Bulb_deep']);
Bulb_deep=channel;
load([res,'/ChannelsToAnalyse/Bulb_sup']);
Bulb_sup=channel;

load([res,'/ChannelsToAnalyse/MoCx_deep']);
MoCx_deep=channel;
load([res,'/ChannelsToAnalyse/MoCx_sup']);
MoCx_sup=channel;

load([res,'/ChannelsToAnalyse/PaCx_deep']);
PaCx_deep=channel;
load([res,'/ChannelsToAnalyse/PaCx_sup']);
PaCx_sup=channel;

load([res,'/ChannelsToAnalyse/PFCx_deep']);
PFCx_deep=channel;
load([res,'/ChannelsToAnalyse/PFCx_sup']);
PFCx_sup=channel;

load([res,'/ChannelsToAnalyse/dHPC_deep']);
dHPC_deep=channel;
load([res,'/ChannelsToAnalyse/dHPC_sup']);
dHPC_sup=channel;

load([res,'/ChannelsToAnalyse/NRT_deep']);
NRT_deep=channel;
load([res,'/ChannelsToAnalyse/NRT_sup']);
NRT_sup=channel;

%<><><><><><><><><><><><><><><><><><><><><><><><>  Find  Spike to Analyse  <><><><><><><><><><><><><><><><><><><><><><><><><>
PoolNeurons_AllStructures;
%<><><><><><><><><><><><><><><><><><><><><><><><>         MakeQfromS       <><><><><><><><><><><><><><><><><><><><><><><><><>
clear SS
SS{1}=PFCx_Spk;
SS=tsdArray(SS);
Qs = MakeQfromS(SS,200);

clear SS2
SS2{1}=NRT_Spk;
SS2=tsdArray(SS2);
Qs2 = MakeQfromS(SS2,200);

clear SS3
SS3{1}=dHPC_Spk;
SS3=tsdArray(SS3);
Qs3 = MakeQfromS(SS3,200);

clear SS4
SS4{1}=OBulb_Spk;
SS4=tsdArray(SS4);
Qs4 = MakeQfromS(SS4,200);



%<><><><><><><><><><><><><><><><><><><><><><><><>         ImagePETH > ToneSWS       <><><><><><><><><><><><><><><><><><>
try load matVal_ToneSWS
catch
figure, [fh, rasterAx, histAx, matVal_PFCx_ToneSWS] = ImagePETH(Qs, ts(ToneSWS), -10000, +20000,'BinSize',500); 
hold on, title('PFCx spikes')
figure, [fh, rasterAx, histAx, matVal_NRT_ToneSWS] = ImagePETH(Qs2, ts(ToneSWS), -10000, +20000,'BinSize',500);
hold on, title('NRT spikes')
figure, [fh, rasterAx, histAx, matVal_dHPC_ToneSWS] = ImagePETH(Qs3, ts(ToneSWS), -10000, +20000,'BinSize',500);
hold on, title('dHPC spikes')
figure, [fh, rasterAx, histAx, matVal_Bulb_ToneSWS] = ImagePETH(Qs4, ts(ToneSWS), -10000, +20000,'BinSize',500);
hold on, title('Bulb spikes')

save matVal_ToneSWS matVal_PFCx_ToneSWS matVal_NRT_ToneSWS matVal_dHPC_ToneSWS matVal_Bulb_ToneSWS
end
m=Data(matVal_PFCx_ToneSWS)';
m2=Data(matVal_NRT_ToneSWS)';
m3=Data(matVal_dHPC_ToneSWS)';
m4=Data(matVal_Bulb_ToneSWS)';
%<><><><><><><><><><><><><><><><><><><><><><><><>         ImagePETH > Delta          <><><><><><><><><><><><><><><><><><>
try load matVal_Delta
catch
    figure, [fh, rasterAx, histAx, matVal_PFCx_dMoCx] = ImagePETH(Qs, ts(Range(Dmot)), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - dMoCx')
    figure, [fh, rasterAx, histAx, matVal_PFCx_dPFCx] = ImagePETH(Qs, ts(Range(Dpfc)), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - dPFCx')
    figure, [fh, rasterAx, histAx, matVal_PFCx_dPaCx] = ImagePETH(Qs, ts(Range(Dpar)), -10000, +15000,'BinSize',500);
    hold on, title('PFCx spikes - dPaCx')
    figure, [fh, rasterAx, histAx, matVal_NRT_dMoCx] = ImagePETH(Qs2, ts(Range(Dmot)), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - dMoCx')
    figure, [fh, rasterAx, histAx, matVal_NRT_dPFCx] = ImagePETH(Qs2, ts(Range(Dpfc)), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - dPFCx')
    figure, [fh, rasterAx, histAx, matVal_NRT_dPaCx] = ImagePETH(Qs2, ts(Range(Dpar)), -10000, +15000,'BinSize',500);
    hold on, title('NRT spikes - dPaCx')
    figure, [fh, rasterAx, histAx, matVal_dHPC_dMoCx] = ImagePETH(Qs3, ts(Range(Dmot)), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - dMoCx')
    figure, [fh, rasterAx, histAx, matVal_dHPC_dPFCx] = ImagePETH(Qs3, ts(Range(Dpfc)), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - dPFCx')
    figure, [fh, rasterAx, histAx, matVal_dHPC_dPaCx] = ImagePETH(Qs3, ts(Range(Dpar)), -10000, +15000,'BinSize',500);
    hold on, title('dHPC spikes - dPaCx')
    figure, [fh, rasterAx, histAx, matVal_Bulb_dMoCx] = ImagePETH(Qs4, ts(Range(Dmot)), -10000, +15000,'BinSize',500);
    hold on, title('OBulb spikes - dMoCx')
    figure, [fh, rasterAx, histAx, matVal_Bulb_dPFCx] = ImagePETH(Qs4, ts(Range(Dpfc)), -10000, +15000,'BinSize',500);
    hold on, title('Obulb spikes - dPFCx')
    figure, [fh, rasterAx, histAx, matVal_Bulb_dPaCx] = ImagePETH(Qs4, ts(Range(Dpar)), -10000, +15000,'BinSize',500);
    hold on, title('OBulb spikes - dPaCx')
    
    save matVal_Delta matVal_PFCx_dMoCx matVal_PFCx_dPFCx matVal_PFCx_dMoCx
    save matVal_Delta -append matVal_NRT_dMoCx matVal_NRT_dPFCx matVal_NRT_dPaCx
    save matVal_Delta -append matVal_dHPC_dMoCx matVal_dHPC_dPFCx matVal_dHPC_dPaCx
    save matVal_Delta -append matVal_Bulb_dMoCx matVal_Bulb_dPFCx matVal_Bulb_dPaCx
end



%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(2,3,1), imagesc(m), axis xy, 
hold on, line([50 50],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('PFCx spikes')
hold on, subplot(2,3,2), imagesc(m2), axis xy,
hold on, line([50 50],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('NRT spikes')
hold on, subplot(2,3,3), imagesc(m3), axis xy, 
hold on, line([50 50],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('dHPC spikes')

hold on, subplot(2,3,4), plot(mean(m),'k'), hold on, plot(mean(m),'r'), yl=ylim;
hold on, line([50 50],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('PFCx spikes')
hold on, subplot(2,3,5), plot(mean(m2),'k'), hold on, plot(mean(m2),'r'), yl=ylim;
hold on, line([50 50],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('NRT spikes')
hold on, subplot(2,3,6), plot(mean(m3),'k'), hold on, plot(mean(m3),'r'), yl=ylim;
hold on, line([50 50],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('dHPC spikes')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
Fwindow=input('what windows for tone sorting ? (std=[52:60])    ');
[BE,id]=sort(mean(m(:,Fwindow),2));
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(2,3,1), imagesc(m(id,:)), axis xy, 
hold on, line([Fwindow(1) Fwindow(1)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, line([Fwindow(end) Fwindow(end)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('PFCx spikes')
hold on, subplot(2,3,2), imagesc(m2(id,:)), axis xy
hold on, line([Fwindow(1) Fwindow(1)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, line([Fwindow(end) Fwindow(end)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('NRT spikes')
hold on, subplot(2,3,3), imagesc(m3(id,:)), axis xy, 
hold on, line([Fwindow(1) Fwindow(1)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, line([Fwindow(end) Fwindow(end)],[0 max(size(m))],'linewidth',1,'color','w')
hold on, title('dHPC spikes')

hold on, subplot(2,3,4), plot(mean(m(id(1:50),:)),'k'), hold on, plot(mean(m(id(end-50:end),:)),'r'), yl=ylim;
hold on, line([Fwindow(1) Fwindow(1)],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('PFCx spikes')
hold on, subplot(2,3,5), plot(mean(m2(id(1:50),:)),'k'), hold on, plot(mean(m2(id(end-50:end),:)),'r'), yl=ylim;
hold on, line([Fwindow(1) Fwindow(1)],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('NRT spikes')
hold on, subplot(2,3,6), plot(mean(m3(id(1:50),:)),'k'), hold on, plot(mean(m3(id(end-50:end),:)),'r'), yl=ylim;
hold on, line([Fwindow(1) Fwindow(1)],[0 yl(2)],'linewidth',1,'color','b')
hold on, title('dHPC spikes')

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% analysis extrem value only : below 50%mean_SpkRate (id1) or above 150%mean_SpkRate
id1=find(BE<(mean(BE)/2));
id2=find(BE>(mean(BE)+(mean(BE)/2)));
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(PFCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_PFCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:50)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PFCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-50:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(PFCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_PFCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PFCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(NRT_deep)]);
figure, [fh, rasterAx, histAx, matVal1_NRT_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_NRT_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(NRT_sup)]);
figure, [fh, rasterAx, histAx, matVal1_NRT_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_NRT_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(Bulb_deep)]);
figure, [fh, rasterAx, histAx, matVal1_Bulb_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_Bulb_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(Bulb_sup)]);
figure, [fh, rasterAx, histAx, matVal1_Bulb_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_Bulb_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(dHPC_deep)]);
figure, [fh, rasterAx, histAx, matVal1_dHPC_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_dHPC_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(dHPC_sup)]);
figure, [fh, rasterAx, histAx, matVal1_dHPC_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_dHPC_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(MoCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_MoCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_MoCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(MoCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_MoCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_MoCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(PaCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_PaCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PaCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(PaCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_PaCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PaCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(2,6,1), plot(mean(Data(matVal1_PFCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_PFCx_sup)'),'r'), 
hold on, title('PFCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,7), plot(mean(Data(matVal2_PFCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_PFCx_sup)'),'r') 
hold on, title('PFCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

hold on, subplot(2,6,2), plot(mean(Data(matVal1_NRT_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_NRT_sup)'),'r'), 
hold on, title('NRT meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,8), plot(mean(Data(matVal2_NRT_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_NRT_sup)'),'r') 
hold on, title('NRT meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

hold on, subplot(2,6,3), plot(mean(Data(matVal1_Bulb_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_Bulb_sup)'),'r'), 
hold on, title('Bulb meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,9), plot(mean(Data(matVal2_Bulb_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_Bulb_sup)'),'r') 
hold on, title('Bulb meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

hold on, subplot(2,6,4), plot(mean(Data(matVal1_dHPC_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_dHPC_sup)'),'r'), 
hold on, title('dHPC meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,10), plot(mean(Data(matVal2_dHPC_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_dHPC_sup)'),'r') 
hold on, title('dHPC meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

hold on, subplot(2,6,5), plot(mean(Data(matVal1_MoCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_MoCx_sup)'),'r'), 
hold on, title('MoCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,11), plot(mean(Data(matVal2_MoCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_MoCx_sup)'),'r') 
hold on, title('MoCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

hold on, subplot(2,6,6), plot(mean(Data(matVal1_PaCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_PaCx_sup)'),'r'), 
hold on, title('PaCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,6,12), plot(mean(Data(matVal2_PaCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_PaCx_sup)'),'r') 
hold on, title('PaCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])




