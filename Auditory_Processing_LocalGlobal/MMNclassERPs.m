
load LocalGlobalTotalAssignment
res=pwd;
smo=0;
load([res,'/LFPData/InfoLFP']);

J1=-3500;
J2=+13000;
    
try
    load AlltoneAAAAxtoneBBBBx
catch
    AAAAx=[LocalStdGlobStdA;LocalStdGlobDvtA;LocalDvtGlobStdB;LocalDvtGlobDvtB;OmissionRareA];
    BBBBx=[LocalStdGlobStdB;LocalStdGlobDvtB;LocalDvtGlobStdA;LocalDvtGlobDvtA;OmissionRareB];
    save Alltone AAAAx BBBBx
end

for num=1:28;
    clear LFP
    clear i;
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    i=num+1;
    
    %figure, [fh, rasterAx, histAx, AllAAAAx(i)]=ImagePETH(LFP2, ts(sort([AAAAx])), J1, J2,'BinSize',800);title(['AAAAx-LFP',num2str(num),'AllEpoch',InfoLFP.structure(i)]);close
    figure, [fh, rasterAx, histAx, AllBBBBx(i)]=ImagePETH(LFP2, ts(sort([BBBBx])), J1, J2,'BinSize',800);title(['BBBBx-LFP',num2str(num),'AllEpoch',InfoLFP.structure(i)]);close
    save -append Alltone AllBBBBx
end


%-------------------------------
% enlever les valeurs aberrantes
%-------------------------------
lim=6000; % less noise on thalamus channels - for cortical lim=6500
NewAllBBBBx=[dataAllBBBBx(:,1:size(dataAllBBBBx,2)-1)];
NewAllBBBBx(NewAllBBBBx>lim)=nan;
NewAllBBBBx(NewAllBBBBx<-lim)=nan;
figure, imagesc(NewAllBBBBx)

%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
F1=[182:189];
F2=[220:255];
F3=[189:220];

