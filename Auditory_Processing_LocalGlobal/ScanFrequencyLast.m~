load behavResources

%---------------------------------------
% Determination des temps de chaque sons
%---------------------------------------
try load ScanFrequency
catch
    
    Tone5000Hz=Event17(1:60,1)*1E4;
    Tone15000Hz=Event17(61:120,1)*1E4;
    Tone25000Hz=Event17(121:180,1)*1E4;
    Tone35000Hz=Event17(181:240,1)*1E4;
    
    Tone7500Hz=Event18(1:60,1)*1E4;
    Tone17500Hz=Event18(61:120,1)*1E4;
    Tone27500Hz=Event18(121:180,1)*1E4;
    Tone37500Hz=Event18(181:240,1)*1E4;
    
    Tone10000Hz=Event19(1:60,1)*1E4;
    Tone20000Hz=Event19(61:120,1)*1E4;
    Tone30000Hz=Event19(121:180,1)*1E4;
    Tone40000Hz=Event19(181:240,1)*1E4;
    
    Tone12500Hz=Event20(1:60,1)*1E4;
    Tone22500Hz=Event20(61:120,1)*1E4;
    Tone32500Hz=Event20(121:180,1)*1E4;
    Tone42500Hz=Event20(181:240,1)*1E4;    
    
    AllTone=[Tone5000Hz;Tone7500Hz;Tone10000Hz;Tone12500Hz;Tone15000Hz;Tone17500Hz;Tone20000Hz;Tone22500Hz;Tone25000Hz;Tone27500Hz;Tone30000Hz;Tone32500Hz;Tone35000Hz;Tone37500Hz;Tone40000Hz;Tone42500Hz];
    
    save ScanFrequency  AllTone Tone5000Hz Tone7500Hz Tone10000Hz Tone12500Hz Tone15000Hz Tone17500Hz Tone20000Hz Tone22500Hz Tone25000Hz Tone27500Hz Tone30000Hz Tone32500Hz Tone35000Hz Tone37500Hz Tone40000Hz Tone42500Hz
end

%---------------------------------------
%      ERPs for each tone frequency
%---------------------------------------
res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);

J1=-1500;
J2=+10000;

disp('----------------------------------------')
LFP_list=input('what are LFP numbers ? ')
disp('----------------------------------------')


for i=1:length(LFP_list)
    clear LFP
    load([res,'/LFPData/LFP',num2str(LFP_list(i))]);
    LFP2=ResampleTSD(LFP,500);
    j=LFP_list(i)+1;
    
    figure, [fh, rasterAx, histAx, LFPTone5000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone5000Hz])), J1, J2,'BinSize',800);  title(['Tone5000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone7500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone7500Hz])), J1, J2,'BinSize',800); title(['Tone7500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone1000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone10000Hz])), J1, J2,'BinSize',800);  title(['Tone1000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone12500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone12500Hz])), J1, J2,'BinSize',800);  title(['Tone12500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone15000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone15000Hz])), J1, J2,'BinSize',800);  title(['Tone15000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone17500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone17500Hz])), J1, J2,'BinSize',800);  title(['Tone17500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone20000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone20000Hz])), J1, J2,'BinSize',800);  title(['Tone20000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone22500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone22500Hz])), J1, J2,'BinSize',800);  title(['Tone22500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone25000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone25000Hz])), J1, J2,'BinSize',800);  title(['Tone25000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone27500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone27500Hz])), J1, J2,'BinSize',800);  title(['Tone27500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone30000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone30000Hz])), J1, J2,'BinSize',800);  title(['Tone30000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone32500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone32500Hz])), J1, J2,'BinSize',800);  title(['Tone32500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone35000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone35000Hz])), J1, J2,'BinSize',800);  title(['Tone35000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone37500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone37500Hz])), J1, J2,'BinSize',800);  title(['Tone37500Hz'])
    figure, [fh, rasterAx, histAx, LFPTone40000Hz(i)]=ImagePETH(LFP2, ts(sort([Tone40000Hz])), J1, J2,'BinSize',800);  title(['Tone40000Hz'])
    figure, [fh, rasterAx, histAx, LFPTone42500Hz(i)]=ImagePETH(LFP2, ts(sort([Tone42500Hz])), J1, J2,'BinSize',800);  title(['Tone42500Hz'])
end
    save ScanFrequency -append LFPTone5000Hz LFPTone7500Hz LFPTone10000Hz LFPTone12500Hz LFPTone15000Hz LFPTone17500Hz LFPTone20000Hz LFPTone22500Hz 
    save ScanFrequency -append LFPTone25000Hz LFPTone27500Hz LFPTone30000Hz LFPTone32500Hz LFPTone35000Hz LFPTone37500Hz LFPTone40000Hz LFPTone42500Hz


%-------------------------------
% enlever les valeurs aberrantes
%-------------------------------
lim=4000; % less noise on thalamus channels - for cortical lim=6500

%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
F1=[60:65];
F2=[65:80];

for i=1:11;
    num=i+1;
    
    nLFPTone25000Hz=Data(LFPTone25000Hz(i))';
    [idx,idy]=find(abs(nLFPTone25000Hz)>lim);
    nLFPTone25000Hz(unique(idx),:)=[];
    
    [BE,id3]=sort((mean(nLFPTone25000Hz(:,F2)')-mean(nLFPTone25000Hz(:,F1)')));
%     
%     figure, imagesc(nLFPTone25000Hz(id3,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(num)])
%     hold on, plot([F1(1,1) F1(1,1)], [0 60],'r','linewidth',1)
%     hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 60],'r','linewidth',1)
%     hold on, plot([F2(1,1) F2(1,1)], [0 60],'k','linewidth',1)
%     hold on, plot([F2(1,length(F2)) F2(1,length(F2))], [0 60],'k','linewidth',1)
       
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    figure,
    hold on, plot(mean(nLFPTone25000Hz(id3(1:length(nLFPTone25000Hz(:,1))/2),:)),'r','linewidth',1)
    hold on, plot(mean(nLFPTone25000Hz(id3(length(nLFPTone25000Hz(:,1))/2+1:length(nLFPTone25000Hz(:,1))),:)),'k','linewidth',1)
    hold on, title([num2str(i),'3 class of ERPs - ',InfoLFP.structure(num)])
    hold on, plot([150 150], [-2000 2000],'k','linewidth',1)
