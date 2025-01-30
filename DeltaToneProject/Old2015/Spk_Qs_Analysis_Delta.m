res=pwd;
load SpikeData;
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;

disp(' ')
cellnames
disp(' ')

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
disp(' ')
PFCx_neurons=input('Which neurons from PFCx ? ');
PFCx_Spk=PoolNeurons(S,PFCx_neurons);
disp(' ')

disp(' ')
dHPC_neurons=input('Which neurons from dHPC ? ');
dHPC_Spk=PoolNeurons(S,dHPC_neurons);
disp(' ')

disp(' ')
NRT_neurons=input('Which neurons from NRT ? ');
NRT_Spk=PoolNeurons(S,NRT_neurons);
disp(' ')

disp(' ')
OBulb_neurons=input('Which neurons from OBulb ? ');
OBulb_Spk=PoolNeurons(S,OBulb_neurons);
disp(' ')

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
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

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, [fh, rasterAx, histAx, matVal_PFCx_dMoCx] = ImagePETH(Qs, ts(Range(Dmot)), -10000, +15000,'BinSize',500); 
hold on, title('PFCx spikes - dMoCx')
figure, [fh, rasterAx, histAx, matVal_PFCx_dPFCx] = ImagePETH(Qs, ts(Range(Dpfc)), -10000, +15000,'BinSize',500); 
hold on, title('PFCx spikes - dPFCx')
figure, [fh, rasterAx, histAx, matVal_PFCx_dMoCx] = ImagePETH(Qs, ts(Range(Dpar)), -10000, +15000,'BinSize',500); 
hold on, title('PFCx spikes - dPaCx')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, [fh, rasterAx, histAx, matVal_NRT_dMoCx] = ImagePETH(Qs2, ts(Range(Dmot)), -10000, +15000,'BinSize',500); 
hold on, title('NRT spikes - dMoCx')
figure, [fh, rasterAx, histAx, matVal_NRT_dPFCx] = ImagePETH(Qs2, ts(Range(Dpfc)), -10000, +15000,'BinSize',500); 
hold on, title('NRT spikes - dPFCx')
figure, [fh, rasterAx, histAx, matVal_NRT_dPaCx] = ImagePETH(Qs2, ts(Range(Dpar)), -10000, +15000,'BinSize',500); 
hold on, title('NRT spikes - dPaCx')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, [fh, rasterAx, histAx, matVal_dHPC_dMoCx] = ImagePETH(Qs3, ts(Range(Dmot)), -10000, +15000,'BinSize',500); 
hold on, title('dHPC spikes - dMoCx')
figure, [fh, rasterAx, histAx, matVal_dHPC_dPFCx] = ImagePETH(Qs3, ts(Range(Dpfc)), -10000, +15000,'BinSize',500); 
hold on, title('dHPC spikes - dPFCx')
figure, [fh, rasterAx, histAx, matVal_dHPC_dPaCx] = ImagePETH(Qs3, ts(Range(Dpar)), -10000, +15000,'BinSize',500); 
hold on, title('dHPC spikes - dPaCx')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
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

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
m_PF_dMo=Data(matVal_PFCx_dMoCx)';
m_PF_dPF=Data(matVal_PFCx_dPFCx)';
m_PF_dPa=Data(matVal_PFCx_dPaCx)';
m_NRT_dMo=Data(matVal_NRT_dMoCx)';
m_NRT_dPF=Data(matVal_NRT_dPFCx)';
m_NRT_dPa=Data(matVal_NRT_dPaCx)';
m_HPC_dMo=Data(matVal_dHPC_dMoCx)';
m_HPC_dPF=Data(matVal_dHPC_dPFCx)';
m_HPC_dPa=Data(matVal_dHPC_dPaCx)';
m_OB_dMo=Data(matVal_Bulb_dMoCx)';
m_OB_dPF=Data(matVal_Bulb_dPFCx)';
m_OBC_dPa=Data(matVal_Bulb_dPaCx)';
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, imagesc(m_PF_dPF)
hold on, title('PFCx spikes')
disp(' ')
Fwindow=input('what windows for tone sorting ? (std=[46:50])    ');
disp(' ')
[BE,id]=sort(mean(m_PF_dPF(:,Fwindow),2));
close all

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(1,4,1), imagesc(m_PF_dPF(id,:)), axis xy, 
hold on, title('PFCx spikes')
hold on, subplot(1,4,2), imagesc(m2(id,:)), axis xy
hold on, title('NRT spikes')
hold on, subplot(1,4,3), imagesc(m3(id,:)), axis xy, 
hold on, title('dHPC spikes')
hold on, subplot(1,4,4), imagesc(m4(id,:)), axis xy
hold on, title('Bulb spikes')

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(1,4,1), plot(mean(m(id(1:100),:)),'k'), hold on, plot(mean(m(id(end-100:end),:)),'r')
hold on, title('PFCx spikes')
hold on, subplot(1,4,2), plot(mean(m2(id(1:100),:)),'k'), hold on, plot(mean(m2(id(end-100:end),:)),'r')
hold on, title('NRT spikes')
hold on, subplot(1,4,3), plot(mean(m3(id(1:100),:)),'k'), hold on, plot(mean(m3(id(end-100:end),:)),'r')
hold on, title('dHPC spikes')
hold on, subplot(1,4,4), plot(mean(m4(id(1:100),:)),'k'), hold on, plot(mean(m4(id(end-100:end),:)),'r')
hold on, title('Bulb spikes')

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/InfoLFP']);

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