for num=8;
    i=num+1;
    
    NewAllBBBBx=Data(AllBBBBx(i))';
    [idx,idy]=find(abs(NewAllBBBBx)>lim);
    NewAllBBBBx(unique(idx),:)=[];
    
    %[BE,id3]=sort((mean(NewAllBBBBx(:,F2)')+mean(NewAllBBBBx(:,F1)')-mean(NewAllBBBBx(:,F3)')));
    [BE,id3]=sort((mean(NewAllBBBBx(:,F2)')-mean(NewAllBBBBx(:,F1)')));
    
    figure, imagesc(NewAllBBBBx(id3,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
    hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
    hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
    hold on, plot([F2(1,1) F2(1,1)], [0 1680],'k','linewidth',1)
    hold on, plot([F2(1,length(F2)) F2(1,length(F2))], [0 1680],'k','linewidth',1)
       
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    figure,
    hold on, plot(mean(NewAllBBBBx(id3(1:200),:)),'r','linewidth',1)
    hold on, plot(mean(NewAllBBBBx(id3(200:1100),:)),'b','linewidth',1)
    hold on, plot(mean(NewAllBBBBx(id3(1200:1483),:)),'k','linewidth',1)
    hold on, title(['3 class of ERPs - ',InfoLFP.structure(i)])
    hold on, plot([150 150], [-2000 2000],'k','linewidth',1)

end

%---------------------------------------------------
% trier le LFP selon les classes de potentiel evoqué
%---------------------------------------------------

class=sort([BBBBx]);
classThal1=class(id3(1:600));
classThal1=sort(classThal1);
classThal2=class(id3(600:1000));
classThal2=sort(classThal2);
classThal3=class(id3(1200:1400));
classThal3=sort(classThal3);
classThal4=class(id3(1400:1680));
classThal4=sort(classThal4);

EpochThal1=intervalSet((classThal1-2E4),(classThal1+2E4));
EpochThal1=mergeCloseIntervals(EpochThal1,1E4);
EpochThal2=intervalSet((classThal2-2E4),(classThal2+2E4));
EpochThal2=mergeCloseIntervals(EpochThal2,1E4);
EpochThal3=intervalSet((classThal3-2E4),(classThal3+2E4));
EpochThal3=mergeCloseIntervals(EpochThal3,1E4);

clear LFP
load([res,'/LFPData/LFP',num2str(num)]);
LFP2=ResampleTSD(LFP,500);
figure, plot(Range(LFP2,'s'),Data(LFP2),'k'), title([num2str(i),'- LFP - ',InfoLFP.structure(i)])
hold on, plot(Range(Restrict(LFP2,EpochThal1),'s'),Data(Restrict(LFP2,EpochThal1)),'r')
hold on, plot(Range(Restrict(LFP2,EpochThal2),'s'),Data(Restrict(LFP2,EpochThal2)),'g')
hold on, plot(Range(Restrict(LFP2,EpochThal3),'s'),Data(Restrict(LFP2,EpochThal3)),'b')

%-----------------------------------------
% plotter les differents potentiels evoqué
%-----------------------------------------

figure, plot(mean(NewAllBBBBx(id3(1:600),:)),'r','linewidth',1)
hold on, plot(mean(NewAllBBBBx(id3(800:1300),:)),'g','linewidth',1)
hold on, plot(mean(NewAllBBBBx(id3(1301:1600),:)),'b','linewidth',1)
hold on, title([num2str(i),'-  ch LFP  - 3 class of ERPs - ',InfoLFP.structure(i)])

%----------------------------------------
% Histogram selon les classes d'ERPs
%----------------------------------------
figure, hist(mean(NewAllBBBBx(:,F1)')-mean(NewAllBBBBx(:,F2)'),100)
hold on, line([0 0],[0 60],'color','r','linewidth',2)

%----------------------------------------
% Power Spectrum selon les classes d'ERPs
%----------------------------------------
for num=1:2:15;
    i=num+1;
    
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    movingwin=[2,0.05];
    params.tapers= [1,2];
    [S,t,f]=mtspecgramc(Data(LFP2),movingwin,params);
    
    Stsd=tsd(t*1E4,S);
    
    figure, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal1)))),'r','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal2)))),'g','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal3)))),'b','linewidth',1.5)
    xlim([0 50])
    hold, title([num2str(i),'-  LOG  - 3 class of ERPs - ',InfoLFP.structure(i)])
    
    figure, plot(f,(mean(Data(Restrict(Stsd,EpochThal1)))),'r','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochThal2)))),'g','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochThal3)))),'b','linewidth',1.5)
    xlim([0 50])    
    hold, title([num2str(i),'-  LOG  - 3 class of ERPs - ',InfoLFP.structure(i)])
end



%---------------------------------------------------
% trier les Spikes selon les classes de potentiel evoqué
%---------------------------------------------------
J1=-2000;
J2=+6000;
    
class=sort([BBBBx]);
class1=class(id3(1:200));
class1=sort(class1);
class2=class(id3(200:1000));
class2=sort(class2);
class3=class(id3(1200:1583));
class3=sort(class3);

