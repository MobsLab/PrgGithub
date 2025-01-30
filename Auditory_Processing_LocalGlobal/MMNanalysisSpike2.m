
%MMNanalysisSpike

load SpikeData
load LocalGlobalTotalAssignment

J1=-2000;
J2=+13000;
smo=2;


%---------------------------------------------------------------------------
%<><><><><><><><><><><><><> Spike Bined Activity <><><><><><><><><><><><><>
%---------------------------------------------------------------------------

J1=-2000;
J2=+13000;

for i=1:length(S)
    A{i}=tsdarray(S{i});
end

try 
    load SpikePETH
catch
        for i=1:length(S);
            Qs = MakeQfromS(A{i},200);
            ratek=Qs;
            rate = Data(ratek);
            ratek = tsd(Range(ratek),rate(:,1));
            figure, [fh, rasterAx, histAx, matValLocStd(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), J1, J2,'BinSize',50);title(['Local Std Global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValLocDvt(i)] = ImagePETH(ratek, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), J1, J2,'BinSize',50);title(['Local Dvt global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValGlobDvt(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobDvtA;LocalStdGlobDvtB])), J1, J2,'BinSize',50);title(['Local Std Global Dvt - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiFreq(i)] = ImagePETH(ratek, ts(sort([OmiAAAA;OmiBBBB])), J1, J2,'BinSize',50);title(['Omission Frequent - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiRare(i)] = ImagePETH(ratek, ts(sort([OmissionRareA;OmissionRareB])), J1, J2,'BinSize',50);title(['Omission Rare - Neuron',num2str(i)])
            matValGlobStd(i)=matValLocStd(i);
        end
   save SpikePETH matValLocStd matValLocDvt matValGlobStd matValGlobDvt matValOmiFreq matValOmiRare
end

try 
    load SpikePETHtoneAvsB
catch
        for i=1:length(S);
            Qs = MakeQfromS(A{i},200);
            ratek=Qs;
            rate = Data(ratek);
            ratek = tsd(Range(ratek),rate(:,1));
            figure, [fh, rasterAx, histAx, matValLocStdA(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobStdA])), J1, J2,'BinSize',50);title(['Local Std Global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValLocDvtA(i)] = ImagePETH(ratek, ts(sort([LocalDvtGlobStdA])), J1, J2,'BinSize',50);title(['Local Dvt global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValGlobDvtA(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobDvtA])), J1, J2,'BinSize',50);title(['Local Std Global Dvt - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiFreqA(i)] = ImagePETH(ratek, ts(sort([OmiAAAA])), J1, J2,'BinSize',50);title(['Omission Frequent - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiRareA(i)] = ImagePETH(ratek, ts(sort([OmissionRareA])), J1, J2,'BinSize',50);title(['Omission Rare - Neuron',num2str(i)])
            matValGlobStdA(i)=matValLocStdA(i);
            figure, [fh, rasterAx, histAx, matValLocStdB(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobStdB])), J1, J2,'BinSize',50);title(['Local Std Global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValLocDvtB(i)] = ImagePETH(ratek, ts(sort([LocalDvtGlobStdB])), J1, J2,'BinSize',50);title(['Local Dvt global Std - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValGlobDvtB(i)] = ImagePETH(ratek, ts(sort([LocalStdGlobDvtB])), J1, J2,'BinSize',50);title(['Local Std Global Dvt - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiFreqB(i)] = ImagePETH(ratek, ts(sort([OmiBBBB])), J1, J2,'BinSize',50);title(['Omission Frequent - Neuron',num2str(i)])
            figure, [fh, rasterAx, histAx, matValOmiRareB(i)] = ImagePETH(ratek, ts(sort([OmissionRareB])), J1, J2,'BinSize',50);title(['Omission Rare - Neuron',num2str(i)])
            matValGlobStdB(i)=matValLocStdB(i);
        end
   save SpikePETHtoneAvsB matValLocStdA matValLocDvtA matValGlobStdA matValGlobDvtA matValOmiFreqA matValOmiRareA matValLocStdB matValLocDvtB matValGlobStdB matValGlobDvtB matValOmiFreqB matValOmiRareB
end

for i=25;
    ValLocStd=Data(matValLocStd(i))';
    reponseValLocStd=ValLocStd(:,1);
    figure, plot(reponseValLocStd)
    hold on, plot(sort(reponseValLocStd),'r','linewidth',3); title(['Local Std Global Std - Neuron',num2str(i)])

    ValLocStd=Data(matValLocStd(i))';
    reponseValLocStd=ValLocStd(:,12);
    figure, title(['Local Std(k) vs Local Dvt(r) - Neuron',num2str(i)])
    hold on, plot(sort(reponseValLocStd),'k','linewidth',2);

    
    ValLocDvt=Data(matValLocDvt(i))';
    reponseValLocDvt=ValLocDvt(:,12);
    hold on, plot(sort(reponseValLocDvt),'r','linewidth',2);
    
    ValGlobStd=Data(matValGlobStd(i))';
    reponseValGlobStd=ValGlobStd(:,12);
    figure, title(['Global Std(k) vs Global Dvt(r) - Neuron',num2str(i)])
    hold on, plot(sort(reponseValGlobStd),'k','linewidth',2);
    
    ValGlobDvt=Data(matValGlobDvt(i))';
    reponseValGlobDvt=ValGlobDvt(:,12);
    hold on, plot(sort(reponseValGlobDvt),'r','linewidth',2);
    
    ValOmiFreq=Data(matValOmiFreq(i))';
    reponseValOmiFreq=ValOmiFreq(:,12);
    figure, title(['OmiFreq(k) vs OmiRare(r) - Neuron',num2str(i)])
    hold on, plot(sort(reponseValOmiFreq),'k','linewidth',2)
    
    ValOmiRare=Data(matValOmiRare(i))';
    reponseValOmiRare=ValOmiRare(:,12);
    hold on, plot(sort(reponseValOmiRare),'r','linewidth',2);
end


LocalStdGlobStd=[LocalStdGlobStdA;LocalStdGlobStdB];
LocalDvtGlobStd=[LocalDvtGlobStdA;LocalDvtGlobStdB];
LocalStdGlobDvt=[LocalStdGlobDvtA;LocalStdGlobDvtB];
OmiFreq=[OmiAAAA;OmiBBBB];
OmiRare=[OmissionRareA;OmissionRareB];

clear HighSpkLocStd
HighSpkLocStd=[];
for a=1:624;
    if reponseValLocStd(a)>1;
        HighSpkLocStd(a)=LocalStdGlobStd(a);
    end
end
b=1;
while b<=length(HighSpkLocStd);
    if HighSpkLocStd(b)==0;
        HighSpkLocStd(b)=[];
    end
    b=b+1;
end
clear HighSpkLocDvt
HighSpkLocDvt=[];
for a=1:624;
    if reponseValLocDvt(a)>1;
        HighSpkLocDvt(a)=LocalDvtGlobStd(a);
    end
end
b=1;
while b<=length(HighSpkLocDvt);
    if HighSpkLocDvt(b)==0;
        HighSpkLocDvt(b)=[];
    end
    b=b+1;
end


%---------------------------------------------------------------------------
%<><><><><><><><><> LFP ERPs triggered by High Spiking activity <><><><><><>
%---------------------------------------------------------------------------

res=pwd;
smo=2;
load([res,'/LFPData/InfoLFP']);

J1=-2000;
J2=+13000;

for num=1:28;
    clear LFP
    clear i;
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    i=num+1;
        figure, [fh, rasterAx, histAx, MLstd1(i)]=ImagePETH(LFP2, ts(sort([HighSpkLocStd])), J1, J2,'BinSize',800);close
        figure, [fh, rasterAx, histAx, MLDvt1(i)]=ImagePETH(LFP2, ts(sort([HighSpkLocDvt])), J1, J2,'BinSize',800);close
end


%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------
for i=2:28;
    lim=5500;
    pval=0.05;

    temp1a=Data(MLstd1(i))';
    Msa=[temp1a(:,1:size(temp1a,2)-1)];
    Msa(Msa>lim)=nan;
    Msa(Msa<-lim)=nan;
    
    temp2a=Data(MLDvt1(i))';
    Msb=[temp2a(:,1:size(temp1a,2)-1)];
    Msb(Msb>lim)=nan;
    Msb(Msb<-lim)=nan;
    
    [Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
    [Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

    [h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
    rg=Range(MLDvt1(i),'ms');
    pr=rescale(p,450, 490);
        
    tps=Range(MLstd1(i),'ms');

    figure, plot(tps(1:end-1),SmoothDec((Ma),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'r','linewidth',2) 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    hold on, plot(rg(p<pval),pr(p<pval),'gx')
    title(['local effect, channel',num2str(num),InfoLFP.structure(i)])
    hold on, axis([-200 1300 -600 600])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
end



% for i=[11 25];
%     figure, imagesc(Data(matValLocStd(i))'),axis xy
%     figure, imagesc(Data(matValLocDvt(i))'),axis xy
%     figure, imagesc(Data(matValGlobStd(i))'),axis xy
%     figure, imagesc(Data(matValGlobDvt(i))'),axis xy
%     figure, imagesc(Data(matValOmiFreq(i))'),axis xy
%     figure, imagesc(Data(matValOmiRare(i))'),axis xy
% end