end





%---------------------------------------------------------------------------
%<><><><><><><><><><><><><> Spike Raster Activity <><><><><><><><><><><><><>
%---------------------------------------------------------------------------
J1=-1000;
J2=1000;
for i=1:length(S);
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([AllTone])), J1, J2,'BinSize',50);title(['Tone5000Hz - Neuron',num2str(i)])
    sqAllTone{i}=sq;
    swAllTone{i}=sw;
end

save ScanFrequency -append sqAllTone swAllTone


for i=1:length(S)
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone5000Hz])), J1, J2,'BinSize',50); close %title(['Tone5000Hz - Neuron',num2str(i)])
    sq5000Hz{i}=sq;
    sw5000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone7500Hz])), J1, J2,'BinSize',50);close %title(['Tone7500Hz - Neuron',num2str(i)])
    sq7500Hz{i}=sq;
    sw7500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone10000Hz])), J1, J2,'BinSize',50);close %title(['Tone10000Hz - Neuron',num2str(i)])
    sq10000Hz{i}=sq;
    sw10000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone12500Hz])), J1, J2,'BinSize',50);close %title(['Tone12500Hz - Neuron',num2str(i)])
    sq12500Hz{i}=sq;
    sw12500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone15000Hz])), J1, J2,'BinSize',50);close %title(['Tone15000Hz - Neuron',num2str(i)])
    sq15000Hz{i}=sq;
    sw15000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone17500Hz])), J1, J2,'BinSize',50);close %title(['Tone17500Hz - Neuron',num2str(i)])
    sq17500Hz{i}=sq;
    sw17500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone20000Hz])), J1, J2,'BinSize',50);close %title(['Tone20000Hz - Neuron',num2str(i)])
    sq20000Hz{i}=sq;
    sw20000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone22500Hz])), J1, J2,'BinSize',50);close %title(['Tone22500Hz - Neuron',num2str(i)])
    sq22500Hz{i}=sq;
    sw22500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone25000Hz])), J1, J2,'BinSize',50);close %title(['Tone25000Hz - Neuron',num2str(i)])
    sq25000Hz{i}=sq;
    sw25000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone27500Hz])), J1, J2,'BinSize',50);close %title(['Tone27500Hz - Neuron',num2str(i)])
    sq27500Hz{i}=sq;
    sw27500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone30000Hz])), J1, J2,'BinSize',50);close %title(['Tone30000Hz - Neuron',num2str(i)])
    sq30000Hz{i}=sq;
    sw30000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone32500Hz])), J1, J2,'BinSize',50);close %title(['Tone32500Hz - Neuron',num2str(i)])
    sq32500Hz{i}=sq;
    sw32500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone35000Hz])), J1, J2,'BinSize',50);close %title(['Tone35000Hz - Neuron',num2str(i)])
    sq35000Hz{i}=sq;
    sw35000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone37500Hz])), J1, J2,'BinSize',50);close %title(['Tone37500Hz - Neuron',num2str(i)])
    sq37500Hz{i}=sq;
    sw37500Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone40000Hz])), J1, J2,'BinSize',50);close %title(['Tone40000Hz - Neuron',num2str(i)])
    sq40000Hz{i}=sq;
    sw40000Hz{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(sort([Tone40000Hz])), J1, J2,'BinSize',50);close %title(['Tone42500Hz - Neuron',num2str(i)])
    sq42500Hz{i}=sq;
    sw42500Hz{i}=sw;