for i=1:length(S);
    
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(class1), J1, J2,'BinSize',50);      close
    sqBBBBxF1{i}=sq;
    swBBBBxF1{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(class2), J1, J2,'BinSize',50);      close
    sqBBBBxF2{i}=sq;
    swBBBBxF2{i}=sw;
    figure, [fh, sq, sw, rasterAx, histAx] = RasterPETH(S{i}, ts(class3), J1, J2,'BinSize',50);      close
    sqBBBBxF3{i}=sq;
    swBBBBxF3{i}=sw;    

        %<><><><><><><><><><><><><><><><><><><><><><>   window n°1   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        figure, 
        hold on, plot((Range(sqBBBBxF1{i}, 'ms')), SmoothDec((Data(sqBBBBxF1{i})/length(swBBBBxF1{i})),smo),'r','linewidth',1);title(['window n°1 - Neuron',num2str(i)])
        %<><><><><><><><><><><><><><><><><><><><><><>   window n°2   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, plot((Range(sqBBBBxF2{i}, 'ms')), SmoothDec((Data(sqBBBBxF2{i})/length(swBBBBxF2{i})),smo),'g','linewidth',1);title(['window n°2 - Neuron',num2str(i)])
        %<><><><><><><><><><><><><><><><><><><><><><>   window n°3   <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
        hold on, plot((Range(sqBBBBxF3{i}, 'ms')), SmoothDec((Data(sqBBBBxF3{i})/length(swBBBBxF3{i})),smo),'b','linewidth',1);title(['window n°3 - Neuron',num2str(i)])
        for a=0:150:150; hold on, plot(a,0:0.1:5,'b','linewidth',1); end
        xlim([-200 400])   
end

%---------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------
%--------------------------------------All Analysis-------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------

%---------------------------------------------------------------
% trier le LFP selon les classes de potentiel evoqué du Thalamus
%---------------------------------------------------------------
num=13;
i=num+1;

NewAllBBBBx=Data(AllBBBBx(i))';
[idx,idy]=find(abs(NewAllBBBBx)>lim);
NewAllBBBBx(unique(idx),:)=[];

[BE,idThal]=sort((mean(NewAllBBBBx(:,F2)')-mean(NewAllBBBBx(:,F1)')));