NRT_deep=10; %m244 -23022015
NRT_sup=11; %m244 -23022015
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(PFCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_PFCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PFCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(PFCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_PFCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PFCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_PFCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_PFCx_sup)'),'r'), 
hold on, title('PFCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_PFCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_PFCx_sup)'),'r') 
hold on, title('PFCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(NRT_deep)]);
figure, [fh, rasterAx, histAx, matVal1_NRT_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_NRT_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(NRT_sup)]);
figure, [fh, rasterAx, histAx, matVal1_NRT_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_NRT_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_NRT_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_NRT_sup)'),'r'), 
hold on, title('NRT meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_NRT_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_NRT_sup)'),'r') 
hold on, title('NRT meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(Bulb_deep)]);
figure, [fh, rasterAx, histAx, matVal1_Bulb_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_Bulb_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(Bulb_sup)]);
figure, [fh, rasterAx, histAx, matVal1_Bulb_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_Bulb_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_Bulb_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_Bulb_sup)'),'r'), 
hold on, title('Bulb meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_Bulb_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_Bulb_sup)'),'r') 
hold on, title('Bulb meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(dHPC_deep)]);
figure, [fh, rasterAx, histAx, matVal1_dHPC_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_dHPC_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(dHPC_sup)]);
figure, [fh, rasterAx, histAx, matVal1_dHPC_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_dHPC_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_dHPC_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_dHPC_sup)'),'r'), 
hold on, title('dHPC meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_dHPC_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_dHPC_sup)'),'r') 
hold on, title('dHPC meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(MoCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_MoCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_MoCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(MoCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_MoCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_MoCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_MoCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_MoCx_sup)'),'r'), 
hold on, title('MoCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_MoCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_MoCx_sup)'),'r') 
hold on, title('MoCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load([res,'/LFPData/LFP',num2str(PaCx_deep)]);
figure, [fh, rasterAx, histAx, matVal1_PaCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PaCx_deep] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close
load([res,'/LFPData/LFP',num2str(PaCx_sup)]);
figure, [fh, rasterAx, histAx, matVal1_PaCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(1:100)))), -10000, +15000,'BinSize',500);close
figure, [fh, rasterAx, histAx, matVal2_PaCx_sup] = ImagePETH(LFP, ts(sort(ToneSWS(id(end-100:end)))), -10000, +15000,'BinSize',500);close

figure, subplot(2,1,1), plot(mean(Data(matVal1_PaCx_deep)'),'k'), yl=ylim;
hold on, plot(mean(Data(matVal1_PaCx_sup)'),'r'), 
hold on, title('PaCx meanLFP (High PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])
hold on, subplot(2,1,2), plot(mean(Data(matVal2_PaCx_deep)'),'k'), 
hold on, plot(mean(Data(matVal2_PaCx_sup)'),'r') 
hold on, title('PaCx meanLFP (Low PFCx-DownStates Epoch)')
hold on, legend('deep','sup')
hold on, ylim([yl(1) yl(2)])


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
mkdir('DownStatesAnalysis')
cd([res,'/DownStatesAnalysis'])
res=pwd;

for i=1:8
    saveFigure(i,(['DownStatesAnalysis',num2str(i)]),res)
end