end

save ScanFrequency -append sq5000Hz sw5000Hz sq7500Hz sw7500Hz sq10000Hz sw10000Hz sq12500Hz sw12500Hz sq15000Hz sw15000Hz
save ScanFrequency -append sq17500Hz sw17500Hz sq20000Hz sw20000Hz sq22500Hz sw22500Hz sq25000Hz sw25000Hz sq27500Hz sw27500Hz  
save ScanFrequency -append sq30000Hz sw30000Hz sq32500Hz sw32500Hz sq35000Hz sw35000Hz sq37500Hz sw37500Hz sq40000Hz sw40000Hz sq42500Hz  sw42500Hz

smo=0.75;
for i=1:length(S);  
        %<><><><><><><><><><><><><><><><><><><><><><>   Low Frequencies   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        figure, subplot(5,1,1), 
        hold on, plot((Range(sq5000Hz{i}, 'ms')), SmoothDec((Data(sq5000Hz{i})/length(sw5000Hz{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sq7500Hz{i}, 'ms')), SmoothDec((Data(sq7500Hz{i})/length(sw7500Hz{i})),smo),'r','linewidth',2);
        hold on, plot((Range(sq10000Hz{i}, 'ms')), SmoothDec((Data(sq10000Hz{i})/length(sw10000Hz{i})),smo),'g','linewidth',2);
        hold on, plot((Range(sq12500Hz{i}, 'ms')), SmoothDec((Data(sq12500Hz{i})/length(sw12500Hz{i})),smo),'b','linewidth',2);
        title(['Low Frequencies (5kHz, 7.5kHz, 10kHz, 12.5kHz > Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        %<><><><><><><><><><><><><><><><><><><><><><>   Middle Frequencies   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(5,1,2), 
        hold on, plot((Range(sq15000Hz{i}, 'ms')), SmoothDec((Data(sq15000Hz{i})/length(sw15000Hz{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sq17500Hz{i}, 'ms')), SmoothDec((Data(sq17500Hz{i})/length(sw17500Hz{i})),smo),'r','linewidth',2);
        hold on, plot((Range(sq20000Hz{i}, 'ms')), SmoothDec((Data(sq20000Hz{i})/length(sw20000Hz{i})),smo),'g','linewidth',2);
        hold on, plot((Range(sq22500Hz{i}, 'ms')), SmoothDec((Data(sq22500Hz{i})/length(sw22500Hz{i})),smo),'b','linewidth',2);
        title(['Middle Frequencies (15kHz, 17.5kHz, 20kHz, 22.5kHz > Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        %<><><><><><><><><><><><><><><><><><><><><><>   High Frequencies   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(5,1,3), 
        hold on, plot((Range(sq25000Hz{i}, 'ms')), SmoothDec((Data(sq25000Hz{i})/length(sw25000Hz{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sq27500Hz{i}, 'ms')), SmoothDec((Data(sq27500Hz{i})/length(sw27500Hz{i})),smo),'r','linewidth',2);
        hold on, plot((Range(sq30000Hz{i}, 'ms')), SmoothDec((Data(sq30000Hz{i})/length(sw30000Hz{i})),smo),'g','linewidth',2);
        hold on, plot((Range(sq32500Hz{i}, 'ms')), SmoothDec((Data(sq32500Hz{i})/length(sw32500Hz{i})),smo),'b','linewidth',2);
        title(['HIgh Frequencies (25kHz, 27.5kHz, 30kHz, 32.5kHz > Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end      
        %<><><><><><><><><><><><><><><><><><><><><><>   High Frequencies   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(5,1,4), 
        hold on, plot((Range(sq35000Hz{i}, 'ms')), SmoothDec((Data(sq35000Hz{i})/length(sw35000Hz{i})),smo),'k','linewidth',2);
        hold on, plot((Range(sq37500Hz{i}, 'ms')), SmoothDec((Data(sq37500Hz{i})/length(sw37500Hz{i})),smo),'r','linewidth',2);
        hold on, plot((Range(sq40000Hz{i}, 'ms')), SmoothDec((Data(sq40000Hz{i})/length(sw40000Hz{i})),smo),'g','linewidth',2);
        hold on, plot((Range(sq42500Hz{i}, 'ms')), SmoothDec((Data(sq42500Hz{i})/length(sw42500Hz{i})),smo),'b','linewidth',2);
        title(['Very High Frequencies (35kHz, 37.5kHz, 40kHz, 42.5kHz > Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        %<><><><><><><><><><><><><><><><><><><><><><>   All Frequencies   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, subplot(5,1,5)
        hold on, plot((Range(sq35000Hz{i}, 'ms')), SmoothDec((Data(sq35000Hz{i})/length(sw35000Hz{i})),smo),'k','linewidth',2);
        title(['All Tone > Neuron',num2str(i)])
        for a=0:150:600; hold on, plot(a,0:0.1:5,'b','linewidth',1); end        
end


