figure, imagesc(NewAllBBBBx(idThal,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F2(1,1) F2(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F2(1,length(F2)) F2(1,length(F2))], [0 1680],'k','linewidth',1)

%-----------------------------------------
% plotter les differents potentiels evoqué

class=sort([BBBBx]);
classThal1=class(idThal(1:600));
classThal1=sort(classThal1);
classThal2=class(idThal(600:1400));
classThal2=sort(classThal2);
classThal3=class(idThal(1400:1680));
classThal3=sort(classThal3);

figure,
hold on, plot(mean(NewAllBBBBx(idThal(1:600),:)),'r','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idThal(600:1000),:)),'g','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idThal(1400:1680),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - ',InfoLFP.structure(i)])
hold on, plot([150 150], [-2000 2000],'k','linewidth',1)

%-------------------------------------------------------------
% trier le LFP selon les classes de potentiel evoqué du Cx Au1 
%-------------------------------------------------------------
num=8;
i=num+1;

NewAllBBBBx=Data(AllBBBBx(i))';
[idx,idy]=find(abs(NewAllBBBBx)>lim);
NewAllBBBBx(unique(idx),:)=[];

[BE,idAu1]=sort((mean(NewAllBBBBx(:,F2)')-mean(NewAllBBBBx(:,F1)')));

figure, imagesc(NewAllBBBBx(idAu1,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F2(1,1) F2(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F2(1,length(F2)) F2(1,length(F2))], [0 1680],'k','linewidth',1)

%-----------------------------------------
% plotter les differents potentiels evoqué

classAu1=class(idAu1(1:200));
classAu1=sort(classAu1);
classAu2=class(idAu1(200:1200));
classAu2=sort(classAu2);
classAu3=class(idAu1(1300:1612));
classAu3=sort(classAu3);

figure,
hold on, plot(mean(NewAllBBBBx(idAu1(1:200),:)),'r','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idAu1(200:1200),:)),'g','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idAu1(1300:1612),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - ',InfoLFP.structure(i)])
hold on, plot([150 150], [-2000 2000],'k','linewidth',1)


%-------------------------------------------------------------------
% trier le LFP selon les classes de potentiel evoqué de l'hippocampe
%-------------------------------------------------------------------
num=1;
i=num+1;

NewAllBBBBx=Data(AllBBBBx(i))';
[idx,idy]=find(abs(NewAllBBBBx)>lim);
NewAllBBBBx(unique(idx),:)=[];

[BE,idHpc]=sort((mean(NewAllBBBBx(:,F2)')-mean(NewAllBBBBx(:,F1)')));

figure, imagesc(NewAllBBBBx(idHpc,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F2(1,1) F2(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F2(1,length(F2)) F2(1,length(F2))], [0 1680],'k','linewidth',1)

%-----------------------------------------
% plotter les differents potentiels evoqué

classHpc1=class(idHpc(1:80));
classHpc1=sort(classHpc1);
classHpc2=class(idHpc(200:1000));
classHpc2=sort(classHpc2);
classHpc3=class(idHpc(1350:1655));
classHpc3=sort(classHpc3);

figure,
hold on, plot(mean(NewAllBBBBx(idHpc(1:80),:)),'r','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idHpc(200:1000),:)),'g','linewidth',1)
hold on, plot(mean(NewAllBBBBx(idHpc(1350:1655),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - ',InfoLFP.structure(i)])
hold on, plot([150 150], [-2000 2000],'k','linewidth',1)

%------------------------------------------
% plotter les firing rate selon les classes
%------------------------------------------
smo=1;
for n=[1 9 12 14 15 21 27 29 13 26 30 33 36 37 47 38];
    figure, subplot(3,1,1)
    [C1,B1]=CrossCorr(classThal1,Range(S{n}),10,1400);
    hold on, plot(B1/1E3,SmoothDec(C1,smo),'r','linewidth',1);
    [C2,B2]=CrossCorr(classThal2,Range(S{n}),10,1400);
    hold on, plot(B2/1E3,SmoothDec(C2,smo),'g','linewidth',1);
    [C3,B3]=CrossCorr(classThal3,Range(S{n}),10,1400);
    hold on, plot(B3/1E3,SmoothDec(C3,smo),'b','linewidth',1);
    xlim([-1 6.5])
    title(['window n°1,2,3,4 with Thalamus - Neuron',num2str(n)])
    for a=0:1.5:6; hold on, plot(a,0:0.1:10,'k','linewidth',2); end
    
    hold on, subplot(3,1,2)
    [C1,B1]=CrossCorr(classAu1,Range(S{n}),10,1400);
    hold on, plot(B1/1E3,SmoothDec(C1,smo),'r','linewidth',1);
    [C2,B2]=CrossCorr(classAu2,Range(S{n}),10,1400);
    hold on, plot(B2/1E3,SmoothDec(C2,smo),'g','linewidth',1);
    [C3,B3]=CrossCorr(classAu3,Range(S{n}),10,1400);
    hold on, plot(B3/1E3,SmoothDec(C3,smo),'b','linewidth',1);
    xlim([-1 6.5])
    title(['window n°1,2,3,4 with CxAu1 - Neuron',num2str(n)])
    for a=0:1.5:6; hold on, plot(a,0:0.1:10,'k','linewidth',2); end
    
    hold on, subplot(3,1,3)
    [C1,B1]=CrossCorr(classHpc1,Range(S{n}),10,1400);
    hold on, plot(B1/1E3,SmoothDec(C1,smo),'r','linewidth',1);
    [C2,B2]=CrossCorr(classHpc2,Range(S{n}),10,1400);
    hold on, plot(B2/1E3,SmoothDec(C2,smo),'g','linewidth',1);
    [C3,B3]=CrossCorr(classHpc3,Range(S{n}),10,1400);
    hold on, plot(B3/1E3,SmoothDec(C3,smo),'b','linewidth',1);
    xlim([-1 6.5])
    title(['window n°1,2,3,4 with CxAu1 - Neuron',num2str(n)])
    for a=0:1.5:6; hold on, plot(a,0:0.1:10,'k','linewidth',2); end
end

%----------------------------------------
% Power Spectrum selon les classes d'ERPs
%----------------------------------------
EpochThal1=intervalSet((classThal1-2E4),(classThal1));
EpochThal1=mergeCloseIntervals(EpochThal1,1E4);
EpochThal2=intervalSet((classThal2-2E4),(classThal2));
EpochThal2=mergeCloseIntervals(EpochThal2,1E4);
EpochThal3=intervalSet((classThal3-2E4),(classThal3));
EpochThal3=mergeCloseIntervals(EpochThal3,1E4);

EpochAu1=intervalSet((classAu1-2E4),(classAu1));
EpochAu1=mergeCloseIntervals(EpochAu1,1E4);
EpochAu2=intervalSet((classAu2-2E4),(classAu2));
EpochAu2=mergeCloseIntervals(EpochAu2,1E4);
EpochAu3=intervalSet((classAu3-2E4),(classAu3));
EpochAu3=mergeCloseIntervals(EpochAu3,1E4);

EpochHpc1=intervalSet((classHpc1-2E4),(classHpc1));
EpochHpc1=mergeCloseIntervals(EpochHpc1,1E4);
EpochHpc2=intervalSet((classHpc2-2E4),(classHpc2));
EpochHpc2=mergeCloseIntervals(EpochHpc2,1E4);
EpochHpc3=intervalSet((classHpc3-2E4),(classHpc3));
EpochHpc3=mergeCloseIntervals(EpochHpc3,1E4);


for num=0:3:22;
    i=num+1;
    
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    
    movingwin=[2,0.05];
    params.tapers= [1,2];
    [S,t,f]=mtspecgramc(Data(LFP2),movingwin,params);
    
    Stsd=tsd(t*1E4,S);
    
    figure, subplot(3,1,1)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal1)))),'r','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal2)))),'g','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochThal3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'-  LOG  - based on Thalamus ERPs - ',InfoLFP.structure(i)])
    hold on, subplot(3,1,2)    
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochAu1)))),'r','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochAu2)))),'g','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochAu3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'-  LOG  - based on CxAu1 ERPs - ',InfoLFP.structure(i)])
    hold on, subplot(3,1,3)    
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochHpc1)))),'r','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochHpc2)))),'g','linewidth',1.5)
    hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,EpochHpc3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'-  LOG  - based on dHpc ERPs - ',InfoLFP.structure(i)])
    
    figure, subplot(3,1,1)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochThal1)))),'r','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochThal2)))),'g','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochThal3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'- Based on Thalamus ERPs - ',InfoLFP.structure(i)])
    hold on, subplot(3,1,2)    
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochAu1)))),'r','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochAu2)))),'g','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochAu3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'- Based on CxAu1 ERPs - ',InfoLFP.structure(i)])
    hold on, subplot(3,1,3)    
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochHpc1)))),'r','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochHpc2)))),'g','linewidth',1.5)
    hold on, plot(f,(mean(Data(Restrict(Stsd,EpochHpc3)))),'b','linewidth',1.5)
    xlim([0 20])
    hold, title([num2str(i),'- Based on dHpc ERPs - ',InfoLFP.structure(i)])
end

%-----------------------------------------
% plotter les differentes waveforms

EpochThal1=intervalSet((classThal1-2E4),(classThal1));
Wthal1=PlotWaveforms(W,29,EpochThal1);



num=1;
i=num+1;

% Local Standard Global Standard : LocalStdGlobStdB
NewLstdB=Data(MLstdB(i))';
[idx,idy]=find(abs(NewLstdB)>lim);
NewLstdB(unique(idx),:)=[];
[BE,idThalLStd]=sort((mean(NewLstdB(:,F3)')-mean(NewLstdB(:,F1)')));
figure, imagesc(NewLstdB(idThalLStd,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F3(1,1) F3(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F3(1,length(F3)) F3(1,length(F3))], [0 1680],'k','linewidth',1)

% Local Deviant Global Standard : LocalDvtGlobStdB
NewLdevB=Data(MLdevB(i))';
[idx,idy]=find(abs(NewLdevB)>lim);
NewLdevB(unique(idx),:)=[];
[BE,idThalLDvt]=sort((mean(NewLdevB(:,F3)')-mean(NewLdevB(:,F1)')));
figure, imagesc(NewLdevB(idThalLDvt,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F3(1,1) F3(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F3(1,length(F3)) F3(1,length(F3))], [0 1680],'k','linewidth',1)

% Local Deviant Global Deviant : LocalStdGlobDvtB
NewGdevB=Data(MGdevB(i))';
[idx,idy]=find(abs(NewGdevB)>lim);
NewGdevB(unique(idx),:)=[];
[BE,idThalGDvt]=sort((mean(NewGdevB(:,F3)')-mean(NewGdevB(:,F1)')));
figure, imagesc(NewGdevB(idThalGDvt,:)), hold on,  title(['Classed by mean diff. ERPs >F2-F1 ',InfoLFP.structure(i)])
hold on, plot([F1(1,1) F1(1,1)], [0 1680],'r','linewidth',1)
hold on, plot([F1(1,length(F1)) F1(1,length(F1))], [0 1680],'r','linewidth',1)
hold on, plot([F3(1,1) F3(1,1)], [0 1680],'k','linewidth',1)
hold on, plot([F3(1,length(F3)) F3(1,length(F3))], [0 1680],'k','linewidth',1)

%-------------------------------------------------------------
% comparaison des 3 classes pour chaque cas 
figure, subplot(3,1,1)
hold on, plot(mean(NewLstdB(idThalLStd(1:100),:)),'r','linewidth',1)
hold on, plot(mean(NewLstdB(idThalLStd(200:400),:)),'g','linewidth',1)
hold on, plot(mean(NewLstdB(idThalLStd(550:596),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - LocalStdGlobStdB ',InfoLFP.structure(i)])
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
hold on, subplot(3,1,2)
hold on, plot(mean(NewLdevB(idThalLDvt(1:100),:)),'r','linewidth',1)
hold on, plot(mean(NewLdevB(idThalLDvt(200:400),:)),'g','linewidth',1)
hold on, plot(mean(NewLdevB(idThalLDvt(550:596),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - LocalDvtGlobStdB ',InfoLFP.structure(i)])
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
hold on, subplot(3,1,3)
hold on, plot(mean(NewGdevB(idThalGDvt(1:30),:)),'r','linewidth',1)
hold on, plot(mean(NewGdevB(idThalGDvt(40:90),:)),'g','linewidth',1)
hold on, plot(mean(NewGdevB(idThalGDvt(100:141),:)),'b','linewidth',1)
hold on, title(['3 class of ERPs - LocalStdGlobDvtB ',InfoLFP.structure(i)])
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end

%-------------------------------------------------------------
% Effet deviant selon les 3 classes 

figure, subplot(3,1,1)
hold on, plot(mean(NewLstdB(idThalLStd(1:100),:)),'k','linewidth',1)
hold on, plot(mean(NewLdevB(idThalLDvt(1:100),:)),'r','linewidth',1)
hold on, plot(mean(NewLdevB(idThalGDvt(1:25),:)),'b','linewidth',1)
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
hold on, subplot(3,1,2)
hold on, plot(mean(NewLstdB(idThalLStd(200:400),:)),'k','linewidth',1)
hold on, plot(mean(NewLdevB(idThalLDvt(200:400),:)),'r','linewidth',1)
hold on, plot(mean(NewGdevB(idThalGDvt(40:90),:)),'b','linewidth',1)
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
hold on, subplot(3,1,3)
hold on, plot(mean(NewLstdB(idThalLStd(400:596),:)),'k','linewidth',1)
hold on, plot(mean(NewLdevB(idThalLDvt(400:596),:)),'r','linewidth',1)
hold on, plot(mean(NewGdevB(idThalGDvt(100:141),:)),'B','linewidth',1)
for a=100:75:400
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end
